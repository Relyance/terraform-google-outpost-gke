<!-- Everything below this line is output from terraform-docs markdown table -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke_cluster"></a> [gke\_cluster](#module\_gke\_cluster) | terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster | ~> 36.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster. | `string` | n/a | yes |
| <a name="input_cmek_key_name"></a> [cmek\_key\_name](#input\_cmek\_key\_name) | CMEK crypto key name used for GCS encryption. | `string` | n/a | yes |
| <a name="input_control_plane_allowed_cidrs"></a> [control\_plane\_allowed\_cidrs](#input\_control\_plane\_allowed\_cidrs) | List of CIDR blocks that are allowed to access the Kubernetes master endpoint. | `map(string)` | n/a | yes |
| <a name="input_enable_public_endpoint"></a> [enable\_public\_endpoint](#input\_enable\_public\_endpoint) | Whether to expose a public endpoint for the GKE control plane (alongside private endpoint). | `bool` | n/a | yes |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | The name of the secondary range to use for pod IPs. | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | The name of the secondary range to use for service IPs. | `string` | n/a | yes |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The /28 CIDR block to use for the master network. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The name of the VPC network to which the cluster will be connected. | `string` | n/a | yes |
| <a name="input_node_service_account"></a> [node\_service\_account](#input\_node\_service\_account) | Service Account for GKE Autopilot Nodes | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which to create the GKE cluster. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which to deploy the GKE cluster. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The name of the subnetwork to which the cluster will be connected. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
