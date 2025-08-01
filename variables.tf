variable "base_name" {
  description = "base name for all resources"
  type        = string
  default     = "relyance-inhost"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.base_name))
    error_message = "base_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_id" {
  description = "The GCP project where the resources will be created"
  type        = string
}

variable "create_vpc_and_gke" {
  description = "If false, assumes external VPC and GKE exist and skips their creation"
  type        = bool
  default     = true
}

# Networking
variable "region" {
  description = "GCP region in which all resources will be created"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the VPC subnet in the selected region"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.subnet_cidr))
    error_message = "subnet_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}

variable "pods_cidr" {
  description = "CIDR block used for GKE Pod IPs (IP aliasing)"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.pods_cidr))
    error_message = "pods_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}

variable "services_cidr" {
  description = "CIDR block used for GKE Services (ClusterIP ranges)"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.services_cidr))
    error_message = "services_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}
