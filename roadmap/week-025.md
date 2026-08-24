# Week 25 Roadmap: Advanced Docker, Security, & The Bridge to Kubernetes

## 📅 Timeline: Days 169 - 175

### 🎯 Weekly Objective
Elevate container skills from local development to production-grade deployment. Master container registries (ECR), resource limits, advanced networking, and security defense-in-depth. Conclude the week by hitting the limits of raw Docker and crossing the bridge into Kubernetes orchestration.

### 🛣️ Daily Breakdown

- [x] **Day 169: Amazon ECR & Cloud Deployments**
  - Authenticate securely using `aws ecr get-login-password`.
  - Tag and push images to a private AWS repository.
  - Implement IAM Instance Roles for secure EC2 image pulling.
  - Automate cleanup using ECR Lifecycle Policies.

- [x] **Day 170: Container Resource Management**
  - Implement hard limits (`--cpus`, `--memory`).
  - Understand relative priority (`--cpu-shares`).
  - Analyze the Linux OOM (Out Of Memory) Killer.
  - Master container observability using `docker stats`.

- [x] **Day 171: Docker in Production Patterns**
  - Implement native Dockerfile `HEALTHCHECK` instructions.
  - Configure self-healing via `--restart=unless-stopped`.
  - Centralize logging directly to CloudWatch using `awslogs`.
  - Enforce filesystem security using `--read-only` and `--tmpfs`.

- [x] **Day 172: Advanced Docker Networking**
  - Master Docker's embedded DNS server (`127.0.0.11`).
  - Implement Round-Robin load balancing via `--network-alias`.
  - Build a microservices API Gateway using Nginx.
  - Understand the dangers of `--network=host`.

- [x] **Day 173: Docker Security Deep Dive**
  - Enforce the principle of least privilege using `--cap-drop=ALL`.
  - Manage secrets securely in-memory using Docker Swarm Secrets.
  - Implement Trivy as a hard security gate in CI/CD pipelines.
  - Prevent supply chain attacks with Docker Content Trust (DCT).

- [x] **Day 174: Bridge to Kubernetes (Container Orchestration)**
  - Acknowledge the multi-host scaling and self-healing limits of raw Docker.
  - Learn why Google created Kubernetes.
  - Understand the Paradigm Shift: Containers vs. Pods.
  - Use `kompose` to translate Docker Compose files into K8s manifests.

- [x] **Day 175: Week 25 Capstone & Review**
  - Build a production-ready 3-tier microservices architecture.
  - Automate the end-to-end CI/CD pipeline (Lint ➡️ Build ➡️ Scan ➡️ ECR ➡️ K8s).
  - Study core Kubernetes concepts (Deployments, Services, ConfigMaps).
