resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.db_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.allowed_security_group_id]
  }
}

resource "aws_db_instance" "this" {
  identifier             = var.db_name
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = "admin"
  password               = "SuperSecret123!"
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  multi_az               = true
}
