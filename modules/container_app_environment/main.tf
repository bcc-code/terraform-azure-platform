resource "azurerm_log_analytics_workspace" "main" {
  count               = var.log_analytics_workspace == null ? 1 : 0
  name                = "logs-${local.project_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

locals {
  log_analytics_workspace = coalesce(var.log_analytics_workspace, azurerm_log_analytics_workspace.main)
}

resource "azurerm_container_app_environment" "main" {
  name                           = "cae-${var.project_name}-${var.app_environment}"
  location                       = var.resource_group.location
  resource_group_name            = var.resource_group.name
  log_analytics_workspace_id     = local.log_analytics_workspace.id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  tags                           = var.tags
}
