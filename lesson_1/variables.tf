//HERE YOU CAN DEFINE THE TERRAFORM VARIABLES
variable "resource_group_env" {
  type        = string
  default     = "test"
  description = "Environment of the resource group"
}

variable "resource_group_project" {
  default     = "terraform"
  description = "Project name to be used on the resource group name"
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}