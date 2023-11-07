
# Create a AWS RDS_mysql

resource "aws_db_instance" "myrds" {
  allocated_storage   = 20
  storage_type        = "gp2"
  identifier          = "rdstf"
  engine              = "mysql"
  engine_version      = "8.0.33"
  instance_class      = "db.t3.micro" # Adjust instance class
  username            = "yotlaire"
  password            = "guilloux"
  publicly_accessible = false # Adjust as needed
  skip_final_snapshot = true    # Create final snapshot on deletion
  db_subnet_group_name = aws_db_subnet_group.my_subnet_group.name
  
  tags = {
    Name = "MyRDS"
  }
}
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-db-subnet-group"
  description = "My DB subnet group"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id] 
}

