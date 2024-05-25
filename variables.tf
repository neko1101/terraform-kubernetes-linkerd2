variable "kubernetes" {
  description = "Kubernetes config"
  type        = map(string)
  default = {
    "config_path"    = "~/.kube/config"
    "config_context" = "my-context"
  }
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

variable "control_plane_ca_validity" {
  description = "Control plane Issuer CA validity in hours eg: 175200 for 20 years"
  type        = string
  default     = "175200"
}

variable "control_plane_cert_duration" {
  description = "Control plane TLS cert duration eg: 24h0m0s"
  type        = string
  default     = "72h0m0s"
}

variable "control_plane_cert_renew_before" {
  description = "Control plane TLS cert renew before eg: 1h0m0s"
  type        = string
  default     = "24h0m0s"
}

variable "control_plane_replica_count" {
  description = "Control plane replica count"
  type        = number
  default     = 1
}

variable "tap_replica_count" {
  description = "Tap replica count"
  type        = number
  default     = 1
}

variable "tap_injector_replica_count" {
  description = "Tap injector replica count"
  type        = number
  default     = 1
}

variable "dashboard_replica_count" {
  description = "Dashboard replica count"
  type        = number
  default     = 1
}

variable "metrics_replica_count" {
  description = "Metrics api replica count"
  type        = number
  default     = 1
}

variable "viz_enable_pod_anti_affinity" {
  description = "Viz enable podAntiAffinity"
  type        = bool
  default     = false
}

variable "viz_enable_pod_distruption_budget" {
  description = "Viz enable podDisruptionBudget"
  type        = bool
  default     = false
}

variable "control_plane_enable_pod_anti_affinity" {
  description = "Control plane enable podAntiAffinity"
  type        = bool
  default     = false
}

variable "control_plane_enable_pod_distruption_budget" {
  description = "Control plane enable podDisruptionBudget"
  type        = bool
  default     = false
}

variable "webhook_ca_validity" {
  description = "Webhook Issuer CA validity in hours eg: 175200 for 20 years"
  type        = string
  default     = "175200"
}

variable "webhook_cert_duration" {
  description = "Webhook TLS cert duration eg: 24h0m0s"
  type        = string
  default     = "48h0m0s"
}

variable "webhook_cert_renew_before" {
  description = "Webhook TLS cert renew before eg: 1h0m0s"
  type        = string
  default     = "24h0m0s"
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

variable "viz_enabled" {
  description = "Toggle Linkerd Viz deployment"
  type        = bool
  default     = true
}

variable "crds_helm_vesion" {
  description = "Crds helm version"
  type        = string
  default     = "1.8.0"
}