output "vpc_name" {
  description = "The self link of the created VPC network"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "The self link of the created primary subnet"
  value       = google_compute_subnetwork.main.name
}
