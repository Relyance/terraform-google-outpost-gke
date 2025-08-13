locals {
  bucket_prefix = var.gcs_bucket_suffix != null ? var.gcs_bucket_suffix : "${var.base_name}-${data.google_project.current.number}"

  ksa_namespace = "inhost"
  ksa_name      = "relyance"
  ksa_principal = "principal://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/${local.ksa_namespace}/sa/${local.ksa_name}"

  bucket_names = var.code_analysis_enabled ? ["findings", "work", "sci"] : ["findings", "work"]

  # Compose effective per-bucket membership for each role:
  # - Always include KSA on: work (objectAdmin), findings (viewer + creator)
  # - Add any principals from user-provided maps (by bucket key)
  viewers_by_bucket = {
    for b in local.bucket_names : b => join(
      ",",
      compact(
        concat(
          b == "findings" ? [local.ksa_principal] : [], # KSA gets read on findings
          lookup(var.bucket_viewers, b, [])
        )
      )
    )
  }

  creators_by_bucket = {
    for b in local.bucket_names : b => join(
      ",",
      compact(
        concat(
          b == "findings" ? [local.ksa_principal] : [], # KSA can upload to findings
          lookup(var.bucket_creators, b, [])
        )
      )
    )
  }

  admins_by_bucket = {
    for b in local.bucket_names : b => join(
      ",",
      compact(
        concat(
          b == "work" ? [local.ksa_principal] : [], # KSA full object admin on work
          lookup(var.bucket_admins, b, [])
        )
      )
    )
  }

  storage_admins_by_bucket = {
    for b in local.bucket_names : b => join(
      ",",
      compact(lookup(var.bucket_storage_admins, b, []))
    )
  }

  # Booleans to create bindings only when there’s at least one member somewhere
  set_admin_roles         = anytrue([for v in local.admins_by_bucket : length(v) > 0])
  set_viewer_roles        = anytrue([for v in local.viewers_by_bucket : length(v) > 0])
  set_creator_roles       = anytrue([for v in local.creators_by_bucket : length(v) > 0])
  set_storage_admin_roles = anytrue([for v in local.storage_admins_by_bucket : length(v) > 0])
}

module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "11.0.0"

  project_id = var.project_id
  location   = var.region
  prefix     = local.bucket_prefix
  names      = local.bucket_names

  public_access_prevention = "enforced"

  versioning = {
    findings = true
    work     = true
    sci      = true
  }

  lifecycle_rules = [
    {
      action    = { type = "Delete" }
      condition = { age = var.work_bucket_expiration_days }
    }
  ]

  bucket_lifecycle_rules = {
    findings = [
      {
        action    = { type = "Delete" }
        condition = { age = var.findings_bucket_expiration_days }
      }
    ]
  }

  encryption_key_names = {
    for b in local.bucket_names : b => module.kms.keys[local.cmek_key_name]
  }

  bucket_viewers        = local.viewers_by_bucket
  bucket_creators       = local.creators_by_bucket
  bucket_admins         = local.admins_by_bucket
  bucket_storage_admins = local.storage_admins_by_bucket

  set_viewer_roles        = local.set_viewer_roles
  set_creator_roles       = local.set_creator_roles
  set_admin_roles         = local.set_admin_roles
  set_storage_admin_roles = local.set_storage_admin_roles
}
