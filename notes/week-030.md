# Week 30 Notes

## 🐧 Day 204 / 1000 — Linux Mastery: Day 9 / 30
## Process Fundamentals & Lifecycle







---

# 1. What Is a Process?

A **process is a running instance of a program**.

A program is static code stored on disk.

A process is that program while it is executing.

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

Example:

```bash
python3 server.py
```

`server.py` is the program.

The running Python instance is the process.

---

# 2. PID — Process ID

Every Linux process has a **Process ID (PID)**.

Check running processes:

```bash
ps
```

Example:

```text
PID   TTY          TIME CMD
421   pts/0    00:00:00 bash
582   pts/0    00:00:00 ps
```

Inspect a specific process:

```bash
ps -p 421
```

More detailed:

```bash
ps -p 421 -o pid,ppid,cmd,stat
```

---

# 3. PPID — Parent Process ID

Processes normally have a parent process.

Example:

```text
systemd
   │
   └── bash
        │
        └── python
             │
             └── worker
```

If Python has PID `582` and its parent shell has PID `421`:

```text
PID  = 582
PPID = 421
```

Check the current shell:

```bash
echo $$
```

Then:

```bash
ps -p $$ -o pid,ppid,cmd,stat
```

---

# 4. Process Tree

Linux processes form a hierarchy.

Use:

```bash
pstree -p
```

Example:

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

This allows us to answer:

> Who created or launched this process?

---

# 5. PID 1 — systemd

On a modern Linux system using systemd:

```text
systemd = PID 1
```

Check:

```bash
ps -p 1 -o pid,ppid,cmd
```

Or:

```bash
ps -p 1 -o comm=
```

Typical output:

```text
systemd
```

PID 1 is responsible for important parts of system initialization and process management.

Conceptually:

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

---

# 6. Evolution of Linux Init Systems

The simplified evolution is:

```text
SysV init
    ↓
Upstart
    ↓
systemd
```

### SysV init

Traditional init system based heavily around startup scripts.

Common location:

```text
/etc/init.d/
```

### Upstart

Introduced more event-driven service management.

### systemd

Modern service and system manager.

It manages things such as:

* Services
* Dependencies
* Boot process
* Timers
* Sockets
* Logging integration
* Resource controls

Main command:

```bash
systemctl
```

---

# 7. Process States

Linux processes can exist in different states.

Common states:

| State | Meaning               |
| ----- | --------------------- |
| `R`   | Running / Runnable    |
| `S`   | Sleeping              |
| `D`   | Uninterruptible Sleep |
| `T`   | Stopped               |
| `Z`   | Zombie                |

Check states:

```bash
ps aux
```

Look at the `STAT` column.

---

# 8. R — Running / Runnable

```text
R
```

The process is currently running or ready to run.

Example:

```bash
python3 cpu_intensive.py
```

A CPU-heavy process may frequently appear as:

```text
R
```

---

# 9. S — Sleeping

```text
S
```

The process is sleeping or waiting for an event.

Example:

```python
import time

while True:
    time.sleep(10)
```

The process isn't constantly consuming CPU.

It waits until it needs to continue.

---

# 10. D — Uninterruptible Sleep

```text
D
```

Usually indicates that a process is waiting inside a kernel-level operation, commonly associated with I/O.

Conceptually:

```text
Process
   ↓
Kernel
   ↓
I/O operation
   ↓
Waiting
```

Processes stuck in `D` state can be important when diagnosing storage or I/O problems.

Check for them:

```bash
ps aux | awk '$8 ~ /D/ {print}'
```

---

# 11. T — Stopped

```text
T
```

The process has been stopped.

For example:

```bash
sleep 1000
```

Press:

```text
Ctrl + Z
```

Then check:

```bash
ps
```

The process may appear with:

```text
T
```

Continue it in the foreground:

```bash
fg
```

Or background:

```bash
bg
```

---

# 12. Z — Zombie

A zombie is a process that has finished executing but whose parent has not yet collected its exit status.

Lifecycle:

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

A zombie is **not actively executing**.

It exists because the parent has not yet reaped the child's termination status.

---

# 13. Process Lifecycle

Simplified lifecycle:

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

---

# 14. fork()

`fork()` creates a new child process.

Conceptually:

```text
Parent
  │
 fork()
  │
  ├──────────→ Parent
  │
  └──────────→ Child
```

The child receives its own PID.

---

# 15. exec()

`exec()` replaces the current process's program image with another program.

Conceptually:

```text
bash process
     │
    exec()
     ↓
  ls program
```

The process can keep its PID while the program being executed changes.

---

# 16. wait()

The parent can use `wait()` to collect the child's termination status.

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

This is how a parent prevents an exited child from remaining as a zombie.

---

# 17. exit()

When a process finishes:

```text
process
   ↓
exit()
   ↓
termination status
   ↓
parent collects status
```

The process no longer executes.

---

# 18. `/proc` — Linux Process Information

Linux exposes process information through:

```text
/proc
```

List it:

```bash
ls /proc
```

You'll see directories such as:

```text
1
2
100
421
582
```

These numeric directories correspond to PIDs.

For example:

```text
/proc/582/
```

contains information about PID `582`.

---

# 19. `/proc/<PID>/cmdline`

Check the current shell:

```bash
cat /proc/$$/cmdline
```

Arguments are separated by NUL characters.

Make them readable:

```bash
tr '\0' ' ' < /proc/$$/cmdline
echo
```

This shows the command used to launch the process.

---

# 20. `/proc/<PID>/environ`

View environment variables:

```bash
tr '\0' '\n' < /proc/$$/environ
```

Example:

```text
HOME=/home/kevz
USER=kevz
PATH=...
SHELL=...
PWD=...
```

Environment variables are important in:

* Docker
* Kubernetes
* CI/CD
* AWS workloads
* Application configuration

Security note:

> Environment variables should not automatically be treated as secret storage. Processes with sufficient permissions may be able to inspect another process's environment.

---

# 21. `/proc/<PID>/fd`

File descriptors:

```bash
ls -l /proc/$$/fd
```

Common descriptors:

```text
0 = stdin
1 = stdout
2 = stderr
```

Example:

```text
0 -> /dev/pts/0
1 -> /dev/pts/0
2 -> /dev/pts/0
```

Conceptually:

```text
Process
 │
 ├── FD 0 → stdin
 ├── FD 1 → stdout
 ├── FD 2 → stderr
 └── FD 3 → file/socket
```

---

# 22. `/proc/<PID>/status`

Inspect process information:

```bash
cat /proc/$$/status
```

Useful fields include:

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

A focused command:

```bash
grep -E 'Name|Pid|PPid|State|Threads|VmRSS' /proc/$$/status
```

---

# 23. `/proc/<PID>/maps`

View the process's memory mappings:

```bash
cat /proc/$$/maps
```

These can represent:

* Program memory
* Shared libraries
* Heap
* Stack
* Memory-mapped files

Conceptually:

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

---

# 24. ps aux

Run:

```bash
ps aux
```

Useful columns include:

```text
USER
PID
%CPU
%MEM
STAT
COMMAND
```

This is useful for quickly viewing resource usage and process state.

---

# 25. ps -ef

Run:

```bash
ps -ef
```

Important columns:

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

`PPID` makes this format particularly useful for understanding parent-child relationships.

---

# 26. ps auxf

Run:

```bash
ps auxf
```

The `f` provides a forest-style process hierarchy.

This makes process relationships easier to visualize.

---

# 27. Hands-On Lab

## Lab 1 — Inspect Your Shell

```bash
echo $$
```

Then:

```bash
ps -p $$ -o pid,ppid,cmd,stat
```

Record:

```text
PID:
PPID:
CMD:
STATE:
```

---

## Lab 2 — Explore `/proc`

```bash
echo $$
```

Then:

```bash
ls -la /proc/$$/
```

Inspect:

```bash
cat /proc/$$/status
```

Command line:

```bash
tr '\0' ' ' < /proc/$$/cmdline
echo
```

Environment:

```bash
tr '\0' '\n' < /proc/$$/environ
```

File descriptors:

```bash
ls -l /proc/$$/fd
```

---

## Lab 3 — Process Tree

Run:

```bash
pstree -p
```

Then:

```bash
pstree -p $$
```

Identify:

```text
Current shell
    ↓
Parent process
    ↓
PID 1 / systemd
```

---

## Lab 4 — Compare ps Commands

Run:

```bash
ps aux
```

```bash
ps -ef
```

```bash
ps auxf
```

Understand what information each format makes easiest to see.

---

# 28. Parent-Child Process Script

Create:

```text
process_tree.py
```

Code:

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

Run:

```bash
python3 process_tree.py
```

From another terminal:

```bash
pstree -p
```

Expected relationship:

```text
bash
 └── python
      └── python
```

The exact output depends on the environment.

---

# 29. Zombie Process Experiment

Create:

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

Run:

```bash
python3 zombie.py
```

Then:

```bash
ps -o pid,ppid,stat,cmd
```

Look for:

```text
Z
```

Example:

```text
PID    PPID   STAT   CMD
1234   1000   S      python3 zombie.py
1235   1234   Z      [python3] <defunct>
```

The child has exited, but the parent has not collected its exit status.

---

# 30. Cloud Infrastructure Connection ☁️

Process management is foundational to cloud infrastructure.

A typical Linux server can look conceptually like:

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

Later, containers introduce concepts such as:

```text
PID namespaces
Network namespaces
Mount namespaces
```

And Kubernetes builds additional orchestration around these Linux primitives.

Therefore:

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

Understanding processes now will make those later topics much easier.

---

# 🧠 Key Takeaways

### Process

A running instance of a program.

### PID

Unique process identifier.

### PPID

Parent process identifier.

### PID 1

The initial userspace process, commonly systemd on modern Linux distributions.

### Process states

```text
R = Running/Runnable
S = Sleeping
D = Uninterruptible Sleep
T = Stopped
Z = Zombie
```

### `/proc`

Kernel-provided interface exposing information about running processes and the system.

### fork()

Creates a child process.

### exec()

Replaces a process's program image.

### wait()

Allows a parent to collect a child's termination status.

### exit()

Terminates a process.

---

# 🎯 Day 9 Deliverable

## Process Lifecycle & States Diagram

Create a diagram showing:

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

## Script

Create:

```text
process_tree.py
```

Demonstrate:

* Parent PID
* Child PID
* Parent-child relationship
* Process tree

## Bonus

Create:

```text
zombie.py
```

and observe the `Z` state using `ps`.

---

# 🔥 Day 9 Completion Checklist

* [x] Understand program vs process
* [x] Understand PID
* [x] Understand PPID
* [x] Understand process hierarchy
* [x] Understand PID 1
* [x] Understand systemd's role
* [x] Understand `R`
* [x] Understand `S`
* [x] Understand `D`
* [x] Understand `T`
* [x] Understand `Z`
* [x] Understand `fork()`
* [x] Understand `exec()`
* [x] Understand `wait()`
* [x] Understand `exit()`
* [x] Explored `/proc/$$`
* [x] Inspected `/proc/<PID>/status`
* [x] Inspected `/proc/<PID>/environ`
* [x] Inspected `/proc/<PID>/fd`
* [x] Inspected `/proc/<PID>/maps`
* [x] Used `ps aux`
* [x] Used `ps -ef`
* [x] Used `ps auxf`
* [x] Used `pstree -p`
* [x] Created parent-child process
* [x] Created/observed a zombie process
* [x] Completed process lifecycle diagram

---

## 🚀 Day 9 → Day 10

Today's mental model:

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
## Monitoring & Managing Processes






---

# 1. What Is a Process?

A **process** is a running instance of a program.

When Linux executes:

```bash
python app.py
```

the kernel creates a process and assigns it a unique **PID (Process ID)**.

Every process has information such as:

* PID
* Parent PID (PPID)
* User
* CPU usage
* Memory usage
* Process state
* Scheduling priority
* Command

Find the PID of the current shell:

```bash
echo $$
```

---

# 2. `top`

`top` is one of the most important Linux process monitoring tools.

```bash
top
```

Typical output contains:

```text
PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM COMMAND
1024 kevz      20   0  450000  82000  12000 R  45.2  0.5 python
2310 root      20   0  200000  35000   8000 S   8.2  0.2 nginx
4821 kevz      20   0   15000   6000   4000 S   0.0  0.1 bash
```

## Important Fields

| Field   | Meaning             |
| ------- | ------------------- |
| PID     | Process ID          |
| USER    | Process owner       |
| PR      | Scheduling priority |
| NI      | Nice value          |
| VIRT    | Virtual memory      |
| RES     | Resident memory     |
| SHR     | Shared memory       |
| S       | Process state       |
| %CPU    | CPU utilization     |
| %MEM    | Memory utilization  |
| COMMAND | Executable/command  |

---

# 3. Process States

Common Linux process states:

```text
R = Running / Runnable
S = Sleeping
D = Uninterruptible Sleep
T = Stopped
Z = Zombie
```

A process being in `S` does not necessarily mean there is a problem.

Most processes spend a lot of their time sleeping while waiting for work.

---

# 4. Useful `top` Shortcuts

Inside `top`:

| Key | Action         |
| --- | -------------- |
| `P` | Sort by CPU    |
| `M` | Sort by memory |
| `N` | Sort by PID    |
| `k` | Kill a process |
| `q` | Quit           |

Practice:

```text
P
M
N
k
q
```

---

# 5. `htop`

`htop` provides an interactive and more user-friendly process monitor.

```bash
htop
```

It displays:

* CPU usage
* Memory
* Swap
* Processes
* CPU utilization per core
* Process hierarchy
* Process IDs

Use it to:

1. Sort by CPU
2. Sort by memory
3. Inspect running processes
4. Identify resource-heavy processes

---

# 6. `glances`

`glances` provides a broader system overview.

```bash
glances
```

It can display:

* CPU
* Memory
* Swap
* Load
* Processes
* Network
* Disk activity

### Tool Comparison

| Tool      | Primary Purpose                |
| --------- | ------------------------------ |
| `top`     | Standard process monitoring    |
| `htop`    | Interactive process monitoring |
| `glances` | Broad system overview          |

---

# 7. Finding Processes with `pgrep`

Find all Bash processes:

```bash
pgrep bash
```

Show PID and command:

```bash
pgrep -a bash
```

Example:

```text
4210 /bin/bash
4382 /bin/bash ./backup.sh
4821 /bin/bash
```

`pgrep` is useful for scripting because it allows processes to be found without manually parsing `ps`.

---

# 8. `pidof`

`pidof` finds PIDs associated with a program.

```bash
pidof bash
```

Example:

```text
4821 4382 4210
```

### `pgrep` vs `pidof`

```text
pgrep → flexible pattern-based process searching

pidof → find PIDs associated with a program
```

---

# 9. `kill`

`kill` sends a signal to a process.

Example:

```bash
kill <PID>
```

A common signal is:

```bash
kill -TERM <PID>
```

`SIGTERM` asks the process to terminate gracefully.

If a process refuses to terminate, a stronger signal can be used:

```bash
kill -KILL <PID>
```

or:

```bash
kill -9 <PID>
```

### Important

Do not immediately use `kill -9`.

Prefer:

```text
SIGTERM → graceful termination
```

before:

```text
SIGKILL → forced termination
```

---

# 10. `pkill`

`pkill` allows processes to be terminated based on their names or patterns.

Example:

```bash
pkill sleep
```

Test safely:

```bash
sleep 1000 &
```

Find it:

```bash
pgrep sleep
```

Terminate it:

```bash
pkill sleep
```

Verify:

```bash
pgrep sleep
```

---

# 11. `pkill -f`

The `-f` option matches the full command line.

Example:

```bash
pkill -f "python.*slow"
```

This could match:

```text
python slow_server.py
```

Before killing a process, inspect the matches:

```bash
pgrep -af "python.*slow"
```

Then terminate:

```bash
pkill -f "python.*slow"
```

### Infrastructure Rule

```text
OBSERVE
   ↓
VERIFY
   ↓
ACT
   ↓
MONITOR
```

Never blindly kill processes on a production system.

---

# 12. Process Priority

Linux uses scheduling priorities to determine how processes compete for CPU time.

The **nice value** normally ranges from:

```text
-20 → highest priority
  0 → default
+19 → lowest priority
```

Positive nice values make a process "nicer" to other processes by giving it lower scheduling priority.

---

# 13. `nice`

Start a process with a lower priority:

```bash
nice -n 10 ./long_task.sh
```

Check its nice value:

```bash
ps -o pid,ni,cmd -C long_task.sh
```

Example:

```text
PID    NI CMD
5120   10 ./long_task.sh
```

---

# 14. `renice`

`renice` changes the priority of an existing process.

Find the process:

```bash
pgrep -af long_task
```

Suppose the PID is:

```text
5120
```

Change its priority:

```bash
renice -n +5 -p 5120
```

Verify:

```bash
ps -p 5120 -o pid,ni,cmd
```

The nice value will have increased.

---

# 15. Important: Nice Is Not a CPU Limit

`nice` does not mean:

```text
"Allow this process to use only 10% CPU."
```

Instead, it influences **CPU scheduling priority**.

Think of it as:

```text
nice
  ↓
Scheduling preference
```

rather than:

```text
nice
  ↓
Hard CPU limit
```

---

# 16. Memory: RSS vs VSZ

Two important memory metrics are:

```text
RSS
VSZ
```

## RSS — Resident Set Size

RSS represents memory pages currently resident in physical RAM for the process.

It is useful when investigating actual physical memory usage.

Example:

```text
RSS = 180 MB
```

---

## VSZ — Virtual Memory Size

VSZ represents the process's virtual address space.

It can include:

* Allocated memory
* Shared libraries
* Memory mappings
* Memory that isn't currently resident in RAM

Example:

```text
VSZ = 2.5 GB
RSS = 180 MB
```

This does **not** mean the process is consuming 2.5 GB of physical RAM.

### Remember

```text
RSS → physical memory currently resident

VSZ → virtual address space
```

---

# 17. Load Average

Check load average:

```bash
uptime
```

Example:

```text
10:35:12 up 2 days, 4:20,
load average: 2.10, 1.50, 0.80
```

These represent:

```text
1 minute     5 minutes     15 minutes
   ↓             ↓             ↓
  2.10          1.50          0.80
```

---

# 18. Load Average Is Not CPU Percentage

This is one of the most important concepts today.

Load average represents the average number of tasks that are runnable or waiting in certain uninterruptible states.

It is **not simply CPU utilization**.

For example:

```text
CPU cores = 4
Load = 2
```

Conceptually:

```text
2 / 4 = 0.5
```

The runnable load is roughly half of available CPU capacity.

Compare that with:

```text
CPU cores = 1
Load = 2
```

Now:

```text
2 / 1 = 2
```

There is more runnable load than one CPU can immediately execute.

### Important

Always interpret load average relative to:

* Number of CPU cores
* CPU utilization
* Memory pressure
* I/O behavior
* System trend

---

# 19. Reading Load Trends

Example:

```text
load average: 0.50, 0.70, 0.90
```

The recent 1-minute load is lower than the 5- and 15-minute averages.

Another example:

```text
load average: 4.00, 2.00, 1.00
```

Recent load has increased significantly.

The goal isn't to memorize a universal "bad load number."

Instead ask:

> Is the load high relative to available CPU capacity, and is it increasing?

---

# 20. Linux Troubleshooting Workflow

When someone says:

> "The server is slow."

Use:

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

Useful commands:

```bash
uptime
free -h
top
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

---

# 21. Hands-On Lab

## Lab 1 — Explore `top`

Run:

```bash
top
```

Identify:

* Total processes
* Running processes
* Sleeping processes
* CPU idle percentage
* Memory usage
* Top CPU process
* Top memory process

Practice:

```text
P
M
N
k
q
```

---

## Lab 2 — Explore `htop`

Run:

```bash
htop
```

Sort by:

1. CPU
2. Memory

Observe which processes move to the top.

---

## Lab 3 — Find Bash Processes

```bash
pgrep bash
```

Then:

```bash
pgrep -a bash
```

Then:

```bash
pidof bash
```

Compare the results.

---

# 22. Lab 4 — Create and Manage a Test Process

Start:

```bash
sleep 1000 &
```

Find it:

```bash
pgrep -a sleep
```

Store its PID:

```bash
PID=$(pgrep -n sleep)
echo "$PID"
```

Inspect it:

```bash
ps -p "$PID" -o pid,ppid,stat,ni,vsz,rss,cmd
```

Terminate it:

```bash
kill "$PID"
```

Verify:

```bash
pgrep sleep
```

---

# 23. Lab 5 — Nice and Renice

Start a low-priority process:

```bash
nice -n 10 ./long_task.sh &
```

Find it:

```bash
pgrep -af long_task
```

Inspect priority:

```bash
ps -p <PID> -o pid,ni,cmd
```

Change priority:

```bash
renice -n +5 -p <PID>
```

Verify:

```bash
ps -p <PID> -o pid,ni,cmd
```

---

# 24. Lab 6 — Stress the CPU

If `stress-ng` is installed:

```bash
stress-ng --cpu 2
```

Open another terminal:

```bash
top
```

Observe:

* CPU utilization
* Load average
* `stress-ng` processes
* Process states

Safer timed version:

```bash
timeout 30 stress-ng --cpu 2
```

This automatically stops the stress test after approximately 30 seconds.

---

# 25. Deliverable — `process_monitor.sh`

Create:

```bash
nano process_monitor.sh
```

Add:

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

Make it executable:

```bash
chmod +x process_monitor.sh
```

Run:

```bash
./process_monitor.sh
```

---

# 26. Expected Output Structure

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

---

# 27. What I Learned Today

### Process Monitoring

* `top`
* `htop`
* `glances`

### Process Discovery

* `pgrep`
* `pidof`
* `ps`

### Process Management

* `kill`
* `pkill`

### Process Scheduling

* `nice`
* `renice`

### Memory

* RSS
* VSZ
* SHR

### System Performance

* Load average
* CPU utilization
* Memory utilization
* Process states

### Automation

* Built `process_monitor.sh`

---

# 28. Key Commands

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

---

# 29. Day 9 Mental Model

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

---

# 🔥 Day 205 Challenge

Pretend you are the junior infrastructure engineer on call.

A server has been reported as:

> **"Slow."**

Without looking at the previous sections, investigate it using:

```bash
uptime
free -h
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

Then answer:

```text
1. What is the current load average?

2. How many CPU cores does the machine have?

3. Which process is consuming the most CPU?

4. Which process is consuming the most memory?

5. Based on the evidence, what would you investigate next?
```

---

# 🧠 Core Takeaway

> **Day 9 is not about memorizing `top`. It is about learning to observe a Linux machine, identify abnormal behavior, gather evidence, and take controlled action.**

The infrastructure mindset is:

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

---

## 📈 Journey Progress

```text
Linux Mastery
Day 9 / 30
█████████░░░░░░░░░░░░ 30%

AI Cloud Infrastructure Journey
Day 205 / 1000
████░░░░░░░░░░░░░░░░ 20.5%
```

**Day 205 / 1000 — Process Monitoring & Management**

**Goal: Become an AI Cloud Infrastructure Engineer by mastering the systems underneath the cloud.**

---

## 🐧 Day 206 / 1000 — Linux Mastery: Day 10 / 30
## Signals, Process Control & Job Management







---

Today is an important Linux day because you're moving from **“I can see processes”** to **“I can control processes safely.”**

As a cloud infrastructure engineer, this matters constantly: deployments, containers, systemd services, CI/CD jobs, autoscaling, graceful shutdowns, and production incidents all depend on process control.

---

# 1. The Mental Model

Think of a Linux process as a running worker:

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

A **signal** is basically a notification sent to a process.

For example:

```bash
kill -TERM 42
```

means:

> "Process 42, please terminate cleanly."

It does **not** necessarily mean "destroy this process immediately."

---

# 2. What Exactly Is a Signal?

A signal is an asynchronous event delivered to a process.

Linux defines many signals:

```bash
kill -l
```

You'll see things like:

```text
1)  SIGHUP
2)  SIGINT
9)  SIGKILL
15) SIGTERM
...
```

You can think of signals as messages:

```text
SIGTERM → "Please shut down."
SIGKILL → "STOP. NOW."
SIGHUP  → "Your controlling terminal disappeared / reload."
SIGINT  → "User interrupted you."
```

---

# 3. The Four Signals You Need Today

## SIGTERM — 15

```text
SIGTERM = Terminate
```

Send:

```bash
kill -TERM <PID>
```

or:

```bash
kill -15 <PID>
```

or simply:

```bash
kill <PID>
```

`kill <PID>` normally means SIGTERM.

### Important

SIGTERM is **request-based**.

The process can catch it:

```text
SIGTERM
   ↓
trap
   ↓
cleanup
   ↓
exit
```

That's why it is the preferred way to shut down a process.

---

# 4. SIGKILL — 9

```text
SIGKILL = Kill immediately
```

```bash
kill -9 <PID>
```

The kernel terminates the process immediately.

The process **cannot catch SIGKILL**.

Therefore this won't work:

```bash
trap 'echo cleanup' SIGKILL
```

You cannot handle SIGKILL.

Think:

```text
SIGTERM
   ↓
"Please leave."

Process:
"Okay, let me save my work."
```

versus:

```text
SIGKILL
   ↓
"You're done."

Process:
"..."
💀
```

---

# 5. Why SIGTERM Matters in Cloud Infrastructure

Imagine your application is writing data:

```text
Application
    ↓
Database
    ↓
Transaction
```

Suddenly AWS/your orchestrator wants to terminate the application.

If it gets SIGTERM:

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

That's a **graceful shutdown**.

This concept appears everywhere:

* Docker
* Kubernetes
* systemd
* load balancers
* CI/CD
* rolling deployments
* autoscaling
* cloud servers

So today's Linux lesson directly connects to your future infrastructure work.

---

# 6. SIGHUP — Signal 1

Historically:

```text
SIGHUP = Hang Up
```

Originally associated with a terminal disconnecting.

Today, many daemons use SIGHUP as:

> "Reload your configuration."

For example:

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

The important difference:

```text
restart:
process dies → process starts again

reload:
process stays alive → configuration changes
```

This is extremely useful for services that should not experience unnecessary downtime.

---

# 7. SIGUSR1 — Signal 10

`SIGUSR1` is a **user-defined signal**.

It doesn't have one universal meaning.

Your application decides what it means.

For example:

```bash
kill -USR1 <PID>
```

Your application could interpret that as:

```text
SIGUSR1
   ↓
Enable debug logging
```

or:

```text
SIGUSR1
   ↓
Dump statistics
```

or:

```text
SIGUSR1
   ↓
Reload something
```

It's application-defined.

---

# 8. SIGINT — Ctrl+C

You should also know:

```text
Ctrl+C → SIGINT
```

For example:

```bash
sleep 100
```

Press:

```text
Ctrl+C
```

The terminal sends SIGINT to the foreground process.

Usually:

```text
Ctrl+C
   ↓
SIGINT
   ↓
process terminates
```

---

# 9. `kill` Does NOT Necessarily Mean "Kill"

This is an important Linux concept.

The command:

```bash
kill
```

is actually a **signal-sending command**.

For example:

```bash
kill -TERM 1234
```

sends SIGTERM.

```bash
kill -HUP 1234
```

sends SIGHUP.

```bash
kill -USR1 1234
```

sends SIGUSR1.

So remember:

> `kill` = send a signal.

---

# 10. Finding a Process

Start:

```bash
sleep 500
```

Find it:

```bash
pgrep sleep
```

or:

```bash
ps aux | grep sleep
```

Suppose you get:

```text
2451
```

Then:

```bash
kill -TERM 2451
```

Check:

```bash
pgrep sleep
```

Nothing appears.

---

# 11. `trap` — The Important Part

Now we reach the really useful scripting concept.

Bash can listen for signals using:

```bash
trap
```

Basic syntax:

```bash
trap 'commands' SIGNAL
```

Example:

```bash
trap 'echo "Received SIGTERM"' SIGTERM
```

Now your script can react when SIGTERM arrives.

---

# 12. Your First Signal-Handling Script

Create:

```bash
nano signal_demo.sh
```

Put:

```bash
#!/bin/bash

trap 'echo "Received SIGTERM. Cleaning up..."' SIGTERM

echo "PID: $$"

while true; do
    echo "Working..."
    sleep 2
done
```

Make executable:

```bash
chmod +x signal_demo.sh
```

Run:

```bash
./signal_demo.sh
```

You'll see:

```text
PID: 3124
Working...
Working...
Working...
```

Now from another terminal:

```bash
kill -TERM 3124
```

You'll see:

```text
Received SIGTERM. Cleaning up...
```

But notice something important:

**the script may continue running.**

Why?

Because you only told `trap` what to do when SIGTERM arrives.

You didn't tell the script to exit.

---

# 13. Graceful Shutdown

Now make it actually exit.

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

Now:

```bash
./signal_demo.sh
```

Find PID:

```bash
pgrep -f signal_demo.sh
```

Then:

```bash
kill -TERM <PID>
```

The flow becomes:

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

That's graceful termination.

---

# 14. The Special Variable `$$`

Inside a Bash script:

```bash
$$
```

means:

> PID of the current shell.

Example:

```bash
echo "My PID is $$"
```

Output:

```text
My PID is 4218
```

This is extremely useful when testing signal handling.

---

# 15. Graceful vs Forced Termination

This distinction should become automatic in your head.

### Graceful

```bash
kill -TERM <PID>
```

Process gets an opportunity to:

```text
save
cleanup
close
flush
exit
```

### Forced

```bash
kill -KILL <PID>
```

or:

```bash
kill -9 <PID>
```

Process gets:

```text
NO cleanup opportunity
```

So operationally:

```text
SIGTERM
   ↓
wait
   ↓
still alive?
   ↓
SIGKILL
```

This is exactly what your Day 10 deliverable will implement.

---

# 16. Background Jobs

Normally:

```bash
sleep 100
```

occupies your terminal.

But:

```bash
sleep 100 &
```

runs it in the background.

Output might be:

```text
[1] 5432
```

Meaning:

```text
Job number = 1
PID        = 5432
```

Your terminal is immediately available again.

---

# 17. `jobs`

See background jobs:

```bash
jobs
```

Example:

```text
[1]+  Running    sleep 100 &
```

This is a **shell job**, not simply a process list.

That's an important distinction.

---

# 18. `fg`

Bring a background job into the foreground:

```bash
fg
```

or:

```bash
fg %1
```

Now it owns your terminal again.

---

# 19. Ctrl+Z

Run:

```bash
sleep 100
```

Then press:

```text
Ctrl+Z
```

The process is **stopped**, not terminated.

You may see:

```text
[1]+  Stopped    sleep 100
```

Check:

```bash
jobs
```

---

# 20. `bg`

Resume the stopped job in the background:

```bash
bg
```

Now:

```bash
jobs
```

might show:

```text
[1]+ Running sleep 100 &
```

The lifecycle is:

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

---

# 21. `nohup`

Suppose you run:

```bash
./long_task.sh &
```

and then close your terminal.

Depending on how the process is attached to the shell/session, it may receive SIGHUP or otherwise stop when the session disappears.

`nohup` is designed to make a command ignore SIGHUP.

```bash
nohup ./long_task.sh &
```

Output is commonly redirected to:

```text
nohup.out
```

So:

```bash
nohup ./long_task.sh &
```

roughly means:

> "Keep this command running even if the terminal disconnects."

---

# 22. `disown`

Bash also has:

```bash
disown
```

Suppose:

```bash
./long_task.sh &
```

Check:

```bash
jobs
```

Then:

```bash
disown %1
```

Now Bash no longer considers that job one of its jobs.

Check:

```bash
jobs
```

It won't appear.

A common pattern is:

```bash
nohup ./long_task.sh &
disown
```

---

# 23. `nohup` vs `disown`

Don't confuse them.

### `nohup`

Changes how the process handles SIGHUP.

```text
nohup
 ↓
ignore hangup
```

### `disown`

Changes the shell's relationship with the job.

```text
disown
 ↓
remove job from shell's job table
```

Together:

```bash
nohup ./long_task.sh &
disown
```

can detach the task from your interactive shell.

---

# 24. Your Day 10 Mini Project

Your deliverable:

```text
graceful_killer.sh
```

The idea:

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

A basic implementation:

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

Run:

```bash
chmod +x graceful_killer.sh
```

Then:

```bash
./graceful_killer.sh <PID>
```

---

# 25. Understand `kill -0`

This is a really useful trick.

```bash
kill -0 <PID>
```

doesn't actually send a terminating signal.

Instead, it lets you test whether the process exists/is signalable.

So:

```bash
if kill -0 "$PID" 2>/dev/null; then
    echo "Process exists"
else
    echo "Process does not exist"
fi
```

This pattern is extremely useful in scripts.

---

# 26. Build a Test Process

Create:

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

Then:

```bash
chmod +x long_task.sh
```

Run:

```bash
./long_task.sh
```

In another terminal:

```bash
./graceful_killer.sh <PID>
```

You should see:

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

Your killer should **not** need SIGKILL.

---

# 27. Now Test a Stubborn Process

Create:

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

Run:

```bash
chmod +x stubborn.sh
./stubborn.sh
```

Then:

```bash
./graceful_killer.sh <PID>
```

Now:

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

**That's the exact behavior your project is supposed to demonstrate.**

---

# 28. SIGHUP Configuration Reload Demo

Now build the second hands-on experiment.

Create:

```bash
config.txt
```

```text
MODE=production
```

Create:

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

Run:

```bash
chmod +x reload_demo.sh
./reload_demo.sh
```

You might see:

```text
Configuration loaded: MODE=production
PID: 5000
Running with MODE=production
```

Change:

```text
MODE=maintenance
```

Then:

```bash
kill -HUP 5000
```

The process remains alive but reloads:

```text
SIGHUP received.
Reloading configuration...
Configuration loaded: MODE=maintenance
```

This is a very important production pattern:

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

---

# 29. The Process-Control Cheat Sheet

| Command           | Meaning                                   |
| ----------------- | ----------------------------------------- |
| `kill PID`        | Send SIGTERM                              |
| `kill -TERM PID`  | Graceful termination request              |
| `kill -KILL PID`  | Force termination                         |
| `kill -9 PID`     | Force termination                         |
| `kill -HUP PID`   | Send SIGHUP                               |
| `kill -USR1 PID`  | Send SIGUSR1                              |
| `kill -0 PID`     | Test whether process exists/is signalable |
| `jobs`            | Show shell jobs                           |
| `fg`              | Bring job foreground                      |
| `bg`              | Resume job in background                  |
| `Ctrl+C`          | Send SIGINT                               |
| `Ctrl+Z`          | Stop foreground job                       |
| `nohup command &` | Protect command from SIGHUP               |
| `disown`          | Remove job from shell job table           |
| `trap`            | Handle signals in shell scripts           |

---

# 30. The Infrastructure Engineer Connection

This is the part I want you to remember from **Day 206**.

Eventually you'll see:

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

For example, a deployment might look conceptually like:

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

If the application refuses to exit:

```text
SIGTERM
   ↓
wait
   ↓
timeout
   ↓
SIGKILL
```

That's why today's seemingly simple Bash lesson is actually foundational infrastructure knowledge.

---

# 🎯 Day 10 Challenge

Don't just read this. Do this sequence.

### Challenge 1 — Signal basics

```bash
sleep 300 &
jobs
pgrep sleep
kill -TERM <PID>
```

### Challenge 2 — Process control

```bash
sleep 300
```

Press:

```text
Ctrl+Z
```

Then:

```bash
jobs
bg
jobs
fg
```

### Challenge 3 — Graceful shutdown

Build:

```text
long_task.sh
```

with:

```bash
trap cleanup SIGTERM
```

and prove that cleanup runs.

### Challenge 4 — Forced shutdown

Run the stubborn process and execute:

```bash
kill -TERM <PID>
```

Wait.

Then:

```bash
kill -9 <PID>
```

Observe the difference.

### Challenge 5 — Your actual deliverable

Build:

```text
graceful_killer.sh
```

It must:

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

### Challenge 6 — SIGHUP

Build:

```text
reload_demo.sh
```

Change its configuration while it is running and use:

```bash
kill -HUP <PID>
```

to reload without restarting.

---

## 🧠 Day 10 Knowledge Check

Before marking Day 10 complete, you should be able to answer these **without looking up the notes**:

1. Why is SIGTERM preferred over SIGKILL?
2. Why can't a process handle SIGKILL?
3. What does `trap` do?
4. What does `$$` represent?
5. What does `kill -0 PID` actually do?
6. What's the difference between `bg` and `fg`?
7. What does `Ctrl+Z` do?
8. What problem does `nohup` solve?
9. What does `disown` do?
10. Why might an application use SIGHUP?
11. What happens when a process ignores SIGTERM?
12. Why is graceful shutdown important during cloud deployments?

If you can explain those **from memory and demonstrate them in your terminal**, you've genuinely completed **Linux Day 10/30** rather than just reading Day 10.

**Day 10/30 → Signals & Process Control ✅**  
**Day 206/1000 → 20.6% of the journey**

---

## 🐧 Day 207 / 1000 — Linux Mastery: Day 11 / 30
## Cron, `at` & Scheduled Automation







---

Today is an important Linux day because you're moving from **“I can control processes”** to **“I can make the system run work automatically.”**

As a cloud infrastructure engineer, scheduled automation is everywhere: backups, log rotation, cleanup jobs, health check reports, maintenance tasks, CI/CD pipelines, database vacuuming, Kubernetes CronJobs, and cloud schedulers all depend on the same fundamental idea.

You define **when** something should happen.  
Linux takes care of **running it**.

---

# 1. The Mental Model

Think of a scheduled task as an automated contract with the operating system:

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

The system daemon (`cron` / `crond`) wakes up every 60 seconds, reads configuration tables (crontabs), checks if any scheduled task matches the current minute, and spawns the configured command in an isolated subshell.

---

# 2. Cron Daemon Architecture

Linux scheduled tasks operate at two levels:

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

### System Drop-in Directories:
Linux provides standardized interval directories for system maintenance:
* `/etc/cron.hourly/` — Scripts executed once every hour.
* `/etc/cron.daily/` — Scripts executed once every day (usually overnight).
* `/etc/cron.weekly/` — Scripts executed once a week.
* `/etc/cron.monthly/` — Scripts executed once a month.

---

# 3. The 5-Field Crontab Syntax

A standard crontab entry consists of 5 time fields followed by the command to execute:

```text
 ┌───────────── Minute (0 - 59)
 │ ┌────────────── Hour (0 - 23)
 │ │ ┌─────────────── Day of Month (1 - 31)
 │ │ │ ┌──────────────── Month (1 - 12 or JAN - DEC)
 │ │ │ │ ┌───────────────── Day of Week (0 - 7 or SUN - SAT, 0 & 7 = Sun)
 │ │ │ │ │
 * * * * * <command-to-execute>
```

### Operators:
* `*` : Every possible value (any minute, any hour, etc.).
* `,` : Value list (e.g. `1,15,30` $\rightarrow$ run at minutes 1, 15, and 30).
* `-` : Range of values (e.g. `1-5` in Day of Week $\rightarrow$ Monday through Friday).
* `/` : Step intervals (e.g. `*/15` $\rightarrow$ every 15 minutes; `0 */2 * * *` $\rightarrow$ every 2 hours).

### Practical Timing Examples:

| Expression | Interpretation |
|---|---|
| `* * * * *` | Every single minute. |
| `*/5 * * * *` | Every 5 minutes. |
| `0 2 * * *` | Every day at 02:00 AM. |
| `0 0 * * 0` | Every Sunday at midnight. |
| `30 8 1 * *` | 1st day of every month at 08:30 AM. |
| `0 9-17 * * 1-5` | Every hour on the hour between 9 AM and 5 PM, Mon–Fri. |

### Cron Special Strings:
* `@reboot` : Run once immediately at system boot time.
* `@hourly` : Equivalent to `0 * * * *`.
* `@daily` or `@midnight` : Equivalent to `0 0 * * *`.
* `@weekly` : Equivalent to `0 0 * * 0`.
* `@monthly` : Equivalent to `0 0 1 * *`.

---

# 4. Crontab Management Commands

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

---

# 5. The #1 Cron Gotcha: The Environment Trap

The single most common mistake in Linux automation is assuming cron runs with your full interactive login shell environment.

```text
Interactive Login Shell                      Cron Subshell Environment
┌───────────────────────────┐                ┌───────────────────────────┐
│ PATH=/home/user/.local/bin│                │ PATH=/usr/bin:/bin        │
│      :/usr/local/bin:...  │       vs       │ SHELL=/bin/sh             │
│ Full ~/.bashrc loaded     │                │ HOME=/home/user           │
│ Aliases & Envs available  │                │ NO interactive variables  │
└───────────────────────────┘                └───────────────────────────┘
```

### Golden Rules for Bulletproof Cron Jobs:
1. **Always use absolute paths** for both commands and scripts:
   ```bash
   # BAD: python backup.py
   # GOOD:
   0 3 * * * /usr/bin/python3 /home/ubuntu/scripts/backup.py
   ```
2. **Explicitly redirect STDOUT and STDERR** to a dedicated log file:
   ```bash
   0 2 * * * /opt/scripts/db_backup.sh >> /var/log/db_backup.log 2>&1
   ```
3. **Define explicit environment variables** at the top of the crontab:
   ```bash
   SHELL=/bin/bash
   PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
   MAILTO=admin@company.com
   ```

---

# 6. One-Time Scheduled Jobs with `at` and `batch`

While `cron` is designed for recurring schedules, `at` executes a command **exactly once** at a specified future timestamp.

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

### `batch`: Load-Aware Execution
```bash
# Queues a task to execute only when the system load average drops below 0.8
batch
```

---

# 7. Anacron: Catch-Up Automation for Non-24/7 Systems

Standard `cron` assumes the server runs continuously 24/7. If an EC2 Spot instance, development VM, or laptop is stopped at 02:00 AM when a daily cron job is scheduled, `cron` misses the execution entirely.

**`anacron`** solves this by recording execution timestamps in `/var/spool/anacron/`. When the system boots up, `anacron` detects missed jobs and runs them after a configurable delay.

Configuration in `/etc/anacrontab`:
```text
# period-in-days   delay-in-minutes   job-identifier   command
1                  5                  cron.daily       run-parts /etc/cron.daily
7                  10                 cron.weekly      run-parts /etc/cron.weekly
@monthly           15                 cron.monthly     run-parts /etc/cron.monthly
```

---

# 8. Hands-On Lab: Automated Log Rotator & Health Audit

I built a production-grade automated log rotation and storage watchdog script:

### `log_rotator_cron.sh`
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

### Scheduling via `crontab -e`:
```bash
# Run the log rotator every night at 02:00 AM and log execution output
0 2 * * * /usr/local/bin/log_rotator_cron.sh >> /var/log/cron_rotator.log 2>&1
```

---

# 9. Cloud & Kubernetes Infrastructure Connection ☁️

Scheduled Linux automation is the direct ancestor of cloud-native scheduling:

* **AWS EventBridge (CloudWatch Events):** Uses standard cron expressions (`cron(0 2 * * ? *)`) to trigger AWS Lambda functions, ECS tasks, and SSM run commands.
* **Kubernetes `CronJob` Resource:** Translates standard Linux crontab syntax directly into Kubernetes Pod orchestration:
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

---

# 10. The Scheduled Automation Cheat Sheet

| Command / Pattern | Meaning |
|---|---|
| `crontab -e` | Edit user's crontab file |
| `crontab -l` | List all active scheduled cron jobs |
| `crontab -r` | Remove all cron jobs for current user |
| `*/15 * * * *` | Run every 15 minutes |
| `0 3 * * 1-5` | Run at 3:00 AM, Monday through Friday |
| `@reboot` | Run once immediately upon system boot |
| `2>&1` | Redirect STDERR to STDOUT for complete logging |
| `at 15:00` | Schedule a one-time execution at 3:00 PM |
| `atq` | List active queued `at` jobs |
| `atrm <ID>` | Delete a queued `at` job by ID |
| `anacron` | Catch-up scheduler for non-continuous / sleeping systems |

---

# 🧠 Day 11 Knowledge Check

Before marking Day 11 complete, verify you can answer these from memory:

1. What are the 5 fields of a standard crontab expression in order?
2. Why do scripts that run fine interactively often fail when run inside cron?
3. What is the difference between `crontab -e` and editing `/etc/crontab` directly?
4. How do you redirect both standard output and standard error to a log file in cron?
5. When would you use `at` instead of `cron`?
6. How does `anacron` differ from standard `cron`?
7. How does a Kubernetes `CronJob` relate to the Linux `crond` daemon?

---

## 📈 Journey Progress

```text
Linux Mastery:                 Day 11 / 30  [███████████░░░░░░░░░░░░░░░░░░░] 36.7%
AI Cloud Infrastructure:     Day 207 / 1000 [████░░░░░░░░░░░░░░░░░░░░░░░░░░] 20.7%
```

**Day 11/30 → Cron & Scheduled Automation Complete! ✅**  
**Day 207 / 1000 → 20.7% of the journey**


# Day 12 — Systemd Services & Timers (Part 1)











---



# 1. What is systemd?



`systemd` is the system and service manager used by many modern Linux distributions.



It is responsible for:



* Starting services during boot

* Managing running services

* Handling service dependencies

* Restarting failed services

* Managing system targets

* Collecting service logs through the journal

* Managing sockets, timers, mounts and other system resources



Basic architecture:



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



---



# 2. Systemd Units



A **unit** is an object that `systemd` knows how to manage.



Common unit types:



| Unit         | Purpose                       |

| ------------ | ----------------------------- |

| `.service`   | Manage processes and services |

| `.socket`    | Manage sockets                |

| `.timer`     | Schedule tasks                |

| `.target`    | Group units together          |

| `.mount`     | Manage filesystem mounts      |

| `.automount` | Automount filesystems         |

| `.path`      | Monitor filesystem paths      |

| `.device`    | Represent devices             |

| `.swap`      | Manage swap                   |



The most important unit type for today is:



```text

.service

```



Examples:



```text

ssh.service

nginx.service

docker.service

myhttp.service

```



---



# 3. Systemd Targets



A **target** is a grouping or synchronization point used by systemd.



For example:



```bash

systemctl get-default

```



A server commonly uses:



```text

multi-user.target

```



Conceptually:



```text

multi-user.target

        │

        ├── ssh.service

        ├── cron.service

        ├── nginx.service

        └── other services

```



Targets help systemd organize the boot process.



---



# 4. Systemd Generators



Systemd generators are programs that dynamically generate or modify systemd configuration during boot.



Conceptually:



```text

Configuration

      ↓

Generator

      ↓

Generated units/dependencies

      ↓

systemd

```



The important idea:



> Generators dynamically create or modify systemd configuration during startup.



---



# 5. Service Unit Files



A service unit file tells systemd:



* What the service is

* How it should start

* What it depends on

* How it should restart

* When it should start during boot



A basic service file:



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



Service files usually contain three major sections:



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



---



# 6. The [Unit] Section



The `[Unit]` section contains information about the service and its dependencies.



Example:



```ini

[Unit]

Description=My Python HTTP Server

After=network.target

```



## Description=



Provides a human-readable description.



```ini

Description=My Python HTTP Server

```



This appears when checking:



```bash

systemctl status myhttp

```



---



# 7. After=



`After=` controls the **startup order**.



Example:



```ini

After=network.target

```



This means:



> Start this service after `network.target`.



Important:



```text

After= ≠ dependency

```



`After=` only controls ordering.



It does not automatically require the other unit.



---



# 8. Requires=



`Requires=` creates a stronger dependency.



Example:



```ini

Requires=network.target

```



This means:



> This service requires the specified unit.



A common combination is:



```ini

Requires=network.target

After=network.target

```



This means:



```text

I require the network target

+

Start me after the network target

```



---



# 9. Wants=



`Wants=` creates a weaker dependency.



Example:



```ini

Wants=some-service.service

```



This means:



> Try to start this service as well, but its failure does not necessarily cause the main service to fail.



Mental model:



```text

Requires = MUST HAVE

Wants    = NICE TO HAVE

After    = START ORDER

```



---



# 10. [Service] Section



The `[Service]` section defines how the actual application should run.



Example:



```ini

[Service]

Type=simple

ExecStart=/usr/bin/python3 -m http.server 8080

Restart=on-failure

RestartSec=10

```



Important directives include:



* `Type=`

* `ExecStart=`

* `Restart=`

* `RestartSec=`



---



# 11. ExecStart=



`ExecStart=` specifies the command systemd should execute.



Example:



```ini

ExecStart=/usr/bin/python3 -m http.server 8080

```



This starts a Python HTTP server on port `8080`.



The executable path can be checked using:



```bash

which python3

```



---



# 12. Service Types



Systemd supports different service types.



## Type=simple



```ini

Type=simple

```



The process launched by `ExecStart=` is treated as the main service process.



Example:



```ini

[Service]

Type=simple

ExecStart=/usr/bin/python3 -m http.server 8080

```



This is suitable for our HTTP server.



---



## Type=forking



```ini

Type=forking

```



Used by applications that start and then fork themselves into the background.



Conceptually:



```text

systemd

   ↓

application

   ↓

fork()

   ↓

background process

```



This is common with traditional daemon-style applications.



---



## Type=oneshot



```ini

Type=oneshot

```



Used for commands or scripts that run and then finish.



Example:



```ini

[Service]

Type=oneshot

ExecStart=/usr/local/bin/backup.sh

```



Flow:



```text

Start

  ↓

Run script

  ↓

Script finishes

  ↓

Service exits

```



Useful for:



* Backup scripts

* Maintenance tasks

* Initialization tasks

* Database migrations



---



## Type=notify



```ini

Type=notify

```



Used by applications that can communicate with systemd and explicitly tell it when they are ready.



Conceptually:



```text

Application starts

      ↓

Application initializes

      ↓

Application tells systemd:

"I'm ready"

```



---



# 13. Restart Policies



Systemd can automatically restart services that fail.



Example:



```ini

Restart=on-failure

```



If the application crashes:



```text

Application

     ↓

   crash

     ↓

systemd detects failure

     ↓

restart

```



This is extremely useful for long-running infrastructure services.



---



# 14. Restart=on-failure



```ini

Restart=on-failure

```



Restarts the service when it terminates unsuccessfully.



Examples of failures include:



```text

Exit code 1

Unexpected termination

Process crash

Failure signal

```



This helps keep applications available without manual intervention.



---



# 15. Restart=always



```ini

Restart=always

```



Tells systemd to restart the service whenever it stops, subject to systemd's restart rules.



Conceptually:



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



This should be used carefully because an application that intentionally exits can create repeated restarts.



---



# 16. RestartSec=



`RestartSec=` controls how long systemd waits before restarting a service.



Example:



```ini

RestartSec=10

```



Means:



```text

Service crashes

      ↓

Wait 10 seconds

      ↓

Restart service

```



Without an appropriate delay, a broken application could repeatedly crash and restart very quickly.



---



# 17. Service Dependencies



Important dependency directives:



| Directive    | Meaning                              |

| ------------ | ------------------------------------ |

| `After=`     | Controls startup order               |

| `Before=`    | Starts this unit before another unit |

| `Requires=`  | Strong dependency                    |

| `Wants=`     | Weak dependency                      |

| `Conflicts=` | Prevents units from running together |



Important distinction:



```text

After=     → ordering

Requires=  → dependency

Wants=     → optional/weak dependency

```



---



# 18. [Install] Section



The `[Install]` section defines how the service integrates with systemd targets when enabled.



Example:



```ini

[Install]

WantedBy=multi-user.target

```



This means the service should be associated with:



```text

multi-user.target

```



when enabled.



---



# 19. Creating a Custom Service



Create:



```bash

sudo nano /etc/systemd/system/myhttp.service

```



Service file:



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



---



# 20. daemon-reload



After creating or modifying a service file:



```bash

sudo systemctl daemon-reload

```



This tells systemd to reread its unit files.



Conceptually:



```text

Edit service file

       ↓

daemon-reload

       ↓

systemd rereads configuration

```



`daemon-reload` does not automatically restart the service.



---



# 21. Starting a Service



Start:



```bash

sudo systemctl start myhttp

```



Check status:



```bash

systemctl status myhttp

```



Expected state:



```text

Active: active (running)

```



---



# 22. Stopping a Service



Stop:



```bash

sudo systemctl stop myhttp

```



Check:



```bash

systemctl status myhttp

```



The service should become:



```text

inactive (dead)

```



---



# 23. Restarting a Service



Restart:



```bash

sudo systemctl restart myhttp

```



This is useful after changing application configuration.



Instead of:



```bash

sudo systemctl stop myhttp

sudo systemctl start myhttp

```



we can use:



```bash

sudo systemctl restart myhttp

```



---



# 24. Enable a Service



Enable:



```bash

sudo systemctl enable myhttp

```



This configures the service to start automatically during boot.



Important distinction:



```bash

systemctl start myhttp

```



means:



> Start the service now.



```bash

systemctl enable myhttp

```



means:



> Start the service automatically during future boots.



---



# 25. Enable and Start Together



Use:



```bash

sudo systemctl enable --now myhttp

```



This means:



```text

Enable for boot

+

Start immediately

```



---



# 26. Check if a Service is Enabled



```bash

systemctl is-enabled myhttp

```



Expected:



```text

enabled

```



---



# 27. Disable a Service



```bash

sudo systemctl disable myhttp

```



This removes the automatic boot configuration.



Important:



```text

disable ≠ stop

```



Disabling a service does not necessarily stop a service that is currently running.



---



# 28. Testing the HTTP Server



Once `myhttp.service` is running:



```bash

curl http://localhost:8080

```



Or:



```bash

curl -I http://localhost:8080

```



Expected:



```text

HTTP/1.0 200 OK

```



This confirms that the Python HTTP server is responding.



---



# 29. Systemd Logs



Systemd uses the journal for centralized logging.



View logs for the service:



```bash

journalctl -u myhttp

```



The `-u` option means:



```text

unit

```



So:



```bash

journalctl -u myhttp

```



means:



> Show journal logs belonging to `myhttp.service`.



---



# 30. Follow Logs in Real Time



```bash

journalctl -u myhttp -f

```



The `-f` option means follow.



It continuously displays new log entries.



This is similar to:



```bash

tail -f logfile

```



Exit using:



```text

Ctrl+C

```



---



# 31. Creating a Failing Service



Create:



```bash

sudo nano /etc/systemd/system/failing.service

```



Use:



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



Reload:



```bash

sudo systemctl daemon-reload

```



Start:



```bash

sudo systemctl start failing

```



Check:



```bash

systemctl status failing

```



---



# 32. Observing Automatic Restart



Because the service exits with:



```bash

exit 1

```



systemd detects a failure.



With:



```ini

Restart=on-failure

RestartSec=10

```



the sequence becomes:



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



View the behavior:



```bash

journalctl -u failing -f

```



This demonstrates systemd's automatic service recovery.



---



# 33. Socket Activation — Introduction



Systemd can also manage sockets.



Normally:



```text

systemd

   ↓

start application

   ↓

application listens on port

```



With socket activation:



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



A socket unit typically has:



```text

myapp.socket

```



and the corresponding service:



```text

myapp.service

```



Architecture:



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



Socket activation allows services to be started on demand when activity arrives on the socket.



---



# 34. Important Commands Learned



## Service management



```bash

systemctl status myhttp

sudo systemctl start myhttp

sudo systemctl stop myhttp

sudo systemctl restart myhttp

```



## Boot management



```bash

sudo systemctl enable myhttp

sudo systemctl disable myhttp

sudo systemctl enable --now myhttp

```



## Configuration



```bash

sudo systemctl daemon-reload

```



## Service state



```bash

systemctl is-active myhttp

systemctl is-enabled myhttp

```



## Logs



```bash

journalctl -u myhttp

journalctl -u myhttp -f

```



---



# 35. Service Lifecycle



The complete lifecycle learned today:



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



Boot lifecycle:



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



---



# 36. Production Infrastructure Connection



Systemd is important for cloud infrastructure because it allows Linux servers to manage long-running applications.



For example:



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



If an application crashes:



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



This provides basic service resilience on individual Linux machines.



---



# 37. systemd vs Kubernetes



Systemd and Kubernetes operate at different infrastructure layers.



### systemd



```text

Linux machine

      ↓

systemd

      ↓

processes/services

```



### Kubernetes



```text

Cluster

   ↓

Kubernetes

   ↓

Pods

   ↓

Containers

```



Systemd manages services on a Linux host, while Kubernetes manages containerized workloads across a cluster.



---



# 38. Key Concepts Learned



### 1. systemd



The Linux system and service manager.



### 2. Unit



An object managed by systemd.



### 3. Service



A unit used to manage a process or application.



### 4. Target



A grouping/synchronization point for units.



### 5. Generator



A program that dynamically generates or modifies systemd configuration.



### 6. ExecStart



Defines the command used to start a service.



### 7. Restart=on-failure



Automatically restarts a service after an unexpected failure.



### 8. RestartSec=



Defines the delay before restarting.



### 9. After=



Controls startup ordering.



### 10. Requires=



Defines a strong dependency.



### 11. Wants=



Defines a weak dependency.



### 12. daemon-reload



Makes systemd reread unit files.



### 13. enable



Configures a service to start during boot.



### 14. start



Starts a service immediately.



### 15. journalctl



Reads systemd journal logs.



### 16. Socket activation



Allows systemd to listen for connections and start a service when needed.



---



# 39. Most Important Mental Model



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



---



# 40. Day 12 Summary



Today I learned how `systemd` manages Linux services and how service unit files are structured.



I learned:



* What systemd is

* What systemd units are

* Different unit types

* Systemd targets

* Systemd generators

* The `[Unit]`, `[Service]`, and `[Install]` sections

* `ExecStart=`

* Service types: `simple`, `forking`, `oneshot`, `notify`

* `Restart=on-failure`

* `Restart=always`

* `RestartSec=`

* Service dependencies

* `After=`

* `Requires=`

* `Wants=`

* `systemctl start`

* `systemctl stop`

* `systemctl restart`

* `systemctl status`

* `systemctl enable`

* `systemctl disable`

* `systemctl daemon-reload`

* `systemctl is-active`

* `systemctl is-enabled`

* `journalctl`

* Live service logs with `journalctl -f`

* Created a custom `myhttp.service`

* Ran a Python HTTP server through systemd

* Tested the service lifecycle

* Created a deliberately failing service

* Observed automatic restart behavior

* Learned the basics of socket activation



---



## 🚀 Day 12 Takeaway



> **systemd turns ordinary Linux processes into managed infrastructure services.**



The key distinction to remember:



```text

start   → run it now

stop    → stop it now

restart → stop + start

enable  → start automatically at boot

disable → don't start automatically at boot

```



And the dependency model:



```text

After=      → ordering

Requires=   → strong dependency

Wants=      → weak dependency

```



**Day 12 / 30 — Linux Mastery**

**Day 208 / 1000 — Cloud Infrastructure Journey**  #


# Day 13 — Systemd Timers (Part 2) & Journal Introduction






---

# 1. Systemd Timers

A **systemd timer** is a systemd unit used to schedule another systemd unit, normally a service.

A service answers:

> What should run?

A timer answers:

> When should it run?

The basic relationship is:

```text
Timer
  ↓
Service
  ↓
Program / Script
```

For example:

```text
backup.timer
      ↓
backup.service
      ↓
backup.sh
```

The timer controls when the backup service runs, while the service defines what actually happens.

---

# 2. Timer Unit Structure

A basic timer contains:

```ini
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

### `[Unit]`

Contains metadata about the timer.

```ini
[Unit]
Description=Daily Backup Timer
```

### `[Timer]`

Contains the scheduling configuration.

```ini
[Timer]
OnCalendar=*-*-* 03:00:00
```

This schedules the timer for every day at 3:00 AM.

### `[Install]`

Controls how the timer is enabled during system boot.

```ini
[Install]
WantedBy=timers.target
```

---

# 3. OnCalendar

`OnCalendar` allows systemd timers to use calendar-based scheduling.

Example:

```ini
OnCalendar=*-*-* 03:00:00
```

Runs every day at 3 AM.

Other examples:

```ini
OnCalendar=daily
```

Runs daily.

```ini
OnCalendar=weekly
```

Runs weekly.

```ini
OnCalendar=Mon *-*-* 09:00:00
```

Runs every Monday at 9 AM.

```ini
OnCalendar=*-*-01 00:00:00
```

Runs on the first day of every month.

The full syntax can be studied with:

```bash
man systemd.time
```

---

# 4. Persistent Timers

A timer can use:

```ini
Persistent=true
```

This allows systemd to account for missed scheduled executions when the system was powered off.

Example:

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

This is particularly useful for tasks such as backups and maintenance jobs.

---

# 5. Systemd Service + Timer

A timer normally triggers a service.

Example:

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

The service contains the actual work.

Example:

```ini
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

---

# 6. Type=oneshot

For backup jobs, `Type=oneshot` is useful.

It means:

```text
Start
  ↓
Execute command
  ↓
Finish
```

The service does not need to remain running continuously.

Example:

```ini
[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

This is different from a long-running service such as a web server.

---

# 7. Creating the Backup Script

The backup script used for today's exercise:

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

The script:

1. Creates a backup directory
2. Generates a timestamp
3. Creates a backup file
4. Records the backup activity

The script was made executable using:

```bash
sudo chmod +x /usr/local/bin/backup.sh
```

---

# 8. backup.service

The service file:

```ini
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

File:

```text
/etc/systemd/system/backup.service
```

---

# 9. backup.timer

The timer file:

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

File:

```text
/etc/systemd/system/backup.timer
```

The timer activates:

```ini
Unit=backup.service
```

---

# 10. daemon-reload

After creating or modifying systemd unit files, systemd needs to reload its configuration.

Command:

```bash
sudo systemctl daemon-reload
```

The general workflow is:

```text
Modify unit file
      ↓
daemon-reload
      ↓
systemd reads configuration
```

---

# 11. Starting the Timer

Start the timer:

```bash
sudo systemctl start backup.timer
```

Enable it so that it starts automatically during boot:

```bash
sudo systemctl enable backup.timer
```

Both operations can also be performed together:

```bash
sudo systemctl enable --now backup.timer
```

---

# 12. Checking Timer Status

Check the timer:

```bash
systemctl status backup.timer
```

List timers:

```bash
systemctl list-timers
```

List all timers, including inactive ones:

```bash
systemctl list-timers --all
```

Useful information includes:

```text
NEXT
LEFT
LAST
PASSED
UNIT
ACTIVATES
```

For example:

```text
NEXT       → next scheduled execution
LEFT       → time until execution
LAST       → previous execution
UNIT       → timer unit
ACTIVATES  → service triggered by the timer
```

---

# 13. Manually Testing the Service

Instead of waiting until 3 AM, the service can be started manually:

```bash
sudo systemctl start backup.service
```

Check its status:

```bash
systemctl status backup.service
```

Because the service uses:

```ini
Type=oneshot
```

it can execute and then become inactive.

That is expected behavior.

---

# 14. Systemd Journal

The **systemd journal** is the logging system used by systemd.

It records information about:

* Services
* Processes
* System events
* Boot activity
* Errors
* Warnings
* Other structured system information

The command used to query the journal is:

```bash
journalctl
```

The basic relationship is:

```text
systemd
   ↓
journal
   ↓
journalctl
```

---

# 15. Basic journalctl

View journal entries:

```bash
journalctl
```

The journal can contain a large amount of information, so filtering is usually more useful.

---

# 16. Current Boot Logs

To view logs from the current boot:

```bash
journalctl -b
```

This is useful when troubleshooting startup problems.

The idea is:

```text
System boots
    ↓
Something goes wrong
    ↓
journalctl -b
    ↓
Inspect current boot logs
```

---

# 17. Logs for a Specific Service

Use:

```bash
journalctl -u backup.service
```

The `-u` option filters logs by systemd unit.

Examples:

```bash
journalctl -u backup.service
```

```bash
journalctl -u ssh.service
```

```bash
journalctl -u nginx.service
```

This is extremely useful when troubleshooting individual services.

---

# 18. Follow Logs in Real Time

Use:

```bash
journalctl -u backup.service -f
```

The `-f` option means **follow**.

It continuously displays new log entries.

A useful testing setup is:

### Terminal 1

```bash
journalctl -u backup.service -f
```

### Terminal 2

```bash
sudo systemctl start backup.service
```

The service's new log entries should appear in Terminal 1.

Exit with:

```text
Ctrl + C
```

---

# 19. Display Recent Journal Entries

Show the latest 20 entries:

```bash
journalctl -n 20
```

For the backup service:

```bash
journalctl -u backup.service -n 20
```

This is useful when the journal contains a large amount of information.

---

# 20. Journal Priorities

Systemd journal entries have priority levels.

The priority levels are:

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

---

# 21. Filter Warnings

Show warning-level messages and more severe messages:

```bash
journalctl -p warning
```

This helps reduce a large log into potentially important events.

---

# 22. Filter Errors

Show error-level messages and more severe messages:

```bash
journalctl -p err
```

For the backup service:

```bash
journalctl -u backup.service -p err
```

This can be useful for quickly identifying service failures.

---

# 23. JSON Output

The journal contains structured information.

JSON output can be viewed using:

```bash
journalctl -u backup.service -o json-pretty
```

This can expose fields such as:

```text
MESSAGE
PRIORITY
_PID
_UID
_SYSTEMD_UNIT
_BOOT_ID
_MACHINE_ID
```

Structured logs are useful because machines and monitoring systems can process individual fields.

---

# 24. Journal Disk Usage

Check journal disk usage:

```bash
journalctl --disk-usage
```

To remove archived journal data until the stored archived logs fit within approximately 500 MB:

```bash
sudo journalctl --vacuum-size=500M
```

This is useful for controlling disk usage on systems where logs could otherwise grow significantly.

---

# 25. system_scheduler.sh

A mini-project was created to automate the complete setup.

The script creates:

```text
backup.sh
backup.service
backup.timer
```

Then it:

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

Example script:

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

Make it executable:

```bash
chmod +x system_scheduler.sh
```

Run it:

```bash
sudo ./system_scheduler.sh
```

---

# 26. Hands-On Commands Practiced

## Create and reload units

```bash
sudo systemctl daemon-reload
```

## Start timer

```bash
sudo systemctl start backup.timer
```

## Enable timer

```bash
sudo systemctl enable backup.timer
```

## Enable and start together

```bash
sudo systemctl enable --now backup.timer
```

## Check timer

```bash
systemctl status backup.timer
```

## List timers

```bash
systemctl list-timers --all
```

## Manually run service

```bash
sudo systemctl start backup.service
```

## View service logs

```bash
journalctl -u backup.service
```

## View current boot

```bash
journalctl -b
```

## Follow logs

```bash
journalctl -u backup.service -f
```

## Show recent lines

```bash
journalctl -u backup.service -n 20
```

## Show warnings

```bash
journalctl -p warning
```

## Show errors

```bash
journalctl -p err
```

## JSON output

```bash
journalctl -u backup.service -o json-pretty
```

## Check journal disk usage

```bash
journalctl --disk-usage
```

## Vacuum journal

```bash
sudo journalctl --vacuum-size=500M
```

---

# 27. Day 13 Mini Project

### Project: Linux System Scheduler

The project demonstrates:

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

Files:

```text
day-013/
├── backup.service
├── backup.timer
├── backup.sh
├── system_scheduler.sh
└── README.md
```

---

# 28. Challenges

### Challenge 1 — Relative Scheduling

Research and test:

```ini
OnUnitActiveSec=5min
```

Understand how relative scheduling differs from:

```ini
OnCalendar=*-*-* 03:00:00
```

---

### Challenge 2 — Timer Inspection

Run:

```bash
systemctl list-timers backup.timer
```

Identify:

* Next execution
* Last execution
* Time remaining
* Service activated by the timer

---

### Challenge 3 — Error Filtering

Run:

```bash
journalctl -u backup.service -p err
```

Understand what the priority filter does.

---

### Challenge 4 — JSON Logs

Run:

```bash
journalctl -u backup.service -o json-pretty
```

Find:

```text
MESSAGE
PRIORITY
_SYSTEMD_UNIT
_PID
```

---

### Challenge 5 — Live Logs

Run:

```bash
journalctl -u backup.service -f
```

Then trigger the service from another terminal:

```bash
sudo systemctl start backup.service
```

Observe the logs appearing in real time.

---

# 29. Cloud Infrastructure Connection

Today's concepts are directly connected to infrastructure engineering.

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

The underlying concepts remain important even when moving to larger cloud systems.

Today's lesson connects three fundamental infrastructure concepts:

```text
Automation
     +
Execution
     +
Observability
```

---

# 30. Key Mental Model

The most important concept from Day 13:

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

Complete workflow:

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

---

# 31. What I Learned Today

Today I learned how Linux can automate recurring tasks using **systemd timers** instead of relying only on traditional cron jobs.

I learned that a timer schedules a service, while the service contains the actual task that needs to execute.

I learned how to use:

```bash
systemctl daemon-reload
systemctl start
systemctl enable
systemctl status
systemctl list-timers
```

I also learned how `OnCalendar` can define calendar-based schedules and how `Persistent=true` can handle missed scheduled executions.

The second major topic was the **systemd journal**.

I learned how to use:

```bash
journalctl
journalctl -b
journalctl -u
journalctl -f
journalctl -n
journalctl -p
```

I learned how to filter logs by service and priority, follow logs in real time, inspect structured JSON output, and manage journal disk usage.

Most importantly, I learned the infrastructure debugging workflow:

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

This is an important foundation for cloud infrastructure and distributed systems.

---

# 32. Day 13 Completion






* Timer units
* `OnCalendar`
* Persistent timers
* Systemd service scheduling
* `Type=oneshot`
* `systemctl list-timers`
* Systemd journal
* `journalctl`
* Boot logs
* Service logs
* Live log following
* Log priorities
* JSON log output
* Journal disk management
* Automated system scheduler


backup.service
backup.timer
backup.sh
system_scheduler.sh
```




# Day 14 — Week 2 Review & Integration Project






---

# 📚 1. Week 2 Review

## Process Management

Linux processes can exist in different states such as:

* Running
* Sleeping
* Waiting
* Stopped
* Terminated

Useful commands:

```bash
ps aux
ps -ef
pgrep <process>
pgrep -a <process>
top
htop
```

---

## systemctl Commands

### Check service status

```bash
systemctl status nginx
```

### Start a service

```bash
sudo systemctl start nginx
```

### Stop a service

```bash
sudo systemctl stop nginx
```

### Restart a service

```bash
sudo systemctl restart nginx
```

### Enable at boot

```bash
sudo systemctl enable nginx
```

### Disable at boot

```bash
sudo systemctl disable nginx
```

### Check whether a service is active

```bash
systemctl is-active nginx
```

### Check whether a service is enabled

```bash
systemctl is-enabled nginx
```

---

# 🧠 2. `Wants=` vs `Requires=`

One important systemd concept reviewed today is the difference between:

```ini
Wants=
```

and:

```ini
Requires=
```

## Wants=

`Wants=` creates a weaker dependency.

Example:

```ini
[Unit]
Wants=network-online.target
```

Meaning:

> Start the requested unit as well, but the current service does not necessarily depend on its successful operation.

## Requires=

`Requires=` creates a stronger dependency.

Example:

```ini
[Unit]
Requires=network-online.target
```

Meaning:

> This service requires the other unit to be available.

### Easy way to remember

```text
Wants    = "I would like this too."
Requires = "I need this."
```

---

# 🛑 3. Linux Signals

Signals allow Linux to communicate with running processes.

Important signals:

| Signal    | Purpose                             |
| --------- | ----------------------------------- |
| `SIGTERM` | Graceful termination                |
| `SIGKILL` | Immediate forced termination        |
| `SIGINT`  | Interrupt                           |
| `SIGHUP`  | Reload/configuration-related signal |
| `SIGSTOP` | Stop a process                      |

Example:

```bash
kill -TERM <PID>
```

This requests graceful termination.

Forcefully terminating:

```bash
kill -KILL <PID>
```

`SIGTERM` should generally be preferred because applications get an opportunity to clean up resources.

---

# 🔥 4. Graceful Shutdown with `trap`

Bash can react to signals using `trap`.

Example:

```bash
trap 'shutdown' SIGTERM
```

Then define:

```bash
shutdown() {
    echo "Guardian shutting down..."
}
```

When the script receives `SIGTERM`, the `shutdown` function is executed.

This allows Process Guardian to:

1. Stop monitoring
2. Stop or gracefully terminate guarded processes
3. Write a shutdown message
4. Clean up resources
5. Exit properly

---

# 📜 5. systemd Journal

Linux systems using systemd normally use `journald` for system logging.

Basic commands:

```bash
journalctl
```

View recent logs:

```bash
journalctl -n 20
```

Follow logs live:

```bash
journalctl -f
```

View logs for a service:

```bash
journalctl -u nginx
```

Follow a service's logs:

```bash
journalctl -u nginx -f
```

View logs from the current boot:

```bash
journalctl -b
```

---

# 📝 6. Logging from Bash

The `logger` command can send messages to the system journal.

Example:

```bash
logger -t process-guardian "Test guardian message"
```

Then view the messages:

```bash
journalctl -t process-guardian
```

This allows Process Guardian to integrate with the Linux logging system instead of maintaining its own separate log file.

---

# 🏗️ 7. Integration Project — Process Guardian

## Problem

Critical processes can unexpectedly stop because of:

* Application crashes
* Configuration errors
* Resource problems
* Unexpected termination
* Dependency failures

Manually checking and restarting these processes is inefficient.

The goal is to automate the basic recovery process.

---

# 🎯 Project Requirements

Process Guardian must:

1. Monitor a list of critical processes
2. Read the process list from a configuration file
3. Detect stopped processes
4. Restart them automatically
5. Support systemd services
6. Support direct restart commands
7. Log every restart
8. Include timestamp and reason in logs
9. Detect repeated failures
10. Alert if the same process restarts 3 times within 5 minutes
11. Gracefully stop guarded processes when receiving `SIGTERM`
12. Run as a systemd service
13. Automatically restart if the guardian itself crashes

---

# 📁 8. Project Structure

Create the project directory:

```bash
mkdir -p ~/process-guardian
cd ~/process-guardian
```

Project structure:

```text
process-guardian/
├── process_guardian.sh
├── processes_to_guard.cfg
├── process_guardian.service
└── README.md
```

---

# ⚙️ 9. Process Configuration

The guardian should not hardcode every process.

Create:

```text
processes_to_guard.cfg
```

Example configuration:

```text
# name|restart_method|restart_target

nginx|systemd|nginx.service
```

The purpose of the configuration file is to separate:

```text
Configuration
      ↓
Monitoring Logic
```

This makes the guardian reusable.

---

# 🔍 10. Detecting Processes

One simple way to check whether a process is running is:

```bash
pgrep -x nginx
```

If the process exists, `pgrep` returns successfully.

If it does not exist, it returns a non-zero exit status.

Example:

```bash
if ! pgrep -x "$process_name" > /dev/null; then
    echo "$process_name is down"
fi
```

This gives the guardian a simple health check.

---

# 🔄 11. Restarting a systemd Service

If a process is managed by systemd:

```bash
sudo systemctl restart nginx.service
```

Then verify:

```bash
systemctl is-active nginx.service
```

The guardian can therefore use systemd as the process recovery mechanism.

Architecture:

```text
Process stops
     ↓
Guardian detects failure
     ↓
systemctl restart
     ↓
Service starts again
```

---

# 🚀 12. Direct Command Restart

Not every application needs to be controlled by systemd.

Some applications may use a direct startup command such as:

```bash
/opt/myapp/start.sh
```

The guardian should therefore support two restart approaches:

```text
Systemd service
      OR
Direct command
```

This makes the project more flexible.

---

# 📊 13. Restart Tracking

A major requirement is detecting repeated failures.

The rule is:

```text
3 restarts within 5 minutes
        ↓
      ALERT
```

Example:

```text
16:00:10 → Restart #1
16:02:30 → Restart #2
16:04:15 → Restart #3
```

All three restarts occurred within five minutes.

Therefore:

```text
ALERT: nginx restarted 3 times within 5 minutes
```

---

## Sliding Time Window

The guardian should keep track of restart timestamps.

Conceptually:

```text
nginx:
    16:00:10
    16:02:30
    16:04:15
```

Old timestamps should be removed when they are more than:

```text
300 seconds
```

old.

This creates a simple sliding five-minute monitoring window.

---

# 🚨 14. Alerting

For this project, an alert can initially be represented by a journal entry.

Example:

```bash
logger -t process-guardian \
    "ALERT: nginx restarted 3 times within 5 minutes"
```

Then inspect it with:

```bash
journalctl -t process-guardian
```

Later, this concept can be extended to:

* Email
* Slack
* Discord
* CloudWatch
* PagerDuty
* Prometheus Alertmanager

---

# 🛑 15. Graceful Shutdown

The guardian must handle `SIGTERM`.

Conceptually:

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

Example Bash structure:

```bash
shutdown() {
    logger -t process-guardian "Guardian shutting down"

    # Stop guarded processes here

    exit 0
}

trap shutdown SIGTERM
```

---

# 🧩 16. Process Guardian Architecture

The complete architecture:

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

Failure flow:

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

---

# 🔧 17. systemd Service

Create:

```text
process_guardian.service
```

Basic structure:

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

Important settings:

```ini
Restart=always
RestartSec=5
```

These tell systemd to restart the guardian if it exits.

---

# 🔁 18. Two Levels of Recovery

This project demonstrates two levels of process supervision.

### Level 1 — Guardian recovers applications

```text
Guardian
    ↓
Application crashes
    ↓
Guardian detects it
    ↓
Guardian restarts application
```

### Level 2 — systemd recovers Guardian

```text
Guardian crashes
    ↓
systemd detects failure
    ↓
systemd waits 5 seconds
    ↓
systemd restarts Guardian
```

Overall:

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

This is an example of layered supervision.

---

# 🧪 19. Hands-On Practice

## Test Process Management

Run:

```bash
ps aux
```

Then:

```bash
pgrep -a bash
```

Practice:

```bash
systemctl status nginx
```

```bash
systemctl is-active nginx
```

---

# 🧪 20. Test Signals

Start a temporary process:

```bash
sleep 1000 &
```

Find it:

```bash
pgrep -a sleep
```

Terminate it:

```bash
kill -TERM <PID>
```

Confirm:

```bash
pgrep -a sleep
```

---

# 🧪 21. Test Journal Logging

Send a test message:

```bash
logger -t process-guardian "Test guardian message"
```

Read it:

```bash
journalctl -t process-guardian -n 10
```

---

# 🧪 22. Test Process Recovery

Start a test process and intentionally terminate it.

The guardian should detect:

```text
PROCESS DOWN
```

Then:

```text
RESTARTING PROCESS
```

Then:

```text
PROCESS RESTARTED
```

---

# 🧪 23. Test Repeated Failures

Repeatedly stop the same process.

Expected behavior:

```text
Restart #1
Restart #2
Restart #3
```

After the third restart within five minutes:

```text
ALERT: process restarted 3 times within 5 minutes
```

Check the journal:

```bash
journalctl -t process-guardian
```

---

# 🧪 24. Test Guardian Shutdown

Stop the service:

```bash
sudo systemctl stop process-guardian
```

Then inspect:

```bash
journalctl -u process-guardian -f
```

Verify that the shutdown handler executes.

---

# 📖 25. README Requirements

The project's `README.md` should explain:

1. What Process Guardian is
2. Project architecture
3. Configuration format
4. How process monitoring works
5. How systemd restart works
6. How direct commands work
7. How restart tracking works
8. How the five-minute alert works
9. How SIGTERM handling works
10. How to install the service
11. How to start the service
12. How to stop the service
13. How to inspect logs
14. How to troubleshoot failures

Useful commands to document:

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

---

# 🧠 26. Key Concepts Learned

By completing today's project, I learned:

* Process supervision
* Process health checks
* `pgrep`
* `systemctl`
* systemd service dependencies
* `Wants=`
* `Requires=`
* Linux signals
* `SIGTERM`
* Bash `trap`
* Graceful shutdown
* `journalctl`
* `logger`
* journald integration
* Automatic service recovery
* Restart policies
* Failure detection
* Restart counters
* Sliding time windows
* Basic alerting
* Configuration-driven scripts
* Layered process supervision

---

# 🌩️ 27. Cloud Infrastructure Connection

Process Guardian demonstrates a fundamental infrastructure pattern:

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

The same pattern appears in modern infrastructure.

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

For example, Kubernetes uses health checks and controllers to detect unhealthy workloads and take corrective actions.

The tooling changes, but the underlying infrastructure principle remains:

```text
Detect failure → Recover automatically → Record what happened
```

---

# 📝 28. Week 2 Integration

Week 2 progression:

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

Today's project combines the entire week.

---

# ✅ 29. Day 14 Completion Checklist

## Theory

* [ ] Reviewed process states
* [ ] Reviewed `systemctl`
* [ ] Understood `Wants=`
* [ ] Understood `Requires=`
* [ ] Reviewed Linux signals
* [ ] Understood `SIGTERM`
* [ ] Reviewed `journalctl`
* [ ] Reviewed systemd service configuration

## Hands-On

* [ ] Created `process_guardian.sh`
* [ ] Created `processes_to_guard.cfg`
* [ ] Created `process_guardian.service`
* [ ] Implemented process detection
* [ ] Implemented process restart
* [ ] Added journal logging
* [ ] Added restart tracking
* [ ] Added 3-in-5-minute alert
* [ ] Added SIGTERM handling
* [ ] Added systemd auto-restart
* [ ] Tested failure recovery
* [ ] Tested graceful shutdown
* [ ] Created README

---

# 🚀 30. Final Deliverables

```text
process_guardian.sh
process_guardian.service
processes_to_guard.cfg
README.md
```

---

# 📌 31. Git Commit

Commit the completed project with:

```bash
git add .
```

```bash
git commit -m "Week 2: Process automation and systemd integration"
```

```bash
git push
```

---

# 🎯 Day 14 Takeaway

The biggest lesson from today's project is not the Bash script itself.

It is the infrastructure mindset:

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

This is the foundation of reliable infrastructure.

**Day 14 / 30 — Linux Mastery Complete**

**Day 210 / 1000 — AI Cloud Infrastructure Journey**

> Monitor → Detect → Recover → Observe → Alert

---

