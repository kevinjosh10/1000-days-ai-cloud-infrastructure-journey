# Week 23 Notes: Terraform III — Advanced Patterns, Terragrunt & Testing

## Overview
This week bridges the gap between Junior and Senior Infrastructure Engineering. We are moving away from writing simple HCL modules and moving toward Enterprise Configuration Management.

## Key Concepts

### Advanced Data Sources
* Data sources (`data "aws_..."`) act as read-only API calls to AWS during the `terraform plan` and `apply` phases.
* **Portability:** Hardcoding values like AMI IDs, region names, or Availability Zones guarantees your code will break if deployed to a new region. Using `data.aws_region.current.name` or `data.aws_availability_zones.available.names` makes modules context-aware and globally portable.
* **Security:** Instead of passing secrets (like DB passwords) in as Terraform variables (which might get logged in CI/CD), use `data "aws_ssm_parameter"` or `data "aws_secretsmanager_secret_version"` to pull them securely from AWS at runtime.

### Dynamic Blocks
* Resource blocks like AWS Security Groups often require repeating nested blocks (e.g., 5 `ingress` rules).
* Instead of copying the `ingress { ... }` block 5 times, a `dynamic "ingress"` block allows you to loop over a list of variables and programmatically construct the nested blocks, drastically shrinking your codebase.

### Terragrunt
* A thin wrapper for Terraform that provides extra tools for keeping configurations DRY (Don't Repeat Yourself), managing remote state, and working with multiple Terraform modules.
* It replaces repetitive backend configurations and module source declarations with a centralized `terragrunt.hcl` file.

### Infrastructure Testing (Terratest)
* Written in Go, Terratest actually deploys your infrastructure to a sandbox AWS account, runs assertions against it (e.g., "Can I curl the ALB endpoint?"), and then runs `terraform destroy`.
* It is the gold standard for testing infrastructure modules before they are merged into the main branch.

### Policy as Code (Sentinel / OPA)
* Enforcing compliance rules programmatically. E.g., a policy that instantly fails `terraform plan` if an S3 bucket does not have encryption enabled, or if an EC2 instance is larger than a `t3.medium`.
