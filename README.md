# terraform-kubernetes-linkerd2
A non-official Linkerd2 Terraform Module


# TODO
1. terraform-docs
2. automated lint
3. publish to tf registry
4. cni toggle
5. viz toggle
6. jaeger toggle
7. viz ingress toggle
8. modular self-sign tls commonname
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
| <a name="input_control_plane_helm_version"></a> [control\_plane\_helm\_version](#input\_control\_plane\_helm\_version) | Control plane helm version | `string` | `"1.16.11"` | no |
| <a name="input_control_plane_namespace"></a> [control\_plane\_namespace](#input\_control\_plane\_namespace) | Control plane namespace | `string` | `"linkerd"` | no |
| <a name="input_crds_helm_vesion"></a> [crds\_helm\_vesion](#input\_crds\_helm\_vesion) | Crds helm version | `string` | `"1.8.0"` | no |
| <a name="input_kubernetes"></a> [kubernetes](#input\_kubernetes) | Kubernetes connection configuration | <pre>object({<br>    host : string,<br>    cluster_ca_certificate : string,<br>    token : string,<br>  })</pre> | n/a | yes |
| <a name="input_linkerd_repository"></a> [linkerd\_repository](#input\_linkerd\_repository) | stable \| edge \| enterprise | `string` | `"stable"` | no |
| <a name="input_viz_ca_validity"></a> [viz\_ca\_validity](#input\_viz\_ca\_validity) | Viz Issuer CA validity in hours eg: 175200 for 20 years | `string` | `"175200"` | no |
| <a name="input_viz_cert_duration"></a> [viz\_cert\_duration](#input\_viz\_cert\_duration) | Viz TLS cert duration eg: 24h0m0s | `string` | `"48h0m0s"` | no |
| <a name="input_viz_cert_renew_before"></a> [viz\_cert\_renew\_before](#input\_viz\_cert\_renew\_before) | Viz TLS cert renew before eg: 1h0m0s | `string` | `"24h0m0s"` | no |
| <a name="input_viz_helm_version"></a> [viz\_helm\_version](#input\_viz\_helm\_version) | Viz helm version | `string` | `"30.12.11"` | no |
| <a name="input_viz_namespace"></a> [viz\_namespace](#input\_viz\_namespace) | Viz namespace | `string` | `"linkerd-viz"` | no |
| <a name="input_webhook_ca_validity"></a> [webhook\_ca\_validity](#input\_webhook\_ca\_validity) | Webhook Issuer CA validity in hours eg: 175200 for 20 years | `string` | `"175200"` | no |
| <a name="input_webhook_cert_duration"></a> [webhook\_cert\_duration](#input\_webhook\_cert\_duration) | Webhook TLS cert duration eg: 24h0m0s | `string` | `"48h0m0s"` | no |
| <a name="input_webhook_cert_renew_before"></a> [webhook\_cert\_renew\_before](#input\_webhook\_cert\_renew\_before) | Webhook TLS cert renew before eg: 1h0m0s | `string` | `"24h0m0s"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->