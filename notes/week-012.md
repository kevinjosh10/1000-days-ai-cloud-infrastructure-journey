# WEEK 12 NOTES — AWS CORE SERVICES II: VPC DEEP DIVE

## 📌 Week Overview

Week 12 focused on mastering AWS networking fundamentals using Amazon VPC (Virtual Private Cloud).

This week covered:
- VPC architecture fundamentals
- CIDR planning and subnetting
- Public vs private subnet design
- Internet Gateways and route tables
- NAT Gateways and outbound internet access
- Security Groups vs NACLs
- VPC Endpoints and PrivateLink
- VPC Peering
- Multi-AZ production networking
- Infrastructure as Code using Terraform
- Production-grade AWS network architecture

The goal of this week was to understand how real-world AWS cloud networks are designed, segmented, secured, and automated for scalable production systems.

---

# 🧠 Core VPC Fundamentals

---

# 1️⃣ Amazon VPC Fundamentals

---

## What is a VPC?

VPC = Virtual Private Cloud.

A VPC is:
- Your isolated private network inside AWS
- A logically separated networking environment
- The foundation of AWS infrastructure

---

## VPC CIDR Blocks

Example:

```text
10.0.0.0/16
```

Meaning:
- Defines the IP range available inside the VPC
- `/16` provides:

```text
65,536 IP addresses
```

---

## VPC CIDR Range Limits

AWS supports:

```text
/16 → /28
```

Examples:

| CIDR | IP Count |
|---|---|
| /16 | 65,536 |
| /24 | 256 |
| /28 | 16 |

---

## Default VPC

Every AWS account receives:
- One default VPC per region

Characteristics:
- Public subnets already configured
- Internet Gateway attached
- Easier for beginners

---

## Why NOT Use Default VPC in Production?

Problems:
- Flat architecture
- Weak segmentation
- Poor security design
- Harder governance
- Less control

Production best practice:
- Build custom VPCs manually

---

## Production VPC Planning

Example production design:

```text
VPC: 10.0.0.0/16
```

Subnet allocation:

| Subnet | CIDR |
|---|---|
| Public AZ1 | 10.0.1.0/24 |
| Public AZ2 | 10.0.2.0/24 |
| Private AZ1 | 10.0.11.0/24 |
| Private AZ2 | 10.0.12.0/24 |

---

## VPC DNS Settings

Important settings:
- Enable DNS Hostnames
- Enable DNS Resolution

Purpose:
- EC2 instances receive internal DNS names
- Required for many AWS services

---

# 2️⃣ Subnets — Public vs Private

---

## What is a Subnet?

A subnet is:
- A smaller IP range inside a VPC

Example:

```text
10.0.1.0/24
```

Characteristics:
- Exists in only ONE Availability Zone
- Used for workload segmentation

---

## AWS Reserved IPs

AWS reserves:
- First 4 IPs
- Last 1 IP

Example:

```text
10.0.1.0/24
```

Reserved:

```text
10.0.1.0
10.0.1.1
10.0.1.2
10.0.1.3
10.0.1.255
```

Usable:
- 251 IPs

---

## Public Subnets

Characteristics:
- Route to Internet Gateway
- Instances can have public IPs

Example:

```text
10.0.1.0/24
10.0.2.0/24
```

Settings:
- Enable auto-assign public IP

---

## Private Subnets

Characteristics:
- No direct internet access
- Backend/internal systems only

Example:

```text
10.0.11.0/24
10.0.12.0/24
```

Settings:
- Disable auto-assign public IP

---

## Multi-AZ Architecture

Production best practice:
- Use at least 2 Availability Zones

Example:

```text
us-east-1a
us-east-1b
```

Benefits:
- High availability
- Fault tolerance
- Better resiliency

---

## CIDR Planning

Important rule:
- Subnets must NEVER overlap

Verification example:

```bash
ipcalc 10.0.1.0/24
```

Best practice:
- Plan subnet allocation before deployment

---

# 3️⃣ Internet Gateway & Route Tables

---

# Internet Gateway (IGW)

---

## What is an Internet Gateway?

IGW:
- Connects VPC to the internet
- Managed by AWS
- Highly available

Characteristics:
- One IGW per VPC

---

## Internet Traffic Flow

```text
Internet
    ↓
Internet Gateway
    ↓
Public Subnet
```

---

# Route Tables

---

## What is a Route Table?

Route tables define:
- Where network traffic should go

---

## Public Route Table

Important route:

```text
0.0.0.0/0 → IGW
```

Meaning:
- Send all internet traffic to Internet Gateway

Associated with:
- Public subnets

---

## Private Route Table

Characteristics:
- No direct route to IGW

Associated with:
- Private subnets

Purpose:
- Keep backend systems isolated

---

## Local Route

Automatically added:

```text
10.0.0.0/16 → local
```

Purpose:
- Enables communication inside VPC

---

## Connectivity Testing

Public EC2:

```bash
curl google.com
```

Expected:
- Works

Private EC2:
- No internet access initially

---

# 4️⃣ NAT Gateway & Private Internet Access

---

# NAT Gateway Fundamentals

---

## What is a NAT Gateway?

NAT Gateway allows:
- Private subnet instances to access the internet outbound
- Without accepting inbound internet traffic

---

## NAT Gateway Placement

MUST be deployed in:
- Public subnet

Requires:
- Elastic IP (EIP)

---

## Private Subnet Internet Flow

```text
Private EC2
     ↓
Private Route Table
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

---

## Private Route Table Update

Add route:

```text
0.0.0.0/0 → NAT Gateway
```

---

## Bastion Host Architecture

Workflow:

```text
Laptop
   ↓
Public EC2 (Bastion)
   ↓
Private EC2
```

Purpose:
- Secure administrative access

---

## NAT Gateway Pricing

Approximate pricing:

```text
~$0.045/hour
~$0.045/GB
```

Important:
- NAT Gateway is NOT free

---

## NAT Instance Alternative

Lower-cost alternative:
- EC2 NAT Instance

Requirements:
- Disable source/destination checks

Best for:
- Development environments

---

# 5️⃣ NACLs vs Security Groups

---

# Security Groups

---

## Security Group Characteristics

Security Groups are:
- Stateful
- Instance-level firewalls
- Allow-only

---

## Stateful Behavior

```text
Inbound Allowed
      ↓
Return Traffic Automatically Allowed
```

---

# Network ACLs (NACLs)

---

## NACL Characteristics

NACLs are:
- Stateless
- Subnet-level firewalls
- Allow + deny capable

---

## Stateless Behavior

```text
Inbound Allowed
      ↓
Outbound MUST ALSO Be Allowed
```

---

## NACL Rule Processing

Rules evaluated:
- Lowest rule number first

Example:

```text
90 → DENY
100 → ALLOW
```

First match wins.

---

## Security Groups vs NACLs

| Feature | Security Group | NACL |
|---|---|---|
| Level | Instance | Subnet |
| Stateful | Yes | No |
| Allow Rules | Yes | Yes |
| Deny Rules | No | Yes |
| Rule Processing | All rules | Ordered |

---

## Ephemeral Ports

Range:

```text
1024-65535
```

Used for:
- Return traffic

Important:
- Must be allowed in stateless firewalls

---

## NACL Deny Rules

Example:

```text
203.0.113.0/24 → DENY
```

Purpose:
- Block malicious IP ranges

---

## Defense in Depth

Production security layering:

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

# 6️⃣ VPC Endpoints & Peering

---

# VPC Endpoints

---

## What are VPC Endpoints?

VPC Endpoints allow:
- Private AWS service access
- Without internet routing

Benefits:
- Better security
- Lower NAT costs

---

## Gateway Endpoints

Supported services:
- S3
- DynamoDB

Example:

```text
com.amazonaws.us-east-1.s3
```

---

## Gateway Endpoint Traffic Flow

```text
Private EC2
      ↓
VPC Endpoint
      ↓
S3
```

No internet required.

---

## Interface Endpoints (PrivateLink)

Used for:
- Secrets Manager
- EC2 API
- KMS
- CloudWatch

Characteristics:
- Creates ENI inside subnet

Benefits:
- Private AWS API access

---

# VPC Peering

---

## What is VPC Peering?

VPC Peering:
- Connects two VPCs privately

Requirements:
- Route updates in both VPCs
- Security Group updates

---

## Non-Transitive Nature

Example:

```text
A ↔ B
B ↔ C
```

Does NOT mean:

```text
A ↔ C
```

---

## Peering Use Cases

- Multi-environment communication
- Shared services
- Multi-team networking
- Hybrid architectures

---

# 7️⃣ Terraform & Infrastructure as Code

---

# Terraform Fundamentals

---

## What is Terraform?

Terraform:
- Infrastructure as Code tool
- Created by HashiCorp

Purpose:
- Automate infrastructure provisioning

---

## Infrastructure as Code (IaC)

IaC means:
- Managing infrastructure using code

Benefits:
- Automation
- Version control
- Reproducibility
- Faster deployments

---

## Terraform Workflow

### Initialize

```bash
terraform init
```

Downloads:
- Providers
- Plugins

---

### Plan

```bash
terraform plan
```

Purpose:
- Preview infrastructure changes

---

### Apply

```bash
terraform apply
```

Purpose:
- Deploy infrastructure

---

### Destroy

```bash
terraform destroy
```

Purpose:
- Remove infrastructure safely

---

# Terraform AWS Provider

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

# Terraform VPC Resources

Common resources:

| Resource | Purpose |
|---|---|
| aws_vpc | Create VPC |
| aws_subnet | Create subnet |
| aws_internet_gateway | Create IGW |
| aws_nat_gateway | Create NAT |
| aws_route_table | Routing |
| aws_route | Routes |
| aws_route_table_association | Associations |

---

## Example Terraform Architecture

```text
Terraform
     ↓
AWS API
     ↓
VPC Infrastructure
```

---

## Terraform State

Terraform tracks infrastructure using:

```text
terraform.tfstate
```

Purpose:
- Resource tracking
- Dependency mapping
- Lifecycle management

---

## Infrastructure Lifecycle

```text
Create
   ↓
Modify
   ↓
Destroy
```

---

# 8️⃣ Production VPC Architecture

---

# Production 3-Tier Networking

```text
Internet
    ↓
Public Subnet
    ↓
Load Balancer / Bastion
    ↓
Private Subnet
    ↓
Application Servers
    ↓
Database Tier
```

---

# Public Tier

Contains:
- Bastion Hosts
- Load Balancers
- Reverse Proxies

Characteristics:
- Internet-facing

---

# Private App Tier

Contains:
- Backend APIs
- Internal services
- AI inference systems

Characteristics:
- No public access

---

# Database Tier

Contains:
- RDS
- Databases
- Stateful systems

Characteristics:
- Most restricted layer

---

# High Availability Design

Production systems:
- Span multiple AZs
- Avoid single points of failure

---

# AI Infrastructure Networking

AI systems commonly require:
- Private GPU clusters
- Secure ML environments
- Internal APIs
- Controlled internet access

---

# VPC Security Best Practices

- Use private subnets whenever possible
- Minimize internet exposure
- Use Security Groups + NACLs together
- Use VPC Endpoints for AWS services
- Segment workloads properly
- Enable multi-AZ architecture

---

# 🔥 Most Important Week 12 Concepts

---

## VPC is the foundation of AWS networking

Everything in AWS networking starts with VPC design.

---

## Public and private subnet separation is critical

Proper segmentation improves:
- Security
- Scalability
- Reliability

---

## Route tables control traffic flow

Networking behavior depends entirely on routing.

---

## NAT Gateway enables secure outbound internet

Private systems should not be publicly reachable.

---

## Security Groups and NACLs serve different purposes

Both layers together create strong network security.

---

## Multi-AZ architecture is mandatory in production

Single-AZ systems are not highly available.

---

## VPC Endpoints improve security and reduce cost

Private AWS access avoids unnecessary internet routing.

---

## Infrastructure as Code is essential

Modern cloud infrastructure must be automated and reproducible.

---

# 🧠 Week 12 Mindset Shift

Moved from:

> Viewing AWS networking as simple internet connectivity

To:

> Understanding VPC architecture as a secure, segmented, highly available cloud networking system powering production infrastructure

---

# 🚀 Week 12 Outcome

By the end of Week 12, built understanding of:
- AWS networking architecture
- CIDR planning
- Public/private subnet design
- Internet routing
- NAT architecture
- Subnet-level security
- Private AWS connectivity
- VPC communication
- Terraform automation
- Production-grade cloud networking

---

# 📚 Week 12 Summary

Week 12 established the foundational networking knowledge required for designing secure and scalable AWS cloud infrastructure.

This week transformed VPC knowledge from:
- Basic subnet creation

Into:
- Real-world cloud network engineering involving routing, segmentation, internet access control, multi-AZ resiliency, security layering, private AWS connectivity, and Infrastructure as Code automation.

Week 12 created the base required for:
- Load Balancers
- Auto Scaling
- Kubernetes Networking
- EKS
- Service Meshes
- Hybrid Cloud
- Enterprise Security
- Production AI Infrastructure
- Advanced DevOps Networking
- Multi-Region Architectures

---