# Sierra Core Environment in GCP Terraform Module

## Introduction

This module is provided for use by customers of Relyance AI. Visit [relyance.ai](https://relyance.ai) to learn more about our services.

## Usage

When you have agreed to sign up for Sierra, this module provisions the core infrastructure in your GCP project.

You will need to provide:

- Subnet CIDR blocks for your regions
- CIDR blocks for control plane (GKE) access
- Your environment (`stage`, `prod`, etc.)

### Resources Created

All resources will have labels identifying them as part of `relyance-inhost`. [TBD: [RD-29657](https://relyance.atlassian.net/browse/RD-29657)]

- A VPC network
- Regional subnets
- A private GKE Autopilot cluster
- Optional: public endpoint access to the GKE control plane

## GKE Control Plane Access: Public vs Private Endpoints

This module provisions a **private GKE Autopilot cluster**. GKE offers two modes of accessing the Kubernetes control plane:

- **Private endpoint only** (default): Access is allowed only from internal networks (e.g., via VPN, VPC peering, NAT)
- **Public endpoint** (optional): A public IP is exposed, and access is restricted to explicitly allowed CIDR ranges

You can configure this behavior using the `enable_public_endpoint` flag:

- If `enable_public_endpoint = true`: a public IP is assigned to the control plane, and access is allowed only from CIDRs listed in `control_plane_allowed_cidrs`.
- If `enable_public_endpoint = false` (default): no public IP is created, and **only internal routes** can be used for access.

> ⚠️ If you include public IP ranges (e.g., `34.x.x.x/32`) in `control_plane_allowed_cidrs` **without** setting `enable_public_endpoint = true`, Terraform will fail with a validation error.

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
| <a name="module_gke"></a> [gke](#module\_gke) | ./modules/gke | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.required](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | base name for all resources | `string` | `"relyance-inhost"` | no |
| <a name="input_control_plane_allowed_cidrs"></a> [control\_plane\_allowed\_cidrs](#input\_control\_plane\_allowed\_cidrs) | Map of CIDR blocks to their descriptions for who can access the GKE control plane endpoint. If you want to allow public IPs (e.g., 34.x.x.x), you must also set `enable_public_endpoint = true`. | `map(string)` | `{}` | no |
| <a name="input_create_vpc_and_gke"></a> [create\_vpc\_and\_gke](#input\_create\_vpc\_and\_gke) | If false, assumes external VPC and GKE exist and skips their creation | `bool` | `true` | no |
| <a name="input_enable_public_endpoint"></a> [enable\_public\_endpoint](#input\_enable\_public\_endpoint) | Whether to expose a public endpoint for the GKE control plane (alongside private endpoint). | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | What environment are you accessing [stage, prod]? | `string` | n/a | yes |
| <a name="input_existing_gke_location"></a> [existing\_gke\_location](#input\_existing\_gke\_location) | Location of existing GKE cluster (used if create\_vpc\_and\_gke = false).<br/><br/>This can be either a region (e.g. "us-central1") for regional clusters,<br/>or a zone (e.g. "us-central1-a") for zonal clusters.<br/><br/>Note: We recommend using **regional** GKE clusters for better availability and resilience. | `string` | `null` | no |
| <a name="input_existing_gke_name"></a> [existing\_gke\_name](#input\_existing\_gke\_name) | Name of existing GKE cluster to use (if create\_vpc\_and\_gke = false) | `string` | `null` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The /28 CIDR block to use for the GKE master's private VPC connection (e.g., 172.16.0.0/28). | `string` | `""` | no |
| <a name="input_pods_cidr"></a> [pods\_cidr](#input\_pods\_cidr) | CIDR block used for GKE Pod IPs (IP aliasing) | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project where the resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region in which all resources will be created | `string` | n/a | yes |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | CIDR block used for GKE Services (ClusterIP ranges) | `string` | `""` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the primary subnet used for GKE nodes | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_name"></a> [base\_name](#output\_base\_name) | Base name used as prefix for all GCP resources |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The GCP project ID where the Sierra environment is deployed |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | The numeric ID of the GCP project |
| <a name="output_region"></a> [region](#output\_region) | Primary GCP region where resources are deployed |
<!-- END_TF_DOCS -->
