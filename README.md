# 🚀 AI Cloud Infrastructure Journey

> **Engineering the highly scalable, distributed systems, high-performance networking, and cloud-native platforms that power modern AI.**

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-Package_Manager-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Mastery_Completed-black?style=for-the-badge&logo=linux&logoColor=white)
![Networking](https://img.shields.io/badge/Networking-30%2F30_Days_Completed-00599C?style=for-the-badge&logo=wireshark&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Shell_Scripting_Mastery-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Streak](https://img.shields.io/badge/Streak-260_Days-fire?style=for-the-badge)
![Progress](https://img.shields.io/badge/Journey-26.0%25_Completed-brightgreen?style=for-the-badge)

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
> I started this repository because I noticed a massive gap in the tech industry: many engineers know how to *build* AI models, but far fewer know how to **deploy, scale, network, secure, and manage** the robust distributed infrastructure required to run them in production.
> 
> My long-term mission is to become an **AI Cloud Infrastructure Engineer**. This repository is not just a collection of tutorials; it is a meticulously documented, 1000-day journey of mastering Systems Engineering, Computer Networking, Container Orchestration, Distributed Fabrics, and Cloud Infrastructure Automation from the absolute ground up.

---

## 📈 The Journey in Numbers

| Metric | Current Status | Details |
| :--- | :--- | :--- |
| **Current Day** | **Day 260 / 1000** | 🔥 **26.0% Milestone Reached** — Unbroken daily execution streak |
| **Current Milestone** | **Month 3: Shell Scripting** | Day 4 / 30: Advanced Bash Parameter Expansion, String Slicing & URI Parsing |
| **Completed Tracks** | **Month 1 (Linux) & Month 2 (Networking)** | Both 30/30-Day Intensive Capstone Tracks fully completed |
| **Daily Execution Logs**| **260 Unbroken Logs** | March through November 2026 across 9 organized monthly volumes |
| **Technical Summaries** | **37 Weekly Volumes** | High-density architectural notes and weekly recaps (Weeks 1–37) |
| **Production Projects** | **32+ Systems Engineered** | Linux suites, Terraform architectures, K8s microservices, and AI/MLOps platforms |
| **Automation Modules** | **42+ Shell & Python Scripts** | Bash parameter toolkits, system monitors, security scanners, `boto3` automation |

---

## 🧠 Core Engineering Stack

I build foundational infrastructure designed for hyper-scale operations, zero-trust security, and complete automation:

### 🌐 Computer Networking & AI Interconnects (30-Day Mastery Completed)
- **Foundations & Protocols:** Layer 2–4 deep dives, Ethernet framing, ARP, IPv4/IPv6 CIDR subnetting, NAT, DHCP, ICMP, and Path MTU Discovery.
- **Routing & Core Architecture:** Autonomous Systems, BGP peering, OSPF, route tables, Anycast routing, and hybrid interconnects (AWS Direct Connect & Transit Gateway).
- **Transport & Security:** TCP state machine (3-way handshake, sliding window, flow control, congestion avoidance: Cubic/BBR), UDP socket programming, TLS 1.3 handshake, PKI, mTLS mutual authentication, and HTTP/2 vs HTTP/3 (QUIC).
- **Container & AI Cluster Fabrics:** Kubernetes CNI architectures (Calico, Cilium eBPF, AWS VPC CNI), Gateway API, and high-performance AI cluster networking: RDMA, RoCE v2, InfiniBand, and NCCL all-reduce collectives across GPU nodes.
- **Observability & Diagnostics:** Six-layer systematic troubleshooting framework, VPC Flow Logs analysis, `tcpdump`, Wireshark packet dissection, `ss`, and `mtr`.

### 💻 Shell Scripting & Systems Automation (Current Track — Month 3)
- **Shell Architecture & Execution:** Kernel `fork()` / `execve()` execution models, subshell isolation, shebang portability (`#!/usr/bin/env bash`), and strict quoting precision (`"..."` vs `'...'` vs `$'...'`).
- **Defensive Parameter Expansion:** Default assignments (`:-`, `:=`), presence validations (`:+`, `:?`), string length inspection (`${#var}`), and case manipulation (`^^`, `,,`).
- **In-Memory String Manipulation:** Zero-based substring extraction (`${var:offset:length}`), prefix trimming (`#`, `##`), suffix removal (`%`, `%%`), and pattern substitution (`/`, `//`) avoiding subprocess overhead.
- **Production Scripting Standards:** Strict mode (`set -euo pipefail`), traps (`trap cleanup EXIT`), POSIX compatibility awareness, and modular CLI utility development.

### 🐧 Linux Systems Engineering (30-Day Mastery Completed)
- **Kernel Architecture & Filesystems:** `/proc` & `/sys` virtual filesystems, inode mechanics, namespace isolation, and cgroups resource limits.
- **Process Supervision:** Process trees, signals (`SIGTERM`, `SIGKILL`), custom `systemd` service units, timer configurations, and automated crash recovery.
- **Security & Hardening:** Granular `sudoers.d` access controls, Ed25519 SSH hardening, UFW firewall packet filtering, and kernel-level `auditd` file-integrity watch rules.
- **Performance Profiling:** USE and RED diagnostic methodologies, CPU profiling (`mpstat`, load avg), memory ratios (`free`, PSI, OOM killer), disk I/O throughput (`iostat`), and journalctl telemetry scraping.

### ☸️ Kubernetes & Cloud-Native Containerization
- **Core Architecture:** Control Plane (`kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`), Worker Nodes (`kubelet`, `containerd`, `kube-proxy`).
- **Workloads & Controllers:** Pods, Deployments (Zero-Downtime RollingUpdates, pod anti-affinity), StatefulSets (`volumeClaimTemplates`), DaemonSets, Jobs & CronJobs.
- **Configuration & Security:** Decoupled ConfigMaps (hot-reloading volume mounts), Kubernetes Secrets, External Secrets Operator, and least-privilege NetworkPolicies.
- **Storage & Networking:** PersistentVolumes (PV), PersistentVolumeClaims (PVC), EBS CSI `gp3` StorageClasses, NGINX Ingress Controller, and Helm 3 chart authoring.

### 🏗️ Infrastructure as Code (IaC) & Cloud Architecture
- **Terraform & Terragrunt:** Modular multi-environment architectures (VPC, RDS Multi-AZ, ALB, ASG), remote state locking (S3/DynamoDB), DRY Terragrunt configurations.
- **Testing & Governance:** Terratest (Golang), policy enforcement with Open Policy Agent (OPA) and Sentinel.
- **AWS Infrastructure:** EC2, S3 (Intelligent-Tiering, Lifecycle Policies), CloudFront CDN, Route 53 DNS, CloudWatch Agent, Container Insights, and `boto3` Python automation.

---

## 🏗️ Real-World Infrastructure Projects

I believe in learning by building real, resilient software. Here are highlights from major platforms and projects engineered during this journey:

### 💻 Shell Scripting & Cloud Automation Toolkit (Month 3)
1. **[Pure Bash Cloud Path & URI Parser (`04_path_url_parser.sh`)](linux-mastery/scripts/04_path_url_parser.sh):** High-performance, zero-fork URI parsing engine leveraging native parameter expansion to dissect complex HTTP, HTTPS, and Amazon S3 URIs without invoking external binaries.
2. **[Environment Validator & Config Hardener (`03_env_validator.sh`)](linux-mastery/scripts/03_env_validator.sh):** Defensive automation script enforcing strict environment variables, cloud deployment configurations, and fallback defaults using `${var:=default}` and `${var:?error}` operators.
3. **[Special Parameter Sandbox (`02_param_sandbox.sh`)](linux-mastery/scripts/02_param_sandbox.sh):** Process lifecycle and argument validation suite inspecting `$$`, `$BASHPID`, and array expansion mechanics across subshell boundaries.
4. **[Quoting Precision Inspector (`01_quote_inspector.sh`)](linux-mastery/scripts/01_quote_inspector.sh):** Portability and escaping validation utility demonstrating safe word-splitting and whitespace preservation in cloud automation scripts.

### 🐧 Linux Systems & Observability Projects (Month 1 Capstones)
1. **[Production System Monitor (`sysmon`)](projects/linux/sysmon/):** Month 1 Capstone monitoring suite built in Bash with `systemd` timer integration. Collects CPU per-core utilization, true available RAM ratios, disk I/O throughput via `iostat`, TCP socket tracking (`ss`), zombie process detection, systemd journal error scraping, and `--json` cloud telemetry export.
2. **[User Onboarding & Security Hardening](projects/linux/user-onboarding/):** Automated identity provisioning engine with Ed25519 SSH keys, granular least-privilege `sudoers.d` rules, password expiry compliance, and kernel-level `auditd` file-integrity watch rules.
3. **[Process Guardian](projects/linux/process-guardian/):** Resilient process supervisor with automated daemon recovery under `systemd`, sliding-window crash alerting, and unified journal logging.
4. **[Filesystem & Permission Auditor (`fs-auditor`)](projects/linux/fs-auditor/):** Automated security auditing utility scanning for SUID/SGID binaries, world-writable directories, POSIX ACLs, and orphaned symlinks.

### 🚀 Featured Platforms & MLOps
1. **[CloudTrain](https://github.com/kevinjosh10/CloudTrain):** A production-grade serverless MLOps platform that automates machine learning training, model governance, and real-time inference using AWS Lambda, S3, API Gateway, Firebase, and Python.
2. **[GitWrapped](https://github.com/kevinjosh10/GitWrapped):** Turn any GitHub profile into a developer story with analytics, achievements, GitHub Wrapped reports, battles, and visual insights.
3. **[S3 Backup Tool](https://github.com/kevinjosh10/s3-backup-tool):** Automated S3 backup tool with incremental sync (MD5 vs ETag), lifecycle management, and secure encrypted storage using Python and AWS.
4. **[Cloud-Morph](https://github.com/kevinjosh10/Cloud-Morph):** A serverless, event-driven file processing platform built on AWS that transforms PDFs, CSVs, and text files into meaningful insights using automated cloud workflows.
5. **[AWS Static Website Platform](https://github.com/kevinjosh10/aws-static-website-platform):** Production-grade static website hosting on AWS using S3, CloudFront, ACM, boto3 automation, lifecycle policies, and GitHub Actions CI/CD.

### 🏗️ Infrastructure as Code & Orchestration
1. **[Enterprise Modular AWS Architecture](projects/terraform/aws-3tier-architecture/):** A production-grade, fully modular 3-tier AWS architecture orchestrated in Terraform. Features independent state-driven modules for VPC, RDS (Multi-AZ), ALB, and ASG, enforcing zero-trust Security Groups and automated CI checks.
2. **Kubernetes 3-Tier Production Stack:** Deployed complete microservice stacks on Kubernetes with NGINX Ingress Layer 7 routing, Flask APIs, PostgreSQL StatefulSets with persistent EBS CSI `gp3` volumes, automated HPA autoscaling, and custom Helm charts.

---

## 📂 Repository Architecture

This repository acts as my central engineering brain, organized to track continuous progress and scale as an industry-grade knowledge base:

```text
📦 1000-days-ai-cloud-infrastructure-journey
 ┣ 📂 daily-logs/             # 260 days of unbroken execution logs (concepts, code, debugging)
 ┃ ┗ 📂 2026/
 ┃   ┣ 📂 1] march-2026/           # Days 1–31: Linux & Networking Foundations
 ┃   ┣ 📂 2] april-2026/           # Days 32–60: Python Automation & boto3
 ┃   ┣ 📂 3] may-2026/             # Days 61–91: AWS Architecture & Security Labs
 ┃   ┣ 📂 4] june-2026/            # Days 92–122: CI/CD, FinOps & SAA Architecture
 ┃   ┣ 📂 5] july-2026/            # Days 122–152: Infrastructure as Code (Terraform)
 ┃   ┣ 📂 6] august-2026/          # Days 153–183: Docker Mastery & Kubernetes Architecture
 ┃   ┣ 📂 7] september-2026/       # Days 184–213: K8s Workloads, Storage, Ingress & Helm
 ┃   ┣ 📂 8] october-2026/         # Days 214–244: Linux Mastery & Networking Foundations
 ┃   ┗ 📂 9] november-2026/        # Days 245–260+: Networking Capstone & Shell Scripting
 ┣ 📂 linux-mastery/          # Shell Scripting & Systems Automation Track
 ┃   ┗ 📂 scripts/                 # Modular Bash utilities (URI parsers, env validators, sandboxes)
 ┣ 📂 projects/               # Production implementations, IaC modules & systems engineering
 ┃   ┣ 📂 linux/                   # Systems Suites (sysmon, user-onboarding, process-guardian, fs-auditor)
 ┃   ┗ 📂 terraform/               # Modular IaC (aws-3tier-architecture)
 ┣ 📂 notes/                  # High-density technical notes organized by week (Weeks 1–37)
 ┣ 📂 recap/                  # Weekly architectural recaps and milestone reviews (Weeks 1–37)
 ┣ 📂 certs/                  # Industry certifications, workshop credentials, and hackathon wins
 ┣ 📂 mastery/                # 2-Week and Fast-Track intensive curriculum roadmaps
 ┣ 📂 roadmap/                # Strategic 125-Day FAANG & Cloud Engineering Roadmap
 ┣ 📂 python-codes/           # 20+ Python automation modules (APIs, OOP, boto3, Watchdogs)
 ┗ 📜 README.md               # You are here (Central repository overview)
```

---

## 🧪 Professional Engineering Practices

A core focus of this journey is writing software and building infrastructure that thrives in production:

- **Zero-Dependency Native Automation:** Utilizing native shell parameter expansion and kernel interfaces to eliminate unnecessary process spawning (`fork()`/`execve()`) in hot paths.
- **Declarative Infrastructure & GitOps:** Managing state via version-controlled manifests (Terraform, Kubernetes YAML, Helm Charts) rather than manual imperative clicks.
- **Zero-Trust Network Segmentation:** Enforcing default-deny NetworkPolicies in Kubernetes, least-privilege IAM roles, KMS volume encryption, and secret synchronization via External Secrets Operator.
- **Resilience & High Availability:** Designing zero-downtime rolling update strategies with strict probe health checks (`liveness`, `readiness`, `startup`) and pod anti-affinity across availability zones.
- **Telemetry & Observability First:** Building self-contained health probes, monitoring scripts with JSON telemetry export, and actionable error classifications.

---

## 🛣️ The Roadmap Ahead

- [x] **Phase 1-5:** Cloud Foundations (Linux, Networking, Python, CI/CD, AWS Architecture)
- [x] **Phase 6:** Infrastructure as Code (Terraform, Terragrunt, Terratest, OPA/Sentinel)
- [x] **Phase 7:** Containerization (Docker Multi-Stage, ECR, Trivy, Production Patterns)
- [x] **Phase 8:** Kubernetes & Cloud-Native Architecture (Control Plane, Workloads, Helm, CNI, Ingress)
- [x] **Phase 9:** Linux Mastery & Systems Engineering (**Month 1 Complete — 30/30 Days**, Days 197–226)
  - [x] Kernel, Virtual Filesystems (`/proc`, `/sys`), Storage, Boot Process
  - [x] Process Lifecycle, Systemd Daemons, Timers, Signal Handling
  - [x] Sudoers, SSH Hardening, Firewalls, Kernel Auditd Watch Rules
  - [x] USE/RED Performance Profiling: CPU, Memory, Disk I/O, Socket Telemetry, Sysmon Capstone
- [x] **Phase 10:** Computer Networking for Cloud Infrastructure (**Month 2 Complete — 30/30 Days**, Days 227–256)
  - [x] Network Layers, Encapsulation, Framing, Ethernet, ARP, IPv4/IPv6 Subnetting
  - [x] Routing Core: BGP, OSPF, NAT, DNS Resolution, Anycast, AWS Transit Gateway
  - [x] Transport & Application: TCP Flow/Congestion Control, UDP, TLS 1.3, mTLS, HTTP/3 (QUIC)
  - [x] Cloud & AI Fabrics: Kubernetes CNI (Calico/Cilium), Zero-Trust Policies, RDMA, RoCE v2, InfiniBand, NCCL collectives
  - [x] Network Observability & Troubleshooting: VPC Flow Logs, Packet Dissection (`tcpdump`), MTR
- [ ] **Phase 11:** Shell Scripting & Systems Automation (**Month 3 In Progress — Day 4/30**, Days 257–260+)
  - [x] Execution Models, Shebangs & Quoting Precision (`01_quote_inspector.sh`)
  - [x] Variable Scopes, Immutability & Special Parameters (`02_param_sandbox.sh`)
  - [x] Defensive Parameter Expansions & Env Validation (`03_env_validator.sh`)
  - [x] Advanced String Slicing, Pattern Removal & Cloud URI Dissection (`04_path_url_parser.sh`)
  - [ ] Flow Control, Robust Loops & Defensive Subprocesses
  - [ ] POSIX Portability, Process Substitution, Named Pipes & Signal Traps
  - [ ] Enterprise Shell Automation Capstone
- [ ] **Phase 12:** Production Observability & SRE (Prometheus, Grafana, OpenTelemetry, Istio Service Mesh)
- [ ] **Phase 13:** AI Model Deployment Infrastructure, Triton Inference Server, vLLM & Multi-GPU Slicing

---

## 💭 Philosophy / Mindset

> [!IMPORTANT]
> **Consistency over Motivation**  
> Motivation is fleeting, but discipline builds empires. I show up and log my progress every single day, whether I feel like it or not.

> [!WARNING]
> **Building over Consuming**  
> Tutorial hell is a trap. The only way to truly master cloud infrastructure is to break configurations, analyze kernel and packet traces, and build resilient architectures from scratch.

> [!TIP]
> **Systems Thinking**  
> I don't just memorize isolated CLI commands; I strive to understand how the entire ecosystem—from Linux kernel cgroups and network namespaces to the cloud load balancer and distributed GPU cluster fabric—interacts seamlessly.

---

## 🤝 Connect With Me

If you're building resilient infrastructure, recruiting for cloud / DevOps / MLOps engineering roles, or just want to talk distributed systems, let's connect:

- **GitHub:** [@kevinjosh10](https://github.com/kevinjosh10)
- **LinkedIn:** [Kevin Joshua](https://www.linkedin.com/in/kevin-josh10)

---
*Built with ☕, discipline, and a relentless passion for engineering.*
