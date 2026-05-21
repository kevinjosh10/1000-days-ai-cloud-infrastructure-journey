# WEEK 11 ROADMAP — AWS CORE SERVICES I: EC2 DEEP DIVE

## 📌 Week Goal

Master Amazon EC2 deeply and build the foundational compute, storage, security, automation, and infrastructure engineering skills required for becoming an AI Cloud Infrastructure Engineer.

Week 11 focuses on understanding how production cloud infrastructure is deployed, secured, automated, and managed using AWS EC2 and related services.

---

# 🎯 Primary Learning Objectives

By the end of Week 11, aim to confidently understand:

✅ EC2 instance architecture  
✅ Compute sizing & workload optimization  
✅ AMIs & immutable infrastructure  
✅ Persistent block storage using EBS  
✅ Security Groups & layered security  
✅ SSH key pair management  
✅ AWS pricing models & cost optimization  
✅ EC2 bootstrapping using User Data  
✅ Metadata services & IMDSv2 security  
✅ Python app deployment automation  
✅ Reverse proxy architecture  
✅ Multi-tier infrastructure design  
✅ Infrastructure automation using boto3  

---

# 🗓️ Weekly Learning Path

---

# 📅 Day 71 — EC2 Instance Types & Families

## 🎯 Focus

Understand AWS EC2 compute architecture and workload-based instance selection.

---

## ✅ Learning Targets

### EC2 Naming Convention

Learn:

```text
m5.xlarge
```

Understand:
- Family
- Generation
- Size

---

### Important Instance Families

Study:
- t-series
- m-series
- c-series
- r-series
- p/g-series
- i-series

---

### AI & Cloud Infrastructure Instance Types

Explore:
- t3.micro
- m5.large
- c5.2xlarge
- p3.2xlarge
- g4dn.xlarge
- inf1.xlarge

---

### Key Compute Metrics

Understand:
- vCPU
- Memory
- Network bandwidth
- EBS optimization

---

### Instance Store vs EBS

Compare:
- Temporary storage
- Persistent storage

---

## 🧠 Outcome

Understand how infrastructure workloads influence EC2 sizing decisions.

---

# 📅 Day 72 — AMIs (Amazon Machine Images)

## 🎯 Focus

Understand reusable infrastructure images and immutable infrastructure concepts.

---

## ✅ Learning Targets

### AMI Structure

Study:
- Root volume snapshot
- Launch permissions
- Block device mappings

---

### AMI Types

Learn:
- AWS-managed
- Marketplace
- Community
- Custom AMIs

---

### Hands-On Practice

- Launch Marketplace Ubuntu AMI
- Create custom AMI
- Install nginx + python3
- Copy AMI across regions

---

## 🧠 Outcome

Understand reusable infrastructure deployment workflows.

---

# 📅 Day 73 — EBS Volumes Deep Dive

## 🎯 Focus

Master AWS persistent block storage architecture.

---

## ✅ Learning Targets

### EBS Volume Types

Study:
- gp3
- io1/io2
- st1
- sc1

---

### Storage Management

Practice:
- Attach EBS volume
- Format storage
- Mount storage
- Persistent mounts

---

### Backup & Security

Learn:
- EBS snapshots
- Encryption using KMS

---

## 🧠 Outcome

Understand production storage management and persistence.

---

# 📅 Day 74 — Security Groups & Key Pairs

## 🎯 Focus

Learn production-grade infrastructure security architecture.

---

## ✅ Learning Targets

### Security Groups

Understand:
- Stateful behavior
- Additive rules
- SG referencing

---

### Layered Security Design

Build:
- web-sg
- app-sg
- db-sg

---

### Key Pair Management

Learn:
- RSA vs ED25519
- SSH security
- Key rotation
- Environment separation

---

## 🧠 Outcome

Understand secure infrastructure access and layered networking.

---

# 📅 Day 75 — EC2 Pricing Models

## 🎯 Focus

Understand AWS cost optimization and compute pricing strategies.

---

## ✅ Learning Targets

### Pricing Models

Study:
- On-Demand
- Reserved Instances
- Savings Plans
- Spot Instances

---

### Cost Modeling

Use:
- AWS Pricing Calculator

Compare:
- Reliability
- Flexibility
- Cost savings

---

## 🧠 Outcome

Develop cloud cost optimization awareness.

---

# 📅 Day 76 — EC2 User Data & Metadata

## 🎯 Focus

Learn infrastructure automation and secure metadata retrieval.

---

## ✅ Learning Targets

### User Data

Practice:
- Bootstrapping EC2 automatically
- Installing packages automatically
- Starting services automatically

---

### Metadata Service

Learn:
- IMDS
- Metadata retrieval
- IAM role credentials

---

### IMDSv2 Security

Understand:
- Token authentication
- SSRF protection
- Secure metadata access

---

### Python Deployment Automation

Automate:
- Python installation
- Virtual environments
- systemd services

---

## 🧠 Outcome

Understand self-configuring cloud infrastructure systems.

---

# 📅 Day 77 — Week 11 Review: 3-Tier Architecture

## 🎯 Focus

Combine all Week 11 concepts into a production-style AWS architecture.

---

## ✅ Learning Targets

### Build Architecture

Deploy:
- Web tier
- App tier
- Database tier

---

### Reverse Proxy Architecture

Configure:
- nginx → Flask communication

---

### Secure Networking

Implement:
- SG-to-SG communication
- Internal-only backend access

---

### Infrastructure Automation

Create:
- `deploy_3tier.py` using boto3

---

### Documentation

Design:
- Infrastructure diagram
- Traffic flow visualization

---

## 🧠 Outcome

Understand real-world cloud infrastructure architecture patterns.

---

# 🔥 Most Important Concepts to Master

---

# 1️⃣ EC2 Compute Fundamentals

Must understand:
- Instance families
- Sizing
- Workload optimization
- GPU infrastructure

---

# 2️⃣ Persistent Storage

Must understand:
- EBS
- Snapshots
- Encryption
- Linux mounting

---

# 3️⃣ Infrastructure Security

Must understand:
- Security Groups
- SSH security
- Least privilege networking
- Layered infrastructure security

---

# 4️⃣ Infrastructure Automation

Must understand:
- User Data
- cloud-init
- boto3
- systemd

---

# 5️⃣ Metadata Security

Must understand:
- IMDSv1 risks
- IMDSv2 protection
- Temporary credentials

---

# 6️⃣ Production Architecture

Must understand:
- Reverse proxies
- Multi-tier systems
- Internal networking
- Infrastructure separation

---

# 🛠️ Hands-On Deliverables

By the end of Week 11, complete:

---

## ✅ Infrastructure Tasks

- Launch multiple EC2 instances
- Create custom AMIs
- Attach and mount EBS volumes
- Configure Security Groups
- Practice SSH access
- Create snapshots

---

## ✅ Automation Tasks

- Write User Data scripts
- Automate nginx installation
- Automate Python deployments
- Use systemd services
- Create boto3 deployment scripts

---

## ✅ Security Tasks

- Implement SG chaining
- Practice IMDSv2
- Use IAM roles securely
- Secure SSH key management

---

## ✅ Architecture Tasks

- Build 3-tier architecture
- Configure reverse proxy
- Document infrastructure visually

---

# 📚 Recommended Study Resources

---

## AWS Official Docs

Study:
- EC2 Docs
- EBS Docs
- IMDS Docs
- Security Groups Docs

---

## Recommended Courses

- A Cloud Guru AWS SAA
- Stephane Maarek AWS SAA

---

## Tools

- instances.vantage.sh
- AWS Pricing Calculator
- draw.io
- Excalidraw

---

# 🧠 Expected Skill Growth

Beginning of Week 11:

```text
Basic EC2 understanding
```

End of Week 11:

```text
Production infrastructure engineering mindset
```

---

# 🚀 Skills Developed This Week

---

## AWS Skills

- EC2 management
- Storage management
- Security architecture
- Pricing optimization
- Infrastructure automation

---

## Linux Skills

- SSH
- systemd
- Storage mounting
- Networking
- Bootstrapping

---

## DevOps Skills

- Automation
- Infrastructure as Code concepts
- Reproducibility
- Service management

---

## Cloud Architecture Skills

- Multi-tier design
- Reverse proxies
- Internal networking
- Infrastructure isolation

---

# 🔄 Mindset Transformation

From:

```text
"Launch a server manually"
```

To:

```text
"Design secure, scalable, automated infrastructure systems"
```

---

# 🏆 Week 11 Success Criteria

By the end of Week 11, should confidently be able to:

✅ Explain EC2 families and workloads  
✅ Create reusable AMIs  
✅ Manage EBS storage  
✅ Configure layered Security Groups  
✅ Understand AWS pricing models  
✅ Automate infrastructure bootstrapping  
✅ Secure metadata access using IMDSv2  
✅ Deploy Python applications automatically  
✅ Build a production-style 3-tier architecture  
✅ Automate infrastructure provisioning using boto3  

---

# 🚀 Final Week 11 Outcome

Week 11 establishes the compute and infrastructure foundation required for:

- Advanced AWS networking
- Load balancing
- Auto Scaling
- Kubernetes
- Terraform
- CI/CD pipelines
- AI infrastructure
- Production DevOps engineering

This week transforms cloud learning from:
- Basic EC2 usage

Into:
- Real infrastructure engineering understanding

---