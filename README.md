# InHost Core Environment in GCP Terraform Module

## Introduction

This module is provided for use by customers of Relyance AI. Visit [relyance.ai](https://relyance.ai) to learn more about our services.

## Usage

When you have agreed to sign up for InHost, this module provisions the core infrastructure in your GCP project.

You will need to provide:

- Subnet CIDR blocks for your regions
- CIDR blocks for control plane (GKE) access

### Resources Created

Terraform always creates

- KMS key for encryption at rest of all cloud storage objects
- Storage buckets for in-progress work and final findings for export back to Relyance

If you are standing up a new GKE cluster rather than reusing an existing one, it also creates

- A VPC network
- Regional subnets
- A private GKE Autopilot cluster
- Optional: public endpoint access to the GKE control plane

### Caveat on teardown:

The dedicated KMS key

- provides optimal security for your data, but
- has (understandable) protections against deletion.

For this reason, it is currently not possible to destroy the entire Terraform module.
To remove most resources and minimize cost, set `create_vpc_and_gke = false`

## GKE Control Plane Access: Public vs Private Endpoints

This module provisions a **private GKE Autopilot cluster**. GKE offers two modes of accessing the Kubernetes control plane:

- **Private endpoint only** (default): Access is allowed only from internal networks (e.g., via VPN, VPC peering, NAT)
- **Public endpoint** (optional): A public IP is exposed, and access is restricted to explicitly allowed CIDR ranges

You can configure this behavior using the `enable_public_endpoint` flag:

- If `enable_public_endpoint = true`: a public IP is assigned to the control plane, and access is allowed only from CIDRs listed in `control_plane_allowed_cidrs`.
- If `enable_public_endpoint = false` (default): no public IP is created, and **only internal routes** can be used for access.

> If you include public IP ranges (e.g., `34.x.x.x/32`) in `control_plane_allowed_cidrs` **without** setting `enable_public_endpoint = true`, Terraform will fail with a validation error.

## Using an Existing GKE Cluster

If you provide the name of an **existing** GKE cluster instead of creating a new one, this module will validate that it is running in **Autopilot** mode.

- This validation requires the **gcloud CLI** to be installed on the system running Terraform.  
  Install instructions: [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install)
- If you want to skip this validation (for example, if you are certain your cluster is Autopilot but do not want to install the CLI), set `require_autopilot_cluster = false`.

### Accessing Private GKE Clusters

If you do not enable a public control plane endpoint, you will need to use one of the following options to interact with the cluster:

- **VPN access** (e.g., Cloud VPN, OpenVPN, CloudConnexa)
- **Bastion host**: SSH into a VM inside the VPC and use `kubectl` from there
- **Internal CI/CD pipelines**: Use internal runners or workloads that have access to the VPC
- **VPC Peering or NCC**: Establish peering or [Network Connectivity Center (NCC)](https://cloud.google.com/network-connectivity/docs/network-connectivity-center) to route control plane traffic from a shared network
- **Cloud NAT**: If your CI/CD runners or developers are behind NAT but route through the VPC

## Known Limitations

- **DNS resolution to the control plane** is not currently supported by this module. You must use the IP address (internal or public) directly.

## Notes on API Enablement and Default VPC

This module currently enables the `compute.googleapis.com` API using Terraform to allow creation of VPCs, subnets, routers, and NATs.

However, enabling the Compute API in a **new** GCP project causes Google to automatically create a `default` VPC network with **wide-open firewall rules** (e.g., SSH access from `0.0.0.0/0`).

This may be undesirable for security or compliance sensitive environments.

### What you should do

- **Preferred**: If you manage GCP organization policies, set the constraint
  [`constraints/compute.skipDefaultNetworkCreation`](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints#compute.skipDefaultNetworkCreation)
  to `TRUE` at the organization or folder level. This will prevent default VPC creation entirely, even when enabling the Compute API in new projects.
- **Alternatively**: If you do not control org policies, you can pre-enable the `compute.googleapis.com` API outside of this module to avoid triggering default VPC creation during apply.
- As a last resort, manually review and delete the default VPC if it was created automatically.

## Examples

These example files (available in `examples/*` directories) bundle everything into one file.
You should follow organizational best practices for file structure, remote state management, etc.

### Create new GKE cluster

`examples/create_cluster/inhost.tf`
```hcl
# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out inhost.tfplan
#     terraform apply inhost.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance/outpost-gke/google"

  project_id = "your-project-id"
  region     = "us-central1"

  # These shouldn't overlap with any resources you need to scan (via peering, NCC, VPN, etc.)
  subnet_cidr   = "10.70.0.0/20"
  pods_cidr     = "10.71.0.0/20"
  services_cidr = "10.72.0.0/20"

  master_ipv4_cidr_block = "172.16.16.48/28" # If you set up private access, this should be unique within your organization
  enable_public_endpoint = true
  control_plane_allowed_cidrs = {
    "127.0.0.1/32" = "Your admin env or VPN" # Replace IP with real public IP!
  }
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
```

### Use existing GKE cluster

`examples/use_existing_cluster/inhost.tf`
```hcl
# Single file with everything you need.
# For local consistency during updates, run
#     terraform init
#     terraform plan -out inhost.tfplan
#     terraform apply inhost.tfplan
# For collaboration, configure backend for shared remote state file
# For maintainability, replace hard-coded values with variables or outputs from other modules

module "inhost" {
  source = "Relyance/outpost-gke/google"

  project_id = "your-project-id"
  region     = "us-central1"

  # Use an existing GKE cluster
  create_vpc_and_gke    = false
  existing_gke_name     = "your-cluster-name"
  existing_gke_location = "us-central1"
}

provider "google" {}

output "inhost" {
  description = "Information to provide to Relyance"
  value       = module.inhost
}
```

<!-- Everything below this line is output from terraform-docs markdown table -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_existing_gke"></a> [existing\_gke](#module\_existing\_gke) | ./modules/existing_gke | n/a |
| <a name="module_gcs_buckets"></a> [gcs\_buckets](#module\_gcs\_buckets) | terraform-google-modules/cloud-storage/google | 11.0.0 |
| <a name="module_gke"></a> [gke](#module\_gke) | ./modules/gke | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-google-modules/kms/google | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_kms_crypto_key_iam_member.gke_control_plane_kms](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_project_iam_member.gke_node_defaultrole](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.required](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.gke_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_iam_binding.bucket_viewer_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_storage_project_service_account.gcs_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | base name for all resources | `string` | `"relyance-inhost"` | no |
| <a name="input_bucket_admins"></a> [bucket\_admins](#input\_bucket\_admins) | Per-bucket principals for roles/storage.objectAdmin (object-level full access; no IAM). | `map(list(string))` | `{}` | no |
| <a name="input_bucket_creators"></a> [bucket\_creators](#input\_bucket\_creators) | Per-bucket principals for roles/storage.objectCreator. | `map(list(string))` | `{}` | no |
| <a name="input_bucket_storage_admins"></a> [bucket\_storage\_admins](#input\_bucket\_storage\_admins) | Per-bucket principals for roles/storage.admin (bucket + object admin incl. IAM/settings). | `map(list(string))` | `{}` | no |
| <a name="input_bucket_viewers"></a> [bucket\_viewers](#input\_bucket\_viewers) | Per-bucket principals for roles/storage.objectViewer. | `map(list(string))` | `{}` | no |
| <a name="input_code_analysis_enabled"></a> [code\_analysis\_enabled](#input\_code\_analysis\_enabled) | Whether to create the SCI bucket | `bool` | `false` | no |
| <a name="input_control_plane_allowed_cidrs"></a> [control\_plane\_allowed\_cidrs](#input\_control\_plane\_allowed\_cidrs) | Map of CIDR blocks to their descriptions for who can access the GKE control plane endpoint.<br/>If you want to allow public IPs (e.g., 34.x.x.x), you must also set `enable_public_endpoint = true`. | `map(string)` | `{}` | no |
| <a name="input_create_vpc_and_gke"></a> [create\_vpc\_and\_gke](#input\_create\_vpc\_and\_gke) | If false, assumes external VPC and GKE exist and skips their creation | `bool` | `true` | no |
| <a name="input_enable_public_endpoint"></a> [enable\_public\_endpoint](#input\_enable\_public\_endpoint) | Whether to expose a public endpoint for the GKE control plane (alongside private endpoint). | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | What environment are you accessing [stage, prod]? | `string` | `"prod"` | no |
| <a name="input_existing_gke_location"></a> [existing\_gke\_location](#input\_existing\_gke\_location) | Location of existing GKE cluster (used if create\_vpc\_and\_gke = false).<br/><br/>This can be either a region (e.g. "us-central1") for regional clusters,<br/>or a zone (e.g. "us-central1-a") for zonal clusters.<br/><br/>Note: We recommend using **regional** GKE clusters for better availability and resilience. | `string` | `null` | no |
| <a name="input_existing_gke_name"></a> [existing\_gke\_name](#input\_existing\_gke\_name) | Name of existing GKE cluster to use (if create\_vpc\_and\_gke = false) | `string` | `null` | no |
| <a name="input_findings_bucket_expiration_days"></a> [findings\_bucket\_expiration\_days](#input\_findings\_bucket\_expiration\_days) | Number of days before objects in findings bucket expire | `number` | `180` | no |
| <a name="input_gcs_bucket_suffix"></a> [gcs\_bucket\_suffix](#input\_gcs\_bucket\_suffix) | Suffix to add to bucket name to avoid (unexpected) collision. Contact Relyance if set | `string` | `null` | no |
| <a name="input_kms_key_destroy_scheduled_duration"></a> [kms\_key\_destroy\_scheduled\_duration](#input\_kms\_key\_destroy\_scheduled\_duration) | Destruction delay for scheduled key version destroy. | `string` | `"2592000s"` | no |
| <a name="input_kms_key_rotation_period"></a> [kms\_key\_rotation\_period](#input\_kms\_key\_rotation\_period) | Rotation period for the CMEK in seconds. | `string` | `"2592000s"` | no |
| <a name="input_kms_prevent_destroy"></a> [kms\_prevent\_destroy](#input\_kms\_prevent\_destroy) | Protect KMS resources from accidental terraform destroy. | `bool` | `true` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The /28 CIDR block to use for the GKE master's private VPC connection (e.g., 172.16.0.0/28). | `string` | `""` | no |
| <a name="input_pods_cidr"></a> [pods\_cidr](#input\_pods\_cidr) | CIDR block used for GKE Pod IPs (IP aliasing) | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project where the resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region in which all resources will be created | `string` | n/a | yes |
| <a name="input_require_existing_gke_autopilot"></a> [require\_existing\_gke\_autopilot](#input\_require\_existing\_gke\_autopilot) | Set false to allow existing GKE cluster that is not Autopilot | `bool` | `true` | no |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | CIDR block used for GKE Services (ClusterIP ranges) | `string` | `""` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the primary subnet used for GKE nodes | `string` | `""` | no |
| <a name="input_work_bucket_expiration_days"></a> [work\_bucket\_expiration\_days](#input\_work\_bucket\_expiration\_days) | Number of days before objects in work bucket expire | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_name"></a> [base\_name](#output\_base\_name) | Base name used as prefix for all GCP resources |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The GCP project ID where the InHost environment is deployed |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | The numeric ID of the GCP project |
| <a name="output_region"></a> [region](#output\_region) | Primary GCP region where resources are deployed |
<!-- END_TF_DOCS -->
