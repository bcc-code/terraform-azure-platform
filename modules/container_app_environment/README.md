For more information about parameters check the provider documentation page<br>(https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/container_app)
<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.45.0 |



## Inputs
Inputs that are marked with `***` are not documented in the official documentation.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | ***<br> The name of the project | `string`| | yes |
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | ***<br> The environment name of the app | `string`| | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | ***<br> The data resource of the project's resource group | `any`| | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | ***<br> (optional) The shared container registry reader user assigned identity data resource<br> If not provided, the module creates one itself. | `any`| `null`| no |
| <a name="input_infrastructure_subnet_id"></a> [infrastructure\_subnet\_id](#input\_infrastructure\_subnet\_id) | n/a | `string`| `null`| no |
| <a name="input_internal_load_balancer_enabled"></a> [internal\_load\_balancer\_enabled](#input\_internal\_load\_balancer\_enabled) | n/a | `bool`| `null`| no |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) Specifies the tags for the resource | `map(string)`| `{}`| no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main"></a> [main](#output\_main) | The `container_app_environment` resource object as described in the provider documentation. |

<!-- END_TF_DOCS -->