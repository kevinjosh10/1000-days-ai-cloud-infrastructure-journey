# 🚀 The Ultimate 2-Week Terraform Mastery Guide

This document is an extremely detailed, day-by-day deep dive into Terraform. It is designed to take you from absolute beginner to an **Entry-Level Cloud Infrastructure Engineer** capable of deploying, managing, and scaling enterprise-grade infrastructure.

---

## 🛠️ Week 1: Foundations, HCL, and State Management

### **Day 1: The Infrastructure as Code (IaC) Paradigm**

#### 🧠 Concept Breakdown
Infrastructure as Code (IaC) is the process of managing and provisioning computing data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools (like the AWS Console).
Terraform uses a **Declarative** approach: you declare *what* you want the end state to look like, and Terraform figures out *how* to achieve it via Cloud APIs.

#### ⚙️ The Core Architecture
1. **Terraform Core:** The compiled binary that reads your `.tf` files, builds a dependency graph, and compares your desired state to the current state (stored in `terraform.tfstate`).
2. **Providers:** Plugins downloaded by Terraform (e.g., AWS, Azure, GCP) that contain the logic to interact with specific APIs.

#### 💻 The Core Workflow
```bash
# 1. Initialize the working directory, download provider plugins, and set up the backend.
terraform init

# 2. Format your code to HashiCorp canonical standards.
terraform fmt

# 3. Validate syntax without calling cloud APIs.
terraform validate

# 4. Create an execution plan (dry run). Highly recommended to output this to a file in CI/CD.
terraform plan -out=tfplan

# 5. Execute the plan to provision resources.
terraform apply "tfplan"

# 6. Tear down everything managed by the state file.
terraform destroy
```

#### 🎯 Enterprise Best Practice
Never run `terraform apply` locally in production. Always run it through a centralized CI/CD pipeline (like GitHub Actions) so that every change is peer-reviewed, linted, and logged.

#### 🎤 Interview Preparation
* **Q:** What is the difference between Terraform and Ansible?
* **A:** Ansible is an imperative Configuration Management tool (designed to install software on existing servers). Terraform is a declarative Provisioning tool (designed to create the servers, networks, and databases themselves).

---

### **Day 2: HCL Syntax & Data Flow**

#### 🧠 Concept Breakdown
The HashiCorp Configuration Language (HCL) is designed to be human-readable. The core building blocks of data flow are Variables (inputs), Locals (computed constants), and Outputs (returned data).

#### 💻 Code Example
```hcl
# variables.tf - What the user provides
variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# locals.tf - What we compute internally (DRY)
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Alpha"
  }
  name_prefix = "${var.environment}-app"
}

# main.tf - The actual resource
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "${local.name_prefix}-vpc" })
}

# outputs.tf - What we expose after creation
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}
```

#### 🎯 Enterprise Best Practice
Keep variables, locals, outputs, and resources in separate files (`variables.tf`, `locals.tf`, `outputs.tf`, `main.tf`). Use `terraform.tfvars` or `*.auto.tfvars` to pass environment-specific values without hardcoding them in the main code.

#### 🎤 Interview Preparation
* **Q:** When would you use a `local` instead of a `variable`?
* **A:** Use `variable` for values passed in from the outside (like region or instance size). Use `local` for values computed inside the module that you don't want the user to override, preventing repetition.

---

### **Day 3: Resource Meta-Arguments**

#### 🧠 Concept Breakdown
Meta-arguments change the fundamental behavior of how Terraform provisions a resource.

1. **`depends_on`:** Terraform automatically builds a dependency graph. If Resource B references Resource A's ID, Terraform knows to build A first. However, sometimes dependencies are hidden (e.g., an EC2 instance needing an IAM role policy to attach before it can boot). `depends_on` forces this ordering.
2. **`count` vs `for_each`:**
   * `count` creates a list (`aws_instance.web[0]`, `aws_instance.web[1]`). If you delete index 0, Terraform shifts everything left and may destroy/recreate healthy resources.
   * `for_each` creates a map (`aws_instance.web["web-a"]`). Safe for production.

#### 💻 Code Example
```hcl
variable "subnets" {
  type = map(string)
  default = {
    "public-1a" = "10.0.1.0/24"
    "public-1b" = "10.0.2.0/24"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.subnets # Iterates over the map
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  
  tags = {
    Name = "subnet-${each.key}"
  }
}
```

#### 🎯 Enterprise Best Practice
**Never use `count`** to loop over lists of distinct resources in production. Always convert the list to a set or use a map with `for_each` to ensure state stability when items are added or removed from the middle of the list.

#### 🎤 Interview Preparation
* **Q:** What does `lifecycle { create_before_destroy = true }` do?
* **A:** Normally, Terraform destroys a resource before recreating it if an immutable attribute changes. This flag forces Terraform to create the new resource first, verify it's working, and *then* destroy the old one, enabling zero-downtime deployments.

---

### **Day 4: Querying the Cloud (Data Sources & Dynamic Blocks)**

#### 🧠 Concept Breakdown
* **Data Sources (`data`):** Read-only queries to the cloud provider. They fetch information about infrastructure that Terraform *isn't* currently managing, or dynamic IDs that change frequently (like AMIs).
* **Dynamic Blocks:** Used to generate nested configuration blocks (like multiple `ingress` rules in a Security Group) from an iterable list, keeping code clean.

#### 💻 Code Example
```hcl
# Fetch the latest Amazon Linux 2 AMI dynamically
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

variable "ingress_ports" {
  type    = list(number)
  default = [80, 443, 8080]
}

resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  # Dynamically create an ingress block for each port
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

#### 🎯 Enterprise Best Practice
Hardcoding AMI IDs is a massive anti-pattern because AMIs differ by region and get deprecated. Always use `data "aws_ami"` to dynamically look up the latest patched image.

#### 🎤 Interview Preparation
* **Q:** What is the difference between a `resource` and a `data` block?
* **A:** A `resource` creates, updates, and deletes infrastructure. A `data` block only *reads* existing infrastructure or API data.

---

### **Day 5: State Management Deep Dive**

#### 🧠 Concept Breakdown
Terraform uses a JSON file named `terraform.tfstate` to map your HCL code to real-world cloud resources. If you delete this file, Terraform forgets everything it built and will attempt to recreate it (causing errors).

**The Problems with Local State:**
1. **No Collaboration:** Only the person with the file can run `apply`.
2. **Security Risk:** The state file contains **plaintext secrets** (database passwords, private keys).
3. **Race Conditions:** Two people running `terraform apply` simultaneously will corrupt the state.

**The Solution: Remote Backends with State Locking**
Store the state in an S3 Bucket (for central access) and use a DynamoDB table to "lock" the state file while an operation is running.

#### 💻 Code Example
```hcl
terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state-bucket"
    key            = "prod/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks" # Enables Locking
    encrypt        = true                    # Encrypts at rest
  }
}
```

#### 🎯 Enterprise Best Practice
Enable Versioning on your S3 state bucket. If the state file ever gets corrupted, you can simply restore the previous version from S3.

#### 🎤 Interview Preparation
* **Q:** You notice sensitive database passwords in the `terraform.tfstate` file. How do you secure them?
* **A:** The state file always stores data in plaintext. To secure it, you MUST use a remote backend (like S3) with Server-Side Encryption enabled, and tightly restrict IAM access to the bucket so only the CI/CD pipeline role can read it.

---

### **Day 6: Advanced State Operations**

#### 🧠 Concept Breakdown
Sometimes infrastructure drifts, or you need to refactor your code without destroying the actual AWS resources. State manipulation commands modify the `terraform.tfstate` file directly.

1. **`terraform import`:** Brings existing, manually created AWS resources into Terraform's control.
2. **`terraform state rm`:** Removes a resource from the state file. Terraform will forget about it, but it will *not* be destroyed in AWS.
3. **`terraform state mv`:** Renames a resource in the state file. Crucial when refactoring code (e.g., changing `aws_instance.web1` to `aws_instance.frontend`) to prevent Terraform from destroying the old name and creating the new name.
4. **`terraform apply -replace="aws_instance.web"`:** Forces Terraform to taint the resource and recreate it on the next run.

#### 💻 Code Example
```bash
# 1. Write the empty resource block in your code
# resource "aws_vpc" "legacy_vpc" {}

# 2. Import the actual AWS resource (vpc-12345678) into that block
terraform import aws_vpc.legacy_vpc vpc-12345678

# 3. Safely rename a resource without destroying it
terraform state mv aws_vpc.legacy_vpc aws_vpc.main_vpc
```

#### 🎯 Enterprise Best Practice
Never manually edit the `terraform.tfstate` JSON file by hand. Always use the `terraform state` CLI commands to ensure syntax integrity.

#### 🎤 Interview Preparation
* **Q:** A junior engineer manually created an S3 bucket in the AWS Console. Your manager wants it managed by Terraform. How do you do it?
* **A:** I would write the `aws_s3_bucket` resource block in HCL, run `terraform import aws_s3_bucket.my_bucket <bucket-name>`, and then run `terraform plan` to adjust my HCL until it perfectly matches the imported state with zero planned changes.

---

### **Day 7: Week 1 Capstone Project**

#### 🧠 Challenge
Deploy a highly available Virtual Private Cloud (VPC).
* **Requirements:** 1 VPC, 2 Public Subnets, 2 Private Subnets, 1 Internet Gateway, 1 NAT Gateway, Route Tables, and a Bastion Host EC2 instance.
* **Constraints:** All CIDR blocks and instance types must be variable-driven. The state must be stored in S3. The AMI must be dynamically fetched.

*Self-Assessment: Spend this day writing the code from scratch, running `terraform plan`, and ensuring no hardcoded values exist.*

---

## 🏗️ Week 2: Modularization, Automation, and Enterprise CI/CD

### **Day 8: Introduction to Modular Architecture**

#### 🧠 Concept Breakdown
A module is simply a folder containing `.tf` files. The directory where you run `terraform apply` is the **Root Module**. Any folders called by the root are **Child Modules**.
Modules enforce **DRY (Don't Repeat Yourself)** principles and **Encapsulation**. You abstract complex logic into a module, expose inputs (`variables`), and return outputs (`outputs`).

#### 💻 Code Example
```hcl
# Root Module: main.tf
module "web_server" {
  source = "./modules/ec2" # Path to the child module
  
  instance_type = "t3.micro"
  vpc_id        = aws_vpc.main.id
}
```

#### 🎯 Enterprise Best Practice
Keep modules highly opinionated. If you build an RDS database module for your company, enforce encryption at rest, automated backups, and multi-AZ within the module code itself, so developers consuming the module cannot turn them off.

#### 🎤 Interview Preparation
* **Q:** What is the difference between a Root Module and a Child Module?
* **A:** The Root Module is the entry point where execution occurs and state is stored. A Child Module is a reusable package of resources invoked by the Root Module.

---

### **Day 9: Module Composition & Dependency Chaining**

#### 🧠 Concept Breakdown
In complex architectures, modules need to talk to each other. You cannot reference a resource inside a module directly from the outside. You must use outputs to pass data from Module A into the inputs of Module B.

#### 💻 Code Example
```hcl
# 1. Instantiate the VPC module
module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}

# 2. Pass the VPC output into the RDS module
module "database" {
  source = "./modules/rds"
  
  # vpc_id must be declared as an output in the VPC module!
  vpc_id = module.vpc.vpc_id 
}
```

#### 🎯 Enterprise Best Practice
Always prefix module outputs clearly. Instead of naming an output `id`, name it `vpc_id` or `alb_dns_name` so it is instantly recognizable when passed into other modules.

#### 🎤 Interview Preparation
* **Q:** How do you pass data between two isolated Terraform modules?
* **A:** By explicitly declaring an `output` block in the source module, and passing that output as a value to a `variable` block defined in the destination module.

---

### **Day 10: Module Versioning & The Public Registry**

#### 🧠 Concept Breakdown
Using pre-built, open-source modules from the [Terraform Registry](https://registry.terraform.io/) saves thousands of hours of development time.
When consuming remote modules (or your own company's modules hosted on GitHub), you must pin the version using Git Tags.

#### 💻 Code Example
```hcl
module "vpc" {
  # Sourcing an official registry module
  source  = "terraform-aws-modules/vpc/aws"
  
  # Pessimistic constraint: >= 5.0.0 and < 6.0.0
  version = "~> 5.0" 
  
  name = "production-vpc"
  cidr = "10.0.0.0/16"
}
```

#### 🎯 Enterprise Best Practice
**Never use `latest` or unversioned branches (`main`) for modules in production.** If the module author introduces a breaking change (like renaming a variable), your next `terraform apply` will fail catastrophically. Always pin to a specific Semantic Version tag (e.g., `v1.2.0`).

#### 🎤 Interview Preparation
* **Q:** What is Semantic Versioning (SemVer)?
* **A:** It is a versioning system formatted as `MAJOR.MINOR.PATCH` (e.g., `1.2.4`). Major versions indicate breaking changes, Minor indicates backward-compatible new features, and Patch indicates backward-compatible bug fixes.

---

### **Day 11: Workspaces & Multi-Environment Deployments**

#### 🧠 Concept Breakdown
How do you deploy the same code to `dev`, `staging`, and `prod`?
1. **Terraform Workspaces:** Allows multiple, distinct `.tfstate` files against the exact same codebase. You switch using `terraform workspace select prod`.
2. **Directory Separation (Terragrunt style):** Creating physical folders for `/dev`, `/staging`, `/prod` that call the same underlying child modules.

#### 💻 Code Example (Workspaces)
```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select prod
```
```hcl
# Dynamically scale based on the active workspace
resource "aws_instance" "web" {
  ami           = data.aws_ami.latest.id
  # If workspace is prod, use t3.large, else use t3.micro
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
}
```

#### 🎯 Enterprise Best Practice
Workspaces are dangerous for vastly different environments because a single code mistake impacts all environments. For enterprise production, use Directory Separation or tools like **Terragrunt** to isolate state completely.

#### 🎤 Interview Preparation
* **Q:** What are the pros and cons of Terraform Workspaces?
* **A:** Pros: Extremely DRY code, easy to spin up ephemeral environments. Cons: High blast radius. A destructive change in the `.tf` file could accidentally wipe out production if the wrong workspace is selected.

---

### **Day 12: Continuous Integration (CI) Automation**

#### 🧠 Concept Breakdown
In modern DevOps, humans do not run `terraform apply` from their laptops. Code is pushed to GitHub, validated automatically, reviewed by peers, and applied by a CI/CD pipeline (like GitHub Actions).

#### 💻 Code Example (GitHub Actions)
```yaml
# .github/workflows/terraform.yml
name: "Terraform CI"
on:
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init

      # Fails the pipeline if code isn't canonically formatted
      - name: Terraform Format
        run: terraform fmt -check

      # Fails the pipeline if syntax is invalid
      - name: Terraform Validate
        run: terraform validate

      # Outputs the plan to the PR
      - name: Terraform Plan
        run: terraform plan -no-color
```

#### 🎯 Enterprise Best Practice
Always enforce `terraform fmt -check` in CI. If developers commit poorly formatted code, the pipeline will fail, forcing them to format it locally before merging.

#### 🎤 Interview Preparation
* **Q:** Describe your ideal Terraform deployment workflow.
* **A:** Developers write HCL locally and push to a feature branch. GitHub Actions runs `fmt`, `validate`, and `tflint`. A Pull Request is opened, which triggers a `terraform plan`. Senior engineers review the plan output. Upon merge to `main`, a final GitHub Action runs `terraform apply -auto-approve` to provision the resources.

---

### **Day 13: Enterprise Code Quality & Security**

#### 🧠 Concept Breakdown
* **`tflint`:** A Terraform linter that checks for cloud-provider-specific errors (e.g., using an invalid EC2 instance type) before you even run a plan.
* **`tfsec` / `checkov`:** Static analysis security scanners. They read your HCL and flag security violations (like unencrypted S3 buckets).
* **`terraform-docs`:** An automation tool that reads your `.tf` files and generates a beautiful `README.md` containing all your inputs and outputs.

#### 🎯 Enterprise Best Practice
Integrate `tfsec` into your GitHub Actions pipeline. If a developer attempts to create a Security Group open to `0.0.0.0/0`, the pipeline will instantly fail and block the merge.

#### 🎤 Interview Preparation
* **Q:** How do you ensure infrastructure security in an automated CI/CD pipeline?
* **A:** I integrate static analysis tools like `tfsec` or `checkov` directly into the CI pipeline. They scan the Terraform code before deployment and enforce compliance rules, blocking any PR that violates security policies.

---

### **Day 14: Final Capstone & Job Readiness**

#### 🧠 The Ultimate Challenge: AWS 3-Tier Architecture
Combine everything you've learned to deploy a highly available, modular 3-Tier Architecture.
1. **Modules Required:** VPC, Application Load Balancer (ALB), Auto Scaling Group (ASG), and RDS (Multi-AZ MySQL).
2. **State:** Remote backend in S3 with DynamoDB locking.
3. **Security:** Zero-Trust Security Groups. The RDS Security Group must *only* accept traffic from the ASG Security Group ID (no IP CIDR blocks).
4. **CI/CD:** Protected by GitHub Actions executing `fmt`, `validate`, and `plan`.
5. **Documentation:** Auto-generated `TERRAFORM.md` and a Semantic Versioning `CHANGELOG.md`.

*Self-Assessment: If you can architect this from scratch without relying on tutorials, you possess the theoretical and practical knowledge required for an Entry-Level Cloud Infrastructure Engineer role.*

---
*Created as part of the 1000-Day AI & Cloud Infrastructure Journey.*
