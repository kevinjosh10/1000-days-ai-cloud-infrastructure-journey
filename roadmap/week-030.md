# Week 30 Roadmap

## 🐧 Day 204 / 1000 — Linux Mastery: Day 9 / 30
- **Date:** September 21, 2026  
- **Journey:** Day 204 / 1000 — AI Cloud Infrastructure Journey  
- **Linux Progress:** Day 9 / 30  
- **Theme:** Every process is under your control. Master systemd.  
- **Focus:** Linux Process Management  
- **Next:** Process control, signals, foreground/background jobs, `kill`, `SIGTERM`, `SIGKILL`, `nice`, and process priority.

### Objective
Understand how Linux creates, manages, schedules, and terminates processes.

By the end of this day, I should understand:

* What a process is
* PID and PPID
* Process lifecycle
* Process states
* Process trees
* PID 1 and systemd
* `/proc/<PID>/`
* `fork()`, `exec()`, `wait()`, and `exit()`
* How to inspect processes with `ps`
* How to visualize processes with `pstree`
* How zombie processes are created
* Why process management matters in cloud infrastructure

---

---

## Day 205 / 1000 — Linux Mastery: Day 9 / 30
- **Date:** September 22, 2026  
- **Linux Mastery:** Day 9 / 30  
- **AI Cloud Infrastructure Journey:** Day 205 / 1000  
- **Focus:** Process Monitoring, Management & Linux Performance  

### Objective
Learn how to observe, identify, analyze, and manage Linux processes.

By the end of today, I should be able to:

* Monitor processes using `top`, `htop`, and `glances`
* Find processes using `pgrep` and `pidof`
* Safely manage processes using `kill` and `pkill`
* Understand process priority with `nice` and `renice`
* Understand RSS vs VSZ memory usage
* Interpret Linux load average
* Build a basic process monitoring script
* Troubleshoot a slow Linux system using evidence

---

---

## 🐧 Day 206 / 1000 — Linux Mastery: Day 10 / 30
- **Date:** September 23, 2026  
- **Journey:** Day 206 / 1000 — AI Cloud Infrastructure Engineer Journey  
- **Linux Progress:** Day 10 / 30  
- **Theme:** Every process is under your control. Master systemd.  
- **Focus:** Linux Signals, Graceful Shutdowns & Shell Job Control  

---

## 🐧 Day 207 / 1000 — Linux Mastery: Day 11 / 30
- **Date:** September 24, 2026  
- **Journey:** Day 207 / 1000 — AI Cloud Infrastructure Engineer Journey  
- **Linux Progress:** Day 11 / 30  
- **Theme:** Stop running repetitive tasks manually. Make Linux schedule and execute them automatically.  
- **Focus:** Cron, Crontab, One-Time Jobs (`at`), Anacron & Scheduled Automation  

---

## Day 12 — Systemd Services & Timers (Part 1)
- **Linux Mastery:** Day 12 / 30
- **Cloud Infrastructure Journey:** Day 208 / 1000
- **Focus:** Systemd Services, Service Units, Dependencies, Restart Policies & Socket Activation

### Objective
Understand how `systemd` manages Linux services, how service unit files are structured, how dependencies and restart policies work, and how to create and manage a custom Linux service.



---

---

## Day 13 — Systemd Timers (Part 2) & Journal Introduction
- **Linux Mastery:** Day 13 / 30
- **AI Cloud Infrastructure Journey:** Day 209 / 1000
- **Focus:** Systemd Timers, Scheduled Services & Journalctl
- **Duration:** ~2.5 Hours
- **Linux Mastery:** Day 13 / 30
- **AI Cloud Infrastructure Journey:** Day 209 / 1000
- **Main Topics:** * Systemd timers
- **Deliverables:** ```text
- **Core takeaway:** > A cloud infrastructure engineer needs to know not only how to run workloads, but also how to schedule them, observe them, investigate failures, and automate repetitive operations.

### Objective
Today I learned how to automate Linux tasks using **systemd timers** and investigate system activity using the **systemd journal**.

The main goal was to understand:

* How systemd timers schedule services
* How `OnCalendar` works
* How persistent timers behave
* How systemd services and timers work together
* How to inspect logs using `journalctl`
* How to filter logs by service and priority
* How to follow logs in real time
* How to export journal entries as JSON
* How to manage journal disk usage

---

---

## Day 14 — Week 2 Review & Integration Project
- **Linux Mastery:** Day 14 / 30
- **AI Cloud Infrastructure Journey:** Day 210 / 1000
- **Focus:** Process Automation + systemd Integration
- **Duration:** ~3 Hours

### Objective
Review everything learned during Week 2 of Linux process management and integrate it into a practical project.

Today's goal is to build **Process Guardian** — a Bash-based process monitoring and recovery system managed by `systemd`.

The guardian will:

* Monitor critical processes
* Detect when a process stops
* Restart failed processes
* Support systemd services and direct commands
* Log restart events to the system journal
* Detect repeated failures
* Generate an alert after 3 restarts within 5 minutes
* Gracefully shut down when receiving `SIGTERM`
* Run continuously as a systemd service
* Automatically restart if the guardian itself crashes

---

---

