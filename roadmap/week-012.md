# WEEK 12 ROADMAP — AWS CORE SERVICES II: VPC DEEP DIVE

## 📌 Week 12 Focus

Master AWS networking deeply by designing and building a production-grade VPC architecture from scratch.

Main learning areas:
- Amazon VPC
- CIDR planning
- Public vs private subnets
- Internet routing
- NAT Gateway architecture
- Network security
- VPC Endpoints
- VPC Peering
- Infrastructure as Code using Terraform

Goal:
- Build strong cloud networking foundations required for production infrastructure, Kubernetes, DevOps, and AI cloud systems.

---

# 🧠 Week 12 Learning Objectives

By the end of Week 12, aim to understand:

- How AWS networking works internally
- How cloud infrastructure is segmented securely
- How public and private traffic flows operate
- How internet connectivity is controlled
- How subnet-level and instance-level security work
- How AWS services can be accessed privately
- How production VPC architectures are designed
- How Infrastructure as Code automates networking

---

# 🗓️ Week 12 Daily Roadmap

---

# 📅 Day 78 — VPC Fundamentals

## 🎯 Goals

Understand:
- What a VPC is
- CIDR blocks
- AWS default VPC
- Production VPC planning

---

## 📚 Topics to Learn

### VPC Basics

Learn:
- VPC = isolated AWS network
- CIDR ranges
- AWS VPC limits

Example:

```text
10.0.0.0/16
```

---

### Default VPC

Understand:
- Why AWS provides default VPCs
- Why production should avoid default VPC usage

---

### CIDR Planning

Design production architecture:

| Subnet | CIDR |
|---|---|
| Public AZ1 | 10.0.1.0/24 |
| Public AZ2 | 10.0.2.0/24 |
| Private AZ1 | 10.0.11.0/24 |
| Private AZ2 | 10.0.12.0/24 |

---

## 🛠️ Hands-On Tasks

- Create custom VPC
- Enable DNS resolution
- Enable DNS hostnames
- Document subnet plan

---

## 🧠 Key Outcome

Understand:
- VPC foundations
- CIDR architecture
- Production network planning

---

# 📅 Day 79 — Subnets: Public vs Private

## 🎯 Goals

Understand:
- Subnet architecture
- Public vs private networking
- Availability Zones
- AWS reserved IP behavior

---

## 📚 Topics to Learn

### Public Subnets

Characteristics:
- Public IP assignment
- Internet accessibility

---

### Private Subnets

Characteristics:
- No public IPs
- Backend-only systems

---

### Availability Zones

Learn:
- Multi-AZ architecture
- High availability networking

---

### AWS Reserved IPs

Understand:
- First 4 IPs reserved
- Last IP reserved

---

## 🛠️ Hands-On Tasks

- Create 2 public subnets
- Create 2 private subnets
- Spread across 2 AZs
- Enable auto-assign public IP only for public subnets

---

## 🧠 Key Outcome

Understand:
- Network segmentation
- Multi-AZ design
- Public/private isolation

---

# 📅 Day 80 — Internet Gateway & Route Tables

## 🎯 Goals

Understand:
- Internet connectivity
- AWS routing behavior
- Public vs private traffic flow

---

## 📚 Topics to Learn

### Internet Gateway (IGW)

Learn:
- IGW enables internet connectivity
- One IGW per VPC

---

### Route Tables

Learn:
- Routes control traffic flow
- Public route tables
- Private route tables

---

### Local Route

Understand:

```text
10.0.0.0/16 → local
```

Purpose:
- Internal VPC communication

---

## 🛠️ Hands-On Tasks

- Create Internet Gateway
- Attach IGW to VPC
- Create public route table
- Associate public subnets
- Create private route table
- Test connectivity

---

## 🧠 Key Outcome

Understand:
- Internet routing
- Route table architecture
- Public vs private connectivity

---

# 📅 Day 81 — NAT Gateway & Private Internet Access

## 🎯 Goals

Understand:
- Secure outbound internet access
- NAT architecture
- Bastion host access patterns

---

## 📚 Topics to Learn

### NAT Gateway

Learn:
- Private subnet outbound internet
- NAT placement requirements

---

### Elastic IP

Understand:
- NAT requires Elastic IP

---

### Bastion Host Architecture

Understand secure admin access:

```text
Laptop
   ↓
Public EC2
   ↓
Private EC2
```

---

### NAT Gateway Pricing

Learn:
- NAT Gateway cost model
- NAT Instance alternatives

---

## 🛠️ Hands-On Tasks

- Allocate Elastic IP
- Create NAT Gateway
- Update private route table
- Test internet from private subnet

---

## 🧠 Key Outcome

Understand:
- Secure outbound networking
- Private internet architecture
- Cost-aware networking design

---

# 📅 Day 82 — NACLs vs Security Groups

## 🎯 Goals

Understand:
- AWS firewall architecture
- Stateful vs stateless networking
- Defense in depth

---

## 📚 Topics to Learn

### Security Groups

Learn:
- Stateful behavior
- Instance-level filtering

---

### Network ACLs

Learn:
- Stateless behavior
- Subnet-level filtering
- Explicit deny rules

---

### Ephemeral Ports

Understand:

```text
1024-65535
```

Importance:
- Return traffic handling

---

## 🛠️ Hands-On Tasks

- Create custom NACL
- Configure HTTP/HTTPS rules
- Allow ephemeral ports
- Create explicit deny rules
- Associate NACLs with public subnets
- Test connectivity failures

---

## 🧠 Key Outcome

Understand:
- Cloud firewall architecture
- Layered AWS security
- Traffic filtering behavior

---

# 📅 Day 83 — VPC Endpoints & Peering

## 🎯 Goals

Understand:
- Private AWS connectivity
- VPC-to-VPC networking

---

## 📚 Topics to Learn

### VPC Endpoints

Learn:
- Gateway Endpoints
- Interface Endpoints (PrivateLink)

---

### S3 Gateway Endpoint

Understand:
- Private S3 access
- Reduced NAT dependency

---

### VPC Peering

Learn:
- Private VPC communication
- Non-transitive networking

---

## 🛠️ Hands-On Tasks

- Create S3 Gateway Endpoint
- Associate endpoint with route tables
- Test private S3 access
- Study Interface Endpoints
- Understand VPC Peering workflow

---

## 🧠 Key Outcome

Understand:
- Private AWS networking
- Inter-VPC communication
- Secure service access

---

# 📅 Day 84 — Build Complete Production VPC with Terraform

## 🎯 Goals

Understand:
- Infrastructure as Code (IaC)
- Terraform basics
- Automated AWS networking deployment

---

## 📚 Topics to Learn

### Terraform Fundamentals

Learn:
- Terraform providers
- Resources
- State management
- Infrastructure lifecycle

---

### Terraform Workflow

Commands:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

### Infrastructure as Code

Understand:
- Reproducible infrastructure
- Version-controlled networking
- Automated deployments

---

## 🛠️ Hands-On Tasks

- Install Terraform
- Create `main.tf`
- Build VPC using code
- Create subnets
- Create route tables
- Deploy infrastructure
- Destroy infrastructure safely
- Document architecture diagram

---

## 🧠 Key Outcome

Understand:
- Infrastructure automation
- Terraform workflows
- Production IaC mindset

---

# 🏗️ Final Architecture Goal

By end of Week 12:

```text
                           Internet
                               ↓
                     Internet Gateway
                               ↓
                     Public Route Table
                         ↓            ↓
                  Public AZ1     Public AZ2
                         ↓
                     NAT Gateway
                         ↓
                    Private Routes
                         ↓
                 Private AZ1    Private AZ2
```

---

# 🔐 Security Goals

By end of week, understand:
- Subnet isolation
- Layered security
- Stateful vs stateless firewalls
- Private networking
- Explicit deny rules
- Defense-in-depth architecture

---

# 🚀 Terraform Goals

Learn:
- Infrastructure provisioning
- AWS automation
- Reproducible networking
- State tracking

Files created:

```text
main.tf
terraform.tfstate
terraform.tfstate.backup
```

---

# 🧠 Important Skills Built This Week

---

## Networking Skills

- CIDR planning
- Subnetting
- Routing
- NAT architecture
- Multi-AZ networking

---

## Security Skills

- Security Groups
- NACLs
- Firewall logic
- Private networking

---

## Cloud Architecture Skills

- Production VPC design
- High availability
- Traffic flow design
- Infrastructure segmentation

---

## DevOps Skills

- Terraform basics
- Infrastructure as Code
- Automated provisioning

---

# 🔥 Most Important Week 12 Mindset

Moved from:

> Viewing networking as basic internet connectivity

To:

> Understanding cloud networking as a production-grade architecture involving routing, segmentation, security, automation, resiliency, and private infrastructure design

---

# 🚀 Week 12 Outcome

By completing Week 12, built foundational understanding required for:
- Kubernetes networking
- EKS
- Load Balancers
- Auto Scaling
- Hybrid Cloud
- Service Meshes
- AI Infrastructure
- DevOps Engineering
- Enterprise Cloud Networking

Week 12 established the networking base for all future cloud infrastructure engineering work.

---

**Week Status:** Complete ✅  
**Primary Focus:** AWS Networking & VPC Architecture  
**Days Covered:** 78 → 84  
**Progress:** 84 / 1000 Days 🚀

---