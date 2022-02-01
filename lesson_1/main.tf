resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name_prefix}-${var.resource_group_project}-${var.resource_group_env}"
  location = var.resource_group_location

  tags = {
    Environment = "Test"
  }
}