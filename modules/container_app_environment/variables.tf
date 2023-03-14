variable "project_name" {
  type        = string
  description = "The name of the project"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "`project_name` variable can only contain lowercase characters, numbers and dashes"
  }
}

variable "app_environment" {
  type        = string
  description = "The environment name of the app"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.app_environment))
    error_message = "`app_environment` variable can only contain lowercase characters and numbers"
  }
}

variable "resource_group" {
  type        = map(any)
  description = "The data resource of the project's resource group"
}

variable "log_analytics_workspace" {
  type        = map(any)
  description = "(optional) The shared container registry reader user assigned identity data resource"
  default     = null
}

variable "infrastructure_subnet_id" {
  type    = string
  default = null
}

variable "internal_load_balancer_enabled" {
  type    = bool
  default = null
}
