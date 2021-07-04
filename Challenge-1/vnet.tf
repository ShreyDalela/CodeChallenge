#Create a Resource Group
# Configure the Azure ARM provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "ResourceGroup" {
  name     = "terraform-3tier-${var.app_env}"
  location = "central us"
  tags = var.default_tags
}


########################################## Virtual Network ###########################################
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-${var.app_env}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
}

# Create subnet Tier1
resource "azurerm_subnet" "subnet1" {
  name                      = "web_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGroup.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.1.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier1_fw.id}"
}

#NIC Tire 1
resource "azurerm_network_interface" "tier1-nics" {
  count               = "3"
  name                = "vmnic-web-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  network_security_group_id = "${azurerm_network_security_group.tier1_fw.id}"

  ip_configuration {
    name                                    = "ipconfig${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "10.0.1.${count.index + 5}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier1.id}"]
  }
}

#NSG Rules Tire 1
resource "azurerm_network_security_group" "tier1_fw" {
  name                = "web_fw"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "allow-winrm"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "allow-RDP"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.0.128/25"
  }
}



##############################################Tier 2#################################################
# Create subnet Tier2
resource "azurerm_subnet" "subnet2" {
  name                      = "business_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGroup.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier2_fw.id}"
}

#NIC Tire 2
resource "azurerm_network_interface" "tier2-nics" {
  count               = "3"
  name                = "vmnic-app-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  network_security_group_id = "${azurerm_network_security_group.tier2_fw.id}"

  ip_configuration {
    name                                    = "ipconfig${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "10.0.2.${count.index + 5}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier2.id}"]
  }
}

#NSG Rules Tire 2
resource "azurerm_network_security_group" "tier2_fw" {
  name                = "app_fw"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "allow-winrm"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "allow-RDP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.0.128/25"
  }
}

##############################################Tier 3#################################################
# Create subnet Tier3
resource "azurerm_subnet" "subnet3" {
  name                      = "data_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGroup.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.3.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"
}

#NIC Tire 3
resource "azurerm_network_interface" "tier3-nics" {
  count               = "${var.count}"
  name                = "vmnic-sql-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"

  ip_configuration {
    name                                    = "ipconfig${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet3.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "10.0.3.${count.index + 5}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier3.id}"]
  }
}


#NSG Rules Tire 3
# Allow SQL and RDP.  Deny HTTP from tier1,tier2 and Internet 

resource "azurerm_network_security_group" "tier3_fw" {
  name                = "sql_fw"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  security_rule {
    name                       = "allow-sql"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.3.0/24"
    destination_address_prefix = "10.0.0.128/25"
  }

  security_rule {
    name                       = "Deny-tier2-inTraffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-tier2-outTraffic"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "Deny-tier1-inTraffic"
    priority                   = 220
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-tier1-outTraffic"
    priority                   = 230
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "Deny-Internet-inTraffic"
    priority                   = 240
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Internet-outTraffic"
    priority                   = 250
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "0.0.0.0/0"
  }
}



##############################################Bastion Subnet#################################################
# Create subnet Bastion
resource "azurerm_subnet" "BastionSubnet" {
  name                      = "management_net"
  resource_group_name       = "${azurerm_resource_group.ResourceGroup.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.0.128/25"
  network_security_group_id = "${azurerm_network_security_group.Bastion_fw.id}"
}

#NIC Bastion
resource "azurerm_network_interface" "Bastion-nics" {
  count               = "1"
  name                = "vmnic-mgt-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  network_security_group_id = "${azurerm_network_security_group.Bastion_fw.id}"

  ip_configuration {
    name                          = "ipconfig${count.index +1}"
    subnet_id                     = "${azurerm_subnet.BastionSubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP.id}"
  }
}

resource "azurerm_public_ip" "PublicIP" {
  name                         = "BastionPublicIP-${var.app_env}"
  location                     = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGroup.name}"
  public_ip_address_allocation = "static"
}

#NSG Rules Bastion
resource "azurerm_network_security_group" "Bastion_fw" {
  name                = "mgt_fw"
  location            = "${azurerm_resource_group.ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

  security_rule {
    name                       = "allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.128/25"
  }
}
