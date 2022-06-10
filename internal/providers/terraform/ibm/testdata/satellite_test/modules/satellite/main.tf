
###################################################################
# Get the details about a specific availability zone (AZ) in the current region.
###################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

###################################################################
# Create satellite location
###################################################################
module "satellite-location" {
  source = "terraform-ibm-modules/satellite/ibm//modules/location"

  is_location_exist = var.is_location_exist
  location          = var.location
  managed_from      = var.managed_from
  location_zones    = var.location_zones
  location_bucket   = var.location_bucket
  host_labels       = var.host_labels
  resource_group    = var.resource_group
  host_provider     = "aws"
}

###################################################################
# Create AWS VPC
###################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.resource_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs                = var.location_zones
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_ipv6        = true
  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = var.resource_prefix
  }

  tags = {
    ibm-satellite = var.resource_prefix
  }

  vpc_tags = {
    Name = var.resource_prefix
  }
}

###################################################################
# Get the ID of a registered AMI
###################################################################
data "aws_ami" "redhat_linux" {
  owners = ["309956199498"]

  filter {
    name = "name"

    values = [
      "RHEL-7.7_HVM_GA-20190723-x86_64-1-Hourly2-GP2",
    ]
  }
}

###################################################################
# provision security group rules
###################################################################
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.resource_prefix}-sg"
  description = "Security group for satellite usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  tags = {
    ibm-satellite = var.resource_prefix
  }

  ingress_with_cidr_blocks = [
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "udp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP TCP"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_with_self = [
    {
      from_port = 0
      to_port   = 0
      protocol  = -1
      self      = true
    },
  ]

}

###################################################################
# provision placement group
###################################################################
resource "aws_placement_group" "satellite-group" {
  name     = "${var.resource_prefix}-pg"
  strategy = "spread"

  tags = {
    ibm-satellite = var.resource_prefix
  }

}

###################################################################
# provision SSH private key
###################################################################
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

###################################################################
# provision SSH key
###################################################################
resource "aws_key_pair" "keypair" {
  key_name   = "${var.resource_prefix}-ssh"
  public_key = var.ssh_public_key != null ? var.ssh_public_key : tls_private_key.example.public_key_openssh

  tags = {
    ibm-satellite = var.resource_prefix
  }

}

###################################################################
# Provision AWS EC2 host for control plane
###################################################################
module "satellite-location-ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.21.0"

  instance_count              = var.satellite_host_count
  name                        = "${var.resource_prefix}-location-host"
  use_num_suffix              = true
  ami                         = data.aws_ami.redhat_linux.id
  instance_type               = var.location_instance_type
  key_name                    = aws_key_pair.keypair.key_name
  subnet_ids                  = module.vpc.public_subnets
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  placement_group             = aws_placement_group.satellite-group.id
  user_data                   = module.satellite-location.host_script

  tags = {
    ibm-satellite = var.resource_prefix
  }

}

###################################################################
# Provision AWS EC2 host for satellite ROKS cluster
###################################################################
module "satellite-cluster-ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.21.0"

  instance_count              = var.addl_host_count
  name                        = "${var.resource_prefix}-cluster-host"
  use_num_suffix              = true
  ami                         = data.aws_ami.redhat_linux.id
  instance_type               = var.cluster_instance_type
  key_name                    = aws_key_pair.keypair.key_name
  subnet_ids                  = module.vpc.public_subnets
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  placement_group             = aws_placement_group.satellite-group.id
  user_data                   = module.satellite-location.host_script

  tags = {
    ibm-satellite = var.resource_prefix
  }

}
