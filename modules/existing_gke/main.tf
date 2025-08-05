data "google_container_cluster" "existing" {
  name     = var.name
  location = var.location
  project  = var.project
}

# Validation logic TBD under https://relyance.atlassian.net/browse/RD-29772
