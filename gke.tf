module "gke" {
  source = "./modules/gke"
  count  = var.create_vpc_and_gke ? 1 : 0

  depends_on = [google_kms_crypto_key_iam_member.gke_control_plane_kms]

  project_id             = var.project_id
  region                 = var.region
  network                = module.vpc[0].vpc_name
  subnetwork             = module.vpc[0].subnet_name
  cluster_name           = "${var.base_name}-${var.env}-gke"
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  ip_range_pods          = "pods"
  ip_range_services      = "services"
  enable_public_endpoint = var.enable_public_endpoint
  cmek_key_name          = module.kms.keys[local.cmek_key_name]
  node_service_account   = google_service_account.gke_nodes[0].email

  control_plane_allowed_cidrs = var.control_plane_allowed_cidrs
}

module "existing_gke" {
  source = "./modules/existing_gke"
  count  = var.create_vpc_and_gke ? 0 : 1

  name     = var.existing_gke_name
  location = var.existing_gke_location
  project  = var.project_id

  require_autopilot_cluster = var.require_existing_gke_autopilot
}

locals {
  gke_cluster_name = var.create_vpc_and_gke ? module.gke[0].name : module.existing_gke[0].name
}
