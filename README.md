# Zeebe Benchmark Helm 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Test - Unit](https://github.com/camunda/zeebe-benchmark-helm/actions/workflows/build.yaml/badge.svg)](https://github.com/camunda/zeebe-benchmark-helm/actions/workflows/build.yaml)

- [Overview](#overview)
- [Installation](#installation)
- [Contributing](#contributing)
- [Versioning](#versioning)
- [Releasing](#releasing)
- [License](#license)

## Overview

Zeebe benchmark Helm charts repo. The Zeebe Benchmark Helm chart is an chart which allows the Zeebe Team
to run perfromance and stability tests also called benchmarks against Zeebe. 

It makes use of the public available [Camunda Platform 8 Helm chart](https://github.com/camunda/zeebe-benchmark-helm/actions/workflows/build.yaml), and adds addition features to it.

## Installation

Find out more details about different installation and deployment options
on the [Zeebe Benchmark Helm chart README](./charts/zeebe-benchmark/README.md).

## Contributing

We value all feedback and contributions. To start contributing to this project, please:

- **Don't create a PR without opening [an issue](https://github.com/camunda/zeebe-benchmark-helm/issues/new/choose)
  and/or discussing it first.**
- Familiarize yourself with the
  [contribution guide](./CONTRIBUTING.md).
- Find more information about configuring and deploying the Zeebe Benchmark
  [Helm chart](./charts/zeebe-benchmark/README.md).

## Versioning

Right now is the versioning not aligned with the general [Camunda Platform 8](https://github.com/camunda/camunda-platform).
Since it is mostly for internal use we will not release a 1.x version soon.

## Releasing

Please visit the [Zeebe Benchmark release guide](./RELEASE.md) to find out how to release the charts.

## License

Zeebe Benchmark Helm charts are licensed under the open-source Apache License 2.0.
Please see [LICENSE](LICENSE) for details.

For Camunda Platform 8 components, please visit
[licensing information page](https://docs.camunda.io/docs/reference/licenses).
