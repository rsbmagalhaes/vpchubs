/////////////////
# API KEY
/////////////////
variable "ibmcloud_api_key" {
}

/////////////////
# TRANSIT GATEWAY
/////////////////
variable "tg_name" {
  description = "Transit Gateway name"
  default     = "bradesco"
}

variable "tg_region" {
  description = "Transit Gateway region"
  default     = "us-south"
}

/////////////////
# RESOURCE GROUP
/////////////////
variable "rg" {
  description = "Resourse Group name"
  default     = "RG-Bradesco"
}

/////////////////
# VPC HUB 1
/////////////////
variable "vpc_hub_name_1" {
  description = "Name for VPC HUB 1"
  default     = "vpc-diti-core-hub-1"
}

variable "vpc_hub_1_region" {
  description = "Region to be used for VPC HUB 1"
  default     = "us-south"
}

variable "vpc_hub_1_zone_1" {
  description = "Zone 1 or 2 to be used for VPC HUB 1"
  default     = "us-south-1"
}

variable "vpc_hub_1_zone_2" {
  description = "Zone 1 or 2 to be used for VPC HUB 1"
  default     = "us-south-2"
}

variable "address_vpc_hub_1_1" {
  description = "Adress prefix for vpc hub 1 in zone 1"
  type        = string
  default     = "192.168.192.0/20"
}

variable "address_vpc_hub_1_2" {
  description = "Adress prefix for vpc hub 1 in zone 2"
  type        = string
  default     = "192.168.208.0/20"
}

/////////////////
# VPC HUB 2
/////////////////
variable "vpc_hub_name_2" {
  description = "Name for VPC HUB 2"
  default     = "vpc-diti-core-hub-2"
}

variable "vpc_hub_2_region" {
  description = "Region to be used for VPC HUB 2"
  default     = "us-south"
}

variable "vpc_hub_2_zone_1" {
  description = "Zone 1 or 2 to be used for VPC HUB 2"
  default     = "us-south-1"
}

variable "vpc_hub_2_zone_2" {
  description = "Zone 1 or 2 to be used for VPC HUB 2"
  default     = "us-south-2"
}

variable "address_vpc_hub_2_1" {
  description = "Adress prefix for VPC HUB 1 in zone 1"
  type        = string
  default     = "193.168.192.0/20"
}

variable "address_vpc_hub_2_2" {
  description = "Adress prefix for VPC HUB 1 in zone 2"
  type        = string
  default     = "193.168.208.0/20"
}

/////////////////
# TAG
/////////////////
variable "tag1" {
  description = "Tag for resources to be used for this core networking"
  default     = "tag-teste"
}











# variable "zone3" {
#   description = "Zone 3 for prefixes to be used for this core networking"
#   default     = "us-south-3"
# }