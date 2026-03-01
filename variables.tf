# AWS
variable "aws_region" {
  default = "us-east-1"
}

# Azure
variable "azurerm_region" {
  default = "westus"
}

variable "ssh_public_key" {
  description = "SSH Public Key"
}