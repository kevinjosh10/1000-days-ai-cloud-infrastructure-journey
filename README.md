# 🚀 AI Cloud Infrastructure Journey

> **Engineering the highly scalable, distributed systems and cloud-native platforms that power modern AI.**

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-Package_Manager-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Administration-black?style=for-the-badge&logo=linux&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Streak](https://img.shields.io/badge/Streak-195_Days-fire?style=for-the-badge)

---

## 📑 Table of Contents
- [📌 The Mission](#-the-mission)
- [📈 The Journey in Numbers](#-the-journey-in-numbers)
- [🧠 Core Engineering Stack](#-core-engineering-stack)
- [🏗️ Real-World Infrastructure Projects](#-real-world-infrastructure-projects)
- [📂 Repository Architecture](#-repository-architecture)
- [🧪 Professional Engineering Practices](#-professional-engineering-practices)
- [🛣️ The Roadmap Ahead](#️-the-roadmap-ahead)
- [💭 Philosophy / Mindset](#-philosophy--mindset)
- [🤝 Connect With Me](#-connect-with-me)

---

## 📌 The Mission

> [!NOTE]
> **Welcome to my central engineering hub.**
>
> I started this repository because I noticed a massive gap in the tech industry: many engineers know how to *build* AI models, but far fewer know how to **deploy, scale, secure, and manage** the robust infrastructure required to run them in production. 
> 
> My long-term mission is to become an **AI Cloud Infrastructure Engineer**. This repository is not just a collection of simple tutorials; it is a meticulously documented, 1000-day journey of mastering Cloud Computing, Distributed Systems, Container Orchestration, Networking, and Infrastructure Automation from the absolute ground up.

---

## 📈 The Journey in Numbers

| Metric | Current Status | Details |
| :--- | :--- | :--- |
| **Current Day** | **Day 195 / 1000** | 🔥 Phase 7: Kubernetes & Cloud-Native Orchestration |
| **Milestone** | **Week 28 / Kubernetes III** | Advanced Networking, Ingress, StorageClasses, & Helm Package Management |
| **Projects & Labs** | **22+ Systems Built** | From Terraform IaC & AWS 3-Tier setups to multi-replica Kubernetes microservices |
| **Automation Modules**| **25+ Automation Scripts** | AWS `boto3` audits, containerized CronJobs, Linux monitoring watchdogs |
| **Current Focus** | **Helm & Production K8s** | Custom Chart Authoring, Go Templating, Ingress L7 Routing, Zero-Trust NetworkPolicies |

---

## 🧠 Core Engineering Stack

I am building a foundational stack designed for large-scale operations, avoiding manual GUI clicks in favor of pure code, declarative state, and automation.

### ☸️ Kubernetes & Cloud-Native Containerization
- **Core Architecture:** Control Plane (`kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`), Worker Nodes (`kubelet`, `containerd` CRI, `kube-proxy`).
- **Workloads & Controllers:** Pods, Deployments (Zero-Downtime RollingUpdates, anti-affinity), StatefulSets (`volumeClaimTemplates`), DaemonSets, Jobs & CronJobs.
- **Configuration & Security:** Decoupled ConfigMaps (hot-reloading volume mounts), Kubernetes Secrets, External Secrets Operator (AWS Secrets Manager integration), Least-Privilege NetworkPolicies (Calico/Cilium CNI).
- **Storage Engineering:** PersistentVolumes (PV), PersistentVolumeClaims (PVC), EBS CSI `gp3` StorageClasses (`WaitForFirstConsumer`), CSI VolumeSnapshots & point-in-time recovery.
- **Networking & Ingress:** ClusterIP, NodePort, Cloud LoadBalancers (AWS ELB/ALB), NGINX Ingress Controller (L7 host/path routing, SSL termination, cert-manager).
- **Package Management & Scaling:** Helm 3 chart authoring, Go templating (`_helpers.tpl`, `nindent`), Horizontal Pod Autoscaler (HPA), KEDA (Event-Driven ML autoscaling).

### 🏗️ Infrastructure as Code (IaC)
- **Terraform & Terragrunt:** Modular multi-environment architectures (VPC, RDS Multi-AZ, ALB, ASG), remote state locking (S3/DynamoDB), DRY Terragrunt configurations.
- **Testing & Governance:** Automated end-to-end infrastructure testing with Terratest (Golang), policy enforcement via Open Policy Agent (OPA) and HashiCorp Sentinel.

### ☁️ AWS & Cloud Architecture
- **Compute & Networking:** EC2 (AMIs, instance sizing), VPC (Public/Private subnets, NAT Gateways, Route Tables), Elastic Load Balancing (ALB/NLB).
- **Storage & Security:** S3 (lifecycle policies, cross-region replication), EBS (`gp3`), KMS encryption at rest, IMDSv2 metadata protection, Security Groups.
- **Orchestration & Serverless:** AWS EKS, Lambda, API Gateway, CloudWatch logs, Amazon ECR container registries, `boto3` Python automation.

### 🔄 CI/CD & DevOps
- **Pipeline Automation:** GitHub Actions workflows (`.yml`), automated linting (`hadolint`, `flake8`, `tflint`), automated unit testing (`pytest`).
- **Security Scanning:** Container vulnerability scanning with Trivy (failing on CRITICAL/HIGH CVEs), Docker Content Trust (DCT).

### 🐧 Linux & Systems Engineering
- **Systems Administration:** `systemd`, `cron`, process management, memory allocation, cgroups, namespace isolation, resource monitoring (`top`, `htop`, `kubectl top`).
- **Networking Foundations:** TCP/IP model, DNS resolution (`dig`, CoreDNS), iptables/IPVS routing, virtual ethernet (`veth`) pairs, overlay networks (VXLAN, BGP).

---

## 🏗️ Real-World Infrastructure Projects

I believe in learning by doing. Here are highlights from major platforms and projects engineered during this journey:

### 🚀 Featured Platforms & MLOps
1. **[CloudTrain](https://github.com/kevinjosh10/CloudTrain):** A production-grade serverless MLOps platform that automates machine learning training, model governance, and real-time inference using AWS Lambda, S3, API Gateway, Firebase, and Python.
2. **[GitWrapped](https://github.com/kevinjosh10/GitWrapped):** Turn any GitHub profile into a developer story with analytics, achievements, GitHub Wrapped reports, battles, and visual insights.
3. **[S3 Backup Tool](https://github.com/kevinjosh10/s3-backup-tool):** Automated S3 backup tool with incremental sync (MD5 vs ETag), lifecycle management, and secure encrypted storage using Python and AWS.
4. **[Cloud-Morph](https://github.com/kevinjosh10/Cloud-Morph):** A serverless, event-driven file processing platform built on AWS that transforms PDFs, CSVs, and text files into meaningful insights using automated cloud workflows.
5. **[AWS Static Website Platform](https://github.com/kevinjosh10/aws-static-website-platform):** Production-grade static website hosting on AWS using S3, CloudFront, ACM, boto3 automation, lifecycle policies, and GitHub Actions CI/CD.

### 🏗️ Infrastructure as Code & Orchestration
1. **[Enterprise Modular AWS Architecture](projects/terraform/aws-3tier-architecture/):** A production-grade, fully modular 3-tier AWS architecture orchestrated in Terraform. Features independent state-driven modules for VPC, RDS (Multi-AZ), ALB, and ASG, enforcing zero-trust Security Groups and automated CI checks.
2. **Advanced IaC Orchestration & Governance:** Scaled architecture using **Terragrunt** for DRY backends, integrated **Terratest** (Golang) for automated end-to-end testing, and enforced compliance with OPA/Sentinel.
3. **Kubernetes 3-Tier Production Stack:** Deployed complete microservice stacks on Kubernetes with NGINX Ingress Layer 7 routing, Flask APIs, PostgreSQL StatefulSets with persistent EBS CSI `gp3` volumes, automated HPA autoscaling, and custom Helm charts.

---

## 📂 Repository Architecture

This repository acts as my second brain, carefully organized to track progress and scale as an engineering knowledge base:

```text
📦 1000-days-ai-cloud-infrastructure-journey
 ┣ 📂 daily-logs/      # 195 days of unbroken execution logs (concepts, code, debugging)
 ┃ ┗ 📂 2026/
 ┃   ┣ 📂 1] march-2026/    # Days 1-31: Linux & Networking Foundations
 ┃   ┣ 📂 2] april-2026/    # Days 32-60: Python Automation & boto3
 ┃   ┣ 📂 3] may-2026/      # Days 61-91: AWS Architecture & Security Labs
 ┃   ┣ 📂 4] june-2026/     # Days 92-121: CI/CD & Advanced Cloud Projects
 ┃   ┣ 📂 5] july-2026/     # Days 122-152: Infrastructure as Code (Terraform)
 ┃   ┣ 📂 6] august-2026/   # Days 153-183: Docker Mastery & Kubernetes Architecture
 ┃   ┗ 📂 7] september-2026/# Days 184-213+: K8s Workloads, Storage, Ingress & Helm
 ┣ 📂 notes/           # High-density technical summaries organized by week (Weeks 1-27+)
 ┣ 📂 roadmap/         # Weekly roadmaps and 125-Day FAANG & Cloud Engineering Roadmap
 ┣ 📂 recap/           # Weekly milestones and architectural paradigm shifts
 ┣ 📂 resources/       # Official documentation links, books, and essential tooling
 ┣ 📂 projects/        # Real-world implementations, IaC modules, CI/CD pipelines & AWS labs
 ┣ 📂 python-codes/    # Python automation scripts (APIs, OOP, boto3, Cloud Watchdogs)
 ┗ 📜 README.md        # Central engineering hub & repository overview
```

---

## 🧪 Professional Engineering Practices

A core focus of this journey is building systems that thrive in production environments:

- **Declarative Infrastructure & GitOps:** Managing state via version-controlled manifests (Terraform, Kubernetes YAML, Helm Charts) rather than manual imperative tweaks.
- **Zero-Trust Security:** Enforcing default-deny NetworkPolicies in Kubernetes, least-privilege IAM roles, KMS volume encryption, and secret synchronization via External Secrets Operator.
- **Resilience & Zero-Downtime:** Designing rolling update strategies with strict probe health checks (`liveness`, `readiness`, `startup`) and pod anti-affinity across availability zones.
- **Automated Validation:** Continuous integration pipelines with automated linting (`tflint`, `helm lint`, `flake8`), image vulnerability scanning (Trivy), and automated unit tests (`pytest`, `Terratest`).

---

## 🛣️ The Roadmap Ahead

- [x] **Phase 1-5:** Cloud Foundations (Linux, Networking, Python, CI/CD, AWS Architecture)
- [x] **Phase 6:** Infrastructure as Code (Terraform, Terragrunt, Terratest, OPA/Sentinel)
- [x] **Phase 7:** Containerization (Docker Multi-Stage, ECR, Trivy, Production Patterns)
- [ ] **Phase 8:** Kubernetes & Cloud-Native Architecture (In Progress — Weeks 26-29)
  - [x] Control Plane & Worker Node Internals (Week 26)
  - [x] Workloads, ConfigMaps, Secrets, Storage & Autoscaling (Week 27)
  - [x] Advanced Networking, Ingress, StorageClasses & Helm (Week 28 - Current)
  - [ ] Production AWS EKS, AWS Load Balancer Controller & GitOps (Week 29)
- [ ] **Phase 9:** Observability & Production Operations (Prometheus, Grafana, OpenTelemetry, Istio)
- [ ] **Phase 10:** AI Model Deployment Infrastructure, GPU Slicing, Triton & Distributed Training Clusters

---

## 💭 Philosophy / Mindset

> [!IMPORTANT]
> **Consistency over Motivation**  
> Motivation is fleeting, but discipline builds systems. I show up and log my progress every single day, whether I feel like it or not.

> [!WARNING]
> **Building over Consuming**  
> Tutorial hell is a trap. The only way to truly master cloud infrastructure is to break configurations, analyze kernel/system logs, and build resilient architectures from scratch.

> [!TIP]
> **Systems Thinking**  
> I don't just memorize isolated CLI commands; I strive to understand how the entire ecosystem—from Linux kernel cgroups and network namespaces to the cloud load balancer and distributed control plane—interacts seamlessly.

---

## 🤝 Connect With Me

If you're building resilient infrastructure, recruiting for cloud / DevOps / MLOps engineering roles, or just want to talk distributed systems, let's connect:

- **GitHub:** [@kevinjosh10](https://github.com/kevinjosh10)
- **LinkedIn:** [Kevin Joshua](https://www.linkedin.com/in/kevin-josh10)

---
*Built with ☕, discipline, and a relentless passion for engineering.*
