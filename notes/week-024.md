# Week 24 Notes: Docker & Containerization

## 1. Docker Architecture
* **Containers vs VMs:** VMs virtualize hardware and run full Guest OS kernels. Containers virtualize the OS, sharing the Host kernel. They are lightweight, fast, and portable.
* **Under the Hood (Linux):** 
  * **Namespaces:** Provide isolation (Process IDs, Networking, Mount points).
  * **Cgroups:** Provide resource limitation (CPU, Memory limits).
  * **UnionFS:** The layered filesystem that makes images efficient.
* **Docker Engine:** Consists of the Docker Daemon (`dockerd`), a REST API, and the Docker CLI.

## 2. Dockerfiles
* The blueprint for an image. Evaluated top-to-bottom. Each line creates a new filesystem layer.
* **`COPY requirements.txt .` BEFORE `COPY . .`:** This optimizes layer caching. Dependencies change less often than code, so placing them higher prevents unnecessary `pip install` executions on every code change.
* **`CMD` vs `ENTRYPOINT`:** `ENTRYPOINT` is the fixed command that runs (e.g., `python`), `CMD` provides the default arguments (e.g., `app.py`) which can be overridden at `docker run`.

## 3. Image Optimization & Security
* **Multi-Stage Builds:** Use a `builder` stage with heavy compilers to build the app, then `COPY --from=builder` the final artifact into a minimal, scratch-like production image.
* **Non-Root Users:** Always add `RUN useradd appuser` and `USER appuser` to prevent attackers from gaining root access if the container is compromised.
* **`.dockerignore`:** Crucial for preventing local `.env` files (containing AWS keys) from being baked into the image.

## 4. Networking & Service Discovery
* **Bridge Network:** The default. Containers on the same bridge can communicate using internal DNS.
* **Service Discovery:** In a custom bridge network, if a database container is named `db`, the API container can connect to it simply using `db:5432`. No hardcoded IP addresses needed.
* **`EXPOSE` vs `-p`:** `EXPOSE 80` just documents the port. `-p 8080:80` actually punches a hole through the host firewall, mapping host port 8080 to container port 80.

## 5. Storage & Persistence
Containers are ephemeral; their local filesystem dies with them.
* **Named Volumes:** Docker-managed directories. Use for production databases (PostgreSQL, Redis).
* **Bind Mounts:** Direct mappings to specific host paths (`-v $(pwd):/app`). Use strictly for local development (live code reloading). Never use in production.
* **tmpfs:** Memory-only storage for sensitive secrets.

## 6. Docker Compose
* Declarative YAML for multi-container orchestration. Replaces messy `docker run` scripts.
* **Healthchecks:** Solves race conditions. Combine `healthcheck` on a database with `depends_on: db: condition: service_healthy` on the API so the API waits for the DB to physically accept connections.
* **`compose.override.yml`:** Used to inject dev-specific settings (like bind mounts) without polluting the base configuration.

## 7. CI/CD & Local Testing
* **LocalStack:** A containerized, fake AWS environment. Allows local testing of AWS scripts without touching a real AWS account or paying for cloud resources.
* **Trivy:** Open-source image scanner. Used in CI/CD to catch HIGH and CRITICAL vulnerabilities (CVEs) before deployment.
* **Amazon ECR:** Elastic Container Registry. The AWS equivalent of Docker Hub where production images are stored.
