resource "azurerm_storage_account" "storage" {
  name                = "CommonStorage-${var.app_env}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  location     = "${azurerm_resource_group.ResourceGroup.location}"
  account_type = "Standard_GRS"

  tags = var.default_tags
}

resource "azurerm_storage_container" "blob1" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.ResourceGroup.name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}
