# Week 27 Roadmap: Kubernetes Workloads, Config & Storage

## 📅 Timeline: Days 183 - 189

### 🎯 Weekly Objective
Master the production building blocks of Kubernetes. Decouple configuration and secrets from container images. Architect persistent storage for stateful applications. Implement advanced controllers for batch processing, global agents, and event-driven autoscaling.

### 🛣️ Daily Breakdown

- [x] **Day 183: ConfigMaps — Externalizing Configuration**
  - Make Docker images environment-agnostic.
  - Inject configurations via Environment Variables (`envFrom`).
  - Mount physical configuration files via Volumes and observe automatic hot-reloading.

- [x] **Day 184: Secrets — Handling Sensitive Data**
  - Break the Base64 "encryption" illusion.
  - Understand the security benefits of Volume mounts over ENV vars.
  - Architect the GitOps pattern using the External Secrets Operator (ESO) and AWS Secrets Manager.

- [x] **Day 185: Resource Requests & Limits**
  - Configure the Scheduler's blueprint (`requests`).
  - Configure execution guardrails to prevent CPU throttling and `OOMKilled` events (`limits`).
  - Master Kubernetes Quality of Service (QoS) classes: Guaranteed, Burstable, BestEffort.

- [x] **Day 186: PersistentVolumes & PersistentVolumeClaims**
  - Abstract storage using PVs, PVCs, and StorageClasses.
  - Implement dynamic EBS volume provisioning on AWS EKS.
  - Navigate the limitations of `ReadWriteOnce` (RWO) vs `ReadWriteMany` (RWX).

- [x] **Day 187: DaemonSets, StatefulSets & HPA**
  - Deploy global logging/monitoring agents using DaemonSets.
  - Ensure stable network identities and ordered execution for databases using StatefulSets.
  - Configure the Horizontal Pod Autoscaler (HPA) and KEDA for event-driven ML elasticity.

- [x] **Day 188: Jobs & CronJobs**
  - Orchestrate run-to-completion batch processing and ML training runs.
  - Implement production failure guardrails (`backoffLimit`, `activeDeadlineSeconds`).
  - Automate cloud auditing via scheduled CronJobs.

- [x] **Day 189: Week 27 Review & Production YAML Patterns**
  - Enforce zero-downtime `RollingUpdates`.
  - Configure Liveness, Readiness, and Startup probes.
  - Apply `LimitRanges` to protect namespaces.
  - Organize manifests using the industry-standard `Kustomize` directory architecture.
