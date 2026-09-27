# 🛡️ Process Guardian

A lightweight, configuration-driven Bash process supervisor and automated recovery system managed by `systemd`.

---

## 📌 Features

- **Continuous Health Checks**: Proactively monitors critical background processes via `pgrep`.
- **Hybrid Recovery Support**: Recovers workloads using native `systemd` unit restarts (`systemctl restart`) or custom background startup commands.
- **Sliding-Window Failure Alerting**: Tracks restart timestamps per process and logs an alert if any workload restarts $\ge 3$ times within a 5-minute (300s) window.
- **Unified Journal Logging**: Dispatches structured logs with severity tags (`INFO`, `WARNING`, `CRITICAL`, `ERROR`) directly to `systemd-journald` using `logger`.
- **Graceful Signal Handling**: Traps `SIGTERM` and `SIGINT` signals to ensure proper shutdown and logging.
- **Layered Supervision**: Runs as a daemon under `systemd` with `Restart=always` and `RestartSec=5` for self-healing resilience.

---

## 🏗️ Architecture

```text
                    systemd
                       │
                       ▼
          process_guardian.service (Level 2 Recovery)
                       │
                       ▼
             process_guardian.sh
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
  processes_to_guard.cfg     journald
              │                 │
              ▼                 ▼
      Critical Processes    Restart Logs
        (Level 1 Recovery)
              │
        ┌─────┼─────┐
        ▼     ▼     ▼
      nginx   API  worker
```

---

## ⚙️ Configuration (`processes_to_guard.cfg`)

Define target workloads in `processes_to_guard.cfg` using pipe-delimited format:

```text
# <process_name>|<restart_method>|<restart_target>
nginx|systemd|nginx.service
api_server|command|/opt/api/bin/start.sh
```

---

## 🚀 Installation & Service Setup

1. **Deploy configuration and script**:
   ```bash
   sudo mkdir -p /etc/process-guardian
   sudo cp processes_to_guard.cfg /etc/process-guardian/
   sudo cp process_guardian.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/process_guardian.sh
   ```

2. **Install and enable systemd unit**:
   ```bash
   sudo cp process_guardian.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now process_guardian.service
   ```

---

## 📊 Management & Journal Log Inspection

- **Check Service Status**:
  ```bash
  systemctl status process_guardian.service
  ```

- **Live Stream Logs**:
  ```bash
  journalctl -u process_guardian.service -f
  ```

- **Inspect Guardian Tagged Events**:
  ```bash
  journalctl -t process-guardian -n 30
  ```

- **Filter Critical Alerts**:
  ```bash
  journalctl -t process-guardian | grep "ALERT"
  ```
