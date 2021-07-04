output "webservers_name" {
  value = ["${azurerm_virtual_machine.tier1-vm.*.name}"]
}

output "appservers_name" {
  value = ["${azurerm_virtual_machine.tier2-vm.*.name}"]
}

output "sqlservers_name" {
  value = ["${azurerm_virtual_machine.tier3-vm.*.name}"]
}

output "bastion_name" {
  value = ["${azurerm_virtual_machine.Bastion-vm.*.name}"]
}

output "bastion_ip" {
  value = ["${azurerm_network_interface.Bastion-nics.private_ip_address}"]
}

output "webservers_ip" {
  value = ["${azurerm_network_interface.tier1-nics.*.private_ip_address}"]
}

output "appservers_ip" {
  value = ["${azurerm_network_interface.tier2-nics.*.private_ip_address}"]
}

output "sqlservers_ip" {
  value = ["${azurerm_network_interface.tier3-nics.*.private_ip_address}"]
}


output "LB_VIP_IP" {
  value = ["${azurerm_public_ip.lbIP.ip_address}"]
}

output "LB_VIP_DNS" {
  value = ["${azurerm_public_ip.lbIP.fqdn}"]
}
