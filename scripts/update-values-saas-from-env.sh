#!/bin/bash

# load environment variables from console first
# source console.env | scripts/update-values-saas-from-env.sh

# yq preserving hack
# preserve lines as much as possible
# hack the javaOpts line otherwise yq executes the "Replace newlines with spaces" directive
yq_p() {
    cat "$2" | sed "s/javaOpts: >-/javaOpts: |-/" | yq "$1" | sed "s/javaOpts: |-/javaOpts: >-/" | diff -wbBZ "$2" - | patch "$2" -
}

CHART_PATH="charts/zeebe-benchmark/values.yaml"

yq_p  '.saas.enabled = true' "$CHART_PATH"
yq_p  '.saas.credentials.clientId = env(CAMUNDA_CLIENT_ID)' "$CHART_PATH"
yq_p  '.saas.credentials.clientSecret = env(CAMUNDA_CLIENT_SECRET)' "$CHART_PATH"
yq_p  '.saas.credentials.zeebeAddress = env(ZEEBE_ADDRESS)' "$CHART_PATH"
yq_p  '.saas.credentials.authServer = env(CAMUNDA_OAUTH_URL)' "$CHART_PATH"
