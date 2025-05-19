The changelog is automatically generated using [git-chglog](https://github.com/git-chglog/git-chglog)
and it follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format.


<a name="zeebe-benchmark-0.3.14"></a>
## [zeebe-benchmark-0.3.14](https://github.com/camunda/camunda-platform-helm/compare/zeebe-benchmark-0.3.12...zeebe-benchmark-0.3.14) (2025-05-19)

### Feat

* increase load
* add NMT and enable camunda custom jfr metrics
* set operate shards and rolloverBatchSize.
* reduce the starter rate to 50.
* add description on how to run the benchmark against saas.

### Fix

* use right node pool
* set disruption budget
* set correct node selector
* set right storageClass
* set retention in camunda.database
* Fix golden files.
* address comments.

### Test

* update golden files
* update golden files
* regenerate golden files

### Pull Requests

* Merge pull request [#245](https://github.com/camunda/camunda-platform-helm/issues/245) from camunda/rl-change-benchmark-config
* Merge pull request [#242](https://github.com/camunda/camunda-platform-helm/issues/242) from camunda/release

