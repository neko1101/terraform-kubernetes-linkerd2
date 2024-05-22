variable "kubernetes" {
  type = object({
    host : string,
    cluster_ca_certificate : string,
    token : string,
  })
}

variable "linkerd_repository" {
  description = "stable | edge | enterprise"
  type        = string
  default     = "stable"
}

variable "control_plane_helm_version" {
  description = "Control plane helm version"
  type        = string
  default     = "1.16.10"
}

variable "control_plane_namespace" {
  description = "Control plane namespace"
  type        = string
  default     = "linkerd"
}

variable "viz_helm_version" {
  description = "Viz helm version"
  type        = string
  default     = "30.12.10"
}

variable "viz_namespace" {
  description = "Viz namespace"
  type        = string
  default     = "linkerd-viz"
}

variable "viz_ca_validity" {
  description = "Viz Issuer CA validity in hours eg: 175200 for 20 years"
  type        = string
  default     = "175200"
}

variable "viz_cert_duration" {
  description = "Viz TLS cert duration eg: 24h0m0s"
  type        = string
  default     = "48h0m0s"
}

variable "viz_cert_renew_before" {
  description = "Viz TLS cert renew before eg: 1h0m0s"
  type        = string
  default     = "24h0m0s"
}

variable "crds_helm_vesion" {
  description = "Crds helm version"
  type        = string
  default     = "1.8.0"
}