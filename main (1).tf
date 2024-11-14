/* Local variables */
locals {
  bgp_asn          = 65300
  bgp_dl01         = "172.21.223.129/30"
  bgp_dl02         = "172.21.223.130/30"
  rg_name          = var.rg
  dl_global        = true
  dl_metered       = true
  dl_name          = "DL_DITI_${var.solution_name}"
  dl_speed         = 10000
  dl_customer_name = var.direct_link_customer_name
  dl_carrier_name  = "Ascenty"
  vpc_hub_name_1     = "vpc-diti-core-hub-1"
  vpc_hub_name_2    = "vpc-diti-core-hub-2"
  vpc_service_name = "vpc-diti-core-shared2"
  vpc_corp_ti_name = "vpc-corp-ti"
  address_range    = var.address_range

  address_vpc_hub_1 = {
    "us-south-1" = ["192.168.192.0/20"],
    "us-south-2" = ["192.168.208.0/20"],
    "us-south-3" = []
  }

   address_vpc_hub_2= {
    "us-south-1" = ["193.168.192.0/20"],
    "us-south-2" = ["193.168.208.0/20"],
    "us-south-3" = []
  }

  bits_ahead_subnet_hub = 5
  hub_private_subnets   = ["ingress", "egress", "teste"]

  routing_tables_vpc_hub = {
    "us-south-1" = [],
    "us-south-2" = [],
    "us-south-3" = []
  }

  routing_tables_service_hub = {
    "us-south-1" = [
      "192.168.192.0/20-->172.21.192.1",
      "10.0.0.0/8-->172.21.192.1"
    ],
    "us-south-2" = [
      "192.168.192.0/20-->172.21.208.1",
      "10.0.0.0/8-->172.21.208.1"
    ],
    "us-south-3" = []
  }

  routing_tables_corp_ti_hub = {
    "us-south-1" = [
      "192.168.192.0/20-->172.21.192.1",
      "10.0.0.0/8-->172.21.192.1"
    ],
    "us-south-2" = [
      "192.168.192.0/20-->172.21.208.1",
      "10.0.0.0/8-->172.21.208.1"
    ],
    "us-south-3" = []
  }

  address_vpc_service = {
    "us-south-1" = ["192.168.194.0/24"],
    "us-south-2" = ["192.168.210.0/24"],
    "us-south-3" = []
  }
  service_private_subnets = ["shared-prod-sbnt", "shared-nprod-sbnt"]


  bits_ahead_subnet_service = 1

  address_vpc_corp_ti = {
    "us-south-1" = ["192.168.196.0/24"],
    "us-south-2" = ["192.168.212.0/24"],
    "us-south-3" = []
  }
  corp_ti_private_subnets = ["corp-ti-prod-sbnt", "corp-ti-nprod-sbnt"]


  bits_ahead_subnet_corp_ti = 1
  tg_name-1                   = "TG_${var.solution_name}_1"
  tg_name-2                   = "TG_${var.solution_name}_2"


  ibmcloud_api_key = var.ibmcloud_api_key

  tags = [
    "bra.app:plataforma",
    var.tag1,
  ]

  deploy_direct_links    = false
  deploy_hub_vpc         = true
  deploy_services_vpc    = true
  deploy_corp_ti_vpc     = true
  deploy_firewall        = false
  deploy_transit_gateway = true

  region = var.region
}

/* Resource Group For CORE Networking resources */
data "ibm_resource_group" "resource_group_networking" {
  name = local.rg_name
}

/* Data source to get XCR routers */
#  data "ibm_dl_routers" "dl_routers" {
#      offering_type = "dedicated"
#      location_name = "sao01"
#  }


/* Hub VPC */
module "vpc_hub_1" {
  count             = local.deploy_hub_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = local.vpc_hub_name_1
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
  count             = local.deploy_hub_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = local.vpc_hub_name_2
  rg_id             = data.ibm_resource_group.resource_group_networking.id
  vpc_subnet        = local.address_vpc_hub_2
  bits_ahead_subnet = local.bits_ahead_subnet_hub
  ibmcloud_api_key  = local.ibmcloud_api_key
  tags              = local.tags
  address_prefixes  = local.address_vpc_hub_2
  private_subnets   = local.hub_private_subnets
  flow_logs         = false
}


/* Shared Services VPC */
module "vpc_services" {
  count             = local.deploy_services_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = local.vpc_service_name
  rg_id             = data.ibm_resource_group.resource_group_networking.id
  vpc_subnet        = local.address_vpc_service
  bits_ahead_subnet = local.bits_ahead_subnet_service
  ibmcloud_api_key  = local.ibmcloud_api_key
  address_prefixes  = local.address_vpc_service
  tags              = local.tags
  private_subnets   = local.service_private_subnets
  routing_tables    = local.routing_tables_service_hub
  flow_logs         = false
  #cos_instance="cos-flow-logs"
  #cos_bucket="vpc-flow-logs-teste"
  #cos_resource_group_id = "GR_Bradesco_Hub_PoC"
}

/* CORP-TI VPC */
module "vpc_corp_ti" {
  count             = local.deploy_corp_ti_vpc == true ? 1 : 0
  source            = "github.com/rsbmagalhaes/terraform-templates/ibmcloud-vpc"
  vpc_name          = local.vpc_corp_ti_name
  rg_id             = data.ibm_resource_group.resource_group_networking.id
  vpc_subnet        = local.address_vpc_corp_ti
  bits_ahead_subnet = local.bits_ahead_subnet_corp_ti
  ibmcloud_api_key  = local.ibmcloud_api_key
  tags              = local.tags
  address_prefixes  = local.address_vpc_corp_ti
  private_subnets   = local.corp_ti_private_subnets
  flow_logs         = false
  #cos_instance="cos-flow-logs"
  #cos_bucket="vpc-flow-logs-teste"
  #cos_resource_group_id = "GR_Bradesco_Hub_PoC"
}


/* Transit Gateway resource */
resource "ibm_tg_gateway" "new_tg_gw-1" {
  # count          = local.deploy_transit_gateway == true ? 1 : 0
  name           = local.tg_name-1
  location       = local.region
  global         = true
  resource_group = data.ibm_resource_group.resource_group_networking.id
  tags           = local.tags
}

resource "ibm_tg_gateway" "new_tg_gw-2" {
  # count          = local.deploy_transit_gateway == true ? 1 : 0
  name           = local.tg_name-2
  location       = local.region
  global         = true
  resource_group = data.ibm_resource_group.resource_group_networking.id
  tags           = local.tags
}

/* Transit Gateway VPC connections */

# // Services VPC
# resource "ibm_tg_connection" "tg_to_services_vpc" {
#   count        = local.deploy_transit_gateway == true && local.deploy_services_vpc == true ? 1 : 0
#   gateway      = ibm_tg_gateway.new_tg_gw[0].id
#   network_type = "vpc"
#   name         = "TG_X_${local.vpc_hub_name}"
#   network_id   = module.vpc_services[0].vpc_crn
# }

# // Hub VPC
# resource "ibm_tg_connection" "tg_to_hub_vpc" {
#   count        = local.deploy_transit_gateway == true && local.deploy_hub_vpc == true ? 1 : 0
#   gateway      = ibm_tg_gateway.new_tg_gw[0].id
#   network_type = "vpc"
#   name         = "TG_X_${local.vpc_service_name}"
#   network_id   = module.vpc_hub[0].vpc_crn
# }

# // CORP_TI VPC
# resource "ibm_tg_connection" "tg_to_corp_ti_vpc" {
#   count        = local.deploy_transit_gateway == true && local.deploy_corp_ti_vpc == true ? 1 : 0
#   gateway      = ibm_tg_gateway.new_tg_gw[0].id
#   network_type = "vpc"
#   name         = "TG_X_${local.vpc_corp_ti_name}"
#   network_id   = module.vpc_corp_ti[0].vpc_crn
# }

 




