# Week 28 Notes: Networking, Ingress, Storage & Helm

## 1. Kubernetes Networking Foundations
* **The 4 Inviolable Rules:** Every Pod gets its own IP; all Pods communicate cross-node without NAT; node agents communicate with local Pods; a Pod's IP is its true source identity.
* **CNI Landscape:** Flannel (simple VXLAN), Calico (BGP routing + NetworkPolicies), Cilium (eBPF kernel-level routing and security), AWS VPC CNI (native ENI secondary IPs).
* **ClusterIP Mechanics:** A virtual IP programmed by `kube-proxy` into node `iptables` or IPVS tables, performing Destination NAT (DNAT) to randomly select backend Pod IPs.
* **CoreDNS FQDN:** `<service>.<namespace>.svc.cluster.local`.

## 2. Layer 7 Ingress & Routing
* **Resource vs. Controller:** An Ingress manifest only declares routing rules; an Ingress Controller (NGINX, Traefik, AWS ALB Controller) is the reverse proxy that executes them.
* **Consolidation:** Replaces expensive multiple cloud load balancers with a single external entry point routing by host (`api.domain.com`) and path (`/service`).
* **TLS Termination:** Managed via `kubernetes.io/tls` secrets containing certificates and private keys, automated in production via `cert-manager`.

## 3. NetworkPolicies & Zero-Trust Security
* **CNI Dependency:** NetworkPolicies require an enforcement-capable CNI (Calico or Cilium). On basic Flannel, policies are silently ignored.
* **Default-Deny:** `podSelector: {}` with empty rules cuts off all ingress and egress.
* **The CoreDNS Lifeline:** When default-deny egress is enforced, egress to `kube-system` on UDP/TCP port 53 must be explicitly allowed, otherwise all DNS resolution fails.

## 4. Storage Classes & Volume Snapshots
* **EBS `gp3` Optimization:** Baseline 3,000 IOPS and 125 MB/s throughput decoupled from disk size; 20% cheaper than `gp2`. Always set `encrypted: "true"`.
* **Binding Mode:** Use `WaitForFirstConsumer` instead of `Immediate` to prevent provisioning EBS volumes in an Availability Zone different from where the Pod gets scheduled.
* **StatefulSets:** Use `volumeClaimTemplates` so each ordinal replica (`pod-0`, `pod-1`) gets its own isolated, persistent PVC that survives StatefulSet deletion.
* **CSI VolumeSnapshots:** Capture point-in-time volume backups and restore data to new PVCs using `spec.dataSource`.

## 5. Helm & Go Templating
* **Chart Structure:** `Chart.yaml` (metadata), `values.yaml` (parameters), `templates/` (manifests), `_helpers.tpl` (partials).
* **Templating Functions:** `{{ .Values.path }}`, `{{ .Release.Name }}`, `{{- if ... }}`, `toYaml`, and `| nindent 4` for clean indentation.
* **Best Practices:** Use `-f values.yaml` over `--set` for GitOps traceability; run `helm lint` and `helm template` prior to deployment.
* **Repository Publishing:** Packaged with `helm package`, indexed with `helm repo index`, and served via static hosts like GitHub Pages or S3.
