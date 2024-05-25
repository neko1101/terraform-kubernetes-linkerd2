## Linkerd crds
resource "helm_release" "linkerd_crds" {
  name             = "linkerd-crds"
  repository       = local.linkerd_repository[var.linkerd_repository]
  chart            = "linkerd-crds"
  version          = var.crds_helm_vesion
  namespace        = kubernetes_namespace.linkerd.id
  create_namespace = false
}

## Cert data
data "kubernetes_secret" "linkerd_identity_issuer_certificate" {
  metadata {
    name      = kubernetes_manifest.linkerd_identity_issuer_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [time_sleep.wait_control_plane_certificate_provisioning]
}

data "kubernetes_secret" "linkerd_policy_validator_certificate" {
  metadata {
    name      = kubernetes_manifest.linkerd_policy_validator_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [time_sleep.wait_webhook_certificate_provisioning]
}

data "kubernetes_secret" "linkerd_proxy_injector_certificate" {
  metadata {
    name      = kubernetes_manifest.linkerd_proxy_injector_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [time_sleep.wait_webhook_certificate_provisioning]
}

data "kubernetes_secret" "linkerd_sp_validator_certificate" {
  metadata {
    name      = kubernetes_manifest.linkerd_sp_validator_certificate.manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd.id
  }

  depends_on = [time_sleep.wait_webhook_certificate_provisioning]
}

data "kubernetes_secret" "linkerd_viz_certificate" {
  count = var.viz_enabled == true ? 1 : 0

  metadata {
    name      = kubernetes_manifest.linkerd_viz_certificate[0].manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd_viz[0].id
  }

  depends_on = [time_sleep.wait_viz_certificate_provisioning]
}

data "kubernetes_secret" "linkerd_tap_injector_certificate" {
  count = var.viz_enabled == true ? 1 : 0

  metadata {
    name      = kubernetes_manifest.linkerd_tap_injector_certificate[0].manifest.spec.secretName
    namespace = kubernetes_namespace.linkerd_viz[0].id
  }

  depends_on = [time_sleep.wait_viz_certificate_provisioning]
}

## Linkerd Control Plane
resource "helm_release" "linkerd_control_plane" {
  name             = "linkerd-control-plane"
  repository       = local.linkerd_repository[var.linkerd_repository]
  chart            = "linkerd-control-plane"
  version          = var.control_plane_helm_version
  namespace        = kubernetes_namespace.linkerd.id
  create_namespace = false

  values = coalesce([
    file("${path.module}/charts/linkerd-control-plane/values.yaml"),
    file("${path.module}/charts/linkerd-control-plane/values-ha.yaml"),
  ])

  set {
    name  = "cniEnabled"
    value = "false"
  }

  set {
    name  = "highAvailability"
    value = "true"
  }

  set {
    name  = "controllerReplicas"
    value = var.control_plane_replica_count
  }

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = data.kubernetes_secret.linkerd_identity_issuer_certificate.data["ca.crt"]
  }

  set {
    name  = "identity.issuer.scheme"
    value = "kubernetes.io/tls"
  }

  set {
    name  = "proxyInjector.externalSecret"
    value = "true"
  }

  set {
    name  = "profileValidator.externalSecret"
    value = "true"
  }

  set {
    name  = "policyValidator.externalSecret"
    value = "true"
  }

  set_sensitive {
    name  = "proxyInjector.caBundle"
    value = data.kubernetes_secret.linkerd_proxy_injector_certificate.data["ca.crt"]
  }

  set_sensitive {
    name  = "profileValidator.caBundle"
    value = data.kubernetes_secret.linkerd_sp_validator_certificate.data["ca.crt"]
  }

  set {
    name  = "enablePodAntiAffinity"
    value = var.control_plane_enable_pod_anti_affinity
  }

  set {
    name  = "enablePodDisruptionBudget"
    value = var.control_plane_enable_pod_distruption_budget
  }

  set_sensitive {
    name  = "policyValidator.caBundle"
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
  count = var.viz_enabled == true ? 1 : 0

  name             = "linkerd-viz"
  repository       = local.linkerd_repository[var.linkerd_repository]
  chart            = "linkerd-viz"
  version          = var.viz_helm_version
  namespace        = kubernetes_namespace.linkerd_viz[0].id
  create_namespace = false

  values = coalesce([
    file("${path.module}/charts/linkerd-viz/values.yaml"),
    file("${path.module}/charts/linkerd-viz/values-ha.yaml"),
  ])

  set {
    name  = "tap.externalSecret"
    value = "true"
  }

  set {
    name  = "tap.replicas"
    value = var.tap_replica_count
  }

  set {
    name  = "tapInjector.externalSecret"
    value = "true"
  }

  set {
    name  = "tapInjector.replicas"
    value = var.tap_replica_count
  }

  set_sensitive {
    name  = "tap.caBundle"
    value = data.kubernetes_secret.linkerd_viz_certificate[0].data["ca.crt"]
  }

  set_sensitive {
    name  = "tapInjector.caBundle"
    value = data.kubernetes_secret.linkerd_tap_injector_certificate[0].data["ca.crt"]
  }

  set {
    name  = "dashboard.replicas"
    value = var.dashboard_replica_count
  }

  set {
    name  = "metricsAPI.replicas"
    value = var.metrics_replica_count
  }

  set {
    name  = "enablePodAntiAffinity"
    value = var.viz_enable_pod_anti_affinity
  }

  set {
    name  = "enablePodDisruptionBudget"
    value = var.viz_enable_pod_distruption_budget
  }

  depends_on = [
    data.kubernetes_secret.linkerd_viz_certificate,
    data.kubernetes_secret.linkerd_tap_injector_certificate,
    helm_release.linkerd_control_plane
  ]
}