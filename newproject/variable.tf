variable "vpc-cidr" {
  default     = "10.0.0.0/16"
  description = "vpc cidr"
}
variable "private-subnet-1-cidr" {
  default     = "10.0.1.0/24"
  description = "private subnet 1 cidr"
}
variable "public-subnet-1-cidr"{
    default = "10.0.2.0/24"
    description = "public-subnet-1-cidr"
} 
variable "private-subnet-2-cidr" {
  default     = "10.0.3.0/24"
  description = "private subnet 2 cidr"
}
#variable "database-snapshot-identifier" {
 # default     = "arn:aws:rds:ap-south-1:041042815388:cluster-snapshot:database-1-instance-1-final-snapshot"
  #description = "database snapshot arn"

#}

#ariable "database-instance-class" {
 #   default = "db.t2.micro"
  #  description = "" 
#}

variable "master_username" {
    default = "kunal"
    description = "username for me"
}

variable "master_password" {
    default = "pass22"
    description = "password for me"
}