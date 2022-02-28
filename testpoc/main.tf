
####resource "aws_vpc" "tfvpc" {
 # cidr_block = var.cidr
 # tags = {
 #   "Name" = "tfvpc"
 #}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "testvpcks"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.4.0/24"]

 

  tags = {
      Name = "kunal"
    Terraform = "true"
    Environment = "dev"
  }
}
resource "aws_rds_cluster" "aurora_cluster" {
     count = 1  
  engine                          ="aurora-postgresql"
  engine_version                  = "10.14"
  engine_mode                       = "serverless"
  cluster_identifier              = "ksdb"
  master_username                 = "kunal"
  master_password                 = "kunall12345"
  skip_final_snapshot             =  true
  //vpc_security_group_ids            = module.security_group.vpc_security_group_id
  db_subnet_group_name            = "default"
  scaling_configuration {
    auto_pause   = true
    max_capacity = "4"
    min_capacity = "2"
  }
  tags = {
    "name" = "demokunal"
  }
 
    lifecycle {
    create_before_destroy = true
  }
 
 }
