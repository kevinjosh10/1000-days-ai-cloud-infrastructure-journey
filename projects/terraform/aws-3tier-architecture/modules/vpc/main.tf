data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "vpc_cidr" {
  name = "/prod/vpc/cidr"
}

resource "aws_vpc" "this" {
  cidr_block           = data.aws_ssm_parameter.vpc_cidr.value
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "project1-vpc" }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-${count.index + 1}" }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = { Name = "private-subnet-${count.index + 1}" }
}
