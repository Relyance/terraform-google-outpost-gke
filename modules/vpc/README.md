<!-- Everything below this line is output from terraform-docs markdown table -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | Base name for VPC-related resources | `string` | n/a | yes |
| <a name="input_pods_cidr"></a> [pods\_cidr](#input\_pods\_cidr) | Secondary IP range for GKE Pods | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region to deploy the network and subnets | `string` | n/a | yes |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | Secondary IP range for GKE Services | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the primary subnet used for GKE nodes | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | The name of the created subnet |
| <a name="output_subnet_secondary_ranges"></a> [subnet\_secondary\_ranges](#output\_subnet\_secondary\_ranges) | The configured secondary IP ranges for pods and services |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the created VPC network |
