# Week 27 Notes: Kubernetes Workloads & Primitives

## 1. Configuration & Security
* **ConfigMaps:** Store non-sensitive data. Can be injected as ENV vars or mounted as physical files. Mounted files update automatically in the container if the ConfigMap YAML changes.
* **Secrets:** Are **NOT** encrypted by default in `etcd`, only Base64 encoded.
* **External Secrets Operator (ESO):** The industry standard for GitOps. Syncs real encrypted secrets from AWS Secrets Manager directly into native K8s Secrets so plaintext passwords never touch the Git repository.

## 2. Compute Resources & QoS
* **Requests:** The minimum guaranteed resources. The Scheduler uses this to place Pods on nodes.
* **Limits:** The absolute maximum resources allowed. Exceeding CPU causes throttling. Exceeding Memory causes an immediate `OOMKilled` termination.
* **QoS Classes:** To ensure a critical Pod is never evicted during a node resource shortage, achieve a **Guaranteed** class by setting `requests` exactly equal to `limits`.

## 3. Persistent Storage
* **PV (PersistentVolume):** The physical storage drive.
* **PVC (PersistentVolumeClaim):** The ticket requesting the storage.
* **StorageClass:** Automates the dynamic creation of PVs (e.g., automatically calling the AWS API to provision a `gp3` EBS volume).
* **Access Modes:** AWS EBS is strictly `ReadWriteOnce` (RWO)—it can only be mounted by one Node at a time. Multi-node read/write requires EFS (`ReadWriteMany`).

## 4. Advanced Controllers
* **DaemonSet:** Guarantees exactly one Pod runs on *every* Node. Perfect for Fluentd or Datadog agents.
* **StatefulSet:** Provides stable identities (`web-0`), stable network names, and strictly ordered startup/shutdown. Mandatory for distributed databases like Kafka or Elasticsearch.
* **Jobs / CronJobs:** Used for run-to-completion tasks. Ideal for database schema migrations (Job) or nightly batch processing (CronJob).

## 5. Autoscaling
* **HPA (Horizontal Pod Autoscaler):** Dynamically scales Replicas based on CPU/RAM metrics provided by the `metrics-server`.
* **KEDA:** Extends HPA to scale based on external events, such as AWS SQS queue depth or Kafka consumer lag. Essential for asynchronous ML batch processing.

## 6. Production YAML Guardrails
* **Probes:** `Liveness` restarts a stuck container. `Readiness` removes a booting container from the load balancer until it is ready.
* **Zero-Downtime:** Achieved via `strategy.type: RollingUpdate` with `maxUnavailable: 0` and `maxSurge: 1`.
* **LimitRange:** A namespace-level policy that injects default requests/limits into Pods that fail to define them.
