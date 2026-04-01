resource "random_password" "admin" {
  length  = 20
  special = true
}

# ── VM Scale Set ──────────────────────────────────────────────────────────────
resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = "${var.project}-${var.env}-vmss"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  sku                             = "Standard_D2s_v3"
  instances                       = 2
  admin_username                  = "azureadmin"
  admin_password                  = random_password.admin.result
  disable_password_authentication = false
  health_probe_id                 = azurerm_lb_probe.http.id
  upgrade_mode                    = "Rolling"

  # Inject App Insights key + SQL connection string into the VM at boot
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y && apt-get install -y nginx
    echo "APPINSIGHTS_KEY=${var.app_insights_key}"   >> /etc/environment
    echo "SQL_CONN=${var.sql_connection_str}"         >> /etc/environment
    echo "server { listen 80; location /health { return 200 'ok'; } }" \
      > /etc/nginx/sites-enabled/default
    systemctl restart nginx
  EOF
  )

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  network_interface {
    name    = "nic"
    primary = true
    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.frontend.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
    }
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }

  lifecycle { ignore_changes = [instances] }
}

# ── Autoscale ─────────────────────────────────────────────────────────────────
resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "${var.project}-${var.env}-autoscale"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.main.id

  profile {
    name = "default"
    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    # Scale OUT when CPU > 75% for 5 min
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    # Scale IN when CPU < 25% for 10 min
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
