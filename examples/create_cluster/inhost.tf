# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out inhost.tfplan
#     terraform apply inhost.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance-Ext/inhost/gcp"

  project_id = "your-project-id"
  region     = "us-central1"

  # These shouldn't overlap with any resources you need to scan (via peering, NCC, VPN, etc.)
  subnet_cidr   = "10.70.0.0/20"
  pods_cidr     = "10.71.0.0/20"
  services_cidr = "10.72.0.0/20"

  master_ipv4_cidr_block = "172.16.16.48/28" # If you set up private access, this should be unique within your organization
  enable_public_endpoint = true
  control_plane_allowed_cidrs = {
    "127.0.0.1/32" = "Your admin env or VPN" # Replace IP with real public IP!
  }
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
