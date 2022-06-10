terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.42.0-beta0"
    }
  }
}

provider "ibm" {
  # Configuration options
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


module "satellite-aws" {
  #source = "/Users/anilkumarnagaraj/go/src/github.com/IBM-Cloud/infracost/internal/providers/terraform/ibm/testdata/cloudant_test/modules/satellite"
  source = "git::git@github.com:terraform-ibm-modules/terraform-ibm-satellite-aws.git"

  for_each                   = toset(["sat01", "sat02"])
  ibmcloud_api_key           = ""
  aws_region                 = "us-east-1"
  aws_access_key             = ""
  aws_secret_key             = ""
  resource_group             = "default"
  is_location_exist          = false
  location                   = "tf-satellite-${each.key}"
  #location                  = "tf-satellite-01"
  managed_from               = "wdc"
  location_zones             = ["zone-1", "zone-2", "zone-3"]
  host_labels                = ["env:dev"]
  host_provider              = "aws"
  create_cluster             = false
  cluster                    = "cluster01"
  cluster_host_labels        = ["env:dev"]
  create_timeout             = null
  update_timeout             = null
  delete_timeout             = null
}