<!-- Everything below this line is output from terraform-docs markdown table -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.verify_autopilot](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_container_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location (region or zone) of the existing cluster | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the existing GKE cluster | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID where the existing cluster lives | `string` | n/a | yes |
| <a name="input_require_autopilot_cluster"></a> [require\_autopilot\_cluster](#input\_require\_autopilot\_cluster) | Set false to allow existing GKE cluster that is not Autopilot | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
