variable "base_name" {
  description = "Base name for VPC-related resources"
  type        = string
}

variable "region" {
  description = "GCP region to deploy the network and subnets"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the primary subnet"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary IP range for GKE Pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary IP range for GKE Services"
  type        = string
}
