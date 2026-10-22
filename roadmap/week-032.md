# Week 32 Roadmap: Linux Performance Profiling, Observability & Troubleshooting

## 📅 Timeline: Days 218 - 224 (October 5, 2026 – October 11, 2026)

---

## Day 218 — Day 22 / 30 — CPU Monitoring & Profiling
- **Date:** 2026-10-05 (Calendar: October 5, 2026 (Monday))
- **1000-Day Journey:** Day 218 / 1000
- **Linux Journey:** Day 22 / 30
- **Duration:** 2.5–3 Hours
- **Focus:** CPU Monitoring, Load Average & Performance Profiling

### Objective & Goals
Learn how to monitor Linux CPU performance, understand load average, identify CPU bottlenecks, distinguish CPU-bound workloads from I/O-bound workloads, and build a reusable CPU profiling script.

By the end of today, I should be able to investigate:

> **"Why is this Linux server slow?"**

using real CPU and process metrics.

---

---

## Day 219 — Day 23 — Memory Monitoring & Management
- **Date:** October 6, 2026 (Tuesday) [Inferred chronologically]
- **Linux Mastery:** Day 23 / 30
- **AI Cloud Infrastructure Journey:** Day 219 / 1000
- **Theme:** Memory Monitoring, Pressure, Swap & OOM Troubleshooting

### Objective & Goals
Learn to diagnose Linux memory problems like a cloud infrastructure engineer.

By the end of today, I should be able to:

* Understand RSS, VSZ and shared memory
* Read `free` and `vmstat`
* Identify memory-hungry processes
* Understand swap and swap pressure
* Understand the Linux OOM killer
* Monitor memory pressure using PSI
* Inspect OOM events
* Simulate controlled memory pressure
* Build a reusable `mem_profiler.sh`

---

---

## Day 220 — Day 24 / 30 — Disk I/O Monitoring
- **Date:** October 7, 2026 (Wednesday) [Inferred chronologically]
- **Linux Mastery:** Day 24 / 30
- **1000-Day Journey:** Day 220 / 1000
- **Duration:** 2.5–3 Hours
- **Focus:** Disk I/O Monitoring, Performance Analysis & Troubleshooting

### Objective & Goals
Understand how Linux handles disk I/O and learn how to monitor:

- IOPS
- Disk throughput
- I/O latency
- Queue depth
- Read/write operations
- I/O request merging
- Disk utilization
- I/O schedulers
- Processes generating heavy disk I/O

Build a `disk_profiler.sh` script to identify disk activity and heavy I/O processes.

---

---

## Day 221 — Day 25/30 — Network Performance & Debugging
- **Date:** 2026-10-08 (Calendar: October 8, 2026 (Thursday))
- **1000-Day Journey:** Day 221/1000
- **Track:** Mastering Linux
- **Duration:** 2.5 Hours
- **Focus:** Network Performance, TCP Connections & Network Debugging
- **Next:** Day 26 — Advanced Networking / Network Security & Troubleshooting

### Objective & Goals
Learn how to monitor, diagnose, and troubleshoot Linux network performance.

By the end of today, I should be able to:

* Understand bandwidth, latency, packet loss, and retransmissions
* Monitor TCP/UDP sockets using `ss`
* Understand TCP connection states
* Diagnose DNS problems
* Test network connectivity
* Trace network routes
* Capture network packets using `tcpdump`
* Measure bandwidth using `iperf3`
* Build a basic Linux network profiling tool

---

---

## Day 222 — Day 26/30 — Logs & Journalctl Mastery
- **Date:** October 9, 2026 (Calendar: October 9, 2026 (Friday))
- **Day:** 222/1000
- **Linux Mastery:** Day 26/30
- **Duration:** 2.5 Hours
- **Focus:** Linux Logging, systemd Journal, Troubleshooting & Log Automation
- **Why logs matter:** * Diagnose application failures.
- **Key components:** * `systemd-journald`: Collects and stores journal records.
- **Use case:** Investigate a service failure that occurred before a server reboot.
- **Important:** Priority filters include the selected priority and more severe priorities. For example, `-p err` includes priorities 0 through 3.
- **Production caution:** Check retention requirements before deleting archived logs. Important incident evidence may be required for security investigations or compliance.
- **Script limitations:** This is a basic investigation tool. It counts journal records rather than unique incidents, relies on journal access permissions, and does not automatically diagnose root causes.
- **File:** `log_investigator.sh`
- **Skills demonstrated:** * Linux system troubleshooting
- **Today's engineering principle:** > Don't just restart a failed service. Find the evidence, establish the timeline, identify the root cause, and verify the fix.
- **Progress:** Day 222/1000 — 22.2% of the 1000-day journey
- **Linux Mastery:** Day 26/30 — Logs & Journalctl Mastery
- **Next:** Day 27/30 — Continue Linux mastery and operational troubleshooting.

### Objective & Goals
Master Linux logging using `journalctl` and `systemd-journald`. Learn to filter logs by service, boot, time, priority, and executable. Understand journal storage, log retention, and disk usage.

Build `log_investigator.sh`, an automated log investigation tool that accepts a service name and time window, extracts relevant logs, counts errors, and summarizes the results.

---

---

## Day 223/1000 — System Snapshot & Comprehensive Monitoring
- **Date:** October 10, 2026 (Calendar: October 10, 2026 (Saturday))
- **Linux Mastery:** Day 27/30
- **Duration:** 2.5 hours
- **Focus:** Linux observability, system health monitoring, automated snapshots
- **Progress:** Day 223/1000 — Building toward AI Cloud Infrastructure Engineering by 2030.
- **Linux Mastery:** Day 27/30 Complete.

### Objective & Goals
Build a reusable Linux monitoring tool that captures CPU, memory, disk, network, and process information and supports periodic collection and historical analysis.

---

---

## Day 224/1000 — Troubleshooting Methodology & Case Studies
- **Date:** October 11, 2026 (Calendar: October 11, 2026 (Sunday))
- **Journey:** 1000 Days Towards Becoming a Cloud Infrastructure Engineer
- **Day:** 224/1000
- **Linux Track:** Day 28/30
- **Duration:** 3 Hours
- **Focus:** Systematic Troubleshooting, Root Cause Analysis, Linux Performance Debugging
- **Primary Tools:** `vmstat`, `iostat`, `pidstat`, `strace`, `lsof`, `perf`, `ss`, `top`
- **Key principle:** A restart may restore service temporarily, but it does not necessarily identify or fix the underlying problem.
- **ESTABLISHED:** A TCP connection is established.
- **TIME_WAIT:** An endpoint waits for a period after connection termination to help prevent delayed packets from interfering with subsequent connections.
- **LISTEN:** A socket is waiting for incoming connections.
- **Problem:** The application cannot write its logs.
- **Why 1:** The file write failed.
- **Why 2:** The filesystem has no available space.
- **Why 3:** A log file grew unusually large.
- **Why 4:** The application repeatedly logged the same exception.
- **Why 5:** A recent deployment introduced an exception loop without effective alerting.
- **File:** `troubleshooting_playbook.md`
- **Progress:** Day 224/1000 — 22.4% of the 1000-day journey.
- **Next:** Day 225/1000 — Continue the final stages of the 30-day Linux mastery track.

### Objective & Goals
By the end of this session, I should be able to:

- Apply a structured troubleshooting methodology.
- Distinguish symptoms from root causes.
- Diagnose high system load with low CPU utilization.
- Investigate file-write failures using Linux permissions and system calls.
- Understand TCP `TIME_WAIT` connections.
- Identify processes consuming excessive CPU.
- Investigate application latency when infrastructure metrics appear healthy.
- Use `strace`, `lsof`, and `perf` for troubleshooting.
- Apply the Five Whys technique for root cause analysis.
- Document incidents in a professional troubleshooting playbook.

---

---

