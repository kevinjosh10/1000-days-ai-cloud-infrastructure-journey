# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-02
### Added
- Complete 3-Tier AWS Architecture orchestration (`environments/prod/main.tf`).
- Dedicated `vpc` module supporting public/private subnets, NAT Gateways, and IGW.
- Dedicated `rds` module for Multi-AZ MySQL databases with strict Security Group chaining.
- Dedicated `alb` module for application load balancing.
- Dedicated `asg` module with dynamic `aws_ami` lookups and launch templates.
- Strict provider version pinning (`~> 5.0`) via `versions.tf`.
- GitHub Actions CI/CD pipeline (`.github/workflows/terraform.yml`) for `terraform fmt` and `terraform validate`.
- `TERRAFORM.md` auto-generated documentation.

### Changed
- Refactored all hardcoded values into dynamic data sources and variables.
- Standardized tagging across all resources (`Environment`, `Project`, `ManagedBy`).

### Security
- Enforced Zero-Trust networking: RDS only accepts traffic from ASG Security Group.
