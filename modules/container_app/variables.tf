variable "project_name" {
  type        = string
  description = "***\n The name of the project"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "`project_name` variable can only contain lowercase characters, numbers and dashes"
  }
}

variable "component_name" {
  type        = string
  description = "***\n The name of the component"
  default     = "api"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.component_name))
    error_message = "`component_name` variable can only contain lowercase characters, numbers and dashes"
  }
}

variable "app_environment" {
  type        = string
  description = "***\n The environment name of the app"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.app_environment))
    error_message = "`app_environment` variable can only contain lowercase characters and numbers"
  }
}

variable "platform_environment" {
  type        = string
  description = "***\n The underlying platform environment. Either 'prod' or 'dev'."

  validation {
    condition     = contains(["prod", "dev", "dev3"], var.platform_environment)
    error_message = "`platform_environment` variable can only be 'prod' or 'dev'."
  }
}

variable "always_on" {
  type        = bool
  description = "***\n Whether the container will have at least a container running at all times."
  default     = false
}

variable "shared_cr_reader" {
  description = "***\n (optional) The shared container registry reader user assigned identity data resource\n If not provided, the module reads it itself."
  default     = null
}

variable "resource_group" {
  description = "***\n The data resource of the project's resource group\n To be used instead of `resource_group_name` variable"
}

variable "container_app_environment" {
  description = "***\n The container app environment data resource\n To be used instead of `container_app_environment_id` variable"
}


# Resource schemas

variable "template" {
  description = "A template block, check documentation for more information"
  type = object({
    container = list(object({
      name              = optional(string)
      image             = optional(string)
      cpu               = optional(number, 0.25)
      memory            = optional(string, "0.5Gi")
      args              = optional(list(string))
      command           = optional(list(string))
      ephemeral_storage = optional(string)
      env = optional(list(object({
        name        = string
        value       = optional(string)
        secret_name = optional(string)
      })), [])
      volume_mounts = optional(list(object({
        name = string
        path = string
      })), [])
      liveness_probe = optional(list(object({
        transport = string
        port      = number
        host      = optional(string)
        path      = optional(string)
        header = optional(list(object({
          name  = string
          value = string
        })))
        initial_delay                    = optional(number)
        interval_seconds                 = optional(number)
        timeout                          = optional(number)
        failure_count_threshold          = optional(number)
        termination_grace_period_seconds = optional(number)
      })), [])
      readiness_probe = optional(list(object({
        transport = string
        port      = number
        host      = optional(string)
        path      = optional(string)
        header = optional(list(object({
          name  = string
          value = string
        })))
        interval_seconds        = optional(number)
        timeout                 = optional(number)
        failure_count_threshold = optional(number)
        success_count_threshold = optional(number)
      })), [])
      startup_probe = optional(list(object({
        transport = string
        port      = number
        host      = optional(string)
        path      = optional(string)
        header = optional(list(object({
          name  = string
          value = string
        })))
        interval_seconds                 = optional(number)
        timeout                          = optional(number)
        failure_count_threshold          = optional(number)
        termination_grace_period_seconds = optional(number)
      })), [])
    }))
    min_replicas    = optional(number)
    max_replicas    = optional(number)
    revision_suffix = optional(string)
    volume = optional(list(object({
      name         = string
      storage_name = optional(string)
      storage_type = optional(string)
    })), [])
  })
  default = {
    container = [{
      name   = "dummy"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "value"
    }]
    min_replicas = 0
    max_replicas = 10
  }
}

variable "revision_mode" {
  type        = string
  description = "The revisions operational mode for the Container App. Possible values include Single and Multiple."
  default     = "Single"
}

variable "ingress" {
  description = "An ingress block, check documentation for more information"
  type = object({
    allow_insecure_connections = optional(bool)
    custom_domain = optional(list(object({
      certificate_binding_type = optional(string)
      certificate_id           = string
      name                     = string
    })), [])
    external_enabled = optional(bool, true)
    target_port      = optional(number, 80)
    transport        = optional(string)
    traffic_weight = optional(object({
      label           = optional(string)
      revision_suffix = optional(string)
      latest_revision = optional(bool)
      percentage      = number
    }))
  })

  default = {
    external_enabled = true
    target_port      = 80
    traffic_weight = {
      latest_revision = true
      percentage      = 100
    }
  }
}

variable "registry" {
  type = list(object({
    server               = string
    username             = optional(string)
    password_secret_name = optional(string)
    identity             = optional(string)
  }))
  default = []
}

variable "secret" {
  type = list(object({
    name  = string
    value = string
  }))
  default   = []
  sensitive = true
}

variable "dapr" {
  type = object({
    app_id       = string
    app_port     = number
    app_protocol = optional(string)
  })
  default = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
  default = null

  validation {
    condition     = var.identity != null ? contains(["SystemAssigned, UserAssigned", "UserAssigned"], var.identity.type) : true
    error_message = "Supported values for identity type are \"SystemAssigned, UserAssigned\" or \"UserAssigned\"."
  }
}

variable "tags" {
  description = "(optional) Specifies the tags for the resource"
  type        = map(string)
  default     = {}
}
