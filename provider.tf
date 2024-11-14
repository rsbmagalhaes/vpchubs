terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.30.0"
    }
  }
}

provider "ibm" {
  region           = "us-south"
  ibmcloud_api_key = var.ibmcloud_api_key
}
