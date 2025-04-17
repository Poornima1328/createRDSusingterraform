resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow inbound MySQL traffic"
  vpc_id      = "vpc-013a1b862b8da3d91"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = ["subnet-089f883550bbc81aa", "subnet-0eb55c1b78e7372dd"]

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "my-rds-db"
  engine                 = "mysql"           
  instance_class         = "db.t3.micro"     
  allocated_storage      = 20            
  max_allocated_storage  = 100           
  username              = "adminuser"       
  password              = "YourSecurePassword1!"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  multi_az              = false        
  storage_type           = "gp2"
  backup_retention_period = 7            

  tags = {
    Name = "My RDS Instance"
  }
}
