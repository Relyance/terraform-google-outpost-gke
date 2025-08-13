variable "base_name" {
  description = "base name for all resources"
  type        = string
  default     = "relyance-inhost"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.base_name))
    error_message = "base_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "env" {
  description = "What environment are you accessing [stage, prod]?"
  type        = string
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
  description = "CIDR block for the primary subnet used for GKE nodes"
  type        = string
  default     = ""
}

# GKE
variable "master_ipv4_cidr_block" {
  description = "The /28 CIDR block to use for the GKE master's private VPC connection (e.g., 172.16.0.0/28)."
  type        = string
  default     = ""
}

variable "pods_cidr" {
  description = "CIDR block used for GKE Pod IPs (IP aliasing)"
  type        = string
  default     = ""
}

variable "services_cidr" {
  description = "CIDR block used for GKE Services (ClusterIP ranges)"
  type        = string
  default     = ""
}

variable "control_plane_allowed_cidrs" {
  description = "Map of CIDR blocks to their descriptions for who can access the GKE control plane endpoint. If you want to allow public IPs (e.g., 34.x.x.x), you must also set `enable_public_endpoint = true`."
  type        = map(string)
  default     = {}
}

variable "existing_gke_name" {
  description = "Name of existing GKE cluster to use (if create_vpc_and_gke = false)"
  type        = string
  default     = null

  validation {
    condition     = !(!var.create_vpc_and_gke && var.existing_gke_name == null)
    error_message = "existing_gke_name is required if create_vpc_and_gke is false"
  }
}

variable "existing_gke_location" {
  description = <<EOT
Location of existing GKE cluster (used if create_vpc_and_gke = false).

This can be either a region (e.g. "us-central1") for regional clusters,
or a zone (e.g. "us-central1-a") for zonal clusters.

Note: We recommend using **regional** GKE clusters for better availability and resilience.
EOT

  type    = string
  default = null

  validation {
    condition     = !(!var.create_vpc_and_gke && var.existing_gke_location == null)
    error_message = "existing_gke_location is required if create_vpc_and_gke is false"
  }
}

variable "enable_public_endpoint" {
  description = "Whether to expose a public endpoint for the GKE control plane (alongside private endpoint)."
  type        = bool
  default     = false
}

variable "require_existing_gke_autopilot" {
  description = "Set false to allow existing GKE cluster that is not Autopilot"
  type        = bool
  default     = true
}

