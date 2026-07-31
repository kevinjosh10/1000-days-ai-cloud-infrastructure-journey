variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "allowed_security_group_id" { type = string }
variable "db_engine" { type = string, default = "mysql" }
variable "db_instance_class" { type = string, default = "db.t3.micro" }
variable "db_name" { type = string }
