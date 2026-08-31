# Week 26 Recap: Kubernetes Architecture

## 🏆 Weekly Milestones Achieved
- **Demystified the Control Plane:** Built a solid mental model of how `kube-apiserver`, `etcd`, and the controllers work together to maintain cluster state.
- **Understood the Node:** Learned how `kubelet`, `kube-proxy`, and modern CRI runtimes (`containerd`) actually execute the compute and networking on the bare metal.
- **Mastered the Pod:** Wrote native Kubernetes YAML from scratch, abandoning `docker run` forever.
- **Engineered Self-Healing:** Implemented Deployments and ReplicaSets to achieve horizontal scaling, rolling updates, and instant rollbacks with zero downtime.
- **Architected Cloud Networking:** Solved the ephemeral IP problem using ClusterIP, NodePort, and AWS ELB LoadBalancer services.
- **Developed CKA Muscle Memory:** Configured aliases and mastered the rapid use of `kubectl exec`, `logs`, `top`, and `port-forward` for deep cluster debugging.
- **Deployed a 3-Tier Architecture:** Validated the entire week's learning by deploying a complete, isolated microservices application onto Minikube.

## 🧠 Major Paradigm Shift
Week 26 forced a massive shift from *imperative* commands to *declarative* state. 

I am no longer telling a server *how* to run a container. I am submitting a YAML manifest to a Control Plane, declaring my *desired state* (e.g., "I want 3 Nginx pods"). The Kubernetes reconciliation loops take over, relentlessly working to make the actual state match my desired state. Understanding this control loop is the key to mastering cloud orchestration.

## 🚀 Status
The Kubernetes foundation is laid. I am ready to move into Week 27 and tackle the advanced primitives: ConfigMaps, Secrets, PersistentVolumes, and StatefulSets.
