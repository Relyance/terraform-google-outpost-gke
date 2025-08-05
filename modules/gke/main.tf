locals {
  master_authorized_networks = [
    for cidr, desc in var.control_plane_allowed_cidrs : {
      cidr_block   = cidr
      display_name = desc
    }
  ]
}

module "gke_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 36.2.0"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region
  network    = var.network
  subnetwork = var.subnetwork

  enable_private_nodes    = true
  enable_private_endpoint = var.enable_public_endpoint ? false : true
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  deletion_protection        = false
  master_authorized_networks = local.master_authorized_networks
}
