data "google_container_cluster" "main" {
  name     = var.name
  location = var.location
  project  = var.project
}

resource "null_resource" "verify_autopilot" {
  count = var.require_autopilot_cluster ? 1 : 0

  triggers = {
    cluster_name = var.name
    timestamp    = timestamp() # ensures it runs every apply
  }

  provisioner "local-exec" {
    command     = <<-EOT
      if [ "$(gcloud container clusters describe ${var.name} \
        --region=${var.location} \
        --project=${var.project} \
        --format="value(autopilot.enabled)")" != "True" ]; then
        echo "GKE cluster '${var.name}' is NOT an Autopilot cluster. Set 'require_autopilot_cluster = false' to override."
        exit 1
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

