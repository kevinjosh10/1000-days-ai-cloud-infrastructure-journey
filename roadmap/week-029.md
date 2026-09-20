# Week 29 Roadmap: Linux Mastery I — Filesystem, Permissions, Storage & Defensive Automation

## 📅 Timeline: Days 197 - 203 (Linux Mastery: Days 1 - 7 / 30)

### 🎯 Weekly Objective
Build an enterprise-grade Linux systems and security foundation. Master the Filesystem Hierarchy Standard (FHS), defensive Bash scripting, inode structures, discretionary and mandatory access controls (UGO, POSIX ACLs, Extended Attributes, SELinux), storage management (MBR/GPT, LVM, `tmpfs`, `/etc/fstab`), and package management lifecycles. Consolidate everything into a production security auditing suite (`fs_auditor.sh`).

---

### 🛣️ Comprehensive Daily Breakdown

- [x] **Day 197: Filesystem Foundations, FHS & File Types (Linux Day 1)**
  - [x] Understand Linux kernel subsystems (CPU, Memory, Processes, Devices, Filesystems, Networking) vs. user-space distributions.
  - [x] Master the Filesystem Hierarchy Standard (FHS): `/`, `/bin`, `/boot`, `/dev`, `/etc`, `/home`, `/mnt`, `/opt`, `/proc`, `/root`, `/run`, `/sbin`, `/sys`, `/tmp`, `/usr`, `/var`, `/var/log`.
  - [x] Practice navigation and pathing: absolute paths, relative paths, `.`, `..`, and `~`.
  - [x] Identify all 7 Linux file types from `ls -l`: regular file (`-`), directory (`d`), symlink (`l`), character device (`c`), block device (`b`), socket (`s`), and named pipe (`p`).
  - [x] File inspection commands: `pwd`, `ls`, `ls -l`, `ls -la`, `cd`, `tree`, `file`, `stat`.
  - [x] Explore runtime virtual filesystems: `/proc` (`cpuinfo`, `meminfo`, `uptime`), `/sys` (hardware/devices), and `/dev` (`/dev/null`, "everything is a file").
  - [x] Map the cloud troubleshooting workflow: Incident $\rightarrow$ Config (`/etc`) $\rightarrow$ Logs (`/var/log`) $\rightarrow$ Metrics (`/proc`) $\rightarrow$ Devices (`/dev`) $\rightarrow$ Kernel (`/sys`).

- [x] **Day 198: File Operations & Defensive Bash Scripting (Linux Day 2)**
  - [x] Directory creation: `mkdir`, nested creation with `mkdir -p`, and complex tree generation via brace expansion `mkdir -p /practice/{docs,scripts,logs,backups/{daily,weekly}}`.
  - [x] File creation: `touch`, batch creation with brace expansion `touch file{1..5}.txt`.
  - [x] File manipulation: copying files and directories (`cp`, `cp -r`), moving and renaming (`mv`).
  - [x] Safe deletion: `rm`, `rm -r`, `rm -f`, `rmdir` (empty directories), and evaluating the catastrophic risks of unconstrained `rm -rf`.
  - [x] Introduction to Hard Links (`ln`) vs. Symbolic Links (`ln -s`) and tracking inode numbers with `ls -li`.
  - [x] Shell Wildcards / Globbing (`*`, `?`, `[]`) vs. Brace Expansion string generation (`{1..5}`, `{jan,feb,mar}`).
  - [x] Command substitution: storing outputs dynamically via `$(command)`.
  - [x] Defensive Bash Scripting standards:
    - [x] `set -e`: Immediate exit on unhandled error.
    - [x] `trap 'echo "ERROR: Script failed at line $LINENO"' ERR`: Line-level error trapping.
    - [x] Persistent logging via appending (`>>`) vs. overwriting (`>`).
    - [x] Subshell execution tracing with `bash -x`.
    - [x] Exit code evaluation with `$?` (0 = Success, non-zero = Failure).
  - [x] Deliverable: Architect the automated environment builder `setup_practice_env.sh`.

- [x] **Day 199: Inodes, Timestamps, Links & Disk Diagnostics (Linux Day 3)**
  - [x] Deep dive into Inode architecture: metadata, permissions, owner UID, group GID, size, timestamps, link counts, and data block pointers.
  - [x] Understand why filenames live in directory entries, NOT inside the inode.
  - [x] Master Linux file timestamps:
    - [x] `atime` (Access): Last time file was read (and `relatime` optimization).
    - [x] `mtime` (Modify): Last time file *contents* were altered.
    - [x] `ctime` (Change): Last time file *metadata/status* changed (`chmod`, `chown`). Note: `ctime` $\neq$ creation time!
  - [x] In-depth Hard Links: multiple directory entries pointing to the same inode; deletion mechanics (data freed only when link count reaches 0); cross-filesystem and directory restrictions.
  - [x] In-depth Symbolic Links: independent inode containing target path string; cross-filesystem capabilities; directory linking.
  - [x] Broken symlinks: identify and locate orphaned links using `find . -type l ! -exec test -e {} \; -print` and `find /opt /home /var -xtype l`.
  - [x] Disk capacity vs. directory utilization: `df -h` vs. `du -sh` / `du -ah`.
  - [x] Inode exhaustion troubleshooting: diagnosing "No space left on device" using `df -i`.
  - [x] Deliverable: Build `link_auditor.sh` and find hard-link candidate duplicates with `find . -type f -printf '%i %p\n'`.

- [x] **Day 200: Permissions Deep Dive I — UGO Model, `umask` & Special Bits (Linux Day 4)**
  - [x] **🎉 Major Milestone: 200 Days (20%) of the 1000-Day Journey Complete!**
  - [x] Master the User, Group, Others (UGO) permission triad (`rwx`).
  - [x] Octal permission values and calculation: Read ($r=4$), Write ($w=2$), Execute ($x=1$). Summing to modes `755`, `640`, `600`, `700`, `750`.
  - [x] Use `chmod` with numeric octals and symbolic syntax (`u+x`, `g+w`, `o-r`, `u=rw,g=r,o=`).
  - [x] Understand the critical difference between file and directory permissions (directory `x` = path traversal / directory entry access).
  - [x] Master `umask` subtraction from `777` (directories) and `666` (files):
    - [x] Standard `umask 022` $\rightarrow$ Directory `755` (`rwxr-xr-x`), File `644` (`rw-r--r--`).
    - [x] Isolated `umask 027` $\rightarrow$ Directory `750` (`rwxr-x---`), File `640` (`rw-r-----`).
  - [x] Master Special Permission Bits:
    - [x] SUID (`4000` / `u+s`): Run executable with file owner's effective privileges (auditing: `find /usr/bin -perm -4000 -type f`).
    - [x] SGID (`2000` / `g+s`): Run with group privileges; on directories, enforce group ownership inheritance for newly created files.
    - [x] Sticky Bit (`1000` / `+t`): Prevent non-owners from deleting/renaming other users' files in shared folders like `/tmp` (`1777` / `drwxrwxrwt`).
  - [x] Apply the Principle of Least Privilege in cloud infrastructure (avoiding `chmod 777`).
  - [x] Deliverable: Write, execute, and verify the `secure_dir_setup.sh` script.

- [x] **Day 201: Permissions Deep Dive II — POSIX ACLs, Extended Attributes & SELinux (Linux Day 5)**
  - [x] Solve UGO group-sprawl limitations with POSIX Access Control Lists (ACLs).
  - [x] Granular user/group access modification with `setfacl -m u:alice:rwx file` and `setfacl -m g:auditors:r-- file`.
  - [x] Inspect ACL tables with `getfacl` and identify ACL-enabled files by the `+` flag in `ls -l` (`-rw-rwxr--+`).
  - [x] Configure directory Default ACLs for automatic inheritance on new children (`setfacl -d -m g:devteam:rwx /dir`).
  - [x] Enforce kernel-level filesystem protection with Extended Attributes (`chattr` / `lsattr`):
    - [x] `+i` (Immutable): Prevent modification, renaming, or deletion even by `root` (UID 0).
    - [x] `+a` (Append-Only): Restrict file writes strictly to append mode for tamper-evident audit logs (`/var/log/audit.log`).
  - [x] Understand Mandatory Access Control (MAC) and SELinux fundamentals:
    - [x] SELinux context labels (`user:role:type:level`) via `ls -Z`.
    - [x] Context sandboxing: how process types (`httpd_t`) are restricted from accessing unauthorized file types (`shadow_t`).
    - [x] Operational modes: `Enforcing`, `Permissive`, and `Disabled` (`getenforce`, `setenforce 0`, `setenforce 1`).
  - [x] Deliverable: Write, verify, and document `acl_setup.sh`.

- [x] **Day 202: Storage Stacks, LVM, Filesystems & Package Management (Linux Day 6)**
  - [x] Map the full Linux storage stack: Physical Disk / AWS EBS $\rightarrow$ Partition Table (MBR vs. GPT) $\rightarrow$ Partition $\rightarrow$ Filesystem (`ext4`, `XFS`, `Btrfs`, `tmpfs`) $\rightarrow$ Mount Point $\rightarrow$ Data.
  - [x] Block devices (`/dev/sda`, `/dev/nvme0n1`) vs. Character devices (`/dev/tty`, `/dev/console`).
  - [x] MBR (Legacy BIOS, 2TB limit, 4 primary partitions) vs. GPT (Modern UEFI, multi-TB disks, backup tables).
  - [x] Filesystem characteristics: `ext4` (general-purpose), `XFS` (enterprise RHEL performance), `Btrfs` (snapshots & copy-on-write), `tmpfs` (volatile RAM-backed high-speed storage).
  - [x] Logical Volume Management (LVM): Physical Volumes (`PV`) $\rightarrow$ Volume Groups (`VG`) $\rightarrow$ Logical Volumes (`LV`).
  - [x] Filesystem mounting lifecycle: `mount`, `findmnt`, `df -hT`, `umount`.
  - [x] Persistent mount configuration (`/etc/fstab`): The 6 critical columns (`[Device/UUID]`, `[Mount Point]`, `[FSType]`, `[Options]`, `[Dump]`, `[fsck Order]`).
  - [x] Storage diagnostics: `lsblk -f`, `blkid`, `fdisk -l`, `tune2fs -l`, `xfs_info`, `fsck -n`.
  - [x] Hands-on `tmpfs` RAM disk: mount 100MB to `/mnt/ramdisk`, test read/write, unmount, and verify volatility.
  - [x] Package management lifecycle: search $\rightarrow$ download $\rightarrow$ resolve dependencies $\rightarrow$ install $\rightarrow$ update $\rightarrow$ remove.
  - [x] APT on Debian/Ubuntu (`apt update`, `apt upgrade`, `/etc/apt/sources.list`, `dpkg -l`) vs. DNF/YUM on RHEL (`dnf install`, `yum update`, `rpm -qa`, `rpm -qi`).
  - [x] Source compilation workflow: `./configure` $\rightarrow$ `make` $\rightarrow$ `sudo make install`.

- [x] **Day 203: Week 1 Review & Capstone Project — `fs_auditor.sh` (Linux Day 7)**
  - [x] Synthesize Week 1 into an automated, defensive security scanner: `fs_auditor.sh`.
  - [x] Implement scan 1: World-writable files in `/home` (`find /home -type f -perm -0002`).
  - [x] Implement scan 2: System-wide SUID/SGID binaries (`-perm -4000 -o -perm -2000`) with automatic `[REVIEW REQUIRED]` categorization for non-standard paths.
  - [x] Implement scan 3: Broken/orphaned symbolic links in `/opt`, `/home`, and `/var` (`-xtype l`).
  - [x] Implement scan 4: Extended POSIX ACL discovery across `/home`, `/opt`, and `/var`.
  - [x] Generate live formatted stdout streams and timestamped persistent audit logs in `$HOME/reports/fs_audit_YYYY-MM-DD_HH-MM-SS.txt`.
  - [x] Automate continuous compliance via daily cron scheduling: `0 2 * * * /path/to/fs_auditor.sh`.
  - [x] Author comprehensive project documentation in `fs-auditor/README.md`.
  - [x] Commit and publish the complete auditing suite to GitHub.
