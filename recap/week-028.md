# Week 28 Recap: Advanced Kubernetes & Helm

## 🏆 Weekly Milestones Achieved
- **Demystified Cluster Networking:** Unpacked the 4 rules of the Kubernetes network model, CNI plugin architectures, and the Linux `iptables` DNAT mechanics managed by `kube-proxy`.
- **Architected Layer 7 Ingress:** Eliminated load balancer sprawl by routing multiple internal microservices through a unified NGINX Ingress Controller with SSL termination.
- **Implemented Zero-Trust Security:** Hardened cluster namespaces using default-deny NetworkPolicies enforced by Calico CNI, whitelisting least-privilege service ports and CoreDNS port 53.
- **Mastered Enterprise Storage & Disaster Recovery:** Optimized AWS EBS CSI `gp3` storage classes, solved multi-AZ scheduling traps with `WaitForFirstConsumer`, and executed point-in-time restores with CSI VolumeSnapshots.
- **Conquered Helm & Package Management:** Transitioned from raw YAML manifests to modular, parameterized Helm charts utilizing Go templating, `_helpers.tpl`, and `nindent`.
- **Published Public Helm Repository:** Automated chart packaging and repository indexing, hosting custom charts on GitHub Pages for public distribution.
- **Orchestrated a Complete Production Stack:** Deployed a fully isolated, autoscaling 4-tier stack (Flask, Postgres, Redis, Ingress) and locked in 25 high-yield CKA exam flashcards.

## 🧠 Major Paradigm Shift
Week 28 marked the shift from basic application deployment to **Platform Engineering and Zero-Trust Operations**.

I learned that running containers in Kubernetes is meaningless without securing the packet boundary. A flat network is a security liability; storage must be resilient across availability zones; and manual YAML writing does not scale in enterprise teams. By packaging applications into versioned Helm charts and establishing declarative network firewalls, I now manage Kubernetes not as a collection of loose containers, but as an integrated, hardened distributed platform.

## 🚀 Status
The core of Kubernetes is fully conquered. Next up: **Week 29 — AWS EKS, AWS Load Balancer Controller, EKS IAM Roles for Service Accounts (IRSA), and GitOps with ArgoCD!**
