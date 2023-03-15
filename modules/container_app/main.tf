data "azurerm_user_assigned_identity" "shared_cr_reader" {
  count               = var.shared_cr_reader == null ? 1 : 0
  name                = "id-cr-reader-${var.project_name}-${var.platform_environment}"
  resource_group_name = var.resource_group.name
}

locals {
  shared_cr_reader = coalesce(var.shared_cr_reader, data.azurerm_user_assigned_identity.shared_cr_reader[0])
}

resource "azurerm_container_app" "main" {
  name                         = "ca-${var.project_name}-${var.app_environment}"
  container_app_environment_id = var.container_app_environment.id
  resource_group_name          = var.resource_group.name
  revision_mode                = var.revision_mode
  tags                         = var.tags

  ingress {
    allow_insecure_connections = var.ingress.allow_insecure_connections
    external_enabled           = var.ingress.external_enabled
    target_port                = var.ingress.target_port
    transport                  = var.ingress.transport
    dynamic "custom_domain" {
      for_each = var.ingress.custom_domain
      content {
        certificate_binding_type = custom_domain.value["certificate_binding_type"]
        certificate_id           = custom_domain.value["certificate_id"]
        name                     = custom_domain.value["name"]
      }
    }
    dynamic "traffic_weight" {
      for_each = var.ingress.traffic_weight != null ? tolist([1]) : tolist([]) // Fill if traffic weight is not null
      content {
        label           = var.ingress.traffic_weight.label
        revision_suffix = var.ingress.traffic_weight.revision_suffix
        latest_revision = var.ingress.traffic_weight.latest_revision
        percentage      = var.ingress.traffic_weight.percentage
      }
    }
  }

  dynamic "registry" {
    for_each = var.registry
    content {
      server               = registry.value["server"]
      username             = registry.value["username"]
      password_secret_name = registry.value["password_secret_name"]
      identity             = registry.value["identity"]
    }
  }

  registry { // Shared container registry
    server   = "crbccplatform${var.platform_environment}.azurecr.io"
    identity = local.shared_cr_reader.id
  }

  template {
    revision_suffix = var.template.revision_suffix
    min_replicas    = coalesce(var.template.min_replicas, var.always_on ? 1 : 0)
    max_replicas    = coalesce(var.template.max_replicas, 10)

    dynamic "container" {
      for_each = var.template.container
      content {
        name              = coalesce(container.value["name"], "dummy")                                                        // "container-${var.component_name}-${var.project_name}-${var.app_environment}"
        image             = coalesce(container.value["image"], "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest") // "crbccplatform${var.platform_environment}.azurecr.io/ca-${var.project_name}-${var.component_name}-${var.app_environment}:latest")
        cpu               = container.value["cpu"]
        memory            = container.value["memory"]
        command           = container.value["command"]
        args              = container.value["args"]
        ephemeral_storage = container.value["ephemeral_storage"]

        dynamic "env" {
          for_each = container.value["env"]
          content {
            name        = env.value["name"]
            value       = env.value["value"]
            secret_name = env.value["secret_name"]
          }
        }

        dynamic "liveness_probe" {
          for_each = container.value["liveness_probe"]
          content {
            transport = liveness_probe.value["transport"]
            port      = liveness_probe.value["port"]
            host      = liveness_probe.value["host"]
            path      = liveness_probe.value["path"]

            dynamic "header" {
              for_each = liveness_probe.value["header"]
              content {
                name  = header.value["name"]
                value = header.value["value"]
              }
            }

            initial_delay                    = liveness_probe.value["initial_delay"]
            interval_seconds                 = liveness_probe.value["interval_seconds"]
            timeout                          = liveness_probe.value["timeout"]
            failure_count_threshold          = liveness_probe.value["failure_count_threshold"]
            termination_grace_period_seconds = liveness_probe.value["termination_grace_period_seconds"]
          }
        }

        dynamic "readiness_probe" {
          for_each = container.value["readiness_probe"]
          content {
            transport = readiness_probe.value["transport"]
            port      = readiness_probe.value["port"]
            host      = readiness_probe.value["host"]
            path      = readiness_probe.value["path"]

            dynamic "header" {
              for_each = readiness_probe.value["header"]
              content {
                name  = header.value["name"]
                value = header.value["value"]
              }
            }

            interval_seconds        = readiness_probe.value["interval_seconds"]
            timeout                 = readiness_probe.value["timeout"]
            failure_count_threshold = readiness_probe.value["failure_count_threshold"]
            success_count_threshold = readiness_probe.value["success_count_threshold"]
          }
        }

        dynamic "startup_probe" {
          for_each = container.value["startup_probe"]
          content {
            transport = startup_probe.value["transport"]
            port      = startup_probe.value["port"]
            host      = startup_probe.value["host"]
            path      = startup_probe.value["path"]

            dynamic "header" {
              for_each = startup_probe.value["header"]
              content {
                name  = header.value["name"]
                value = header.value["value"]
              }
            }

            interval_seconds                 = startup_probe.value["interval_seconds"]
            timeout                          = startup_probe.value["timeout"]
            failure_count_threshold          = startup_probe.value["failure_count_threshold"]
            termination_grace_period_seconds = startup_probe.value["termination_grace_period_seconds"]
          }
        }

        dynamic "volume_mounts" {
          for_each = container.value["volume_mounts"]
          content {
            name = volume_mounts.value["name"]
            path = volume_mounts.value["path"]
          }
        }
      }
    }

    dynamic "volume" {
      for_each = var.template.volume
      content {
        name         = volume.value["name"]
        storage_name = volume.value["storage_name"]
        storage_type = volume.value["storage_type"]
      }
    }
  }

  dynamic "secret" {
    for_each = { for k, v in var.secret : k => v }
    content {
      name  = secret.key
      value = sensitive(secret.value)
    }
  }

  dynamic "dapr" {
    for_each = var.dapr != null ? tolist([1]) : tolist([]) // Fill if dapr is not null
    content {
      app_id       = var.dapr.app_id
      app_port     = var.dapr.app_port
      app_protocol = var.dapr.app_protocol
    }
  }

  identity {
    type         = can(regex("SystemAssigned", var.identity.type)) ? "SystemAssigned, UserAssigned" : "UserAssigned"
    identity_ids = concat(try(tolist(var.identity.identity_ids), []), [local.shared_cr_reader.id])
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image
    ]
  }
}
