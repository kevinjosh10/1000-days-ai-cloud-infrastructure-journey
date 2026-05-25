# WEEK 12 RECAP — AWS CORE SERVICES II: VPC DEEP DIVE

## 📌 Week 12 Overview

Week 12 focused entirely on mastering AWS networking using Amazon VPC (Virtual Private Cloud).

This week covered:
- VPC architecture
- CIDR planning and subnetting
- Public vs private subnet design
- Internet Gateways
- Route tables
- NAT Gateway architecture
- NACLs vs Security Groups
- VPC Endpoints
- VPC Peering
- Multi-AZ networking
- Infrastructure as Code using Terraform

The goal of this week was to understand how real-world cloud infrastructure networking works in production environments.

---

# 🧠 Major Concepts Learned

---

# 1️⃣ VPC Fundamentals

Learned:
- A VPC is an isolated private network in AWS
- Every VPC uses a CIDR block
- Example:

```text
10.0.0.0/16
```

Understood:
- `/16` provides 65,536 IP addresses
- VPCs form the networking foundation of AWS infrastructure

---

## Important VPC Concepts

| Concept | Meaning |
|---|---|
| CIDR | Defines IP range |
| Isolation | Separates AWS networks |
| DNS Resolution | Internal hostname support |
| DNS Hostnames | Enables EC2 DNS names |

---

## Default VPC Understanding

Learned:
- Every AWS region has a default VPC
- Default VPCs are beginner-friendly
- Production environments should use custom VPCs instead

---

# 2️⃣ CIDR Planning & Subnet Design

Planned production VPC layout:

| Subnet | CIDR |
|---|---|
| Public AZ1 | 10.0.1.0/24 |
| Public AZ2 | 10.0.2.0/24 |
| Private AZ1 | 10.0.11.0/24 |
| Private AZ2 | 10.0.12.0/24 |

Learned:
- Subnets divide VPC IP ranges
- CIDR planning prevents overlap issues
- AWS reserves 5 IPs per subnet

---

## Public vs Private Subnets

### Public Subnet

Characteristics:
- Internet accessible
- Uses public IPs
- Connected to IGW

Examples:
- Bastion hosts
- Load balancers

---

### Private Subnet

Characteristics:
- No direct internet access
- Internal-only systems

Examples:
- Databases
- APIs
- AI workloads

---

# 3️⃣ Multi-AZ Architecture

Studied:
- High availability design

Used:
- us-east-1a
- us-east-1b

Learned:
- Production systems should span multiple AZs
- Prevents single-AZ failure risks

---

# 4️⃣ Internet Gateway & Routing

Created:
- Internet Gateway (IGW)

Purpose:
- Connect VPC to internet

---

## Public Route Table

Configured:

```text
0.0.0.0/0 → Internet Gateway
```

Associated with:
- Public subnets

---

## Private Route Table

Characteristics:
- No internet route initially

Purpose:
- Isolate backend systems

---

## Local Route Understanding

Automatically added route:

```text
10.0.0.0/16 → local
```

Purpose:
- Enables internal VPC communication

---

# 5️⃣ Connectivity Testing

Validated:
- Public EC2 internet access
- Private EC2 isolation

Used:

```bash
curl google.com
```

Results:

| Subnet Type | Internet Access |
|---|---|
| Public | YES |
| Private | NO |

---

# 6️⃣ NAT Gateway Architecture

Learned:
- NAT Gateway allows outbound internet access for private subnets

Requirements:
- Public subnet placement
- Elastic IP

---

## Private Internet Flow

```text
Private EC2
      ↓
NAT Gateway
      ↓
Internet Gateway
      ↓
Internet
```

---

## Private Route Table Update

Added:

```text
0.0.0.0/0 → NAT Gateway
```

Result:
- Private instances gained outbound internet access

---

## NAT Gateway Cost Awareness

Learned:
- NAT Gateway is NOT free

Approximate pricing:

```text
~$0.045/hour
~$0.045/GB
```

Alternative:
- NAT Instance for development

---

# 7️⃣ Security Groups vs NACLs

Studied:
- Stateful vs stateless firewalls

---

## Security Groups

Characteristics:
- Stateful
- Instance-level
- Allow rules only

Behavior:

```text
Inbound Allowed
      ↓
Return Traffic Automatically Allowed
```

---

## Network ACLs (NACLs)

Characteristics:
- Stateless
- Subnet-level
- Allow + deny rules

Behavior:

```text
Inbound Allowed
      ↓
Outbound Must ALSO Be Allowed
```

---

## Comparison Table

| Feature | Security Group | NACL |
|---|---|---|
| Level | Instance | Subnet |
| Stateful | Yes | No |
| Deny Rules | No | Yes |
| Rule Order | No order | Ordered |

---

# 8️⃣ Ephemeral Ports

Learned:
- Return traffic uses temporary ports

Range:

```text
1024-65535
```

Importance:
- Required for stateless communication

---

# 9️⃣ Explicit Deny Rules

Configured:
- NACL deny rules

Example:

```text
203.0.113.0/24 → DENY
```

Learned:
- Security Groups cannot explicitly deny traffic
- NACLs can

---

# 🔟 Defense-in-Depth Security

Studied layered protection:

```text
Internet
    ↓
NACL
    ↓
Security Group
    ↓
Application
```

Learned:
- Production environments use multiple security layers

---

# 1️⃣1️⃣ VPC Endpoints

Studied:
- Private AWS service access

Purpose:
- Avoid internet routing for AWS services

---

## Gateway Endpoints

Created:
- S3 Gateway Endpoint

Traffic flow:

```text
Private EC2
      ↓
VPC Endpoint
      ↓
S3
```

Benefits:
- Improved security
- Reduced NAT cost

---

## Interface Endpoints (PrivateLink)

Studied services:
- Secrets Manager
- KMS
- EC2 API

Learned:
- AWS APIs can be privately consumed inside VPC

---

# 1️⃣2️⃣ VPC Peering

Learned:
- VPC-to-VPC private communication

Requirements:
- Routes in both VPCs
- Security Group updates

---

## Non-Transitive Nature

Example:

```text
A ↔ B
B ↔ C

A ≠ C
```

Learned:
- Peering does not automatically forward traffic between all VPCs

---

# 1️⃣3️⃣ Terraform Fundamentals

Installed:
- Terraform on Windows

Learned:
- Infrastructure as Code (IaC)

Purpose:
- Build infrastructure using code

---

## Terraform Workflow

### Initialize

```bash
terraform init
```

---

### Preview Changes

```bash
terraform plan
```

---

### Deploy Infrastructure

```bash
terraform apply
```

---

### Destroy Infrastructure

```bash
terraform destroy
```

---

# 1️⃣4️⃣ Built Complete VPC Using Terraform

Created:
- `main.tf`

Automated:
- VPC
- Subnets
- Route tables
- Internet Gateway
- Associations

---

## Terraform State Management

Used:

```bash
terraform state list
```

Observed:
- Terraform tracks infrastructure resources

Important files:

```text
terraform.tfstate
terraform.tfstate.backup
```

---

# 1️⃣5️⃣ Infrastructure as Code Mindset

Understood:
- Infrastructure should be:
  - Reproducible
  - Automated
  - Version-controlled

Benefits:
- Faster deployments
- Easier scaling
- Reduced manual errors

---

# 🏗️ Final Architecture Built

```text
                           Internet
                               ↓
                     Internet Gateway (IGW)
                               ↓
                   Public Route Table
                         ↓           ↓
                 Public Subnet   Public Subnet
                    AZ1              AZ2
                         ↓
                    NAT Gateway
                         ↓
                  Private Route Table
                         ↓
                Private Subnet AZ1
                Private Subnet AZ2
```

---

# 🔥 Most Important Week 12 Lessons

---

## VPC is the foundation of AWS networking

Everything depends on proper VPC design.

---

## Public and private subnet separation is critical

Not every resource should face the internet.

---

## Route tables control traffic flow

Networking behavior depends entirely on routing.

---

## NAT Gateway enables secure outbound internet

Private systems can access internet safely.

---

## NACLs and Security Groups work together

Production environments require layered security.

---

## Multi-AZ design is mandatory

High availability requires multiple AZs.

---

## VPC Endpoints improve security posture

AWS services can be accessed privately.

---

## Infrastructure as Code is the future

Terraform enables scalable cloud operations.

---

# 🧠 Week 12 Mindset Shift

Moved from:

> Viewing networking as basic internet connectivity

To:

> Understanding cloud networking as a carefully engineered system involving segmentation, routing, security, high availability, and infrastructure automation

---

# 🚀 Skills Gained This Week

Built understanding of:
- AWS networking architecture
- CIDR planning
- Subnetting
- Public/private routing
- NAT architecture
- Security layering
- Stateless vs stateful firewalls
- Private AWS connectivity
- Multi-AZ design
- Terraform automation
- Infrastructure as Code

---

# 📚 Week 12 Final Summary

Week 12 established the networking foundation required for becoming a strong AI Cloud Infrastructure Engineer.

This week transformed networking knowledge from:
- Basic subnet creation

Into:
- Real-world cloud network engineering involving routing, security, private connectivity, high availability, segmentation, and Infrastructure as Code.

Week 12 created the foundation required for:
- Load Balancers
- Auto Scaling
- Kubernetes Networking
- EKS
- Hybrid Cloud
- DevOps Engineering
- Service Meshes
- Enterprise Security
- AI Infrastructure Networking

---

**Status:** Week 12 Complete  
**Focus Area:** AWS Networking & Production VPC Architecture  
**Progress:** 84 / 1000 Days 🚀

---