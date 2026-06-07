# 🚀 AI Cloud Infrastructure Journey

> **Engineering the highly scalable, distributed systems that power modern AI.**

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Administration-black?style=for-the-badge&logo=linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Streak](https://img.shields.io/badge/Streak-98_Days-fire?style=for-the-badge)

---

## 📌 The Mission

Welcome to my central engineering hub. 

I started this repository because I noticed a massive gap in the tech industry: many engineers know how to *build* AI models, but far fewer know how to **deploy, scale, and manage** the robust infrastructure required to run them in production. 

My long-term mission is to become an **AI Cloud Infrastructure Engineer**. This repository is not just a collection of simple tutorials; it is a meticulously documented, 1000-day journey of mastering Cloud Computing, Distributed Systems, Networking, and Infrastructure Automation from the absolute ground up.

---

## 📈 The Journey in Numbers

| Metric | Current Status | Details |
| :--- | :--- | :--- |
| **Current Day** | **Day 98 / 1000** | Unbroken consistency in daily execution logs |
| **Milestone** | **Week 14 Completed** | Successfully cleared Linux, Python, and AWS Core & Security phases |
| **Projects Built** | **15 Infrastructure Systems** | From Linux bash automation to fully automated AWS CI/CD pipelines |
| **Python Scripts** | **20 Automation Modules** | Focused on system health, APIs, config, and `boto3` automation |
| **Current Phase** | **AWS Architecture & CI/CD** | Transitioning from automation to production-grade cloud deployments |

---

## 🧠 Core Engineering Stack

I am building a foundational stack designed for large-scale operations, avoiding GUI clicks in favor of pure code and automation.

### ☁️ AWS & Cloud Architecture
- **Compute & Storage:** EC2 (AMIs, families, sizing), EBS volumes, persistent block storage, Snapshots.
- **Security:** Layered Security Groups, SSH Key Pairs, IMDSv2 Metadata Security.
- **Orchestration:** `boto3` infrastructure provisioning, bootstrapping with EC2 User Data, Multi-tier architecture.

### 🔄 CI/CD & DevOps
- **Pipeline Automation:** GitHub Actions workflows (`.yml`), YAML syntax, continuous integration.
- **Code Quality:** Automated linting (`flake8`), automated testing (`pytest`).
- **Version Control:** Advanced Git operations, branching strategies, and repository management.

### 🐧 Linux & Networking
- **Systems Admin:** `systemd`, `cron`, resource monitoring (`top`, `htop`), log rotation.
- **Security:** UFW/Firewall rules, secure user permissions, reverse proxy design (Nginx).
- **Networking:** TCP/IP, DNS (`dig`), Subnetting, NAT routing, custom AWS VPC design.

### 🐍 Python Automation
- **Software Engineering:** Object-Oriented Programming (OOP), modular design, `argparse` CLI tools.
- **Resilience:** Comprehensive Error Handling (`try/except`), file logging, decoupling via YAML/JSON.

---

## 🏗️ Real-World Infrastructure Projects

I believe in learning by doing. Instead of watching lectures, I build systems. Here are highlights from the 15 major projects engineered during this journey:

### 🌩️ Cloud Architecture & CI/CD (Weeks 9-11)
1. **⚙️ Python CI/CD Automation Pipeline:** Engineered a professional GitHub Actions pipeline to automatically lint code (`flake8`) and run unit tests (`pytest`) on every push/PR, simulating production DevOps workflows.
2. **🏗️ Production 3-Tier AWS Architecture:** Designed and deployed a complete cloud system featuring a Web Tier (Nginx), App Tier (Flask), and Database Tier (SQLite) using `boto3` automation and strict Security Group isolation.
3. **🔐 EC2 Advanced Security & Metadata Lab:** Hardened cloud instances using custom AMIs, IMDSv2 token-based metadata authentication, and automated python application bootstrapping via User Data scripts.

### 🕸️ Networking & Automation (Weeks 1-8)
4. **☁️ Cloud Multi-Tool CLI:** A production-grade CLI built in Python utilizing `boto3` and `argparse` to fetch GitHub repositories via REST API, list S3 buckets, and dynamically generate multi-region EC2 reports.
5. **🛡️ Infrastructure Health Monitor:** A custom Python utility script designed to actively monitor CPU, memory, disk usage, and system logs, acting as an automated watchdog.
6. **🌐 Cloud VPC Design & Implementation:** Architected a secure cloud network from scratch, defining public/private subnets, Internet Gateways, Route Tables, and granular Security Groups.
7. **🔍 Local-to-Cloud Network Simulator:** Traced packet flows from local clients to cloud servers, debugged NAT routing, and extensively tested DNS resolution paths.
8. **🐧 Linux Server Automation:** Deployed NGINX on an AWS EC2 instance, configuring robust SSH access and automating background health-check tasks using `cron` and `systemd`.

---

## 📂 Repository Architecture

This repository acts as my second brain, carefully organized to track progress and scale as a knowledge base:

```text
📦 ai-cloud-infrastructure-journey
 ┣ 📂 daily-logs/      # 98 days of unbroken execution logs (concepts, commands, bugs)
 ┃ ┗ 📂 2026/
 ┃   ┣ 📂 march-2026/    # Days 1-31
 ┃   ┣ 📂 april-2026/    # Days 32-60
 ┃   ┣ 📂 may-2026/      # Days 61-91
 ┃   ┗ 📂 june-2026/     # Days 92-98
 ┣ 📂 projects/        # 15 real-world implementations, CI/CD pipelines & AWS labs
 ┣ 📂 python-codes/    # 20 days of Python automation code (APIs, OOP, boto3)
 ┣ 📂 notes/           # Deep-dive documentation and concept breakdowns
 ┣ 📂 roadmap/         # 11 weeks of strategic, granular learning plans
 ┗ 📜 README.md        # You are here
```

---

## 🧪 Professional Engineering Practices

A core focus of this journey is writing code and building infrastructure that survives in production environments. I strictly adhere to:

- **Config-Driven Development:** Decoupling hardcoded values from logic using YAML and environment variables.
- **Continuous Integration:** Validating all commits automatically through GitHub Action pipelines.
- **Immutable Infrastructure:** Pre-baking infrastructure requirements into custom AMIs rather than configuring servers manually.
- **Testing & Mocking:** Validating infrastructure logic using `pytest` and `unittest.mock` to simulate AWS services.
- **Clean Architecture:** Utilizing Object-Oriented Programming (OOP) to ensure system components remain modular and extensible.

---

## 📊 Sample Work (Automated CI Pipeline)

**Extract from `.github/workflows/ci.yml` (Day 69 Project):**

```yaml
name: CI Pipeline

on:
  push:
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: pip install flake8
      - run: flake8 .

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: pip install pytest
      - run: pytest
```

---

## 🛣️ The Roadmap Ahead

- [x] **Phase 1:** Linux Administration & System Deep Dives
- [x] **Phase 2:** Networking Fundamentals (TCP/IP, DNS, Subnetting, VPCs)
- [x] **Phase 3:** Python Programming & OOP Design
- [x] **Phase 4:** Advanced Git & CI/CD Pipelines (GitHub Actions)
- [x] **Phase 5:** AWS Core Services & API Automation (`boto3`, EC2, IAM)
- [ ] **Phase 6:** Containerization (Docker) & Orchestration (Kubernetes)
- [ ] **Phase 7:** Infrastructure as Code (Terraform)
- [ ] **Phase 8:** Serverless Architecture & Monitoring (CloudWatch, Prometheus)
- [ ] **Phase 9:** AI Model Deployment Infrastructure & GPU Compute Environments

---

## 💭 Philosophy / Mindset

**Consistency over Motivation.**  
Motivation is fleeting, but discipline builds empires. I show up and log my progress every single day, whether I feel like it or not. 

**Building over Consuming.**  
Tutorial hell is a trap. The only way to truly understand a system is to break it, debug the logs, and build it from scratch.

**Systems Thinking.**  
I don't just memorize isolated terminal commands; I strive to understand how the entire ecosystem—from the Linux kernel processes, through the CI/CD pipeline, to the cloud load balancer—interacts seamlessly.

---

## 🤝 Connect With Me

If you're building resilient infrastructure, recruiting for cloud engineering roles, or just want to talk distributed systems, let's connect:

- **GitHub:** [@kevinjosh10](https://github.com/kevinjosh10)
- **LinkedIn:** [Kevin Joshua](https://www.linkedin.com/in/kevin-josh10)

---
*Built with ☕, discipline, and a relentless passion for engineering.*
