variable "name" {
  description = "Name of the existing GKE cluster"
  type        = string
}

variable "location" {
  description = "Location (region or zone) of the existing cluster"
  type        = string
}

variable "project" {
  description = "GCP project ID where the existing cluster lives"
  type        = string
}

variable "require_autopilot_cluster" {
  description = "Set false to allow existing GKE cluster that is not Autopilot"
  type        = bool
}
