# Week 30 Resources

## 🐧 Day 204 / 1000 — Linux Mastery: Day 9 / 30
```text
Program
   │
   │ Execute
   ▼
Process
   │
   ├── PID
   ├── Memory
   ├── File Descriptors
   ├── Environment Variables
   ├── CPU State
   └── Security Credentials
```
```bash
python3 server.py
```
```bash
ps
```
```text
PID   TTY          TIME CMD
421   pts/0    00:00:00 bash
582   pts/0    00:00:00 ps
```
```bash
ps -p 421
```
```bash
ps -p 421 -o pid,ppid,cmd,stat
```
```text
systemd
   │
   └── bash
        │
        └── python
             │
             └── worker
```
```text
PID  = 582
PPID = 421
```
```bash
echo $$
```
```bash
ps -p $$ -o pid,ppid,cmd,stat
```
```bash
pstree -p
```
```text
systemd(1)
├─NetworkManager(500)
├─sshd(700)
│ └─sshd(710)
│   └─bash(720)
│     ├─python(800)
│     └─pstree(801)
└─cron(900)
```
```text
systemd = PID 1
```
```bash
ps -p 1 -o pid,ppid,cmd
```
```bash
ps -p 1 -o comm=
```
```text
systemd
```
```text
Boot
  ↓
Kernel
  ↓
systemd (PID 1)
  ↓
Services
  ↓
Processes
```
```text
SysV init
    ↓
Upstart
    ↓
systemd
```
```text
/etc/init.d/
```
```bash
systemctl
```
```bash
ps aux
```
```text
R
```
```bash
python3 cpu_intensive.py
```
```text
R
```
```text
S
```
```python
import time

while True:
    time.sleep(10)
```
```text
D
```
```text
Process
   ↓
Kernel
   ↓
I/O operation
   ↓
Waiting
```
```bash
ps aux | awk '$8 ~ /D/ {print}'
```
```text
T
```
```bash
sleep 1000
```
```text
Ctrl + Z
```
```bash
ps
```
```text
T
```
```bash
fg
```
```bash
bg
```
```text
Child
  ↓
exit()
  ↓
Zombie
  ↓
Parent calls wait()
  ↓
Zombie removed
```
```text
             fork()
               ↓
          ┌─────────┐
          │ CREATED │
          └────┬────┘
               ↓
          ┌──────────┐
          │ RUNNABLE │
          └────┬─────┘
               ↓
          ┌─────────┐
          │ RUNNING │
          └────┬────┘
               │
       ┌───────┼────────┐
       ↓       ↓        ↓
   sleeping  stopped   exit
       │       │        ↓
       │       │      zombie
       │       │        ↓
       └───────┴──→   wait()
                         ↓
                      REMOVED
```
```text
Parent
  │
 fork()
  │
  ├──────────→ Parent
  │
  └──────────→ Child
```
```text
bash process
     │
    exec()
     ↓
  ls program
```
```text
Parent
  │
  ├── Child
  │
  │   exit()
  │
  └── wait()
        ↓
   collect status
        ↓
   child removed
```
```text
process
   ↓
exit()
   ↓
termination status
   ↓
parent collects status
```
```text
/proc
```
```bash
ls /proc
```
```text
1
2
100
421
582
```
```text
/proc/582/
```
```bash
cat /proc/$$/cmdline
```
```bash
tr '\0' ' ' < /proc/$$/cmdline
echo
```
```bash
tr '\0' '\n' < /proc/$$/environ
```
```text
HOME=/home/kevz
USER=kevz
PATH=...
SHELL=...
PWD=...
```
```bash
ls -l /proc/$$/fd
```
```text
0 = stdin
1 = stdout
2 = stderr
```
```text
0 -> /dev/pts/0
1 -> /dev/pts/0
2 -> /dev/pts/0
```
```text
Process
 │
 ├── FD 0 → stdin
 ├── FD 1 → stdout
 ├── FD 2 → stderr
 └── FD 3 → file/socket
```
```bash
cat /proc/$$/status
```
```text
Name
Pid
PPid
State
Uid
Gid
Threads
VmSize
VmRSS
```
```bash
grep -E 'Name|Pid|PPid|State|Threads|VmRSS' /proc/$$/status
```
```bash
cat /proc/$$/maps
```
```text
Process Virtual Memory
┌──────────────────────┐
│ Program              │
├──────────────────────┤
│ Shared Libraries     │
├──────────────────────┤
│ Heap                 │
├──────────────────────┤
│ Memory Mappings      │
├──────────────────────┤
│ Stack                │
└──────────────────────┘
```
```bash
ps aux
```
```text
USER
PID
%CPU
%MEM
STAT
COMMAND
```
```bash
ps -ef
```
```text
UID
PID
PPID
C
STIME
TTY
TIME
CMD
```
```bash
ps auxf
```
```bash
echo $$
```
```bash
ps -p $$ -o pid,ppid,cmd,stat
```
```text
PID:
PPID:
CMD:
STATE:
```
```bash
echo $$
```
```bash
ls -la /proc/$$/
```
```bash
cat /proc/$$/status
```
```bash
tr '\0' ' ' < /proc/$$/cmdline
echo
```
```bash
tr '\0' '\n' < /proc/$$/environ
```
```bash
ls -l /proc/$$/fd
```
```bash
pstree -p
```
```bash
pstree -p $$
```
```text
Current shell
    ↓
Parent process
    ↓
PID 1 / systemd
```
```bash
ps aux
```
```bash
ps -ef
```
```bash
ps auxf
```
```text
process_tree.py
```
```python
import os
import time

print(f"Parent PID: {os.getpid()}")
print(f"Parent PPID: {os.getppid()}")

pid = os.fork()

if pid == 0:
    print(f"Child PID: {os.getpid()}")
    print(f"Child PPID: {os.getppid()}")
    time.sleep(30)

else:
    print(f"Created child with PID: {pid}")
    time.sleep(30)
```
```bash
python3 process_tree.py
```
```bash
pstree -p
```
```text
bash
 └── python
      └── python
```
```text
zombie.py
```
```python
import os
import time

pid = os.fork()

if pid == 0:
    print(f"Child exiting. PID={os.getpid()}")
    os._exit(0)

else:
    print(f"Parent PID={os.getpid()}")
    print(f"Child PID={pid}")
    print("Parent sleeping without wait()...")

    time.sleep(30)
```
```bash
python3 zombie.py
```
```bash
ps -o pid,ppid,stat,cmd
```
```text
Z
```
```text
PID    PPID   STAT   CMD
1234   1000   S      python3 zombie.py
1235   1234   Z      [python3] <defunct>
```
```text
EC2 Instance
     │
     └── Linux Kernel
           │
           └── systemd (PID 1)
                │
                ├── nginx
                │
                ├── docker
                │    └── container
                │         └── application
                │
                └── monitoring agent
```
```text
PID namespaces
Network namespaces
Mount namespaces
```
```text
Linux Processes
      ↓
systemd
      ↓
Containers
      ↓
Kubernetes
      ↓
Cloud Infrastructure
```
```text
R = Running/Runnable
S = Sleeping
D = Uninterruptible Sleep
T = Stopped
Z = Zombie
```
```text
Created
   ↓
Runnable
   ↓
Running
   ├──→ Sleeping
   │       ↓
   │     Running
   │
   ├──→ Stopped
   │       ↓
   │     Running
   │
   └──→ Exit
          ↓
       Zombie
          ↓
        wait()
          ↓
       Removed
```
```text
process_tree.py
```
```text
zombie.py
```
```text
PROGRAM
   ↓
PROCESS
   ↓
PID + PPID
   ↓
PROCESS TREE
   ↓
PROCESS STATES
   ↓
/proc/<PID>
   ↓
systemd / PID 1
```

---

## Day 205 / 1000 — Linux Mastery: Day 9 / 30
```bash
python app.py
```
```bash
echo $$
```
```bash
top
```
```text
PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM COMMAND
1024 kevz      20   0  450000  82000  12000 R  45.2  0.5 python
2310 root      20   0  200000  35000   8000 S   8.2  0.2 nginx
4821 kevz      20   0   15000   6000   4000 S   0.0  0.1 bash
```
```text
R = Running / Runnable
S = Sleeping
D = Uninterruptible Sleep
T = Stopped
Z = Zombie
```
```text
P
M
N
k
q
```
```bash
htop
```
```bash
glances
```
```bash
pgrep bash
```
```bash
pgrep -a bash
```
```text
4210 /bin/bash
4382 /bin/bash ./backup.sh
4821 /bin/bash
```
```bash
pidof bash
```
```text
4821 4382 4210
```
```text
pgrep → flexible pattern-based process searching

pidof → find PIDs associated with a program
```
```bash
kill <PID>
```
```bash
kill -TERM <PID>
```
```bash
kill -KILL <PID>
```
```bash
kill -9 <PID>
```
```text
SIGTERM → graceful termination
```
```text
SIGKILL → forced termination
```
```bash
pkill sleep
```
```bash
sleep 1000 &
```
```bash
pgrep sleep
```
```bash
pkill sleep
```
```bash
pgrep sleep
```
```bash
pkill -f "python.*slow"
```
```text
python slow_server.py
```
```bash
pgrep -af "python.*slow"
```
```bash
pkill -f "python.*slow"
```
```text
OBSERVE
   ↓
VERIFY
   ↓
ACT
   ↓
MONITOR
```
```text
-20 → highest priority
  0 → default
+19 → lowest priority
```
```bash
nice -n 10 ./long_task.sh
```
```bash
ps -o pid,ni,cmd -C long_task.sh
```
```text
PID    NI CMD
5120   10 ./long_task.sh
```
```bash
pgrep -af long_task
```
```text
5120
```
```bash
renice -n +5 -p 5120
```
```bash
ps -p 5120 -o pid,ni,cmd
```
```text
"Allow this process to use only 10% CPU."
```
```text
nice
  ↓
Scheduling preference
```
```text
nice
  ↓
Hard CPU limit
```
```text
RSS
VSZ
```
```text
RSS = 180 MB
```
```text
VSZ = 2.5 GB
RSS = 180 MB
```
```text
RSS → physical memory currently resident

VSZ → virtual address space
```
```bash
uptime
```
```text
10:35:12 up 2 days, 4:20,
load average: 2.10, 1.50, 0.80
```
```text
1 minute     5 minutes     15 minutes
   ↓             ↓             ↓
  2.10          1.50          0.80
```
```text
CPU cores = 4
Load = 2
```
```text
2 / 4 = 0.5
```
```text
CPU cores = 1
Load = 2
```
```text
2 / 1 = 2
```
```text
load average: 0.50, 0.70, 0.90
```
```text
load average: 4.00, 2.00, 1.00
```
```text
SERVER IS SLOW
      ↓
CHECK LOAD
      ↓
CHECK CPU
      ↓
CHECK MEMORY
      ↓
IDENTIFY PROCESS
      ↓
INSPECT PROCESS
      ↓
VERIFY CAUSE
      ↓
TAKE ACTION
      ↓
MONITOR AGAIN
```
```bash
uptime
free -h
top
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```
```bash
top
```
```text
P
M
N
k
q
```
```bash
htop
```
```bash
pgrep bash
```
```bash
pgrep -a bash
```
```bash
pidof bash
```
```bash
sleep 1000 &
```
```bash
pgrep -a sleep
```
```bash
PID=$(pgrep -n sleep)
echo "$PID"
```
```bash
ps -p "$PID" -o pid,ppid,stat,ni,vsz,rss,cmd
```
```bash
kill "$PID"
```
```bash
pgrep sleep
```
```bash
nice -n 10 ./long_task.sh &
```
```bash
pgrep -af long_task
```
```bash
ps -p <PID> -o pid,ni,cmd
```
```bash
renice -n +5 -p <PID>
```
```bash
ps -p <PID> -o pid,ni,cmd
```
```bash
stress-ng --cpu 2
```
```bash
top
```
```bash
timeout 30 stress-ng --cpu 2
```
```bash
nano process_monitor.sh
```
```bash
#!/usr/bin/env bash

set -euo pipefail

echo "========================================="
echo "       LINUX PROCESS MONITOR"
echo "========================================="
echo "Timestamp: $(date)"
echo "Hostname: $(hostname)"
echo "CPU cores: $(nproc)"
echo

echo "=== SYSTEM LOAD ==="
uptime
echo

echo "=== TOP 5 CPU PROCESSES ==="
ps -eo pid,user,%cpu,%mem,stat,comm --sort=-%cpu | head -n 6
echo

echo "=== TOP 5 MEMORY PROCESSES ==="
ps -eo pid,user,%cpu,%mem,stat,comm --sort=-%mem | head -n 6
echo

echo "=== MEMORY ==="
free -h
echo

echo "========================================="
echo "Monitor complete"
echo "========================================="
```
```bash
chmod +x process_monitor.sh
```
```bash
./process_monitor.sh
```
```text
=========================================
       LINUX PROCESS MONITOR
=========================================
Timestamp: Tue Sep 22 10:40:12 IST 2026
Hostname: linux-vm
CPU cores: 4

=== SYSTEM LOAD ===
load average: 1.20, 0.90, 0.70

=== TOP 5 CPU PROCESSES ===
...

=== TOP 5 MEMORY PROCESSES ===
...

=== MEMORY ===
...

=========================================
Monitor complete
=========================================
```
```bash
# Process monitoring
top
htop
glances

# Find processes
pgrep bash
pgrep -a bash
pidof bash

# Process information
ps aux
ps -ef
ps -p <PID> -o pid,ppid,stat,ni,vsz,rss,cmd

# CPU-heavy processes
ps aux --sort=-%cpu | head

# Memory-heavy processes
ps aux --sort=-%mem | head

# Process management
kill <PID>
kill -TERM <PID>
pkill <process>

# Scheduling priority
nice -n 10 <command>
renice -n +5 -p <PID>

# System load
uptime
w

# Memory
free -h

# CPU count
nproc

# Stress testing
stress-ng --cpu 2
timeout 30 stress-ng --cpu 2
```
```text
                 LINUX MACHINE
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
        CPU          MEMORY        LOAD
          │            │            │
        %CPU         RSS/VSZ      1/5/15m
          │            │            │
          └────────────┼────────────┘
                       ↓
                    PROCESS
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
        FIND         INSPECT       MANAGE
          │            │            │
       pgrep          ps          kill
       pidof          top         pkill
                     htop        nice
                                renice
```
```bash
uptime
free -h
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```
```text
1. What is the current load average?

2. How many CPU cores does the machine have?

3. Which process is consuming the most CPU?

4. Which process is consuming the most memory?

5. Based on the evidence, what would you investigate next?
```
```text
OBSERVE
   ↓
MEASURE
   ↓
IDENTIFY
   ↓
VERIFY
   ↓
ACT
   ↓
MONITOR
```
```text
Linux Mastery
Day 9 / 30
█████████░░░░░░░░░░░░ 30%

AI Cloud Infrastructure Journey
Day 205 / 1000
████░░░░░░░░░░░░░░░░ 20.5%
```

---

## 🐧 Day 206 / 1000 — Linux Mastery: Day 10 / 30
```text
                 LINUX KERNEL
                      │
                      ▼
                ┌───────────┐
                │  PROCESS  │
                │   PID 42  │
                └─────┬─────┘
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       signals      stdin       stdout
          │
          ▼
     "STOP / EXIT /
      RELOAD / ..."
```
```bash
kill -TERM 42
```
```bash
kill -l
```
```text
1)  SIGHUP
2)  SIGINT
9)  SIGKILL
15) SIGTERM
...
```
```text
SIGTERM → "Please shut down."
SIGKILL → "STOP. NOW."
SIGHUP  → "Your controlling terminal disappeared / reload."
SIGINT  → "User interrupted you."
```
```text
SIGTERM = Terminate
```
```bash
kill -TERM <PID>
```
```bash
kill -15 <PID>
```
```bash
kill <PID>
```
```text
SIGTERM
   ↓
trap
   ↓
cleanup
   ↓
exit
```
```text
SIGKILL = Kill immediately
```
```bash
kill -9 <PID>
```
```bash
trap 'echo cleanup' SIGKILL
```
```text
SIGTERM
   ↓
"Please leave."

Process:
"Okay, let me save my work."
```
```text
SIGKILL
   ↓
"You're done."

Process:
"..."
💀
```
```text
Application
    ↓
Database
    ↓
Transaction
```
```text
SIGTERM
   ↓
Stop accepting new requests
   ↓
Finish existing requests
   ↓
Close connections
   ↓
Flush logs
   ↓
Cleanup temporary files
   ↓
Exit
```
```text
SIGHUP = Hang Up
```
```text
Application
     │
     │ SIGHUP
     ▼
Reload config
     │
     ▼
Continue running
```
```text
restart:
process dies → process starts again

reload:
process stays alive → configuration changes
```
```bash
kill -USR1 <PID>
```
```text
SIGUSR1
   ↓
Enable debug logging
```
```text
SIGUSR1
   ↓
Dump statistics
```
```text
SIGUSR1
   ↓
Reload something
```
```text
Ctrl+C → SIGINT
```
```bash
sleep 100
```
```text
Ctrl+C
```
```text
Ctrl+C
   ↓
SIGINT
   ↓
process terminates
```
```bash
kill
```
```bash
kill -TERM 1234
```
```bash
kill -HUP 1234
```
```bash
kill -USR1 1234
```
```bash
sleep 500
```
```bash
pgrep sleep
```
```bash
ps aux | grep sleep
```
```text
2451
```
```bash
kill -TERM 2451
```
```bash
pgrep sleep
```
```bash
trap
```
```bash
trap 'commands' SIGNAL
```
```bash
trap 'echo "Received SIGTERM"' SIGTERM
```
```bash
nano signal_demo.sh
```
```bash
#!/bin/bash

trap 'echo "Received SIGTERM. Cleaning up..."' SIGTERM

echo "PID: $$"

while true; do
    echo "Working..."
    sleep 2
done
```
```bash
chmod +x signal_demo.sh
```
```bash
./signal_demo.sh
```
```text
PID: 3124
Working...
Working...
Working...
```
```bash
kill -TERM 3124
```
```text
Received SIGTERM. Cleaning up...
```
```bash
#!/bin/bash

cleanup() {
    echo "Received SIGTERM"
    echo "Cleaning up..."
    
    # cleanup operations go here
    
    echo "Cleanup complete"
    exit 0
}

trap cleanup SIGTERM

echo "PID: $$"

while true; do
    echo "Working..."
    sleep 2
done
```
```bash
./signal_demo.sh
```
```bash
pgrep -f signal_demo.sh
```
```bash
kill -TERM <PID>
```
```text
SIGTERM
   ↓
trap
   ↓
cleanup()
   ↓
cleanup work
   ↓
exit 0
```
```bash
$$
```
```bash
echo "My PID is $$"
```
```text
My PID is 4218
```
```bash
kill -TERM <PID>
```
```text
save
cleanup
close
flush
exit
```
```bash
kill -KILL <PID>
```
```bash
kill -9 <PID>
```
```text
NO cleanup opportunity
```
```text
SIGTERM
   ↓
wait
   ↓
still alive?
   ↓
SIGKILL
```
```bash
sleep 100
```
```bash
sleep 100 &
```
```text
[1] 5432
```
```text
Job number = 1
PID        = 5432
```
```bash
jobs
```
```text
[1]+  Running    sleep 100 &
```
```bash
fg
```
```bash
fg %1
```
```bash
sleep 100
```
```text
Ctrl+Z
```
```text
[1]+  Stopped    sleep 100
```
```bash
jobs
```
```bash
bg
```
```bash
jobs
```
```text
[1]+ Running sleep 100 &
```
```text
Foreground
    │
 Ctrl+Z
    ↓
Stopped
    │
   bg
    ↓
Background
    │
   fg
    ↓
Foreground
```
```bash
./long_task.sh &
```
```bash
nohup ./long_task.sh &
```
```text
nohup.out
```
```bash
nohup ./long_task.sh &
```
```bash
disown
```
```bash
./long_task.sh &
```
```bash
jobs
```
```bash
disown %1
```
```bash
jobs
```
```bash
nohup ./long_task.sh &
disown
```
```text
nohup
 ↓
ignore hangup
```
```text
disown
 ↓
remove job from shell's job table
```
```bash
nohup ./long_task.sh &
disown
```
```text
graceful_killer.sh
```
```text
             graceful_killer.sh
                    │
                    ▼
              target process
                    │
              send SIGTERM
                    │
                    ▼
               wait 5 sec
                    │
              ┌─────┴─────┐
              │           │
           exited       alive
              │           │
              ▼           ▼
             DONE       SIGKILL
                          │
                          ▼
                         DONE
```
```bash
#!/bin/bash

TARGET_PID="$1"
LOG_FILE="graceful_killer.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

if [[ -z "$TARGET_PID" ]]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

if ! kill -0 "$TARGET_PID" 2>/dev/null; then
    log "Process $TARGET_PID does not exist."
    exit 1
fi

log "Sending SIGTERM to PID $TARGET_PID"
kill -TERM "$TARGET_PID"

log "Waiting up to 5 seconds for graceful shutdown..."

for i in {1..5}; do
    if ! kill -0 "$TARGET_PID" 2>/dev/null; then
        log "Process $TARGET_PID exited gracefully."
        exit 0
    fi

    sleep 1
done

if kill -0 "$TARGET_PID" 2>/dev/null; then
    log "Process $TARGET_PID still running."
    log "Sending SIGKILL to PID $TARGET_PID"

    kill -KILL "$TARGET_PID"

    log "SIGKILL sent."
fi
```
```bash
chmod +x graceful_killer.sh
```
```bash
./graceful_killer.sh <PID>
```
```bash
kill -0 <PID>
```
```bash
if kill -0 "$PID" 2>/dev/null; then
    echo "Process exists"
else
    echo "Process does not exist"
fi
```
```bash
nano long_task.sh
```
```bash
#!/bin/bash

cleanup() {
    echo "[$$] SIGTERM received"
    echo "[$$] Cleaning temporary resources..."
    sleep 2
    echo "[$$] Cleanup complete"
    exit 0
}

trap cleanup SIGTERM

echo "Long task started."
echo "PID: $$"

while true; do
    echo "[$$] Processing..."
    sleep 1
done
```
```bash
chmod +x long_task.sh
```
```bash
./long_task.sh
```
```bash
./graceful_killer.sh <PID>
```
```text
Sending SIGTERM
        ↓
long_task.sh receives SIGTERM
        ↓
cleanup()
        ↓
2 second cleanup
        ↓
exit
```
```bash
stubborn.sh
```
```bash
#!/bin/bash

trap 'echo "SIGTERM received, but I refuse to exit."' SIGTERM

echo "PID: $$"

while true; do
    sleep 1
done
```
```bash
chmod +x stubborn.sh
./stubborn.sh
```
```bash
./graceful_killer.sh <PID>
```
```text
SIGTERM
   ↓
process ignores termination
   ↓
5 seconds
   ↓
SIGKILL
   ↓
process dies
```
```bash
config.txt
```
```text
MODE=production
```
```bash
reload_demo.sh
```
```bash
#!/bin/bash

CONFIG_FILE="config.txt"

load_config() {
    source "$CONFIG_FILE"
    echo "Configuration loaded: MODE=$MODE"
}

reload() {
    echo "SIGHUP received."
    echo "Reloading configuration..."
    load_config
}

trap reload SIGHUP

load_config

echo "PID: $$"

while true; do
    echo "Running with MODE=$MODE"
    sleep 3
done
```
```bash
chmod +x reload_demo.sh
./reload_demo.sh
```
```text
Configuration loaded: MODE=production
PID: 5000
Running with MODE=production
```
```text
MODE=maintenance
```
```bash
kill -HUP 5000
```
```text
SIGHUP received.
Reloading configuration...
Configuration loaded: MODE=maintenance
```
```text
                    CONFIG CHANGE
                         │
                         ▼
                      SIGHUP
                         │
                         ▼
                  ┌─────────────┐
                  │   PROCESS   │
                  │   STAYS UP  │
                  └──────┬──────┘
                         │
                         ▼
                   NEW CONFIG
```
```text
Linux
  ↓
Processes
  ↓
Signals
  ↓
Services
  ↓
Containers
  ↓
Kubernetes
  ↓
Cloud infrastructure
```
```text
NEW VERSION
     │
     ▼
Start new instance
     │
     ▼
Health check
     │
     ▼
Stop old instance
     │
     ▼
SIGTERM
     │
     ├── finish requests
     ├── close connections
     ├── flush logs
     └── cleanup
     │
     ▼
Exit
```
```text
SIGTERM
   ↓
wait
   ↓
timeout
   ↓
SIGKILL
```
```bash
sleep 300 &
jobs
pgrep sleep
kill -TERM <PID>
```
```bash
sleep 300
```
```text
Ctrl+Z
```
```bash
jobs
bg
jobs
fg
```
```text
long_task.sh
```
```bash
trap cleanup SIGTERM
```
```bash
kill -TERM <PID>
```
```bash
kill -9 <PID>
```
```text
graceful_killer.sh
```
```text
Accept PID
   ↓
Validate PID
   ↓
SIGTERM
   ↓
Log
   ↓
Wait 5 seconds
   ↓
Check process
   ↓
If alive → SIGKILL
   ↓
Log result
```
```text
reload_demo.sh
```
```bash
kill -HUP <PID>
```

---

## 🐧 Day 207 / 1000 — Linux Mastery: Day 11 / 30
```text
                 LINUX SCHEDULER
                       │
                       ▼
                 ┌───────────┐
                 │   TIME    │
                 │  02:00 AM │
                 └─────┬─────┘
                       │
                       ▼
                scheduled task
                       │
                       ▼
              log_rotator.sh
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
        Rotate logs        Compress old logs
```
```text
                           CRON SUBSYSTEM
                                  │
          ┌───────────────────────┴───────────────────────┐
          ▼                                               ▼
   User Crontabs                                   System Crontabs
 (/var/spool/cron/crontabs/)                     (/etc/crontab & /etc/cron.d/)
          │                                               │
 Managed via `crontab -e`                        Configured by root / packages
 (Runs as that specific user)                    (Contains explicit username field)
```
```text
 ┌───────────── Minute (0 - 59)
 │ ┌────────────── Hour (0 - 23)
 │ │ ┌─────────────── Day of Month (1 - 31)
 │ │ │ ┌──────────────── Month (1 - 12 or JAN - DEC)
 │ │ │ │ ┌───────────────── Day of Week (0 - 7 or SUN - SAT, 0 & 7 = Sun)
 │ │ │ │ │
 * * * * * <command-to-execute>
```
```bash
# Edit current user's crontab (uses $EDITOR or nano/vim)
crontab -e

# List current user's scheduled jobs
crontab -l

# Remove/wipe current user's crontab completely (CAUTION!)
crontab -r

# Inspect another user's crontab (root only)
sudo crontab -u appuser -l
```
```text
Interactive Login Shell                      Cron Subshell Environment
┌───────────────────────────┐                ┌───────────────────────────┐
│ PATH=/home/user/.local/bin│                │ PATH=/usr/bin:/bin        │
│      :/usr/local/bin:...  │       vs       │ SHELL=/bin/sh             │
│ Full ~/.bashrc loaded     │                │ HOME=/home/user           │
│ Aliases & Envs available  │                │ NO interactive variables  │
└───────────────────────────┘                └───────────────────────────┘
```
```bash
   # BAD: python backup.py
   # GOOD:
   0 3 * * * /usr/bin/python3 /home/ubuntu/scripts/backup.py
   ```
```bash
   0 2 * * * /opt/scripts/db_backup.sh >> /var/log/db_backup.log 2>&1
   ```
```bash
   SHELL=/bin/bash
   PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
   MAILTO=admin@company.com
   ```
```bash
# Schedule a job for 2:30 PM today (or tomorrow if past 14:30)
at 14:30

# Natural language scheduling
at 10:00 PM tomorrow
at now + 2 hours
at midnight next Friday

# Provide commands via stdin or file
echo "/usr/local/bin/deploy.sh" | at 03:00 AM

# Inspect the queue of scheduled one-time jobs
atq

# Remove a queued job by job ID
atrm 4
```
```bash
# Queues a task to execute only when the system load average drops below 0.8
batch
```
```text
# period-in-days   delay-in-minutes   job-identifier   command
1                  5                  cron.daily       run-parts /etc/cron.daily
7                  10                 cron.weekly      run-parts /etc/cron.weekly
@monthly           15                 cron.monthly     run-parts /etc/cron.monthly
```
```bash
#!/usr/bin/env bash
# ==============================================================================
# log_rotator_cron.sh
# Day 11/30 - Linux Mastery | Day 207/1000 - AI Cloud Infrastructure Journey
# Automated log cleanup, compression, and disk health reporting.
# ==============================================================================

set -euo pipefail

TARGET_LOG_DIR="/var/log/custom-apps"
ARCHIVE_DIR="${TARGET_LOG_DIR}/archive"
LOG_FILE="/var/log/cron_rotator.log"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

mkdir -p "${ARCHIVE_DIR}"

log() {
    echo "${TIMESTAMP} | [LOG-ROTATOR] | $1" | tee -a "${LOG_FILE}"
}

log "Starting scheduled log maintenance run..."

# 1. Compress raw .log files older than 7 days
log "Compressing inactive log files older than 7 days..."
find "${TARGET_LOG_DIR}" -maxdepth 1 -name "*.log" -mtime +7 -exec gzip -v {} \; 2>&1 | while read -r line; do
    log "GZIP: ${line}"
done || true

# 2. Move compressed archives into archive directory
find "${TARGET_LOG_DIR}" -maxdepth 1 -name "*.log.gz" -exec mv -t "${ARCHIVE_DIR}" {} + 2>/dev/null || true

# 3. Purge archived logs older than 30 days
log "Purging archives older than 30 days..."
DELETED_COUNT=$(find "${ARCHIVE_DIR}" -name "*.log.gz" -mtime +30 -delete -print | wc -l)
log "Purged ${DELETED_COUNT} obsolete log archive(s)."

# 4. Check disk usage of log partition
DISK_USAGE=$(df -h "${TARGET_LOG_DIR}" | awk 'NR==2 {print $5}')
log "Current log directory disk utilization: ${DISK_USAGE}"

log "Log maintenance completed successfully."
```
```bash
# Run the log rotator every night at 02:00 AM and log execution output
0 2 * * * /usr/local/bin/log_rotator_cron.sh >> /var/log/cron_rotator.log 2>&1
```
```yaml
  apiVersion: batch/v1
  kind: CronJob
  metadata:
    name: automated-db-backup
  spec:
    schedule: "0 2 * * *"
    successfulJobsHistoryLimit: 3
    failedJobsHistoryLimit: 1
    jobTemplate:
      spec:
        template:
          spec:
            containers:
            - name: backup-worker
              image: postgres:15-alpine
              command: ["/bin/sh", "-c", "/scripts/backup.sh"]
            restartPolicy: OnFailure
  ```
```text
Linux Mastery:                 Day 11 / 30  [███████████░░░░░░░░░░░░░░░░░░░] 36.7%
AI Cloud Infrastructure:     Day 207 / 1000 [████░░░░░░░░░░░░░░░░░░░░░░░░░░] 20.7%
```

---

## Day 12 — Systemd Services & Timers (Part 1)
```text

                    systemd

                       │

        ┌──────────────┼──────────────┐

        │              │              │

      Units          Targets       Generators

        │

   ┌────┼────┬────┬────┐

   │    │    │    │    │

service socket timer mount target

```
```text

.service

```
```text

ssh.service

nginx.service

docker.service

myhttp.service

```
```bash

systemctl get-default

```
```text

multi-user.target

```
```text

multi-user.target

        │

        ├── ssh.service

        ├── cron.service

        ├── nginx.service

        └── other services

```
```text

Configuration

      ↓

Generator

      ↓

Generated units/dependencies

      ↓

systemd

```
```ini

[Unit]

Description=My HTTP Server

After=network.target



[Service]

Type=simple

ExecStart=/usr/bin/python3 -m http.server 8080

Restart=on-failure

RestartSec=10



[Install]

WantedBy=multi-user.target

```
```text

[Unit]

    ↓

Identity and dependencies



[Service]

    ↓

How the application runs



[Install]

    ↓

How the service integrates with boot

```
```ini

[Unit]

Description=My Python HTTP Server

After=network.target

```
```ini

Description=My Python HTTP Server

```
```bash

systemctl status myhttp

```
```ini

After=network.target

```
```text

After= ≠ dependency

```
```ini

Requires=network.target

```
```ini

Requires=network.target

After=network.target

```
```text

I require the network target

+

Start me after the network target

```
```ini

Wants=some-service.service

```
```text

Requires = MUST HAVE

Wants    = NICE TO HAVE

After    = START ORDER

```
```ini

[Service]

Type=simple

ExecStart=/usr/bin/python3 -m http.server 8080

Restart=on-failure

RestartSec=10

```
```ini

ExecStart=/usr/bin/python3 -m http.server 8080

```
```bash

which python3

```
```ini

Type=simple

```
```ini

[Service]

Type=simple

ExecStart=/usr/bin/python3 -m http.server 8080

```
```ini

Type=forking

```
```text

systemd

   ↓

application

   ↓

fork()

   ↓

background process

```
```ini

Type=oneshot

```
```ini

[Service]

Type=oneshot

ExecStart=/usr/local/bin/backup.sh

```
```text

Start

  ↓

Run script

  ↓

Script finishes

  ↓

Service exits

```
```ini

Type=notify

```
```text

Application starts

      ↓

Application initializes

      ↓

Application tells systemd:

"I'm ready"

```
```ini

Restart=on-failure

```
```text

Application

     ↓

   crash

     ↓

systemd detects failure

     ↓

restart

```
```ini

Restart=on-failure

```
```text

Exit code 1

Unexpected termination

Process crash

Failure signal

```
```ini

Restart=always

```
```text

Service

   ↓

stops

   ↓

restart

   ↓

stops

   ↓

restart

```
```ini

RestartSec=10

```
```text

Service crashes

      ↓

Wait 10 seconds

      ↓

Restart service

```
```text

After=     → ordering

Requires=  → dependency

Wants=     → optional/weak dependency

```
```ini

[Install]

WantedBy=multi-user.target

```
```text

multi-user.target

```
```bash

sudo nano /etc/systemd/system/myhttp.service

```
```ini

[Unit]

# Human-readable description

Description=My Simple Python HTTP Server



# Start after the network target

After=network.target





[Service]

# Long-running foreground process

Type=simple



# Start Python HTTP server on port 8080

ExecStart=/usr/bin/python3 -m http.server 8080



# Restart if the service fails

Restart=on-failure



# Wait 10 seconds before restarting

RestartSec=10





[Install]

# Start automatically with multi-user.target

WantedBy=multi-user.target

```
```bash

sudo systemctl daemon-reload

```
```text

Edit service file

       ↓

daemon-reload

       ↓

systemd rereads configuration

```
```bash

sudo systemctl start myhttp

```
```bash

systemctl status myhttp

```
```text

Active: active (running)

```
```bash

sudo systemctl stop myhttp

```
```bash

systemctl status myhttp

```
```text

inactive (dead)

```
```bash

sudo systemctl restart myhttp

```
```bash

sudo systemctl stop myhttp

sudo systemctl start myhttp

```
```bash

sudo systemctl restart myhttp

```
```bash

sudo systemctl enable myhttp

```
```bash

systemctl start myhttp

```
```bash

systemctl enable myhttp

```
```bash

sudo systemctl enable --now myhttp

```
```text

Enable for boot

+

Start immediately

```
```bash

systemctl is-enabled myhttp

```
```text

enabled

```
```bash

sudo systemctl disable myhttp

```
```text

disable ≠ stop

```
```bash

curl http://localhost:8080

```
```bash

curl -I http://localhost:8080

```
```text

HTTP/1.0 200 OK

```
```bash

journalctl -u myhttp

```
```text

unit

```
```bash

journalctl -u myhttp

```
```bash

journalctl -u myhttp -f

```
```bash

tail -f logfile

```
```text

Ctrl+C

```
```bash

sudo nano /etc/systemd/system/failing.service

```
```ini

[Unit]

Description=Deliberately Failing Service



[Service]

Type=simple

ExecStart=/bin/sh -c 'echo "Service failed"; exit 1'

Restart=on-failure

RestartSec=10



[Install]

WantedBy=multi-user.target

```
```bash

sudo systemctl daemon-reload

```
```bash

sudo systemctl start failing

```
```bash

systemctl status failing

```
```bash

exit 1

```
```ini

Restart=on-failure

RestartSec=10

```
```text

failing.service

       ↓

starts

       ↓

exit 1

       ↓

systemd detects failure

       ↓

wait 10 seconds

       ↓

restart

       ↓

fails again

       ↓

repeat

```
```bash

journalctl -u failing -f

```
```text

systemd

   ↓

start application

   ↓

application listens on port

```
```text

systemd

   ↓

listen on socket

   ↓

connection arrives

   ↓

start service

   ↓

application handles connection

```
```text

myapp.socket

```
```text

myapp.service

```
```text

myapp.socket

      │

      ▼

 listening socket

      │

      │ connection

      ▼

myapp.service

      │

      ▼

 application

```
```bash

systemctl status myhttp

sudo systemctl start myhttp

sudo systemctl stop myhttp

sudo systemctl restart myhttp

```
```bash

sudo systemctl enable myhttp

sudo systemctl disable myhttp

sudo systemctl enable --now myhttp

```
```bash

sudo systemctl daemon-reload

```
```bash

systemctl is-active myhttp

systemctl is-enabled myhttp

```
```bash

journalctl -u myhttp

journalctl -u myhttp -f

```
```text

                 service file

                      │

                      ▼

                daemon-reload

                      │

                      ▼

                    start

                      │

                      ▼

               active/running

                 │          │

              restart      stop

                 │          │

                 ▼          ▼

          active/running  inactive

```
```text

system boot

     ↓

systemd

     ↓

multi-user.target

     ↓

enabled services

     ↓

myhttp.service

     ↓

Python HTTP server

```
```text

EC2 Instance

     │

   systemd

     │

     ├── nginx.service

     ├── application.service

     ├── monitoring.service

     └── worker.service

```
```text

Application

     ↓

Crash

     ↓

systemd

     ↓

Restart

     ↓

Application running again

```
```text

Linux machine

      ↓

systemd

      ↓

processes/services

```
```text

Cluster

   ↓

Kubernetes

   ↓

Pods

   ↓

Containers

```
```text

                    SYSTEMD

                       │

          ┌────────────┼────────────┐

          │            │            │

        Units        Targets     Generators

          │

    ┌─────┼──────┐

    │     │      │

 service socket timer

    │

    ▼

  [Unit]

    │

    ├── Description

    ├── After

    ├── Requires

    └── Wants



  [Service]

    │

    ├── Type

    ├── ExecStart

    ├── Restart

    └── RestartSec



  [Install]

    │

    └── WantedBy

```
```text

start   → run it now

stop    → stop it now

restart → stop + start

enable  → start automatically at boot

disable → don't start automatically at boot

```
```text

After=      → ordering

Requires=   → strong dependency

Wants=      → weak dependency

```

---

## Day 13 — Systemd Timers (Part 2) & Journal Introduction
```text
Timer
  ↓
Service
  ↓
Program / Script
```
```text
backup.timer
      ↓
backup.service
      ↓
backup.sh
```
```ini
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
```ini
[Unit]
Description=Daily Backup Timer
```
```ini
[Timer]
OnCalendar=*-*-* 03:00:00
```
```ini
[Install]
WantedBy=timers.target
```
```ini
OnCalendar=*-*-* 03:00:00
```
```ini
OnCalendar=daily
```
```ini
OnCalendar=weekly
```
```ini
OnCalendar=Mon *-*-* 09:00:00
```
```ini
OnCalendar=*-*-01 00:00:00
```
```bash
man systemd.time
```
```ini
Persistent=true
```
```text
03:00 AM
   ↓
Computer is OFF
   ↓
Scheduled execution is missed
   ↓
Computer starts later
   ↓
systemd detects the missed execution
   ↓
Service can be triggered
```
```text
backup.timer
     │
     │ scheduled execution
     ▼
backup.service
     │
     ▼
backup.sh
```
```ini
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```
```text
Start
  ↓
Execute command
  ↓
Finish
```
```ini
[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```
```bash
#!/bin/bash

BACKUP_DIR="/tmp/linux-backups"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p "$BACKUP_DIR"

echo "Backup started at $(date)"

echo "Linux Day 13 backup" \
    > "$BACKUP_DIR/backup_$TIMESTAMP.txt"

echo "Backup completed at $(date)"
```
```bash
sudo chmod +x /usr/local/bin/backup.sh
```
```ini
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```
```text
/etc/systemd/system/backup.service
```
```ini
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
Unit=backup.service

[Install]
WantedBy=timers.target
```
```text
/etc/systemd/system/backup.timer
```
```ini
Unit=backup.service
```
```bash
sudo systemctl daemon-reload
```
```text
Modify unit file
      ↓
daemon-reload
      ↓
systemd reads configuration
```
```bash
sudo systemctl start backup.timer
```
```bash
sudo systemctl enable backup.timer
```
```bash
sudo systemctl enable --now backup.timer
```
```bash
systemctl status backup.timer
```
```bash
systemctl list-timers
```
```bash
systemctl list-timers --all
```
```text
NEXT
LEFT
LAST
PASSED
UNIT
ACTIVATES
```
```text
NEXT       → next scheduled execution
LEFT       → time until execution
LAST       → previous execution
UNIT       → timer unit
ACTIVATES  → service triggered by the timer
```
```bash
sudo systemctl start backup.service
```
```bash
systemctl status backup.service
```
```ini
Type=oneshot
```
```bash
journalctl
```
```text
systemd
   ↓
journal
   ↓
journalctl
```
```bash
journalctl
```
```bash
journalctl -b
```
```text
System boots
    ↓
Something goes wrong
    ↓
journalctl -b
    ↓
Inspect current boot logs
```
```bash
journalctl -u backup.service
```
```bash
journalctl -u backup.service
```
```bash
journalctl -u ssh.service
```
```bash
journalctl -u nginx.service
```
```bash
journalctl -u backup.service -f
```
```bash
journalctl -u backup.service -f
```
```bash
sudo systemctl start backup.service
```
```text
Ctrl + C
```
```bash
journalctl -n 20
```
```bash
journalctl -u backup.service -n 20
```
```text
0 = emergency
1 = alert
2 = critical
3 = error
4 = warning
5 = notice
6 = informational
7 = debug
```
```bash
journalctl -p warning
```
```bash
journalctl -p err
```
```bash
journalctl -u backup.service -p err
```
```bash
journalctl -u backup.service -o json-pretty
```
```text
MESSAGE
PRIORITY
_PID
_UID
_SYSTEMD_UNIT
_BOOT_ID
_MACHINE_ID
```
```bash
journalctl --disk-usage
```
```bash
sudo journalctl --vacuum-size=500M
```
```text
backup.sh
backup.service
backup.timer
```
```text
Creates files
     ↓
Reloads systemd
     ↓
Enables timer
     ↓
Starts timer
     ↓
Displays timer status
     ↓
Runs backup once
     ↓
Displays journal logs
```
```bash
#!/bin/bash

set -e

SERVICE_FILE="/etc/systemd/system/backup.service"
TIMER_FILE="/etc/systemd/system/backup.timer"
BACKUP_SCRIPT="/usr/local/bin/backup.sh"

echo "======================================"
echo " Linux Day 13 System Scheduler"
echo "======================================"

echo "[1/7] Creating backup script..."

sudo tee "$BACKUP_SCRIPT" > /dev/null <<'EOF'
#!/bin/bash

BACKUP_DIR="/tmp/linux-backups"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p "$BACKUP_DIR"

echo "Backup started at $(date)"

echo "Linux Day 13 backup" \
    > "$BACKUP_DIR/backup_$TIMESTAMP.txt"

echo "Backup completed at $(date)"
EOF

sudo chmod +x "$BACKUP_SCRIPT"

echo "[2/7] Creating backup.service..."

sudo tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF

echo "[3/7] Creating backup.timer..."

sudo tee "$TIMER_FILE" > /dev/null <<'EOF'
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
Unit=backup.service

[Install]
WantedBy=timers.target
EOF

echo "[4/7] Reloading systemd..."

sudo systemctl daemon-reload

echo "[5/7] Enabling backup.timer..."

sudo systemctl enable backup.timer

echo "[6/7] Starting backup.timer..."

sudo systemctl start backup.timer

echo "[7/7] Timer status..."

systemctl status backup.timer --no-pager

echo
echo "======================================"
echo " Scheduled Timers"
echo "======================================"

systemctl list-timers --all | grep -E "backup|NEXT"

echo
echo "======================================"
echo " Running Backup Once for Testing"
echo "======================================"

sudo systemctl start backup.service

echo
echo "======================================"
echo " Backup Journal"
echo "======================================"

sudo journalctl -u backup.service -n 10 --no-pager

echo
echo "Day 13 scheduler setup complete."
```
```bash
chmod +x system_scheduler.sh
```
```bash
sudo ./system_scheduler.sh
```
```bash
sudo systemctl daemon-reload
```
```bash
sudo systemctl start backup.timer
```
```bash
sudo systemctl enable backup.timer
```
```bash
sudo systemctl enable --now backup.timer
```
```bash
systemctl status backup.timer
```
```bash
systemctl list-timers --all
```
```bash
sudo systemctl start backup.service
```
```bash
journalctl -u backup.service
```
```bash
journalctl -b
```
```bash
journalctl -u backup.service -f
```
```bash
journalctl -u backup.service -n 20
```
```bash
journalctl -p warning
```
```bash
journalctl -p err
```
```bash
journalctl -u backup.service -o json-pretty
```
```bash
journalctl --disk-usage
```
```bash
sudo journalctl --vacuum-size=500M
```
```text
Scheduled Automation
        +
Systemd Services
        +
Systemd Timers
        +
Structured Logging
        +
Journal Investigation
```
```text
day-013/
├── backup.service
├── backup.timer
├── backup.sh
├── system_scheduler.sh
└── README.md
```
```ini
OnUnitActiveSec=5min
```
```ini
OnCalendar=*-*-* 03:00:00
```
```bash
systemctl list-timers backup.timer
```
```bash
journalctl -u backup.service -p err
```
```bash
journalctl -u backup.service -o json-pretty
```
```text
MESSAGE
PRIORITY
_SYSTEMD_UNIT
_PID
```
```bash
journalctl -u backup.service -f
```
```bash
sudo systemctl start backup.service
```
```text
Linux
 │
 ├── systemd services
 │
 ├── systemd timers
 │
 ├── journalctl
 │
 └── process management
       │
       ▼
Cloud Infrastructure
 │
 ├── Automated jobs
 ├── Monitoring
 ├── Logging
 ├── Incident investigation
 ├── Containers
 └── Kubernetes
```
```text
Automation
     +
Execution
     +
Observability
```
```text
SERVICE
"What should run?"

TIMER
"When should it run?"

JOURNAL
"What happened?"

JOURNALCTL
"Show me what happened."
```
```text
backup.timer
      │
      │ scheduled time
      ▼
backup.service
      │
      ▼
backup.sh
      │
      ▼
Backup operation
      │
      ▼
systemd journal
      │
      ▼
journalctl
      │
      ├── -u  → specific unit
      ├── -b  → current boot
      ├── -f  → follow live logs
      ├── -n  → recent lines
      └── -p  → priority filtering
```
```bash
systemctl daemon-reload
systemctl start
systemctl enable
systemctl status
systemctl list-timers
```
```bash
journalctl
journalctl -b
journalctl -u
journalctl -f
journalctl -n
journalctl -p
```
```text
Automate
   ↓
Execute
   ↓
Observe
   ↓
Investigate
   ↓
Fix
```
```text
backup.service
backup.timer
backup.sh
system_scheduler.sh
```

---

## Day 14 — Week 2 Review & Integration Project
```bash
ps aux
ps -ef
pgrep <process>
pgrep -a <process>
top
htop
```
```bash
systemctl status nginx
```
```bash
sudo systemctl start nginx
```
```bash
sudo systemctl stop nginx
```
```bash
sudo systemctl restart nginx
```
```bash
sudo systemctl enable nginx
```
```bash
sudo systemctl disable nginx
```
```bash
systemctl is-active nginx
```
```bash
systemctl is-enabled nginx
```
```ini
Wants=
```
```ini
Requires=
```
```ini
[Unit]
Wants=network-online.target
```
```ini
[Unit]
Requires=network-online.target
```
```text
Wants    = "I would like this too."
Requires = "I need this."
```
```bash
kill -TERM <PID>
```
```bash
kill -KILL <PID>
```
```bash
trap 'shutdown' SIGTERM
```
```bash
shutdown() {
    echo "Guardian shutting down..."
}
```
```bash
journalctl
```
```bash
journalctl -n 20
```
```bash
journalctl -f
```
```bash
journalctl -u nginx
```
```bash
journalctl -u nginx -f
```
```bash
journalctl -b
```
```bash
logger -t process-guardian "Test guardian message"
```
```bash
journalctl -t process-guardian
```
```bash
mkdir -p ~/process-guardian
cd ~/process-guardian
```
```text
process-guardian/
├── process_guardian.sh
├── processes_to_guard.cfg
├── process_guardian.service
└── README.md
```
```text
processes_to_guard.cfg
```
```text
# name|restart_method|restart_target

nginx|systemd|nginx.service
```
```text
Configuration
      ↓
Monitoring Logic
```
```bash
pgrep -x nginx
```
```bash
if ! pgrep -x "$process_name" > /dev/null; then
    echo "$process_name is down"
fi
```
```bash
sudo systemctl restart nginx.service
```
```bash
systemctl is-active nginx.service
```
```text
Process stops
     ↓
Guardian detects failure
     ↓
systemctl restart
     ↓
Service starts again
```
```bash
/opt/myapp/start.sh
```
```text
Systemd service
      OR
Direct command
```
```text
3 restarts within 5 minutes
        ↓
      ALERT
```
```text
16:00:10 → Restart #1
16:02:30 → Restart #2
16:04:15 → Restart #3
```
```text
ALERT: nginx restarted 3 times within 5 minutes
```
```text
nginx:
    16:00:10
    16:02:30
    16:04:15
```
```text
300 seconds
```
```bash
logger -t process-guardian \
    "ALERT: nginx restarted 3 times within 5 minutes"
```
```bash
journalctl -t process-guardian
```
```text
systemctl stop process-guardian
            ↓
          SIGTERM
            ↓
      shutdown handler
            ↓
  stop guarded processes
            ↓
       write log
            ↓
           exit
```
```bash
shutdown() {
    logger -t process-guardian "Guardian shutting down"

    # Stop guarded processes here

    exit 0
}

trap shutdown SIGTERM
```
```text
                    systemd
                       │
                       ▼
          process_guardian.service
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
              │
        ┌─────┼─────┐
        ▼     ▼     ▼
      nginx   API  worker
```
```text
Process crashes
      ↓
Guardian detects failure
      ↓
Restart process
      ↓
Log restart
      ↓
Update restart counter
      ↓
3 failures in 5 minutes?
      ↓
     YES
      ↓
Write ALERT
```
```text
process_guardian.service
```
```ini
[Unit]
Description=Process Guardian
After=network.target

[Service]
Type=simple
ExecStart=/path/to/process_guardian.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```
```ini
Restart=always
RestartSec=5
```
```text
Guardian
    ↓
Application crashes
    ↓
Guardian detects it
    ↓
Guardian restarts application
```
```text
Guardian crashes
    ↓
systemd detects failure
    ↓
systemd waits 5 seconds
    ↓
systemd restarts Guardian
```
```text
systemd
   │
   ▼
Guardian
   │
   ├── nginx
   ├── API
   └── worker
```
```bash
ps aux
```
```bash
pgrep -a bash
```
```bash
systemctl status nginx
```
```bash
systemctl is-active nginx
```
```bash
sleep 1000 &
```
```bash
pgrep -a sleep
```
```bash
kill -TERM <PID>
```
```bash
pgrep -a sleep
```
```bash
logger -t process-guardian "Test guardian message"
```
```bash
journalctl -t process-guardian -n 10
```
```text
PROCESS DOWN
```
```text
RESTARTING PROCESS
```
```text
PROCESS RESTARTED
```
```text
Restart #1
Restart #2
Restart #3
```
```text
ALERT: process restarted 3 times within 5 minutes
```
```bash
journalctl -t process-guardian
```
```bash
sudo systemctl stop process-guardian
```
```bash
journalctl -u process-guardian -f
```
```bash
systemctl status process-guardian
```
```bash
sudo systemctl start process-guardian
```
```bash
sudo systemctl stop process-guardian
```
```bash
sudo systemctl restart process-guardian
```
```bash
journalctl -u process-guardian
```
```bash
journalctl -u process-guardian -f
```
```bash
journalctl -t process-guardian
```
```text
Monitor
   ↓
Detect
   ↓
Recover
   ↓
Observe
   ↓
Alert
```
```text
Linux systemd
      ↓
Docker
      ↓
Kubernetes
      ↓
AWS ECS
      ↓
Cloud monitoring
```
```text
Detect failure → Recover automatically → Record what happened
```
```text
Day 8
systemd + process lifecycle
        ↓
Day 9
Process monitoring
        ↓
Day 10
Signals + jobs
        ↓
Day 11
Cron + scheduled tasks
        ↓
Day 12
systemd services
        ↓
Day 13
systemd timers + journal
        ↓
Day 14
Process automation + integration
```
```text
process_guardian.sh
process_guardian.service
processes_to_guard.cfg
README.md
```
```bash
git add .
```
```bash
git commit -m "Week 2: Process automation and systemd integration"
```
```bash
git push
```
```text
A process can fail.
        ↓
Assume failure will happen.
        ↓
Detect it automatically.
        ↓
Recover automatically.
        ↓
Log what happened.
        ↓
Alert when recovery keeps failing.
```

---

