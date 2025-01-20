package test

import (
	"benchmark-helm/charts/zeebe-benchmark/test/golden"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
)

func TestGoldenCamundaPlatformServiceMonitorDefaults(t *testing.T) {
	// Test which allows to verify also parent chart templates
	// This makes sure that properties are correctly set
	// OR configurations have been changed

	chartPath, err := filepath.Abs("../")
	require.NoError(t, err)
	templateNames := []string{"core-service-monitor"}

	for _, name := range templateNames {
		suite.Run(t, &golden.TemplateGoldenTest{
			ChartPath:      chartPath,
			Release:        "benchmark-test",
			Namespace:      "benchmark-" + strings.ToLower(random.UniqueId()),
			GoldenFileName: "c8-" + name,
			Templates:      []string{"charts/camunda-platform/templates/service-monitor/" + name + ".yaml"},
			SetValues:      map[string]string{"camunda-platform.operate.enabled": "true"},
		})
	}
}

func TestGoldenCamundaPlatformCoreDefaults(t *testing.T) {
	// Test which allows to verify also parent chart templates
	// This makes sure that properties are correctly set
	// OR configurations have been changed

	chartPath, err := filepath.Abs("../")
	require.NoError(t, err)
	templateNames := []string{"service", "statefulset", "configmap"}

	for _, name := range templateNames {
		suite.Run(t, &golden.TemplateGoldenTest{
			ChartPath:      chartPath,
			Release:        "benchmark-test",
			Namespace:      "benchmark-" + strings.ToLower(random.UniqueId()),
			GoldenFileName: "c8-core-" + name,
			Templates:      []string{"charts/camunda-platform/templates/core/" + name + ".yaml"},
			SetValues:      map[string]string{"camunda-platform.operate.enabled": "true"},
		})
	}
}
