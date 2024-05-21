resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"
    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/is-control-plane" = "true"
      "linkerd.io/control-plane-ns" = "linkerd"
    } 

    annotations = {
      "linkerd.io/inject" = "disabled"
      "meta.helm.sh/release-name": "linkerd2"
      "meta.helm.sh/release-namespace": "linkerd"
    }
  }
}

resource "kubernetes_namespace" "linkerd_viz" {
  metadata {
    name = "linkerd-viz"
    labels = {
      "linkerd.io/extension" = "viz"
    } 
  }
}

resource "kubernetes_namespace" "linkerd_cni" {
  metadata {
    name = "linkerd-cni"
    labels = {
      "linkerd.io/extension" = "cni"
    } 
  }
}