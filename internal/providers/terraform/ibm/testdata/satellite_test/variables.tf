

#####################################################
# IBM Cloud Satellite -  AWS
# Copyright 2021 IBM
#####################################################

#################################################################################################
# IBMCLOUD & AWS -  Authentication , Target Variables.
# The region variable is common across zones used to setup VSI Infrastructure and Satellite host.
#################################################################################################

variable "TF_VERSION" {
  description = "terraform version"
  type        = string
  default     = "0.13"
}

variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key"
  type        = string
  default = "test"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default = "test"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default = "test"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "resource_group" {
  description = "Name of the resource group on which location has to be created"
  default = "default"

  validation {
    condition     = var.resource_group != ""
    error_message = "Sorry, please provide value for resource_group variable."
  }
}

##################################################
# IBMCLOUD Satellite Location Variables
##################################################

variable "location" {
  description = "Location Name"
  default     = "satellite-aws"

  validation {
    condition     = var.location != "" && length(var.location) <= 32
    error_message = "Sorry, please provide value for location_name variable or check the length of name it should be less than 32 chars."
  }
}

variable "is_location_exist" {
  description = "Determines if the location has to be created or not"
  type        = bool
  default     = false
}

variable "managed_from" {
  description = "The IBM Cloud region to manage your Satellite location from. Choose a region close to your on-prem data center for better performance."
  type        = string
  default     = "wdc"
}

variable "location_zones" {
  description = "Allocate your hosts across these three zones"
  type        = list(string)
  default     = []
}

variable "location_bucket" {
  description = "COS bucket name"
  default     = null
}

variable "host_labels" {
  description = "Labels to add to attach host script"
  type        = list(string)
  default     = ["env:prod"]

  validation {
    condition     = can([for s in var.host_labels : regex("^[a-zA-Z0-9:]+$", s)])
    error_message = "Label must be of the form `key:value`."
  }
}

variable "host_provider" {
  description = "The cloud provider of host|vms"
  type        = string
  default     = "aws"
}

##################################################
# AWS Host Variables
##################################################

variable "satellite_host_count" {
  description = "The total number of AWS host to create for control plane. satellite_host_count value should always be in multiples of 3, such as 3, 6, 9, or 12 hosts"
  type        = number
  default     = 3
  validation {
    condition     = (var.satellite_host_count % 3) == 0 && var.satellite_host_count > 0
    error_message = "Sorry, host_count value should always be in multiples of 3, such as 6, 9, or 12 hosts."
  }
}

variable "addl_host_count" {
  description = "The total number of additional aws host"
  type        = number
  default     = 3
}

variable "location_instance_type" {
  description = "The type of aws instance to create"
  type        = string
  default     = "m5d.xlarge"
}

variable "cluster_instance_type" {
  description = "The type of aws instance to create"
  type        = string
  default     = "m5d.xlarge"
}

variable "ssh_public_key" {
  description = "SSH Public Key. Get your ssh key by running `ssh-key-gen` command"
  type        = string
  default     = null
}

variable "resource_prefix" {
  description = "Name to be used on all aws resource as prefix"
  type        = string
  default     = "satellite-aws"

  validation {
    condition     = var.resource_prefix != "" && length(var.resource_prefix) <= 25
    error_message = "Sorry, please provide value for resource_prefix variable or check the length of resource_prefix it should be less than 25 chars."
  }
}

##################################################
# IBMCLOUD ROKS Cluster Variables
##################################################

variable "create_cluster" {
  description = "Create Cluster"
  type        = bool
  default     = true
}

variable "cluster" {
  description = "Cluster name"
  type        = string
  default     = "satellite-ibm-cluster"

  validation {
    error_message = "Cluster name must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.cluster))
  }
}

variable "kube_version" {
  description = "Satellite Kube Version"
  default     = "4.7_openshift"
}

variable "cluster_host_labels" {
  description = "Labels to add to attach host script"
  type        = list(string)
  default     = ["env:prod"]

  validation {
    condition     = can([for s in var.cluster_host_labels : regex("^[a-zA-Z0-9:]+$", s)])
    error_message = "Label must be of the form `key:value`."
  }
}

variable "worker_count" {
  description = "Worker Count for default pool"
  type        = number
  default     = 1
}

variable "wait_for_worker_update" {
  description = "Wait for worker update"
  type        = bool
  default     = true
}

variable "default_worker_pool_labels" {
  description = "Label to add default worker pool"
  type        = map(any)
  default     = null
}

variable "tags" {
  description = "List of tags associated with cluster."
  type        = list(string)
  default     = null
}

variable "create_timeout" {
  type        = string
  description = "Timeout duration for create."
  default     = null
}

variable "update_timeout" {
  type        = string
  description = "Timeout duration for update."
  default     = null
}

variable "delete_timeout" {
  type        = string
  description = "Timeout duration for delete."
  default     = null
}

