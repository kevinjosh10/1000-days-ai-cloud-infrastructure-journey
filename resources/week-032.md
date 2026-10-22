# Week 32 Resources: Linux Performance Profiling, Observability & Troubleshooting

## 📅 Timeline: Days 218 - 224 (October 5, 2026 – October 11, 2026)

---

## Day 218 — Day 22 / 30 — CPU Monitoring & Profiling
- **Date:** 2026-10-05 (Calendar: October 5, 2026 (Monday))

```bash
vmstat 1
```

```text
us   sy   id   wa   st
```

```text
us  sy  id  wa
70  10  15   5
```

```bash
uptime
```

```text
load average: 1.20, 0.85, 0.60
```

```text
1 minute
5 minutes
15 minutes
```

```bash
nproc
```

```text
4
```

```text
Load = 1
CPU  = 4
```

```text
Load = 8
CPU  = 4
```

```bash
vmstat 1
```

```text
r
b
```

```text
r = 10
b = 0
```

```text
r = 1
b = 20
```

```bash
lscpu
```

```text
Architecture
CPU(s)
Thread(s) per core
Core(s) per socket
Socket(s)
Model name
```

```bash
nproc
```

```bash
vmstat 1
```

```bash
vmstat 1 10
```

```text
1 second interval
10 samples
```

```text
procs
memory
swap
io
system
cpu
```

```text
us
sy
id
wa
st
```

```bash
sudo apt update
sudo apt install sysstat
```

```bash
mpstat 1
```

```bash
mpstat -P ALL 1
```

```text
CPU    %usr   %sys   %idle
all    20.0    5.0    75.0
0      10.0    5.0    85.0
1      40.0    5.0    85.0
2      15.0    5.0    80.0
3      15.0    5.0    80.0
```

```bash
top
```

```text
%Cpu(s)
```

```bash
top -b -n1 | head -20
```

```bash
ps aux --sort=-%cpu | head -10
```

```text
USER   PID   %CPU   %MEM   COMMAND
root   321   92.4    1.2   ./worker
root   412   44.1    0.8   python3 app.py
user   512   15.2    2.1   java
```

```bash
sudo apt install stress-ng
```

```bash
nproc
```

```bash
stress-ng --cpu $(nproc)
```

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

```bash
vmstat 1
```

```bash
top
```

```text
CPU usage ↑
Idle CPU ↓
Runnable processes ↑
```

```bash
sar --version
```

```bash
sar -u 1 5
```

```text
-u → CPU statistics
1  → every 1 second
5  → five samples
```

```bash
vmstat 1
```

```text
cs
```

```bash
lscpu
```

```bash
nproc
```

```text
Architecture:
CPU Count:
CPU Model:
Cores:
Threads:
```

```bash
vmstat 1
```

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

```bash
mpstat -P ALL 1
```

```bash
top -b -n1 | head -20
```

```bash
ps aux --sort=-%cpu | head -10
```

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

```bash
vmstat 1
```

```text
us ↑
id ↓
r ↑
```

```bash
sar -u 1 5
```

```text
Average user CPU:
Average system CPU:
Average idle CPU:
Average I/O wait:
```

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

```text
CPU count = 8
Load average = 9.5
```

```bash
vmstat 1
```

```text
r  = 10
b  = 0
us = 85
sy = 10
id = 5
wa = 0
```

```bash
ps aux --sort=-%cpu | head
```

```text
python3 worker.py    380% CPU
```

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

```text
Load average = 9.5
```

```text
us = 10
sy = 5
id = 5
wa = 80
```

```text
Disk
Storage
Filesystem
Database I/O
Network storage
```

```bash
nano cpu_profiler.sh
```

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

```bash
chmod +x cpu_profiler.sh
```

```bash
./cpu_profiler.sh
```

```bash
mkdir -p "$HOME/cpu-profiles"
```

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

```text
~/cpu-profiles/cpu_20261005_141530.log
```

```bash
./cpu_profiler.sh
```

```text
CPU count:
Load:
User CPU:
System CPU:
Idle:
I/O wait:
Top CPU process:
```

```bash
stress-ng --cpu $(nproc) --timeout 30s
```

```bash
vmstat 1
```

```bash
mpstat -P ALL 1
```

```text
Most utilized CPU:
Least utilized CPU:
Average CPU utilization:
```

```text
I/O wait
Blocked processes
Uninterruptible sleep
Storage bottlenecks
```

```text
cpu_profiler.sh
```

```text
High CPU ≠ Always the problem
High Load ≠ Always CPU
High wa ≠ CPU bottleneck
```

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

---

## Day 219 — Day 23 — Memory Monitoring & Management
- **Date:** October 6, 2026 (Tuesday) [Inferred chronologically]

```text
Application Memory + Empty Memory
```

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

```text
available
```

```text
RSS = 500 MB
```

```bash
ps aux
```

```text
USER   PID  %CPU %MEM    VSZ    RSS
root   123   5.0  4.2 900000 420000
```

```text
VSZ ≠ actual RAM consumption
```

```text
VSZ = 2 GB
RSS = 400 MB
```

```text
Process A ─────┐
               ├── Shared Library ── RAM
Process B ─────┘
```

```bash
free -h
```

```text
               total   used   free   shared  buff/cache  available
Mem:            7.7Gi   2.1Gi  1.2Gi    200Mi    4.4Gi       5.1Gi
Swap:           2.0Gi   100Mi  1.9Gi
```

```bash
free -h -w
```

```text
               total  used  free  shared  buff  cache  available
Mem:            7.7G   2.2G  1.1G  200M    150M  4.3G   5.0G
Swap:           2.0G   100M  1.9G
```

```bash
free -h
```

```bash
free -h -w
```

```bash
ps aux --sort=-%mem | head -20
```

```text
USER       PID %CPU %MEM    VSZ   RSS COMMAND
mysql     1240  2.1 12.4  ...   ... mysqld
node      2310  1.2  8.7  ...   ... node
root      1000  0.4  4.2  ...   ... python
```

```bash
top
```

```text
M
```

```bash
vmstat 1
```

```text
RAM → Disk
Disk → RAM
```

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

```text
             MEMORY
                │
        ┌───────┴───────┐
        │               │
       RAM             SWAP
      Fast              Slow
```

```bash
swapon -s
```

```bash
cat /proc/swaps
```

```bash
swapon --show
```

```text
si > 0
so > 0
```

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

```text
RAM = 8 GB
Swap = 0
```

```text
10 GB
```

```text
Memory Pressure
      ↓
Allocation failures
      ↓
OOM condition
      ↓
OOM Killer
```

```text
Recover memory
      ↓
Keep the system alive
```

```bash
cat /proc/sys/vm/overcommit_memory
```

```bash
cat /proc/<PID>/oom_score
```

```bash
cat /proc/<PID>/oom_score_adj
```

```bash
cat /proc/pressure/memory
```

```text
some avg10=0.00 avg60=0.00 avg300=0.00 total=...
full avg10=0.00 avg60=0.00 avg300=0.00 total=...
```

```bash
sudo apt update
sudo apt install stress-ng
```

```bash
stress-ng --vm 2 --vm-bytes 50%
```

```bash
watch -n 1 free -h
```

```bash
vmstat 1
```

```bash
cat /proc/pressure/memory
```

```bash
sudo dmesg | grep -Ei 'out of memory|killed process|oom'
```

```bash
journalctl -k | grep -Ei 'oom|out of memory|killed process'
```

```text
Nginx
   ↓
Node.js API
   ↓
Python ML Worker
```

```bash
free -h
ps aux --sort=-%mem | head -20
journalctl -k | grep -Ei 'oom|killed process'
```

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

```bash
chmod +x mem_profiler.sh
```

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

## Day 220 — Day 24 / 30 — Disk I/O Monitoring
- **Date:** October 7, 2026 (Wednesday) [Inferred chronologically]

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

```bash
sudo apt update && sudo apt install -y sysstat
```

```bash
iostat -x 1
```

```bash
iostat -xz 1 5
```

```text
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm  r_await  w_await   aqu-sz  rareq-sz  wareq-sz  svctm  %util
nvme0n1         12.00   85.00   1024.00   4096.00     0.00    15.00   0.00  15.00     0.45     1.20     0.10     85.33     48.18   0.15   2.50
```

```bash
sudo apt install -y iotop
```

```bash
sudo iotop
```

```bash
sudo iotop -o
```

```bash
sudo iotop -b -n 3 -o
```

```bash
pidstat -d 1 5
```

```text
UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
1000     4512   5120.00   1024.00      0.00      12  postgres
1000     8921      0.00   8192.00      0.00      45  python3
```

```bash
cat /sys/block/sda/queue/scheduler
```

```bash
echo mq-deadline | sudo tee /sys/block/sda/queue/scheduler
```

```bash
sudo apt install -y fio
```

```bash
fio --name=seq-write --ioengine=libaio --rw=write --bs=1M --size=512M --numjobs=1 --direct=1 --filename=/tmp/fio-test.img --group_reporting
```

```bash
fio --name=rand-read --ioengine=libaio --rw=randread --bs=4k --size=512M --numjobs=4 --direct=1 --filename=/tmp/fio-test.img --group_reporting
```

```bash
rm -f /tmp/fio-test.img
```

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

## Day 221 — Day 25/30 — Network Performance & Debugging
- **Date:** 2026-10-08 (Calendar: October 8, 2026 (Thursday))

```text
Mbps
Gbps
MB/s
GB/s
```

```text
8 bits = 1 byte
```

```text
1 Gbps ≈ 125 MB/s
```

```text
Client ───────────────> Server
          20 ms
```

```text
Packets sent:     1000
Packets received: 995
Packets lost:     5
```

```text
Packet 1 ✓
Packet 2 ✓
Packet 3 ✗
Packet 4 ✓
```

```text
Packet 3 → again
```

```text
Socket Statistics
```

```bash
ss
```

```bash
ss -tlnp
```

```text
-t → TCP
-l → Listening
-n → Numeric output
-p → Process information
```

```text
LISTEN  0  128  0.0.0.0:22
```

```bash
ss -anp
```

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

```text
sshd
   ↓
LISTEN
   ↓
Port 22
```

```text
Client
   │
   │ SSH
   ▼
Linux Server

ESTABLISHED
```

```bash
ss -tan | grep TIME_WAIT | wc -l
```

```bash
ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c
```

```text
12 ESTAB
5 LISTEN
27 TIME-WAIT
```

```bash
ping google.com
```

```bash
ping -c 4 google.com
```

```text
Packet loss
Minimum latency
Average latency
Maximum latency
```

```text
4 packets transmitted
4 packets received
0% packet loss
```

```bash
traceroute google.com
```

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

```bash
tracepath google.com
```

```text
ping + traceroute
```

```bash
mtr google.com
```

```text
google.com
     ↓
IP Address
     ↓
142.x.x.x
```

```bash
curl https://example.com
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
dig google.com A
```

```bash
dig google.com AAAA
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

```text
Machine A
    │
    │ Network
    ▼
Machine B
```

```bash
ip addr
```

```bash
ip link
```

```bash
sudo tcpdump -i eth0 -n
```

```bash
sudo tcpdump -i eth0 -n port 80
```

```bash
sudo tcpdump -i eth0 -n port 443
```

```bash
sudo tcpdump -i eth0 -n port 22
```

```bash
sudo tcpdump -i eth0 -n host 192.168.1.10
```

```text
Ctrl+C
```

```bash
ip addr
```

```text
Interface
IPv4 address
IPv6 address
```

```bash
ss -tlnp
```

```text
Port
Process
IP address
State
```

```bash
ss -anp
```

```text
LISTEN
ESTABLISHED
TIME-WAIT
CLOSE-WAIT
```

```bash
ss -tan | grep TIME_WAIT | wc -l
```

```bash
ss -tan | awk 'NR>1 {print $1}' | sort | uniq -c
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
ping -c 4 google.com
```

```text
Packet loss
Minimum latency
Average latency
Maximum latency
```

```bash
traceroute google.com
```

```bash
tracepath google.com
```

```bash
ip link
```

```bash
sudo tcpdump -i <interface> -n
```

```bash
sudo tcpdump -i <interface> -n port 80
```

```text
Ctrl+C
```

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

```bash
#!/bin/bash
```

```bash
hostname
date
```

```bash
ip addr
```

```bash
ss -tlnp
```

```bash
ss -tan
```

```bash
ss -tan | grep TIME_WAIT | wc -l
```

```bash
dig +short google.com
```

```bash
ping -c 4 google.com
```

```bash
traceroute google.com
```

```text
network_report.txt
```

```text
TIME_WAIT connections: 18
STATUS: NORMAL
```

```text
TIME_WAIT connections: 15432
STATUS: INVESTIGATE
```

```text
Connection timeout
```

```bash
ss -tlnp
```

```bash
curl localhost:8080
```

```bash
dig +short api.example.com
```

```bash
ping <destination>
```

```bash
traceroute <destination>
```

```bash
ss -tan
```

```bash
ss -tan | grep TIME_WAIT | wc -l
```

```bash
sudo tcpdump -i <interface> -n port 8080
```

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

```text
network_profiler.sh
network_report.txt
```

```text
"It is slow."
```

```text
"DNS is working.
TCP connection exists.
Latency is 42 ms.
Packet loss is 0%.
There are 18 TIME_WAIT connections.
The service is listening on port 8080.
The network path is healthy."
```

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
- **Date:** October 9, 2026 (Calendar: October 9, 2026 (Friday))

```bash
journalctl --disk-usage
ls -ld /var/log/journal /run/log/journal 2>/dev/null
```

```bash
systemd-analyze cat-config systemd/journald.conf
```

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

```bash
# Display journal disk usage
journalctl --disk-usage

# Reduce archived journal storage to approximately 1 GB
sudo journalctl --vacuum-size=1G

# Remove archived journal files older than seven days
sudo journalctl --vacuum-time=7d
```

```bash
man journald.conf
man journalctl
man systemd.journal-fields
```

```bash
journalctl --list-boots
journalctl --disk-usage
journalctl -n 50 --no-pager
```

```bash
systemctl --failed
systemctl status nginx
journalctl -u nginx -n 50 --no-pager
```

```bash
sudo journalctl -p err --since "1 hour ago"
sudo journalctl -u nginx -p err --since "1 hour ago"
```

```bash
journalctl -o json-pretty -n 5
journalctl -u nginx -o short-iso -n 20
```

```bash
nano log_investigator.sh
```

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

```bash
chmod +x log_investigator.sh

./log_investigator.sh nginx "1 hour ago" now
```

```bash
./log_investigator.sh nginx \
    "2026-10-09 09:00:00" \
    "2026-10-09 12:00:00"
```

```bash
sudo ./log_investigator.sh nginx "1 hour ago" now
```

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

---

## Day 223/1000 — System Snapshot & Comprehensive Monitoring
- **Date:** October 10, 2026 (Calendar: October 10, 2026 (Saturday))

*No standalone code blocks recorded for this day.*

---

## Day 224/1000 — Troubleshooting Methodology & Case Studies
- **Date:** October 11, 2026 (Calendar: October 11, 2026 (Sunday))

```bash
uptime
free -h
df -h
vmstat 1 5
```

```bash
uptime
vmstat 1 5
free -h
df -h
```

```bash
uptime
cat /proc/loadavg
nproc
```

```text
Load average: 12.50, 11.80, 10.90
CPU utilization: 15%
```

```bash
uptime
nproc
cat /proc/loadavg
```

```bash
vmstat 1 5
```

```bash
iostat -xz 1 5
```

```bash
pidstat -d 1 5
pidstat -r 1 5
ps -eo pid,stat,comm,wchan:24 | head -20
```

```bash
uptime
vmstat 1 5
iostat -xz 1 5
pidstat -d 1 5
```

```text
/var/log/myapp/app.log
```

```text
Permission denied
```

```bash
ls -ld /var/log/myapp
ls -l /var/log/myapp/app.log
id
namei -l /var/log/myapp/app.log
```

```bash
df -h /var/log
df -i /var/log
```

```bash
findmnt -T /var/log/myapp/app.log
```

```bash
sudo strace -e trace=openat -p <PID>
```

```bash
sudo lsof /var/log/myapp/app.log
```

```bash
sudo lsof +D /var/log/myapp
```

```bash
ss -s
ss -tan | grep -c TIME-WAIT
ss -tan state time-wait
```

```bash
ss -tan '( sport = :8080 or dport = :8080 )'
```

```bash
ss -s
ss -tan state time-wait
```

```bash
top
```

```bash
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -15
pidstat -u 1 5
```

```bash
sudo strace -c -p <PID>
```

```bash
sudo strace -tt -T -p <PID>
```

```bash
sudo perf top -p <PID>
```

```bash
sudo perf record -g -p <PID> -- sleep 10
sudo perf report
```

```bash
top
pidstat -u 1 5
```

```bash
systemctl status myapp
journalctl -u myapp --since "15 minutes ago"
```

```bash
ss -lntp
ss -tan
```

```bash
getent hosts example.com
curl -sS -o /dev/null -w 'HTTP %{http_code} total=%{time_total}s\n' https://example.com
```

```bash
df -h
```

```bash
df -i
```

```bash
sudo du -xhd1 /var 2>/dev/null
```

```bash
sudo find /var/log -xdev -type f -size +100M -print
```

```bash
sudo lsof +L1
```

```bash
df -h
df -i
```

```bash
uptime
nproc
free -h
df -h
vmstat 1 5
```

```bash
iostat -xz 1 5
pidstat -d 1 5
```

```bash
strace -e trace=openat,read,write ls /tmp 2>&1 | head -50
```

```bash
lsof -p <PID>
```

```bash
ss -s
ss -tan state time-wait
```

```bash
mkdir -p ~/linux-debug-lab
touch ~/linux-debug-lab/test.log
chmod 400 ~/linux-debug-lab/test.log
```

```bash
echo "test message" >> ~/linux-debug-lab/test.log
```

```bash
ls -l ~/linux-debug-lab/test.log
namei -l ~/linux-debug-lab/test.log
```

```bash
strace -e trace=openat,write bash -c 'echo test >> ~/linux-debug-lab/test.log'
```

```bash
chmod u+w ~/linux-debug-lab/test.log
echo "test message" >> ~/linux-debug-lab/test.log
cat ~/linux-debug-lab/test.log
```

---

