output "sever" {
  value     = azurerm_linux_virtual_machine.myterraformvm
  sensitive = true
}

# output "tls_private_key" {
#   value     = tls_private_key.example_ssh.private_key_pem
#   sensitive = true
# }