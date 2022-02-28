terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aws" {
  region = local.region
  profile = "kunal"
}

locals {
  name   = "Ktest"//${replace(basename(path.cwd), "_", "-")}"
  region = "ap-south-1"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# Supporting Resources
################################################################################

resource "random_password" "master" {
  length = 10
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  tags = local.tags
}

################################################################################
# RDS Aurora Module
################################################################################

module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  engine         = "aurora-postgresql"
  engine_version = "10.14"
  engine_mode = "serverless"
  instance_class = "db.t3.micro"
  instances = {
    1 = {
    }
    2 = {
    }
    3 = {
    }
  }
   autoscaling_enabled      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  endpoints = {
    static = {
      identifier     = "static-custom-endpt"
      type           = "ANY"
      static_members = ["static-member-1"]
      tags           = { Endpoint = "static-members" }
    }
    excluded = {
      identifier       = "excluded-custom-endpt"
      type             = "READER"
      excluded_members = ["excluded-member-1"]
      tags             = { Endpoint = "excluded-members" }
    }
  }

  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  create_db_subnet_group = true
  create_security_group  = true
  allowed_cidr_blocks    = module.vpc.private_subnets_cidr_blocks
  security_group_egress_rules = {
    to_cidrs = {
      cidr_blocks = ["10.0.0.0/28"]
      description = "Egress to corporate printer closet"
    }
  }

  iam_database_authentication_enabled = true
  master_password                     = random_password.master.result
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.vpc.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.Ktest.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = local.tags
}
output "this_password_as_json" {
  value = jsonencode({ "password" = random_password.master.result})
  sensitive = true
}