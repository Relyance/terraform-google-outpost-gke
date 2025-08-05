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
