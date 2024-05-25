resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = var.control_plane_namespace
    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/is-control-plane"          = "true"
      "linkerd.io/control-plane-ns"          = "${var.control_plane_namespace}"
    }

    annotations = {
      "linkerd.io/inject" = "disabled"
      "meta.helm.sh/release-name" : "linkerd2"
      "meta.helm.sh/release-namespace" : "${var.control_plane_namespace}"
    }
  }
}

resource "kubernetes_namespace" "linkerd_viz" {
  count = var.viz_enabled == true ? 1 : 0

  metadata {
    name = var.viz_namespace
    labels = {
      "linkerd.io/extension" = "viz"
    }
  }
}