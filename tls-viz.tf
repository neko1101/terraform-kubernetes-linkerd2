resource "tls_private_key" "linkerd_viz_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd_viz_root_ca" {
  private_key_pem       = tls_private_key.linkerd_viz_private_key.private_key_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 175200 # 20 years
  dns_names             = ["webhook.linkerd.cluster.local"]

  subject {
    common_name = "webhook.linkerd.cluster.local"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "kubernetes_secret" "linkerd_viz_root_ca" {
  metadata {
    name      = "webhook-issuer-tls"
    namespace = kubernetes_namespace.linkerd_viz.id
  }

  data = {
    "tls.crt" = tls_self_signed_cert.linkerd_viz_root_ca.cert_pem
    "tls.key" = tls_self_signed_cert.linkerd_viz_root_ca.private_key_pem
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_manifest" "linkerd_viz_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"
    "metadata" = {
      "name"      = "webhook-issuer"
      "namespace" = "${kubernetes_namespace.linkerd_viz.id}"
    }
    "spec" = {
      "ca" = {
        "secretName" : "${kubernetes_secret.linkerd_viz_root_ca.metadata[0].name}"
      }
    }
  }
}

resource "kubernetes_manifest" "linkerd_viz_certificate" {
  computed_fields = ["spec.duration", "spec.renewBefore", "spec.isCA"]

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "tap"
      "namespace" = "${kubernetes_namespace.linkerd_viz.id}"
    }
    "spec" = {
      "secretName"  = "tap-k8s-tls"
      "duration"    = "24h0m0s"
      "renewBefore" = "1h0m0s"
      "issuerRef" = {
        "name" = "webhook-issuer"
        "kind" = "Issuer"
      }
      "commonName" = "tap.linkerd-viz.svc"
      "dnsNames" = [
        "tap.linkerd-viz.svc"
      ]
      "isCA" = "false"
      "privateKey" = {
        "algorithm" = "ECDSA"
      }
      "usages" = [
        "server auth"
      ]
    }
  }

  depends_on = [kubernetes_manifest.linkerd_viz_issuer]
}

resource "kubernetes_manifest" "linkerd_tap_injector_certificate" {
  computed_fields = ["spec.duration", "spec.renewBefore", "spec.isCA"]

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "linkerd-tap-injector"
      "namespace" = "${kubernetes_namespace.linkerd_viz.id}"
    }
    "spec" = {
      "secretName"  = "tap-injector-k8s-tls"
      "duration"    = "24h0m0s"
      "renewBefore" = "1h0m0s"
      "issuerRef" = {
        "name" = "webhook-issuer"
        "kind" = "Issuer"
      }
      "commonName" = "tap-injector.linkerd-viz.svc"
      "dnsNames" = [
        "tap-injector.linkerd-viz.svc"
      ]
      "isCA" = "false"
      "privateKey" = {
        "algorithm" = "ECDSA"
      }
      "usages" = [
        "server auth"
      ]
    }
  }

  depends_on = [kubernetes_manifest.linkerd_viz_issuer]
}

resource "time_sleep" "wait_viz_certificate_provisioning" {
  depends_on = [
    kubernetes_manifest.linkerd_tap_injector_certificate,
    kubernetes_manifest.linkerd_viz_certificate
  ]

  create_duration = "60s"

  triggers = {
    always_run = "${timestamp()}"
  }
}