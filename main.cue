package kube


import (
	monitoringv1 "github.com/coreos/prometheus-operator/pkg/apis/monitoring/v1"

)

// Validation Code
#PrometheusSpec: {
	monitoringv1.#PrometheusSpec
	ruleSelectorNilUsesHelmValues: bool | *false
	storageSpec:                   null | monitoringv1.#StorageSpec
}

#RouteConfig: {
	match: {[string]: string} | *_|_
	match_re: {[string]: string} | *_|_
	receiver: string
}

#ReceiverConfig: {
	name: string

	slack_configs: [...{
		channel:       string
		api_url:       string
		send_resolved: bool | *true
		title:         string | *titleText
		text:          string | *templateText
	}]
}

#AlertRoutingConfig: {
	group_by:        [...string] | *["job"]
	group_wait:      string | *"30s"
	group_interval:  string | *"5m"
	repeat_interval: string | *"12h"
	receiver:        string | *"null"
	routes: [...#RouteConfig]
}

#PrometheusOperatorValues: {
	commonLabels: [string]: string

	defaultRules: {
		rules: [string]:       bool
		labels: [string]:      string
		annotations: [string]: string
	}

	createCustomResource: bool

	alertmanager: {
		alertmanagerSpec: monitoringv1.#AlertmanagerSpec
		config: global: resolve_timeout: string | *"300s"
		config: route: #AlertRoutingConfig
		config: receivers: [...#ReceiverConfig]
	}

	prometheus: prometheusSpec: #PrometheusSpec

	prometheusOperator: {
		enabled:           bool | *true
		admissionWebhooks: _
	}

	grafana: enabled:               bool
	kubeApiServer: enabled:         bool
	kubeScheduler: enabled:         bool
	kubeControllerManager: enabled: bool
	kubeEtcd: enabled:              bool
	kubelet: serviceMonitor: https: bool

	kubeTargetVersionOverride: string | *"1.16.7"
}

#teamRoutes: [...#RouteConfig]
#teamReceivers: [...#ReceiverConfig]

titleText: """
[{{ .Status | toUpper }}{{ if eq .Status \"firing\" }}:{{ .Alerts.Firing | len }}{{ end }}] Monitoring Event Notification
"""

templateText: """
{{ range .Alerts }}
  *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`
  *Description:* {{ .Annotations.description }}
  *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:> *Runbook:* <{{ .Annotations.runbook }}|:spiral_note_pad:>
  *Details:*
  {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
  {{ end }}
{{ end }}
"""

helmRelease: "prometheus-operator": {
	metadata: namespace: "monitoring"

	spec: chart: {
		repository: "https://kubernetes-charts.storage.googleapis.com"
		version:    "8.14.0"
	}

	spec: values: #PrometheusOperatorValues & {
		commonLabels: prometheus: "default"

		createCustomResource: true

		defaultRules: {
			labels: alertmanager: "default"

			rules: {
				alertmanager:                true
				etcd:                        false
				general:                     true
				k8s:                         true
				kubeApiserver:               false
				kubePrometheusNodeAlerting:  true
				kubePrometheusNodeRecording: true
				kubeScheduler:               false
				kubernetesAbsent:            false
				kubernetesApps:              true
				kubernetesResources:         true
				kubernetesStorage:           true
				kubernetesSystem:            true
				node:                        true
				prometheusOperator:          true
				prometheus:                  true
			}
		}

		alertmanager: {
			alertmanagerSpec: {
				logFormat:   "logfmt"
				externalUrl: "https://alertmanager.foo.com"
			}

			config: {
				global: resolve_timeout: "5m"

				route: {
					group_by: ["job"]
					group_wait:      "30s"
					group_interval:  "5m"
					repeat_interval: "12h"

					routes: #teamRoutes + [{
						match: alertname: "Watchdog"
						receiver: "null"
					}]
				}

				receivers: #teamReceivers + [
						{
						name: "null"
					},
				]
			}
		}

		prometheus: prometheusSpec: {
			externalUrl: "https://prometheus.foo.com"
			serviceMonitorSelector: matchLabels: prometheus: "default"

			replicas: 1
			externalLabels: {
			}

			storageSpec: volumeClaimTemplate: spec: {
				accessModes: ["ReadWriteOnce"]
				resources: requests: storage: "60Gi"
			}

			thanos: {
				version: "v0.12.2"
				objectStorageConfig: {
					name: "metrics-storage"
					key:  "object-store.yaml"
				}
			}
		}

		prometheusOperator: {
			enabled: true
			admissionWebhooks: enabled: true
		}
		grafana: enabled:               false
		kubeApiServer: enabled:         false
		kubeScheduler: enabled:         false
		kubeControllerManager: enabled: false
		kubeEtcd: enabled:              false
		kubelet: serviceMonitor: https: true
	}
}
