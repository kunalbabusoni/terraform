#creating database subnet group
#terraform aws db subnet group
resource "aws_db_subnet_group" "databasesubnetgroup" {
  name = "database subnets"
  subnet_ids = [aws_subnet.private-subnet2.id,aws_subnet.private-subnet1.id ]
  description = "subnet for database instance"
  tags = {
    "Name" = "Database subnets"
  }
}

#get the latest db snapshot 
#terraform aws data db snapshot
#data "aws_db_snapshot" "lastest_db_snapshot"{
 #   db_snapshot_identifier ="${var.database-snapshot-identifier}"
  #   most_recent = true
   #  snapshot_type = "manual"
#}

resource "aws_rds_cluster" "database-instance" {
  engine = "aurora-postgresql"
  engine_version = "10.14"
  cluster_identifier      = "test-db-instance"
  engine_mode          = "serverless"
  availability_zones      = ["ap-south-1a"]
  database_name           = "testkunal"
  master_username         = "${var.master_username}"
  master_password         = "${var.master_password}"
  backup_retention_period = 5
   skip_final_snapshot  = true
   db_subnet_group_name = aws_db_subnet_group.databasesubnetgroup.name
   port = "5432"
   vpc_security_group_ids = [aws_security_group.testsg.id]
  scaling_configuration {
    auto_pause   = true
    max_capacity = "4"
    min_capacity = "2"
  }
    }

#creating redshift cluster
resource "aws_redshift_cluster" "redshiftclusteraurora" {
    
  
}