module example.com/foo

go 1.14

require (
	cuelang.org/go v0.2.0 // indirect
	github.com/Venafi/vcert v0.0.0-20200310111556-eba67a23943f // indirect
	github.com/banzaicloud/thanos-operator/pkg/sdk v0.0.4 // indirect
	github.com/blang/semver v3.5.1+incompatible // indirect
	github.com/brancz/gojsontoyaml v0.0.0-20191212081931-bf2969bbd742 // indirect
	github.com/brancz/kube-rbac-proxy v0.5.0 // indirect
	github.com/coreos/prometheus-operator v0.39.0 // indirect
	github.com/google/gofuzz v1.1.0 // indirect
	github.com/jetstack/cert-manager v0.15.1 // indirect
	github.com/jsonnet-bundler/jsonnet-bundler v0.3.1 // indirect
	github.com/mitchellh/hashstructure v0.0.0-20170609045927-2bca23e0e452 // indirect
	github.com/onsi/ginkgo v1.11.0 // indirect
	github.com/onsi/gomega v1.8.1 // indirect
	github.com/openshift/prom-label-proxy v0.1.1-0.20191016113035-b8153a7f39f1 // indirect
	github.com/prometheus/client_model v0.2.0 // indirect
	github.com/thanos-io/thanos v0.11.0 // indirect
	golang.org/x/crypto v0.0.0-20200220183623-bac4c82f6975 // indirect
	k8s.io/api v0.18.8 // indirect
	k8s.io/apimachinery v0.18.2 // indirect
	k8s.io/code-generator v0.18.2 // indirect
	k8s.io/kube-openapi v0.0.0-20200121204235-bf4fb3bd569c // indirect
	k8s.io/utils v0.0.0-20200324210504-a9aa75ae1b89 // indirect
	sigs.k8s.io/apiserver-network-proxy/konnectivity-client v0.0.7 // indirect
	sigs.k8s.io/structured-merge-diff/v3 v3.0.0 // indirect
	sigs.k8s.io/yaml v1.2.0 // indirect
)

replace (
	k8s.io/api => k8s.io/api v0.16.5
	k8s.io/apimachinery => k8s.io/apimachinery v0.16.5
	k8s.io/client-go => k8s.io/client-go v0.16.5
	k8s.io/code-generator => k8s.io/code-generator v0.16.5
)
