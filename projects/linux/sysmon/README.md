# 🚀 Production System Monitor (`sysmon`)

> **Comprehensive Linux Observability, Performance Profiling & SRE Health Monitoring Suite.**  
> Built as the Month 1 Capstone Project (**Day 226 / 1000 — Linux Day 30 / 30**) of the **AI Cloud Infrastructure Journey**.

![Linux](https://img.shields.io/badge/Linux-Ubuntu%20%7C%20Debian%20%7C%20RHEL-black?style=for-the-badge&logo=linux&logoColor=white)
![Bash](https://img.shields.io/badge/Shell_Script-Bash%204.0+-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Systemd](https://img.shields.io/badge/Daemon-systemd%20service%20%26%20timer-red?style=for-the-badge)
![JSON](https://img.shields.io/badge/Output-JSON%20%26%20Terminal-orange?style=for-the-badge)

---

## 📌 Overview

Monitoring is not simply collecting raw numbers. Reliable cloud infrastructure operations require **accurate measurements**, **meaningful thresholds**, **defensive error handling**, **timestamps**, and the ability to investigate **abnormal conditions** before they escalate into service outages.

`sysmon.sh` is an automated, modular Linux performance monitor engineered for production workloads, edge nodes, and cloud compute instances. It evaluates CPU, memory, disk I/O, network sockets, process lifecycle health, and kernel/systemd errors, classifying system state into `NORMAL`, `WARNING`, or `CRITICAL` conditions.

---

## 🏗️ Architecture & Telemetry Pipeline

```text
                             ┌─────────────────┐
                             │    sysmon.sh    │
                             └────────┬────────┘
                                      │
         ┌────────────────┬───────────┼───────────┬────────────────┐
         ▼                ▼           ▼           ▼                ▼
     CPU Module       Memory      Disk I/O     Network          Process
     (mpstat, ps)   (free, ps)  (df, iostat)  (ss -ltn)    (ps, journalctl)
         │                │           │           │                │
         └────────────────┼───────────┼───────────┼────────────────┘
                                      │
                                      ▼
                         Threshold Classification Engine
                            (sysmon.conf: WARN / CRIT)
                                      │
                         ┌────────────┴────────────┐
                         ▼                         ▼
             Human Terminal Dashboard       Structured JSON
             (Color-coded status tags)    (--json cloud export)
                         │                         │
                         ▼                         ▼
                 Terminal / Console         Prometheus / Datadog
```

---

## ✨ Features & Modules

### 1. ⚡ CPU Performance & Workload Analysis
- **System Utilization**: Overall CPU busy percentage measured via `mpstat` / `top` fallbacks.
- **Per-Core Granularity**: Inspects uneven workload distribution across individual cores.
- **Load Averages**: 1-minute, 5-minute, and 15-minute load tracking relative to `nproc`.
- **Top CPU Consumers**: Identifies the highest CPU-consuming processes.

### 2. 🧠 Memory & Swap Health
- **Accurate RAM Availability**: Calculates utilization as $\frac{\text{Total} - \text{Available}}{\text{Total}} \times 100$ rather than relying solely on `free` memory.
- **Swap Saturation**: Tracks swap utilization to detect paging under pressure.
- **Top Memory Consumers**: Displays top processes by percentage memory and resident set size (RSS).

### 3. 💾 Filesystem Capacity & Disk I/O
- **Mount Point Auditing**: Filters virtual filesystems and evaluates storage capacity against configurable warning/critical thresholds.
- **Throughput Metrics**: Extracts real-time disk read throughput (`rkB/s`) and write throughput (`wkB/s`) via `iostat`.
- **Transaction Rate**: Captures IOPS transactions per second (`tps`) and device `%util`.

### 4. 🌐 Network Socket Telemetry
- **Listening TCP Sockets**: Enumerates active server listeners waiting for traffic (`ss -H -ltn`).
- **Established Sessions**: Tracks active TCP connections (`ss -H -tn state established`).

### 5. ⚙️ Process Inventory & Zombie Detection
- **Process Count**: Total active processes across all system namespaces.
- **Zombie Sweeper**: Detects defunct processes (`stat ~ /^Z/`) indicating parent reaping failures.
- **Elapsed Runtime Leaderboard**: Identifies the 3 longest-running processes formatted in days, hours, and minutes.

### 6. 📜 Systemd Journal Error Inspection
- Scrapes the latest 5 error-level log entries (`journalctl -p err -n 5`).
- Distinguishes permission-restricted execution from genuine zero-error log states.

### 7. 🔌 Dual-Format Telemetry
- **Terminal UI**: ANSI color-coded badges (`[ NORMAL ]`, `[ WARNING ]`, `[ CRITICAL ]`).
- **Machine-Readable JSON**: Generates structured JSON via `--json` for ingestion by CloudWatch, Prometheus, or Datadog agents.

---

## 📂 Project Structure

```text
projects/linux/sysmon/
├── sysmon.sh              # Core monitoring and telemetry engine
├── sysmon.conf            # Central configuration and threshold thresholds
├── sysmon.service         # Systemd oneshot unit definition
├── sysmon.timer           # Systemd timer unit (5-minute execution interval)
├── README.md              # Architectural and operational documentation
└── examples/
    ├── sample-output.txt  # Sample terminal dashboard transcript
    └── output.json        # Sample JSON telemetry payload
```

---

## 🚀 Installation & Prerequisites

`sysmon.sh` runs on any standard modern Linux distribution (Ubuntu, Debian, CentOS, Rocky Linux, Amazon Linux).

### 1. Install Required Tooling
```bash
sudo apt update
sudo apt install -y sysstat procps iproute2 util-linux
```

### 2. Make Executable
```bash
chmod +x sysmon.sh
```

### 3. Verify Script Syntax
```bash
bash -n sysmon.sh
```

---

## 💻 Usage

### Basic Interactive Run
```bash
./sysmon.sh
```

### Custom Configuration File
```bash
./sysmon.sh --config /etc/sysmon.conf
```

### JSON Telemetry Output (for Pipelines / APIs)
```bash
./sysmon.sh --json
```

### Disable Colors (for Pipe Redirection)
```bash
./sysmon.sh --no-color > /tmp/system_report.txt
```

---

## ⚙️ Configuration (`sysmon.conf`)

Thresholds and limits can be customized without altering script code:

```bash
# --- Resource Thresholds (Percentages 0-100) ---
CPU_WARN=70
CPU_CRIT=90

MEM_WARN=80
MEM_CRIT=95

DISK_WARN=80
DISK_CRIT=90

# --- Process & Log Limits ---
TOP_PROCESS_COUNT=3
JOURNAL_LOG_LINES=5

# --- Output Preferences ---
DEFAULT_OUTPUT_FORMAT="text"
LOG_FILE="/var/log/sysmon.log"
ENABLE_COLORS=true
```

---

## ⏱️ Automated Scheduling with Systemd

To run `sysmon.sh` automatically every 5 minutes and maintain audit logs:

### 1. Deploy Files to System Locations
```bash
sudo mkdir -p /opt/sysmon /etc/sysmon
sudo cp sysmon.sh /opt/sysmon/
sudo cp sysmon.conf /etc/sysmon/
sudo chmod +x /opt/sysmon/sysmon.sh
sudo cp sysmon.service /etc/systemd/system/
sudo cp sysmon.timer /etc/systemd/system/
```

### 2. Enable and Start the Timer
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now sysmon.timer
```

### 3. Verify Timer Status
```bash
systemctl list-timers sysmon.timer
```

### 4. Trigger Manual Run & Inspect Logs
```bash
sudo systemctl start sysmon.service
sudo journalctl -u sysmon.service -n 20
sudo tail -f /var/log/sysmon.log
```

---

## 🔍 Troubleshooting Scenarios

| Symptom | Diagnostic Clues | Root Cause & Remediation |
|---|---|---|
| **High Load Avg, Low CPU Util** | `mpstat` shows high `%iowait`; `vmstat` shows high blocked tasks (`b` > 0). | Unresponsive disk I/O, NFS mount hang, or synchronous filesystem writes. |
| **High Memory Usage, No OOM** | `free` shows low free memory, but high `available` memory. | Linux page caching. No action needed unless `available` approaches 0%. |
| **Zombie Processes Detected** | `ZOMBIE_PROCS > 0` flagged as `WARNING`. | Defunct processes whose parent process failed to call `wait()`. Inspect parent PID using `ps -ef \| grep defunct`. |
| **Zero Sockets Listed** | `LISTENING_TCP=0`. | Verify whether network services are running and check `ss` execution privileges. |

---

## 🌐 Cloud Infrastructure & SRE Relevance

This capstone project connects directly to core cloud infrastructure engineering practices:
- **Observability Foundations:** Establishes how daemon agents (like Datadog Agent, AWS CloudWatch Agent, and Prometheus Node Exporter) gather kernel counters from `/proc` and `sysfs`.
- **Site Reliability Engineering (SRE):** Provides the mathematical baseline for SLIs/SLOs (CPU saturation, memory exhaustion, disk filling rate).
- **Incident Response:** Provides a fast, standalone, zero-dependency diagnostic binary that can be copied onto any malfunctioning server during an outage.

---

*Part of the **1000-Days AI Cloud Infrastructure Journey** by [Kevin Joshua](https://github.com/kevinjosh10).*
