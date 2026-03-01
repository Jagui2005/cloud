# Outputs para AWS
output "aws_public_ip" {
  value       = aws_instance.awsvm1.public_ip
  description = "IP pública de la instancia AWS"
}

output "aws_private_ip" {
  value       = aws_instance.awsvm1.private_ip
  description = "IP privada de la instancia AWS"
}

# Outputs para Azure
output "azure_public_ip" {
  value       = azurerm_public_ip.publicip.ip_address
  description = "IP pública de la VM en Azure"
}

output "azure_private_ip" {
  value       = azurerm_linux_virtual_machine.azurevm1.private_ip_address
  description = "IP privada de la VM en Azure"
}