The changelog is automatically generated using [git-chglog](https://github.com/git-chglog/git-chglog)
and it follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format.


<a name="zeebe-benchmark-0.3.9"></a>
## [zeebe-benchmark-0.3.9](https://github.com/camunda/camunda-platform-helm/compare/zeebe-benchmark-0.3.8...zeebe-benchmark-0.3.9) (2025-02-18)

### Feat

* enable flow control throttling in normal benchmarks.
* increase disk size for elastic search in normal benchmarks.
* fix golden files.
* fetch images from global.
* re-enable zeebe config, set global image.
* remap the values.yaml to fit the new chart.
* fetch a different image for starters and workers.
* add the option to fetch image form a different repo in starters and workers.
* append dependency to "0.0.0-8.7.0-alpha2"
* print active profiles
* increase resources of single core app
* switch to camunda "core" component, instead of individual zeebe, tasklist, operate component
* increase disk size to 64GB.
* increase ES memory for the benchmarks.

### Fix

* operate value set in golden tests is not supported
* increase throughput by decreasing payload
* reduce workload for regular benchmarks
* core values are expected as strings now
* set core image tag to snapshot
* disable operate and tasklist importers until they are compatible
* adjust archiver/retention config schema
* disable ES deprecation warnings
* remove broken profiling support
* fix file logging on non-root file system
* disable flow control to stabilize benchmarks
* archive faster than the rollover interval
* use non-deprecated config values
* remove unnecessary 'image-worker' deployment
* use new scrapping endpoint after project update
* point leader balancing job to the right service
* fix golden files.
* fix golden files.
* reduce rate of PI/s in starter for normal benchmarks.
* remove OPERATE_LOG env vars.
* fix golden tests.
* remove global values in values-realistic-benchmark.yaml
* fix the way we display active profiles.
* add env variables to realistic benchmark
* add operate stackdriver env variables to core app
* add operate resources to core app
* run operate and tasklist in realistic benchmark
* only print operate in notes if it's enabled
* fix maintainer name.
* fix tests to accommodate the changes in charts refactorings.
* replace release tag
* disable camunda platform correctly

### Refactor

* remove unneeded camunda-platform overrides from realistic workload
* remove unneeded identity value
* remove unneeded K8S env vars
* disable waiting for importers for now
* configure hourly retention policy
* remove unused, and rename appropriately golden files.

### Test

* update golden files
* update golden files
* update golden files
* update golden files
* regenerate golden files
* update golden files

### Pull Requests

* Merge pull request [#224](https://github.com/camunda/camunda-platform-helm/issues/224) from camunda/rl-reduce-starter-pis
* Merge pull request [#213](https://github.com/camunda/camunda-platform-helm/issues/213) from camunda/rl-increase-es-memory
* Merge pull request [#211](https://github.com/camunda/camunda-platform-helm/issues/211) from zeebe-io/release

