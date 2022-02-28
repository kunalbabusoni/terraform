# creating vpc
# terraform aws create vpc
resource "aws_vpc" "vpc" {
    cidr_block       = "${var.vpc-cidr}"
    instance_tenancy =  "default"
    enable_dns_hostnames = true
    tags = {
        Name = "Test vpc"
    }
}

# creating a internetgay and attaching to vpc
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "test Igw"
  }
}
 
# creating a private subnet 1
resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = "${var.private-subnet-1-cidr}"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
} 

# creating a public subnet 1
resource "aws_subnet" "public-subnet1"{
    vpc_id = aws_vpc.vpc.id
    cidr_block = "${var.public-subnet-1-cidr}"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = "true"
}
# creating a private subnet 2
resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = "${var.private-subnet-2-cidr}"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = false
}  

# creating a route table & add public route 
resource "aws_route_table" "public-route-table" {
  vpc_id                  = aws_vpc.vpc.id
  route{
      cidr_block          = "0.0.0.0/0"
      gateway_id          = aws_internet_gateway.internet-gateway.id
      }
    tags = {
        Name ="public routtable"
    }
} 

# creating security group
resource "aws_security_group" "testsg" {
  name = "sg-rds"
  vpc_id = aws_vpc.vpc.id
  description = "for aurora"
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
