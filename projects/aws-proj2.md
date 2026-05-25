# WEEK 12 PROJECT — BUILD PRODUCTION-GRADE AWS VPC ARCHITECTURE

## 📌 Project Overview

This week’s project focused on designing and building a complete production-style AWS networking environment from scratch.

The goal was to understand how real-world cloud infrastructure networking works by manually creating and configuring:
- VPCs
- Public and private subnets
- Route tables
- Internet Gateways
- NAT Gateway architecture
- Security layers
- VPC Endpoints
- Terraform-based infrastructure automation

This project simulated how production cloud environments are designed for:
- Scalability
- Security
- High availability
- Isolation
- Infrastructure automation

---

# 🎯 Project Objectives

By completing this project, achieved understanding of:

- AWS VPC architecture fundamentals
- CIDR planning and subnetting
- Public vs private networking
- Internet access control
- Secure outbound internet architecture
- Stateless vs stateful firewall behavior
- VPC endpoint private connectivity
- Multi-AZ networking design
- Infrastructure as Code using Terraform
- Production cloud networking principles

---

# 🏗️ Final Architecture Built

```text
                           Internet
                               ↓
                     Internet Gateway (IGW)
                               ↓
                   Public Route Table (0.0.0.0/0)
                         ↓                 ↓
               Public Subnet AZ1    Public Subnet AZ2
                  10.0.1.0/24         10.0.2.0/24
                         ↓
                    NAT Gateway
                         ↓
                Private Route Table
                         ↓
              Private Subnet AZ1   Private Subnet AZ2
                 10.0.11.0/24       10.0.12.0/24
                         ↓
                  Internal Workloads
```

---

# 🧠 Core Concepts Implemented

---

# 1️⃣ Built Custom Production VPC

Created a fully isolated AWS network.

Configuration:

| Setting | Value |
|---|---|
| CIDR | 10.0.0.0/16 |
| DNS Hostnames | Enabled |
| DNS Resolution | Enabled |

Purpose:
- Foundation of all AWS networking

---

# 2️⃣ Designed Production CIDR Architecture

Planned subnet allocation carefully.

Subnet design:

| Subnet | CIDR | Type |
|---|---|---|
| Public AZ1 | 10.0.1.0/24 | Public |
| Public AZ2 | 10.0.2.0/24 | Public |
| Private AZ1 | 10.0.11.0/24 | Private |
| Private AZ2 | 10.0.12.0/24 | Private |

Learned:
- CIDR planning is critical in production systems
- Subnets must never overlap

---

# 3️⃣ Implemented Multi-AZ Architecture

Distributed infrastructure across:
- us-east-1a
- us-east-1b

Benefits:
- High availability
- Fault tolerance
- Production resiliency

---

# 4️⃣ Built Public Subnet Infrastructure

Configured:
- Auto-assign public IP
- Public routing

Purpose:
- Internet-facing resources

Examples:
- Bastion hosts
- Load balancers
- Reverse proxies

---

# 5️⃣ Built Private Subnet Infrastructure

Configured:
- No public IP assignment
- Private routing

Purpose:
- Internal backend systems

Examples:
- APIs
- Databases
- AI inference servers
- Internal services

---

# 6️⃣ Configured Internet Gateway

Created and attached:
- Internet Gateway (IGW)

Purpose:
- Connect VPC to internet

Traffic flow:

```text
Internet
    ↓
IGW
    ↓
Public Subnets
```

---

# 7️⃣ Built Public Route Table

Configured route:

```text
0.0.0.0/0 → Internet Gateway
```

Associated with:
- Public Subnet AZ1
- Public Subnet AZ2

Purpose:
- Enable internet access

---

# 8️⃣ Built Private Route Table

Created isolated private routing.

Initially:
- No route to internet

Purpose:
- Protect backend infrastructure

---

# 9️⃣ Tested Public vs Private Connectivity

Validated networking behavior.

Results:

| Subnet Type | Internet Access |
|---|---|
| Public | YES |
| Private | NO |

Test command:

```bash
curl google.com
```

Learned:
- Internet access depends entirely on routing configuration

---

# 🔟 Implemented NAT Gateway Architecture

Created:
- Elastic IP
- NAT Gateway in public subnet

Updated private route table:

```text
0.0.0.0/0 → NAT Gateway
```

Purpose:
- Allow outbound internet access from private subnets

---

# 1️⃣1️⃣ Built Secure Bastion Host Access Pattern

Used public EC2 as:
- Bastion host

Access flow:

```text
Laptop
   ↓
Public EC2
   ↓
Private EC2
```

Purpose:
- Secure administration of private systems

---

# 1️⃣2️⃣ Learned NAT Gateway Cost Optimization

Studied:
- NAT Gateway pricing

Approximate cost:

```text
~$0.045/hour
~$0.045/GB
```

Learned:
- NAT Gateways are expensive for dev environments

Alternative:
- NAT Instance

---

# 1️⃣3️⃣ Configured Network ACLs (NACLs)

Created custom subnet-level firewall.

Configured:
- HTTP access
- HTTPS access
- Ephemeral ports
- Outbound allow rules

Learned:
- NACLs are stateless firewalls

---

# 1️⃣4️⃣ Compared NACLs vs Security Groups

Studied differences:

| Feature | SG | NACL |
|---|---|---|
| Level | Instance | Subnet |
| Stateful | Yes | No |
| Deny Rules | No | Yes |

Learned:
- Security Groups and NACLs solve different security problems

---

# 1️⃣5️⃣ Implemented Explicit Deny Rules

Added NACL deny rule for:
- Specific IP ranges

Purpose:
- Block malicious traffic

Learned:
- NACLs are AWS’s only native explicit deny mechanism

---

# 1️⃣6️⃣ Tested Stateless Firewall Behavior

Experiment:
- Removed outbound NACL rule

Result:
- Connections failed

Learned:
- Stateless firewalls require bidirectional rules

---

# 1️⃣7️⃣ Implemented VPC Endpoint for S3

Created:
- Gateway Endpoint for S3

Purpose:
- Private S3 connectivity without internet

Traffic flow:

```text
Private EC2
      ↓
VPC Endpoint
      ↓
Amazon S3
```

Benefits:
- Improved security
- Reduced NAT costs

---

# 1️⃣8️⃣ Learned Interface Endpoints (PrivateLink)

Studied:
- Interface Endpoints

Examples:
- Secrets Manager
- KMS
- EC2 API

Learned:
- AWS services can be privately consumed inside VPC

---

# 1️⃣9️⃣ Learned VPC Peering

Studied:
- Private VPC-to-VPC connectivity

Important concept:
- Peering is NON-transitive

Example:

```text
A ↔ B
B ↔ C

A ≠ C
```

---

# 2️⃣0️⃣ Automated Entire Infrastructure Using Terraform

Installed:
- Terraform on Windows

Created:
- `main.tf`

Automated:
- VPC
- Subnets
- Route tables
- Internet Gateway
- Associations

---

# 2️⃣1️⃣ Learned Terraform Workflow

Used commands:

Initialize:

```bash
terraform init
```

Preview:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

Destroy:

```bash
terraform destroy
```

Learned:
- Infrastructure can be fully managed through code

---

# 2️⃣2️⃣ Learned Infrastructure as Code (IaC)

Understood:
- Infrastructure becomes:
  - Reproducible
  - Version-controlled
  - Automated

Benefits:
- Faster deployments
- Reduced human error
- Easier collaboration

---

# 2️⃣3️⃣ Verified Terraform State Management

Used:

```bash
terraform state list
```

Observed:
- Terraform tracks infrastructure resources internally

State files:

```text
terraform.tfstate
terraform.tfstate.backup
```

---

# 2️⃣4️⃣ Documented Complete Architecture

Created:
- Architecture diagrams
- CIDR documentation
- Traffic flow visualization

Tools learned:
- CloudCraft
- draw.io
- Excalidraw

---

# 🔐 Security Architecture Built

---

# Layered Security Model

```text
Internet
    ↓
NACL
    ↓
Security Group
    ↓
Application
```

---

# Public Tier Security

Protected:
- Internet-facing systems

Controls:
- Security Groups
- NACL filtering

---

# Private Tier Security

Protected:
- Internal systems
- APIs
- Databases

Characteristics:
- No direct internet access

---

# AI Infrastructure Relevance

This architecture directly applies to:
- GPU clusters
- ML training environments
- AI APIs
- Backend inference systems
- Kubernetes networking

---

# 🧪 Validation & Testing Performed

---

## Connectivity Tests

Validated:
- Public internet access
- Private subnet isolation
- NAT outbound connectivity

---

## Route Table Validation

Verified:
- Public routing
- Private routing
- NAT routing

---

## NACL Testing

Validated:
- Explicit deny behavior
- Stateless firewall behavior
- Ephemeral port handling

---

## VPC Endpoint Validation

Tested:
- Private S3 access without NAT

---

## Terraform Validation

Verified:
- Successful infrastructure deployment
- State tracking
- Infrastructure destruction

---

# 🚀 Technologies & AWS Services Used

| Service / Tool | Purpose |
|---|---|
| Amazon VPC | Networking foundation |
| Subnets | Network segmentation |
| Internet Gateway | Internet connectivity |
| NAT Gateway | Outbound internet |
| Route Tables | Traffic routing |
| Security Groups | Instance firewall |
| NACLs | Subnet firewall |
| VPC Endpoints | Private AWS access |
| VPC Peering | VPC connectivity |
| EC2 | Testing infrastructure |
| Terraform | Infrastructure as Code |
| AWS CLI | AWS management |
| CloudCraft | Architecture diagrams |

---

# 🧠 Major Engineering Lessons Learned

---

## Proper networking design is foundational

Cloud infrastructure depends heavily on networking architecture.

---

## Public and private segmentation is critical

Not every system should be internet-facing.

---

## Routing controls everything

Traffic behavior depends entirely on route tables.

---

## Security requires multiple layers

Production systems use:
- NACLs
- Security Groups
- Private subnets
- Controlled routing

Together.

---

## Multi-AZ architecture is mandatory

Single-AZ systems are not production-grade.

---

## NAT enables secure outbound connectivity

Private systems can access internet without public exposure.

---

## VPC Endpoints improve security posture

AWS services can be accessed privately.

---

## Infrastructure as Code changes everything

Terraform enables:
- Repeatable deployments
- Automated infrastructure
- Scalable operations

---

# 🧠 Mindset Shift

Moved from:

> Viewing AWS networking as simple subnet creation

To:

> Understanding cloud networking as a carefully engineered system involving segmentation, routing, security, high availability, private connectivity, and automation

---

# 🚀 Final Outcome

By the end of Week 12 Project, successfully built understanding of:
- Production VPC architecture
- CIDR planning
- Public/private subnetting
- Internet routing
- NAT architecture
- Stateful vs stateless security
- Private AWS service access
- Multi-AZ resiliency
- Infrastructure automation using Terraform
- Real-world cloud networking engineering

This project established the networking foundation required for:
- Load Balancers
- Kubernetes
- EKS
- Service Meshes
- Auto Scaling
- Hybrid Cloud
- AI Infrastructure
- DevOps Engineering
- Enterprise Cloud Architecture

---