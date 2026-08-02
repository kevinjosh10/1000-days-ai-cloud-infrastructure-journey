<!-- BEGIN_TF_DOCS -->
# AWS 3-Tier Architecture (Project 1)

This repository contains a complete, production-grade 3-Tier AWS Architecture orchestrated via independent, reusable Terraform modules.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/vpc | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ../../modules/alb | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | ../../modules/asg | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ../../modules/rds | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name (e.g., prod, dev) | `string` | `"prod"` | no |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_db_engine"></a> [db_engine](#input\_db\_engine) | The database engine to use (e.g., mysql) | `string` | `"mysql"` | no |
| <a name="input_db_instance_class"></a> [db_instance_class](#input\_db\_instance\_class) | The RDS instance class | `string` | `"db.t3.micro"` | no |
| <a name="input_db_name"></a> [db_name](#input\_db\_name) | The name of the primary database | `string` | `"appdb"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb_dns_name](#output\_alb\_dns\_name) | The DNS name of the Application Load Balancer |
| <a name="output_rds_endpoint"></a> [rds_endpoint](#output\_rds\_endpoint) | The connection endpoint for the RDS Multi-AZ database |
| <a name="output_vpc_id"></a> [vpc_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
