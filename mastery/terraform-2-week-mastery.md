# 🚀 The Definitive 2-Week Terraform Mastery Guide for Cloud Engineers

Welcome to the ultimate, no-stone-left-unturned guide to mastering Terraform. This isn't just a cheat sheet; it is a comprehensive, deeply technical manual designed to simulate the rigorous training of an Enterprise Cloud Infrastructure Engineer. By the end of this 14-day path, you will possess the theoretical depth, practical coding skills, and interview readiness required to manage millions of dollars of cloud infrastructure at scale.

---

## 🛠️ Week 1: Foundations, HCL Deep Dive, and State Architecture

### **Day 1: The Infrastructure as Code (IaC) Paradigm**

#### 🧠 Comprehensive Concept Breakdown
Before writing a single line of code, you must understand *why* Terraform exists. Historically, system administrators clicked through the AWS Console to create servers (ClickOps) or wrote massive bash scripts calling the AWS CLI. Both methods are disastrous at scale: they are unversioned, prone to human error, and completely lack **State Awareness**.

**Infrastructure as Code (IaC)** solves this by allowing you to define your architecture in plaintext files. 
Terraform specifically uses a **Declarative** paradigm. 
* **Imperative (Ansible, Bash):** You tell the system *how* to do it. ("Create an EC2 instance. Now install Apache. Now start the service.")
* **Declarative (Terraform):** You tell the system *what* you want. ("I want 3 EC2 instances running Apache.") Terraform calculates the difference between reality and your request, and automatically executes the precise API calls to bridge the gap.

**The Terraform Architecture:**
1. **Terraform Core:** The central, open-source binary written in Go. It reads your `.tf` files, reads the `terraform.tfstate` file, builds a mathematical Dependency Graph, and calculates the exact execution plan.
2. **Providers:** Terraform Core itself knows *nothing* about AWS or Azure. It relies on plugins called Providers (e.g., `hashicorp/aws`). The provider translates Terraform's core instructions into the specific REST API calls required by AWS.

#### 💻 The Core Workflow Walkthrough
```bash
# 1. Initialization
# This scans your code, detects the required providers (e.g., AWS), downloads their binaries into a hidden `.terraform/` directory, and sets up your remote state backend.
terraform init

# 2. Canonical Formatting
# Consistency is key in enterprise teams. This automatically rewrites your files to follow HashiCorp's strict indentation and spacing rules.
terraform fmt

# 3. Static Syntax Validation
# Checks your code for typos, missing brackets, and type mismatches WITHOUT needing internet access or AWS credentials.
terraform validate

# 4. Execution Planning (The Dry Run)
# Terraform compares your code against the actual AWS environment (via API) and the state file. It generates a diff (+ for create, - for destroy, ~ for update). 
# Saving it to a file (`tfplan`) guarantees that the exact plan reviewed is the one executed.
terraform plan -out=tfplan

# 5. Provisioning
# Executes the saved plan. No surprises.
terraform apply "tfplan"

# 6. Decommissioning
# Safely tears down every single resource tracked in the state file in the correct reverse-dependency order.
terraform destroy
```

#### 🚨 Common Pitfalls & Debugging
* **Error:** `Provider registry.terraform.io/hashicorp/aws v5.0.0 is not available.`
* **Fix:** You added a new provider to your code but forgot to run `terraform init` to download the binary.

#### 🎤 Technical Interview Prep
* **Q:** What is the concept of "Idempotency" in Terraform?
* **A:** Idempotency means that no matter how many times you run `terraform apply`, the end result will always be the same. If the infrastructure already matches the code, Terraform will make zero changes. It does not blindly create new resources on every run.

---

### **Day 2: HCL Syntax, Types, & Data Flow**

#### 🧠 Comprehensive Concept Breakdown
HashiCorp Configuration Language (HCL) is JSON's highly readable cousin. To master HCL, you must understand how data flows through a module: from Inputs (`variables`), to Internal Processing (`locals`), to Provisioning (`resources`), to Outputs (`outputs`).

* **Variables (`variables.tf`):** The arguments your module accepts. They are strictly typed.
* **Locals (`locals.tf`):** Constants computed within the module. They reduce repetition (DRY principle). If you type the same string three times, it belongs in a `local`.
* **Outputs (`outputs.tf`):** The data your module returns to the user or to another module after creation.

#### 💻 Code Example & Walkthrough
```hcl
# variables.tf - We define a complex object to strictly enforce inputs
variable "db_config" {
  description = "Database configuration object"
  type = object({
    engine         = string
    instance_class = string
    multi_az       = bool
  })
  
  # Custom Validation Rule to prevent junior devs from making expensive mistakes
  validation {
    condition     = var.db_config.instance_class != "db.m5.24xlarge"
    error_message = "Do not deploy ultra-expensive instances in this environment!"
  }
}

# locals.tf - Standardizing naming conventions globally
locals {
  app_name = "payment-gateway"
  # String interpolation to create dynamic names
  db_name  = "${local.app_name}-db-${terraform.workspace}"
  
  standard_tags = {
    Application = local.app_name
    ManagedBy   = "Terraform"
  }
}

# main.tf - Consuming the variables and locals
resource "aws_db_instance" "main" {
  identifier     = local.db_name
  engine         = var.db_config.engine
  instance_class = var.db_config.instance_class
  multi_az       = var.db_config.multi_az
  tags           = local.standard_tags
}
```

#### 🚨 Common Pitfalls & Debugging
* **Error:** Missing variable values.
* **Fix:** Use a `terraform.tfvars` file to automatically inject values into your variables, or explicitly pass them via `terraform apply -var="engine=mysql"`.

#### 🎤 Technical Interview Prep
* **Q:** Why would you use a `local` instead of a `variable` with a default value?
* **A:** Variables can be overridden by the user at runtime via the CLI or a `.tfvars` file. Locals are strictly internal and cannot be overridden. If you have a strict naming convention that users must follow, you enforce it via a `local`, guaranteeing they cannot bypass it.

---

### **Day 3: Resource Meta-Arguments (Control Flow)**

#### 🧠 Comprehensive Concept Breakdown
By default, one `resource` block creates exactly one cloud resource. Meta-arguments allow you to inject programmatic control flow into your HCL (loops, implicit dependencies, and lifecycle rules).

1. **`count` vs `for_each`:**
   * **`count`:** Accepts a number. Creates a list (Array) of resources (`aws_instance.web[0]`, `[1]`). **WARNING:** If you have an array `["A", "B", "C"]` and remove `"A"`, everything shifts left. Terraform will destroy `"B"` to replace it with `"C"`, causing catastrophic downtime.
   * **`for_each`:** Accepts a Map or a Set. Creates resources keyed by strings (`aws_instance.web["subnet-1a"]`). If you remove an item, only that specific item is destroyed. **Always prefer `for_each` in production.**
2. **`depends_on`:** Terraform normally infers dependencies implicitly. If Resource B uses Resource A's ID, A builds first. `depends_on` explicitly forces an order when Terraform cannot see the connection.
3. **`lifecycle`:** Injects custom rules into the creation/destruction process.

#### 💻 Code Example & Walkthrough
```hcl
variable "environments" {
  type    = set(string)
  default = ["dev", "staging", "prod"]
}

# Safe looping using for_each
resource "aws_s3_bucket" "env_buckets" {
  for_each = var.environments
  
  bucket = "company-assets-${each.key}"
  
  lifecycle {
    # If someone manually deletes the bucket in the AWS Console, 
    # Terraform will ignore the drift and NOT recreate it on the next run.
    ignore_changes = [tags] 
    
    # Absolute safety net: Terraform will outright refuse to run a destroy command on this resource.
    prevent_destroy = true 
  }
}
```

#### 🎤 Technical Interview Prep
* **Q:** What is a scenario where you MUST use `depends_on`?
* **A:** Imagine an EC2 instance that runs a startup script requiring access to an S3 bucket. The EC2 instance requires an IAM Instance Profile. Terraform will create the IAM Role, Instance Profile, and EC2 instance simultaneously. However, IAM roles take ~10 seconds to propagate globally. The EC2 instance will boot, try to read S3, fail, and crash. Using `depends_on = [aws_iam_role_policy_attachment.s3_access]` forces the EC2 instance to wait until the policy is fully attached and propagated.

---

### **Day 4: Querying the Cloud (Data Sources & Dynamic Blocks)**

#### 🧠 Comprehensive Concept Breakdown
* **Data Sources (`data`):** These are read-only API calls. While a `resource` provisions new infrastructure, a `data` block fetches information about existing infrastructure. This is critical for making your code dynamic (e.g., dynamically finding the VPC ID of the "Default" VPC without hardcoding it).
* **Dynamic Blocks:** HCL does not support standard `for` loops inside resource blocks (you can't just write `for i in list` inside a Security Group). `dynamic` blocks allow you to programmatically generate repeated nested blocks (like `ingress` rules or `tags`).

#### 💻 Code Example & Walkthrough
```hcl
# Dynamically fetch the current AWS Region the provider is operating in
data "aws_region" "current" {}

# Dynamically fetch the latest Ubuntu 22.04 AMI for that specific region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

variable "allowed_ports" {
  type    = list(number)
  default = [80, 443, 8080]
}

resource "aws_security_group" "web_sg" {
  name = "web-sg-${data.aws_region.current.name}"

  # Loop through the list of ports and generate an ingress block for each one
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

#### 🎤 Technical Interview Prep
* **Q:** Why is hardcoding AMI (Amazon Machine Image) IDs considered an anti-pattern?
* **A:** AMI IDs are region-specific. `ami-12345` might be Ubuntu 22.04 in `us-east-1`, but it won't exist in `eu-west-1`. Furthermore, AWS frequently deprecates old AMIs to force security patching. Hardcoding guarantees your code will eventually break. Using `data "aws_ami"` ensures your code is universally portable and always fetches the latest patched image.

---

### **Day 5: State Management Deep Dive (The Source of Truth)**

#### 🧠 Comprehensive Concept Breakdown
Terraform does not blindly query AWS every time you run it. It relies on a local JSON database called `terraform.tfstate`. This file maps your HCL code (`aws_instance.web`) to the physical AWS Resource ID (`i-0abcd1234`). 

**The Catastrophic Flaws of Local State:**
1. **No Concurrency:** If Bob and Alice both run `terraform apply` on their laptops simultaneously, AWS will receive conflicting API calls, and the infrastructure will corrupt.
2. **Plaintext Secrets:** Terraform state stores EVERYTHING in plaintext. Database passwords, private SSH keys, and API tokens are completely visible to anyone who can read the file.
3. **Data Loss:** If you drop your laptop in a lake, Terraform forgets what it built. You will have orphaned infrastructure burning money in AWS.

**The Enterprise Solution: Remote State with Locking**
You must migrate the state file off your laptop and into a centralized, highly durable remote backend (AWS S3) and pair it with a distributed locking mechanism (Amazon DynamoDB).

#### 💻 Code Example & Walkthrough
```hcl
terraform {
  backend "s3" {
    bucket         = "acme-corp-terraform-state-prod"
    key            = "networking/vpc/terraform.tfstate" # The path inside the bucket
    region         = "us-east-1"
    
    # DynamoDB handles State Locking. It creates a temporary record while an apply is running.
    dynamodb_table = "terraform-state-locks" 
    
    # Secures the plaintext secrets at rest in AWS
    encrypt        = true 
  }
}
```

#### 🚨 Common Pitfalls & Debugging
* **Error:** `Error acquiring the state lock...`
* **Fix:** Someone else is currently running `terraform apply`. Wait for them to finish. If their CI pipeline crashed mid-run and orphaned the lock, you can manually release it using `terraform force-unlock <LOCK_ID>`.

#### 🎤 Technical Interview Prep
* **Q:** Describe the exact mechanism of Terraform State Locking.
* **A:** When an engineer executes `terraform plan` or `apply`, Terraform makes an API call to the configured DynamoDB table and writes an item containing a Lock ID. If a second engineer attempts to run Terraform, their client reads the DynamoDB table, sees the existing Lock ID, and instantly aborts with an error, preventing race conditions and state corruption. Upon successful completion, the first client deletes the Lock ID from DynamoDB.

---

### **Day 6: Advanced State Operations (Surgery on the State File)**

#### 🧠 Comprehensive Concept Breakdown
Infrastructure is messy. Sometimes a developer clicks around in the AWS Console and creates resources manually. Sometimes you need to rename a module in your code but CANNOT afford to destroy the database associated with it. 
To fix these issues, you must perform surgery directly on the state file using CLI commands.

1. **`terraform import`:** The ultimate rescue tool. It maps an existing, manually created AWS resource into your Terraform state file so Terraform can manage it going forward.
2. **`terraform state rm`:** The amnesia command. Terraform deletes the resource from its state file but **leaves it running in AWS**. Useful if you want to stop managing a resource but don't want to destroy it.
3. **`terraform state mv`:** The rename command. Moves a resource from one HCL address to another without destroying it.

#### 💻 CLI Walkthrough
```bash
# Scenario: Refactoring a poorly named resource
# Old code: resource "aws_instance" "test" {}
# New code: resource "aws_instance" "production_web_server" {}

# If you just run apply, Terraform will DESTROY "test" and CREATE "production_web_server" (Downtime!)
# Instead, move the state mapping:
terraform state mv aws_instance.test aws_instance.production_web_server

# Now run plan. Terraform will report: "0 to add, 0 to change, 0 to destroy." Perfect refactor.
```

#### 🎤 Technical Interview Prep
* **Q:** A rogue developer manually created a critical RDS database in the AWS Console. Your manager demands it be brought under Terraform management immediately without causing downtime. Walk me through the exact steps.
* **A:** 
  1. I would write an empty `resource "aws_db_instance" "rogue_db" {}` block in my HCL code.
  2. I would execute `terraform import aws_db_instance.rogue_db <actual-rds-identifier>`. Terraform now tracks it.
  3. I would run `terraform plan`. Terraform will show a massive list of differences because my empty HCL block doesn't match the real-world RDS settings.
  4. I will iteratively update my HCL block to match the real-world settings (engine, instance class, storage) and run `terraform plan` again.
  5. I will repeat step 4 until `terraform plan` returns "No changes. Your infrastructure matches the configuration." The database is now safely managed.

---

### **Day 7: Week 1 Capstone Challenge**

#### 🧠 The Architecture Objective
Deploy a highly available, production-grade Virtual Private Cloud (VPC) spanning two Availability Zones.
* **Requirements:** 
  * 1 VPC with a variable-driven CIDR block (e.g., `10.0.0.0/16`).
  * 2 Public Subnets (dynamically using `data "aws_availability_zones"` to ensure they are in different AZs).
  * 2 Private Subnets.
  * 1 Internet Gateway attached to the VPC.
  * 1 NAT Gateway deployed in Public Subnet 1, with an Elastic IP.
  * Public Route Table routing `0.0.0.0/0` to the IGW. Private Route Table routing `0.0.0.0/0` to the NAT Gateway.
* **Constraints:** No hardcoded strings for availability zones. State must be configured for a remote S3 backend.

*Self-Assessment: Spend 4-6 hours architecting this from scratch. Do not use the Terraform Registry VPC module; build every resource manually to understand the underlying routing mechanics.*

---
*(End of Week 1. You now possess the foundational knowledge of a Junior Cloud Engineer.)*
---

## 🏗️ Week 2: Modularization, Automation, and Enterprise CI/CD

### **Day 8: Introduction to Modular Architecture (DRY Terraform)**

#### 🧠 Comprehensive Concept Breakdown
As your infrastructure grows, your `main.tf` will hit 5,000 lines. It becomes unreadable, unmaintainable, and dangerous. 
**Modules** are the solution. A module is simply a folder containing `.tf` files. By abstracting complex resources into isolated folders, you enforce the **DRY (Don't Repeat Yourself)** principle and achieve **Encapsulation**.

* **Root Module:** The directory where you type `terraform apply`.
* **Child Module:** The reusable package of code called by the Root Module. 

Think of a module like a Python function. You define the function (`Child Module`), specify the parameters it accepts (`variables.tf`), and define what it returns (`outputs.tf`). The user (`Root Module`) calls the function, passes the arguments, and receives the output.

#### 💻 Code Example & Walkthrough
```hcl
# --- CHILD MODULE (located in ./modules/s3_bucket/main.tf) ---
variable "bucket_name" { type = string }

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}
# Enforce encryption at the module level so the user cannot turn it off
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}
output "bucket_arn" { value = aws_s3_bucket.this.arn }


# --- ROOT MODULE (located in ./main.tf) ---
# Calling the child module as a black box
module "secure_finance_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "acme-finance-secure-logs-2026"
}
```

#### 🎤 Technical Interview Prep
* **Q:** What is the principle of Encapsulation in Terraform Modules?
* **A:** Encapsulation means hiding the complex internal workings of infrastructure from the end-user. As a Platform Engineer, I create a module that enforces security (like forcing S3 encryption). The developer consuming my module only sees the variables I expose to them. They cannot bypass the security rules because they cannot touch the internal resources directly.

---

### **Day 9: Module Composition & Dependency Chaining**

#### 🧠 Comprehensive Concept Breakdown
When you abstract your code into modules, those modules will inevitably need to communicate. For example, your `rds` module needs to know the Subnet IDs created by your `vpc` module to deploy the database in the right place.
You CANNOT reference `aws_vpc.main.id` from inside the RDS module. Scope is strictly isolated. 
You must explicitly export the data using an `output` block in the VPC module, and pass it into a `variable` block in the RDS module. This creates an explicit dependency chain.

#### 💻 Code Example & Walkthrough
```hcl
# 1. Instantiate the VPC Module
module "networking" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}

# 2. Instantiate the RDS Module, injecting the outputs from the VPC Module
module "database" {
  source = "./modules/rds"
  
  # Dependency Chaining: Terraform now knows it MUST build the VPC before the Database
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  
  db_password = var.secure_db_password
}
```

#### 🎯 Enterprise Best Practice
When designing modules, aim for high cohesion and loose coupling. A VPC module should only handle networking. An RDS module should only handle the database. Do not create "God Modules" that try to deploy an entire company's infrastructure in one folder.

---

### **Day 10: The Terraform Public Registry & Semantic Versioning**

#### 🧠 Comprehensive Concept Breakdown
You do not need to reinvent the wheel. The [Terraform Registry](https://registry.terraform.io/) contains thousands of battle-tested, open-source modules built by AWS and HashiCorp experts.
However, pulling code from the internet into your enterprise infrastructure requires extreme caution. You must use **Version Pinning** via Semantic Versioning (SemVer).

**Semantic Versioning (MAJOR.MINOR.PATCH):**
* **MAJOR (v2.0.0):** Breaking changes. Variables were renamed or removed. Your code will fail if you upgrade.
* **MINOR (v1.5.0):** Backward-compatible new features. Safe to upgrade.
* **PATCH (v1.4.2):** Backward-compatible bug fixes. Highly recommended to upgrade.

#### 💻 Code Example & Walkthrough
```hcl
module "eks_cluster" {
  # Sourcing from the official public registry
  source  = "terraform-aws-modules/eks/aws"
  
  # The Pessimistic Constraint Operator (~>)
  # This allows Terraform to automatically download any version >= 19.0.0, but strictly < 20.0.0
  # This ensures you get critical bug fixes (19.1.5) but protects you from breaking changes (20.0.0)
  version = "~> 19.0"
  
  cluster_name    = "production-cluster"
  cluster_version = "1.27"
}
```

#### 🎤 Technical Interview Prep
* **Q:** A junior engineer wants to use `version = "latest"` or omit the version constraint entirely on a third-party Terraform module. Why is this a fireable offense?
* **A:** Because third-party module authors frequently release Major updates that rename variables or restructure state. If you use `latest`, the next time a CI pipeline runs `terraform init`, it will download the breaking change, and `terraform apply` will fail catastrophically, or worse, destroy and recreate production resources based on the new module structure. Always pin your versions.

---

### **Day 11: Workspaces & Multi-Environment Deployments**

#### 🧠 Comprehensive Concept Breakdown
You have written a beautiful modular architecture. Now you need to deploy it three times: to `dev`, `staging`, and `production`. How do you do this without copy-pasting your code three times?

**Method 1: Terraform Workspaces**
Workspaces allow you to maintain a single directory of `.tf` files, but Terraform stores multiple, completely isolated `.tfstate` files in the backend. 
```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
```

**Method 2: Directory Separation (The Enterprise Choice)**
Workspaces are risky because a typo in your `.tf` code affects `dev` and `prod` simultaneously. Many enterprises prefer physical directory separation, creating `environments/dev/main.tf` and `environments/prod/main.tf`, which both call the same underlying child modules but maintain completely isolated state and configurations. Tools like **Terragrunt** excel at managing this.

#### 💻 Code Example (Dynamic Workspace Logic)
```hcl
# Dynamically adjust instance sizing based on the currently selected workspace
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  
  # If we are in prod, deploy a huge server. Otherwise, deploy a micro server to save money.
  instance_type = terraform.workspace == "prod" ? "m5.large" : "t3.micro"
  
  tags = {
    Name = "web-server-${terraform.workspace}"
  }
}
```

#### 🎤 Technical Interview Prep
* **Q:** What are the drawbacks of using Terraform Workspaces for separating Dev and Prod?
* **A:** The primary drawback is blast radius. Because both environments share the exact same configuration files, a destructive syntax error or a logical flaw introduced into the code will impact production as soon as the workspace is switched. Physical directory separation isolates the blast radius.

---

### **Day 12: Continuous Integration (CI) Automation (GitHub Actions)**

#### 🧠 Comprehensive Concept Breakdown
Running Terraform locally from a laptop is for hobbyists. In an enterprise, Terraform is executed by a CI/CD pipeline. This enforces peer review, runs security scans, and provides an auditable log of every infrastructure change.

#### 💻 Code Example & Walkthrough
```yaml
# .github/workflows/terraform.yml
name: "Terraform CI"
on:
  pull_request: # Run on every PR to validate the code before merge

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v4
        
      - name: Setup Terraform Binary
        uses: hashicorp/setup-terraform@v3

      - name: Initialize Backend
        run: terraform init

      # Fails the pipeline instantly if the code is not canonically formatted
      - name: Format Check
        run: terraform fmt -check

      # Fails the pipeline if there are syntax errors or broken variable references
      - name: Validate Syntax
        run: terraform validate

      # Generates the execution plan. 
      # In advanced setups, a GitHub Action script will post this output directly as a comment on the PR.
      - name: Dry Run Plan
        run: terraform plan
```

#### 🎯 Enterprise Best Practice
Enforce Branch Protection Rules on your `main` branch in GitHub. Require that the `Terraform CI` status check passes before any Pull Request can be merged.

---

### **Day 13: DevSecOps, Static Analysis, and Code Quality**

#### 🧠 Comprehensive Concept Breakdown
Deploying code automatically is great, but what if a developer writes code that opens an S3 bucket to the public internet? You must "Shift Security Left" by scanning your HCL code *before* it gets applied.

1. **`tflint`:** A strict linter. It queries the AWS API to verify that the EC2 instance type you specified (`t3.superlarge`) actually exists, catching errors before `terraform plan` even runs.
2. **`tfsec` (or `checkov`):** Static Application Security Testing (SAST). It scans your code against hundreds of known security vulnerabilities (CIS benchmarks). If it finds a Security Group open to `0.0.0.0/0` on port 22, it throws an exit code 1 and kills the CI pipeline.
3. **`terraform-docs`:** An automation tool that parses your variables and outputs to auto-generate beautiful Markdown tables for your `README.md`, ensuring your documentation is never out of date.

#### 💻 CLI Walkthrough
```bash
# Run tfsec locally before committing
tfsec .

# Output:
# Result 1
# [aws-s3-enable-bucket-encryption] Resource 'aws_s3_bucket.main' does not have encryption enabled.
# Impact: The bucket objects could be read if compromised.
# Resolution: Add server-side encryption configuration.
```

#### 🎤 Technical Interview Prep
* **Q:** How do you ensure infrastructure compliance and security in an automated Terraform pipeline?
* **A:** I integrate static analysis tools like `tfsec` or `checkov` as blocking steps in the CI pipeline. Before `terraform plan` is even executed, the security scanner analyzes the HCL. If any compliance rules are violated (e.g., unencrypted databases, public subnets), the pipeline fails and rejects the Pull Request.

---

### **Day 14: Final Capstone & Job Readiness (The AWS 3-Tier Architecture)**

#### 🧠 The Ultimate Challenge
You have reached the end of the 2-week mastery journey. To prove you are ready for an Entry-Level Cloud Infrastructure Engineer position, you must deploy a complete, production-ready AWS 3-Tier Architecture.

**The Requirements:**
1. **Modules:** Build custom, reusable modules for:
   * **VPC:** Highly available, public/private subnets, NAT Gateways.
   * **RDS:** Multi-AZ MySQL database.
   * **ALB:** Application Load Balancer facing the public subnets.
   * **ASG:** Auto Scaling Group dynamically launching EC2 instances into the private subnets.
2. **State:** Configure an S3 remote backend with DynamoDB state locking.
3. **Security:** Implement Zero-Trust Security Groups. The RDS Security Group must *not* contain IP CIDR blocks; it must only accept traffic explicitly from the ASG's Security Group ID.
4. **Dynamic Data:** Use `data` sources to fetch the latest Amazon Linux 2 AMI automatically.
5. **CI/CD:** Protect the repository with a GitHub Actions pipeline enforcing `terraform fmt` and `terraform validate`.
6. **Documentation:** Auto-generate a `TERRAFORM.md` file using `terraform-docs` and maintain a `CHANGELOG.md` utilizing Semantic Versioning.

*Self-Assessment: If you can architect, secure, document, and automate this entire stack from a blank VS Code window, you are no longer a beginner. You are a highly capable Cloud Infrastructure Engineer.*

---
*Authored for the 1000-Day AI & Cloud Infrastructure Journey.*
