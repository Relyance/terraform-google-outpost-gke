# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out sierra.tfplan
#     terraform apply sierra.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance-Ext/inhost/gcp"

  env        = "stage"
  project_id = "rely-rd-25500-poc-1"
  region     = "us-central1"
  base_name  = "relyance-inhost"

  subnet_cidr   = "10.70.0.0/20"
  pods_cidr     = "10.71.0.0/20"
  services_cidr = "10.72.0.0/20"

  master_ipv4_cidr_block = "172.16.16.48/28"
  enable_public_endpoint = true
  control_plane_allowed_cidrs = {
    "34.105.86.245/32" = "Relyance developer VPN"
    "34.83.113.133/32" = "Relyance OpenVPN CloudConnexa Internet Gateway"
  }
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
