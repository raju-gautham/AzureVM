data "azurerm_resource_group" "main" {
  name     = "${var.rgName}"
  }

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["${var.address_space}"]
  location            = "${var.region}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = "${data.azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefixes     = ["${var.subnet_prefix}"]
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  location            = "${var.region}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  allocation_method   = "Dynamic"
}
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${var.region}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.prefix}-ipconfiguration"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.main.id}"
  }
}
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-azure-vm"
  location              = "${var.region}"
  resource_group_name   = "${data.azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "${var.vmSize}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys{
      path="/home/${var.admin_username}/.ssh/authorized_keys"
      key_data="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvGIAe+yvgiY/y18jO25+FYVTqLXRdbBYn3VrT3ttHeRwK1vKyYZY3bKiPy5eTP6mHAgXe6uHlgHU4ulFcgdvebevgAYomPxJokwuaf+t/3W4WbbFUZWlPCR5lQAwgTSlGtycmsMwUFMYHAPrIhe3J/V0W4f5HRPj38ktCktFNbO3wMsw7dg/7Jn+mMC54Lg3vPJBufN/aGgUe8yt/qMWjKT/NeA8xke+JjvEKhU1gCjOTMFQiB9AoScXnUgtDs8wjI7nJTaDLkS5MPn0WYUit8zwH+0I40bgqEK7us5xenh2POfLWgdyXZ6TDrFr1QshFQTsRTv04XA1D3vzIuyM1GXEbO8pUOO49bVsMhWdGl+wrqHLmKjFLchMjCgJPHXAMBIrbEYnDw1GzeeFeVeeiFkK7P+iF24BcF1AD7I0xELlaBYeFQ6jtWB10vpF2b926KRC/7WlYSS0MRn9+Kr9eWD5C8INoVwOwFgdfEdoouQ8ehbDW3LyIMMS4LlRhf5U= generated-by-azure"
    }
 }
  tags = {
     environment = "staging"
  }
}
