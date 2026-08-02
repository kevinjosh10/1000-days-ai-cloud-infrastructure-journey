# 🚀 2-Week Terraform Mastery for Cloud Infrastructure Engineers

This guide is designed to take you from a beginner to an entry-level **Cloud Infrastructure Engineer** ready for production workloads. It focuses heavily on **theory, enterprise patterns, and state management**—the exact concepts asked in DevOps and Cloud Engineering interviews.

---

## 🛠️ Week 1: Foundations, HCL, and State Management

### **Day 1: The Infrastructure as Code (IaC) Paradigm**
*Understand why Terraform exists and how it communicates with the cloud.*
* **Concepts:** Imperative vs. Declarative IaC, Push vs. Pull models, Idempotency.
* **Architecture:** Terraform Core (CLI engine) vs. Terraform Providers (Plugins for AWS, Azure, etc.).
* **The Core Workflow:**
  * `terraform init` (Downloads provider binaries & initializes backends)
  * `terraform plan` (Creates an execution plan in memory)
  * `terraform apply` (Executes the plan via Cloud API calls)
  * `terraform destroy` (Tears down resources using the state file tracker)
* **Interview Prep:** "How does Terraform differ from Ansible or Chef?" (Ansible is imperative/configuration management; Terraform is declarative/provisioning).

### **Day 2: HCL Syntax & Data Flow**
*Mastering the HashiCorp Configuration Language.*
* **Input Variables (`variables.tf`):** Strings, numbers, lists, maps, and objects. Defining default values and `validation` blocks.
* **Local Values (`locals.tf`):** Computed values that reduce repetition (DRY). Unlike variables, they cannot be injected from the CLI.
* **Outputs (`outputs.tf`):** Extracting data from your deployment (e.g., getting the public IP of an EC2 instance after creation).
* **TFVARS Files:** Using `terraform.tfvars` or `-var-file` to inject environment-specific configurations.

### **Day 3: Resource Meta-Arguments**
*Controlling how resources are created.*
* **`depends_on`:** Explicitly forcing a dependency when Terraform cannot infer it (e.g., waiting for an IAM role policy to attach before launching EC2).
* **`count` vs `for_each`:**
  * `count`: Creates multiple identical resources (returns a list). Bad if the list order changes.
  * `for_each`: Creates resources from a map/set (returns a map). Safer for production since resources are keyed by string, not index.
* **`lifecycle`:** `create_before_destroy`, `prevent_destroy`, `ignore_changes` (preventing manual AWS console changes from being overridden).

### **Day 4: Querying the Cloud (Data Sources & Dynamic Blocks)**
*Making your code flexible across different AWS accounts.*
* **Data Sources (`data`):** Querying AWS for existing information (e.g., fetching the latest Amazon Linux 2 AMI ID automatically without hardcoding it).
* **Dynamic Blocks:** Programmatically generating nested blocks (like `ingress` or `egress` rules inside a Security Group) based on a variable list.

### **Day 5: State Management Deep Dive (Crucial for Interviews)**
*Terraform’s source of truth.*
* **What is `terraform.tfstate`?** A JSON file mapping your HCL code to real-world cloud resources.
* **The Problem with Local State:** Contains plaintext secrets, blocks team collaboration, and can be easily deleted.
* **Remote Backends:** Storing state centrally (e.g., AWS S3).
* **State Locking:** Using DynamoDB tables to lock the state file, preventing two engineers from running `terraform apply` simultaneously and corrupting the state.

### **Day 6: Advanced State Operations**
*Fixing broken infrastructure without causing an outage.*
* **`terraform state rm`:** Removing a resource from state (Terraform "forgets" it) without destroying it in AWS.
* **`terraform import`:** Bringing existing manually created AWS resources under Terraform management.
* **`terraform state mv`:** Renaming a resource in your code without destroying and recreating it.
* **`terraform taint` (Legacy) / `-replace`:** Forcing Terraform to destroy and recreate a specific resource on the next apply.

### **Day 7: Week 1 Milestone Architecture**
* **Project:** Deploy a highly available Virtual Private Cloud (VPC) spanning two Availability Zones.
* **Requirements:** Public/Private subnets, Internet Gateway, NAT Gateways, Route Tables, and a bastion host EC2 instance. All parameters (CIDR blocks, instance types) must be variable-driven.

---

## 🏗️ Week 2: Modules, Scaling, and Enterprise CI/CD

### **Day 8: Introduction to Modular Architecture**
*Writing DRY (Don't Repeat Yourself) code.*
* **Root Module vs. Child Module:** The folder where you run `apply` is the root; folders it calls are children.
* **Encapsulation:** Modules should be black boxes. You pass in variables, and it spits out outputs. You do not touch the resources inside directly.
* **Sourcing Modules:** Calling modules from local paths (`source = "../modules/vpc"`) or Git repositories (`source = "git::https://github.com/..."`).

### **Day 9: Building Standardized Modules**
*Designing for reuse.*
* Build a generic AWS RDS (Database) module.
* Ensure the module does not hardcode **anything**—VPC IDs, security group rules, and instance types must be passed in as variables.
* **Interview Prep:** "How do you handle secrets in Terraform?" (Never hardcode them. Use AWS Secrets Manager, SSM Parameter Store, or pass via environment variables like `TF_VAR_db_password`).

### **Day 10: Module Versioning & The Public Registry**
*Consuming enterprise code securely.*
* **The Terraform Registry:** Using pre-built community modules (e.g., `terraform-aws-modules/vpc/aws`).
* **Provider & Module Pinning:** Always specify versions using the pessimistic constraint operator (`~> 5.0`). Never use `latest` in production to avoid breaking API changes.
* **Git Tags:** Versioning your own internal company modules using standard Git releases (`v1.2.0`).

### **Day 11: Workspaces & Multi-Environment Strategies**
*Deploying to Dev, Staging, and Prod.*
* **Terraform Workspaces:** Allows multiple `.tfstate` files against the same codebase (e.g., `terraform workspace new prod`).
* **Workspace Caveats:** Great for identical environments (where dev/prod look exactly the same but have different instance sizes). Bad for completely separate architectures.
* **Directory Separation:** An alternative (and often preferred) method of having separate folders for `/dev`, `/staging`, and `/prod` relying on remote modules.

### **Day 12: Continuous Integration (CI) Automation**
*Validating code before it merges.*
* **`terraform fmt`:** Automatically formats your HCL code to HashiCorp's canonical style.
* **`terraform validate`:** Checks if your code is syntactically correct and internally consistent without hitting the cloud API.
* **GitHub Actions:** Building a `.github/workflows/terraform.yml` pipeline that runs `fmt` and `validate` on every Pull Request.
* **Plan in PR:** Automating `terraform plan` to output the expected changes directly as a comment on the GitHub PR.

### **Day 13: Enterprise Code Quality & Security**
*Failing the build if code is insecure.*
* **Static Analysis with `tflint`:** Finds potential errors, deprecated syntax, and unused declarations.
* **Security Scanning with `tfsec` or `checkov`:** Automatically fails your CI pipeline if you try to deploy an S3 bucket without encryption or an EC2 instance with an open SSH port (0.0.0.0/0).
* **Automated Docs:** Using `terraform-docs` to auto-generate `README.md` tables for your module variables and outputs.

### **Day 14: Final Capstone & Interview Readiness**
* **Project:** Combine your VPC, RDS, and Web-Tier modules into a single, cohesive 3-Tier Architecture via a root orchestration module. Apply it using Remote State (S3 + DynamoDB) and push it through a GitHub Actions CI pipeline.
* **Interview Prep Focus Areas:**
  1. Explain the lifecycle of a `terraform plan`.
  2. Explain how to recover a corrupted state file.
  3. Detail how you would structure a Terraform repository for a 50-person engineering team.
  4. Explain how to securely pass database passwords into an RDS module.

---

> 💡 **Entry-Level Advice:** If you can confidently discuss **Remote State Locking**, **`for_each` vs `count`**, **Module Encapsulation**, and **CI/CD Linting (`fmt`/`validate`/`tfsec`)**, you will stand out against 90% of junior candidates who only know how to run `terraform apply` locally.
