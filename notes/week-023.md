# Week 23 Notes: Advanced Terraform & GitOps Automation

## 1. Advanced Data Sources & Dynamic Config
* **The Problem:** Hardcoding values like `us-east-1a` or AMI IDs (`ami-0abc123`) breaks when you deploy to new regions or when AMIs get updated.
* **The Solution:** Use Data Sources to query AWS at runtime.
  * `data "aws_availability_zones"`: Dynamically grabs available AZs.
  * `data "aws_ssm_parameter"`: Fetches the latest Amazon Linux 2023 AMI directly from AWS's public parameter store.
  * `data "aws_caller_identity"`: Grabs the current AWS Account ID.

## 2. Terragrunt (DRY Terraform)
* **The Problem:** In native Terraform, every environment (dev, staging, prod) requires you to copy-paste the `backend` and `provider` blocks.
* **The Solution:** Terragrunt uses a root `terragrunt.hcl` file.
  * Child modules use `include` to inherit the root config automatically.
  * **Dependencies:** Instead of messy `terraform_remote_state` blocks, Terragrunt uses `dependency "vpc" { config_path = "../vpc" }` to automatically pass VPC outputs directly into the ALB module's inputs.

## 3. Infrastructure Testing (Terratest)
* Written in **Golang**.
* **Workflow:** 
  1. `terraform.InitAndApply()`
  2. Run assertions (e.g., `assert.NotNil(t, vpc_id)`)
  3. Guarantee cleanup using `defer terraform.Destroy()`
* Tests are run in GitHub Actions to block broken infrastructure from merging.

## 4. Policy as Code (OPA & Sentinel)
* Replaces human documentation with machine-enforced compliance rules.
* **Open Policy Agent (OPA):** Open-source, uses the **Rego** language.
  * You run `terraform plan -out=plan.out`, convert it to JSON, and run `conftest test plan.json`.
  * If a developer forgets to encrypt an S3 bucket, OPA returns a non-zero exit code and fails the CI/CD pipeline instantly.
* **Sentinel:** HashiCorp's proprietary alternative for Terraform Cloud. Uses a more English-like syntax.

## 5. Refactoring Legacy Infrastructure & Import
* **The 4-Step Import:**
  1. Write empty HCL resource block.
  2. Run `terraform import <address> <aws_id>`.
  3. Run `terraform plan` and update HCL until drift is exactly zero.
  4. Run `terraform apply` (no-op).
* **The `moved` block:** Introduced in TF 1.1. Allows you to declaratively rename resources or move them into modules without Terraform destroying the actual AWS resource. Far safer than the old imperative `terraform state mv` CLI command.
* **Drift Detection:** `terraform plan -refresh-only` compares AWS reality to the state file without proposing destructive actions.

## 6. Team Workflows & Terraform Cloud (TFC)
* **Never run `apply` on a laptop.** Use centralized remote execution.
* **TFC Workspaces:** Store AWS Credentials securely as Environment Variables.
* **VCS Integration (GitOps):**
  * Open PR ➡️ TFC runs a *Speculative Plan* and comments on the PR.
  * Human reviews the plan and approves.
  * Merge to `main` ➡️ TFC automatically runs `apply`.
* **Atlantis:** The open-source, self-hosted alternative. Uses comment-driven automation (`atlantis plan` and `atlantis apply` inside GitHub PR comments).
