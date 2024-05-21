## Linkerd crds
resource "helm_release" "linkerd_crds" {
  name = "linkerd-crds"
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-crds"
  version = "1.8.0"
  namespace = kubernetes_namespace.linkerd.id
  create_namespace = false  
}

## Linkerd cni
# resource "helm_release" "linkerd_cni" {
#   name = "linkerd-cni"
#   repository = "https://helm.linkerd.io/stable"
#   chart = "linkerd2-cni"
#   version = "30.12.2"
#   namespace = kubernetes_namespace.linkerd.id
#   create_namespace = false  
# }

## Cert data
data "kubernetes_secret" "linkerd_identity_issuer_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_identity_issuer_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [ time_sleep.wait_control_plane_certificate_provisioning ]
}

data "kubernetes_secret" "linkerd_policy_validator_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_policy_validator_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [ time_sleep.wait_webhook_certificate_provisioning ]
}

data "kubernetes_secret" "linkerd_proxy_injector_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_proxy_injector_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [ time_sleep.wait_webhook_certificate_provisioning ]
}

data "kubernetes_secret" "linkerd_sp_validator_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_sp_validator_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [ time_sleep.wait_webhook_certificate_provisioning ]
}

data "kubernetes_secret" "linkerd_viz_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_viz_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd_viz.id
  }

  depends_on = [ time_sleep.wait_viz_certificate_provisioning ]
}

data "kubernetes_secret" "linkerd_tap_injector_certificate" {
  metadata {
    name = kubernetes_manifest.linkerd_tap_injector_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd_viz.id
  }

  depends_on = [ time_sleep.wait_certificate_provisioning ]
}

## Linkerd Control Plane
resource "helm_release" "linkerd_control_plane" {
  name = "linkerd-control-plane"
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-control-plane"
  version = "1.16.11"
  namespace = kubernetes_namespace.linkerd.id
  create_namespace = false

  values = coalesce([
    file("${path.module}/charts/linkerd-control-plane/values.yml"),
    file("${path.module}/charts/linkerd-control-plane/values-ha.yml"),
  ])

  set {
    name = "cniEnabled"
    value = "true"
  }

  set {
    name  = "highAvailability"
    value = "true"
  }
  
  set_sensitive {
    name = "identityTrustAnchorsPEM"
    value = data.kubernetes_secret.linkerd_identity_issuer_certificate.data["ca.crt"]
  }

  set {
    name = "identity.issuer.scheme"
    value = "kubernetes.io/tls"
  }

  set {
    name = "proxyInjector.externalSecret"
    value = "true"
  }

  set {
    name = "profileValidator.externalSecret"
    value = "true"
  }
  
  set {
    name = "policyValidator.externalSecret"
    value = "true"
  }

  set_sensitive {
    name = "proxyInjector.caBundle"
    value = data.kubernetes_secret.linkerd_proxy_injector_certificate.data["ca.crt"]
  }

  set_sensitive {
    name = "profileValidator.caBundle"
    value = data.kubernetes_secret.linkerd_sp_validator_certificate.data["ca.crt"]
  } 

  set_sensitive {
    name = "policyValidator.caBundle"
    value = data.kubernetes_secret.linkerd_policy_validator_certificate.data["ca.crt"]
  }

  depends_on = [ 
    helm_release.linkerd_crds,
    data.kubernetes_secret.linkerd_identity_issuer_certificate,
    data.kubernetes_secret.linkerd_proxy_injector_certificate,
    data.kubernetes_secret.linkerd_sp_validator_certificate,
    data.kubernetes_secret.linkerd_policy_validator_certificate
  ]
}

## Linkerd Viz
resource "helm_release" "linkerd_viz" {
  name = "linkerd-viz"
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-viz"
  version = "30.12.11"
  namespace = kubernetes_namespace.linkerd_viz.id
  create_namespace = false  

  values = coalesce([
    file("${path.module}/charts/linkerd-viz/values.yml"),
    file("${path.module}/charts/linkerd-viz/values-ha.yml"),
  ])

  set {
    name = "tap.externalSecret"
    value = "true"
  }

  set {
    name = "tapInjector.externalSecret"
    value = "true"
  }

  set_sensitive {
    name = "tap.caBundle"
    value = data.kubernetes_secret.linkerd_viz_certificate.data["ca.crt"]
  }

  set_sensitive {
    name = "tapInjector.caBundle"
    value = data.kubernetes_secret.linkerd_tap_injector_certificate.data["ca.crt"]
  }

  depends_on = [ 
    data.kubernetes_secret.linkerd_viz_certificate,
    data.kubernetes_secret.linkerd_tap_injector_certificate,
    helm_release.linkerd_control_plane
  ]
}