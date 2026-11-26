# Project 14: Microservice Process Controller (`14_service_ctl.sh`)
## Week 10 Capstone — Mastering Shell Scripting & Automation

**Author:** Kevin Josh (@kevinjosh10)  
**Track:** Linux Administration → Bash Automation → Cloud Infrastructure Engineering  
**Journey:** Day 270 / 1000 (27.0% Milestone)  

---

## 1. Project Overview

`14_service_ctl.sh` is a unified, production-ready Command-Line Interface (CLI) service lifecycle manager designed to control local background microservices and worker daemons. It consolidates all core Bash concepts mastered throughout Week 10:
- POSIX-compliant CLI argument parsing with `getopts`.
- Command routing via `case`.
- Defensive input validation (ports, environments, timeouts).
- Background process management with `nohup`, `$!`, and persistent PID tracking.
- Three-tier process and health verification (`kill -0`, socket inspection, and `curl` HTTP health probes).
- Graceful shutdown polling using SIGTERM with timeout escalation.
- Automated cleanup of stale or corrupted PID files.

---

## 2. CLI Architecture & Command Reference

```text
Usage:
  ./14_service_ctl.sh <COMMAND> [OPTIONS]

Primary Commands:
  start       Start the background service daemon
  stop        Gracefully terminate the running service (SIGTERM)
  restart     Stop and restart the service
  status      Verify if the service process is currently active
  health      Perform an HTTP endpoint health check (HTTP probe)

Options:
  -e ENV      Deployment environment: dev | staging | prod (default: dev)
  -p PORT     Network listening port: 1 - 65535 (default: 8001)
  -t SECONDS  Graceful shutdown / probe timeout: >= 1 (default: 10)
  -v          Enable verbose debug telemetry
  -h, --help  Display documentation and exit
```

---

## 3. The 3-Tier Verification Hierarchy

Reliable cloud infrastructure scripts never assume a service is healthy merely because its process exists. `14_service_ctl.sh` implements three independent verification tiers:

```text
                        3-Tier Verification Model
                        
  Tier 1: Process Verification (OS Level)
  └── Command: kill -0 "$PID"
  └── Verifies that the PID exists in the kernel process table and the caller has signal permissions.
  
  Tier 2: Port & Socket Verification (Transport Level)
  └── Command: ss -ltnp | grep ":$PORT"
  └── Verifies that the daemon has successfully bound its TCP listening socket.
  
  Tier 3: Application Health Verification (Application Layer)
  └── Command: curl -fsS --max-time "$TIMEOUT" "http://127.0.0.1:$PORT/"
  └── Probes the actual application runtime to confirm HTTP 2xx/3xx readiness.
```

---

## 4. State Management & Directory Layout

State files are isolated per service name, environment, and port:

```text
~/.local/state/service-ctl/
├── auth-service-dev-8001.pid   # Contains the active process PID
└── auth-service-dev-8001.log   # Standard output and standard error stream
```

---

## 5. Example Operational Sessions

### 1. Starting a Service
```bash
$ ./14_service_ctl.sh start -e dev -p 8001 -v
[INFO] 2026-11-26 12:00:00 - Starting auth-service on port 8001 (dev)...
[DEBUG] 2026-11-26 12:00:00 - Executing command: nohup python3 -m http.server 8001 --bind 127.0.0.1 > ~/.local/state/service-ctl/auth-service-dev-8001.log 2>&1 &
[SUCCESS] auth-service started successfully with PID 41285.
[INFO] 2026-11-26 12:00:01 - Listening on http://127.0.0.1:8001/
```

### 2. Checking Service Status
```bash
$ ./14_service_ctl.sh status -p 8001
[RUNNING] auth-service active | PID: 41285 | Port: 8001 | Env: dev
```

### 3. Probing Endpoint Health
```bash
$ ./14_service_ctl.sh health -p 8001
[INFO] 2026-11-26 12:00:10 - Probing service health endpoint: http://127.0.0.1:8001/ (Timeout: 10s)...
[HEALTHY] Service on port 8001 responded with HTTP 200 OK.
```

### 4. Restarting the Service
```bash
$ ./14_service_ctl.sh restart -p 8001
[INFO] 2026-11-26 12:00:20 - Initiating service restart sequence...
[INFO] 2026-11-26 12:00:20 - Sending SIGTERM to process PID 41285...
[SUCCESS] Service PID 41285 stopped gracefully after 1s.
[INFO] 2026-11-26 12:00:22 - Starting auth-service on port 8001 (dev)...
[SUCCESS] auth-service started successfully with PID 41350.
```

### 5. Gracefully Stopping the Service
```bash
$ ./14_service_ctl.sh stop -p 8001
[INFO] 2026-11-26 12:00:30 - Sending SIGTERM to process PID 41350...
[SUCCESS] Service PID 41350 stopped gracefully after 0s.
```

---

## 6. Real-World Cloud & DevOps Engineering Alignment

| Controller Function | Enterprise Infrastructure Equivalent |
|---|---|
| `start_service()` | Docker container startup / `systemctl start <unit>` |
| `stop_service()` | Kubernetes pod graceful termination period (`terminationGracePeriodSeconds`) |
| `restart_service()` | Kubernetes rolling rollout restart / AWS Auto-Scaling instance cycling |
| `status_service()` | Kubelet liveness probes / process supervisor health polling |
| `health_check()` | Application Load Balancer target group health checks (`/healthz`) |
| Logging & Signals | UNIX 12-Factor App observability and graceful signal handling |

---

*Part of the 1000-Day AI Cloud Infrastructure Engineering Journey.*
