# Week 25 Notes: Production Docker & Container Orchestration

## 1. Amazon ECR & Authentication
* **Never hardcode AWS keys.** Use `aws ecr get-login-password` to pipe a 12-hour token into `docker login`.
* **EC2 Pulls:** Attach an IAM Instance Role to the EC2 server (e.g., `AmazonEC2ContainerRegistryReadOnly`) so it can authenticate via metadata, eliminating stored credentials.
* **Lifecycle Policies:** JSON rules that automatically delete old/untagged images to prevent S3 storage bloat.

## 2. Resource Limits & OOM
* **CPU:** `--cpus="0.5"` enforces a hard limit. If exceeded, Docker **throttles** the container (it slows down). `--cpu-shares` dictates relative priority during contention.
* **Memory:** `--memory="128m"`. If exceeded, the Linux kernel triggers an **OOM (Out Of Memory)** event and kills the container (`OOMKilled: true`).
* **Observability:** `docker stats` is the `top` command for containers.

## 3. Production Operational Patterns
* **Healthchecks:** Bake `HEALTHCHECK` directly into the Dockerfile so orchestrators know if an app is deadlocked.
* **Self-Healing:** `--restart=unless-stopped` survives application crashes and host reboots.
* **Logging:** `--log-driver=awslogs` bypasses local disk and streams logs directly to AWS CloudWatch.
* **Immutability:** Never SSH into a container. Patch the code, rebuild the image, tag with a Git SHA, and redeploy.

## 4. Advanced Networking & Service Discovery
* **Embedded DNS:** Custom bridge networks have a DNS server at `127.0.0.11`. Containers resolve each other by name (e.g., `http://db:5432`).
* **Load Balancing:** If 3 containers share the same `--network-alias`, Docker uses Round-Robin DNS to balance traffic between them.
* **API Gateway:** A single Nginx container exposed to the public that routes traffic to isolated, private microservices based on URL paths.

## 5. Security Defense-in-Depth
* **Least Privilege:** `--cap-drop=ALL` strips root privileges. Add back only what is needed (e.g., `--cap-add=NET_BIND_SERVICE`).
* **Read-Only:** `--read-only` paired with `--tmpfs /tmp` prevents attackers from downloading malicious payloads to the filesystem.
* **Secrets:** Never use Environment Variables (they leak easily). Use Docker Secrets to mount passwords as temporary in-memory files.
* **Content Trust:** `DOCKER_CONTENT_TRUST=1` ensures you only run cryptographically signed images, preventing supply chain tampering.

## 6. The Bridge to Kubernetes
* Docker runs containers on a single host. Kubernetes orchestrates workloads across massive fleets of hosts.
* **The Pod:** Kubernetes doesn't run containers; it runs Pods. A Pod wraps 1+ containers that share the same network namespace, meaning they can communicate via `localhost`.
* **kompose:** A CLI tool that translates `docker-compose.yml` into native K8s Deployment and Service manifests.
