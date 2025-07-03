# Copied from https://github.com/camunda/camunda-platform-helm

# Makefile for managing the Helm charts

chartPath=charts/zeebe-benchmark
chartVersion=$(shell grep -Po '(?<=^version: ).+' $(chartPath)/Chart.yaml)
releaseName=zeebe-benchmark-test
gitChglog=quay.io/git-chglog/git-chglog:0.15.1
goBin=go
#########################################################
######### Go.
#########################################################

#
# Tests.

# go.test: runs the tests without updating the golden files (runs checks against golden files)
.PHONY: go.test
go.test: helm.dependency-update
	$(goBin) test ./...

# go.test-golden-updated: runs the tests with updating the golden files
.PHONY: go.test-golden-updated
go.test-golden-updated: helm.dependency-update
	$(goBin) test ./... -args -update-golden

# go.test-it: runs the integration tests against the current kube context
.PHONY: go.test-it
go.test-it: helm.dependency-update
	$(goBin) test -p 1 -timeout 1h -tags integration ./.../integration $(value GO_TEST_IT_ARGS)

# go.it-os: runs a subset of the integration tests against the current Openshift cluster
.PHONY: go.test-it-os
go.test-it-os: helm.dependency-update
	$(goBin) test -p 1 -timeout 1h -tags integration,openshift ./.../integration $(value GO_TEST_IT_OS_ARGS)

# go.fmt: runs the gofmt in order to format all $(goBin) files
.PHONY: go.fmt
go.fmt:
	$(goBin) fmt ./...
	@diff=$$(git status --porcelain | grep -F ".go" || true)
	@if [ -n "$${diff}" ]; then\
		echo "Some files are not following the $(goBin) format ($${diff}), run gofmt and fix your files.";\
		exit 1;\
	fi

#
# Helpers.

# go.addlicense-install: installs the addlicense tool
.PHONY: go.addlicense-install
go.addlicense-install:
	$(goBin) install github.com/google/addlicense@v1.0.0

# go.addlicense-run: adds license headers to $(goBin) files
.PHONY: go.addlicense-run
go.addlicense-run:
	addlicense -c 'Camunda Services GmbH' -l apache charts/zeebe-benchmark/test/**/*.go

# go.addlicense-check: checks that the $(goBin) files contain license header
.PHONY: go.addlicense-check
go.addlicense-check:
	addlicense -check -l apache charts/zeebe-benchmark/test/**/*.go

#########################################################
######### Tools
#########################################################

# Add asdf plugins.
.tools.asdf-plugins-add:
	@# Add plugins from .tool-versions file within the repo.
	@# If the plugin is already installed asdf exits with 2, so grep is used to handle that.
	@for plugin in $$(awk '{print $$1}' .tool-versions); do \
		echo "$${plugin}"; \
		asdf plugin add $${plugin} 2>&1 | (grep "already added" && exit 0); \
	done

# Install tools via asdf.
tools.asdf-install: .tools.asdf-plugins-add
	asdf install

# This target will be mainly used in the CI to update the images tag from camunda-platform repo
.PHONY: tools.update-values-file-image-tag
tools.update-values-file-image-tag:
	@bash scripts/update-values-file-image-tag.sh

.PHONY: tools.zbctl-topology
tools.zbctl-topology:
	kubectl exec svc/$(releaseName)-zeebe-gateway -- zbctl --insecure status

#########################################################
######### HELM
#########################################################

# helm.repos-add: add Helm repos needed by the charts
.PHONY: helm.repos-add
helm.repos-add:
	helm repo add zeebe https://helm.camunda.io
	helm repo add prometheus https://prometheus-community.github.io/helm-charts
	helm repo update

# helm.dependency-update: update and downloads the dependencies for the Helm chart
.PHONY: helm.dependency-update
helm.dependency-update:
	helm dependency update $(chartPath)

# helm.install: install the local chart into the current kubernetes cluster/namespace
.PHONY: helm.install
helm.install: helm.dependency-update
	helm install $(releaseName) $(chartPath) --render-subchart-notes

# helm.uninstall: uninstall the chart and removes all related pvc's
.PHONY: helm.uninstall
helm.uninstall:
	-helm uninstall $(releaseName)
	-kubectl delete pvc -l app.kubernetes.io/instance=$(releaseName)
	-kubectl delete pvc -l release=$(releaseName)

# helm.clean: cleans the resources deployed by the previous chart
.PHONY: helm.clean
helm.clean:
	-kubectl delete pvc -l app.kubernetes.io/name=elasticsearch
	-kubectl delete pvc -l app=camunda-platform

# helm.dry-run: run an install dry-run with the local chart
.PHONY: helm.dry-run
helm.dry-run: helm.dependency-update
	helm install $(releaseName) $(chartPath) --dry-run --render-subchart-notes

# helm.template: show all rendered templates for the local chart
.PHONY: helm.template
helm.template: helm.dependency-update
	helm template $(releaseName) $(chartPath) --render-subchart-notes

#########################################################
######### Release
#########################################################

.PHONY: .release.bump-chart-version
.release.bump-chart-version:
	@bash scripts/bump-chart-version.sh

.PHONY: release.bump-chart-version-and-commit
release.bump-chart-version-and-commit: .release.bump-chart-version
	git add $(chartPath);\
	git commit -m "chore: bump benchmark chart version to $(chartVersion)"

.PHONY: .release.generate-notes
.release.generate-notes:
ifdef chgLogCmd
	bash scripts/generate-release-notes.sh;
else
	docker run --rm -w /data -v `pwd`:/data --entrypoint sh $(gitChglog) \
		-c "apk add bash grep yq; bash scripts/generate-release-notes.sh"
endif

.PHONY: release.generate-notes-and-commit
release.generate-notes-and-commit: .release.generate-notes
	git add $(chartPath);\
	git commit -m "chore: add release notes for benchmark $(chartVersion)"

.PHONY: release.generate-pr-url
release.generate-pr-url:
	@echo "\n\n###################################\n"
	@echo "Open the release PR using this URL:"
	@echo "https://github.com/camunda/zeebe-benchmark-helm/compare/release?expand=1&template=release_template.md&title=Release%20Zeebe%20Benchmark%20Helm%20Chart%20v$(chartVersion)"
	@if [ "$$CI" != "true" ]; then \
	  xdg-open "https://github.com/camunda/zeebe-benchmark-helm/compare/release?expand=1&template=release_template.md&title=Release%20Zeebe%20Benchmark%20Helm%20Chart%20v$(chartVersion)"; \
	fi
	@echo "\n###################################\n\n"

.PHONY: release.chores
release.chores:
	git checkout main
	git pull --tags
	git switch -C release
	@$(MAKE) release.bump-chart-version-and-commit
	@$(MAKE) release.generate-notes-and-commit
	git push -fu origin release
	@$(MAKE) release.generate-pr-url
	git checkout main
