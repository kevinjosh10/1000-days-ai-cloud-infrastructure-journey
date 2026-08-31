# Week 26 Notes: Kubernetes Architecture & Foundations

## 1. The Control Plane (The Brain)
* **`kube-apiserver`:** The single entry point for all control plane communication. All `kubectl` commands hit this first.
* **`etcd`:** The highly available key-value store. It is the absolute source of truth. If `etcd` dies, the cluster is blind.
* **`kube-scheduler`:** Does *not* run containers. It simply evaluates resource requirements and assigns unscheduled Pods to suitable worker nodes.
* **`kube-controller-manager`:** Runs reconciliation loops (e.g., Replication Controller) to ensure the *actual* state constantly matches the *desired* state.

## 2. Worker Nodes (The Muscle)
* **`kubelet`:** The agent on every node that talks to the API server and commands the local container runtime to start/stop containers.
* **CRI (Container Runtime Interface):** Kubernetes no longer uses Docker by default (since v1.24). It uses CRI-compatible runtimes like `containerd` or `CRI-O`.
* **`kube-proxy`:** Maintains network rules (`iptables` / `IPVS`) on the node to ensure traffic hitting a Service IP is correctly routed to a backend Pod IP.

## 3. Workload Hierarchy
* **Pod:** The atomic unit. Wraps 1+ containers. Containers in the same Pod share a network namespace and communicate via `localhost`. *Never run bare pods in production (no self-healing).*
* **ReplicaSet:** Ensures exactly `N` copies of a Pod are always running.
* **Deployment:** Manages ReplicaSets. Provides zero-downtime rolling updates (`kubectl rollout status`) and instant rollbacks (`kubectl rollout undo`).

## 4. Services (Networking)
Pods are ephemeral; their IPs change when they die. Services provide a stable Virtual IP and DNS name.
* **ClusterIP:** Internal only. Used for pod-to-pod communication (e.g., API to Database).
* **NodePort:** Opens a port (30000-32767) on *every* worker node. Dangerous for production.
* **LoadBalancer:** Triggers the `cloud-controller-manager` to provision a real cloud load balancer (e.g., AWS ELB). The standard for exposing web traffic.

## 5. Organization & CKA Speed
* **Namespaces:** Logically isolate workloads within the same physical cluster (e.g., `dev` vs `prod`).
* **Labels & Selectors:** Labels (`app: web`) attach metadata to Pods. Services and Deployments use Selectors to find and manage those Pods.
* **Aliases:** Essential for exam speed: `alias k=kubectl` and `source <(kubectl completion bash)`.
* **Debugging:** Use `kubectl port-forward pod/db-pod 5432:5432` to securely tunnel into a private pod from a local laptop without exposing it to the internet.
