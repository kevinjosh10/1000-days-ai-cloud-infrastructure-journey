# Week 24 Roadmap: Docker & Containerization Mastery

## 📅 Timeline: Days 162 - 168

### 🎯 Weekly Objective
Transition from deploying raw infrastructure to packaging the application layer. Master Docker architecture, image optimization, networking, persistent storage, multi-container orchestration, and automated CI/CD container delivery pipelines.

### 🛣️ Daily Breakdown

- [x] **Day 162: Docker Architecture & Fundamentals**
  - Understand the difference between Images and Containers.
  - Learn the underlying Linux technologies: Namespaces (isolation) and Cgroups (resource limitation).
  - Understand the Docker Engine architecture (Daemon, REST API, CLI).

- [x] **Day 163: Dockerfile Mechanics**
  - Learn core instructions: `FROM`, `WORKDIR`, `COPY`, `RUN`, `ENV`, `EXPOSE`.
  - Master the difference between `CMD` (default arguments) and `ENTRYPOINT` (fixed executable).
  - Build and run the first Python Flask API container.

- [x] **Day 164: Image Optimization & Security**
  - Implement Multi-stage builds to drastically reduce production image sizes.
  - Utilize `.dockerignore` to prevent secret leaks and bloat.
  - Enforce non-root container users for security.
  - Optimize Dockerfile layer caching for faster builds.

- [x] **Day 165: Docker Networking**
  - Understand Docker Network Drivers (`bridge`, `host`, `none`, `overlay`).
  - Master internal DNS and Service Discovery (containers finding each other by name).
  - Distinguish between `EXPOSE` (documentation) and `-p` (host port mapping).

- [x] **Day 166: Docker Volumes & Data Persistence**
  - Solve the ephemeral filesystem problem for stateful workloads.
  - Implement Named Volumes (for production databases).
  - Implement Bind Mounts (for local development live code reloading).
  - Use `tmpfs` for in-memory secrets and `:ro` for read-only security.

- [x] **Day 167: Docker Compose**
  - Move from imperative `docker run` scripts to declarative YAML blueprints.
  - Orchestrate a 3-tier architecture (Nginx, Flask, Postgres, Redis) in one file.
  - Solve startup race conditions using `depends_on` with `healthcheck`.
  - Use `compose.override.yml` for local development workflows.

- [x] **Day 168: Week 24 Capstone — Container CI/CD Pipeline**
  - Containerize Python AWS tools and test them locally using LocalStack.
  - Scan images for vulnerabilities using Trivy.
  - Automate build, test, scan, and push to Amazon ECR using GitHub Actions.
