resource "tls_private_key" "linkerd_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd_root_ca" {
  private_key_pem       = tls_private_key.linkerd_private_key.private_key_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 175200 # 20 years
  dns_names             = ["root.linkerd.cluster.local"]

  subject {
    common_name = "root.linkerd.cluster.local"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "kubernetes_secret" "linkerd_root_ca" {
  metadata {
    name      = "linkerd-trust-anchor"
    namespace = kubernetes_namespace.linkerd.id
  }

  data = {
    "tls.crt" = tls_self_signed_cert.linkerd_root_ca.cert_pem
    "tls.key" = tls_self_signed_cert.linkerd_root_ca.private_key_pem
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_manifest" "linkerd_root_ca_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"
    "metadata" = {
      "name"      = "linkerd-trust-anchor"
      "namespace" = "${kubernetes_namespace.linkerd.id}"
    }
    "spec" = {
      "ca" = {
        "secretName" : "${kubernetes_secret.linkerd_root_ca.metadata[0].name}"
      }
    }
  }
}

resource "kubernetes_manifest" "linkerd_identity_issuer_certificate" {
  computed_fields = ["spec.duration", "spec.renewBefore", "spec.isCA"]

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "linkerd-identity-issuer"
      "namespace" = "${kubernetes_namespace.linkerd.id}"
    }
    "spec" = {
      "secretName"  = "linkerd-identity-issuer"
      "duration"    = "48h0m0s"
      "renewBefore" = "6h0m0s"
      "issuerRef" = {
        "name" = "linkerd-trust-anchor"
        "kind" = "Issuer"
      }
      "commonName" = "identity.linkerd.cluster.local"
      "dnsNames" = [
        "identity.linkerd.cluster.local"
      ]
      "isCA" = "true"
      "privateKey" = {
        "algorithm" = "ECDSA"
      }
      "usages" = [
        "cert sign",
        "crl sign",
        "server auth",
        "client auth"
      ]
    }
  }

  depends_on = [kubernetes_manifest.linkerd_root_ca_issuer]
}

resource "time_sleep" "wait_control_plane_certificate_provisioning" {
  depends_on = [
    kubernetes_manifest.linkerd_identity_issuer_certificate,
  ]

  create_duration = "60s"

  triggers = {
    always_run = "${timestamp()}"
  }
}