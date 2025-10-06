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
  default     = "prod"
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
  description = <<-EOT
    Map of CIDR blocks to their descriptions for who can access the GKE control plane endpoint.
    If you want to allow public IPs (e.g., 34.x.x.x), you must also set `enable_public_endpoint = true`.
  EOT
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
  description = <<-EOT
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

# GCS
variable "gcs_bucket_suffix" {
  description = "Suffix to add to bucket name to avoid (unexpected) collision. Contact Relyance if set"
  type        = string
  default     = null
}

variable "code_analysis_enabled" {
  description = "Whether to create the SCI bucket"
  type        = bool
  default     = false
}

variable "findings_bucket_expiration_days" {
  description = "Number of days before objects in findings bucket expire"
  type        = number
  default     = 180
}

variable "work_bucket_expiration_days" {
  description = "Number of days before objects in work bucket expire"
  type        = number
  default     = 7
}

# Map each bucket name -> list of principals for the given role.
# Valid bucket keys with your module are: "findings", "work", and (optionally) "sci".
# Example:
# bucket_viewers = { findings = ["serviceAccount:ingestor@molokai.iam.gserviceaccount.com"] }

variable "bucket_viewers" {
  description = "Per-bucket principals for roles/storage.objectViewer."
  type        = map(list(string))
  default     = {}
}

variable "bucket_creators" {
  description = "Per-bucket principals for roles/storage.objectCreator."
  type        = map(list(string))
  default     = {}
}

variable "bucket_admins" {
  description = "Per-bucket principals for roles/storage.objectAdmin (object-level full access; no IAM)."
  type        = map(list(string))
  default     = {}
}

variable "bucket_storage_admins" {
  description = "Per-bucket principals for roles/storage.admin (bucket + object admin incl. IAM/settings)."
  type        = map(list(string))
  default     = {}
}

# KMS
variable "kms_key_rotation_period" {
  description = "Rotation period for the CMEK in seconds."
  type        = string
  default     = "2592000s" # 30 days in seconds
}

variable "kms_prevent_destroy" {
  description = "Protect KMS resources from accidental terraform destroy."
  type        = bool
  default     = true
}

variable "kms_key_destroy_scheduled_duration" {
  description = "Destruction delay for scheduled key version destroy."
  type        = string
  default     = "2592000s" # 30 days in seconds
}
