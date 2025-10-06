output "project_id" {
  description = "The GCP project ID where the InHost environment is deployed"
  value       = var.project_id
}

output "project_number" {
  description = "The numeric ID of the GCP project"
  value       = data.google_project.current.number
}

output "base_name" {
  description = "Base name used as prefix for all GCP resources"
  value       = var.base_name
}

output "region" {
  description = "Primary GCP region where resources are deployed"
  value       = var.region
}
