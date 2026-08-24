# Week 25 Recap: Docker Mastery & The Kubernetes Bridge

## 🏆 Weekly Milestones Achieved
- **Conquered Cloud Registries:** Authenticated and pushed immutable images to Amazon ECR securely using IAM instance roles and short-lived tokens.
- **Mastered Resource Physics:** Learned to cage workloads using CPU limits and Memory ceilings, observing live OOM kills and throttling via `docker stats`.
- **Implemented Production Guardrails:** Transitioned from fragile local dev setups to self-healing (`--restart`), auto-logging (`awslogs`), and self-monitoring (`HEALTHCHECK`) deployments.
- **Engineered Defense-in-Depth:** Stripped containers of Linux capabilities, locked down filesystems as read-only, and blocked supply chain attacks using Docker Content Trust.
- **Built the Ultimate CI/CD Pipeline:** Automated the entire delivery flow using GitHub Actions—from `hadolint` linting to Trivy security gating, ending with a Git SHA-tagged push to ECR.
- **Crossed the Orchestration Bridge:** Hit the multi-host scaling limits of raw Docker, installed `minikube`, and deployed my first translated Kubernetes Pods using `kompose`.

## 🧠 Major Paradigm Shift
Week 25 marked the transition from *building* containers to *operating* them securely at scale.

I realized that a Docker image isn't automatically secure or reliable just because it runs. It must be constrained, monitored, centralized, and locked down. More importantly, I realized that Docker alone is not enough for the enterprise. Understanding embedded DNS and network aliases in Docker Compose was the perfect stepping stone to understanding why Kubernetes was invented.

## 🚀 Status
Docker is fully mastered. I am now standing on the shores of Kubernetes, ready to dive into the Control Plane and master true multi-node cloud orchestration in Week 26.
