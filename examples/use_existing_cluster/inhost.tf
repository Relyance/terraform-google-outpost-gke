# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out inhost.tfplan
#     terraform apply inhost.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance-Ext/inhost/gcp"

  env        = "stage"
  project_id = "rely-rd-25500-poc-1"
  region     = "us-central1"
  base_name  = "relyance-inhost"

  # Use an existing GKE cluster
  create_vpc_and_gke    = false
  existing_gke_name     = "existing-cluster-test2"
  existing_gke_location = "us-central1"

  subnet_cidr   = "10.70.0.0/20"
  pods_cidr     = "10.71.0.0/20"
  services_cidr = "10.72.0.0/20"
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
