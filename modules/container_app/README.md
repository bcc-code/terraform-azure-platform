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
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | ***<br> The name of the component | `string`| `"api"`| no |
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | ***<br> The environment name of the app | `string`| | yes |
| <a name="input_platform_environment"></a> [platform\_environment](#input\_platform\_environment) | ***<br> The underlying platform environment. Either 'prod' or 'dev'. | `string`| | yes |
| <a name="input_always_on"></a> [always\_on](#input\_always\_on) | ***<br> Whether the container will have at least a container running at all times. | `bool`| `false`| no |
| <a name="input_shared_cr_reader"></a> [shared\_cr\_reader](#input\_shared\_cr\_reader) | ***<br> (optional) The shared container registry reader user assigned identity data resource<br> If not provided, the module reads it itself. | `map(any)`| `null`| no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | ***<br> The data resource of the project's resource group<br> To be used instead of `resource_group_name` variable | `map(any)`| | yes |
| <a name="input_container_app_environment"></a> [container\_app\_environment](#input\_container\_app\_environment) | ***<br> The container app environment data resource<br> To be used instead of `container_app_environment_id` variable | `map(any)`| | yes |
| <a name="input_template"></a> [template](#input\_template) | A template block, check documentation for more information | <pre>object({<br>    container = list(object({<br>      name              = optional(string)<br>      image             = optional(string)<br>      cpu               = optional(number, 0.25)<br>      memory            = optional(string, "0.5Gi")<br>      args              = optional(list(string))<br>      command           = optional(list(string))<br>      ephemeral_storage = optional(string)<br>      env = optional(list(object({<br>        name        = string<br>        value       = optional(string)<br>        secret_name = optional(string)<br>      })))<br>      volume_mounts = optional(list(object({<br>        name = string<br>        path = string<br>      })))<br>      liveness_probe = optional(object({<br>        transport = string<br>        port      = number<br>        host      = optional(string)<br>        path      = optional(string)<br>        header = optional(list(object({<br>          name  = string<br>          value = string<br>        })))<br>        initial_delay                    = optional(number)<br>        interval_seconds                 = optional(number)<br>        timeout                          = optional(number)<br>        failure_count_threshold          = optional(number)<br>        termination_grace_period_seconds = optional(number)<br>      }))<br>      readiness_probe = optional(object({<br>        transport = string<br>        port      = number<br>        host      = optional(string)<br>        path      = optional(string)<br>        header = optional(list(object({<br>          name  = string<br>          value = string<br>        })))<br>        interval_seconds        = optional(number)<br>        timeout                 = optional(number)<br>        failure_count_threshold = optional(number)<br>        success_count_threshold = optional(number)<br>      }))<br>      startup_probe = optional(object({<br>        transport = string<br>        port      = number<br>        host      = optional(string)<br>        path      = optional(string)<br>        header = optional(list(object({<br>          name  = string<br>          value = string<br>        })))<br>        interval_seconds                 = optional(number)<br>        timeout                          = optional(number)<br>        failure_count_threshold          = optional(number)<br>        termination_grace_period_seconds = optional(number)<br>      }))<br>    }))<br>    min_replicas    = optional(number)<br>    max_replicas    = optional(number)<br>    revision_suffix = optional(string)<br>    volume = optional(list(object({<br>      name         = string<br>      storage_name = optional(string)<br>      storage_type = optional(string)<br>    })))<br>  })</pre>| <pre>{<br>  "container": [<br>    {<br>      "cpu": 0.25,<br>      "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",<br>      "memory": "value",<br>      "name": "dummy"<br>    }<br>  ],<br>  "max_replicas": 10,<br>  "min_replicas": 0<br>}</pre>| no |
| <a name="input_revision_mode"></a> [revision\_mode](#input\_revision\_mode) | The revisions operational mode for the Container App. Possible values include Single and Multiple. | `string`| `"Single"`| no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | An ingress block, check documentation for more information | <pre>object({<br>    allow_insecure_connections = optional(bool)<br>    custom_domain = optional(list(object({<br>      certificate_binding_type = optional(string)<br>      certificate_id           = string<br>      name                     = string<br>    })))<br>    external_enabled = optional(bool, true)<br>    target_port      = optional(number, 80)<br>    transport        = optional(string)<br>    traffic_weight = optional(object({<br>      label           = optional(string)<br>      revision_suffix = optional(string)<br>      latest_revision = optional(bool)<br>      percentage      = number<br>    }))<br>  })</pre>| <pre>{<br>  "external_enabled": true,<br>  "target_port": 80<br>}</pre>| no |
| <a name="input_registry"></a> [registry](#input\_registry) | n/a | <pre>list(object({<br>    server               = string<br>    username             = optional(string)<br>    password_secret_name = optional(string)<br>    identity             = optional(string)<br>  }))</pre>| `[]`| no |
| <a name="input_secret"></a> [secret](#input\_secret) | n/a | <pre>set(object({<br>    name  = string<br>    value = string<br>  }))</pre>| `[]`| no |
| <a name="input_dapr"></a> [dapr](#input\_dapr) | n/a | <pre>object({<br>    app_id       = string<br>    app_port     = number<br>    app_protocol = optional(string)<br>  })</pre>| `null`| no |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object({<br>    type         = string<br>    identity_ids = optional(set(string))<br>  })</pre>| `null`| no |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) Specifies the tags for the resource | `map(string)`| `{}`| no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main"></a> [main](#output\_main) | The `container_app` resource object as described in the provider documentation. |

<!-- END_TF_DOCS -->