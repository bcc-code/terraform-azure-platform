provider "azurerm" {
  features {}
}

locals {
  project_name   = "[slug]" # Fill in with the project slug here
  component_name = ""       # Fill in with the component name e.g. api or cms
}

data "azurerm_resource_group" "main" {
  name = "${local.project_name}-${var.app_environment}"
}

module "container_app_environment" {
  source          = "bcc-code/platform/azure//modules/container_app_environment"
  project_name    = local.project_name
  app_environment = var.app_environment
  resource_group  = data.azurerm_resource_group.main
}

# Supports the same parameters as described here https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/container_app
module "container_app_api" {
  source                    = "bcc-code/platform/azure//modules/container_app"
  project_name              = local.project_name
  app_environment           = var.app_environment
  platform_environment      = var.platform_environment
  resource_group            = data.azurerm_resource_group.main
  container_app_environment = azurerm_container_app_environment.main
  # always_on                 = true # by default it's false and it allows the application to downscale to no running instances if there's no load for 5 minutes.
  template = {
    container = [{
      # Possible values for CPU and Memory are: 0.25/0.5Gi, 0.5/1.0Gi, 0.75/1.5Gi, 1.0/2.0Gi, 1.25/2.5Gi, 1.5/3.0Gi, 1.75/3.5Gi, and 2.0/4.0Gi
      cpu    = 0.25
      memory = "0.5Gi"
      env = [
        {
          name  = "PORT"
          value = "8081"
        },
        {
          name  = "ANOTHER_ENV_VARIABLE"
          value = "bla... bla... bla..."
        }
      ]
    }]
  }
}

module "container_app_second_component" {
  source                    = "bcc-code/platform/azure//modules/container_app"
  project_name              = local.project_name
  component_name            = "second-component" # If more than one container app is deployed in a project, a component name different that "api" must be specified. "api" is the default one.
  app_environment           = var.app_environment
  platform_environment      = var.platform_environment
  resource_group            = data.azurerm_resource_group.main
  container_app_environment = azurerm_container_app_environment.main
  secret = [
    {
      name  = "your_secret"
      value = "super secret value. It's recommended to leave this field empty here and fill the value through Azure Portal"
    }
  ]
  template = {
    container = [{
      image = "value" # Image can also be specified in case the default one is not wanted. 
      # After the resource creation, the image has to be managed from outside terraform from Azure Portal or the Github Action
      cpu    = 1.0
      memory = "2.0Gi"
    }]
    min_replicas = 0  # Setting this to 0 has the same effect as leaving the always_on variable set to false. This setting takes precedence over always_on variable.
    max_replicas = 10 # 10 is the default 
  }
}
