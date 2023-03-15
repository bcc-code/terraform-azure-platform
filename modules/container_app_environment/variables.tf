variable "project_name" {
  type        = string
  description = "***\n The name of the project"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "`project_name` variable can only contain lowercase characters, numbers and dashes"
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

variable "resource_group" {
  type        = map(any)
  description = "***\n The data resource of the project's resource group"
}

variable "log_analytics_workspace" {
  type        = map(any)
  description = "***\n (optional) The shared container registry reader user assigned identity data resource\n If not provided, the module creates one itself."
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

variable "tags" {
  description = "(optional) Specifies the tags for the resource"
  type        = map(string)
  default     = {}
}
