# Week 33 Roadmap: Linux Capstone & Networking Mastery Foundations

## 📅 Timeline: Days 225 - 231 (October 12, 2026 – October 18, 2026)

---

## Day 225 — Day 29 — Integration & Practice: Sick Server Diagnosis
- **Date:** 12 October 2026 (Calendar: October 12, 2026 (Monday))
- **Journey:** Day 225/1000 — Becoming a Cloud Infrastructure Engineer
- **Linux Track:** Day 29/30 — Mastering Linux
- **Duration:** 3 Hours
- **Focus:** Linux Monitoring, System Troubleshooting, Root Cause Analysis
- **Important principle:** A symptom is not necessarily the root cause. High CPU utilization is a symptom; a runaway process consuming CPU may be the root cause.
- **Incident:** Controlled Linux server performance degradation.
- **Environment:** Linux lab VM.
- **Workload:** Time-limited stress test.
- **Symptoms observed:** High CPU / Memory / IO wait under controlled load.
- **Primary bottleneck:** Resource exhaustion simulated via `stress-ng`.

### Objective & Goals
By the end of this lab, I will be able to:

- Integrate Linux monitoring tools to investigate a sick server.
- Interpret `vmstat`, `iostat`, `ss`, `top`, and `free` output.
- Identify CPU, memory, disk, and network bottlenecks.
- Find resource-intensive processes and inspect their open files.
- Distinguish symptoms from root causes.
- Create a structured incident diagnosis report.
- Verify whether the system recovers after the workload stops.

---

---

## Day 226/1000 — Linux Day 30/30: Production System Monitor
- **Date:** October 13, 2026 (Calendar: October 13, 2026 (Tuesday))
- **Duration:** 3–4 Hours
- **Focus:** Linux System Monitoring, Bash Scripting, Observability, Troubleshooting
- **Milestone:** Completion of Month 1 — Linux Mastery (30/30 Days)
- **Journey:** 1000 Days. 2 Hours Daily.
- **Goal:** Become an AI Cloud Infrastructure Engineer by 2030.
- **Linux Milestone:** 30/30 Days Completed (100% of Month 1).
- **Overall Journey Progress:** Day 226 / 1000 Days.
- **Primary Project:** Production System Monitor — `sysmon.sh`.
- **Key Takeaway:** Monitoring is not simply collecting numbers. Reliable infrastructure monitoring requires accurate measurements, meaningful thresholds, defensive error handling, timestamps, and the ability to investigate abnormal conditions.

### Objective & Goals
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

---

## Day 227/1000 — Day 1/28: Mastering Networking
- **Date:** October 14, 2026 (Calendar: October 14, 2026 (Wednesday))
- **Duration:** 2 Hours
- **Focus:** Network Layers and Encapsulation
- **Track:** Month 2 — Networking for Cloud Infrastructure Engineers (Day 1 / 28)
- **Journey:** Day 227 / 1000 — Becoming an AI Cloud Infrastructure Engineer
- **Objective:** Understand the OSI and TCP/IP models, encapsulation, decapsulation, and how networking layers map to AWS cloud infrastructure.
- **Core Concept:** Network communication is structured as a layered pipeline. Application data is encapsulated into a transport segment, then into an IP packet, and finally into a data link frame. The receiving system strips these headers in reverse order.
- **Cloud Engineering Takeaway:** Virtual cloud networks in AWS/GCP/Azure directly implement these foundational layers. Isolating connectivity issues to the correct layer (DNS vs Routing vs Security Groups vs Application Listener) is the hallmark of a senior infrastructure engineer.

---

## Day 228/1000 — Day 2/28: IPv4 Address Structure & Binary Conversion
- **Date:** 15 October 2026 (Calendar: October 15, 2026 (Thursday))
- **Duration:** 2 Hours
- **Focus:** IPv4 Addressing, Binary Conversion & CIDR Foundations
- **Track:** Month 2 — Networking for Cloud Infrastructure Engineers (Day 2 / 28)
- **Journey:** Day 228 / 1000 — Becoming an AI Cloud Infrastructure Engineer
- **Objective:** Master 32-bit IPv4 structure, perform rapid decimal-to-binary conversions, distinguish network vs. host boundaries, and understand CIDR prefix allocation in AWS VPC design.
- **Next:** Day 3/28 — Special and Reserved Address Ranges (RFC 1918, CGNAT, 169.254 Link-Local & AWS IMDS)
- **Journey Progress:** Day 228 / 1000 — 1000 Days. 2 Hours Daily. One Step Closer to Becoming an AI Cloud Infrastructure Engineer.

---

## Day 229/1000 — Day 3/28: Special and Reserved IPv4 Address Ranges
- **Date:** 16 October 2026 (Calendar: October 16, 2026 (Friday))
- **Duration:** 2 Hours
- **Focus:** Private IPs, CGNAT, Loopback, Link-Local, Multicast and Reserved Addresses
- **Track:** Month 2 — Networking for Cloud Infrastructure Engineers (Day 3 / 28)
- **Journey:** Day 229 / 1000 — Becoming an AI Cloud Infrastructure Engineer
- **Objective:** Master special and reserved IPv4 address blocks (RFC 1918, RFC 6598 CGNAT, RFC 3927 Link-Local, 127.0.0.0/8 Loopback, Multicast), explore AWS EC2 IMDSv2 security, and execute Linux route inspection labs.
- **Next:** Day 4/28 — CIDR Notation and Prefix Math (Calculating Network, Broadcast & Host Counts)
- **Journey Progress:** Day 229 / 1000 — 1000 Days. 2 Hours Daily. One Step Closer to Becoming an AI Cloud Infrastructure Engineer.

---

## Day 230/1000 — Day 4/28: CIDR Notation and Prefix Math
- **Date:** October 17, 2026 (Calendar: October 17, 2026 (Saturday))
- **Duration:** 2 Hours
- **Main Focus:** Networking Fundamentals — CIDR and Subnetting
- **Track:** Month 2 — Networking for Cloud Infrastructure Engineers (Day 4 / 28)
- **Journey:** Mastering Networking to Become a Cloud Infrastructure Engineer (Day 230 / 1000)
- **Results:** - **Network address:** `192.168.10.64`
- **Given:** `192.168.5.64/27`
- **Calculations:** - **Host bits ($h$):** $32 - 27 = 5$ bits
- **Given:** `10.0.0.150/26`
- **Calculations:** - **Host bits ($h$):** $32 - 26 = 6$ bits
- **Given:** VPC `10.0.0.0/16` with two public `/24` subnets and two private `/24` subnets:
- **Question:** Explain why a `/24` subnet provides 251 usable IPv4 addresses in AWS rather than the conventional 254.
- **Answer:** Conventional IPv4 subnets reserve only 2 addresses: the network identifier (`.0`) and the broadcast address (`.255`).
- **Next:** Day 5/28 — Subnetting by Hand and Route Aggregation (Supernetting).
- **Journey Motto:** 1000 Days. 2 Hours Daily. Building Toward AI Cloud Infrastructure Engineering.

### Objective & Goals
Understand CIDR notation, subnet masks, IP address ranges, network and broadcast addresses, usable host calculations, and cloud-provider IP reservations.

---

---

## Day 231/1000 — Day 5/28: Subnetting by Hand & Route Aggregation
- **Date:** 18 October 2026 (Calendar: October 18, 2026 (Sunday))
- **Duration:** 2 Hours
- **Networking Mastery:** Day 5 / 28
- **AI Cloud Infrastructure Journey:** Day 231 / 1000
- **Theme:** Borrowing Bits, Block Size Shortcuts, Equal Subnet Splitting & Supernetting
- **Goal:** Divide `192.168.1.0/24` into 4 equal subnets.
- **Goal:** Divide `10.0.50.0/24` into 8 equal subnets for a microservice mesh.
- **Given Routes:** * `10.0.0.0/24`
- **Verification:** * A `/22` has a block size of $4$ in the 3rd octet ($256 - 252 = 4$).
- **Solution:** * $2^s = 8 \implies s = 3 \implies 24 + 3 = \mathbf{/27}$.
- **Solution:** * 3rd octets in binary:

### Objective & Goals
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

---

