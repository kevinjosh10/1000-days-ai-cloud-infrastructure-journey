# 📝 Week 22 Notes: Enterprise Terraform & Modular Architecture

## 1. Modular Infrastructure as Code
A Terraform module is simply a folder containing `.tf` files. The root directory where you run `terraform apply` is the **root module**. When it calls other directories, they are **child modules**.

**Key Principles:**
- **DRY (Don't Repeat Yourself):** Extract repeated patterns (e.g., standard VPC configurations, hardened RDS clusters) into centralized modules.
- **Encapsulation:** Modules should expose inputs (`variables.tf`) and outputs (`outputs.tf`), completely abstracting the complexity of the underlying resources.

## 2. Advanced State Management
- **Workspaces:** Allow multiple state files for a single backend configuration (e.g., `dev`, `staging`, `prod`). Best for identical environments.
- **Module Composition:** Passing the outputs of one module directly into the inputs of another.

```hcl
module "vpc" {
  source = "../../modules/vpc"
}

module "rds" {
  source = "../../modules/rds"
  vpc_id = module.vpc.vpc_id
}
```

## 3. Best Practices for Production
- **Provider Pinning:** Always specify exactly which version of the `hashicorp/aws` provider your module is compatible with using the Pessimistic Constraint Operator (`~>`).
- **Semantic Versioning (SemVer):** Tag releases of your infrastructure code (e.g., `v1.0.0`). Consume remote modules using these tags to prevent breaking changes.
- **Continuous Integration (CI):** Enforce `terraform fmt` and `terraform validate` in GitHub Actions for all pull requests.
