# Terraform Kubernetes Linkerd2
An unofficial Linkerd2 Terraform Module for Kubernetes Cluster

# Dependency
  - Cert manager must be enabled in your cluster.

# How to use?
1. Setup module.
```
module "linkerd2" {
  source  = "neko1101/linkerd2/kubernetes"
  version = "1.0.0"
}
```
2. Apply
```
terraform init
terraform plan
terraform deploy
```

# Highlights
  - Automated cert creation and signing.
  - Automated TLS rotation by Cert Manager.
  - Long-lived CA by default (20 Years).
  - Modular Kubernetes related configurations.
  - Modular Helm artifact version.
  - Saves time.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.13.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.30.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.13.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.30.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.11.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.linkerd_control_plane](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.linkerd_crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.linkerd_viz](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.linkerd_identity_issuer_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_policy_validator_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_proxy_injector_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_root_ca_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_sp_validator_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_tap_injector_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_viz_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_viz_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.linkerd_webhook_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.linkerd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.linkerd_viz](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.linkerd_root_ca](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.linkerd_viz_root_ca](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.linkerd_webhook_root_ca](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [time_sleep.wait_control_plane_certificate_provisioning](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_viz_certificate_provisioning](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_webhook_certificate_provisioning](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.linkerd_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.linkerd_viz_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.linkerd_webhook_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.linkerd_root_ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [tls_self_signed_cert.linkerd_viz_root_ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [tls_self_signed_cert.linkerd_webhook_root_ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [kubernetes_secret.linkerd_identity_issuer_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.linkerd_policy_validator_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.linkerd_proxy_injector_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.linkerd_sp_validator_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.linkerd_tap_injector_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.linkerd_viz_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_control_plane_ca_validity"></a> [control\_plane\_ca\_validity](#input\_control\_plane\_ca\_validity) | Control plane Issuer CA validity in hours eg: 175200 for 20 years | `string` | `"175200"` | no |
| <a name="input_control_plane_cert_duration"></a> [control\_plane\_cert\_duration](#input\_control\_plane\_cert\_duration) | Control plane TLS cert duration eg: 24h0m0s | `string` | `"72h0m0s"` | no |
| <a name="input_control_plane_cert_renew_before"></a> [control\_plane\_cert\_renew\_before](#input\_control\_plane\_cert\_renew\_before) | Control plane TLS cert renew before eg: 1h0m0s | `string` | `"24h0m0s"` | no |
| <a name="input_control_plane_enable_pod_anti_affinity"></a> [control\_plane\_enable\_pod\_anti\_affinity](#input\_control\_plane\_enable\_pod\_anti\_affinity) | Control plane enable podAntiAffinity | `bool` | `false` | no |
| <a name="input_control_plane_enable_pod_distruption_budget"></a> [control\_plane\_enable\_pod\_distruption\_budget](#input\_control\_plane\_enable\_pod\_distruption\_budget) | Control plane enable podDisruptionBudget | `bool` | `false` | no |
| <a name="input_control_plane_helm_version"></a> [control\_plane\_helm\_version](#input\_control\_plane\_helm\_version) | Control plane helm version | `string` | `"1.16.10"` | no |
| <a name="input_control_plane_namespace"></a> [control\_plane\_namespace](#input\_control\_plane\_namespace) | Control plane namespace | `string` | `"linkerd"` | no |
| <a name="input_control_plane_replica_count"></a> [control\_plane\_replica\_count](#input\_control\_plane\_replica\_count) | Control plane replica count | `number` | `1` | no |
| <a name="input_crds_helm_vesion"></a> [crds\_helm\_vesion](#input\_crds\_helm\_vesion) | Crds helm version | `string` | `"1.8.0"` | no |
| <a name="input_dashboard_replica_count"></a> [dashboard\_replica\_count](#input\_dashboard\_replica\_count) | Dashboard replica count | `number` | `1` | no |
| <a name="input_kubernetes"></a> [kubernetes](#input\_kubernetes) | Kubernetes config | `map(string)` | <pre>{<br>  "config_context": "my-context",<br>  "config_path": "~/.kube/config"<br>}</pre> | no |
| <a name="input_linkerd_repository"></a> [linkerd\_repository](#input\_linkerd\_repository) | stable \| edge \| enterprise | `string` | `"stable"` | no |
| <a name="input_metrics_replica_count"></a> [metrics\_replica\_count](#input\_metrics\_replica\_count) | Metrics api replica count | `number` | `1` | no |
| <a name="input_tap_injector_replica_count"></a> [tap\_injector\_replica\_count](#input\_tap\_injector\_replica\_count) | Tap injector replica count | `number` | `1` | no |
| <a name="input_tap_replica_count"></a> [tap\_replica\_count](#input\_tap\_replica\_count) | Tap replica count | `number` | `1` | no |
| <a name="input_viz_ca_validity"></a> [viz\_ca\_validity](#input\_viz\_ca\_validity) | Viz Issuer CA validity in hours eg: 175200 for 20 years | `string` | `"175200"` | no |
| <a name="input_viz_cert_duration"></a> [viz\_cert\_duration](#input\_viz\_cert\_duration) | Viz TLS cert duration eg: 24h0m0s | `string` | `"48h0m0s"` | no |
| <a name="input_viz_cert_renew_before"></a> [viz\_cert\_renew\_before](#input\_viz\_cert\_renew\_before) | Viz TLS cert renew before eg: 1h0m0s | `string` | `"24h0m0s"` | no |
| <a name="input_viz_enable_pod_anti_affinity"></a> [viz\_enable\_pod\_anti\_affinity](#input\_viz\_enable\_pod\_anti\_affinity) | Viz enable podAntiAffinity | `bool` | `false` | no |
| <a name="input_viz_enable_pod_distruption_budget"></a> [viz\_enable\_pod\_distruption\_budget](#input\_viz\_enable\_pod\_distruption\_budget) | Viz enable podDisruptionBudget | `bool` | `false` | no |
| <a name="input_viz_helm_version"></a> [viz\_helm\_version](#input\_viz\_helm\_version) | Viz helm version | `string` | `"30.12.10"` | no |
| <a name="input_viz_namespace"></a> [viz\_namespace](#input\_viz\_namespace) | Viz namespace | `string` | `"linkerd-viz"` | no |
| <a name="input_webhook_ca_validity"></a> [webhook\_ca\_validity](#input\_webhook\_ca\_validity) | Webhook Issuer CA validity in hours eg: 175200 for 20 years | `string` | `"175200"` | no |
| <a name="input_webhook_cert_duration"></a> [webhook\_cert\_duration](#input\_webhook\_cert\_duration) | Webhook TLS cert duration eg: 24h0m0s | `string` | `"48h0m0s"` | no |
| <a name="input_webhook_cert_renew_before"></a> [webhook\_cert\_renew\_before](#input\_webhook\_cert\_renew\_before) | Webhook TLS cert renew before eg: 1h0m0s | `string` | `"24h0m0s"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->