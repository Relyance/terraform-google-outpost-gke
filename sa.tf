resource "google_service_account" "gke_nodes" {
  count        = var.create_vpc_and_gke ? 1 : 0
  project      = var.project_id
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account for Autopilot"
}

resource "google_project_iam_member" "gke_node_defaultrole" {
  count   = var.create_vpc_and_gke ? 1 : 0
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = google_service_account.gke_nodes[0].member
}

# Grant CMEK permissions to the Google-managed GKE control plane service account.
# This is required because database_encryption in GKE encrypts etcd (including Kubernetes Secrets)
# at the control plane level, and the control plane runs under this Google-managed SA:
#   service-<PROJECT_NUMBER>@container-engine-robot.iam.gserviceaccount.com
# Without this binding, cluster creation fails with MISSING_IAM_PERMISSIONS_ON_CRYPTO_KEY.
# https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets
resource "google_kms_crypto_key_iam_member" "gke_control_plane_kms" {
  crypto_key_id = module.kms.keys[local.cmek_key_name]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@container-engine-robot.iam.gserviceaccount.com"
}
