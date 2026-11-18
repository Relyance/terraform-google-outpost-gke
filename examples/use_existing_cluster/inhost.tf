# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out inhost.tfplan
#     terraform apply inhost.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance/outpost-gke/google"

  project_id = "your-project-id"
  region     = "us-central1"

  # Use an existing GKE cluster
  create_vpc_and_gke    = false
  existing_gke_name     = "your-cluster-name"
  existing_gke_location = "us-central1"
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
