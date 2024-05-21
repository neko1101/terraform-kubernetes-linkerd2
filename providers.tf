terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.1"
    }
  }
}

provider "time" {}

provider "kubernetes" {
  host                   = var.kubernetes.host
  cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
  token                  = var.kubernetes.token
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes.host
    cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
    token                  = var.kubernetes.token
  }
}