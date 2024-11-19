/* Local variables */
locals {
  rg_name = var.rg

  address_vpc_hub_1 = {
    "${var.vpc_hub_1_zone_1}"   = ["${var.address_vpc_hub_1_1}"],
    "${var.vpc_hub_1_zone_2}"   = ["${var.address_vpc_hub_1_2}"],
    "${var.vpc_hub_1_region}-3" = []
  }

  address_vpc_hub_2 = {
    "${var.vpc_hub_2_zone_1}"   = ["${var.address_vpc_hub_2_1}"],
    "${var.vpc_hub_2_zone_2}"   = ["${var.address_vpc_hub_2_2}"],
    "${var.vpc_hub_2_region}-3" = []
  }

  bits_ahead_subnet_hub = 5
  hub_private_subnets   = ["ingress", "egress", "teste"]

  tg_name-1 = "TG_${var.tg_name}_1"
  tg_name-2 = "TG_${var.tg_name}_2"


  ibmcloud_api_key = var.ibmcloud_api_key

  tags = [
    "bra.app:plataforma",
    var.tag1,
  ]

  tgw_region = var.tg_region
}

/* Resource Group For CORE Networking resources */
data "ibm_resource_group" "resource_group_networking" {
  name = local.rg_name
}

/* Hub VPC */
module "vpc_hub_1" {
  # count             = local.deploy_hub_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = var.vpc_hub_name_1
  rg_id             = data.ibm_resource_group.resource_group_networking.id
  vpc_subnet        = local.address_vpc_hub_1
  bits_ahead_subnet = local.bits_ahead_subnet_hub
  ibmcloud_api_key  = local.ibmcloud_api_key
  tags              = local.tags
  address_prefixes  = local.address_vpc_hub_1
  private_subnets   = local.hub_private_subnets
  flow_logs         = false
}

module "vpc_hub_2" {
  # count             = local.deploy_hub_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = var.vpc_hub_name_2
  rg_id             = data.ibm_resource_group.resource_group_networking.id
  vpc_subnet        = local.address_vpc_hub_2
  bits_ahead_subnet = local.bits_ahead_subnet_hub
  ibmcloud_api_key  = local.ibmcloud_api_key
  tags              = local.tags
  address_prefixes  = local.address_vpc_hub_2
  private_subnets   = local.hub_private_subnets
  flow_logs         = false
}


/* Transit Gateway resource */
resource "ibm_tg_gateway" "new_tg_gw-1" {
  # count          = local.deploy_transit_gateway == true ? 1 : 0
  name           = local.tg_name-1
  location       = local.tgw_region
  global         = true
  resource_group = data.ibm_resource_group.resource_group_networking.id
  tags           = local.tags
}

resource "ibm_tg_gateway" "new_tg_gw-2" {
  # count          = local.deploy_transit_gateway == true ? 1 : 0
  name           = local.tg_name-2
  location       = local.tgw_region
  global         = true
  resource_group = data.ibm_resource_group.resource_group_networking.id
  tags           = local.tags
}






