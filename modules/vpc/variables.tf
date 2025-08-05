variable "base_name" {
  description = "Base name for VPC-related resources"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region to deploy the network and subnets"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the primary subnet used for GKE nodes"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.subnet_cidr))
    error_message = "subnet_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}

variable "pods_cidr" {
  description = "Secondary IP range for GKE Pods"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.pods_cidr))
    error_message = "pods_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}

variable "services_cidr" {
  description = "Secondary IP range for GKE Services"
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.services_cidr))
    error_message = "services_cidr must be a valid CIDR block (e.g. 10.0.0.0/24)."
  }
}
