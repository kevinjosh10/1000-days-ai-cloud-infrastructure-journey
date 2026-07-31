# Terraform AWS 3-Tier Architecture

This repository contains a full production-grade AWS infrastructure deployed via Terraform module composition.

## Architecture
- **Layer 1:** Custom VPC Module (Public/Private Subnets, IGW)
- **Layer 2:** Security Group Chaining (Internet -> ALB -> ASG -> RDS)
- **Layer 3:** Compute (ASG via Launch Templates, ALB)
- **Layer 4:** Persistence (Multi-AZ MySQL RDS)

## Deployment
```bash
cd environments/prod
terraform init
terraform apply
```
