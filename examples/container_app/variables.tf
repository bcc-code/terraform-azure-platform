variable "app_environment" {
  type = string
}

variable "platform_environment" {
  type        = string
  description = "The underlying platform environment. Either 'prod' or 'dev'."
}
