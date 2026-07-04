# Week 01 — Cloud Foundations & Environment Setup 🌐

**Journey:** 1000 Days to AI Cloud Infrastructure Engineer  
**Week:** 1  
**Focus:** AWS Fundamentals, Git/GitHub, Networking Basics, CLI Workflows

---

# 🎯 Week 1 Objective

The goal of Week 1 was to build **strong foundational knowledge** required for cloud infrastructure engineering.

Instead of jumping directly into complex architectures, the focus was on:

- Cloud fundamentals
- Development environment setup
- Networking basics
- Command-line workflows
- Git version control

These concepts form the **base layer of modern cloud engineering**.

---

# ☁ AWS Core Services Review

AWS provides hundreds of services, but several core services form the backbone of most architectures.

### EC2 (Elastic Compute Cloud)

EC2 provides **virtual servers in the cloud**.

Key concepts:

- Instance types (t2.micro, t3.medium, etc.)
- Security groups
- Elastic IPs
- SSH access

Example workflow:

Launch → Connect → Deploy application → Terminate.

---

### S3 (Simple Storage Service)

Amazon S3 is **object storage** designed for scalability and durability.

Common uses:

- File storage
- Backups
- Static website hosting
- Machine learning datasets
- Logs

Important features:

- Buckets
- Objects
- Versioning
- Lifecycle policies

---

### IAM (Identity and Access Management)

IAM controls **authentication and authorization** within AWS.

Key components:

- Users
- Groups
- Roles
- Policies

Security best practices:

- Enable **MFA**
- Avoid using the **root account**
- Apply **least privilege access**

---
  
### VPC (Virtual Private Cloud)

A VPC is a **private network inside AWS**.

Key components:

- Subnets
- Route tables
- Internet gateways
- NAT gateways
- Security groups

VPC allows engineers to **design secure network architectures** in the cloud.

---

# 🧠 Git & GitHub Fundamentals

Git is a **version control system** used to track changes in code and collaborate with teams.

GitHub is a **remote hosting platform** for Git repositories.

---

## Basic Git Workflow

Initialize repository:

```bash
git init
```

Stage changes:

```bash
git add .
```

Create commit:

```bash
git commit -m "commit message"
```

Push to GitHub:

```bash
git push origin main
```

This workflow allows engineers to **track history, collaborate, and manage code safely**.

---

# 🌐 Networking Fundamentals

Networking knowledge is critical for understanding **how cloud systems communicate**.

---

# OSI Model

The **OSI (Open Systems Interconnection) Model** defines 7 layers of network communication.

| Layer | Name | Function |
|------|------|------|
| 7 | Application | User-facing protocols (HTTP, FTP) |
| 6 | Presentation | Encryption and formatting |
| 5 | Session | Maintains communication sessions |
| 4 | Transport | TCP / UDP data transport |
| 3 | Network | Routing packets via IP |
| 2 | Data Link | MAC addressing |
| 1 | Physical | Transmission of bits |

The OSI model helps engineers **troubleshoot networking problems**.

---

# TCP vs UDP

Transport layer protocols define how data moves between devices.

### TCP

Reliable protocol.

Features:

- Connection-oriented
- Ordered delivery
- Error checking

Uses **3-way handshake**:

1. SYN
2. SYN-ACK
3. ACK

Common uses:

- Web browsing
- Email
- File transfers

---

### UDP

Faster but less reliable.

Features:

- No connection setup
- Low latency
- No delivery guarantee

Common uses:

- Video streaming
- Online gaming
- DNS requests

---

# 🌍 IP Addressing Basics

Devices on the internet communicate using **IP addresses**.

Example IPv4 format:

```
192.168.1.1
```

---

## Private IP Address Ranges

| Range | Example |
|------|------|
| 10.0.0.0 – 10.255.255.255 | 10.0.0.5 |
| 172.16.0.0 – 172.31.255.255 | 172.16.10.1 |
| 192.168.0.0 – 192.168.255.255 | 192.168.1.25 |

Routers use **NAT (Network Address Translation)** to convert private IPs to public IPs.

---

# 💻 AWS CLI Basics

The **AWS Command Line Interface** allows engineers to manage cloud resources directly from the terminal.

---

## List S3 Buckets

```bash
aws s3 ls
```

---

## View EC2 Instances

```bash
aws ec2 describe-instances
```

---

## Create S3 Bucket

```bash
aws s3 mb s3://my-test-bucket
```

---

## Upload File

```bash
aws s3 cp file.txt s3://my-test-bucket
```

---

## Delete File

```bash
aws s3 rm s3://my-test-bucket/file.txt
```

---

# ⚙ AWS CLI Profiles

Profiles allow multiple AWS credentials on one machine.

Create profile:

```bash
aws configure --profile dev
```

Use profile:

```bash
aws s3 ls --profile dev
```

---

# 🐧 Linux Preparation

Since most cloud servers run Linux, the next step is learning Linux fundamentals.

Using **LinuxJourney**, the first topics explored include:

- Linux introduction
- The shell
- Command history
- File system navigation

Linux will be a major focus in **Week 2**.

---

# 📚 Key Takeaways

Week 1 established the **core pillars of cloud engineering**:

- AWS fundamentals
- Git version control
- Networking concepts
- CLI-based infrastructure management
- Introduction to Linux systems

These fundamentals are necessary before progressing to:

- Linux system administration
- Cloud architecture
- Infrastructure automation
- AI infrastructure deployments

---

# 🚀 Next Week Focus

Week 2 will focus on **Linux fundamentals and system operations**.

Topics include:

- Linux filesystem
- Permissions
- Process management
- Package installation
- Networking commands

Linux mastery is critical because **most cloud infrastructure runs on Linux-based systems.**

---

### 🔑 Strong infrastructure engineers are built on strong fundamentals.