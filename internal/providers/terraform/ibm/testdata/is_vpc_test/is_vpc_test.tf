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

resource "ibm_is_vpc" "example" {
  name = "example-vpc"
}