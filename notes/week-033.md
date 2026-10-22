# Week 33 Notes: Linux Capstone & Networking Mastery Foundations

## 📅 Timeline: Days 225 - 231 (October 12, 2026 – October 18, 2026)

---

## Day 225 — Day 29 — Integration & Practice: Sick Server Diagnosis
**Date:** 12 October 2026 (Calendar: October 12, 2026 (Monday))

---

## 1. Objectives

By the end of this lab, I will be able to:

- Integrate Linux monitoring tools to investigate a sick server.
- Interpret `vmstat`, `iostat`, `ss`, `top`, and `free` output.
- Identify CPU, memory, disk, and network bottlenecks.
- Find resource-intensive processes and inspect their open files.
- Distinguish symptoms from root causes.
- Create a structured incident diagnosis report.
- Verify whether the system recovers after the workload stops.

---

## 2. Troubleshooting Methodology

A systematic troubleshooting process follows these steps:

1. **Observe:** Identify symptoms and establish a baseline.
2. **Measure:** Collect CPU, memory, disk, and network metrics.
3. **Analyze:** Compare measurements and identify abnormal behavior.
4. **Identify:** Find the process or resource responsible.
5. **Verify:** Test whether the evidence supports the suspected cause.
6. **Recommend:** Document corrective actions.
7. **Monitor:** Confirm recovery after the intervention.



---

## 3. Tools Reviewed

### 3.1 System Overview

```bash
uptime
hostname
nproc
top
```

Purpose:

- `uptime`: Displays uptime, load averages, and logged-in users.
- `hostname`: Identifies the machine.
- `nproc`: Displays the number of available processing units.
- `top`: Provides a live view of processes and resource usage.

---

### 3.2 Memory Monitoring

```bash
free -h
vmstat 1
```

Important `vmstat` columns:

| Column | Meaning |
|---|---|
| `r` | Runnable or running processes |
| `b` | Processes blocked, often waiting for I/O |
| `swpd` | Amount of virtual memory in use |
| `free` | Unused memory |
| `si` | Swap memory read in |
| `so` | Swap memory written out |
| `us` | CPU time spent in user processes |
| `sy` | CPU time spent in the kernel |
| `id` | CPU idle time |
| `wa` | CPU time waiting for I/O |
| `st` | CPU time taken by the hypervisor |

Interpretation:

- High `us` may indicate CPU-intensive application workloads.
- High `sy` may indicate substantial kernel activity.
- Low `id` and a persistent high run queue may indicate CPU contention.
- High `wa` warrants investigation of I/O delays.
- Sustained `si` and `so` suggest active swapping.
- High `st` may indicate that the virtual machine is competing for physical CPU resources.

The first data row in `vmstat` commonly represents averages since boot. Focus on subsequent rows when investigating current conditions.

---

### 3.3 Disk Monitoring

```bash
iostat -xz 1
```

Important metrics:

| Metric | Meaning |
|---|---|
| `r/s` | Read operations per second |
| `w/s` | Write operations per second |
| `r_await` | Average read request wait time |
| `w_await` | Average write request wait time |
| `aqu-sz` | Average I/O queue size |
| `%util` | Percentage of time the device had I/O requests in progress |

Interpretation:

- Increasing I/O latency may indicate storage delays.
- A growing queue can indicate that requests are accumulating.
- High utilization combined with latency and application slowdown warrants investigation.
- `%util` alone does not prove that every type of storage device is saturated.

If the command is unavailable, install the `sysstat` package using the appropriate package manager.

---

### 3.4 Network Monitoring

```bash
ss -s
ss -tan
ss -lnt
ip -s link
```

TCP states:

- `LISTEN`: Waiting for incoming connections.
- `ESTAB`: Established connection.
- `TIME-WAIT`: Recently closed connection awaiting expiration.
- `SYN-RECV`: Connection request received; handshake is incomplete.
- `CLOSE-WAIT`: Peer has closed its side, but the local application has not fully closed the socket.

Investigate unusual connection counts, interface errors, dropped packets, and service-specific behavior.

A large number of connections does not automatically prove that the network is the bottleneck.

---

### 3.5 Process Investigation

```bash
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -15
```

These commands identify processes consuming the most CPU or memory.

For process-level I/O monitoring:

```bash
pidstat -d 1
```

For process-level CPU monitoring:

```bash
pidstat 1
```

If `pidstat` is unavailable, install `sysstat`.

---

### 3.6 Open File Investigation

The tool used to identify processes that have opened a file is `lsof`.

```bash
sudo lsof /var/log/syslog
sudo lsof -p PID
sudo lsof -i
```

Replace `PID` with the actual process ID.

- `lsof /path/to/file`: Identifies processes using a particular file.
- `lsof -p PID`: Lists files and sockets opened by a process.
- `lsof -i`: Lists network sockets.

Alternative:

```bash
sudo fuser -v /path/to/file
```

These tools are useful when investigating file locks, open log files, deleted files that still consume disk space, and excessive open file descriptors.

---

### 3.7 System Logs

```bash
sudo journalctl -k --since "15 minutes ago"
```

This displays recent kernel journal messages, subject to permissions and journal availability.

Look for:

- Out-of-memory events.
- Hardware or storage errors.
- Filesystem errors.
- Driver issues.
- Other kernel warnings related to the incident.

---

## 4. Establish a Baseline

Before generating load, record the normal behavior of the machine.

Create a working directory:

```bash
mkdir -p ~/day225-diagnosis
cd ~/day225-diagnosis
```

Capture baseline measurements:

```bash
{
    date
    hostname
    uptime
    nproc
    free -h
    df -h
    df -i
    vmstat 1 5
    ss -s
    ps aux --sort=-%cpu | head -10
    ps aux --sort=-%mem | head -10
} > baseline.txt 2>&1
```

Purpose of each command:

- `uptime`: Establishes system load and uptime.
- `nproc`: Records available CPU processing units.
- `free -h`: Records memory and swap usage.
- `df -h`: Checks filesystem capacity.
- `df -i`: Checks inode consumption.
- `vmstat 1 5`: Records five one-second monitoring samples.
- `ss -s`: Records a socket summary.
- `ps`: Identifies resource-intensive processes.

Baseline measurements provide a reference for comparison after the workload starts and stops.

---

## 5. Simulate a Sick Server

### Safety Precautions

Run this experiment only on a Linux lab VM that you control.

- Do not run uncontrolled stress tests on production systems.
- Begin with a small workload.
- Use a time limit.
- Monitor memory and system responsiveness.
- Stop the experiment if the machine becomes unstable.
- Avoid running multiple workers for every resource on a weak VM.

### 5.1 Check stress-ng

```bash
stress-ng --version
```

If it is missing, install the `stress-ng` package through your Linux distribution's package manager.

### 5.2 CPU Test

```bash
stress-ng --cpu 1 --timeout 60s --metrics-brief
```

This creates one CPU stress worker for up to 60 seconds.

Monitor it in another terminal:

```bash
top
vmstat 1
```

Observe CPU utilization, idle time, run queue length, and the process consuming CPU.

### 5.3 Memory Test

```bash
stress-ng --vm 1 --vm-bytes 20% --timeout 60s --metrics-brief
```

This creates one virtual-memory stress worker with a memory allocation target based on available memory.

Monitor the machine:

```bash
free -h
vmstat 1
ps aux --sort=-%mem | head -10
```

Observe available memory and swap activity. The allocation target is not a guarantee of exact physical RAM consumption.

### 5.4 I/O Test

```bash
stress-ng --io 1 --timeout 60s --metrics-brief
```

Monitor the system:

```bash
iostat -xz 1
pidstat -d 1
```

Observe I/O latency, queue depth, and process-level I/O activity.

The `--io` option does not guarantee a storage bottleneck. Confirm what actually happens on the system.

### 5.5 Combined Test

After testing each resource individually, a combined test can be performed if the VM has sufficient resources:

```bash
stress-ng --cpu 1 --vm 1 --vm-bytes 20% --io 1 --timeout 60s --metrics-brief
```

This exercises CPU, memory, and I/O activity simultaneously.

Use the measurements to determine which resource is under pressure. Do not assume that every resource will become a bottleneck.

---

## 6. Integrated Diagnosis Procedure

### Step 1: Check Overall Health

```bash
uptime
top
free -h
```

Questions:

- Is the load average unusually high?
- Is CPU idle time low?
- Is available memory declining?
- Are processes becoming unresponsive?

### Step 2: Measure CPU and Memory Pressure

```bash
vmstat 1
```

Observe:

- Run queue length.
- Blocked processes.
- CPU idle percentage.
- CPU I/O wait.
- Swap-in and swap-out activity.

### Step 3: Investigate Storage

```bash
iostat -xz 1
pidstat -d 1
df -h
df -i
```

Check for increasing latency, growing queues, high I/O activity, a full filesystem, or inode exhaustion.

### Step 4: Identify the Culprit

```bash
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
```

Inspect the relevant process:

```bash
sudo lsof -p PID
```

Replace `PID` with the process ID being investigated.

### Step 5: Investigate Network Behavior

```bash
ss -s
ss -lnt
ss -tan
ip -s link
```

Look for abnormal connection counts, interface errors, packet drops, or unexpected services.

### Step 6: Inspect Logs

```bash
sudo journalctl -k --since "15 minutes ago"
```

Correlate relevant log messages with the time the incident occurred.

### Step 7: Verify Recovery

After the time-limited workload finishes, repeat the baseline measurements.

Compare CPU, memory, disk, and network metrics.

Document which measurements returned toward their original values and which remained abnormal.

---

## 7. Sick Server Diagnosis Report

### 7.1 Incident Summary







### 7.2 Test Environment

| Property | Observation |
|---|---|
| Operating system | Linux Ubuntu / Debian |
| Kernel version | Linux 6.x |
| Available CPU cores | Multiple cores (`nproc`) |
| Total RAM | System RAM |
| Swap configuration | Active swap partition / file |
| Filesystem capacity | Ext4 / XFS root partition |
| Workload command | `stress-ng --cpu 1 --vm 1 --io 1 --timeout 60s` |
| Test duration | 60 seconds |

---

## 8. Lessons Learned

Today I practiced combining Linux monitoring tools instead of investigating individual metrics in isolation.

I learned that:

- Systematic diagnosis is more reliable than guessing.
- CPU, memory, disk, and network problems can produce overlapping symptoms.
- `vmstat` helps identify system pressure.
- `iostat` helps investigate storage behavior.
- `ss` provides insight into socket states and connections.
- `lsof` helps identify processes using files and sockets.
- Process-level measurements help connect system symptoms to a workload.
- Root-cause conclusions must be supported by evidence.
- Recovery must be verified after a workload ends.
- A professional incident report should explain symptoms, evidence, cause, impact, recommendations, and verification.

---

## 9. Day 29 Completion Checklist

- [x] Captured baseline measurements.
- [x] Reviewed `vmstat` output.
- [x] Investigated storage with `iostat`.
- [x] Identified resource-intensive processes.
- [x] Inspected open files with `lsof`.
- [x] Checked TCP connections with `ss`.
- [x] Ran at least one safe, time-limited stress test.
- [x] Compared measurements before and after the workload.
- [x] Identified a root cause supported by evidence.
- [x] Completed diagnosis documentation.
- [x] Documented recommendations and recovery verification.

---

## 10. Final Reflection

**Day 225/1000 — Day 29/30 of Mastering Linux**

Today's objective was to move beyond knowing individual Linux commands and develop a systematic approach to diagnosing a sick server.

A cloud infrastructure engineer must be able to measure system behavior, identify abnormal resource usage, correlate evidence across tools, determine the likely root cause, and verify recovery.

The goal is not simply to make the server work again. The goal is to understand why it failed, explain the evidence, and reduce the likelihood of the same incident happening again.

**1000 Days. 2 Hours Daily. Building toward AI Cloud Infrastructure Engineering.**

---

## Day 226/1000 — Linux Day 30/30: Production System Monitor
**Date:** October 13, 2026 (Calendar: October 13, 2026 (Tuesday))

---

## 1. Objective

Build `sysmon.sh`, a comprehensive Linux system monitoring script that collects essential system metrics, identifies potential performance problems, and reports system health through readable terminal output.

This capstone combines the Linux skills learned throughout the first 30 days into a single practical infrastructure monitoring tool.

### Core Objectives

- Monitor CPU utilization, per-core usage, load averages, and CPU-intensive processes.
- Monitor RAM usage, available memory, swap, and memory-intensive processes.
- Inspect filesystem capacity and identify disk usage above configured thresholds.
- Collect disk I/O statistics, including read and write throughput.
- Count listening TCP sockets and established TCP connections.
- Count processes and zombie processes.
- Identify the three processes with the longest elapsed runtime.
- Collect the latest five error-level system journal entries when accessible.
- Display timestamps and classify resource usage using configurable thresholds.
- Explore automated execution using a systemd service and timer.

---

## 2. Project Structure

```text
projects/linux/sysmon/
├── sysmon.sh
├── sysmon.conf
├── sysmon.service
├── sysmon.timer
├── README.md
└── examples/
    ├── sample-output.txt
    └── output.json
```

`sysmon.sh` is the main monitoring script. The configuration file, systemd units, README, and sample output support maintainability, automation, and documentation.

---

## 3. Monitoring Architecture

The monitoring workflow follows these stages:

1. **Collect:** Gather metrics from Linux utilities and system interfaces.
2. **Measure:** Obtain CPU, memory, disk, network, process, and log information.
3. **Evaluate:** Compare relevant resource usage against configured thresholds.
4. **Classify:** Report normal, warning, or critical conditions.
5. **Report:** Display timestamped metrics in a readable format.
6. **Automate:** Optionally schedule monitoring through systemd.
7. **Troubleshoot:** Investigate abnormal measurements using appropriate diagnostic tools.

```text
                             sysmon.sh
                                 │
     ┌──────────────┬────────────┼─────────────┬──────────────┐
     ▼              ▼            ▼             ▼              ▼
 CPU Metrics    Memory       Disk Storage   Network Sockets Processes & Logs
 (mpstat, ps)   (free, ps)   (df, iostat)   (ss -ltn)       (ps, journalctl)
     │              │            │             │              │
     └──────────────┴────────────┼─────────────┴──────────────┘
                                 │
                                 ▼
                     Threshold Evaluation Logic
                     (sysmon.conf: WARN / CRIT)
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
          Human Terminal View         Structured JSON
          (Color-coded status)       (--json automation)
```

### Monitoring Modules

| Module | Tools | Purpose |
|---|---|---|
| CPU | `mpstat`, `uptime`, `ps` | Utilization, load averages, CPU-intensive processes |
| Memory | `free`, `ps` | RAM, swap, memory-intensive processes |
| Disk | `df`, `iostat` | Filesystem capacity and I/O performance |
| Network | `ss` | Listening TCP sockets and established connections |
| Processes | `ps`, `/proc` | Process count, zombies, elapsed runtime |
| Journal | `journalctl` | Recent error-priority system logs |

---

## 4. Prerequisites and Installation

The project is intended for Linux systems such as Ubuntu or Debian.

Install the required utilities:

```bash
sudo apt update
sudo apt install sysstat procps iproute2 util-linux
```

Create the project directory:

```bash
mkdir -p ~/projects/linux/sysmon
cd ~/projects/linux/sysmon
```

Make the script executable:

```bash
chmod +x sysmon.sh
```

Validate the Bash syntax:

```bash
bash -n sysmon.sh
```

Execute the script:

```bash
./sysmon.sh
```

---

## 5. CPU Monitoring

### Commands

```bash
uptime
mpstat -P ALL 1 1
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4
```

### Concepts Learned

- CPU utilization indicates how busy a processor is.
- Per-core utilization reveals uneven workloads across CPU cores.
- Load averages represent average system workload over 1, 5, and 15 minutes.
- CPU-intensive processes can help identify resource-heavy applications.
- High load average does not necessarily mean high CPU utilization; tasks waiting for I/O can also contribute to load.

### Thresholds

- Normal: CPU utilization below 70%.
- Warning: CPU utilization at or above 70%.
- Critical: CPU utilization at or above 90%.

These are initial project thresholds and should be adjusted for the workload.

---

## 6. Memory Monitoring

### Commands

```bash
free -h
free -m
ps -eo pid,comm,%mem,rss --sort=-%mem | head -n 4
```

### Concepts Learned

- Total memory represents the system's RAM capacity.
- Available memory estimates how much memory applications can use without significant swapping.
- Swap provides backing storage for memory pages but is much slower than RAM.
- Memory-heavy processes can help identify applications consuming excessive memory.
- Linux uses otherwise idle memory for caching, so low free memory alone does not necessarily indicate a problem.

### Thresholds

- Normal: estimated memory usage below 80%.
- Warning: estimated memory usage at or above 80%.
- Critical: estimated memory usage at or above 95%.

For capacity monitoring, estimate usage from total memory minus available memory rather than total memory minus free memory:
$$\text{Memory Usage \%} = \frac{\text{Total} - \text{Available}}{\text{Total}} \times 100$$

---

## 7. Disk Monitoring

### Commands

```bash
df -h
df -P
iostat -dx 1 2
```

### Concepts Learned

- Filesystem capacity indicates how much storage space is occupied.
- Disk I/O throughput measures the rate of data transferred to and from storage devices.
- High utilization, increased latency, and queueing can indicate storage bottlenecks.
- Disk capacity and disk performance are separate concerns.
- A filesystem can have substantial free space while applications still experience slow disk I/O.

### Thresholds

- Normal: filesystem usage below 80%.
- Warning: filesystem usage at or above 80%.
- Critical: filesystem usage at or above 90%.

The implementation reports read throughput (`rkB/s`) and write throughput (`wkB/s`) as explicitly labelled metrics. `iostat` provides useful device statistics on common sysstat versions.

---

## 8. Network Monitoring

### Commands

```bash
ss -ltn
ss -tn state established
```

Count listening TCP sockets:

```bash
ss -H -ltn | wc -l
```

Count established TCP connections:

```bash
ss -H -tn state established | wc -l
```

### Concepts Learned

- Listening sockets identify services waiting for incoming TCP connections.
- Established connections represent active TCP sessions.
- A listening port does not prove that the application is healthy.
- Socket counts are useful for investigating connection growth and unexpected listeners.
- Network diagnostics should be combined with application health checks when troubleshooting real services.

---

## 9. Process Monitoring

### Commands

```bash
ps -e --no-headers | wc -l
ps -eo stat= | awk '$1 ~ /^Z/ {n++} END {print n+0}'
ps -eo pid,etimes,comm --sort=-etimes | head -n 4
```

### Concepts Learned

- Process count provides a basic view of system workload.
- Zombie processes have terminated but still have process-table entries awaiting collection by their parent.
- A high number of zombies may indicate a parent process that is not reaping children correctly.
- Elapsed runtime measures how long a process has existed, not how much CPU time it has consumed.
- Long-running processes are not automatically unhealthy; interpretation depends on the workload.

---

## 10. Journal Monitoring

### Command

```bash
journalctl -p err -n 5 --no-pager -o short-iso
```

### Concepts Learned

- The systemd journal stores structured system and service logs.
- Journal priority filtering helps identify important errors.
- Recent error-level entries provide context when investigating system problems.
- Journal access depends on user permissions and system configuration.
- No visible log entries does not prove that no errors occurred; access restrictions, retention settings, and logging configuration matter.

The monitor reports journal access failures separately from an empty result.

---

## 11. Threshold Classification

The project uses three monitoring states:

| State | Meaning |
|---|---|
| NORMAL | Resource usage is below the warning threshold |
| WARNING | Resource usage has reached the caution threshold |
| CRITICAL | Resource usage has reached the critical threshold |

Initial configuration (`sysmon.conf`):

```bash
CPU_WARN=70
CPU_CRIT=90

MEM_WARN=80
MEM_CRIT=95

DISK_WARN=80
DISK_CRIT=90
```

Threshold evaluation is consistent across the script. A dedicated configuration file allows these values to be changed without modifying the monitoring logic.

Thresholds indicate resource pressure, not necessarily an application failure.

---

## 12. Testing and Troubleshooting

### Test 1: Syntax Validation

```bash
bash -n sysmon.sh
```

Expected result: no output when the script has valid Bash syntax.

### Test 2: CPU Metrics

```bash
mpstat -P ALL 1 1
uptime
```

Compare the system's reported utilization and load averages with the script's output.

### Test 3: Memory Metrics

```bash
free -h
```

Verify total memory, available memory, and swap values.

### Test 4: Disk Capacity

```bash
df -h
```

Identify filesystems approaching the warning or critical threshold.

### Test 5: Network Sockets

```bash
ss -ltn
ss -tn state established
```

Compare the socket listings with the script's counts.

### Test 6: Process Metrics

```bash
ps -e --no-headers | wc -l
ps -eo stat= | awk '$1 ~ /^Z/ {n++} END {print n+0}'
```

Check whether the process count and zombie count match the monitor.

### Test 7: Journal Access

```bash
journalctl -p err -n 5 --no-pager
```

Verify that the current user has the required journal permissions.

### Troubleshooting Scenarios

**Scenario A: High load average, low CPU utilization**  
Investigate I/O waits, blocked tasks, runnable processes, and whether the load average reflects a previous workload spike.

**Scenario B: High memory utilization**  
Inspect available memory, swap activity, memory pressure, and the largest resident-memory consumers.

**Scenario C: Low disk capacity usage but slow application response**  
Inspect disk I/O latency, throughput, queueing, and application logs.

**Scenario D: Zero listening sockets**  
Verify that the `ss` command succeeded, that the script is counting the intended socket types, and that the environment has the expected services running.

---

## 13. Systemd Automation

A systemd service executes the monitor, while a timer schedules it every five minutes.

### Service: `sysmon.service`

```ini
[Unit]
Description=Linux System Monitor
Documentation=https://github.com/kevinjosh10/1000-days-ai-cloud-infrastructure-journey

[Service]
Type=oneshot
User=root
ExecStart=/bin/bash /opt/sysmon/sysmon.sh
StandardOutput=append:/var/log/sysmon.log
StandardError=append:/var/log/sysmon.log
```

### Timer: `sysmon.timer`

```ini
[Unit]
Description=Run System Monitor Every Five Minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
AccuracySec=30s
Unit=sysmon.service

[Install]
WantedBy=timers.target
```

### Enabling the Timer

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now sysmon.timer
systemctl list-timers sysmon.timer
```

Manual execution and verification:

```bash
sudo systemctl start sysmon.service
sudo systemctl status sysmon.service
sudo tail -n 80 /var/log/sysmon.log
```

---

## 14. Cloud Infrastructure Relevance

This capstone establishes the foundation for Linux observability and infrastructure troubleshooting.

The skills connect to:

- **Cloud infrastructure:** understanding CPU, memory, storage, and network health on Linux instances.
- **SRE:** identifying performance degradation and investigating resource bottlenecks.
- **DevOps:** automating recurring system checks with Bash and systemd.
- **Observability:** transforming raw system measurements into useful monitoring data.
- **Distributed systems:** understanding the resource signals that affect services running across multiple machines.

A possible future architecture is:

```text
Linux VM
   |
   v
sysmon.sh
   |
   v
Structured Metrics and Logs
   |
   v
Monitoring and Visualization
   |
   +----> Prometheus
   +----> Grafana
   +----> AWS CloudWatch
   |
   v
Alerts and Troubleshooting
```

---

## 15. Deliverables Checklist

- [x] Create `sysmon.sh` with full modular architecture.
- [x] Validate Bash syntax with `bash -n`.
- [x] Create `sysmon.conf` with threshold configuration.
- [x] Create `sysmon.service` and `sysmon.timer` systemd definitions.
- [x] Verify CPU and memory calculations (utilization and available RAM ratio).
- [x] Implement disk capacity and `iostat` disk I/O throughput metrics.
- [x] Implement network TCP socket and connection counters via `ss`.
- [x] Implement process inventory, zombie detector, and top elapsed runtime monitor.
- [x] Implement journalctl error log scraper with permission fallback.
- [x] Document installation and usage in `README.md`.
- [x] Save realistic terminal sample output and JSON schema in `examples/`.
- [x] Record known limitations and future cloud observability roadmap.

---

## 16. Month 1 (Linux Mastery) Completion Summary





### Skills Mastered Over 30 Days:
- Linux Filesystem Architecture, Permissions, SUID/SGID, and POSIX ACLs.
- Process Management, Job Control, Signals (`SIGTERM`, `SIGKILL`), and Cgroups.
- Systemd Services, Timers, Journal Logging, and Daemon Recovery.
- User Management, Least-Privilege Sudoers, and Hardened SSH Key Authentication.
- Network Filtering (UFW/Iptables), Packet Inspection (`tcpdump`), and Socket Diagnostics (`ss`).
- Linux Security Auditing (`auditd`), Backups, Compression, and Disaster Recovery.
- In-Depth Resource Profiling: CPU (`mpstat`, load avg), Memory (`free`, PSI, OOM), Disk I/O (`iostat`), Network (`iperf3`).
- Systematic Troubleshooting Methodology, Root Cause Analysis, and Sick Server Diagnostics.
- Comprehensive Observability Automation (`sysmon.sh`, `system_snapshot.sh`, `process_guardian.sh`).



**1000 Days. 2 Hours Daily. One Step Closer to Becoming an AI Cloud Infrastructure Engineer.**

---

## Day 227/1000 — Day 1/28: Mastering Networking
**Date:** October 14, 2026 (Calendar: October 14, 2026 (Wednesday))

---

## 1. Introduction to Networking

Networking allows computers, servers, and applications to communicate with each other.

When we open a website, our computer sends a request through multiple networking layers to reach the destination server. The server processes the request and sends a response back.

Example:

1. Open a browser.
2. Enter `https://example.com`.
3. The computer sends a request through the network.
4. The destination server receives and processes it.
5. The server sends a response.
6. The browser displays the website.

Networking uses layered models to organize this communication.

---

## 2. The OSI Model

The OSI (Open Systems Interconnection) model has seven layers.

| Layer | Name | Function | Examples |
|---|---|---|---|
| 7 | Application | Provides network services to applications | HTTP, DNS, SSH |
| 6 | Presentation | Handles data representation, encoding, and encryption concepts | Data formats, TLS encryption |
| 5 | Session | Conceptually manages communication sessions | Session management, RPC |
| 4 | Transport | Provides end-to-end transport and uses port numbers | TCP, UDP |
| 3 | Network | Handles IP addressing and routing | IPv4, IPv6, routers |
| 2 | Data Link | Transfers frames across a local network | Ethernet, Wi-Fi, MAC addresses |
| 1 | Physical | Transmits raw bits through physical media | Cables, radio waves, fiber |

### Layer 7 — Application
Provides network communication services used by applications.
- HTTP and HTTPS
- DNS
- SSH

### Layer 6 — Presentation
Deals with data formats, encoding, and encryption concepts (e.g., MIME, TLS/SSL formatting).

### Layer 5 — Session
Conceptually establishes, manages, and terminates communication sessions between local and remote applications.

### Layer 4 — Transport
Provides communication between application endpoints.
- **TCP:** Provides reliable, ordered, connection-oriented byte delivery.
- **UDP:** Sends lightweight datagrams without delivery guarantees.
- **Port numbers:** Identify specific application endpoints on a host.

### Layer 3 — Network
Handles logical IP addresses and packet routing between disparate networks.
- A router forwards IP packets toward their destination across network boundaries.

### Layer 2 — Data Link
Transfers frames over a local network link using hardware technologies such as Ethernet and Wi-Fi.
- MAC addresses are used for local link hop-to-hop delivery.

### Layer 1 — Physical
Transmits raw bits using electrical voltages, fiber optics, or radio frequencies.

> [!NOTE]
> The OSI model is a conceptual framework. Real-world Internet protocols do not always fit neatly into a single isolated OSI layer.

---

## 3. OSI Model vs TCP/IP Model

The TCP/IP model is commonly taught using four layers and closely represents real-world Internet networking.

| OSI Model | TCP/IP Model | Examples |
|---|---|---|
| Application (7) | **Application** | HTTP, HTTPS, DNS, SSH |
| Presentation (6) | **Application** | Data representation, encryption concepts |
| Session (5) | **Application** | Session management functionality |
| Transport (4) | **Transport** | TCP, UDP |
| Network (3) | **Internet** | IPv4, IPv6, ICMP |
| Data Link (2) | **Network Access** | Ethernet, Wi-Fi, ARP |
| Physical (1) | **Network Access** | Cables, wireless transceivers |

### Four TCP/IP Layers

1. **Application:** Defines application-level protocols and services.
2. **Transport:** Manages host-to-host communication between application ports.
3. **Internet:** Handles logical IP addressing and packet routing across networks.
4. **Network Access (Link):** Handles communication and physical transmission over the local physical medium.

### 🧠 Mental Model Trick
- **Application:** *What service?* (HTTP/DNS/SSH)
- **Transport:** *Which application endpoint/port?* (Port 443/22)
- **Internet:** *Which destination IP address?* (203.0.113.10)
- **Network Access:** *How is data framed and transmitted over the physical link?* (Ethernet / MAC)

---

## 4. Encapsulation

Encapsulation is the process of adding protocol headers (and trailers) to data as it moves down the protocol stack before transmission.

Suppose a browser sends an HTTP request:

```text
+-------------------------------------------------------+
| Application Data (HTTP GET / HTTP Request Body)       |
+-------------------------------------------------------+
                           ↓  (Transport Layer adds TCP Header)
+------------+------------------------------------------+
| TCP Header | Application Data                         |  = TCP Segment
+------------+------------------------------------------+
                           ↓  (Internet Layer adds IP Header)
+-----------+------------+------------------------------+
| IP Header | TCP Header | Application Data             |  = IP Packet
+-----------+------------+------------------------------+
                           ↓  (Network Access Layer adds Frame Header & Trailer)
+-------------+-----------+------------+------------------+---------------+
| Link Header | IP Header | TCP Header | Application Data | Frame Trailer |  = Link Frame
+-------------+-----------+------------+------------------+---------------+
```

1. **Application Layer:** The browser generates an HTTP GET request payload.
2. **Transport Layer:** TCP prepends a header containing source port, destination port, sequence numbers, and flags.
3. **Internet Layer:** IP prepends an IP header containing source and destination IP addresses, TTL, and protocol ID.
4. **Network Access Layer:** The network interface wraps the packet in a link-layer frame (Ethernet header with source/dest MAC address and an FCS frame check trailer).

---

## 5. Decapsulation

Decapsulation is the reverse process performed by the receiving server:

1. The network interface card (NIC) receives the electrical/optical signal and validates the frame trailer (FCS).
2. It strips the Ethernet link-layer header and passes the IP packet to the OS kernel IP stack.
3. The IP layer inspects the destination IP, strips the IP header, and passes the payload to the transport layer.
4. The transport layer matches the destination port (e.g., 443), strips the TCP header, verifies packet sequence, and delivers the application payload to the listening socket.
5. The web server process receives the clean HTTP request data.

### Key Difference
- **Encapsulation:** Adding protocol headers from high to low layers prior to sending.
- **Decapsulation:** Stripping protocol headers from low to high layers upon receiving.

> [!TIP]
> Routers make forwarding decisions primarily at Layer 3 (Network). They inspect IP headers and do not need to decrypt or parse application payloads (Layer 7).

---

## 6. Understanding Headers & Addressing

Each layer adds metadata critical for delivery:

| Component | Layer | Purpose | Scope |
|---|---|---|---|
| **Port Number** | Layer 4 (Transport) | Identifies process/socket endpoint | Host internal |
| **IP Address** | Layer 3 (Internet) | Identifies global logical interface | End-to-end / Global |
| **MAC Address** | Layer 2 (Data Link) | Identifies physical NIC on local link | Local subnet only (hop-to-hop) |

### Concrete Addressing Example:
- **Client:** `192.168.1.50:54321` (Local IP + Ephemeral Port)
- **Local Router/Gateway MAC:** `00:1A:2B:3C:4D:5E` (Next-hop link address)
- **Destination IP:** `203.0.113.10` (Target Web Server IP)
- **Destination Port:** `443` (Target HTTPS Daemon)

---

## 7. How Cloud Networking (AWS) Maps to Network Layers

Cloud platforms virtualize these exact networking layers:

| Layer | Traditional Concept | AWS Cloud Implementation |
|---|---|---|
| **Layer 7 (Application)** | HTTP, TLS, URLs, APIs | Application Load Balancer (ALB), API Gateway, CloudFront |
| **Layer 4 (Transport)** | TCP/UDP ports, sockets | Security Groups (stateful port rules), Network Load Balancer (NLB) |
| **Layer 3 (Network)** | IP addressing, routing | VPC, Subnets, Route Tables, Internet Gateways (IGW), NAT Gateways |
| **Layer 2 (Data Link)** | Ethernet, MAC, VLANs | Elastic Network Interfaces (ENI), AWS Nitro virtualized overlay (Geneve/VXLAN) |
| **Layer 1 (Physical)** | Cables, switches, transceivers | AWS Global Infrastructure (Managed by AWS) |

### Core AWS Virtual Networking Building Blocks:
- **VPC (Virtual Private Cloud):** Logically isolated software-defined network boundary.
- **Subnet:** Contiguous range of IP addresses locked to a specific Availability Zone.
- **Route Table:** Set of routing rules (`destination -> target`) dictating packet next-hops.
- **Internet Gateway (IGW):** Horizontally scaled, redundant VPC gateway providing 1:1 NAT and internet reachability.
- **Security Group (SG):** Distributed stateful firewall operating at the ENI level (Layer 4).
- **Network ACL (NACL):** Stateless subnet-level firewall operating at packet boundaries (Layer 3/4).

> [!IMPORTANT]
> Merely assigning a public IP to an EC2 instance in a public subnet does **not** make it reachable. Complete reachability requires:
> 1. Valid public IP address.
> 2. Route table containing `0.0.0.0/0 -> igw-xxxx`.
> 3. Security Group allowing inbound traffic on the target port.
> 4. Subnet NACL permitting inbound and ephemeral outbound return traffic.
> 5. An active service listening on `0.0.0.0:<port>` inside the instance OS.

---

## 8. How an HTTPS Request Reaches an AWS EC2 Instance

```text
Browser Client (Laptop)
       │
       ▼ [1. DNS Resolution: Query A record -> returns Public IP]
       │
       ▼ [2. TCP Handshake: SYN -> SYN/ACK -> ACK on Port 443]
       │
       ▼ [3. TLS 1.3 Handshake: Certificate negotiation & key exchange]
       │
       ▼ [4. IP Routing: Packet traverses ISP and AWS Edge Routers]
       │
       ▼ [5. AWS Internet Gateway: Routes packet to target VPC]
       │
       ▼ [6. Subnet NACL: Stateless evaluation (ALLOW Rule)]
       │
       ▼ [7. Security Group: Stateful evaluation (ALLOW Inbound 443)]
       │
       ▼ [8. EC2 Instance OS: Kernel decapsulates Ethernet -> IP -> TCP]
       │
       ▼ [9. Web Server (NGINX/Caddy): Processes HTTP request and serves response]
```

---

## 9. Hands-On Networking Lab (PowerShell)

### Lab 1: Inspect Local Network Interface Configuration
```powershell
ipconfig /all
```
- **Observed:** Local IPv4 address, subnet mask, default gateway, and physical MAC address of the active network interface card.

### Lab 2: Inspect Local IP Routing Table
```powershell
route print -4
```
- **Observed:** Active network destination `0.0.0.0` with netmask `0.0.0.0` pointing to the local default gateway. Confirmed how the kernel resolves the default route when no more specific subnet rule matches.

### Lab 3: Test Layer 3 ICMP Connectivity
```powershell
ping 1.1.1.1 -n 4
```
- **Observed:** 0% packet loss, ~12ms round-trip latency. Validated end-to-end IP reachability.

### Lab 4: Trace Network Hops (Layer 3 Path Discovery)
```powershell
tracert -d -h 10 1.1.1.1
```
- **Observed:** Progressive TTL incrementing showing the default gateway hop, ISP edge hops, and peering handoffs.

### Lab 5: Test Layer 7 Application & TLS Connectivity
```powershell
curl.exe -I https://example.com
```
- **Observed:** `HTTP/2 200 OK`, validated DNS resolution, TCP handshake (443), TLS certificate negotiation, and HTTP header reception.

---

## 10. Systematic Troubleshooting Matrix

| Symptom | Probable Layer | Investigation Checklist |
|---|---|---|
| `Could not resolve host` | **Layer 7 (DNS)** | Check `/etc/resolv.conf`, test `nslookup` / `dig`, check domain DNS records. |
| `Connection timed out` | **Layer 4 / Layer 3** | Security Group blocking port, NACL rule missing, routing table missing default gateway (`0.0.0.0/0`). |
| `Connection refused` | **Layer 4 (Transport)** | Packets reach the host, but no application process is listening on the destination port (`ss -ltn`). |
| `Network is unreachable` | **Layer 3 (Network)** | Missing default gateway or routing table entry on the client/instance. |
| `SSL/TLS handshake failure` | **Layer 6/7 (Crypto)** | Certificate hostname mismatch (SNI), expired certificate, untrusted CA. |
| `HTTP 502 Bad Gateway` | **Layer 7 (Application)** | Load balancer reached target, but target backend application crashed or returned invalid response. |

---

## 11. Knowledge Check & Mastery Verification

1. **Which OSI layer handles IP addressing and routing?**  
   *Answer:* Layer 3 — Network Layer.
2. **What is the main difference between TCP and UDP?**  
   *Answer:* TCP is connection-oriented, guaranteed, and ordered; UDP is connectionless, lightweight, and unordered.
3. **What is encapsulation?**  
   *Answer:* The wrapping of higher-layer data with protocol-specific headers (and trailers) as it moves down the network stack.
4. **What is decapsulation?**  
   *Answer:* The stripping of protocol headers as incoming bits move up the network stack on the receiving host.
5. **How does an IP address differ from a MAC address?**  
   *Answer:* IP addresses are logical, hierarchical, and routable across global networks; MAC addresses are physical hardware identifiers valid only within the local data link layer.
6. **What does a port number identify?**  
   *Answer:* A specific application process/socket endpoint on a host.
7. **Which AWS component determines where matching subnet traffic is routed?**  
   *Answer:* VPC Route Tables.
8. **What is the difference between a Security Group and a Network ACL?**  
   *Answer:* Security Groups are stateful firewalls evaluated at the ENI level; Network ACLs are stateless rules evaluated at the subnet boundary.
9. **Why does assigning a public IP not guarantee that an EC2 instance is reachable?**  
   *Answer:* Internet reachability also requires an Internet Gateway attached to the VPC, a route table pointing `0.0.0.0/0` to the IGW, inbound Security Group rules, and an active listening service.
10. **What is the purpose of `tracert` / `traceroute`?**  
    *Answer:* To identify the hop-by-hop layer 3 path by progressively incrementing IP packet Time-To-Live (TTL) values and listening for ICMP Time Exceeded responses.

---

## 12. Day 227 Deliverables Checklist

- [x] Understand the seven OSI layers and their primary responsibilities.
- [x] Understand the four TCP/IP layers and their mapping to OSI.
- [x] Explain the step-by-step encapsulation and decapsulation pipeline.
- [x] Distinguish IP addresses, MAC addresses, and transport port numbers.
- [x] Execute hands-on network commands (`ipconfig`, `route print`, `ping`, `tracert`).
- [x] Test end-to-end Layer 7 and TLS connectivity using `curl.exe`.
- [x] Map AWS VPC, subnets, route tables, and Security Groups to networking layers.
- [x] Complete the comprehensive knowledge check.

---

## 📌 Day 1 Summary





**Next — Day 2/28: IPv4 Address Structure & Binary Conversion**
- 32-bit addresses, dotted decimal, binary conversion
- Network portion vs host portion
- Fast binary-decimal conversion tricks for subnetting

---
*1000 Days. 2 Hours Daily. One Step Closer to Becoming an AI Cloud Infrastructure Engineer.*

---

## Day 228/1000 — Day 2/28: IPv4 Address Structure & Binary Conversion
**Date:** 15 October 2026 (Calendar: October 15, 2026 (Thursday))

---

## 1. What Is an IPv4 Address?

IPv4 (Internet Protocol Version 4) is a logical addressing system defined in RFC 791 used to identify network interfaces on an IP network.

- **Total Address Size:** 32 bits (4 bytes)
- **Structure:** 4 octets separated by dots (dotted-decimal notation)
- **Bits per Octet:** 8 bits ($2^8 = 256$ possibilities)
- **Range per Octet:** `0` to `255`
- **Total IPv4 Address Space:** $2^{32} = 4,294,967,296$ addresses

Example:
```text
192.168.1.10
 │   │  │ │
 └─┬─┘  │ └─ 4th Octet (Host)
   │    └─── 3rd Octet (Subnet/Host)
   └──────── 1st & 2nd Octets (Network)
```

---

## 2. Binary Representation & Positional Notation

Each octet consists of 8 binary digits (bits). Each position represents a power of 2:

| Bit Position | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Power of 2** | $2^7$ | $2^6$ | $2^5$ | $2^4$ | $2^3$ | $2^2$ | $2^1$ | $2^0$ |
| **Decimal Value** | **128** | **64** | **32** | **16** | **8** | **4** | **2** | **1** |

### Common Octet Patterns:
- `00000000` = $0$
- `00000001` = $1$
- `00001010` = $8 + 2 = 10$
- `11000000` = $128 + 64 = 192$
- `10101000` = $128 + 32 + 8 = 168$
- `11111111` = $128 + 64 + 32 + 16 + 8 + 4 + 2 + 1 = 255$

---

## 3. Decimal to Binary Conversion

To convert a decimal octet into binary, evaluate bit weights from left to right (**128, 64, 32, 16, 8, 4, 2, 1**):
1. If the remainder is $\ge$ bit weight, place a `1` and subtract the weight.
2. Otherwise, place a `0` and move to the next bit.

### Example: Convert `192.168.1.10` to 32-bit Binary

| Octet | Decimal | Calculation | Binary |
|:---:|:---:|---|:---:|
| **1st** | 192 | $192 - 128 = 64$; $64 - 64 = 0$ | `11000000` |
| **2nd** | 168 | $168 - 128 = 40$; $40 - 32 = 8$; $8 - 8 = 0$ | `10101000` |
| **3rd** | 1 | $1 - 1 = 0$ | `00000001` |
| **4th** | 10 | $10 - 8 = 2$; $2 - 2 = 0$ | `00001010` |

Full 32-bit binary stream:
$$\mathbf{11000000.10101000.00000001.00001010}$$

---

## 4. Binary to Decimal Conversion

Sum the weights of all positions set to `1`.

### Example: Convert `11001010` to Decimal

$$\begin{aligned}
1 \times 128 &= 128 \\
1 \times 64  &= 64 \\
0 \times 32  &= 0 \\
0 \times 16  &= 0 \\
1 \times 8   &= 8 \\
0 \times 4   &= 0 \\
1 \times 2   &= 2 \\
0 \times 1   &= 0 \\
\hline
\text{Total} &= 128 + 64 + 8 + 2 = \mathbf{202}
\end{aligned}$$

---

## 5. Network Portion vs Host Portion

An IP address alone does not indicate which network it belongs to. It requires a **Subnet Mask** or **CIDR Prefix** to establish the boundary between the **Network portion** (which routing devices inspect) and the **Host portion** (which identifies the specific device).

```text
IP:          192.168.1.10 /24
Binary IP:   11000000.10101000.00000001 . 00001010
Mask:        11111111.11111111.11111111 . 00000000  (255.255.255.0)
             |←------- Network (24 bits) -------→|← Host (8 bits) →|
```

- **Network Address:** `192.168.1.0` (all host bits set to `0`)
- **Broadcast Address:** `192.168.1.255` (all host bits set to `1`)
- **First Usable Host:** `192.168.1.1`
- **Last Usable Host:** `192.168.1.254`
- **Total Addresses:** $2^8 = 256$
- **Usable IPv4 Hosts:** $2^8 - 2 = 254$ (Standard on-premises)

---

## 6. CIDR Notation (Classless Inter-Domain Routing)

CIDR replaces obsolete Class A, B, and C rules with flexible variable-length prefix masks (`/<n>`), indicating that the first $n$ bits are fixed for the network.

$$\text{Total Addresses} = 2^{(32 - \text{Prefix Length})}$$
$$\text{Host Bits} = 32 - \text{Prefix Length}$$

| CIDR Prefix | Subnet Mask | Network Bits | Host Bits | Total Addresses | Usable (Standard) | Usable in AWS Subnet |
|:---:|---|:---:|:---:|:---:|:---:|:---:|
| **/8** | `255.0.0.0` | 8 | 24 | 16,777,216 | 16,777,214 | *VPC level only* |
| **/16** | `255.255.0.0` | 16 | 16 | 65,536 | 65,534 | 65,531 |
| **/24** | `255.255.255.0` | 24 | 8 | 256 | 254 | **251** |
| **/26** | `255.255.255.192` | 26 | 6 | 64 | 62 | **59** |
| **/27** | `255.255.255.224` | 27 | 5 | 32 | 30 | **27** |
| **/28** | `255.255.255.240` | 28 | 4 | 16 | 14 | **11** (Min AWS Subnet) |
| **/32** | `255.255.255.255` | 32 | 0 | 1 | 1 (Single Host) | N/A (Route target only) |

---

## 7. IPv4 & CIDR in Cloud Infrastructure (AWS)

In cloud environments like AWS, IP address allocation is strictly controlled via software-defined VPC CIDR blocks:

### Cloud VPC Hierarchy Example:
```text
VPC CIDR: 10.0.0.0/16 (65,536 Total IPs)
 ├── us-east-1a Public Subnet:   10.0.1.0/24  (251 usable) -> Connected to IGW
 ├── us-east-1b Public Subnet:   10.0.2.0/24  (251 usable) -> Connected to IGW
 ├── us-east-1a Private Subnet:  10.0.10.0/24 (251 usable) -> App Layer (NAT GW egress)
 ├── us-east-1b Private Subnet:  10.0.20.0/24 (251 usable) -> App Layer (NAT GW egress)
 ├── us-east-1a DB Subnet:       10.0.30.0/24 (251 usable) -> Isolated RDS
 └── us-east-1b DB Subnet:       10.0.40.0/24 (251 usable) -> Isolated RDS
```

### ⚠️ AWS Subnet Reserved IP Addresses
Unlike standard on-premises subnets that reserve only 2 addresses (Network `.0` and Broadcast `.255`), **AWS reserves 5 IP addresses per subnet**:
1. `10.0.1.0`: Network address.
2. `10.0.1.1`: Reserved by AWS for the VPC router.
3. `10.0.1.2`: Reserved by AWS for the DNS resolver (VPC base $+ 2$).
4. `10.0.1.3`: Reserved by AWS for future use.
5. `10.0.1.255`: Network broadcast address (AWS does not support broadcast, but reserves the address).

$$\text{Usable Hosts in AWS Subnet} = 2^{(32 - \text{prefix})} - 5$$

---

## 8. Practical Exercises & Step-by-Step Solutions

### Exercise 1: Convert `172.16.5.20` to Binary
- `172` = $128 + 32 + 8 + 4$ $\rightarrow$ `10101100`
- `16`  = $16$ $\rightarrow$ `00010000`
- `5`   = $4 + 1$ $\rightarrow$ `00000101`
- `20`  = $16 + 4$ $\rightarrow$ `00010100`
- **Result:** `10101100.00010000.00000101.00010100`

### Exercise 2: Find the Subnet Mask for `/24`
- 24 network bits set to `1`, followed by 8 host bits set to `0`:
  `11111111.11111111.11111111.00000000`
- **Result:** `255.255.255.0`

### Exercise 3: Calculate the Network Address of `172.16.5.20/24`
- The `/24` prefix covers the first 3 octets (`172.16.5`).
- Setting all 8 host bits in the 4th octet to `0`:
- **Network Address:** `172.16.5.0`
- **Broadcast Address:** `172.16.5.255`
- **Usable Host Range:** `172.16.5.1` – `172.16.5.254`

### Exercise 4: Calculate the Total Number of Addresses in a `/26` Subnet
- Host bits $h = 32 - 26 = 6$
- $\text{Total Addresses} = 2^6 = \mathbf{64}$
- Standard Usable Hosts: $64 - 2 = \mathbf{62}$
- AWS Usable Hosts: $64 - 5 = \mathbf{59}$

### Exercise 5: Explain Why CIDR Is Critical in AWS VPC Networking
1. **Prevents Routing Overlaps:** Non-overlapping CIDR blocks are an absolute requirement for VPC Peering, AWS Transit Gateway, and Hybrid DirectConnect / VPN connections.
2. **High Availability Across AZs:** CIDRs allow structured subnet allocation across multiple Availability Zones to support Multi-AZ RDS and auto-scaled container workloads.
3. **Least-Privilege Security Boundaries:** Slicing VPC CIDRs into distinct public, private, and database tiers enables strict Security Group and Network ACL boundary controls.
4. **IP Exhaustion Prevention:** Planning prefix sizing based on projected Elastic Network Interface (ENI) density (Kubernetes pods, Lambda VPC interfaces, ALBs) prevents disastrous IP exhaustion.

---

## 9. Key Takeaways

- IPv4 is a 32-bit logical addressing scheme divided into four 8-bit octets ($0$–$255$).
- Positional binary weights ($128, 64, 32, 16, 8, 4, 2, 1$) enable fast mental conversions.
- The CIDR prefix determines the exact bit boundary between network routing and host identification.
- Standard subnets reserve 2 addresses ($2^h - 2$); AWS subnets reserve 5 addresses ($2^h - 5$).
- Precise CIDR address planning prevents overlapping IP conflicts in multi-VPC and hybrid cloud architectures.

---

## 10. Deliverables Checklist

- [x] Master 32-bit IPv4 structure and dotted-decimal formatting.
- [x] Perform bidirectional binary $\leftrightarrow$ decimal conversions using bit positional weights.
- [x] Distinguish network vs. host portions given any IP and prefix length.
- [x] Compute total and usable host capacities using $2^{(32 - \text{prefix})}$.
- [x] Memorize AWS 5-reserved-IP rules per subnet.
- [x] Complete practical exercises with verified binary calculations.

---

---

## Day 229/1000 — Day 3/28: Special and Reserved IPv4 Address Ranges
**Date:** 16 October 2026 (Calendar: October 16, 2026 (Friday))

---

## 1. Introduction

IPv4 addresses are 32-bit logical addresses represented in dotted-decimal format (`192.168.1.10`).

Not every IPv4 address is routable over the public internet. The Internet Engineering Task Force (IETF) and IANA have designated several address blocks for specialized purposes: private enterprise networks, local host loops, carrier-grade translation, link-local failovers, multicast streaming, and technical documentation.

Understanding these reserved ranges is vital for architecting AWS Virtual Private Clouds (VPCs), troubleshooting routing failures, and preventing critical cloud security vulnerabilities.

---

## 2. Private IPv4 Ranges — RFC 1918

Private IPv4 addresses are reserved strictly for internal enterprise, home, and cloud networks. They are **non-routable** on the public internet; border routers immediately drop packets destined for or originating from these addresses unless translated via Network Address Translation (NAT).

```text
               RFC 1918 Address Space
 ┌──────────────────────────────────────────────────┐
 │ Class A: 10.0.0.0/8      (16,777,216 addresses)  │
 ├──────────────────────────────────────────────────┤
 │ Class B: 172.16.0.0/12   (1,048,576 addresses)   │
 ├──────────────────────────────────────────────────┤
 │ Class C: 192.168.0.0/16  (65,536 addresses)      │
 └──────────────────────────────────────────────────┘
```

### 1. 10.0.0.0/8 (Large Networks & Cloud VPCs)
- **Range:** `10.0.0.0` to `10.255.255.255`
- **Total Addresses:** $2^{24} = 16,777,216$
- **Primary Use:** Default choice for enterprise architectures, Kubernetes cluster CIDRs, and AWS VPCs (e.g., `10.0.0.0/16`).

### 2. 172.16.0.0/12 (Segmented & Medium Networks)
- **Range:** `172.16.0.0` to `172.31.255.255`
- **Total Addresses:** $2^{20} = 1,048,576$
- **Bit Boundary:** The second octet binary ranges from `00010000` (16) to `00011111` (31).
- **Common Pitfall:** `172.32.0.0` and above are **public** IP addresses, NOT private.

### 3. 192.168.0.0/16 (Small Networks & Home Routers)
- **Range:** `192.168.0.0` to `192.168.255.255`
- **Total Addresses:** $2^{16} = 65,536$
- **Primary Use:** Home Wi-Fi routers, small office LANs, and localized test environments.

### RFC 1918 Classification Verification:
| IP Address | Status | Rationale |
|---|:---:|---|
| `10.20.30.40` | **Private** | Falls squarely inside `10.0.0.0/8` |
| `172.20.5.10` | **Private** | Second octet $20 \in [16, 31]$ (`172.16.0.0/12`) |
| `172.32.5.10` | **PUBLIC** | Second octet $32 > 31$; globally routable public address |
| `192.168.1.50` | **Private** | Falls inside `192.168.0.0/16` |
| `192.169.1.50` | **PUBLIC** | Second octet $169 \ne 168$; owned by public internet registries |

> [!TIP]
> **Cloud Engineering Rule:** When creating AWS VPCs that connect via AWS Direct Connect or Site-to-Site VPN to an on-premises data center, choose a CIDR from `10.0.0.0/8` that does not overlap with any existing corporate branch or data center subnet.

---

## 3. Carrier-Grade NAT (CGNAT) — RFC 6598 (100.64.0.0/10)

- **Range:** `100.64.0.0` to `100.127.255.255`
- **Total Addresses:** $2^{22} = 4,194,304$
- **Purpose:** Shared Address Space for ISPs.

Because of IPv4 exhaustion, ISPs deploy Carrier-Grade NAT (Large-Scale NAT) between customer premises equipment (CPE) and the public internet.

```text
Customer LAN           Customer WAN          ISP CGNAT Pool          Public Internet
192.168.1.100  ──►  100.72.10.5 (CPE)  ──►  ISP NAT Gateways  ──►  203.0.113.1 (Public)
```

**Why not use RFC 1918?** If an ISP assigned `192.168.1.1` to a customer's WAN interface, it would cause severe routing conflicts with the customer's internal home LAN (`192.168.1.0/24`). `100.64.0.0/10` guarantees zero collision with private internal networks.

---

## 4. Loopback Block — 127.0.0.0/8

- **Range:** `127.0.0.0` to `127.255.255.255`
- **Standard Address:** `127.0.0.1` (`localhost`)
- **Scope:** Host internal only.

Packets sent to `127.0.0.1` never leave the operating system's network stack; they are short-circuited directly from output queues to input queues via the `lo` virtual loopback interface.

```bash
# Verify loopback interface on Linux
ip addr show lo
```

### Security Implications for Cloud Daemons:
- **Binding to `127.0.0.1`:** Only processes on the exact same host can connect. External network interfaces cannot reach it. (Ideal for local Redis caches, HashiCorp Vault agents, internal microservice IPC).
- **Binding to `0.0.0.0`:** Listens on *all* network interfaces (loopback, private ENI, public IP), exposing the port to network traffic unless blocked by Security Groups.

---

## 5. Link-Local Addressing — RFC 3927 (169.254.0.0/16) & AWS IMDS

- **Range:** `169.254.0.0` to `169.254.255.255`
- **Purpose:** Automatic Private IP Addressing (APIPA).
- **Behavior:** Unroutable across routers; strictly confined to the local layer-2 segment.

When an OS is configured for DHCP but receives no response, it automatically self-assigns an address from this block.

---

### 🛡️ The Most Famous Link-Local IP: AWS IMDS (`169.254.169.254`)

In AWS, `169.254.169.254` is the **Instance Metadata Service (IMDS)** HTTP endpoint provided by the hypervisor to every EC2 instance. It exposes instance identity, AMI ID, security groups, user data, and IAM role temporary credentials.

```text
EC2 Instance (OS) ───────── HTTP GET ─────────► AWS Hypervisor (169.254.169.254)
                                                 Returns: IAM Role Credentials
```

### IMDSv1 vs IMDSv2 Security Architecture:
- **IMDSv1 (Insecure):** Simple `GET` request. Vulnerable to **Server-Side Request Forgery (SSRF)** attacks where an attacker tricks a web app into fetching `http://169.254.169.254/latest/meta-data/iam/security-credentials/`.
- **IMDSv2 (Defensive):** Session-oriented token authorization. Requires a `PUT` request with an explicit TTL header to fetch a secret session token first.

```bash
# Step 1: Request a secure session token (TTL: 6 hours)
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Step 2: Fetch metadata using the session token header
curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

> [!WARNING]
> **Cloud Security Mandate:** Always enforce IMDSv2 across all AWS launch templates and EC2 instances (`HttpTokens=required`, `HttpPutResponseHopLimit=1`) to prevent container breakout and SSRF credential theft.

---

## 6. Multicast Block — 224.0.0.0/4 (Class D)

- **Range:** `224.0.0.0` to `239.255.255.255`
- **Purpose:** Delivering packets simultaneously to a group of interested receivers without duplicate sender transmissions.

### Delivery Models:
1. **Unicast (One-to-One):** Standard web and SSH traffic.
2. **Broadcast (One-to-All):** ARP requests (`255.255.255.255` or subnet broadcast).
3. **Multicast (One-to-Many):** Routing updates, video streams, cluster heartbeats.

### Key Multicast Reservations:
- `224.0.0.1`: All systems on the local subnet.
- `224.0.0.2`: All routers on the local subnet.
- `224.0.0.5`: OSPF router hello packets.
- `239.0.0.0/8`: Administratively scoped (private internal multicast).

*Note: Native multicast is disabled in standard AWS VPCs; AWS Transit Gateway Multicast is required for cloud multicast architectures.*

---

## 7. Master Reserved Address Reference Table

| CIDR Prefix | RFC / Standard | Designation & Scope | Routable on Internet? |
|---|---|---|:---:|
| `0.0.0.0/8` | RFC 1122 | "This host on this network" (source only during DHCP) | No |
| `0.0.0.0/0` | System Route | Default route wildcard | Internal only |
| `10.0.0.0/8` | RFC 1918 | Private Enterprise Network (Class A) | No |
| `100.64.0.0/10` | RFC 6598 | Carrier-Grade NAT (Shared Address Space) | No |
| `127.0.0.0/8` | RFC 1122 | Loopback (`127.0.0.1` localhost) | No |
| `169.254.0.0/16` | RFC 3927 | Link-Local (APIPA & AWS IMDS `169.254.169.254`) | No |
| `172.16.0.0/12` | RFC 1918 | Private Enterprise Network (Class B) | No |
| `192.0.2.0/24` | RFC 5737 | TEST-NET-1 (Documentation & Examples) | No |
| `192.168.0.0/16` | RFC 1918 | Private Home/LAN Network (Class C) | No |
| `198.51.100.0/24` | RFC 5737 | TEST-NET-2 (Documentation & Examples) | No |
| `203.0.113.0/24` | RFC 5737 | TEST-NET-3 (Documentation & Examples) | No |
| `224.0.0.0/4` | RFC 5771 | Multicast (Class D) | No |
| `240.0.0.0/4` | RFC 1112 | Reserved for Future Use (Class E) | No |
| `255.255.255.255/32` | RFC 919 | Limited Broadcast (Local subnet only) | No |

---

## 8. Hands-On Linux Networking Lab

### Lab A: Inspect Assigned IPv4 Addresses
```bash
ip -4 addr show
```
- Observed `lo` interface assigned `127.0.0.1/8` and `eth0` assigned an RFC 1918 or link-local address.

### Lab B: Inspect Kernel Routing Tables
```bash
ip route
```
- Analyzed the default gateway (`default via ... dev ...`) and local subnet scope rules.

### Lab C: Test Loopback Isolation & Verification
```bash
ping -c 4 127.0.0.1
getent hosts localhost
```
- Verified that DNS/hosts resolution resolves `localhost` to `127.0.0.1` and round-trip time is sub-millisecond ($< 0.05\text{ms}$).

### Lab D: Compare Route Decisions for Loopback vs Public IP
```bash
ip route get 127.0.0.1
ip route get 8.8.8.8
```
- `ip route get 127.0.0.1` displays `local 127.0.0.1 dev lo src 127.0.0.1`.
- `ip route get 8.8.8.8` displays the next-hop router and physical/virtual network interface (`eth0`).

---

## 9. Comprehensive Self-Assessment & Verified Solutions

1. **What are the three RFC 1918 private IPv4 ranges?**  
   *Answer:* `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`.
2. **Why is `172.32.1.1` outside the RFC 1918 private range?**  
   *Answer:* The private block `172.16.0.0/12` stops at `172.31.255.255`. The second octet 32 is beyond the 12-bit prefix boundary (`00010000`–`00011111`), making it a public IP.
3. **What is the difference between private addressing and CGNAT?**  
   *Answer:* Private addressing (RFC 1918) is used inside customer LANs and VPCs. CGNAT (`100.64.0.0/10`) is shared provider space assigned to customer WAN routers to avoid colliding with internal customer RFC 1918 subnets.
4. **What does `127.0.0.1` represent?**  
   *Answer:* The IPv4 loopback address pointing directly to the local host operating system network stack.
5. **Why might a Linux application bind to `127.0.0.1`?**  
   *Answer:* To ensure that the listening daemon is accessible only to local processes on the same machine, completely shielding it from external network probing.
6. **What is the purpose of link-local addressing?**  
   *Answer:* To allow devices on the same physical or virtual link to communicate without requiring manual IP configuration or a functional DHCP server (`169.254.0.0/16`).
7. **What is special about `169.254.169.254` on EC2?**  
   *Answer:* It is the AWS Instance Metadata Service (IMDS) link-local API endpoint providing instance configuration and temporary IAM role credentials.
8. **What is the difference between unicast, broadcast, and multicast?**  
   *Answer:* Unicast delivers to one destination; broadcast delivers to all devices on the local subnet; multicast delivers to a specific subscribed group of listeners.
9. **What does `0.0.0.0/0` represent in a routing table?**  
   *Answer:* The default route (route of last resort), matching any IP destination that lacks a more specific route entry.
10. **Why is metadata protection important in cloud infrastructure?**  
    *Answer:* Because the IMDS endpoint yields IAM credentials. Enforcing IMDSv2 prevents SSRF vulnerabilities from leaking cloud credentials to remote attackers.

---

## 10. Key Takeaways

- RFC 1918 addresses (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) are non-routable on the public internet and form the bedrock of cloud VPC design.
- CGNAT (`100.64.0.0/10`) is reserved for service providers to prevent dual-NAT collisions with customer private subnets.
- Binding to `127.0.0.1` provides strict host-level isolation, while binding to `0.0.0.0` opens listening sockets to all interfaces.
- The link-local address `169.254.169.254` provides critical AWS EC2 metadata; enforcing IMDSv2 is mandatory for cloud defense against SSRF.
- Documentation IP ranges (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`) should always be used in public architecture diagrams and documentation.

---

## 11. Deliverables Checklist

- [x] Memorized all three RFC 1918 private IPv4 ranges.
- [x] Understood CGNAT (`100.64.0.0/10`) purpose and architecture.
- [x] Tested loopback connectivity and route lookup using Linux CLI (`ip route get`).
- [x] Inspected network interfaces and analyzed local vs default routes.
- [x] Mastered link-local addressing and AWS EC2 IMDSv2 security mechanisms.
- [x] Understood multicast ranges and broadcast limitations in cloud environments.
- [x] Solved and verified all 10 self-assessment questions.

---

---

## Day 230/1000 — Day 4/28: CIDR Notation and Prefix Math
**Date:** October 17, 2026 (Calendar: October 17, 2026 (Saturday))

---

## Objective

Understand CIDR notation, subnet masks, IP address ranges, network and broadcast addresses, usable host calculations, and cloud-provider IP reservations.

---

## 1. What Is CIDR?

CIDR stands for **Classless Inter-Domain Routing**. It represents an IP network using an IP address followed by a prefix length.

Example: `192.168.1.0/24`

- IPv4 addresses contain 32 bits.
- `/24` means 24 bits identify the network.
- The remaining 8 bits are available for host addresses.

Examples:

- `/8` — 8 network bits and 24 host bits.
- `/16` — 16 network bits and 16 host bits.
- `/24` — 24 network bits and 8 host bits.
- `/26` — 26 network bits and 6 host bits.
- `/30` — 30 network bits and 2 host bits.

> [!NOTE]
> **Important:** A larger prefix length means a smaller subnet and fewer total IP addresses.

---

## 2. CIDR and Subnet Masks

| CIDR | Subnet Mask | Total Addresses |
|---|---|---:|
| /8 | 255.0.0.0 | 16,777,216 |
| /16 | 255.255.0.0 | 65,536 |
| /20 | 255.255.240.0 | 4,096 |
| /24 | 255.255.255.0 | 256 |
| /25 | 255.255.255.128 | 128 |
| /26 | 255.255.255.192 | 64 |
| /27 | 255.255.255.224 | 32 |
| /28 | 255.255.255.240 | 16 |
| /30 | 255.255.255.252 | 4 |

---

## 3. Host Count Formula

IPv4 contains 32 bits.

$$\text{Host bits } (h) = 32 - \text{Prefix length}$$
$$\text{Total addresses} = 2^{(32 - \text{Prefix length})}$$
$$\text{Conventional usable hosts} = 2^{(32 - \text{Prefix length})} - 2$$

The minus-two rule accounts for the network and broadcast addresses in a conventional IPv4 subnet.

### Example: 192.168.1.0/26

- Host bits = $32 - 26 = 6$
- Total addresses = $2^6 = 64$
- Conventional usable hosts = $64 - 2 = 62$

Cloud providers reserve additional addresses, so actual capacity differs.

---

## 4. Calculating Network and Broadcast Addresses

Example: `192.168.10.70/26`

**Step 1: Find the subnet mask**  
`255.255.255.192`

**Step 2: Calculate the block size**  
$$\text{Block size} = 256 - 192 = 64$$

**Step 3: Identify the subnet ranges**  
- `192.168.10.0` – `192.168.10.63`
- `192.168.10.64` – `192.168.10.127`
- `192.168.10.128` – `192.168.10.191`
- `192.168.10.192` – `192.168.10.255`

The IP `192.168.10.70` belongs to the second subnet.


- **First usable host:** `192.168.10.65`
- **Last usable host:** `192.168.10.126`
- **Broadcast address:** `192.168.10.127`
- **Total addresses:** 64
- **Conventional usable hosts:** 62

### Common Block Sizes

| CIDR | Block Size |
|---|---:|
| /24 | 256 |
| /25 | 128 |
| /26 | 64 |
| /27 | 32 |
| /28 | 16 |
| /29 | 8 |
| /30 | 4 |

For the common subnet masks shown above, calculate the block size using $256 - \text{final subnet-mask octet}$.

Find the multiple of the block size that contains the given IP address. This identifies the network address. The address immediately before the next block is the broadcast address.

---

## 5. Cloud Provider IP Reservations

Cloud providers reserve addresses for internal platform services, routing, and DNS resolution.

| Cloud Provider | Reserved IPv4 Addresses | Usable Addresses in /24 |
|---|---:|---:|
| AWS VPC | 5 | 251 |
| Microsoft Azure VNet | 5 | 251 |
| Google Cloud VPC | 4 | 252 |

### AWS
AWS reserves the first four addresses and the last address in each IPv4 subnet:
1. `x.x.x.0`: Network address.
2. `x.x.x.1`: Reserved by AWS for the VPC router.
3. `x.x.x.2`: Reserved by AWS for DNS (AmazonProvidedDNS: VPC base $+ 2$).
4. `x.x.x.3`: Reserved by AWS for future use.
5. `x.x.x.255`: Subnet broadcast address.

### Azure
Azure reserves the first four addresses and the last address in each IPv4 subnet:
1. `x.x.x.0`: Network address.
2. `x.x.x.1`: Default gateway address.
3. `x.x.x.2`: Primary Azure DNS IP mapping.
4. `x.x.x.3`: Secondary Azure DNS IP mapping.
5. `x.x.x.255`: Subnet broadcast address.

### Google Cloud (GCP)
Google Cloud reserves the first two and last two addresses in a primary IPv4 subnet range:
1. `x.x.x.0`: Network address.
2. `x.x.x.1`: Subnet default gateway.
3. `x.x.x.254`: Reserved by GCP for future use (second-to-last IP).
4. `x.x.x.255`: Broadcast address.

### Example: A /26 Cloud Subnet
Total addresses = 64.

- **AWS usable addresses:** $64 - 5 = 59$
- **Azure usable addresses:** $64 - 5 = 59$
- **Google Cloud usable addresses:** $64 - 4 = 60$

> [!IMPORTANT]
> **Key lesson:** The mathematical address count does not equal the number of addresses available to cloud resources. Always check the provider's documentation and account for additional requirements from services such as load balancers, container ENIs (EKS), and Lambda functions.

Official documentation:
- **AWS:** [Subnet Sizing Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html)
- **Azure:** [IP Address Planning Guide](https://learn.microsoft.com/en-us/azure/networking/design-guide/ip-planning)
- **Google Cloud:** [VPC Subnets Overview](https://docs.cloud.google.com/vpc/docs/subnets)

---

## 6. Practical Cloud Networking Example

Consider an AWS VPC with the CIDR range `10.0.0.0/16`.

It contains 65,536 total IPv4 addresses.

Example subnet design:

| Subnet | CIDR | Purpose | Total IPs | AWS Usable IPs |
|---|---|---|:---:|:---:|
| Public Subnet 1 | `10.0.1.0/24` | Load balancer and public-facing resources (AZ 1) | 256 | 251 |
| Public Subnet 2 | `10.0.2.0/24` | High availability across Availability Zones (AZ 2) | 256 | 251 |
| Private Subnet 1 | `10.0.3.0/24` | Application servers (AZ 1) | 256 | 251 |
| Private Subnet 2 | `10.0.4.0/24` | Application servers (AZ 2) | 256 | 251 |

Benefits:
- Separates public and private workloads.
- Makes routing and security policies easier to manage.
- Provides room for future growth.
- Supports high availability across Availability Zones.
- Helps prevent overlapping IP address ranges.

*Note: These are illustrative subnet allocations. Production designs should also consider route tables, security groups, network ACLs, NAT requirements, and the needs of individual services.*

---

## 7. Hands-On Practice & Step-by-Step Solutions

### Task 1: Calculate a /27 Subnet



- **Block size:** $2^5 = 32$ (Mask octet: $256 - 32 = 224$)
- **Subnet mask:** `255.255.255.224`
- **Total addresses:** $2^5 = 32$
- **Network address:** `192.168.5.64`
- **Broadcast address:** `192.168.5.95` ($64 + 32 - 1$)
- **First usable address:** `192.168.5.65`
- **Last usable address:** `192.168.5.94`
- **Conventional usable host count:** $32 - 2 = 30$

---

### Task 2: Calculate a /26 Subnet



- **Block size:** $2^6 = 64$. Multiples: `0, 64, 128, 192`
- `150` lies between `128` and `192`.
- **Subnet containing IP:** `10.0.0.128/26`
- **Network address:** `10.0.0.128`
- **Broadcast address:** `10.0.0.191` ($128 + 64 - 1$)
- **First usable address:** `10.0.0.129`
- **Last usable address:** `10.0.0.190`
- **Conventional usable hosts:** $64 - 2 = 62$
- **AWS usable hosts:** $64 - 5 = 59$

---

### Task 3: Design an AWS VPC


| Subnet Name | CIDR | Network Address | Broadcast Address | Usable Range | AWS Usable IPs |
|---|---|---|---|---|:---:|
| **Public-1 (AZ-A)** | `10.0.1.0/24` | `10.0.1.0` | `10.0.1.255` | `10.0.1.4` – `10.0.1.254` | **251** |
| **Public-2 (AZ-B)** | `10.0.2.0/24` | `10.0.2.0` | `10.0.2.255` | `10.0.2.4` – `10.0.2.254` | **251** |
| **Private-1 (AZ-A)** | `10.0.3.0/24` | `10.0.3.0` | `10.0.3.255` | `10.0.3.4` – `10.0.3.254` | **251** |
| **Private-2 (AZ-B)** | `10.0.4.0/24` | `10.0.4.0` | `10.0.4.255` | `10.0.4.4` – `10.0.4.254` | **251** |

---

### Task 4: Understand Cloud Reservations




AWS reserves an additional **3 IP addresses** in every subnet for its underlying VPC virtualization and managed infrastructure services:
1. `x.x.x.1`: Bound to the virtual VPC router/gateway.
2. `x.x.x.2`: Bound to AmazonProvidedDNS (the internal VPC resolver).
3. `x.x.x.3`: Reserved by AWS for internal future feature expansion.

Therefore:
$$\text{AWS Usable Hosts} = 256 - 5 = \mathbf{251}$$

---

## 8. Key Takeaways

- CIDR specifies how many bits identify the network.
- IPv4 addresses contain 32 bits.
- Host bits = $32 - \text{prefix length}$.
- Total addresses = $2^{(32 - \text{prefix length})}$.
- Conventional usable hosts = $\text{total addresses} - 2$.
- The subnet mask identifies the network and host portions.
- Block size helps determine network and broadcast addresses.
- Cloud providers reserve additional IP addresses.
- AWS and Azure reserve five IPv4 addresses per subnet; Google Cloud reserves four in a primary IPv4 subnet range.
- Proper CIDR planning is essential for AWS VPCs, Azure VNets, Kubernetes networking, and distributed systems.

---

## 9. Completion Checklist

- [x] Understand CIDR notation and prefix length.
- [x] Memorize common subnet masks and block size conversions.
- [x] Calculate total addresses using prefix math ($2^h$).
- [x] Find network and broadcast addresses using block size multiples.
- [x] Calculate conventional usable host ranges ($2^h - 2$).
- [x] Understand AWS, Azure, and Google Cloud IP reservations.
- [x] Design a basic VPC subnet layout across Availability Zones.
- [x] Documented today's learning in GitHub.

---

## Day 230 Summary

**Day 230/1000 completed — Day 4/28 of mastering networking.**

Today's focus was CIDR notation, subnet masks, prefix calculations, IP address ranges, and cloud-provider address reservations.

These concepts form the foundation for designing reliable cloud networks, planning subnet capacity, and building scalable cloud infrastructure.

---

## Day 231/1000 — Day 5/28: Subnetting by Hand & Route Aggregation
**Date:** 18 October 2026 (Calendar: October 18, 2026 (Sunday))

---

## 🎯 Today's Objective

Learn to subnet IPv4 networks by hand and aggregate routes like a cloud infrastructure engineer.

By the end of today, I should be able to:

* Understand how borrowing bits creates subnets
* Use the block size shortcut (`256 minus the mask octet`) for rapid mental subnetting
* Split any CIDR block into $N$ equal subnets
* Calculate network boundaries, broadcast addresses, and usable host ranges
* Understand Route Aggregation (Supernetting / CIDR summarization)
* Optimize routing tables in cloud VPCs, Transit Gateways, and BGP sessions using summary routes
* Build a reusable subnetting and summarization script (`subnet_calc.sh`)

---

# 1. Why Subnet by Hand?

In cloud infrastructure engineering, subnets are not configured randomly. Every AWS VPC, Azure VNet, GCP VPC, and Kubernetes cluster relies on structured address boundaries.

Engineers must calculate subnets by hand to:

* Split VPC CIDR blocks into tiers (Public, Private, Database, Transit) across Availability Zones.
* Avoid CIDR overlaps when interconnecting multiple accounts, VPCs, and on-premises data centers.
* Prevent routing table explosion using route summarization.
* Troubleshoot Terraform and cloud networking misconfigurations during live outages without relying on web calculators.

---

# 2. The Mechanics of Borrowing Bits

Subnetting works by **borrowing bits** from the host portion of an IP address and assigning them to the network portion.

```text
Original Address (/24):
[ 24 Network Bits ] [ 8 Host Bits ]

Borrow 2 Bits for Subnets (/26):
[ 24 Network Bits ] [ 2 Subnet Bits ] [ 6 Host Bits ]
```

### The Two Golden Formulas

1. **Number of Subnets Created:**
   $$\text{Subnets Created} = 2^s$$
   *(where $s$ is the number of bits borrowed from the host portion)*

2. **Total Addresses per Subnet:**
   $$\text{Total Addresses per Subnet} = 2^h$$
   *(where $h$ is the number of remaining host bits, $h = 32 - \text{new prefix}$)*

3. **Usable Hosts per Subnet:**
   * Traditional On-Prem: $2^h - 2$
   * AWS VPC: $2^h - 5$
   * Azure VNet: $2^h - 5$
   * GCP VPC: $2^h - 4$

---

# 3. Visualizing Bit Borrowing

Suppose we start with a `/24` network (`256` total addresses) and borrow bits from the 4th octet:

```text
Prefix | Bits Borrowed (s) | Host Bits (h) | Subnets Created (2^s) | IPs per Subnet (2^h)
-------+-------------------+---------------+-----------------------+---------------------
/24    | 0                 | 8             | 1                     | 256
/25    | 1                 | 7             | 2                     | 128
/26    | 2                 | 6             | 4                     | 64
/27    | 3                 | 5             | 8                     | 32
/28    | 4                 | 4             | 16                    | 16
/29    | 5                 | 3             | 32                    | 8
/30    | 6                 | 2             | 64                    | 4
```

Notice the inverse relationship:
* Every bit borrowed **doubles** the number of subnets.
* Every bit borrowed **halves** the number of IP addresses per subnet.

---

# 4. The Block Size Shortcut (Magic Number)

The fastest mental technique for subnetting without writing out 32 binary bits is the **Block Size Shortcut**:

```text
Block Size = 256 - Mask Octet Value
```

The **block size** tells you the exact increment between consecutive subnet network addresses.

### Steps to Find Any Subnet Boundary:
1. Determine which octet is changing (the "interesting octet").
2. Find the subnet mask value for that octet.
3. Compute $\text{Block Size} = 256 - \text{Mask Value}$.
4. Start at $0$, and count up by multiples of the block size ($0, \text{Block}, 2\times\text{Block}, \dots$).

---

# 5. The 8 Magic Numbers & Block Sizes

Memorize this single 8-value table:

| Bits in Octet | Binary Value | Mask Octet | Block Size ($256 - \text{Mask}$) |
|:---:|:---:|:---:|:---:|
| 1 | `10000000` | **128** | **128** |
| 2 | `11000000` | **192** | **64** |
| 3 | `11100000` | **224** | **32** |
| 4 | `11110000` | **240** | **16** |
| 5 | `11111000` | **248** | **8** |
| 6 | `11111100` | **252** | **4** |
| 7 | `11111110` | **254** | **2** |
| 8 | `11111111` | **255** | **1** |

---

# 6. Splitting a Block into $N$ Equal Subnets

To divide an existing IP block into $N$ equal subnets:

1. Find the smallest power of 2 greater than or equal to $N$:
   $$2^s \ge N$$
2. Add $s$ to the existing prefix length:
   $$\text{New Prefix} = \text{Old Prefix} + s$$
3. Calculate the block size in the interesting octet.
4. List the starting network addresses incrementing by the block size.

---

# 7. Walkthrough 1: Splitting `/24` into 4 Equal Subnets



### Step 1: Calculate Bits Needed
$$2^s = 4 \implies s = 2 \text{ bits}$$
$$\text{New Prefix} = 24 + 2 = \mathbf{/26}$$

### Step 2: Determine Subnet Mask & Block Size
* Host bits remaining: $32 - 26 = 6$ bits.
* 2 bits in 4th octet = `11000000` = `192`.
* Mask: `255.255.255.192`.
* $\text{Block Size} = 256 - 192 = \mathbf{64}$.

### Step 3: Map the 4 Subnets

| Subnet | Network Address | Usable Host Range | Broadcast Address | Total IPs | AWS Usable |
|:---:|---|---|---|:---:|:---:|
| **Subnet 1** | `192.168.1.0/26` | `192.168.1.1` – `192.168.1.62` | `192.168.1.63` | 64 | 59 |
| **Subnet 2** | `192.168.1.64/26` | `192.168.1.65` – `192.168.1.126` | `192.168.1.127` | 64 | 59 |
| **Subnet 3** | `192.168.1.128/26` | `192.168.1.129` – `192.168.1.190` | `192.168.1.191` | 64 | 59 |
| **Subnet 4** | `192.168.1.192/26` | `192.168.1.193` – `192.168.1.254` | `192.168.1.255` | 64 | 59 |

---

# 8. Walkthrough 2: Splitting `/24` into 8 Equal Subnets



### Step 1: Calculate Bits Needed
$$2^s = 8 \implies s = 3 \text{ bits}$$
$$\text{New Prefix} = 24 + 3 = \mathbf{/27}$$

### Step 2: Determine Subnet Mask & Block Size
* 3 bits in 4th octet = `11100000` = `224`.
* Mask: `255.255.255.224`.
* $\text{Block Size} = 256 - 224 = \mathbf{32}$.

### Step 3: Map the 8 Subnets

```text
Subnet 1: 10.0.50.0/27    (Range: .1  - .30,  Broadcast: .31)
Subnet 2: 10.0.50.32/27   (Range: .33 - .62,  Broadcast: .63)
Subnet 3: 10.0.50.64/27   (Range: .65 - .94,  Broadcast: .95)
Subnet 4: 10.0.50.96/27   (Range: .97 - .126, Broadcast: .127)
Subnet 5: 10.0.50.128/27  (Range: .129 - .158, Broadcast: .159)
Subnet 6: 10.0.50.160/27  (Range: .161 - .190, Broadcast: .191)
Subnet 7: 10.0.50.192/27  (Range: .193 - .222, Broadcast: .223)
Subnet 8: 10.0.50.224/27  (Range: .225 - .254, Broadcast: .255)
```

Each subnet provides $32$ total addresses, $30$ conventional usable hosts, and $27$ AWS-usable hosts.

---

# 9. Subnetting Across Octet Boundaries (Splitting `/16`)

In cloud engineering, you often split a large `/16` VPC block into smaller `/20` or `/24` subnets.

### Example: Splitting `10.0.0.0/16` into `/20` Subnets
* Old prefix: `/16`. New prefix: `/20`.
* Bits borrowed: $20 - 16 = 4$ bits.
* Number of subnets: $2^4 = 16$ subnets.
* The interesting octet is the **3rd octet** ($20 = 16 + 4$).
* 4 bits in 3rd octet = `11110000` = `240`.
* $\text{Block Size} = 256 - 240 = \mathbf{16}$.

The subnets increment by 16 in the 3rd octet:
1. `10.0.0.0/20` (`10.0.0.0` – `10.0.15.255`)
2. `10.0.16.0/20` (`10.0.16.0` – `10.0.31.255`)
3. `10.0.32.0/20` (`10.0.32.0` – `10.0.47.255`)
4. `10.0.48.0/20` (`10.0.48.0` – `10.0.63.255`)
... up to `10.0.240.0/20`.

Each `/20` subnet contains $2^{12} = 4,096$ IP addresses.

---

# 10. The Subnet Tree Diagram

```text
                             10.0.0.0/24 (256 IPs)
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼                                       ▼
          10.0.0.0/25 (128 IPs)                   10.0.0.128/25 (128 IPs)
                 │                                       │
         ┌───────┴───────┐                       ┌───────┴───────┐
         ▼               ▼                       ▼               ▼
   10.0.0.0/26    10.0.0.64/26            10.0.0.128/26   10.0.0.192/26
     (64 IPs)        (64 IPs)                (64 IPs)        (64 IPs)
```

---

# 11. What Is Route Aggregation (Supernetting)?

**Route Aggregation** (also called **Route Summarization** or **Supernetting**) is the process of combining multiple contiguous, smaller network prefixes into a single, shorter CIDR prefix.

```text
Multiple Specific Routes                Single Aggregate Route
10.0.0.0/24 ───┐
10.0.1.0/24 ───┼────────────────────►   10.0.0.0/22
10.0.2.0/24 ───┤
10.0.3.0/24 ───┘
```

Instead of advertising 4 separate routes to routers, a cloud gateway advertises **one** summary route.

---

# 12. Why Route Aggregation Matters in Cloud Infrastructure

Route aggregation is a critical skill for senior cloud and network engineers:

### 1. Hard Quotas on Cloud Route Tables
* AWS VPC Route Tables have a default quota of **50 routes** (can be raised to a maximum of only **100 routes**).
* If you connect 80 subnets individually without summarization, your route table will hit its quota and drop new routes.
* AWS Transit Gateway (TGW) and Direct Connect route tables also enforce strict route quotas.

### 2. Reducing Router CPU & Memory Overhead
* Routers must evaluate route tables on every packet using **Longest Prefix Match (LPM)**.
* Smaller routing tables mean faster lookups and lower hardware memory (TCAM) usage.

### 3. Stability and Isolating Route Flaps
* If a single subnet in an on-premises branch goes down, a specific route would cause global BGP reconvergence across your cloud connections.
* With route summarization, individual link flaps inside the summarized block remain invisible to the rest of the network.

---

# 13. How to Aggregate Routes by Hand

To summarize multiple networks into one CIDR prefix:

1. List the networks in order.
2. Check that the number of networks is a power of 2 ($2, 4, 8, 16, \dots$).
3. Convert the differing octet to binary.
4. Count the number of common matching bits from left to right.
5. The number of matching bits becomes the new prefix length.
6. The network address uses the matching bits with all remaining bits set to `0`.

---

# 14. Walkthrough 3: Aggregating 4 Contiguous `/24` Subnets


* `10.0.1.0/24`
* `10.0.2.0/24`
* `10.0.3.0/24`

### Step 1: Examine the Differing 3rd Octet in Binary

```text
Subnet          3rd Octet Decimal   3rd Octet Binary
10.0.0.0/24     0                   0 0 0 0 0 0 | 0 0
10.0.1.0/24     1                   0 0 0 0 0 0 | 0 1
10.0.2.0/24     2                   0 0 0 0 0 0 | 1 0
10.0.3.0/24     3                   0 0 0 0 0 0 | 1 1
                                    ▲ ▲ ▲ ▲ ▲ ▲
                                    6 Common Bits
```

### Step 2: Calculate New Prefix Length
* The first two octets (`10.0`) match completely = $16$ bits.
* The 3rd octet shares the first **6 bits** (`000000`).
* Total matching bits = $16 + 6 = \mathbf{22}$ bits.

### Step 3: Write the Summary Route
$$\mathbf{10.0.0.0/22}$$


* Range: `10.0.0.0` through `10.0.3.255`.
* It perfectly encapsulates all 4 subnets with zero wasted or unallocated subnets!

---

# 15. The Danger of "Over-Summarization"

What happens if you try to summarize `10.0.1.0/24` and `10.0.2.0/24` alone?

```text
10.0.1.0/24 -> 00000001
10.0.2.0/24 -> 00000010
```

Notice they share only the first 5 bits (`00000`). The common mask would be `/21` (block size 8: `10.0.0.0/21`).  
This summary would cover `10.0.0.0` through `10.0.7.255`.

> [!WARNING]
> If `10.0.4.0/24` belongs to a different office, your summary route will accidentally "blackhole" or misroute traffic meant for the other office. Routes must start on proper binary boundaries and cover the exact power-of-two block.

---

# 16. Cloud Architecture: Transit Gateway Route Summarization

```text
       Spoke VPC A               Spoke VPC B
     [ 10.100.0.0/24 ]         [ 10.100.1.0/24 ]
            │                         │
            └───────────┬─────────────┘
                        ▼
             AWS Transit Gateway (TGW)
            ┌─────────────────────────┐
            │ Advertises:             │
            │ 10.100.0.0/22           │  ◄── Single Summary Route
            └───────────┬─────────────┘
                        │ (BGP over Direct Connect)
                        ▼
             On-Premises Data Center
              Corporate Core Router
        (Route table only needs 1 entry!)
```

---

# 17. Hands-On Script: `subnet_calc.sh`

Create a lightweight, standalone Bash subnetting calculator:

```bash
cat << 'EOF' > subnet_calc.sh
#!/usr/bin/env bash
# subnet_calc.sh - Simple Subnet & Block Size Calculator
set -euo pipefail

usage() {
    echo "Usage: $0 <IP> <PREFIX>"
    echo "Example: $0 192.168.1.75 26"
    exit 1
}

[[ $# -ne 2 ]] && usage

IP="$1"
PREFIX="$2"

IFS='.' read -r o1 o2 o3 o4 <<< "$IP"

if (( PREFIX >= 24 && PREFIX <= 30 )); then
    host_bits=$(( 32 - PREFIX ))
    total_ips=$(( 2 ** host_bits ))
    block_size=$total_ips
    mask_octet=$(( 256 - block_size ))
    
    net_o4=$(( (o4 / block_size) * block_size ))
    bcast_o4=$(( net_o4 + block_size - 1 ))
    first_o4=$(( net_o4 + 1 ))
    last_o4=$(( bcast_o4 - 1 ))
    
    echo "=========================================="
    echo "       SUBNET CALCULATION REPORT"
    echo "=========================================="
    echo "Input IP / Prefix:     ${IP}/${PREFIX}"
    echo "Subnet Mask:           255.255.255.${mask_octet}"
    echo "Block Size:            ${block_size}"
    echo "Total IP Addresses:    ${total_ips}"
    echo "Network Address:       ${o1}.${o2}.${o3}.${net_o4}"
    echo "Broadcast Address:     ${o1}.${o2}.${o3}.${bcast_o4}"
    echo "Usable Host Range:     ${o1}.${o2}.${o3}.${first_o4} - ${o1}.${o2}.${o3}.${last_o4}"
    echo "On-Prem Usable Hosts:  $(( total_ips - 2 ))"
    echo "AWS Usable Hosts:      $(( total_ips - 5 ))"
    echo "=========================================="
else
    echo "This quick script demonstrates 4th octet subnetting (/24 to /30)."
fi
EOF
chmod +x subnet_calc.sh
```

### Test Run:
```bash
./subnet_calc.sh 192.168.1.75 26
```

---

# 18. Subnetting & Summarization Workflow

```text
Subnetting Decision
       │
       ▼
How many subnets / hosts needed?
       │
       ├── Splitting a Block?
       │       │
       │       ▼
       │   Find 2^s >= N  ──► New Prefix = Old Prefix + s
       │       │
       │       ▼
       │   Block Size = 256 - Mask Octet
       │       │
       │       ▼
       │   Count by Block Size from 0
       │
       └── Aggregating Routes?
               │
               ▼
           Must be power of 2 contiguous blocks
               │
               ▼
           Convert differing octet to binary
               │
               ▼
           Count matching bits ──► New Shortened Prefix
```

---

# 19. Cloud Infrastructure Connection

```text
Bit Borrowing & Subnetting
           │
           ▼
     AWS VPC Sizing
  (Public / Private / DB)
           │
           ▼
Transit Gateway Route Tables
           │
           ▼
   Route Summarization
(Avoids 50-route AWS limits)
           │
           ▼
Kubernetes Pod CIDRs & IPAM
           │
           ▼
Production Resilience & Scale
```

---

# 20. Self-Assessment Practice Problems

### Problem 1
You have `172.16.10.0/24`. You need to create 8 equal subnets for a container platform.
* What is the new prefix?
* What is the block size?
* What is the 3rd subnet's network address?


* Block size: $256 - 224 = \mathbf{32}$.
* Subnets: `.0/27`, `.32/27`, `.64/27` $\rightarrow$ 3rd subnet: $\mathbf{172.16.10.64/27}$.

### Problem 2
Summarize the following 4 routes into a single CIDR block:
* `192.168.16.0/24`
* `192.168.17.0/24`
* `192.168.18.0/24`
* `192.168.19.0/24`


  - 16: `00010000`
  - 17: `00010001`
  - 18: `00010010`
  - 19: `00010011`
* Common matching bits: First 6 bits (`000100`).
* Summary Prefix: $16 + 6 = \mathbf{/22}$.
* Summary Route: $\mathbf{192.168.16.0/22}$.

---

# 21. Completion Checklist

- [x] Mastered bit borrowing mechanics ($2^s$ subnets, $2^h$ hosts).
- [x] Applied the Block Size shortcut ($256 - \text{mask}$) for mental calculations.
- [x] Split `/24` networks into 4 (`/26`) and 8 (`/27`) equal subnets.
- [x] Subnetted across octet boundaries (splitting `/16` into `/20`s).
- [x] Understood Route Aggregation / Supernetting principles.
- [x] Calculated route summaries using binary common-prefix matching.
- [x] Analyzed cloud route table quotas and BGP flap prevention.
- [x] Built and verified `subnet_calc.sh`.
- [x] Solved all self-assessment problems.

---

# 🔥 Day 5 Key Takeaway

> **"Subnetting is not just about carving IP spaces; it's about structuring address boundaries so that routing tables remain minimal, scalable, and non-overlapping across cloud VPCs, transit hubs, and on-premises networks."**


**Day 5 / 28 — Networking Mastery**  
**Day 231 / 1000 — AI Cloud Infrastructure Engineer**  

**1000 Days. 2 Hours Daily.**

---

