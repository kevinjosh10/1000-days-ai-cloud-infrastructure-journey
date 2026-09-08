# Month 1: Linux Essentials — Day-by-Day Mastery Plan (Revised)
## 4-Week Intensive | 15–20 hrs/week | ~2.5–3 hrs/day (Realistic)

> **Goal:** Debug production OS issues independently. Build muscle memory through daily hands-on practice. **This is intensive but survivable.**

---

## Pre-Flight Checklist (Before Day 1)

- [ ] Linux VM spun up: Ubuntu 22.04 LTS or Rocky Linux 9
- [ ] 30 GB disk space minimum
- [ ] Bash shell: `bash --version` (4.0+)
- [ ] SSH key generated: `ssh-keygen -t ed25519`
- [ ] GitHub account created; local repo initialized
- [ ] `man` pages working: `man bash` (test it)
- [ ] Text editor installed: `nano` or `vim` (your choice)
- [ ] Time commitment confirmed: 15–20 hrs/week minimum

---

## Week 1: Foundations — File Systems, Permissions & Bash Scripting
> **Theme:** "Master the filesystem, understand permissions, and write scripts that don't suck."

---

### Day 0 (Pre-Week) — Bash Bootcamp (Optional, but Recommended)
**Theory (1.5 hrs)**
- Bash basics: shebang, variables, quoting (single vs. double)
- Command substitution: `$(...)` vs. backticks
- Globbing and expansions: `*`, `?`, `[]`, `{1..10}`, `${var:-default}`
- Exit codes: `$?` and error handling
- `set -euo pipefail` — what each flag does and why it matters

**Hands-On (1.5 hrs)**
- Write 5 small scripts: hello world, variable expansion, loops, functions, error checking
- Test them with `bash -x script.sh` for debugging
- Commit to GitHub with meaningful messages

**Resources**
- *The Linux Command Line* (Shotts) — Chapter 24 (Writing Scripts)
- Bash pitfalls: https://mywiki.wooledge.org/BashPitfalls

**Deliverable**
- `00_bash_basics/` folder with 5 scripts + `README.md`

---

### Day 1 — The Linux Landscape & FHS
**Theory (1 hr)**
- Linux directory structure (FHS): `/bin`, `/sbin`, `/usr`, `/etc`, `/var`, `/tmp`, `/home`, `/opt`, `/mnt`, `/proc`, `/sys`, `/dev`
- Absolute vs. relative paths
- File types: regular, directory, symlink, block/char device, socket, pipe

**Hands-On (1.5 hrs)**
- Spin up VM; navigate filesystem: `cd`, `ls`, `pwd`, `tree`
- Inspect file types: `ls -l`, `file`, `stat` on 15 different file types
- Explore `/proc` and `/sys`: read `cpuinfo`, `meminfo`, `uptime`, `pressure/`

**Resources**
- *The Linux Command Line* — Chapters 1–3
- `man hier` (FHS reference)

**Deliverable**
- Screenshot of VM + `tree -L 2 /` output
- One-page: "What each FHS directory is for" (your own words)

---

### Day 2 — File & Directory Operations + Defensive Scripting
**Theory (1 hr)**
- File creation, deletion, copying, moving
- Wildcards & globbing: `*`, `?`, `[]`, `{}`
- Brace expansion and command substitution
- **Error handling in scripts**: `set -e`, `trap`, error messages

**Hands-On (2 hrs)**
- Create practice directory: `mkdir -p /practice/{docs,scripts,logs,backups/{daily,weekly}}`
- Practice: `touch`, `cp`, `mv`, `rm`, `rmdir`, `ln`, `ln -s`
- Experiment with wildcards: `ls *.txt`, `rm file{1..5}.log`
- Write a script with error handling; intentionally break it; practice debugging with `bash -x`

**Resources**
- *TLCL* — Chapters 4–5, 24
- `man bash` (search "EXPANSION")

**Deliverable**
- Script: `setup_practice_env.sh` — creates directory tree, handles errors, logs actions

---

### Day 3 — Inodes, Hard Links & Symlinks
**Theory (1.5 hrs)**
- What is an inode? (metadata: size, permissions, timestamps, block pointers)
- `stat` output deep dive: Access, Modify, Change times
- Hard links vs. symbolic links: inode sharing, cross-filesystem behavior, broken symlinks
- When to use each type; common gotchas

**Hands-On (1.5 hrs)**
- Run `stat` on 10 different file types
- Create hard link, verify same inode: `ls -li file hardlink`
- Create symlink, delete original, observe broken link behavior
- Find broken symlinks: `find . -type l ! -exec test -e {} \; -print`
- Disk usage comparison: `du -h`, `du -sh`, `du -ah` on `/var/log`

**Resources**
- *TLCL* — Chapter 11
- `man inode`, `man stat`

**Deliverable**
- Script: `link_auditor.sh` — finds and reports broken symlinks + duplicate files (hard link candidates)

---

### Day 4 — Permissions Deep Dive — Part 1 (UGO Model)
**Theory (1.5 hrs)**
- Permission bits: read (4), write (2), execute (1)
- UGO model: User, Group, Others
- Directory permissions: execute = traverse, read = list, write = create
- Default permissions: `umask` calculation and security implications
- Special permissions intro: SUID (4), SGID (2), Sticky Bit (1)

**Hands-On (1.5 hrs)**
- Create files with specific perms: `chmod 755`, `chmod 640`, `chmod 600`, `chmod 4755`
- Test directory traversal: create directories with different perms; try `cd` and `ls`
- Calculate and set `umask` for different scenarios: `umask 027` (secure), `umask 022` (standard)
- Identify SUID/SGID binaries: `find /usr/bin -perm -4000` and `find /usr/bin -perm -2000`
- Set sticky bit on test directory; verify non-owner can't delete others' files

**Resources**
- *TLCL* — Chapter 9
- `man chmod`, `man umask`

**Deliverable**
- Script: `secure_dir_setup.sh` — creates directories with specific perms; explains each in comments

---

### Day 5 — Permissions Deep Dive — Part 2 (ACLs & Attributes)
**Theory (1 hr)**
- POSIX ACLs: `getfacl`, `setfacl`, why they matter
- Default ACLs for inherited permissions
- Extended attributes: `lsattr`, `chattr`
- Immutable flag (`+i`), append-only (`+a`) — real-world use cases
- SELinux basics (contexts, enforcing vs. permissive) — awareness, not mastery

**Hands-On (1.5 hrs)**
- Enable ACLs on test filesystem
- Grant specific user access without changing group: `setfacl -m u:alice:rwx file`
- Set default ACL on directory; verify inheritance
- Make file immutable: `chattr +i file`; try to delete as root
- Inspect SELinux context: `ls -Z`, `getenforce`
- Quick demo: disable SELinux (not recommended in production!)

**Resources**
- `man getfacl`, `man setfacl`, `man chattr`
- Red Hat SELinux User Guide (Chapters 1–3)

**Deliverable**
- Script: `acl_setup.sh` — grants ACL, verifies, revokes; includes comments

---

### Day 6 — Storage, Partitions, Filesystems & Package Management
**Theory (1.5 hrs)** [SPLIT: Storage + Packages]

**Part A: Storage (45 min)**
- Block devices vs. character devices
- Partition tables: MBR vs. GPT
- Filesystem types: ext4, XFS, Btrfs, tmpfs (when to use)
- LVM basics: PV → VG → LV (high-level only)
- Mounting: `/etc/fstab`, `mount`, `umount`

**Part B: Package Management (45 min)** [NEW — CRITICAL MISSING TOPIC]
- Package managers: `apt` (Debian/Ubuntu) vs. `yum` (RHEL/CentOS)
- Package lifecycle: search, install, update, remove, info
- Dependencies and package repositories
- Building from source basics (configure, make, make install)

**Hands-On (1.5 hrs)**
- List block devices: `lsblk`, `blkid`, `df -h`, `df -T`
- Analyze partition table: `fdisk -l` or `parted -l`
- Review `/etc/fstab` — explain each column
- Check filesystem health: `fsck -n` (dry-run), `xfs_info`, `tune2fs`
- Mount tmpfs: `mount -t tmpfs -o size=100M tmpfs /mnt/ramdisk`
- **Package mgmt practice:**
  - `apt search curl` or `yum search curl`
  - Install a package: `apt install htop` or `yum install htop`
  - Show package info: `apt show htop` or `rpm -qi htop`
  - List installed packages: `dpkg -l | head` or `rpm -qa | head`
  - Update system: `apt update && apt upgrade` or `yum update`

**Resources**
- *TLCL* — Chapter 15
- `man fstab`, `man apt`, `man yum`
- Arch Wiki: "Pacman/Rosetta" (package manager comparison)

**Deliverable**
- Document: "My Server Storage & Packages" — map partitions, mount options, list 5 installed packages with purpose

---

### Day 7 — Week 1 Review & Mini-Project
**Review (1 hr)**
- Re-read all notes; re-run all scripts
- Flashcard quiz: permission octals, FHS paths, inode concepts, umask calculation

**Mini-Project (2 hrs): File System & Permission Auditor**
Write `fs_auditor.sh` that:
1. Scans `/home` for world-writable files (warn)
2. Finds SUID/SGID files outside standard paths (report)
3. Lists broken symlinks under `/opt`, `/home`, `/var`
4. Reports files with overly permissive ACLs
5. Generates timestamped summary: `~/reports/fs_audit_$(date +%F).txt`

**Deliverable**
- `fs_auditor.sh` + README (usage, output format, cron example)
- Push to GitHub with commit message: "Week 1: Filesystem auditing suite"

---

## Week 2: Process Management, Services & Package Administration
> **Theme:** "Every process is under your control. Master systemd."

---

### Day 8 — Process Fundamentals & Lifecycle
**Theory (1.5 hrs)**
- What is a process? PID, PPID, PID namespace
- Process states: R (running), S (sleeping), D (uninterruptible), T (stopped), Z (zombie)
- Process tree: `pstree`, `ps` forest view
- Init systems: SysV → Upstart → **systemd** (focus here)
- `/proc/<pid>/` deep dive: `cmdline`, `environ`, `fd`, `status`, `maps`

**Hands-On (1.5 hrs)**
- Inspect shell: `echo $$`, `ps -p $$ -o pid,ppid,cmd,stat`
- Explore `/proc/$$/`: read `cmdline`, `environ`, count FDs
- Run `pstree -p` and trace back to systemd or init
- Create a zombie in Python/C; observe in `ps`; explain why it exists
- Compare `ps aux`, `ps -ef`, `ps auxf` outputs

**Resources**
- *TLCL* — Chapter 10
- `man proc`, `man ps`, `man pstree`
- Systemd.io: process concepts

**Deliverable**
- Diagram: "Process lifecycle & states" (digital or hand-drawn)
- Short script that spawns a child process and shows parent-child relationship

---

### Day 9 — Monitoring & Managing Processes
**Theory (1 hr)**
- `top` vs. `htop` vs. `glances` — fields explained
- `pgrep`, `pkill`, `pidof` — pattern-based process management
- `nice` and `renice` — priority and CPU scheduling
- Memory vs. RSS vs. VSZ
- Load average interpretation

**Hands-On (1.5 hrs)**
- Run `htop`; sort by CPU, memory, memory growth
- Use `pgrep bash` to find all bash processes
- Use `pkill -f "python.*slow"` to kill matching processes
- Start a low-priority process: `nice -n 10 long_task.sh`
- Change priority on-the-fly: `renice -n +5 -p <pid>`
- Stress system: `stress-ng --cpu 2` and monitor with `top`

**Resources**
- `man top`, `man htop`, `man nice`, `man renice`
- Brendan Gregg: Linux Performance

**Deliverable**
- Script: `process_monitor.sh` — lists top 5 CPU hogs, top 5 memory hogs, system load average with timestamps

---

### Day 10 — Signals, Process Control & Job Management
**Theory (1 hr)**
- POSIX signals: SIGTERM (15), SIGKILL (9), SIGHUP (1), SIGUSR1 (10)
- Signal handling in scripts: `trap`
- Graceful shutdown vs. forced kill
- Background jobs: `&`, `bg`, `fg`, `jobs`
- Disown and nohup

**Hands-On (1.5 hrs)**
- Create a process that handles SIGTERM gracefully (cleanup before exit)
- Send signals: `kill -TERM <pid>`, `kill -9 <pid>`; observe differences
- Run process in background: `long_task.sh &`
- Suspend with Ctrl+Z; resume with `fg` or `bg`
- Demonstrate `nohup long_task.sh & disown`
- Create a script that handles SIGHUP to reload config without restart

**Resources**
- *TLCL* — Chapter 10
- `man signal`, `man trap`, `man kill`

**Deliverable**
- Script: `graceful_killer.sh` — sends SIGTERM, waits 5s, sends SIGKILL if needed; logs actions

---

### Day 11 — Cron, At & Scheduled Tasks
**Theory (1.5 hrs)**
- Cron syntax: `* * * * * command`
- Crontab: user vs. system (e.g., `/etc/cron.d/`, `/etc/cron.daily/`)
- Common pitfalls: PATH, environment variables, email output
- `at` and `atq` for one-time jobs
- Anacron for systems that don't run 24/7

**Hands-On (1.5 hrs)**
- Create user crontab: `crontab -e`
- Set up a task: run `log_cleanup.sh` daily at 2 AM
- Verify cron execution: check syslog or mail
- Use `at` to schedule one-time task: `echo "backup.sh" | at 3:00 AM tomorrow`
- Debug cron issue: check `crontab -l`, `/var/log/syslog`, environment variables
- Create system cron script in `/etc/cron.d/`

**Resources**
- *TLCL* — Chapter 23
- `man crontab`, `man 5 crontab`, `man cron`, `man at`

**Deliverable**
- Script: `log_rotator.sh` — rotates logs by date, compresses old ones
- Crontab entry running it daily + documentation

---

### Day 12 — Systemd Services & Timers (Part 1)
**Theory (1.5 hrs)**
- Systemd architecture: units, targets, generators
- Service files: `[Unit]`, `[Service]`, `[Install]`
- Service types: simple, forking, oneshot, notify
- Restart policies: `on-failure`, `always`, `Restart=on-failure RestartSec=10`
- Dependencies: `After=`, `Requires=`, `Wants=`
- Socket activation intro

**Hands-On (1.5 hrs)**
- Create a simple service unit: `myhttp.service` (runs a simple Python HTTP server)
- Place in `/etc/systemd/system/myhttp.service`
- `sudo systemctl daemon-reload`
- Start, stop, restart, status: `systemctl {start|stop|restart|status} myhttp`
- Enable on boot: `systemctl enable myhttp`
- Check logs: `journalctl -u myhttp -f`
- Create a failing service; configure `Restart=on-failure`

**Resources**
- `man systemd.unit`, `man systemd.service`
- systemd.io documentation (Units, Services)

**Deliverable**
- `myhttp.service` file with comments explaining each directive
- Test output showing service lifecycle

---

### Day 13 — Systemd Timers (Part 2) & Journal Introduction
**Theory (1 hr)**
- Systemd timers: persistent and transient scheduling
- Timer units: `[Timer]` section, OnCalendar syntax
- Systemd journal: binary format, indexed, structured logging
- Journalctl basics: `-b` (boot), `-u` (unit), `-f` (follow), `-n` (lines)

**Hands-On (1.5 hrs)**
- Create timer + service: `backup.timer` runs `backup.service` daily at 3 AM
- `systemctl start backup.timer`, `systemctl enable backup.timer`
- `systemctl list-timers` to verify
- Query journal: `journalctl -u backup.service`, `journalctl -b`, `journalctl -f`
- Filter by priority: `journalctl -p warning`, `journalctl -p err`
- Export JSON: `journalctl -u backup.service -o json-pretty`
- Set disk limit: `journalctl --vacuum-size=500M`

**Resources**
- `man systemd.timer`, `man systemd.time`
- `man journalctl`, systemd.io: "The Journal"

**Deliverable**
- `backup.timer` + `backup.service` files
- `system_scheduler.sh` — creates sample timer + service demonstrating scheduling

---

### Day 14 — Week 2 Review & Integration Project
**Review (1 hr)**
- Quiz: "What's the difference between `Wants=` and `Requires=`?" 
- Re-run all process management scripts
- Practice `systemctl` commands until muscle memory

**Integration Project (2 hrs): Process Guardian**
Write `process_guardian.sh` that:
1. Monitors a list of critical processes (config file: `processes_to_guard.cfg`)
2. If a process dies, restarts it via systemd service or direct command
3. Logs all restarts to journal with timestamp + reason
4. Sends alert (email or log entry) if same process restarts 3x in 5 minutes
5. Gracefully stops all guarded processes on SIGTERM

Run it as a systemd service with auto-restart.

**Deliverable**
- `process_guardian.sh` + `process_guardian.service` + `processes_to_guard.cfg`
- README: "How to monitor custom processes"
- Commit: "Week 2: Process automation and systemd integration"

---

## Week 3: Security, Users, SSH & Firewalls
> **Theme:** "Lock it down. Authentication and network filtering matter."

---

### Day 15 — User & Group Management
**Theory (1 hr)**
- User accounts: `/etc/passwd`, `/etc/shadow`, UID/GID
- Group accounts: `/etc/group`, `/etc/gshadow`
- User creation, deletion, modification
- Password aging: `chage`
- System vs. regular users; UID ranges

**Hands-On (1.5 hrs)**
- Create user: `useradd -m -s /bin/bash alice`
- Set password: `passwd alice`
- Create group: `groupadd developers`
- Add user to group: `usermod -aG developers alice`
- View user info: `id alice`, `finger alice`
- Check password expiry: `chage -l alice`
- Set password expiry: `chage -E 2025-12-31 -W 14 alice`
- Delete user: `userdel -r alice` (remove home dir)

**Resources**
- `man useradd`, `man usermod`, `man passwd`, `man chage`
- `/etc/login.defs` — system-wide defaults

**Deliverable**
- Script: `bulk_user_setup.sh` — reads CSV file, creates users, sets groups, logs actions
- Test CSV with 3 users; verify creation

---

### Day 16 — Sudo & Privilege Escalation
**Theory (1.5 hrs)**
- `sudo` architecture: `/etc/sudoers`, visudo
- Sudoers syntax: users, groups, commands, NOPASSWD
- `sudo -i` vs. `sudo su -` vs. `sudo -s`
- Logging: `sudo` audit trail in syslog/journal
- Passwordless sudo for specific commands (automation-friendly)
- Common misconfigurations and security risks

**Hands-On (1.5 hrs)**
- Edit sudoers (ONLY with `visudo`; NEVER edit directly)
- Grant user: `alice ALL=(ALL) ALL` (full sudo)
- Grant group: `%developers ALL=(ALL) /usr/bin/systemctl`
- Grant passwordless: `alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx`
- Test each rule; verify logging: `grep sudo /var/log/auth.log` or `journalctl SYSLOG_IDENTIFIER=sudo`
- Demonstrate `sudo -l` to see what a user can do
- Break a sudo rule intentionally; observe audit trail

**Resources**
- `man sudoers`, `man visudo`
- `/etc/sudoers.d/` — split configuration best practice

**Deliverable**
- Document: "Sudoers Configuration for Our Team" (your imaginary org)
- Script: `apply_sudoers.sh` — validates sudoers syntax, backs up original, applies new rules

---

### Day 17 — SSH Hardening & Key-Based Authentication
**Theory (1.5 hrs)**
- SSH protocol: public-key vs. password authentication
- Key generation: RSA vs. ECDSA vs. Ed25519 (recommend Ed25519)
- `~/.ssh/authorized_keys`, `~/.ssh/config`
- SSH server hardening: `/etc/ssh/sshd_config`
- Port changes, key-only auth, root login disable, rate limiting
- `ssh-agent` and key caching
- Jump hosts / bastion hosts

**Hands-On (1.5 hrs)**
- Generate Ed25519 key: `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@host"`
- Copy public key to server: `ssh-copy-id -i ~/.ssh/id_ed25519 user@host`
- Test key auth: `ssh -i ~/.ssh/id_ed25519 user@host`
- Configure `~/.ssh/config` for quick access:
  ```
  Host myserver
      HostName 192.168.1.100
      User alice
      IdentityFile ~/.ssh/id_ed25519
  ```
- Harden sshd_config:
  - `PermitRootLogin no`
  - `PasswordAuthentication no`
  - `PubkeyAuthentication yes`
  - `Port 2222` (non-standard)
  - `MaxAuthTries 3`, `MaxSessions 5`
- Restart SSH: `sudo systemctl restart ssh`
- Test from another machine: `ssh -p 2222 user@host`
- Check logs: `journalctl -u ssh` or `tail /var/log/auth.log`

**Resources**
- `man ssh`, `man ssh-keygen`, `man sshd_config`
- SSH Academy: SSH protocol overview

**Deliverable**
- Script: `setup_ssh_hardening.sh` — backs up sshd_config, applies hardening, restarts SSH safely
- SSH config snippet for team use

---

### Day 18 — Firewalls, UFW & Network Filtering
**Theory (1.5 hrs)**
- Firewall concepts: stateful, stateless, netfilter, iptables
- UFW (Uncomplicated Firewall): simple, opinionated frontend to iptables
- `ufw` rules: default policies, allow, deny, limit
- UFW profiles for apps (e.g., `ufw allow 'OpenSSH'`)
- Rate limiting to prevent brute-force
- Logging and rule inspection

**Hands-On (1.5 hrs)**
- Check firewall status: `ufw status`
- Enable firewall: `sudo ufw enable` (careful not to lock yourself out!)
- Set default policies: `sudo ufw default deny incoming`, `sudo ufw default allow outgoing`
- Allow SSH (before enabling): `sudo ufw allow 22/tcp` or `sudo ufw allow 'OpenSSH'`
- Allow HTTP/HTTPS: `sudo ufw allow 80/tcp`, `sudo ufw allow 443/tcp`
- Deny a specific IP: `sudo ufw deny from 192.168.1.50`
- Rate limit SSH: `sudo ufw limit 22/tcp` (max 6 connections per 30 sec)
- List rules with numbers: `sudo ufw show added`
- Delete a rule: `sudo ufw delete allow 8080/tcp`
- Check logs: `tail /var/log/ufw.log`

**Resources**
- `man ufw`, Ubuntu UFW documentation
- `man iptables` (advanced; optional deep dive)

**Deliverable**
- Script: `basic_firewall.sh` — applies sensible defaults, configurable services
- Document: "Firewall Rules for Production" (your imaginary setup)

---

### Day 19 — File Integrity & Auditd
**Theory (1 hr)**
- File integrity monitoring: AIDE, Tripwire, auditd
- `auditd`: system call auditing, real-time monitoring
- Audit rules: `-w` (watch), `-p` (permissions), `-k` (key)
- `ausearch` and `aureport` for analysis
- Regulatory compliance: PCI-DSS, HIPAA often require audit trails

**Hands-On (1.5 hrs)**
- Install: `apt install auditd` or `yum install audit`
- Enable: `sudo systemctl start auditd`, `sudo systemctl enable auditd`
- Add audit rule: `sudo auditctl -w /etc/passwd -p wa -k passwd_modifications`
- Add rule for system calls: `sudo auditctl -a always,exit -F arch=b64 -S execve -k exec`
- List rules: `sudo auditctl -l`
- Modify a watched file; check audit log: `sudo ausearch -k passwd_modifications`
- Generate report: `sudo aureport`
- Make rules persistent: `/etc/audit/rules.d/audit.rules`

**Resources**
- `man auditctl`, `man ausearch`, `man auditd.conf`
- RedHat Audit documentation

**Deliverable**
- Script: `deploy_audit_rules.sh` — sets up comprehensive audit rules for compliance
- Document: "What we're auditing and why"

---

### Day 20 — Backups & Disaster Recovery (NEW — CRITICAL)
**Theory (1.5 hrs)**
- Backup strategies: full, incremental, differential
- 3-2-1 rule: 3 copies, 2 media types, 1 offsite
- Backup tools: `rsync`, `tar`, `restic`, `burp`
- Backup testing: restore drills, not just fire-and-forget
- Retention policies: daily/weekly/monthly/yearly
- Encryption in transit and at rest

**Hands-On (1.5 hrs)**
- Create tarball: `tar -czf backup_$(date +%F).tar.gz /home/user/data`
- List contents: `tar -tzf backup_*.tar.gz | head`
- Extract: `tar -xzf backup_*.tar.gz -C /restore_test/`
- Incremental backup with `rsync`: 
  ```bash
  rsync -av --delete /source/ /backup/destination/
  ```
- Verify backup: `diff -r /source /backup/destination`
- Create a backup script with logging and email notification
- Set up cron to run backups daily
- Simulate disaster: delete a file, restore from backup, verify

**Resources**
- `man tar`, `man rsync`
- Restic documentation (modern backup tool)
- 3-2-1 backup rule articles

**Deliverable**
- Script: `daily_backup.sh` — full/incremental backup with logging, retention policy
- Script: `backup_verification.sh` — spot-checks backup integrity
- Cron setup to run backup daily + weekly off-site copy

---

### Day 21 — Week 3 Review & Integration Project
**Review (1 hr)**
- Quiz: "How do you allow a user to restart nginx without password?"
- Re-run all security scripts; test SSH hardening manually
- Practice `ufw` rules from memory

**Integration Project (2.5 hrs): Onboard User Script**
Write `onboard_user.sh` that:
1. Creates user account with home directory
2. Adds to appropriate groups (e.g., developers, admins)
3. Configures sudo rules (read from template)
4. Copies SSH public keys to authorized_keys
5. Sets password expiry policies
6. Creates audit rules for user's home directory
7. Logs all actions; sends summary email to admin

**Deliverable**
- `onboard_user.sh` + supporting config files
- Usage documentation + example runs
- Commit: "Week 3: User onboarding and security hardening"

---

## Week 4: System Monitoring, Troubleshooting & Capstone
> **Theme:** "See everything. Fix anything fast."

---

### Day 22 — CPU Monitoring & Profiling
**Theory (1 hr)**
- CPU metrics: utilization, load average, context switches
- `vmstat`, `mpstat`, `iostat` — per-CPU breakdowns
- Load average: 1-min, 5-min, 15-min interpretation
- Runnable vs. blocked processes

**Hands-On (1.5 hrs)**
- Check CPU info: `lscpu`, `nproc`
- Monitor real-time: `vmstat 1`, watch for `us`, `sy`, `id`, `wa`
- Per-core breakdown: `mpstat 1`
- Compare top CPU processes: `top -b -n1 | head -20`
- Stress CPU: `stress-ng --cpu $(nproc)` and monitor
- Analyze with `sar` (if installed): `sar -u 1 5`

**Resources**
- Brendan Gregg: "CPU Performance Analysis" (linuxperf.com)
- `man vmstat`, `man mpstat`, `man iostat`

**Deliverable**
- Script: `cpu_profiler.sh` — captures CPU utilization, load, top processes with timestamp

---

### Day 23 — Memory Monitoring & Management
**Theory (1 hr)**
- Memory types: RSS, VSZ, shared memory, swap
- `free`, `vmstat` memory columns
- Out-Of-Memory (OOM) killer behavior
- Memory pressure: `/proc/pressure/memory`
- Swap management and performance impact

**Hands-On (1.5 hrs)**
- Check memory: `free -h`, `free -h -w` (new format)
- View by process: `ps aux --sort=-%mem | head -20`
- Check OOM killer settings: `cat /proc/sys/vm/overcommit_memory`
- Simulate memory pressure: `stress-ng --vm 2 --vm-bytes 50%`
- Monitor in real-time: `vmstat 1` watch `free`, `buff`, `swap`
- Check swap usage: `swapon -s`, `cat /proc/swaps`
- Observe OOM killer: `dmesg | grep -i oom`

**Resources**
- Brendan Gregg: "Memory Performance Analysis"
- Linux memory management internals

**Deliverable**
- Script: `mem_profiler.sh` — tracks memory usage, identifies memory hogs, checks swap pressure

---

### Day 24 — Disk I/O Monitoring
**Theory (1 hr)**
- Disk I/O metrics: IOPS, throughput, latency, queue depth
- `iostat`: read/write rates, await, svctm
- Filesystem performance: ext4 vs. XFS
- I/O scheduler choices: `noop`, `deadline`, `cfq`, `mq-deadline`

**Hands-On (1.5 hrs)**
- Check disk devices: `lsblk -d`, `fdisk -l`
- Real-time I/O: `iostat -x 1` (every 1 second)
- Watch for: `r/s`, `w/s` (ops/sec), `rrqm/s`, `wrqm/s` (merges), `await` (latency)
- Generate disk load: `dd if=/dev/zero of=/tmp/testfile bs=1M count=1000`
- Monitor during write: `iostat -x 1` in another terminal
- Check I/O scheduler: `cat /sys/block/sda/queue/scheduler`
- Compare `vmstat` memory and disk stats

**Resources**
- `man iostat`, `man iotop`
- Brendan Gregg: "Disk I/O Performance Analysis"

**Deliverable**
- Script: `disk_profiler.sh` — monitors disk I/O, identifies heavy readers/writers

---

### Day 25 — Network Performance & Debugging
**Theory (1 hr)**
- Network metrics: bandwidth, latency, packet loss, retransmissions
- `ss` vs. `netstat`: socket statistics
- `iperf3` for bandwidth testing
- `ping`, `traceroute`, `mtr` for connectivity
- TCP connection state: LISTEN, ESTABLISHED, TIME_WAIT, etc.

**Hands-On (1.5 hrs)**
- List listening ports: `ss -tlnp`
- Show all connections: `ss -anp`
- Check for TIME_WAIT buildup: `ss -tan | grep TIME_WAIT | wc -l`
- Network bandwidth: (optional) `iperf3` between two machines
- DNS resolution: `nslookup`, `dig`, `host`
- Trace packets: `tcpdump -i eth0 -n port 80` (capture HTTP traffic)
- Connection states: `ss -tan | awk '{print $2}' | sort | uniq -c`

**Resources**
- `man ss`, `man netstat`, `man tcpdump`
- iperf3 documentation (if available in your network)

**Deliverable**
- Script: `network_profiler.sh` — captures network baseline, listening ports, connection stats

---

### Day 26 — Logs & Journalctl Mastery
**Theory (1 hr)**
- systemd journal: binary format, indexed, structured
- `journalctl` queries: boolean operators, field filters, output formats
- Log levels: emerg, alert, crit, err, warning, notice, info, debug
- Persistent vs. volatile storage
- Log rotation and retention

**Hands-On (1.5 hrs)**
- Query all logs: `journalctl | head -50`
- Filter by boot: `journalctl -b` (current), `journalctl -b -1` (previous)
- Follow service: `journalctl -u nginx -f`
- Time range: `journalctl --since "2024-01-15 09:00" --until "2024-01-15 12:00"`
- Error-level only: `journalctl -p err`
- Executable path: `journalctl /usr/bin/nginx`
- Export JSON: `journalctl -o json-pretty | head -100`
- Set retention: `journalctl --vacuum-size=1G`, `journalctl --vacuum-time=7d`
- Disk usage: `journalctl --disk-usage`

**Resources**
- `man journalctl`, `man systemd.journal-fields`
- systemd.io: "The Journal"

**Deliverable**
- Script: `log_investigator.sh` — accepts time window + service name; extracts and summarizes logs

---

### Day 27 — System Snapshot & Comprehensive Monitoring
**Theory (1 hr)**
- Monitoring frameworks: Prometheus, Grafana, ELK, Splunk (concepts)
- The USE method: Utilization, Saturation, Errors (Brendan Gregg)
- The RED method: Rate, Errors, Duration (for services)
- All-in-one tools: `dstat`, `glances`

**Hands-On (1.5 hrs)**
- Install and run `glances`: `glances` (TUI) or `glances -w` (web mode)
- Unified snapshot: `dstat --cpu --mem --net --disk --proc`
- Create one-liner for complete snapshot:
  ```bash
  echo "=== CPU ===" && mpstat 1 1 && echo "=== Memory ===" && free -h && \
  echo "=== Disk ===" && iostat -x 1 1 && echo "=== Network ===" && ss -tan | awk '{print $2}' | sort | uniq -c
  ```
- Set up cron job to capture snapshot every 10 minutes
- Trending: Compare snapshots over time to identify patterns

**Resources**
- Brendan Gregg: "USE Method" article
- `man dstat`, `man glances`

**Deliverable**
- Script: `system_snapshot.sh` — single command captures CPU, memory, disk, network, processes
- Cron setup to log snapshots every 10 min; aggregate reports

---

### Day 28 — Troubleshooting Methodology & Case Studies
**Theory (1.5 hrs)**
- Framework: Define problem → Measure → Analyze → Improve → Verify
- Common patterns: high load but low CPU use, fast disk but slow app, etc.
- Tools: `strace`, `lsof`, `perf` (intro)
- Systematic vs. random debugging
- Root cause analysis: the "5 Whys"

**Hands-On (1.5 hrs)**
- **Case Study 1:** High load, low CPU
  - Use: `vmstat`, `iostat`, `pidstat`
  - Likely cause: disk I/O or memory swapping
- **Case Study 2:** Process can't write file
  - Use: `strace -e openat -p <pid>`, `lsof +D /path`, `ls -la` on file
  - Check: permissions, inode limits, disk space
- **Case Study 3:** Port stuck in TIME_WAIT
  - Use: `ss -tan | grep TIME_WAIT`, increase `tw_reuse` if needed
- **Case Study 4:** Mystery high CPU process
  - Use: `top`, `strace -c -p <pid>`, `perf top` (if installed)
- Practice `strace`: `strace -e trace=open,openat,read,write ls /tmp 2>&1 | head -50`

**Resources**
- `man strace`, `man lsof`, `man perf`
- Red Hat: "Troubleshooting Guide"

**Deliverable**
- Document: `troubleshooting_playbook.md` — 5+ real scenarios with diagnosis commands and solutions

---

### Day 29 — Integration & Practice
**Review (1 hr)**
- Re-run all monitoring scripts; verify they still work
- Practice interpreting `vmstat 1`, `iostat -x 1`, `ss -tan` output
- Quiz: "What tool tells you which process opened that file?"

**Integration Exercise (2 hrs)**
- Simulate a sick server: `stress-ng --cpu 2 --vm 2 --io 2` (or lower numbers on weak VM)
- Use ALL your tools to diagnose: CPU, memory, disk, network bottlenecks
- Identify the culprit; explain what's happening
- Create structured report with findings, tools used, root cause, recommendations

**Deliverable**
- Report: `sick_server_diagnosis.md` — analysis with screenshots/output, tool explanations

---

### Day 30 — Month 1 Capstone Project
**Capstone (3–4 hrs): Production System Monitor**

Build `sysmon.sh` — a comprehensive, realistic monitoring suite:

**Core Requirements:**
1. **CPU Module**: Per-core usage, load avg, top 3 CPU hogs
2. **Memory Module**: Total/used/free, top 3 memory hogs, swap usage
3. **Disk Module**: Filesystem usage (warn >80%), I/O throughput (reads/sec, writes/sec)
4. **Network Module**: Listening ports count, ESTABLISHED connections count
5. **Processes Module**: Process count, zombie count, top 3 by runtime
6. **Journal Module**: Last 5 ERROR-level log entries (if any)

**Execution & Output:**
- Single JSON output for easy parsing: `{cpu: {...}, memory: {...}, ...}`
- Or plain text with clear sections
- Timestamp on every metric
- Color-coded thresholds (if terminal output):
  - Green: normal
  - Yellow: caution (CPU > 70%, Memory > 80%)
  - Red: critical (CPU > 90%, Memory > 95%, Disk > 90%)

**Bonus (Optional):**
- Systemd timer: `sysmon.timer` runs every 5 min; appends results to log file
- Configuration file: `sysmon.conf` with customizable thresholds
- Email alert if critical threshold breached

**Deliverable:**
- `sysmon.sh` (main script, ~150–200 lines)
- Optional: `sysmon.service`, `sysmon.timer`, `sysmon.conf`
- Comprehensive README: purpose, usage, output format, integration
- Example output (JSON + text)
- Test run on your VM

**Submission:**
- Push to GitHub with clean directory structure:
  ```
  sysmon/
  ├── sysmon.sh
  ├── sysmon.conf (optional)
  ├── sysmon.service (optional)
  ├── sysmon.timer (optional)
  ├── README.md
  └── examples/
      ├── output.json
      └── output.txt
  ```
- Commit message: "Month 1 Capstone: Production system monitor"

---

## Resources Summary

### Books
| Resource | Chapters | Purpose |
|----------|----------|---------|
| *The Linux Command Line* (Shotts) | 1–5, 9–12, 15–16, 23–24 | Core reference |
| *How Linux Works* (Ward) | 1–4, 7–9 | Deeper internals |
| *Linux Bible* (Negus) | 3, 6, 8, 11, 13, 15 | Supplemental depth |
| *The Unix & Linux System Administrator's Handbook* (Nemeth et al.) | Chapters 1–5 | Professional perspective |

### Online
- **Linux man pages**: Your primary reference — `man bash`, `man systemctl`, etc.
- **Arch Wiki**: Best technical documentation available
- **Red Hat System Administrator's Guide**: Enterprise focus
- **Brendan Gregg's Linux Performance**: brendangregg.com/linuxperf.html
- **systemd.io**: Official systemd documentation

### Practice Environment
- **Primary**: Local VM (VirtualBox/UTM/Hyper-V) — Ubuntu 22.04 LTS or Rocky Linux 9
- **Secondary**: Cloud VM (AWS free tier / GCP always free) for networking
- **Tertiary**: WSL2 only for scripting (NOT for systemd or networking)

---

## Progress Tracker

| Day | Topic | Hours | Deliverable | Status |
|-----|-------|-------|-------------|--------|
| 0 | Bash Bootcamp (Optional) | 3 | 5 scripts | ☐ |
| 1 | Linux Landscape | 2.5 | FHS notes | ☐ |
| 2 | File Operations | 3 | `setup_practice_env.sh` | ☐ |
| 3 | Inodes & Links | 3 | `link_auditor.sh` | ☐ |
| 4 | Permissions UGO | 3 | `secure_dir_setup.sh` | ☐ |
| 5 | ACLs & Attributes | 2.5 | `acl_setup.sh` | ☐ |
| 6 | Storage & Packages | 3 | Storage/packages doc | ☐ |
| 7 | W1 Project | 3 | `fs_auditor.sh` | ☐ |
| 8 | Process Fundamentals | 3 | Process diagram | ☐ |
| 9 | Process Monitoring | 3 | `process_monitor.sh` | ☐ |
| 10 | Signals & Control | 3 | `graceful_killer.sh` | ☐ |
| 11 | Cron & At | 3 | `log_rotator.sh` | ☐ |
| 12 | Systemd Services | 3 | `myhttp.service` | ☐ |
| 13 | Systemd Timers | 3 | `backup.timer` | ☐ |
| 14 | W2 Project | 3 | `process_guardian.sh` | ☐ |
| 15 | Users & Groups | 3 | `bulk_user_setup.sh` | ☐ |
| 16 | Sudo & Privilege | 3 | `apply_sudoers.sh` | ☐ |
| 17 | SSH Hardening | 3 | `setup_ssh_hardening.sh` | ☐ |
| 18 | Firewalls | 3 | `basic_firewall.sh` | ☐ |
| 19 | File Integrity | 3 | `deploy_audit_rules.sh` | ☐ |
| 20 | Backups & DR | 3 | `daily_backup.sh` | ☐ |
| 21 | W3 Project | 3 | `onboard_user.sh` | ☐ |
| 22 | CPU Monitoring | 2.5 | `cpu_profiler.sh` | ☐ |
| 23 | Memory Monitoring | 2.5 | `mem_profiler.sh` | ☐ |
| 24 | Disk I/O | 2.5 | `disk_profiler.sh` | ☐ |
| 25 | Network Performance | 2.5 | `network_profiler.sh` | ☐ |
| 26 | Logs & Journalctl | 2.5 | `log_investigator.sh` | ☐ |
| 27 | System Snapshot | 2.5 | `system_snapshot.sh` | ☐ |
| 28 | Troubleshooting | 3 | `troubleshooting_playbook.md` | ☐ |
| 29 | Integration | 3 | `sick_server_diagnosis.md` | ☐ |
| 30 | Capstone | 4 | `sysmon.sh` + docs | ☐ |

**Total: ~92 hours over 30 days (3 hrs/day average, realistic)**

---

## Success Criteria for Month 1 Completion

Before advancing to Month 2, you should be able to:

- [ ] Explain any FHS directory without looking it up
- [ ] Set complex permission scenarios (UGO + ACL) in under 15 min
- [ ] Write a systemd service + timer from scratch
- [ ] Diagnose a "slow server" using `vmstat`, `iostat`, `ss` in under 10 min
- [ ] Harden SSH and configure firewall with documented rules
- [ ] Create a user with groups, sudo, SSH keys, audit rules (automation script)
- [ ] Have a GitHub repo with 15+ working scripts, all with best practices:
  - `#!/bin/bash` shebang
  - `set -euo pipefail`
  - Error handling (`trap`, `||`)
  - Comments explaining logic
  - Usage/help output
- [ ] Comfortably read and use `man` pages as primary reference
- [ ] Understand and explain: processes, permissions, systemd, monitoring, logs, troubleshooting

---

## Month 2 Preview
*After Month 1, you'll be ready for:*
- Advanced shell scripting: functions, error handling patterns, testing
- Python for automation: system calls, subprocess, file handling
- Container fundamentals: Docker basics, container networking
- Infrastructure as Code: Terraform, Ansible intro

---

> **"The Linux command line is the most powerful tool in DevOps/SRE. Every hour here multiplies your value 10x. Enjoy the journey."**

**Ready? Start with Day 0 (Bash Bootcamp), or jump to Day 1 if you're confident. Either way — commit your work. Future you will thank you.**
