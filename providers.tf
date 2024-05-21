terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.13.2"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.1"
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