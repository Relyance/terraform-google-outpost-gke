locals {
  kms_keyring_name = "${var.base_name}-keyring"
  cmek_key_name    = "${var.base_name}-storage-key"
}

# GCS service agent for this project (must be allowed to use CMEK)
data "google_storage_project_service_account" "gcs_sa" {
  project = var.project_id
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 4.0"

  project_id                     = var.project_id
  location                       = lower(var.region)
  keyring                        = local.kms_keyring_name
  prevent_destroy                = var.kms_prevent_destroy
  key_destroy_scheduled_duration = var.kms_key_destroy_scheduled_duration
  key_rotation_period            = var.kms_key_rotation_period

  # Create exactly one key we’ll reuse across buckets
  keys = [local.cmek_key_name]

  # Grant usage to GCS service agent
  set_encrypters_for = [local.cmek_key_name]
  set_decrypters_for = [local.cmek_key_name]
  encrypters         = [data.google_storage_project_service_account.gcs_sa.member]
  decrypters         = [data.google_storage_project_service_account.gcs_sa.member]
}
