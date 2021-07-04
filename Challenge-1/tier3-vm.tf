#Availability Set
resource "azurerm_availability_set" "tier3-AvailabilitySet" {
  name                         = "DataAvailSet-${var.app_env}"
  location                     = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "3"

  tags = var.default_tags 
}

# Create virtal machine and define image to install on VM 
resource "azurerm_virtual_machine" "tier3-vm" {
  count = "${var.count}"
  name  = "sql-0${count.index + 1}-${var.app_env}"
  tags = var.default_tags
  location = "${azurerm_resource_group.ResourceGroup.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGroup.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.tier3-nics.*.id, count.index)}"]
  availability_set_id              = "${azurerm_availability_set.tier3-AvailabilitySet.id}"
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  vm_size                          = "Standard_A2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "osdisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier3-osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier3-datadisk${count.index}.vhd"
    disk_size_gb  = "100"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "sqlvm-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"


  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "true"

    winrm {
      protocol = "http"
    }
  }

}

