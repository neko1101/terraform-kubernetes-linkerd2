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
  default     = "1.16.11"
}
variable "control_plane_namespace" {
  description = "Control plane namespace"
  type        = string
  default     = "linkerd"
}

variable "viz_helm_version" {
  description = "Viz helm version"
  type        = string
  default     = "30.12.11"
}

variable "viz_namespace" {
  description = "Viz namespace"
  type        = string
  default     = "linkerd-viz"
}

variable "crds_helm_vesion" {
  description = "Crds helm version"
  type        = string
  default     = "1.8.0"
}