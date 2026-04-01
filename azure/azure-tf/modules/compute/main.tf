resource "random_password" "admin" {
  length  = 20
  special = true
}

# ── VM Scale Set — B1s is the free-tier eligible VM ──────────────────────────
resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = "${var.project}-${var.env}-vmss"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku                             = "Standard_B1s" # 1 vCPU, 1 GB RAM — free tier
  instances                       = 1              # keep at 1 to stay free
  admin_username                  = "azureadmin"
  admin_password                  = random_password.admin.result
  disable_password_authentication = false
  health_probe_id                 = var.lb_probe_id
  upgrade_mode                    = "Rolling"

  # Bootstrap: install nginx, write env vars from Terraform outputs
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    cat >> /etc/environment <<ENVVARS
    APPINSIGHTS_KEY=${var.app_insights_key}
    SQL_CONN=${var.sql_connection_str}
    ENVVARS
    # Simple health endpoint
    echo 'server { listen 80; location /health { return 200 "ok\n"; add_header Content-Type text/plain; } }' \
      > /etc/nginx/sites-enabled/default
    systemctl enable nginx
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
    storage_account_type = "Standard_LRS" # cheapest disk tier
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = var.frontend_subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool_id]
    }
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 100
    max_unhealthy_instance_percent          = 100
    max_unhealthy_upgraded_instance_percent = 100
    pause_time_between_batches              = "PT0S"
  }

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }

  lifecycle { ignore_changes = [instances] }
}

# ── Autoscale — scale to max 2 to keep costs near zero ───────────────────────
resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "${var.project}-${var.env}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.main.id

  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    # Scale out: CPU > 80% for 5 min → add 1 instance
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale in: CPU < 20% for 10 min → remove 1 instance
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
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
