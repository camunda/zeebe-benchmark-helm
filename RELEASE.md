# Zeebe Benchmark Helm Chart Release Process

The charts are build, linted and tested on every push to the main branch. If the chart version
(in `Chart.yaml`) changes a new github release with the corresponding packaged helm chart is
created. The charts are hosted via github pages and use the release artifacts. We use the
[chart-releaser-action](https://github.com/helm/chart-releaser-action) to release the charts.

## Update Camunda Platform Helm chart

Before the release make sure that the Chart version, in the [Chart.yaml](./charts/zeebe-benchmark/Chart.yaml) is up-to-date.

This should be also done automatically via dependabot.

## Process

We are trying to automate as much as possible of the release process yet without sacrificing
transparency so we are using PR release flow with minimal manual interactions.

When it's time to release, just do the following steps.

Locally, run:

```
make release.chores
```

> [!Note]
>
> If you use podman, you will run into issues with this.
> As workaround you can install [git-chglog](https://github.com/git-chglog/git-chglog) and run `make release.chores chgLogCmd="git-chglog"`.

This action will:

- Locally pull latest updates to the `main` branch.
- Locally create a new branch called `release` from `main` branch.
- Bump chart version and make a commit.
- Generate release notes and make a commit.
- Push updated `release` branch to the repo.
- Generate a link to open a PR with prefilled title and template.

> [!Note]
>
> If you are using macOS or Windows, the `make release.chores` command might not work as expected.
> Instead, you can run the [Chart - Prepare Release](https://github.com/camunda/zeebe-benchmark-helm/actions/workflows/chart-prepare-release.yaml) workflow.
> The link to open the pull request will be shown in the workflow logs.

Next, all that you need to open the PR using the generated link and follow th checklist there.

> **Note**
>
> The release notes depend on git commit log, only the commits that follow
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format) will be added to
the release notes.
