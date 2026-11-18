variable "project_id" {
  description = "The ID of the project in which to create the GKE cluster."
  type        = string
}

variable "region" {
  description = "The region in which to deploy the GKE cluster."
  type        = string
}

variable "network" {
  description = "The name of the VPC network to which the cluster will be connected."
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to which the cluster will be connected."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The /28 CIDR block to use for the master network."
  type        = string

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.master_ipv4_cidr_block))
    error_message = "The master_ipv4_cidr_block must be a valid CIDR notation string (e.g., 172.16.0.0/28)."
  }
}

variable "ip_range_pods" {
  description = "The name of the secondary range to use for pod IPs."
  type        = string
}

variable "ip_range_services" {
  description = "The name of the secondary range to use for service IPs."
  type        = string
}

variable "control_plane_allowed_cidrs" {
  description = "List of CIDR blocks that are allowed to access the Kubernetes master endpoint."
  type        = map(string)

  validation {
    condition = alltrue([
      for cidr in keys(var.control_plane_allowed_cidrs) :
      can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr))
    ])
    error_message = "Each key in control_plane_allowed_cidrs must be a valid CIDR (e.g., 203.0.113.0/24)."
  }
}

variable "enable_public_endpoint" {
  description = "Whether to expose a public endpoint for the GKE control plane (alongside private endpoint)."
  type        = bool
}

variable "node_service_account" {
  description = "Service Account for GKE Autopilot Nodes"
  type        = string
}

variable "cmek_key_name" {
  description = "CMEK crypto key name used for GCS encryption."
  type        = string
}
