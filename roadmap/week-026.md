# Week 26 Roadmap: Kubernetes Core Concepts & Architecture

## 📅 Timeline: Days 176 - 182

### 🎯 Weekly Objective
Transition from Docker to Kubernetes. Master the internal architecture of the Kubernetes Control Plane and Worker Nodes. Understand the foundational K8s objects (Pods, Deployments, Services) and develop rapid `kubectl` muscle memory for the CKA exam.

### 🛣️ Daily Breakdown

- [x] **Day 176: The Control Plane**
  - Dissect the cluster brain: `kube-apiserver` and `etcd`.
  - Understand the matchmaking logic of `kube-scheduler`.
  - Learn the reconciliation loops of `kube-controller-manager`.
  - Bridge to AWS using `cloud-controller-manager`.

- [x] **Day 177: Worker Nodes & CRI**
  - Understand the role of the `kubelet` as the node captain.
  - Navigate the Docker deprecation and learn the Container Runtime Interface (CRI / containerd).
  - Understand how `kube-proxy` enforces network rules via `iptables`.
  - Memorize the 5 phases of a Pod's lifecycle.

- [x] **Day 178: Pods — The Fundamental Unit**
  - Write native Kubernetes Pod YAML from scratch.
  - Understand shared network namespaces (`localhost` communication).
  - Inspect lifecycles using `kubectl describe` and `kubectl logs`.
  - Execute live debugging with `kubectl exec`.

- [x] **Day 179: Deployments & ReplicaSets**
  - Master the Controller Hierarchy: Deployment ➡️ ReplicaSet ➡️ Pods.
  - Achieve self-healing and horizontal scaling.
  - Execute zero-downtime rolling updates.
  - Practice instant incident recovery using `kubectl rollout undo`.

- [x] **Day 180: Kubernetes Services**
  - Solve the problem of ephemeral Pod IPs.
  - Implement `ClusterIP` for secure internal traffic.
  - Implement `NodePort` for local development access.
  - Implement `LoadBalancer` to provision native AWS ELBs for production traffic.

- [x] **Day 181: Namespaces, Labels & Selectors**
  - Isolate environments (Dev vs. Prod) logically using Namespaces.
  - Use Labels as the core connective tissue for K8s objects.
  - Master equality-based vs. set-based Label Selectors.

- [x] **Day 182: Week 26 Capstone & Muscle Memory**
  - Configure `.bashrc` for CKA exam speed (`alias k=kubectl`).
  - Securely debug internal databases via `kubectl port-forward`.
  - Monitor live telemetry using `kubectl top`.
  - Deploy a complete 3-Tier microservices architecture on Minikube.
