output "vpc_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "The name of the created subnet"
  value       = google_compute_subnetwork.main.name
}

output "subnet_secondary_ranges" {
  description = "The configured secondary IP ranges for pods and services"
  value = {
    pods     = var.pods_cidr
    services = var.services_cidr
  }
}
