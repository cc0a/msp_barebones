variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-msp-main"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}