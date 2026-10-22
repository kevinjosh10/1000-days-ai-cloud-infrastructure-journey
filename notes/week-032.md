# Week 32 Notes: Linux Performance Profiling, Observability & Troubleshooting

## 📅 Timeline: Days 218 - 224 (October 5, 2026 – October 11, 2026)

---

## Day 218 — Day 22 / 30 — CPU Monitoring & Profiling
**Date:** 2026-10-05 (Calendar: October 5, 2026 (Monday))

---

## 🎯 Objective

Learn how to monitor Linux CPU performance, understand load average, identify CPU bottlenecks, distinguish CPU-bound workloads from I/O-bound workloads, and build a reusable CPU profiling script.

By the end of today, I should be able to investigate:

> **"Why is this Linux server slow?"**

using real CPU and process metrics.

---

# 📚 Theory

## 1. CPU Performance Metrics

Important CPU metrics:

| Metric                   | Meaning                                   |
| ------------------------ | ----------------------------------------- |
| CPU Utilization          | Percentage of CPU being used              |
| User CPU (`us`)          | CPU used by applications                  |
| System CPU (`sy`)        | CPU used by the Linux kernel              |
| Idle (`id`)              | CPU doing nothing                         |
| I/O Wait (`wa`)          | CPU waiting for I/O                       |
| Steal (`st`)             | CPU time taken by a hypervisor            |
| Context Switches (`cs`)  | Switching CPU execution between processes |
| Runnable Processes (`r`) | Processes ready to execute                |
| Blocked Processes (`b`)  | Processes waiting, often for I/O          |

---

# 2. CPU Utilization

Use:

```bash
vmstat 1
```

Important columns:

```text
us   sy   id   wa   st
```

Example:

```text
us  sy  id  wa
70  10  15   5
```

Interpretation:

* `us = 70%` → applications are consuming CPU
* `sy = 10%` → kernel is consuming CPU
* `id = 15%` → CPU is idle
* `wa = 5%` → CPU is waiting for I/O

A high CPU utilization does not automatically mean the application is the problem.

Always investigate where the CPU time is going.

---

# 3. Load Average

Check:

```bash
uptime
```

Example:

```text
load average: 1.20, 0.85, 0.60
```

These represent:

```text
1 minute
5 minutes
15 minutes
```

Load average represents work that is waiting to run or is in certain uninterruptible states.

It is **not the same as CPU percentage**.

---

## Load Average and CPU Count

Check CPU count:

```bash
nproc
```

Example:

```text
4
```

If the system has 4 CPUs:

```text
Load = 1
CPU  = 4
```

There is roughly one CPU's worth of demand.

If:

```text
Load = 8
CPU  = 4
```

there may be significant contention.

However, load must be combined with other metrics such as CPU utilization and I/O wait.

---

# 4. Runnable vs Blocked Processes

Use:

```bash
vmstat 1
```

Look at:

```text
r
b
```

### `r` — Runnable

Processes that are ready to run.

High `r` values relative to CPU count can indicate CPU contention.

### `b` — Blocked

Processes waiting in an uninterruptible state, commonly due to I/O.

Example:

```text
r = 10
b = 0
```

Potential CPU pressure.

Example:

```text
r = 1
b = 20
```

Potential I/O-related pressure.

---

# 5. CPU Information

Check detailed CPU information:

```bash
lscpu
```

Useful information includes:

```text
Architecture
CPU(s)
Thread(s) per core
Core(s) per socket
Socket(s)
Model name
```

Check the number of logical CPUs:

```bash
nproc
```

---

# 6. `vmstat`

Run:

```bash
vmstat 1
```

This continuously reports system statistics every second.

Run a fixed number of samples:

```bash
vmstat 1 10
```

Meaning:

```text
1 second interval
10 samples
```

Important sections:

```text
procs
memory
swap
io
system
cpu
```

CPU fields:

```text
us
sy
id
wa
st
```

---

# 7. `mpstat`

Install `sysstat` if required:

```bash
sudo apt update
sudo apt install sysstat
```

Run:

```bash
mpstat 1
```

For individual CPU cores:

```bash
mpstat -P ALL 1
```

This helps identify CPU imbalance.

Example:

```text
CPU    %usr   %sys   %idle
all    20.0    5.0    75.0
0      10.0    5.0    85.0
1      40.0    5.0    85.0
2      15.0    5.0    80.0
3      15.0    5.0    80.0
```

CPU 1 is significantly busier than the other CPUs.

---

# 8. `top`

Run:

```bash
top
```

Look at:

```text
%Cpu(s)
```

and the process list.

For a one-time snapshot:

```bash
top -b -n1 | head -20
```

`-b` means batch mode.

`-n1` means one iteration.

---

# 9. Find CPU-Heavy Processes

Use:

```bash
ps aux --sort=-%cpu | head -10
```

This sorts processes by CPU usage.

Example:

```text
USER   PID   %CPU   %MEM   COMMAND
root   321   92.4    1.2   ./worker
root   412   44.1    0.8   python3 app.py
user   512   15.2    2.1   java
```

The next question is:

> Why is that process consuming so much CPU?

---

# 10. CPU Stress Testing

Install:

```bash
sudo apt install stress-ng
```

Check available CPUs:

```bash
nproc
```

Stress all CPUs:

```bash
stress-ng --cpu $(nproc)
```

For a controlled test:

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

Monitor from another terminal:

```bash
vmstat 1
```

or:

```bash
top
```

Expected behavior:

```text
CPU usage ↑
Idle CPU ↓
Runnable processes ↑
```

---

# 11. `sar`

Check whether `sar` is available:

```bash
sar --version
```

CPU monitoring:

```bash
sar -u 1 5
```

Meaning:

```text
-u → CPU statistics
1  → every 1 second
5  → five samples
```

`sar` is useful for collecting and analyzing system activity statistics.

---

# 12. Context Switching

Context switching occurs when the CPU switches execution from one task to another.

Monitor context switches using:

```bash
vmstat 1
```

Look at:

```text
cs
```

High context switching is not automatically bad.

The important question is:

> Is excessive context switching creating CPU overhead or indicating heavy scheduling activity?

---

# 🔬 Hands-On Labs

## Lab 1 — Inspect CPU

Run:

```bash
lscpu
```

Then:

```bash
nproc
```

Record:

```text
Architecture:
CPU Count:
CPU Model:
Cores:
Threads:
```

---

## Lab 2 — Monitor CPU

Run:

```bash
vmstat 1
```

Observe:

```text
us
sy
id
wa
st
r
b
cs
```

Record:

```text
User CPU:
System CPU:
Idle:
I/O Wait:
Steal:
Runnable:
Blocked:
Context Switches:
```

---

## Lab 3 — Per-Core Monitoring

Run:

```bash
mpstat -P ALL 1
```

Observe whether CPU usage is evenly distributed.

Ask:

> Are all CPUs being used equally?

---

## Lab 4 — Find Top CPU Processes

Run:

```bash
top -b -n1 | head -20
```

Then:

```bash
ps aux --sort=-%cpu | head -10
```

Record the top CPU-consuming process.

---

## Lab 5 — CPU Stress Test

Start:

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

In another terminal:

```bash
vmstat 1
```

Observe:

```text
us ↑
id ↓
r ↑
```

After the stress test finishes, compare the CPU statistics with the baseline.

---

## Lab 6 — SAR

Run:

```bash
sar -u 1 5
```

Record:

```text
Average user CPU:
Average system CPU:
Average idle CPU:
Average I/O wait:
```

---

# 🧠 CPU Troubleshooting Framework

When a Linux server becomes slow:

```text
SERVER IS SLOW
      │
      ▼
Check CPU Count
      │
      ▼
Check Load Average
      │
      ▼
Check vmstat
      │
      ├───────────────┐
      ▼               ▼
CPU Pressure       I/O Wait
      │               │
      ▼               ▼
  mpstat           Investigate I/O
      │
      ▼
top / ps
      │
      ▼
Find CPU-heavy process
      │
      ▼
Investigate application
```

---

# 🚨 Important Diagnosis Example

Suppose:

```text
CPU count = 8
Load average = 9.5
```

This looks suspicious.

Run:

```bash
vmstat 1
```

Suppose:

```text
r  = 10
b  = 0
us = 85
sy = 10
id = 5
wa = 0
```

This strongly suggests CPU contention.

Then:

```bash
ps aux --sort=-%cpu | head
```

You discover:

```text
python3 worker.py    380% CPU
```

Possible diagnosis:

```text
High load
     ↓
High runnable processes
     ↓
High CPU utilization
     ↓
High user CPU
     ↓
CPU-heavy process found
```

---

# ⚠️ Another Diagnosis

Suppose:

```text
Load average = 9.5
```

but:

```text
us = 10
sy = 5
id = 5
wa = 80
```

Do not immediately conclude:

> CPU is overloaded.

A high `wa` value suggests the system is spending significant time waiting for I/O.

Investigate:

```text
Disk
Storage
Filesystem
Database I/O
Network storage
```

This is why infrastructure engineers investigate multiple metrics instead of relying on a single number.

---

# 🛠️ Day 22 Project — `cpu_profiler.sh`

Create:

```bash
nano cpu_profiler.sh
```

Add:

```bash
#!/bin/bash

echo "========================================="
echo "        CPU PROFILER"
echo "========================================="

echo
echo "Timestamp:"
date

echo
echo "CPU Information:"
lscpu | grep -E "Architecture|CPU\(s\)|Core\(s\) per socket|Thread\(s\) per core|Model name"

echo
echo "CPU Count:"
nproc

echo
echo "Load Average:"
uptime

echo
echo "CPU Statistics:"
vmstat 1 2 | tail -1

echo
echo "Top CPU Processes:"
ps aux --sort=-%cpu | head -10

echo
echo "========================================="
echo "Profiling completed"
echo "========================================="
```

Make executable:

```bash
chmod +x cpu_profiler.sh
```

Run:

```bash
./cpu_profiler.sh
```

---

# 🚀 Enhanced Version — Timestamped Reports

Create a directory:

```bash
mkdir -p "$HOME/cpu-profiles"
```

Use:

```bash
#!/bin/bash

LOG_DIR="$HOME/cpu-profiles"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/cpu_$(date +%Y%m%d_%H%M%S).log"

{
    echo "CPU PROFILE"
    echo "Timestamp: $(date)"
    echo

    echo "CPU COUNT:"
    nproc
    echo

    echo "LOAD:"
    uptime
    echo

    echo "CPU:"
    vmstat 1 2 | tail -1
    echo

    echo "TOP PROCESSES:"
    ps aux --sort=-%cpu | head -10

} > "$LOG_FILE"

echo "Report saved to: $LOG_FILE"
```

This creates reports such as:

```text
~/cpu-profiles/cpu_20261005_141530.log
```

---

# 🎯 Day 22 Challenge

## Challenge 1 — Baseline

Run:

```bash
./cpu_profiler.sh
```

Record:

```text
CPU count:
Load:
User CPU:
System CPU:
Idle:
I/O wait:
Top CPU process:
```

---

## Challenge 2 — Stress

Run:

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

Monitor:

```bash
vmstat 1
```

Compare with the baseline.

---

## Challenge 3 — Per-Core Analysis

Run:

```bash
mpstat -P ALL 1
```

Determine:

```text
Most utilized CPU:
Least utilized CPU:
Average CPU utilization:
```

---

## Challenge 4 — Explain the Bottleneck

Answer:

> If load average is high but CPU idle is also high, what could be happening?

Think about:

```text
I/O wait
Blocked processes
Uninterruptible sleep
Storage bottlenecks
```

---

# 📋 Day 22 Deliverable

Create:

```text
cpu_profiler.sh
```

The script must capture:

* Timestamp
* CPU count
* CPU information
* Load average
* CPU utilization
* Top CPU-consuming processes

Optional improvement:

* Save reports to `~/cpu-profiles/`
* Add timestamps to filenames
* Add error handling
* Add `mpstat`
* Add `sar`
* Add warnings when CPU utilization exceeds a threshold

---

# 🧪 Validation Checklist

* [ ] Understand CPU utilization
* [ ] Understand `us`
* [ ] Understand `sy`
* [ ] Understand `id`
* [ ] Understand `wa`
* [ ] Understand `st`
* [ ] Understand load average
* [ ] Understand 1/5/15-minute load
* [ ] Understand runnable processes
* [ ] Understand blocked processes
* [ ] Use `lscpu`
* [ ] Use `nproc`
* [ ] Use `vmstat`
* [ ] Use `mpstat`
* [ ] Use `top`
* [ ] Use `ps`
* [ ] Use `stress-ng`
* [ ] Use `sar`
* [ ] Understand context switches
* [ ] Build `cpu_profiler.sh`
* [ ] Generate a CPU profiling report

---

# 🧠 What I Learned Today

> CPU monitoring is not simply checking whether CPU usage is high. I learned how to combine CPU utilization, load average, runnable processes, blocked processes, context switches, per-core statistics, and process-level CPU usage to identify the actual bottleneck.

I learned that:

```text
High CPU ≠ Always the problem
High Load ≠ Always CPU
High wa ≠ CPU bottleneck
```

The correct approach is:

```text
Measure
   ↓
Compare
   ↓
Correlate
   ↓
Identify bottleneck
   ↓
Investigate process
   ↓
Fix
   ↓
Measure again
```

---

# ☁️ Cloud Infrastructure Connection

CPU monitoring is directly relevant to cloud infrastructure.

On an AWS EC2 instance, for example, I need to understand:

```text
EC2 Instance
     │
     ├── CPU Utilization
     │
     ├── Load Average
     │
     ├── Processes
     │
     ├── I/O Wait
     │
     └── CPU Credits
```

Linux-level CPU analysis helps me understand what is happening **inside** a cloud server rather than blindly scaling the instance.

This connects directly to:

* EC2 monitoring
* CloudWatch
* Auto Scaling
* Container resource limits
* Kubernetes CPU requests/limits
* Performance engineering
* Distributed systems
* Production incident response

---

# 🔥 Day 22 Key Takeaway

> **A strong Cloud Infrastructure Engineer doesn't just see a high CPU graph. They investigate why the CPU is high, which process is responsible, whether the workload is CPU-bound or I/O-bound, and what the system is doing over time.**

**Day 218 / 1000 complete.**

**Day 22 / 30 Linux complete.**

> **1000 Days. 2 Hours Daily.**

---

## Day 219 — Day 23 — Memory Monitoring & Management
**Date:** October 6, 2026 (Tuesday) [Inferred chronologically]

---

## 🎯 Today's Objective

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

# 1. Linux Memory Fundamentals

Linux memory is not simply:

```text
Application Memory + Empty Memory
```

Linux actively uses unused RAM for:

* Application memory
* Page cache
* Buffers
* Shared memory
* Kernel memory

Simplified model:

```text
              PHYSICAL RAM
        ┌─────────────────────┐
        │ Application Memory  │
        ├─────────────────────┤
        │ Shared Memory       │
        ├─────────────────────┤
        │ Kernel Memory       │
        ├─────────────────────┤
        │ Page Cache          │
        ├─────────────────────┤
        │ Buffers             │
        └─────────────────────┘
```

### Important

Low free memory does not automatically mean the system is running out of memory.

The more useful quick indicator is usually:

```text
available
```

---

# 2. RSS — Resident Set Size

RSS represents the memory pages of a process that are currently resident in physical RAM.

Example:

```text
RSS = 500 MB
```

This means the process currently has roughly 500 MB resident in physical memory.

Check process memory:

```bash
ps aux
```

Example:

```text
USER   PID  %CPU %MEM    VSZ    RSS
root   123   5.0  4.2 900000 420000
```

For memory troubleshooting, RSS is generally more useful than VSZ when identifying actual RAM consumers.

---

# 3. VSZ — Virtual Memory Size

VSZ is the virtual address space associated with a process.

It can include:

* Mapped files
* Shared libraries
* Allocated but unused memory
* Memory mappings
* Swapped memory

Therefore:

```text
VSZ ≠ actual RAM consumption
```

Example:

```text
VSZ = 2 GB
RSS = 400 MB
```

The process can have a 2 GB virtual address space while only around 400 MB is resident in RAM.

### Infrastructure Rule

When searching for a RAM hog:

> Pay more attention to RSS than VSZ.

---

# 4. Shared Memory

Multiple processes can share physical memory.

Example:

```text
Process A ─────┐
               ├── Shared Library ── RAM
Process B ─────┘
```

This means adding every process's RSS does not necessarily give an exact amount of unique physical memory consumed.

For advanced investigation:

`smem` can provide more detailed memory accounting.

---

# 5. `free`

Start with:

```bash
free -h
```

Typical output:

```text
               total   used   free   shared  buff/cache  available
Mem:            7.7Gi   2.1Gi  1.2Gi    200Mi    4.4Gi       5.1Gi
Swap:           2.0Gi   100Mi  1.9Gi
```

### Important fields:

| Field | Meaning |
|---|---|
| `total` | Total usable memory |
| `used` | Memory currently in use |
| `free` | Completely unused memory |
| `shared` | Memory used by shared memory mechanisms |
| `buff/cache` | Buffers and filesystem cache |
| `available` | Estimated memory available for new workloads |
| `swap` | Swap space usage |

### Key Rule

Do NOT judge memory health using `free` alone.

Look at:

* `available`
* Swap activity
* Memory pressure
* Process memory usage

---

# 6. `free -h -w`

Run:

```bash
free -h -w
```

This gives a more detailed breakdown:

```text
               total  used  free  shared  buff  cache  available
Mem:            7.7G   2.2G  1.1G  200M    150M  4.3G   5.0G
Swap:           2.0G   100M  1.9G
```

The `-w` option separates **buffers** and **cache** instead of grouping them together.

---

# 7. Hands-On: Inspect Current Memory

Run:

```bash
free -h
```

Then:

```bash
free -h -w
```

Record:

* Total RAM
* Available RAM
* Swap Total
* Swap Used

Ask yourself:

* Is available memory healthy?
* Is swap being used?
* Is the system under pressure?

---

# 8. Find Memory-Hungry Processes

Run:

```bash
ps aux --sort=-%mem | head -20
```

This sorts processes by memory percentage.

Example:

```text
USER       PID %CPU %MEM    VSZ   RSS COMMAND
mysql     1240  2.1 12.4  ...   ... mysqld
node      2310  1.2  8.7  ...   ... node
root      1000  0.4  4.2  ...   ... python
```

Focus on:

* `%MEM`
* `RSS`

---

# 9. Real-Time Monitoring With `top`

Run:

```bash
top
```

Press:

```text
M
```

This sorts processes by memory usage.

Use `top` to quickly answer:

* Is RAM exhausted?
* Is swap being used?
* Which process consumes the most memory?

This is an essential Linux troubleshooting skill.

---

# 10. `vmstat`

Run:

```bash
vmstat 1
```

The `1` means refresh every 1 second.

### Important columns:

| Column | Meaning |
|---|---|
| `r` | Runnable processes |
| `b` | Blocked processes |
| `swpd` | Swap used |
| `free` | Free RAM |
| `buff` | Buffer memory |
| `cache` | Page cache |
| `si` | Swap-in |
| `so` | Swap-out |

---

# 11. Swap-In and Swap-Out

The most important swap columns are:

* `si` = swap in
* `so` = swap out

If Linux repeatedly moves memory:

```text
RAM → Disk
Disk → RAM
```

performance can degrade significantly.

Conceptually:

```text
Heavy swapping
      ↓
Higher disk I/O
      ↓
Higher latency
      ↓
Applications slow down
      ↓
Requests may timeout
```

---

# 12. Swap

Swap is disk space used by Linux as part of virtual memory management.

Conceptually:

```text
             MEMORY
                │
        ┌───────┴───────┐
        │               │
       RAM             SWAP
      Fast              Slow
```

Check swap:

```bash
swapon -s
```

or:

```bash
cat /proc/swaps
```

Also useful:

```bash
swapon --show
```

---

# 13. Is Swap Usage Always Bad?

No.

Occasional swap usage does not automatically mean something is wrong.

Linux may move inactive memory pages to swap to free RAM for other useful work.

The bigger concern is **continuous swap activity**, especially repeated:

```text
si > 0
so > 0
```

in `vmstat`.

Think:

```text
Occasional swap
      ↓
Can be normal

Constant swap in/out
      ↓
Memory pressure
      ↓
Performance problem
```

---

# 14. OOM — Out Of Memory

Imagine:

```text
RAM = 8 GB
Swap = 0
```

Applications collectively demand:

```text
10 GB
```

Eventually:

```text
Memory Pressure
      ↓
Allocation failures
      ↓
OOM condition
      ↓
OOM Killer
```

The Linux OOM killer terminates selected processes to recover memory.

---

# 15. Why Does Linux Kill a Process?

Imagine a server running:

* Nginx
* Database
* Python API
* Monitoring Agent
* SSH

When memory becomes critically low, Linux needs to recover memory. It considers factors such as OOM scoring when selecting a process.

The goal is:

```text
Recover memory
      ↓
Keep the system alive
```

Unfortunately, the process killed may be your application.

---

# 16. Check Overcommit

Run:

```bash
cat /proc/sys/vm/overcommit_memory
```

Common values:

* `0` = heuristic overcommit
* `1` = always overcommit
* `2` = strict overcommit

---

# 17. OOM Score

Inspect a process:

```bash
cat /proc/<PID>/oom_score
```

Also inspect:

```bash
cat /proc/<PID>/oom_score_adj
```

`oom_score` helps indicate how likely a process is to be selected by the OOM killer. `oom_score_adj` allows the OOM preference to be adjusted.

---

# 18. Memory Pressure — PSI

Linux provides Pressure Stall Information:

```bash
cat /proc/pressure/memory
```

Example:

```text
some avg10=0.00 avg60=0.00 avg300=0.00 total=...
full avg10=0.00 avg60=0.00 avg300=0.00 total=...
```

* `free` $\rightarrow$ How much memory is available?
* `PSI` $\rightarrow$ Are processes being delayed because memory is difficult to obtain?

---

# 19. `some` vs `full`

* **`some`**: Some tasks are stalled waiting for memory resources.
* **`full`**: All non-idle tasks are simultaneously stalled on memory resources.

---

# 20. Simulate Memory Pressure

Install `stress-ng` if necessary:

```bash
sudo apt update
sudo apt install stress-ng
```

Run controlled memory pressure:

```bash
stress-ng --vm 2 --vm-bytes 50%
```

---

# 21. Monitor the Stress Test

Open another terminal:

```bash
watch -n 1 free -h
```

```bash
vmstat 1
```

```bash
cat /proc/pressure/memory
```

Stop the stress test with `Ctrl+C`.

---

# 22. Check OOM Events

Try:

```bash
sudo dmesg | grep -Ei 'out of memory|killed process|oom'
```

On systemd systems:

```bash
journalctl -k | grep -Ei 'oom|out of memory|killed process'
```

---

# 23. Real-World Cloud Incident

Imagine an AWS EC2 instance running:

```text
Nginx
   ↓
Node.js API
   ↓
Python ML Worker
```

Traffic increases $\rightarrow$ Memory grows to 8 GB $\rightarrow$ OOM triggers $\rightarrow$ Python worker killed.

Troubleshooting workflow:

```bash
free -h
ps aux --sort=-%mem | head -20
journalctl -k | grep -Ei 'oom|killed process'
```

---

# 24. Build `mem_profiler.sh`

Create:

```bash
nano mem_profiler.sh
```

```bash
#!/usr/bin/env bash

echo "======================================"
echo "       LINUX MEMORY PROFILER"
echo "======================================"

echo
echo "[1] MEMORY SUMMARY"
free -h

echo
echo "[2] TOP MEMORY-CONSUMING PROCESSES"
ps aux --sort=-%mem | head -11

echo
echo "[3] SWAP STATUS"
swapon --show

echo
echo "[4] OVERCOMMIT MEMORY"
cat /proc/sys/vm/overcommit_memory

echo
echo "[5] MEMORY PRESSURE"
cat /proc/pressure/memory

echo
echo "[6] OOM EVENTS"
dmesg 2>/dev/null | grep -Ei "oom|out of memory|killed process" | tail -10

echo
echo "======================================"
echo "        MEMORY CHECK COMPLETE"
echo "======================================"
```

Make it executable:

```bash
chmod +x mem_profiler.sh
```

---

# 25. Memory Troubleshooting Flow

```text
Memory Problem
      │
      ▼
   free -h
      │
      ▼
Check available memory
      │
      ▼
ps / top
      │
      ▼
Find memory-heavy process
      │
      ▼
vmstat 1
      │
      ├── si/so high?
      │       │
      │       ▼
      │     Swap pressure
      │
      ▼
/proc/pressure/memory
      │
      ▼
Check PSI
      │
      ▼
journalctl -k
      │
      ▼
Check OOM events
```

---

# 26. Cloud Infrastructure Connection

Linux memory knowledge directly transfers to:

```text
Linux
  ↓
EC2
  ↓
Docker
  ↓
Kubernetes
  ↓
Containers
  ↓
OOMKilled Pods
  ↓
Resource Requests/Limits
  ↓
Production Incident Response
```

---

# 🔥 Day 23 Key Takeaway

> **Don't ask only "How much RAM is free?" Ask: "Is the system under memory pressure, which process is responsible, is the kernel swapping, and has the OOM killer been triggered?"**

**Day 23 / 30 — Linux Mastery**  
**Day 219 / 1000 — AI Cloud Infrastructure Engineer**  

**1000 Days. 2 Hours Daily.**

---

## Day 220 — Day 24 / 30 — Disk I/O Monitoring
**Date:** October 7, 2026 (Wednesday) [Inferred chronologically]

---

## 🎯 Objective

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

# 1. What is Disk I/O?

I/O means **Input/Output**.

For storage:

- **Read** → Getting data from storage
- **Write** → Sending data to storage

Basic flow:

```text
Application
     ↓
Filesystem (ext4, XFS, Btrfs)
     ↓
Block Layer & I/O Scheduler
     ↓
Device Driver
     ↓
Physical Storage (NVMe, SSD, HDD, Cloud EBS)
```

Storage performance is typically measured in three primary dimensions:

1. **IOPS (Input/Output Operations Per Second)**: How many individual read/write operations occur per second.
2. **Throughput (MB/s)**: The total volume of data transferred per second.
3. **Latency (ms)**: The time it takes for an I/O request to be completed.

---

# 2. Key Disk Performance Metrics

| Metric | Tool Column | Description |
|---|---|---|
| **`r/s` & `w/s`** | `iostat` | Read / Write requests issued per second (IOPS) |
| **`rkB/s` & `wkB/s`** | `iostat` | Read / Write throughput in kilobytes per second |
| **`rrqm/s` & `wrqm/s`** | `iostat` | Merged read / write requests per second |
| **`r_await` & `w_await`** | `iostat` | Average time (ms) for read/write requests to be served |
| **`aqu-sz`** | `iostat` | Average queue size (outstanding requests) |
| **`%util`** | `iostat` | Percentage of CPU time during which I/O requests were issued |
| **`wa` (iowait)** | `top` / `vmstat` | Percentage of time the CPU is idle waiting for disk I/O |

---

# 3. `iostat` — Core Storage Diagnostics

Install `sysstat` if not already installed:

```bash
sudo apt update && sudo apt install -y sysstat
```

### Basic `iostat` Usage

```bash
iostat -x 1
```

For extended metrics filtering out inactive devices:

```bash
iostat -xz 1 5
```

### Interpreting Output:

```text
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm  r_await  w_await   aqu-sz  rareq-sz  wareq-sz  svctm  %util
nvme0n1         12.00   85.00   1024.00   4096.00     0.00    15.00   0.00  15.00     0.45     1.20     0.10     85.33     48.18   0.15   2.50
```

### Critical Rules:

- If **`%util` approaches 100%**, the storage device is saturated.
- If **`r_await` or `w_await` spikes (>20ms for SSD, >5ms for NVMe)**, storage latency is hurting application response times.
- If **`aqu-sz` is high**, requests are queuing up faster than the disk can service them.

---

# 4. `iotop` — Finding Heavy I/O Processes

`iotop` works like `top`, but displays per-process disk read/write throughput and I/O percentages.

Install:

```bash
sudo apt install -y iotop
```

Run in interactive mode:

```bash
sudo iotop
```

Show only active I/O processes (filtered mode):

```bash
sudo iotop -o
```

Batch mode for scripts and snapshots:

```bash
sudo iotop -b -n 3 -o
```

---

# 5. `pidstat` — Detailed Per-Process I/O

`pidstat -d` reports per-process I/O activity:

```bash
pidstat -d 1 5
```

Example output:

```text
UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
1000     4512   5120.00   1024.00      0.00      12  postgres
1000     8921      0.00   8192.00      0.00      45  python3
```

- **`kB_rd/s`**: Kilobytes read per second.
- **`kB_wr/s`**: Kilobytes written per second.
- **`iodelay`**: Delay spent waiting for I/O (in clock ticks).

---

# 6. Linux I/O Schedulers

The I/O scheduler reorders and merges block requests to optimize performance.

Inspect current scheduler for a disk (e.g. `sda` or `nvme0n1`):

```bash
cat /sys/block/sda/queue/scheduler
```

Common Schedulers:
- **`none`**: Bypass scheduler (standard for NVMe and high-speed SSDs).
- **`mq-deadline`**: Multi-queue deadline scheduler (general-purpose, predictable latency).
- **`bfq` (Budget Fair Queueing)**: Desktop responsiveness, complex multimedia workloads.
- **`kyber`**: Low-latency scheduler tuned for fast devices.

Change scheduler temporarily:

```bash
echo mq-deadline | sudo tee /sys/block/sda/queue/scheduler
```

---

# 7. Controlled Disk Stress Testing with `fio` and `dd`

Install `fio`:

```bash
sudo apt install -y fio
```

### Sequential Write Test:
```bash
fio --name=seq-write --ioengine=libaio --rw=write --bs=1M --size=512M --numjobs=1 --direct=1 --filename=/tmp/fio-test.img --group_reporting
```

### Random Read IOPS Test:
```bash
fio --name=rand-read --ioengine=libaio --rw=randread --bs=4k --size=512M --numjobs=4 --direct=1 --filename=/tmp/fio-test.img --group_reporting
```

Clean up test files:

```bash
rm -f /tmp/fio-test.img
```

---

# 8. Disk I/O Troubleshooting Flow

```text
System Slow / High Load
          │
          ▼
     vmstat 1
          │
      wa > 20%?
     ┌────┴────┐
     ▼         ▼
    YES        NO (Look at CPU/Memory)
     │
     ▼
  iostat -xz 1
     │
     ├───────────────┬───────────────┐
     ▼               ▼               ▼
 %util ≈ 100%     await > 20ms     aqu-sz >> 1
(Disk Saturated) (High Latency)  (Queue Backlog)
     │
     ▼
 iotop -o / pidstat -d 1
     │
     ▼
Identify Process (PID, Command)
     │
     ▼
Optimize Query / Add Cache / Upgrade Cloud IOPS / Scale Storage
```

---

# 9. Hands-On Script — `disk_profiler.sh`

```bash
#!/usr/bin/env bash
# ==============================================================================
# Linux Storage & Disk I/O Profiler
# ==============================================================================

set -euo pipefail

echo "============================================================"
echo "                 LINUX DISK I/O PROFILER                    "
echo "============================================================"
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo

echo "[1] BLOCK DEVICES & MOUNTPOINTS"
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
echo

echo "[2] FILESYSTEM UTILIZATION (df -h)"
df -h --total -x tmpfs -x devtmpfs
echo

echo "[3] I/O SYSTEM PERFORMANCE (iostat snapshot)"
if command -v iostat >/dev/null 2>&1; then
    iostat -xz 1 2 | awk '/Device/{flag=1} flag' | tail -n +2
else
    echo "iostat not installed (install sysstat package)."
fi
echo

echo "[4] TOP 5 DISK I/O PROCESSES (pidstat)"
if command -v pidstat >/dev/null 2>&1; then
    pidstat -d 1 1 | awk 'NR>2 {print $0}' | sort -k4 -nr | head -n 5
else
    echo "pidstat not installed (install sysstat package)."
fi
echo

echo "[5] I/O SCHEDULERS PER BLOCK DEVICE"
for dev in /sys/block/*; do
    bname=$(basename "$dev")
    if [[ ! "$bname" =~ ^(loop|ram) ]]; then
        if [ -f "$dev/queue/scheduler" ]; then
            echo "$bname: $(cat "$dev/queue/scheduler")"
        fi
    fi
done
echo
echo "============================================================"
echo "               DISK PROFILING COMPLETE                      "
echo "============================================================"
```

---

# 10. Cloud Infrastructure Connection (AWS / Cloud Storage)

In cloud environments (such as AWS EC2 and EBS):
- **EBS gp3**: Baseline 3,000 IOPS and 125 MB/s throughput regardless of volume size, with scalable independent IOPS/throughput.
- **EBS io2 Block Express**: Sub-millisecond latency for high-transaction enterprise databases (up to 256,000 IOPS).
- **Burst Credits / I/O Throttling**: When disk IOPS/throughput limits are reached, the hypervisor throttles I/O, causing high `await` and high `wa` in Linux metrics without physical hardware failure.
- **CloudWatch VolumeReadOps / VolumeWriteOps**: Directly correlates to `iostat r/s` and `w/s`.

---

# 🧠 Day 24 Summary & Key Takeaways

1. **`%util` is a measure of time, not bandwidth**: 100% utilization means the disk was busy 100% of the sampling period.
2. **`await` vs `svctm`**: `await` represents total time (queuing + service). When `await` is much higher than `svctm`, disk queueing is the primary bottleneck.
3. **Always correlate `wa` with `iostat` and `iotop`**: High CPU `wa` means the processor is waiting on disk, and `iotop` reveals the exact application responsible.

**Day 24 / 30 — Linux Mastery**  
**Day 220 / 1000 — AI Cloud Infrastructure Engineer**  

**1000 Days. 2 Hours Daily.**

---

## Day 221 — Day 25/30 — Network Performance & Debugging
**Date:** 2026-10-08 (Calendar: October 8, 2026 (Thursday))

---

## 🎯 Objective

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

# 📚 Theory

## 1. Network Performance Metrics

### Bandwidth

Bandwidth is the maximum amount of data that can be transferred over a network in a given period.

Common units:

```text
Mbps
Gbps
MB/s
GB/s
```

Remember:

```text
8 bits = 1 byte
```

Therefore:

```text
1 Gbps ≈ 125 MB/s
```

---

## 2. Latency

Latency is the time required for data to travel between two endpoints.

Example:

```text
Client ───────────────> Server
          20 ms
```

Lower latency generally means faster communication.

Latency is especially important for:

* APIs
* Databases
* Microservices
* Distributed systems
* Cloud applications
* AI inference systems

---

## 3. Packet Loss

Packet loss occurs when packets sent across a network fail to reach their destination.

Example:

```text
Packets sent:     1000
Packets received: 995
Packets lost:     5
```

Packet loss can cause:

* Slow connections
* TCP retransmissions
* Unstable SSH sessions
* Poor application performance
* Increased latency

---

## 4. Retransmissions

TCP expects packets to be acknowledged.

If a packet is lost:

```text
Packet 1 ✓
Packet 2 ✓
Packet 3 ✗
Packet 4 ✓
```

TCP may retransmit packet 3.

```text
Packet 3 → again
```

Excessive retransmissions can reduce network performance.

---

# 🔌 5. Linux Socket Statistics — `ss`

`ss` means:

```text
Socket Statistics
```

It is the modern replacement for many uses of `netstat`.

Basic command:

```bash
ss
```

---

## 6. List Listening TCP Ports

```bash
ss -tlnp
```

Options:

```text
-t → TCP
-l → Listening
-n → Numeric output
-p → Process information
```

Example:

```text
LISTEN  0  128  0.0.0.0:22
```

This means a service is listening on TCP port `22`.

---

## 7. Show All Connections

```bash
ss -anp
```

Useful for seeing:

* Listening sockets
* Established connections
* TIME_WAIT
* Source addresses
* Destination addresses
* Processes

---

# 🔄 8. TCP Connection States

Important TCP states include:

```text
LISTEN
SYN-SENT
SYN-RECV
ESTABLISHED
FIN-WAIT-1
FIN-WAIT-2
CLOSE-WAIT
CLOSING
LAST-ACK
TIME-WAIT
CLOSED
```

---

## LISTEN

A service is waiting for incoming connections.

Example:

```text
sshd
   ↓
LISTEN
   ↓
Port 22
```

---

## ESTABLISHED

An active TCP connection exists.

Example:

```text
Client
   │
   │ SSH
   ▼
Linux Server

ESTABLISHED
```

---

## TIME_WAIT

A TCP connection has been closed but the system temporarily keeps connection information.

Check:

```bash
ss -tan | grep TIME_WAIT | wc -l
```

A small number is normal.

A very large number may indicate a system creating many short-lived TCP connections.

Possible areas to investigate:

* Connection pooling
* Keep-alive
* Application behavior
* Ephemeral ports
* Load balancers
* Microservice communication

---

# 📊 9. Count TCP Connection States

```bash
ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c
```

Example:

```text
12 ESTAB
5 LISTEN
27 TIME-WAIT
```

This gives a quick network connection baseline.

---

# 📡 10. `ping`

`ping` tests basic network reachability and measures round-trip latency.

```bash
ping google.com
```

For four packets:

```bash
ping -c 4 google.com
```

Important information:

```text
Packet loss
Minimum latency
Average latency
Maximum latency
```

Example:

```text
4 packets transmitted
4 packets received
0% packet loss
```

### Important

A failed ping does not always mean the destination is down.

Some systems block ICMP traffic.

---

# 🛣️ 11. `traceroute`

`traceroute` shows the network hops between your machine and a destination.

```bash
traceroute google.com
```

Conceptually:

```text
Your Machine
     ↓
Router
     ↓
ISP
     ↓
Internet
     ↓
Destination
```

It helps identify where latency or routing problems may occur.

Alternative:

```bash
tracepath google.com
```

---

# 📈 12. `mtr`

`mtr` combines concepts from:

```text
ping + traceroute
```

Run:

```bash
mtr google.com
```

It continuously monitors:

* Network hops
* Latency
* Packet loss

Useful for troubleshooting unstable network paths.

---

# 🌐 13. DNS Troubleshooting

DNS converts domain names into IP addresses.

Example:

```text
google.com
     ↓
IP Address
     ↓
142.x.x.x
```

If DNS fails:

```bash
curl https://example.com
```

may fail even though the network itself is working.

---

# 🔎 14. `nslookup`

```bash
nslookup google.com
```

Used for basic DNS queries.

---

# 🔬 15. `dig`

`dig` provides detailed DNS information.

```bash
dig google.com
```

Get only the IP:

```bash
dig +short google.com
```

IPv4:

```bash
dig google.com A
```

IPv6:

```bash
dig google.com AAAA
```

---

# 🔍 16. `host`

Simple DNS lookup:

```bash
host google.com
```

Useful for quick DNS checks.

---

# 🚀 17. `iperf3`

`iperf3` measures network throughput between two machines.

Server:

```bash
iperf3 -s
```

Client:

```bash
iperf3 -c <server-ip>
```

It can measure:

* Throughput
* Transfer rate
* Bandwidth

Concept:

```text
Machine A
    │
    │ Network
    ▼
Machine B
```

---

# 🐦 18. `tcpdump`

`tcpdump` captures and displays network packets.

First identify the network interface:

```bash
ip addr
```

or:

```bash
ip link
```

Then:

```bash
sudo tcpdump -i eth0 -n
```

Replace `eth0` with the actual interface.

---

## Capture HTTP Traffic

```bash
sudo tcpdump -i eth0 -n port 80
```

## Capture HTTPS Traffic

```bash
sudo tcpdump -i eth0 -n port 443
```

## Capture SSH Traffic

```bash
sudo tcpdump -i eth0 -n port 22
```

## Capture Traffic From a Specific Host

```bash
sudo tcpdump -i eth0 -n host 192.168.1.10
```

Stop packet capture:

```text
Ctrl+C
```

---

# 🧪 Hands-On Lab

## Exercise 1 — Network Interfaces

```bash
ip addr
```

Identify:

```text
Interface
IPv4 address
IPv6 address
```

---

## Exercise 2 — Listening Ports

```bash
ss -tlnp
```

Record:

```text
Port
Process
IP address
State
```

---

## Exercise 3 — All Connections

```bash
ss -anp
```

Look for:

```text
LISTEN
ESTABLISHED
TIME-WAIT
CLOSE-WAIT
```

---

## Exercise 4 — TIME_WAIT

```bash
ss -tan | grep TIME_WAIT | wc -l
```

Record the number.

---

## Exercise 5 — Connection State Statistics

```bash
ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c
```

Understand what each state represents.

---

## Exercise 6 — DNS Testing

Run:

```bash
nslookup google.com
```

Then:

```bash
dig google.com
```

Then:

```bash
dig +short google.com
```

Then:

```bash
host google.com
```

Compare the outputs.

---

## Exercise 7 — Connectivity

```bash
ping -c 4 google.com
```

Record:

```text
Packet loss
Minimum latency
Average latency
Maximum latency
```

---

## Exercise 8 — Route Tracing

```bash
traceroute google.com
```

If unavailable:

```bash
tracepath google.com
```

Observe the network hops.

---

## Exercise 9 — Packet Capture

Find the network interface:

```bash
ip link
```

Then:

```bash
sudo tcpdump -i <interface> -n
```

Capture HTTP traffic:

```bash
sudo tcpdump -i <interface> -n port 80
```

Stop using:

```text
Ctrl+C
```

---

# 🛠️ Mini Project — `network_profiler.sh`

## Objective

Create a script that captures a basic Linux network baseline.

The script should collect:

```text
Hostname
Date
Network interfaces
IP addresses
Listening ports
TCP connection states
TIME_WAIT count
DNS resolution
Connectivity
```

---

## Expected Report

```text
========================================
       NETWORK PERFORMANCE REPORT
========================================

HOST:

DATE:

--- NETWORK INTERFACES ---

--- IP ADDRESSES ---

--- LISTENING PORTS ---

--- CONNECTION STATES ---

--- TIME_WAIT COUNT ---

--- DNS TEST ---

--- CONNECTIVITY TEST ---

--- ROUTING INFORMATION ---

========================================
```

---

# 🧠 Recommended Script Logic

Start with:

```bash
#!/bin/bash
```

Collect system information:

```bash
hostname
date
```

Network information:

```bash
ip addr
```

Listening ports:

```bash
ss -tlnp
```

Connection information:

```bash
ss -tan
```

TIME_WAIT:

```bash
ss -tan | grep TIME_WAIT | wc -l
```

DNS:

```bash
dig +short google.com
```

Connectivity:

```bash
ping -c 4 google.com
```

Routing:

```bash
traceroute google.com
```

Save the results into:

```text
network_report.txt
```

---

# ⭐ Recommended Improvement

Don't make the script only dump raw command output.

Make it interpret the results.

Example:

```text
TIME_WAIT connections: 18
STATUS: NORMAL
```

If the number becomes unusually large:

```text
TIME_WAIT connections: 15432
STATUS: INVESTIGATE
```

This makes the script more useful as an infrastructure monitoring tool.

---

# 🚨 Real-World Debugging Scenario

Suppose an application reports:

```text
Connection timeout
```

Don't immediately restart the server.

Follow a structured process.

### 1. Check whether the service is listening

```bash
ss -tlnp
```

### 2. Test the service locally

```bash
curl localhost:8080
```

### 3. Test DNS

```bash
dig +short api.example.com
```

### 4. Test connectivity

```bash
ping <destination>
```

### 5. Check routing

```bash
traceroute <destination>
```

### 6. Check TCP connections

```bash
ss -tan
```

### 7. Check TIME_WAIT

```bash
ss -tan | grep TIME_WAIT | wc -l
```

### 8. Inspect packets

```bash
sudo tcpdump -i <interface> -n port 8080
```

---

# 🔥 Network Debugging Decision Tree

```text
Application unreachable
        │
        ▼
Is service listening?
        │
     ss -tlnp
        │
   ┌────┴────┐
   │         │
  NO        YES
   │         │
Service    Test locally
problem       │
              ▼
       curl localhost
              │
         ┌────┴────┐
         │         │
        FAIL      PASS
         │         │
     Application  Network
       problem    problem
                    │
                    ▼
                  DNS?
              dig / host
                    │
                    ▼
                Routing?
          ping / traceroute
                    │
                    ▼
              TCP states?
                 ss
                    │
                    ▼
               Packets?
              tcpdump
```

---

# ☁️ Cloud Engineering Connection

Network debugging is fundamental to cloud infrastructure.

Eventually, systems will look like:

```text
                    Internet
                       │
                       ▼
                 Load Balancer
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
        Server       Server       Server
          │            │            │
          └────────────┼────────────┘
                       ▼
                    Database
```

When an application becomes slow, you need to determine whether the problem is:

```text
DNS
 ↓
Routing
 ↓
Latency
 ↓
Packet Loss
 ↓
TCP
 ↓
Connections
 ↓
Bandwidth
 ↓
Application
 ↓
Database
```

This is the foundation for troubleshooting:

* AWS EC2
* AWS VPC
* Load Balancers
* Containers
* Kubernetes
* Microservices
* Distributed systems
* AI inference infrastructure

---

# 🧠 Key Commands to Remember

```bash
ip addr
```

```bash
ss -tlnp
```

```bash
ss -anp
```

```bash
ss -tan | grep TIME_WAIT | wc -l
```

```bash
ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c
```

```bash
ping -c 4 google.com
```

```bash
traceroute google.com
```

```bash
mtr google.com
```

```bash
nslookup google.com
```

```bash
dig google.com
```

```bash
dig +short google.com
```

```bash
host google.com
```

```bash
iperf3 -s
```

```bash
iperf3 -c <server-ip>
```

```bash
sudo tcpdump -i <interface> -n
```

---

# ✅ Day 25 Completion Checklist

* [ ] Understand bandwidth
* [ ] Understand latency
* [ ] Understand packet loss
* [ ] Understand TCP retransmissions
* [ ] Understand `ss`
* [ ] Understand `netstat`
* [ ] List listening ports
* [ ] View active connections
* [ ] Understand TCP states
* [ ] Check TIME_WAIT
* [ ] Count connection states
* [ ] Use `ping`
* [ ] Use `traceroute`
* [ ] Use `mtr`
* [ ] Use `nslookup`
* [ ] Use `dig`
* [ ] Use `host`
* [ ] Understand `iperf3`
* [ ] Capture packets with `tcpdump`
* [ ] Build `network_profiler.sh`
* [ ] Generate a network baseline report
* [ ] Understand real-world network debugging workflow

---

# 📦 Deliverable

```text
network_profiler.sh
network_report.txt
```

---

# 🏆 Day 25 Takeaway

> **Don't guess where a network problem is. Measure it.**

Today I learned how to move from:

```text
"It is slow."
```

to:

```text
"DNS is working.
TCP connection exists.
Latency is 42 ms.
Packet loss is 0%.
There are 18 TIME_WAIT connections.
The service is listening on port 8080.
The network path is healthy."
```

That shift from **guessing → measuring → diagnosing** is a core infrastructure engineering skill.

---

## 🚀 Progress

```text
Linux Journey:
Day 25 / 30

AI Cloud Infrastructure Journey:
Day 221 / 1000

Linux Progress:
83.33%

1000-Day Progress:
22.1%
```

---

## Day 222 — Day 26/30 — Logs & Journalctl Mastery
**Date:** October 9, 2026 (Calendar: October 9, 2026 (Friday))

**1000-Day AI Cloud Infrastructure Engineer Journey**  






---

## 🎯 Objective

Master Linux logging using `journalctl` and `systemd-journald`. Learn to filter logs by service, boot, time, priority, and executable. Understand journal storage, log retention, and disk usage.

Build `log_investigator.sh`, an automated log investigation tool that accepts a service name and time window, extracts relevant logs, counts errors, and summarizes the results.

---

## 📚 Theory (1 Hour)

### 1. Understanding Linux Logs

Logs are timestamped records of events generated by applications, services, the Linux kernel, and the operating system.


* Investigate service startup problems.
* Identify permission and configuration errors.
* Troubleshoot network and infrastructure issues.
* Understand system behavior before and after a reboot.
* Support security auditing and incident response.

---

### 2. systemd Journal Architecture

`systemd-journald` collects and stores structured log events.

Unlike traditional plain-text log files, the systemd journal uses a binary storage format and supports indexed queries.


* `journalctl`: Queries and displays journal records.
* Structured fields: Store information such as timestamps, process IDs, service units, and messages.
* Access control: Determines which journal records a user can read.

---

### 3. Persistent vs. Volatile Storage

| Type       | Location            | Behavior                                              |
| ---------- | ------------------- | ----------------------------------------------------- |
| Persistent | `/var/log/journal/` | Can survive system reboots                            |
| Volatile   | `/run/log/journal/` | Stored in runtime storage and normally lost at reboot |

Check journal storage:

```bash
journalctl --disk-usage
ls -ld /var/log/journal /run/log/journal 2>/dev/null
```

Inspect journald configuration:

```bash
systemd-analyze cat-config systemd/journald.conf
```

---

### 4. Basic journalctl Commands

```bash
# Display journal entries
journalctl

# Display the first 50 entries
journalctl | head -50

# Display the latest 50 entries
journalctl -n 50

# Follow new journal entries
journalctl -f

# Display detailed record fields
journalctl -o verbose -n 10

# Display ISO-formatted timestamps
journalctl -o short-iso -n 50
```

Press `Ctrl+C` to stop following logs.

---

### 5. Boot-Based Log Investigation

```bash
# Current boot
journalctl -b

# Previous boot
journalctl -b -1

# List recorded boots
journalctl --list-boots

# Kernel messages
journalctl -k

# Kernel messages from the current boot
journalctl -k -b
```



Previous-boot logs are available only if the relevant records have been retained.

---

### 6. Service-Based Filtering

```bash
# Display Nginx logs
journalctl -u nginx

# Display the last 50 Nginx entries
journalctl -u nginx -n 50

# Follow Nginx logs in real time
journalctl -u nginx -f

# Display SSH service logs
journalctl -u ssh

# Display service errors
journalctl -u nginx -p err
```

Service unit names vary across Linux distributions. For example, SSH may use `ssh.service` or `sshd.service`.

---

### 7. Time-Based Filtering

```bash
# Logs from the last hour
journalctl --since "1 hour ago"

# Logs from today
journalctl --since today

# Logs from the last 30 minutes
journalctl --since "30 minutes ago"

# Logs between two timestamps
journalctl --since "2026-10-09 09:00:00" \
           --until "2026-10-09 12:00:00"

# Nginx logs from the last hour
journalctl -u nginx --since "1 hour ago"
```

Always check time zones when correlating system logs with application logs or cloud monitoring events.

---

### 8. Log Priority Levels

| Priority | Name    | Meaning                   |
| -------- | ------- | ------------------------- |
| 0        | emerg   | System is unusable        |
| 1        | alert   | Immediate action required |
| 2        | crit    | Critical condition        |
| 3        | err     | Error condition           |
| 4        | warning | Warning condition         |
| 5        | notice  | Significant normal event  |
| 6        | info    | Informational message     |
| 7        | debug   | Diagnostic information    |

Examples:

```bash
# Errors and more severe messages
journalctl -p err

# Warnings and more severe messages
journalctl -p warning

# Error-level messages from the current boot
journalctl -b -p err

# Nginx errors from the last hour
journalctl -u nginx -p err --since "1 hour ago"
```



---

### 9. Filtering by Executable and Fields

```bash
# Logs associated with an executable
journalctl /usr/bin/sudo

# Filter by service unit field
journalctl _SYSTEMD_UNIT=nginx.service

# Filter by process ID
journalctl _PID=1234

# Display structured JSON
journalctl -o json-pretty -n 5

# Display machine-readable JSON records
journalctl -o json -n 100
```

The executable path must match the executable recorded in the journal.

---

### 10. Log Rotation and Retention

Logs must be managed carefully to prevent excessive disk consumption.

```bash
# Display journal disk usage
journalctl --disk-usage

# Reduce archived journal storage to approximately 1 GB
sudo journalctl --vacuum-size=1G

# Remove archived journal files older than seven days
sudo journalctl --vacuum-time=7d
```

Vacuum commands remove archived journal files, not necessarily every entry in the active journal file.

Important journald settings include:

* `Storage=` — Controls journal storage behavior.
* `SystemMaxUse=` — Limits persistent journal disk usage.
* `SystemKeepFree=` — Specifies filesystem space to keep free.
* `MaxRetentionSec=` — Sets a maximum retention period.

Inspect configuration with:

```bash
man journald.conf
man journalctl
man systemd.journal-fields
```



---

## 🛠️ Hands-On Practice (1.5 Hours)

### Task 1: Inspect the Journal

```bash
journalctl --list-boots
journalctl --disk-usage
journalctl -n 50 --no-pager
```

Observe the timestamps, messages, and service information.

---

### Task 2: Investigate a Service

```bash
systemctl --failed
systemctl status nginx
journalctl -u nginx -n 50 --no-pager
```

If Nginx is not installed, use a service available on your Linux environment.

---

### Task 3: Find Recent Errors

```bash
sudo journalctl -p err --since "1 hour ago"
sudo journalctl -u nginx -p err --since "1 hour ago"
```

Identify any error messages and determine what they suggest.

---

### Task 4: Export Structured Logs

```bash
journalctl -o json-pretty -n 5
journalctl -u nginx -o short-iso -n 20
```

Observe the difference between structured JSON and human-readable output.

---

### Task 5: Create the Log Investigator

Create the script:

```bash
nano log_investigator.sh
```

Paste the following code:

```bash
#!/usr/bin/env bash

set -u

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 SERVICE SINCE UNTIL"
    echo 'Example: $0 nginx "1 hour ago" now'
    exit 1
fi

SERVICE="$1"
SINCE="$2"
UNTIL="$3"

if ! command -v journalctl >/dev/null 2>&1; then
    echo "Error: journalctl is not available."
    exit 1
fi

TMP_LOG=$(mktemp) || exit 1
TMP_ERR=$(mktemp) || {
    rm -f "$TMP_LOG"
    exit 1
}

trap 'rm -f "$TMP_LOG" "$TMP_ERR"' EXIT

echo "=================================="
echo "       LOG INVESTIGATOR"
echo "=================================="
echo "Service : $SERVICE"
echo "Since   : $SINCE"
echo "Until   : $UNTIL"
echo

if ! journalctl -u "$SERVICE" \
    --since "$SINCE" \
    --until "$UNTIL" \
    --no-pager -o short-iso >"$TMP_LOG"; then
    echo "Error: Unable to retrieve service logs."
    exit 1
fi

if ! journalctl -u "$SERVICE" -p err \
    --since "$SINCE" \
    --until "$UNTIL" \
    --no-pager -o short-iso >"$TMP_ERR"; then
    echo "Error: Unable to retrieve error-level logs."
    exit 1
fi

TOTAL=$(wc -l < "$TMP_LOG")
ERRORS=$(wc -l < "$TMP_ERR")

echo "Total entries   : $TOTAL"
echo "Error-or-higher : $ERRORS"
echo

if (( TOTAL == 0 )); then
    echo "No matching journal entries found."
    echo "Check the service name and time range."
    exit 0
fi

echo "----- ERROR SUMMARY -----"

if (( ERRORS == 0 )); then
    echo "No error-or-higher entries found."
else
    cat "$TMP_ERR"
fi

echo
echo "----- LATEST 10 ENTRIES -----"
tail -n 10 "$TMP_LOG"

echo
echo "----- INVESTIGATION COMPLETE -----"
```

---

### Task 6: Execute the Script

```bash
chmod +x log_investigator.sh

./log_investigator.sh nginx "1 hour ago" now
```

Test a fixed time window:

```bash
./log_investigator.sh nginx \
    "2026-10-09 09:00:00" \
    "2026-10-09 12:00:00"
```

If permission is denied:

```bash
sudo ./log_investigator.sh nginx "1 hour ago" now
```

---

### Expected Output Format

Actual values depend on your system.

```text
==================================
       LOG INVESTIGATOR
==================================
Service : nginx
Since   : 1 hour ago
Until   : now

Total entries   : 25
Error-or-higher : 3

----- ERROR SUMMARY -----
[Matching error-level journal entries]

----- LATEST 10 ENTRIES -----
[Most recent journal entries]

----- INVESTIGATION COMPLETE -----
```

The numbers above are illustrative. The script does not create errors or guarantee that matching records exist.



---

## ☁️ Cloud Engineering Applications

### AWS EC2 Troubleshooting

When an application on an EC2 instance fails:

1. Connect to the instance.
2. Check service status using `systemctl`.
3. Query journal entries around the failure timestamp.
4. Filter errors by service and priority.
5. Compare application failures with deployment or infrastructure events.
6. Identify the likely root cause and verify the fix.

---

### Production Incident Investigation

For a service returning HTTP 500 errors:

1. Establish the incident time window.
2. Investigate the application and web server logs.
3. Look for configuration failures, unavailable dependencies, permission problems, or resource exhaustion.
4. Correlate findings with monitoring metrics and deployment events.
5. Document the evidence, corrective action, and verification results.

For long-term production observability, journal logs may also need to be forwarded to a centralized logging platform such as Amazon CloudWatch Logs.

---

## ✅ Day 26 Completion Checklist

* [ ] Understood `systemd-journald` and the journal architecture.
* [ ] Compared persistent and volatile journal storage.
* [ ] Queried logs using `journalctl`.
* [ ] Investigated current and previous boot records.
* [ ] Filtered logs by service and time range.
* [ ] Understood all eight journal priority levels.
* [ ] Exported journal records as JSON.
* [ ] Inspected journal disk usage and retention controls.
* [ ] Created `log_investigator.sh`.
* [ ] Tested the script with valid and empty-result scenarios.

---

## 📦 Deliverable




* Structured log querying
* Service and time-based filtering
* Bash automation
* Error investigation
* Operational observability fundamentals

---

## 🧠 Key Takeaways

* Logs provide evidence for diagnosing system failures.
* `journalctl` is one of the most useful tools for troubleshooting systemd-based Linux systems.
* Time and service filters reduce investigation noise.
* Persistent storage helps preserve evidence across reboots.
* Log retention must balance storage limits and investigation requirements.
* Automation makes routine incident investigation faster and more consistent.



---

---

## Day 223/1000 — System Snapshot & Comprehensive Monitoring
**Date:** October 10, 2026 (Calendar: October 10, 2026 (Saturday))

---

## 🎯 Objective

Build a reusable Linux monitoring tool that captures CPU, memory, disk, network, and process information and supports periodic collection and historical analysis.

---

## 📚 Concepts Learned

- **Observability Stacks**: Prometheus, Grafana, ELK Stack, and Splunk architectures.
- **USE Method**:
  - **Utilization**: Time resource was busy (e.g. `%util`, CPU usage).
  - **Saturation**: Work queued waiting for resource (e.g. `load average`, `aqu-sz`, runnable `r`).
  - **Errors**: Device or software errors (e.g. TCP retransmits, disk read errors).
- **RED Method**:
  - **Rate**: Requests/operations per second.
  - **Errors**: Number of failed requests.
  - **Duration**: Time taken per request/operation (latency).
- **Diagnostics Utilities**: Advanced real-time exploration via `glances` and `dstat`.
- **System Metrics Correlation**: Correlating CPU load, RAM available, disk I/O latency, TCP connection states, and top resource consumers.
- **Automated Telemetry**: Periodic snapshot capture via `cron` and trend evaluation.

---

## 🛠️ Hands-On Work

- [x] Installed and explored system monitoring tools (`glances`, `dstat`, `sysstat`).
- [x] Architected and implemented `system_snapshot.sh` capturing unified host telemetry.
- [x] Captured system health snapshots under varying load conditions.
- [x] Configured 10-minute automated periodic collection via `cron`.
- [x] Created `daily_report.sh` to parse and summarize historical snapshots.
- [x] Compared multiple snapshots across time windows to detect resource trends and leaks.

---

## 📦 Deliverables

- `system_snapshot.sh`
- `daily_report.sh`
- Timestamped system snapshots (`/var/log/snapshots/` / `~/snapshots/`)
- Cron-based automated telemetry collection configuration

---

## 🧠 Key Takeaway

> Monitoring is not just collecting metrics. It is understanding how resource utilization, saturation, and errors affect application performance and using historical observations to diagnose problems.

---

## 🚀 Next Steps

Improve the collector with structured JSON output, explicit error tracking, log retention, and automated threshold-based alerts.

---

## Day 224/1000 — Troubleshooting Methodology & Case Studies
**Date:** October 11, 2026 (Calendar: October 11, 2026 (Sunday))

## Day 28/30 — Mastering Linux









---

## 1. Learning Objectives

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

## 2. Theory — Troubleshooting Methodology

### 2.1 The Five-Stage Troubleshooting Framework

Professional troubleshooting follows a systematic process.

#### Stage 1: Define the Problem

Clearly identify the failure before attempting a fix.

Questions:

- What exactly is failing?
- When did the problem begin?
- Which users or services are affected?
- Did a recent deployment or configuration change occur?
- Can the problem be reproduced?

Example:

An API that normally responds in 200 milliseconds now takes five seconds.

#### Stage 2: Measure

Collect evidence before modifying the system.

```bash
uptime
free -h
df -h
vmstat 1 5
```

Check:

- CPU utilization.
- Memory availability.
- Disk space.
- I/O activity.
- System load.
- Process behavior.

#### Stage 3: Analyze

Compare the collected evidence and investigate possible explanations.

Examples:

- High load with low CPU usage may indicate I/O waits.
- High memory pressure may lead to swapping.
- A failed file write may indicate permissions or storage exhaustion.
- High CPU usage may indicate a busy loop or expensive computation.

Do not assume that one metric proves the cause.

#### Stage 4: Improve

Apply a targeted correction.

Examples:

- Correct file permissions.
- Investigate and resolve disk-space exhaustion.
- Reduce unnecessary disk writes.
- Fix inefficient application logic.
- Correct service configuration.

Avoid making unrelated changes during an incident.

#### Stage 5: Verify

Repeat the measurements after applying the fix.

```bash
uptime
vmstat 1 5
free -h
df -h
```

Also verify application behavior, service health, and relevant logs.

A successful command does not automatically mean the incident is resolved.

### 2.2 Systematic Debugging vs Random Debugging

| Systematic Debugging                          | Random Debugging             |
| --------------------------------------------- | ---------------------------- |
| Collects evidence first                       | Changes settings immediately |
| Tests a specific hypothesis                   | Tries unrelated commands     |
| Changes one variable at a time when practical | Changes multiple variables   |
| Records the original symptoms                 | Loses important evidence     |
| Verifies the result                           | Assumes the fix worked       |
| Investigates root causes                      | Often treats symptoms only   |



---

## 3. Understanding Linux Load Average

Linux load average measures the average number of tasks that are runnable or waiting in uninterruptible sleep.

```bash
uptime
cat /proc/loadavg
nproc
```

The three load-average values represent approximately:

- The last 1 minute.
- The last 5 minutes.
- The last 15 minutes.

Runnable tasks compete for CPU time. Tasks in uninterruptible sleep are commonly waiting for I/O.

For example, a load average of 12 has different implications on a 2-vCPU system and a 16-vCPU system.

High load does not always mean high CPU utilization.

Possible causes include:

- CPU contention.
- Disk I/O bottlenecks.
- Tasks blocked in uninterruptible sleep.
- Memory pressure and swapping.
- Storage or device problems.

---

## 4. Case Study 1 — High Load with Low CPU Usage

### Scenario

A Linux server reports:

```text
Load average: 12.50, 11.80, 10.90
CPU utilization: 15%
```

The machine has a high load average, but most CPU capacity appears idle.

### Step 1: Check the System Load

```bash
uptime
nproc
cat /proc/loadavg
```

Compare load average against the available CPU count.

### Step 2: Investigate with vmstat

```bash
vmstat 1 5
```

Important columns:

| Column | Meaning                             |
| ------ | ----------------------------------- |
| `r`    | Runnable tasks                      |
| `b`    | Tasks in uninterruptible sleep      |
| `si`   | Swap-in activity                    |
| `so`   | Swap-out activity                   |
| `wa`   | CPU time idle while waiting for I/O |
| `us`   | User CPU time                       |
| `sy`   | System CPU time                     |

The first report may include averages since boot. Focus on subsequent interval reports for current behavior.

### Step 3: Check Disk I/O

```bash
iostat -xz 1 5
```

If `iostat` is unavailable, install the `sysstat` package using the appropriate package manager.

Important metrics:

- `r/s`: Read operations per second.
- `w/s`: Write operations per second.
- `rkB/s`: Read throughput.
- `wkB/s`: Write throughput.
- `await`: Average I/O completion time, including queueing.
- `aqu-sz`: Average outstanding I/O queue length.
- `%util`: Device busy time.

Interpret these metrics according to the device type and workload. No single metric proves that storage is the bottleneck.

### Step 4: Identify Processes Generating I/O

```bash
pidstat -d 1 5
pidstat -r 1 5
ps -eo pid,stat,comm,wchan:24 | head -20
```

The first command reports per-process I/O activity. The second reports memory-related statistics.

A process in `D` state is in uninterruptible sleep. It may be waiting for a kernel operation to complete.

### Possible Root Causes

- Heavy disk reads or writes.
- Slow storage.
- Memory pressure causing swapping.
- Many blocked processes.
- An inefficient workload.

### Potential Solutions

- Reduce unnecessary disk operations.
- Investigate storage latency.
- Optimize the workload.
- Investigate memory pressure and excessive allocation.
- Check for device or filesystem errors.

### Verification

Repeat the measurements:

```bash
uptime
vmstat 1 5
iostat -xz 1 5
pidstat -d 1 5
```

Confirm that the suspected bottleneck has improved.

---

## 5. Case Study 2 — A Process Cannot Write a File

### Scenario

An application attempts to write to:

```text
/var/log/myapp/app.log
```

The application reports:

```text
Permission denied
```

### Step 1: Check Permissions

```bash
ls -ld /var/log/myapp
ls -l /var/log/myapp/app.log
id
namei -l /var/log/myapp/app.log
```

`namei -l` displays the permissions of each component in the file path.

A process needs execute permission on directories it traverses and appropriate permissions on the target file. Creating a new file requires write and execute permissions on the parent directory.

### Step 2: Check Disk Space

```bash
df -h /var/log
df -i /var/log
```

- `df -h` checks available filesystem space.
- `df -i` checks available inodes.

A filesystem may have free storage capacity but no free inodes.

### Step 3: Check Mount Status

```bash
findmnt -T /var/log/myapp/app.log
```

Investigate whether the filesystem is mounted read-only.

### Step 4: Trace File-Opening System Calls

```bash
sudo strace -e trace=openat -p <PID>
```

Replace `<PID>` with the actual process ID.

Reproduce the failure and inspect the output for errors such as `EACCES` or `ENOSPC`.

Attaching a tracer to a production process can affect timing, so use it cautiously.

### Step 5: Inspect Open Files

```bash
sudo lsof /var/log/myapp/app.log
```

For a small directory, you can also use:

```bash
sudo lsof +D /var/log/myapp
```

The recursive directory search can be expensive on large directory trees.

### Common Errors

| Error    | Meaning                               |
| -------- | ------------------------------------- |
| `EACCES` | Permission or access-control failure  |
| `ENOSPC` | No space or inode capacity available  |
| `EROFS`  | Filesystem is read-only               |
| `EDQUOT` | User or group quota exceeded          |
| `EMFILE` | Process file-descriptor limit reached |
| `ENFILE` | System-wide file table exhaustion     |

### Potential Solutions

- Correct the service account's permissions.
- Fix directory ownership or group membership.
- Investigate ACLs or security policies.
- Free disk space safely.
- Investigate inode exhaustion.
- Correct filesystem mount problems.
- Investigate file-descriptor limits when applicable.

Avoid using `chmod 777` as a general solution.

### Verification

Repeat the write operation using the intended service account and confirm that the application works correctly.

---

## 6. Case Study 3 — Many TCP TIME_WAIT Connections

### Understanding TCP States







### Step 1: Inspect Connection Counts

```bash
ss -s
ss -tan | grep -c TIME-WAIT
ss -tan state time-wait
```

Inspect connections involving a specific application port:

```bash
ss -tan '( sport = :8080 or dport = :8080 )'
```

Replace port `8080` with the actual port.

### Step 2: Investigate the Cause

Possible explanations:

- Many short-lived client connections.
- High request volume.
- Frequent connection creation.
- Application retries.
- Poor connection reuse.
- Ephemeral port exhaustion.

A large number of `TIME_WAIT` connections is not automatically a failure.

### Step 3: Potential Solutions

- Reuse connections when appropriate.
- Configure sensible connection pooling.
- Investigate excessive retries.
- Check whether ephemeral ports are actually being exhausted.
- Review client and server connection patterns.

Linux provides the `net.ipv4.tcp_tw_reuse` setting, but changing it blindly is not recommended. Its behavior depends on kernel and configuration details, and it is not a universal fix.

Avoid attempting to force-close all `TIME_WAIT` connections.

### Verification

```bash
ss -s
ss -tan state time-wait
```

Check application errors, connection availability, and request latency before and after the correction.

---

## 7. Case Study 4 — Mystery High-CPU Process

### Scenario

CPU utilization suddenly reaches 95%.

The objective is to identify the responsible process and understand its behavior.

### Step 1: Find the Process

```bash
top
```

Press `P` in `top` to sort by CPU utilization.

Alternatively:

```bash
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -15
pidstat -u 1 5
```

Record:

- Process ID.
- Parent process.
- CPU usage.
- Memory usage.
- Command name.

Do not terminate a process simply because its CPU usage is high.

### Step 2: Use strace

```bash
sudo strace -c -p <PID>
```

Allow the tracer to run briefly, then press `Ctrl+C` to stop tracing.

The summary can reveal frequently used system calls and the time attributed to them.

For detailed timing:

```bash
sudo strace -tt -T -p <PID>
```

- `-tt` adds timestamps.
- `-T` displays time spent in each system call.
- `-c` summarizes system-call statistics.

`strace` adds overhead. It also cannot fully explain CPU time spent executing user-space calculations without system calls.

### Step 3: Use perf

If `perf` is installed and supported:

```bash
sudo perf top -p <PID>
```

For a short profiling sample:

```bash
sudo perf record -g -p <PID> -- sleep 10
sudo perf report
```

`perf` can help identify hot functions and execution paths.

Available details depend on permissions, symbols, kernel configuration, and debug information.

### Possible Root Causes

- Infinite loop.
- Excessive request volume.
- Expensive calculations.
- Inefficient algorithm.
- Unnecessary background jobs.
- Excessive kernel work.

### Potential Solutions

- Fix inefficient code.
- Correct unexpected retry loops.
- Optimize algorithms.
- Investigate traffic spikes.
- Adjust workload scheduling.
- Allocate resources appropriately when justified.

### Verification

```bash
top
pidstat -u 1 5
```

Compare CPU usage and application behavior after applying the fix.

---

## 8. Case Study 5 — Application Slow Despite Healthy Infrastructure

### Scenario

The server shows:

- CPU utilization around 20%.
- Available memory.
- Normal disk latency.
- API latency of five seconds instead of 200 milliseconds.

The server may not be the bottleneck.

### Step 1: Check Service Health

```bash
systemctl status myapp
journalctl -u myapp --since "15 minutes ago"
```

Replace `myapp` with the actual service name.

### Step 2: Check Listening Ports

```bash
ss -lntp
ss -tan
```

Check whether the application is listening on the expected address and port.

### Step 3: Check DNS and HTTP Latency

```bash
getent hosts example.com
curl -sS -o /dev/null -w 'HTTP %{http_code} total=%{time_total}s\n' https://example.com
```

Use an appropriate test endpoint for the environment.

A successful DNS lookup or HTTP request does not prove that every network path is healthy.

### Step 4: Investigate External Dependencies

Check:

- Database latency.
- External API latency.
- Connection pool exhaustion.
- Thread or lock contention.
- Slow DNS resolution.
- Excessive retries.
- Recent deployments.

### Step 5: Measure the Request Path

Measure latency across the client, load balancer, application, database, and external dependencies.

Compare measurements over the same time window.

### Potential Solutions

- Optimize slow database queries.
- Fix inefficient application logic.
- Correct connection pool settings.
- Investigate external service delays.
- Reduce unnecessary network requests.
- Resolve retry storms.

### Verification

Repeat the request under comparable conditions and confirm that latency has returned to an acceptable range.

---

## 9. Case Study 6 — Disk Space or Inode Exhaustion

### Scenario

An application cannot create new files, or a service fails because the filesystem is full.

### Step 1: Check Disk Space

```bash
df -h
```

### Step 2: Check Inodes

```bash
df -i
```

### Step 3: Identify Large Directories

```bash
sudo du -xhd1 /var 2>/dev/null
```

This command is suitable for GNU `du` implementations, including common Linux distributions.

### Step 4: Identify Large Files

```bash
sudo find /var/log -xdev -type f -size +100M -print
```

Review the files before deleting or truncating anything.

### Step 5: Investigate Open but Deleted Files

```bash
sudo lsof +L1
```

A deleted file may still consume disk space while a process holds it open.

### Potential Solutions

- Fix excessive log generation.
- Configure log rotation and retention.
- Remove verified, unnecessary files.
- Investigate open deleted files.
- Resolve inode exhaustion.
- Expand storage when justified.

Do not blindly delete active application files or logs.

### Verification

```bash
df -h
df -i
```

Check that the application can create files and that storage utilization remains under control.

---

## 10. Root Cause Analysis — The Five Whys

The Five Whys technique helps identify the underlying cause instead of stopping at the initial symptom.

### Example: Application Cannot Write Logs




*Evidence:* The application reports `ENOSPC`.


*Evidence:* `df -h` reports 100% usage.


*Evidence:* Directory usage measurements show excessive log storage.


*Evidence:* The journal contains repeated error messages.


*Evidence:* The error began after deployment and monitoring did not alert on abnormal log growth.

### Corrective Actions

- Fix the exception loop.
- Restore appropriate log rotation and retention.
- Reclaim disk space safely.
- Add alerts for filesystem usage.
- Add tests to catch repeated error conditions.

The fifth Why is not automatically the correct answer. Each step must be supported by evidence, and incidents may have multiple contributing causes.

---

## 11. Essential Troubleshooting Commands

| Problem            | Commands                                 |
| ------------------ | ---------------------------------------- |
| High load          | `uptime`, `vmstat 1 5`                   |
| Disk I/O           | `iostat -xz 1 5`, `pidstat -d 1 5`       |
| Memory pressure    | `free -h`, `vmstat 1 5`                  |
| Process memory     | `pidstat -r 1 5`                         |
| High CPU           | `top`, `pidstat -u 1 5`                  |
| System calls       | `strace -e trace=openat,write command`   |
| Open files         | `lsof /path/to/file`                     |
| TCP connections    | `ss -s`, `ss -tan`                       |
| Service errors     | `systemctl status SERVICE`               |
| Service logs       | `journalctl -u SERVICE`                  |
| Kernel logs        | `journalctl -k --since "15 minutes ago"` |
| Disk capacity      | `df -h`, `df -i`                         |
| Large directories  | `du -xhd1 /var`                          |
| Deleted open files | `lsof +L1`                               |
| CPU profiling      | `perf top -p PID`                        |

Some commands require elevated privileges or additional packages, such as `sysstat`, `lsof`, and `perf`.

Use tracing and profiling cautiously on production systems.

---

## 12. Hands-On Lab

Complete the following exercises in a Linux environment.

### Exercise 1: System Inspection

```bash
uptime
nproc
free -h
df -h
vmstat 1 5
```

Record the system load, available memory, disk usage, and relevant observations.

### Exercise 2: Disk Activity

```bash
iostat -xz 1 5
pidstat -d 1 5
```

Identify any processes generating significant I/O.

### Exercise 3: Trace System Calls

```bash
strace -e trace=openat,read,write ls /tmp 2>&1 | head -50
```

Observe file-opening, reading, and writing system calls.

### Exercise 4: Inspect Open Files

```bash
lsof -p <PID>
```

Replace `<PID>` with a process you own or are authorized to inspect.

### Exercise 5: Inspect TCP Connections

```bash
ss -s
ss -tan state time-wait
```

Explain why `TIME_WAIT` connections are not automatically a problem.

### Exercise 6: Create and Diagnose a File-Write Failure

Create a test directory and file:

```bash
mkdir -p ~/linux-debug-lab
touch ~/linux-debug-lab/test.log
chmod 400 ~/linux-debug-lab/test.log
```

Attempt to append data:

```bash
echo "test message" >> ~/linux-debug-lab/test.log
```

Inspect permissions:

```bash
ls -l ~/linux-debug-lab/test.log
namei -l ~/linux-debug-lab/test.log
```

Trace the operation:

```bash
strace -e trace=openat,write bash -c 'echo test >> ~/linux-debug-lab/test.log'
```

Look for `EACCES`.

Correct the permissions and verify:

```bash
chmod u+w ~/linux-debug-lab/test.log
echo "test message" >> ~/linux-debug-lab/test.log
cat ~/linux-debug-lab/test.log
```

This exercise demonstrates the troubleshooting lifecycle: reproduce, observe, diagnose, fix, and verify.

---

## 13. Troubleshooting Playbook Deliverable



Create a reusable document containing at least six scenarios:

1. High load with low CPU usage.
2. Process cannot write a file.
3. Excessive TCP `TIME_WAIT` connections.
4. Unexpected high CPU usage.
5. Slow application with apparently healthy infrastructure.
6. Disk-space or inode exhaustion.

---

## 14. Knowledge Check

1. Why can Linux load average be high while CPU utilization is low?
2. What do `r`, `b`, `si`, `so`, and `wa` indicate in `vmstat`?
3. What is the difference between `strace`, `lsof`, and `perf`?
4. What does `EACCES` mean?
5. Why should both `df -h` and `df -i` be checked?
6. Why is a high `TIME_WAIT` count not automatically an error?
7. What is the difference between a symptom and a root cause?
8. Why can an application be slow when CPU and disk metrics look healthy?
9. Why should production processes be traced cautiously?
10. What are the five stages of systematic troubleshooting?

---

## 15. Learning Resources

- `man strace`
- `man lsof`
- `man perf`
- `man vmstat`
- `man iostat`
- `man pidstat`
- `man ss`
- Red Hat Enterprise Linux Troubleshooting Guide
- Linux manual pages and kernel documentation

---

## 16. Day 224 Completion Checklist

- [x] Learned the five-stage troubleshooting framework.
- [x] Understood Linux load average.
- [x] Practiced `vmstat`, `iostat`, and `pidstat`.
- [x] Investigated file-write failures.
- [x] Understood TCP `TIME_WAIT`.
- [x] Practiced process inspection with `top`.
- [x] Learned introductory `strace` and `perf`.
- [x] Applied the Five Whys technique.
- [x] Completed the file-write failure lab.
- [x] Created `troubleshooting_playbook.md`.
- [x] Recorded actual observations and verification results.

---

## 17. Key Takeaways

- High load does not always mean high CPU utilization.
- `vmstat`, `iostat`, and `pidstat` help identify performance bottlenecks.
- `strace` reveals system-call behavior and errors.
- `lsof` identifies open files and sockets.
- `perf` helps investigate CPU hotspots.
- `TIME_WAIT` is a normal TCP state.
- File-write failures can involve permissions, disk capacity, inodes, quotas, or file-descriptor limits.
- Application latency may originate in external dependencies rather than the host itself.
- Root cause analysis prevents recurring incidents.
- A fix is not complete until recovery has been verified.

**Day 224 Motto: Don't guess at the failure. Collect evidence, identify the root cause, fix it safely, and verify the result.**

---

