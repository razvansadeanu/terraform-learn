# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "vnet-terraform-demo"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "Terraform Demo"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "snet-terraform-demo"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "pip-terraform-demo"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

data "azurerm_public_ip" "myterraformpublicip" {
  name                = azurerm_public_ip.myterraformpublicip.name
  resource_group_name = azurerm_public_ip.myterraformpublicip.resource_group_name
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "nsg-terraform-demo"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "nic-terraform-demo"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "stvmterraformdemo"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "vm-terraform-demo"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC63m/VVVzIaJicsDSrqd3uJM7cCIJjtCaJHYiMXdk/NiZrbxA42KYE+XSClNcmA5wYnimCBKT2QWRukqSaYbghohmkG/XAj77RtqgRx7tzqrl7egivh8aF2TgZc0VxOOtgI2YEpogWSo516gC+Ot99J63Ffus/nIAdaIAyEqMzs3AizB4EIKSIQotbQHueGaVl2OQyUm2sKR4xkTXIL43fd8ikpIxp0d7nLizxQXGJ2/ymln5X57+q3uJ9KK3FgT5YQaHLcKP//f5e9svpU3oyR8xpEemfQ2l4WJFxayZ61ArUE61YdDzomRhDdRRzpjBUX/inpayBNy3AVwn3KLT0OTmz1EvJEcJpRRTYwRmTFu6XBMgdE4LVqSiuCubF+5bCMtGE0QC0XJ/yvKm4R+r08Jyf2pqt6GKWYCQsM18hRSkVghaFFT5vuHwuecfQlBo4vCIPaeB7OMhctdQoN+A+fuWnhgLjVvKKitkg1vhzXPpN0K0UAbTI5ucfMJw+WOM= razvan@DESKTOP-TRVUIIT"
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt install httpd && sudo systemctl start httpd"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     host        = data.azurerm_public_ip.myterraformpublicip.ip_address
  #     user        = "azureuser"
  #     private_key = file("/home/razvan/.ssh/id_rsa")
  #   }
  # }



  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }


  tags = {
    environment = "Terraform Demo"
  }
}