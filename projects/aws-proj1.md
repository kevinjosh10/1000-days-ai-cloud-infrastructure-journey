# WEEK 11 PROJECTS — AWS CORE SERVICES I: EC2 DEEP DIVE

## 📌 Week Overview

Week 11 projects focused on building strong hands-on AWS EC2 infrastructure skills through practical deployments, storage management, security architecture, automation, and multi-tier cloud system design.

Projects completed this week emphasized:
- EC2 deployment
- AMI management
- EBS storage operations
- Security Group architecture
- EC2 automation
- Infrastructure bootstrapping
- Metadata retrieval
- Multi-tier cloud architecture

These projects simulated real-world cloud engineering workflows used in production AWS environments.

---

# 🚀 Project 1 — EC2 Instance Family Research Lab

## 🎯 Objective

Understand AWS EC2 instance families, sizing models, and workload optimization strategies.

---

## ✅ Tasks Completed

- Studied EC2 naming convention:
  
```text
m5.xlarge
```

- Learned:
  - Family
  - Generation
  - Size structure

- Explored important EC2 families:
  - t-series
  - m-series
  - c-series
  - r-series
  - p/g GPU families
  - i-series

- Compared:
  - vCPU
  - Memory
  - Network bandwidth
  - EBS optimization

- Used:
  - instances.vantage.sh

- Practiced:
  - GPU filtering
  - Cost comparison
  - Instance selection analysis

---

## 🧠 Skills Gained

- EC2 sizing
- Cloud workload planning
- Compute optimization
- Cost-performance analysis
- AI/ML infrastructure awareness

---

# 🚀 Project 2 — Custom AMI Creation Lab

## 🎯 Objective

Learn how to create reusable infrastructure templates using AMIs.

---

## ✅ Tasks Completed

- Launched EC2 instance
- Installed:
  - nginx
  - python3

- Configured server manually
- Created custom AMI using:

```text
Actions → Create Image
```

- Recorded custom AMI ID
- Copied AMI to another region

---

## 🧠 Skills Gained

- Immutable infrastructure concepts
- Infrastructure standardization
- Disaster recovery planning
- Multi-region deployment understanding

---

# 🚀 Project 3 — EBS Storage Management Lab

## 🎯 Objective

Understand AWS block storage management and persistence.

---

## ✅ Tasks Completed

- Created additional EBS volume
- Attached volume to running EC2 instance
- Formatted volume:

```bash
sudo mkfs -t ext4 /dev/xvdf
```

- Mounted storage:

```bash
sudo mount /dev/xvdf /data
```

- Configured persistent mounting using:

```bash
/etc/fstab
```

- Created EBS snapshot
- Enabled EBS encryption

---

## 🧠 Skills Gained

- Linux storage management
- Persistent storage configuration
- Backup strategies
- Snapshot management
- Cloud storage security

---

# 🚀 Project 4 — Production Security Group Architecture

## 🎯 Objective

Design layered cloud network security using Security Groups.

---

## ✅ Tasks Completed

Created Security Groups:
- web-sg
- app-sg
- db-sg

Configured rules:

### web-sg
- HTTP/HTTPS from internet

### app-sg
- Application traffic only from web-sg

### db-sg
- Database traffic only from app-sg

Created SGs using AWS CLI:

```bash
aws ec2 create-security-group \
--group-name web-sg \
--description "Web servers"
```

---

## 🧠 Skills Gained

- Stateful firewall understanding
- Layered cloud security
- SG referencing
- Least privilege networking
- Production VPC security design

---

# 🚀 Project 5 — EC2 Key Pair Management Lab

## 🎯 Objective

Understand secure SSH authentication management in AWS.

---

## ✅ Tasks Completed

- Created:
  - RSA key pair
  - ED25519 key pair

- Compared:
  - Security
  - Performance
  - Key sizes

- Practiced:
  - Secure `.pem` storage
  - Environment-specific key management

- Learned:
  - Private key recovery limitations

---

## 🧠 Skills Gained

- SSH authentication
- Infrastructure access control
- Secure credential management
- Key rotation best practices

---

# 🚀 Project 6 — EC2 Pricing Optimization Study

## 🎯 Objective

Understand AWS compute pricing models and infrastructure cost optimization.

---

## ✅ Tasks Completed

Studied:
- On-Demand pricing
- Reserved Instances
- Savings Plans
- Spot Instances

Used:
- AWS Pricing Calculator

Modeled:
- 5-instance production environment

Compared:
- Cost savings
- Flexibility
- Reliability tradeoffs

---

## 🧠 Skills Gained

- Cloud cost optimization
- Infrastructure budgeting
- Pricing strategy planning
- Production workload planning

---

# 🚀 Project 7 — EC2 User Data Automation Lab

## 🎯 Objective

Automate EC2 initialization using User Data scripts.

---

## ✅ Tasks Completed

Created User Data script that:
- Updated packages
- Installed nginx
- Started services automatically

Example:

```bash
#!/bin/bash

yum update -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
```

Launched EC2 with automated bootstrap configuration.

Verified:
- nginx running automatically after launch

---

## 🧠 Skills Gained

- Infrastructure bootstrapping
- cloud-init understanding
- Infrastructure automation
- Automated server provisioning

---

# 🚀 Project 8 — EC2 Metadata & IMDSv2 Security Lab

## 🎯 Objective

Understand EC2 metadata architecture and secure metadata access.

---

## ✅ Tasks Completed

Retrieved metadata using:

```bash
curl http://169.254.169.254/latest/meta-data/
```

Fetched:
- Instance ID
- Instance type
- Availability Zone

Practiced IMDSv2:

### Generate Token

```bash
TOKEN=$(curl -X PUT \
"http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
```

### Access Metadata

```bash
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id
```

---

## 🧠 Skills Gained

- Metadata architecture
- IMDS security
- Token-based authentication
- IAM role credential awareness
- SSRF security understanding

---

# 🚀 Project 9 — Automated Python App Deployment

## 🎯 Objective

Automate Python application deployment using EC2 User Data and systemd.

---

## ✅ Tasks Completed

Automated:
- Python installation
- Virtual environment creation
- Dependency installation
- Application startup

Configured:
- systemd service

Commands practiced:

```bash
python3 -m venv venv
source venv/bin/activate
```

Managed service:

```bash
systemctl start myapp
systemctl enable myapp
```

---

## 🧠 Skills Gained

- Python deployment automation
- Linux service management
- Production application setup
- systemd fundamentals

---

# 🚀 Project 10 — Production 3-Tier AWS Architecture

## 🎯 Objective

Build a complete production-style 3-tier architecture using AWS EC2.

---

## ✅ Architecture Built

```text
Internet
    ↓
Web Tier (nginx)
    ↓
App Tier (Flask)
    ↓
Database Tier (SQLite)
```

---

## ✅ Infrastructure Components

### Web Tier
- 2 × t2.micro
- nginx reverse proxy

### App Tier
- 1 × t2.micro
- Python Flask

### DB Tier
- SQLite database

---

## ✅ Security Architecture

Configured:
- web-sg
- app-sg
- db-sg

Implemented:
- SG-to-SG communication
- Least privilege networking

---

## ✅ Connectivity Testing

Verified:
- Web → App works
- Internet → App blocked
- App isolated privately

---

## ✅ boto3 Automation

Created:

```text
deploy_3tier.py
```

Automated:
- EC2 provisioning
- Security Group creation
- Infrastructure deployment

---

## ✅ Architecture Documentation

Created:
- Infrastructure diagram using draw.io / Excalidraw
- Exported PNG
- Added to GitHub repository

---

## 🧠 Skills Gained

- Production cloud architecture
- Reverse proxy design
- Internal networking
- Infrastructure automation
- Multi-tier security
- Cloud infrastructure engineering mindset

---

# 🏆 Week 11 Major Achievements

By the end of Week 11, successfully practiced:

✅ EC2 infrastructure deployment  
✅ Instance family selection  
✅ AMI creation & replication  
✅ Persistent EBS storage management  
✅ Snapshot backups  
✅ Security Group architecture  
✅ SSH key management  
✅ Infrastructure cost optimization  
✅ EC2 bootstrapping automation  
✅ Metadata security using IMDSv2  
✅ Python deployment automation  
✅ systemd service management  
✅ Reverse proxy architecture  
✅ 3-tier cloud system design  
✅ boto3 infrastructure automation  

---

# 🧠 Core Engineering Concepts Reinforced

- Infrastructure as Code  
- Cloud networking  
- Linux systems administration  
- AWS compute architecture  
- Secure infrastructure design  
- Layered security  
- Immutable infrastructure  
- Automation-first mindset  
- Cloud scalability principles  
- Production infrastructure architecture  

---

# 🚀 Final Outcome

Week 11 projects transformed EC2 knowledge from:

```text
Launching simple virtual machines
```

Into:

```text
Designing secure, automated, scalable, production-grade AWS infrastructure systems
```

These projects established the foundational compute and infrastructure engineering skills required for:
- Advanced AWS networking
- Kubernetes
- Terraform
- CI/CD pipelines
- Auto Scaling
- Load balancing
- AI/ML cloud infrastructure
- Production DevOps engineering

---