# WEEK 12 RESOURCES — AWS CORE SERVICES II: VPC DEEP DIVE

## 📌 Week 12 Focus

Week 12 focused on mastering AWS networking fundamentals using Amazon VPC and learning how production cloud networks are designed, secured, segmented, and automated.

Main topics covered:
- Amazon VPC
- CIDR planning
- Public vs private subnets
- Internet Gateway
- Route Tables
- NAT Gateway
- Security Groups
- Network ACLs (NACLs)
- VPC Endpoints
- VPC Peering
- Terraform
- Infrastructure as Code (IaC)

---

# 📚 Primary Learning Resources

---

# 1️⃣ AWS Official VPC Documentation

Primary documentation for all VPC concepts.

Topics covered:
- VPC architecture
- Subnets
- Route tables
- NAT Gateway
- Internet Gateway
- VPC Endpoints
- Peering
- NACLs
- Security Groups

Website:

```text
https://docs.aws.amazon.com/vpc/
```

Best for:
- Official AWS explanations
- Architecture diagrams
- Production best practices

---

# 2️⃣ AWS VPC User Guide

Deep networking reference guide.

Important sections:
- VPC fundamentals
- CIDR blocks
- Route table behavior
- DNS settings
- Multi-AZ networking
- Security architecture

Website:

```text
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
```

---

# 3️⃣ Stephane Maarek — AWS Certified Solutions Architect Course

Excellent beginner-to-advanced AWS networking explanations.

Topics learned:
- Public/private subnet design
- NAT Gateway
- Route tables
- Security Groups
- NACLs
- VPC Endpoints
- Terraform introduction

Platform:

```text
Udemy
```

Recommended:
- Buy during sale periods

Best for:
- Visual explanations
- AWS architecture understanding
- Exam preparation

---

# 4️⃣ AWS Skill Builder

Official AWS training platform.

Useful networking courses:
- Amazon VPC Basics
- Networking Essentials
- AWS Security Fundamentals

Website:

```text
https://explore.skillbuilder.aws
```

Best for:
- Free AWS learning labs
- Beginner-friendly networking concepts

---

# 5️⃣ AWS VPC Reachability Analyzer

AWS networking troubleshooting tool.

Purpose:
- Analyze connectivity paths
- Detect routing issues
- Validate Security Group and NACL behavior

Found in:
- AWS Console → VPC → Reachability Analyzer

Best for:
- Troubleshooting networking issues
- Understanding packet flow

---

# 6️⃣ CloudCraft

AWS architecture diagramming tool.

Used for:
- Drawing VPC architecture
- Visualizing subnets
- Mapping traffic flow
- Infrastructure documentation

Website:

```text
https://cloudcraft.co
```

Best for:
- Production AWS diagrams
- Portfolio architecture visualization

---

# 7️⃣ draw.io (Diagrams.net)

Free architecture diagram tool.

Used for:
- AWS network diagrams
- Subnet visualization
- Security architecture mapping

Website:

```text
https://draw.io
```

Best for:
- Quick infrastructure diagrams
- Clean network documentation

---

# 8️⃣ Excalidraw

Whiteboard-style architecture sketching tool.

Used for:
- Planning subnet layouts
- Visualizing traffic flow
- Quick architecture brainstorming

Website:

```text
https://excalidraw.com
```

Best for:
- Fast rough architecture design

---

# 🌐 CIDR & Subnetting Resources

---

# 9️⃣ ipcalc

CIDR calculation tool.

Used for:
- Subnet calculations
- IP range validation
- Overlap detection

Example:

```bash
ipcalc 10.0.1.0/24
```

Best for:
- Learning subnetting
- CIDR planning

---

# 🔟 CIDR.xyz

Interactive subnetting visualization tool.

Website:

```text
https://cidr.xyz
```

Best for:
- Visual CIDR understanding
- Subnetting practice

---

# 🔐 Security Learning Resources

---

# 1️⃣1️⃣ AWS Security Groups Documentation

Learned:
- Stateful firewall behavior
- Instance-level filtering
- Security architecture best practices

Website:

```text
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
```

---

# 1️⃣2️⃣ AWS Network ACL Documentation

Learned:
- Stateless firewall behavior
- Rule evaluation order
- Explicit deny rules

Website:

```text
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
```

---

# 🛠️ Terraform Resources

---

# 1️⃣3️⃣ Terraform Official Documentation

Primary Terraform reference.

Topics covered:
- Providers
- Resources
- State management
- Variables
- Outputs
- Infrastructure as Code

Website:

```text
https://developer.hashicorp.com/terraform/docs
```

---

# 1️⃣4️⃣ Terraform AWS Provider Documentation

Used for:
- AWS Terraform resources

Important resources:
- aws_vpc
- aws_subnet
- aws_route_table
- aws_nat_gateway
- aws_internet_gateway

Website:

```text
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
```

---

# 1️⃣5️⃣ Terraform Install Guide

Used to install Terraform on Windows.

Website:

```text
https://developer.hashicorp.com/terraform/install
```

---

# 🧪 Hands-On Practice Resources

---

# 1️⃣6️⃣ AWS Free Tier

Used for:
- Building VPCs
- Launching EC2 instances
- Testing route tables
- Learning subnet behavior

Important:
- NAT Gateway is NOT free

Website:

```text
https://aws.amazon.com/free
```

---

# 1️⃣7️⃣ AWS CLI Documentation

Used for:
- AWS management from terminal

Commands practiced:
- S3 access
- Connectivity validation
- Terraform support workflows

Website:

```text
https://docs.aws.amazon.com/cli/
```

---

# 🎥 YouTube Channels & Video Resources

---

# 1️⃣8️⃣ TechWorld with Nana

Best for:
- Terraform basics
- Infrastructure as Code
- DevOps workflows

Topics:
- Terraform fundamentals
- IaC workflows
- AWS automation

---

# 1️⃣9️⃣ NetworkChuck

Best for:
- Beginner networking explanations
- Cloud networking fundamentals
- CIDR understanding

Topics:
- Subnetting
- Networking basics
- AWS concepts

---

# 2️⃣0️⃣ FreeCodeCamp AWS Networking Videos

Best for:
- Long-form AWS learning
- Beginner-friendly cloud networking

Topics:
- VPC architecture
- Route tables
- NAT Gateway
- Security Groups

---

# 📖 Important Commands Learned

---

# Terraform Commands

Initialize:

```bash
terraform init
```

Preview changes:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply
```

Destroy infrastructure:

```bash
terraform destroy
```

List Terraform resources:

```bash
terraform state list
```

---

# AWS CLI Testing Commands

Test internet connectivity:

```bash
curl google.com
```

List S3 buckets:

```bash
aws s3 ls
```

---

# 📂 Important AWS Services Learned

| Service | Purpose |
|---|---|
| Amazon VPC | Virtual private networking |
| EC2 | Compute instances |
| Internet Gateway | Internet access |
| NAT Gateway | Outbound internet |
| Route Tables | Traffic routing |
| Security Groups | Instance firewall |
| NACLs | Subnet firewall |
| VPC Endpoints | Private AWS access |
| VPC Peering | Private VPC communication |
| Elastic IP | Static public IP |
| Terraform | Infrastructure as Code |

---

# 🧠 Important Architecture Concepts Learned

---

## Public vs Private Networking

```text
Public → Internet Accessible
Private → Internal Only
```

---

## Multi-AZ Design

```text
AZ1 + AZ2
```

Purpose:
- High availability

---

## Defense in Depth

```text
NACL
  ↓
Security Group
  ↓
Application
```

---

## Infrastructure as Code

```text
Infrastructure = Code
```

Benefits:
- Automation
- Reproducibility
- Version control

---

# 🔥 Most Valuable Resources This Week

| Resource | Why It Was Valuable |
|---|---|
| AWS VPC Docs | Official architecture understanding |
| Stephane Maarek Course | Easy networking explanations |
| Terraform Docs | IaC learning |
| CloudCraft | Architecture diagrams |
| Reachability Analyzer | Troubleshooting networking |
| ipcalc | CIDR understanding |

---

# 🚀 Week 12 Outcome

Using these resources, built understanding of:
- AWS networking
- CIDR planning
- Public/private subnet architecture
- Route table behavior
- NAT Gateway design
- Stateful vs stateless firewalls
- Private AWS connectivity
- Terraform automation
- Production VPC architecture

These resources established the networking foundation required for:
- Kubernetes
- EKS
- Load Balancers
- Auto Scaling
- DevOps
- AI Infrastructure
- Enterprise Cloud Architecture

---

# 📚 Final Resource Summary

Week 12 resources focused heavily on:
- Real AWS networking
- Production architecture
- Security design
- Traffic routing
- Infrastructure automation
- Multi-AZ resiliency
- Infrastructure as Code

The combination of:
- AWS documentation
- Terraform documentation
- Visual architecture tools
- Hands-on labs
- Networking calculators
- Video tutorials

Created a strong foundation in production cloud networking engineering.

---