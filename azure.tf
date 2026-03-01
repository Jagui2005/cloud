resource "azurerm_resource_group" "rg" {
  name     = "azurevm1_rg"
  location = var.azurerm_region 
}

resource "azurerm_virtual_network" "vnet" {
  name                = "azurevm1_vnet"
  address_space       = ["10.0.0.0/16"] 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "azurevm1_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"] 
}

resource "azurerm_public_ip" "publicip" {
  name                = "azurevm1-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" 
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "azurevm1_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "azurevm1_ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"                     
    public_ip_address_id          = azurerm_public_ip.publicip.id 
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "azurevm1_nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "AllowSSH"
  priority                    = 100       
  direction                   = "Inbound" 
  access                      = "Allow"   
  protocol                    = "Tcp"  
  source_port_range           = "*"       
  destination_port_range      = "22"      
  source_address_prefix       = "*"       
  destination_address_prefix  = "*"       
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "azurevm1" {
  name                = "azurevm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3" 
  admin_username      = "azureuser"   
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key) 
  }

  os_disk {
    name                 = "azurevm1_disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" 
    disk_size_gb         = 30            
  }

  source_image_reference {         
    publisher = "Canonical"       
    offer     = "ubuntu-24_04-lts" 
    sku       = "server"           
    version   = "latest"           
  }
}
