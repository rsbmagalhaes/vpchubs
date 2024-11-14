variable "ibmcloud_api_key" {
}

variable "solution_name" {
  description = "Suffix to be used while naming resources"
  default = "nome-teste"
}

variable "direct_link_customer_name" {
  description = "Direct Link Customer name"
  default = "direct-link-teste"
}

variable "address_range" {
  description = "Prefixes to be used for this core networking"
  default = "10.10.10.10/24"
}

variable "region" {
  description = "Region to be used for this core networking"
  default = "us-south"
}

variable "zone1" {
  description = "Zone 1 for prefixes to be used for this core networking"
  default = "us-south-1"
}

variable "zone2" {
  description = "Zone 2 for prefixes to be used for this core networking"
  default = "us-south-2"
}

variable "zone3" {
  description = "Zone 3 for prefixes to be used for this core networking"
  default = "us-south-3"
}

variable "tag1" {
  description = "Tag for resources to be used for this core networking"
  default = "tag-teste"
}

variable "rg" {
  description = "Resourse Group"
  default = "RG-Bradesco"
}
