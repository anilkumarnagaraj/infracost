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

resource "ibm_cloudant" "ibm_cloudant" {
  name     = "cloudant-service-name"
  location = "us-south"
  plan     = "standard"

  legacy_credentials  = true
  include_data_events = false
  capacity            = 1
  enable_cors         = true

  cors_config {
    allow_credentials = false
    origins           = ["https://example.com"]
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}


resource "ibm_cloudant" "cloudant_lite" {
  name     = "cloudant-service-name"
  location = "us-south"
  plan     = "lite"

  legacy_credentials  = true
  include_data_events = false
  capacity            = 1
  enable_cors         = true

  cors_config {
    allow_credentials = false
    origins           = ["https://example.com"]
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}