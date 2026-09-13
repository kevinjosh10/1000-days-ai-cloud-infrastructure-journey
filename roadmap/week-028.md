# Week 28 Roadmap: Kubernetes Networking, Ingress, Storage & Helm

## 📅 Timeline: Days 190 - 196

### 🎯 Weekly Objective
Master the Kubernetes networking model, Layer 7 Ingress routing, Zero-Trust NetworkPolicies, advanced cloud storage configurations, and the Helm package manager. Author, package, and publish custom Helm charts for enterprise cloud-native applications.

### 🛣️ Daily Breakdown

- [x] **Day 190: The Kubernetes Networking Model**
  - Master the 4 fundamental networking rules (flat IP space, no NAT).
  - Understand Container Network Interface (CNI) plugins: Flannel, Calico, and Cilium (eBPF).
  - Trace pod-to-pod packet journeys across nodes (veth pairs, overlay networks).
  - Demystify CoreDNS and `kube-proxy` iptables DNAT rewriting.

- [x] **Day 191: Ingress Controllers & Layer 7 Routing**
  - Distinguish Ingress resources from Ingress Controllers.
  - Deploy and configure NGINX Ingress Controller on Minikube.
  - Architect host-based and path-based routing rules.
  - Enforce TLS encryption at the edge with Kubernetes TLS Secrets and `cert-manager`.
  - Customize reverse proxy behavior using Ingress annotations.

- [x] **Day 192: NetworkPolicies — Kubernetes Firewall**
  - Understand the vulnerabilities of Kubernetes default flat networking.
  - Identify CNI policy enforcement requirements (Calico/Cilium vs Flannel).
  - Implement a Zero-Trust default-deny baseline across namespaces.
  - Whitelist granular ingress/egress rules and preserve CoreDNS UDP/TCP port 53.

- [x] **Day 193: Advanced StorageClasses & Volume Snapshots**
  - Optimize AWS EBS CSI driver configurations (`gp3`, IOPS, throughput, encryption).
  - Eliminate multi-AZ volume scheduling failures with `WaitForFirstConsumer`.
  - Isolate stateful replica disks via StatefulSet `volumeClaimTemplates`.
  - Execute point-in-time backups and disaster recovery using CSI `VolumeSnapshots`.

- [x] **Day 194: Helm — Kubernetes Package Manager**
  - Eliminate raw YAML sprawl with parameterized Helm charts.
  - Master the release lifecycle (`install`, `upgrade`, `rollback`, `uninstall`).
  - Standardize environment configurations using `-f values.yaml`.
  - Deploy the enterprise `kube-prometheus-stack` observability suite.

- [x] **Day 195: Creating Custom Helm Charts**
  - Scaffold modular charts using `helm create`.
  - Master Go templating syntax, pipelines, conditionals, and built-ins.
  - Write reusable template helpers in `_helpers.tpl` using `nindent`.
  - Establish a 4-stage validation pipeline (`lint`, `template`, `--dry-run`, `install`).

- [x] **Day 196: Week 28 Review & Complete Application Stack**
  - Deploy an end-to-end multi-tier stack (Flask API, PostgreSQL, Redis, Ingress) via Helm.
  - Harden the environment with strict Zero-Trust NetworkPolicies.
  - Integrate dynamic, conditional HPA into custom Helm templates.
  - Publish a public Helm repository to GitHub Pages (`helm package`, `helm repo index`).
  - Master 25 high-yield CKA flashcards.
