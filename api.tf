# We are currently enabling `compute.googleapis.com` via Terraform
# to allow this module to create VPCs, subnets, routers, and NATs.
#
# However, enabling the Compute API in a new GCP project also causes Google
# to auto-create a "default" VPC with wide-open firewall rules (e.g. SSH from 0.0.0.0/0).
# This may be undesirable in customer environments due to security or compliance policies.
#
# Long-term, we may remove this from the module and ask customers to enable the API explicitly.
# Until then, customers should be aware of the default VPC behavior and delete it if needed.

locals {
  required_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "pubsub.googleapis.com",
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.required_apis)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
