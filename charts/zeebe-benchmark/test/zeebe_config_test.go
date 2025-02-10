package test

import (
	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"

	corev1 "k8s.io/api/core/v1"
)

type configMapTemplateTest struct {
	suite.Suite
	chartPath string
	release   string
	namespace string
	templates []string
}

func TestConfigMapTemplate(t *testing.T) {
	chartPath, err := filepath.Abs("../")
	require.NoError(t, err)

	suite.Run(t, &configMapTemplateTest{
		chartPath: chartPath,
		release:   "benchmark-test",
		namespace: "benchmark-" + strings.ToLower(random.UniqueId()),
		templates: []string{"templates/benchmark-config.yaml"},
	})
}

func (s *configMapTemplateTest) TestSetZeebeConfig() {
	// given
	options := &helm.Options{
		SetValues: map[string]string{
			"zeebe.config.zeebe.broker.cluster.replicationFactor": "3",
			"zeebe.config.zeebe.broker.threads.cpuThreadCount":    "2",
		},
		KubectlOptions: k8s.NewKubectlOptions("", "", s.namespace),
	}

	// when
	output := helm.RenderTemplate(s.T(), options, s.chartPath, s.release, s.templates)
	var configmap corev1.ConfigMap
	var zeebeConfig map[string]interface{}
	helm.UnmarshalK8SYaml(s.T(), output, &configmap)
	helm.UnmarshalK8SYaml(s.T(), configmap.Data["benchmark-config.yaml"], &zeebeConfig)

	brokerConfig := zeebeConfig["zeebe"].(map[string]interface{})["broker"]
	replicationFactor := brokerConfig.(map[string]interface{})["cluster"].(map[string]interface{})["replicationFactor"]
	threadCount := brokerConfig.(map[string]interface{})["threads"].(map[string]interface{})["cpuThreadCount"]

	// then
	s.Require().Equal(float64(3), replicationFactor)
	s.Require().Equal(float64(2), threadCount)
}
