# WEEK 11 NOTES — AWS CORE SERVICES I: EC2 DEEP DIVE

## 📌 Week Overview

Week 11 focused on mastering Amazon EC2 deeply — the foundational compute service of AWS cloud infrastructure.

This week covered:
- EC2 instance families and sizing
- AMIs (Amazon Machine Images)
- EBS storage architecture
- Security Groups and key pairs
- EC2 pricing models
- User Data and Metadata services
- Infrastructure automation concepts
- Multi-tier AWS architecture design

The goal of this week was to move beyond simply launching EC2 instances and begin understanding how production-grade AWS infrastructure is designed, secured, automated, and scaled.

---

# 🧠 Core EC2 Fundamentals

---

# 1️⃣ EC2 Instance Types & Families

## EC2 Naming Convention

Example:

```text
m5.xlarge
```

Breakdown:

| Component | Meaning |
|---|---|
| m | Instance family |
| 5 | Generation |
| xlarge | Size |

---

## Important EC2 Families

| Family | Purpose |
|---|---|
| t | Burstable general workloads |
| m | General purpose |
| c | Compute optimized |
| r | Memory optimized |
| p / g | GPU workloads |
| i | Storage optimized |

---

## Important Instance Types for AI & Cloud Engineering

| Instance | Use Case |
|---|---|
| t3.micro | Development / Free Tier |
| m5.large | General workloads |
| c5.2xlarge | Compute-heavy workloads |
| p3.2xlarge | GPU model training |
| g4dn.xlarge | GPU inference |
| inf1.xlarge | ML inference optimized |

---

## Key Compute Concepts

### vCPU
Virtual CPU allocation for compute processing.

### Memory (RAM)
Used for application execution and caching.

### Network Bandwidth
Controls network throughput capability.

### EBS Optimized
Dedicated bandwidth between EC2 and EBS storage.

---

## Instance Store vs EBS

| Feature | Instance Store | EBS |
|---|---|---|
| Persistence | Temporary | Persistent |
| Lost on Stop? | YES | NO |
| Speed | Very Fast | Fast |
| Use Cases | Cache / Temporary | Production storage |

---

# 2️⃣ AMIs — Amazon Machine Images

---

## What is an AMI?

AMI = Blueprint for launching EC2 instances.

AMI includes:
- Root volume snapshot
- Launch permissions
- Block device mappings

---

## AMI Types

| Type | Description |
|---|---|
| AWS-managed | Official AWS images |
| Marketplace | Vendor-provided images |
| Community | Public community images |
| Custom AMIs | Your own reusable images |

---

## Common AMIs

| OS | Example |
|---|---|
| Amazon Linux 2023 | AWS optimized |
| Ubuntu Server 22.04 | Popular Linux distro |

---

## Custom AMI Workflow

```text
Launch Instance
       ↓
Install Software
       ↓
Create Image
       ↓
Reusable AMI
```

Benefits:
- Faster deployments
- Standardized infrastructure
- Immutable infrastructure patterns

---

## AMI Copy Between Regions

Used for:
- Disaster Recovery
- Multi-region deployments
- Global infrastructure replication

---

# 3️⃣ EBS Volumes — Storage Deep Dive

---

## EBS Volume Types

| Volume | Purpose |
|---|---|
| gp3 | General purpose SSD |
| io1/io2 | High-performance databases |
| st1 | Throughput HDD |
| sc1 | Cold HDD |

---

## gp3 Important Facts

- Default recommended EBS type
- SSD-based
- 3000 IOPS baseline
- Good balance of performance and price

---

## Attaching EBS Volumes

Example:

```bash
sudo mkfs -t ext4 /dev/xvdf
sudo mount /dev/xvdf /data
```

---

## Persistent Mounts

Using `/etc/fstab`:

```bash
echo '/dev/xvdf /data ext4 defaults,nofail 0 0' | sudo tee -a /etc/fstab
```

Purpose:
- Automatically remount after reboot

---

## EBS Snapshots

Snapshots are:
- Incremental backups
- Stored in S3 internally
- Used for disaster recovery

CLI Example:

```bash
aws ec2 create-snapshot \
--volume-id vol-xxx \
--description "backup"
```

---

## EBS Encryption

Best practice:
- Enable encryption by default
- Uses AWS KMS

Benefits:
- Data-at-rest security
- Compliance readiness

---

# 4️⃣ Security Groups & Key Pairs

---

# Security Groups

Security Groups are:
- Stateful firewalls
- Allow-only rules
- Instance-level security

---

## Important SG Characteristics

| Feature | Meaning |
|---|---|
| Stateful | Return traffic auto-allowed |
| Additive | Multiple SGs combine rules |
| No deny rules | Only allow rules exist |

---

## Layered SG Architecture

### web-sg

Allow:
- 80/443 from internet

### app-sg

Allow:
- 8080 only from web-sg

### db-sg

Allow:
- 3306 only from app-sg

---

## SG Referencing

Best practice:

```text
Source = web-sg
```

NOT:

```text
Source = IP address
```

Benefits:
- Dynamic trust
- Easier scaling
- Better security management

---

# Key Pairs

---

## Key Pair Fundamentals

AWS stores:
- Public key

You store:
- Private key

Important:
- Lost private key cannot be recovered

---

## RSA vs ED25519

| Type | Notes |
|---|---|
| RSA | Traditional |
| ED25519 | Faster, smaller, modern |

---

## Key Pair Best Practices

- Separate keys per environment
- Rotate keys regularly
- Never share `.pem` files
- Store securely

---

# 5️⃣ EC2 Pricing Models

---

# On-Demand

Characteristics:
- No commitment
- Most flexible
- Highest cost

Best for:
- Unpredictable workloads
- Short-term projects

---

# Reserved Instances (RIs)

Commitment:
- 1 year or 3 years

Discount:
- Up to 72%

Types:
- Standard
- Convertible
- Scheduled

Best for:
- Stable workloads

---

# Savings Plans

More flexible than RIs.

Types:
- Compute Savings Plans
- EC2 Savings Plans

Benefits:
- Lower cost
- Flexible compute usage

---

# Spot Instances

Characteristics:
- Up to 90% cheaper
- AWS can terminate anytime
- 2-minute warning provided

Best for:
- Batch jobs
- CI/CD
- ML training
- Fault-tolerant systems

---

# Cost Optimization Mindset

Production systems often use:

```text
Mix of:
- On-Demand
- Savings Plans
- Spot Instances
```

Goal:
- Balance reliability and cost

---

# 6️⃣ EC2 User Data & Metadata

---

# EC2 User Data

User Data:
- Startup script executed during first boot
- Used for bootstrapping automation

---

## Typical User Data Tasks

- Install packages
- Configure software
- Start services
- Download configs
- Deploy applications

---

## Example User Data Script

```bash
#!/bin/bash

yum update -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
```

---

# Bootstrapping Workflow

```text
Launch EC2
      ↓
OS Boot
      ↓
cloud-init
      ↓
Execute User Data
      ↓
Ready Infrastructure
```

---

# EC2 Metadata Service (IMDS)

Metadata endpoint:

```bash
http://169.254.169.254/latest/meta-data/
```

Provides:
- Instance ID
- Instance type
- IAM credentials
- AZ information
- Network details

---

## Metadata Retrieval Examples

Instance ID:

```bash
curl http://169.254.169.254/latest/meta-data/instance-id
```

Availability Zone:

```bash
curl http://169.254.169.254/latest/meta-data/placement/availability-zone
```

---

# IAM Role Credentials

Metadata can expose:
- Temporary AWS credentials

Benefits:
- Avoid hardcoded AWS keys
- Better security

---

# IMDSv1 vs IMDSv2

---

## IMDSv1

Problems:
- Vulnerable to SSRF attacks
- No authentication

---

## IMDSv2

Uses:
- Session tokens

Workflow:

### Generate Token

```bash
TOKEN=$(curl -X PUT \
"http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
```

### Use Token

```bash
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id
```

Benefits:
- Improved metadata security
- Production best practice

---

# Python App Deployment Automation

Production-style workflow:
- Install Python
- Create virtual environment
- Download app from S3
- Install dependencies
- Create systemd service
- Start app automatically

---

# systemd Fundamentals

Commands:

```bash
systemctl start myapp
systemctl enable myapp
systemctl status myapp
```

Purpose:
- Background service management
- Automatic startup
- Reliability

---

# Important Logs

## cloud-init Logs

```bash
/var/log/cloud-init.log
/var/log/cloud-init-output.log
```

## systemd Logs

```bash
journalctl -u myapp
```

---

# 7️⃣ Week 11 Review — 3-Tier Architecture

---

# 3-Tier Architecture

```text
Internet
    ↓
Web Tier (nginx)
    ↓
App Tier (Flask)
    ↓
Database Tier
```

---

# Web Tier

Components:
- nginx
- Public-facing EC2

Responsibilities:
- Handle internet traffic
- Reverse proxy

---

# App Tier

Components:
- Flask application
- Private EC2

Responsibilities:
- Business logic
- APIs

---

# DB Tier

Current:
- SQLite

Future:
- Amazon RDS

---

# Reverse Proxy Architecture

Request flow:

```text
User
  ↓
nginx
  ↓
Flask App
```

Benefits:
- Backend isolation
- Security
- Scalability

---

# Multi-Tier Security Groups

| SG | Allows |
|---|---|
| web-sg | Internet traffic |
| app-sg | Traffic only from web-sg |
| db-sg | Traffic only from app-sg |

---

# Infrastructure Automation with boto3

Example:

```python
import boto3

ec2 = boto3.resource('ec2')

instances = ec2.create_instances(
    ImageId='ami-xxxx',
    MinCount=1,
    MaxCount=1,
    InstanceType='t2.micro'
)
```

Purpose:
- Infrastructure as Code
- Automated provisioning

---

# Architecture Documentation

Tools:
- draw.io
- Excalidraw

Architecture diagrams should include:
- Internet
- Web/App/DB tiers
- Security Groups
- Traffic flow
- Public/private networking

---

# 🔥 Most Important Week 11 Concepts

---

## EC2 is the foundation of AWS infrastructure

Everything builds on compute.

---

## Security Groups are critical

Proper SG architecture defines cloud security posture.

---

## EBS powers persistent storage

Understanding storage is essential for infrastructure reliability.

---

## User Data enables automation

Infrastructure should self-configure automatically.

---

## IMDS security matters

Metadata exposure can become a major security risk.

---

## Multi-tier architectures are production standard

Separation of concerns improves:
- Security
- Scalability
- Reliability

---

## Infrastructure as Code is mandatory

Manual infrastructure does not scale.

---

# 🧠 Week 11 Mindset Shift

Moved from:

> Viewing EC2 as simple virtual machines

To:

> Understanding EC2 as programmable, scalable, secure cloud infrastructure components powering production systems

---

# 🚀 Week 11 Outcome

By the end of Week 11, built understanding of:
- EC2 architecture
- Cloud compute fundamentals
- Persistent storage
- Security layering
- Infrastructure automation
- Multi-tier design
- Bootstrapping
- Metadata services
- Cost optimization
- Production infrastructure thinking

---

# 📚 Week 11 Summary

Week 11 established the foundational compute knowledge required for becoming a strong AI Cloud Infrastructure Engineer.

This week transformed EC2 knowledge from:
- Basic instance launching

Into:
- Real-world infrastructure engineering skills involving automation, security, storage, networking, scaling, and architecture design.

Week 11 created the base required for:
- Advanced VPC networking
- Load balancing
- Auto Scaling
- Kubernetes
- Infrastructure as Code
- Production cloud systems

---