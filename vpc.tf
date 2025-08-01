module "vpc" {
  source = "./modules/vpc"
  count  = var.create_vpc_and_gke ? 1 : 0

  base_name     = var.base_name
  subnet_cidr   = var.subnet_cidr
  region        = var.region
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
}