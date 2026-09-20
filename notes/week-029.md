# Week 29 Technical Notes: Linux Systems, Storage, Security & Defensive Automation

---

## 1. Linux Kernel & Filesystem Hierarchy Standard (FHS)
* **Kernel vs. Distribution:** The Linux kernel manages CPU scheduling, virtual memory, process isolation, device drivers, virtual filesystems, and network stacks. A distribution (Ubuntu, Debian, RHEL, Rocky) packages the kernel with user-space utilities, a package manager, and standard libraries.
* **System Call Boundary:** User commands (`cat`, `ls`) operate in user-space and invoke the kernel via system calls (`open()`, `read()`, `write()`, `fork()`, `execve()`).
* **FHS Standard Structure:**
  * `/` : The root directory of the entire unified filesystem hierarchy.
  * `/etc` : Host-specific system-wide and service configuration files (`/etc/fstab`, `/etc/passwd`, `/etc/hosts`).
  * `/var` : Variable runtime data that changes continuously (`/var/log` for logs, `/var/cache`, `/var/lib`).
  * `/proc` : Virtual pseudo-filesystem generated dynamically in RAM by the kernel. Exposes process metadata (`/proc/<PID>/`), hardware telemetry (`/proc/cpuinfo`, `/proc/meminfo`), and system uptime (`/proc/uptime`).
  * `/sys` : Virtual filesystem providing a structured view of kernel subsystems, hardware devices, and bus drivers.
  * `/dev` : Device node files representing physical/virtual hardware (`/dev/sda`, `/dev/nvme0n1`, `/dev/null`, `/dev/zero`, `/dev/urandom`).
  * `/home` & `/root` : User and superuser home directories.
  * `/usr` : Primary user-space binaries (`/usr/bin`), system admin tools (`/usr/sbin`), and shared libraries (`/usr/lib`).
  * `/tmp` & `/run` : Ephemeral temporary files and runtime daemon state (PIDs, sockets).
  * `/opt` & `/mnt` : Optional third-party software installations and temporary filesystem mount points.
* **7 Linux File Types:**
  1. Regular file (`-`)
  2. Directory (`d`)
  3. Symbolic link (`l`)
  4. Character device (`c` — streams unbuffered bytes, e.g. `/dev/tty`)
  5. Block device (`b` — transfers buffered fixed-size data blocks, e.g. `/dev/sda`)
  6. Socket (`s` — inter-process network/local communication)
  7. Named Pipe / FIFO (`p` — inter-process streaming queues created with `mkfifo`)

---

## 2. Inode Architecture, Links & File Timestamps
* **The Inode Data Structure:** Every filesystem object is represented by an inode storing:
  * File type and permission bits
  * Owner User ID (UID) and Group ID (GID)
  * File byte size
  * Number of hard links referencing this inode
  * File timestamps (`atime`, `mtime`, `ctime`)
  * Pointers to physical storage data blocks
  * **Crucial Rule:** Filenames are **NOT** stored inside inodes; filenames exist exclusively as directory entry mappings pointing to inode numbers.
* **Linux File Timestamps:**
  * **`atime` (Access Time):** When file contents were last read (`cat`, `grep`). Often optimized by the kernel using `relatime` to reduce disk write overhead.
  * **`mtime` (Modify Time):** When file *contents* were last changed or written to.
  * **`ctime` (Change Time):** When file *metadata or status* changed (e.g. `chmod`, `chown`, moving the file). **`ctime` is NOT creation time.**
* **Hard Links (`ln target link`) vs. Symbolic Links (`ln -s target link`):**

| Feature | Hard Link (`ln`) | Symbolic Link (`ln -s`) |
|---|---|---|
| **Inode Number** | Identical (Shares target inode) | Unique (Has its own inode) |
| **Pointers** | Points directly to physical data blocks | Stores target pathname string |
| **Cross-Filesystem?** | ❌ No (Inodes are filesystem-specific) | ✅ Yes |
| **Directory Linking?** | ❌ No (Prevents filesystem loops) | ✅ Yes |
| **Target Deletion** | ✅ Data survives as long as link count $\ge 1$ | ❌ Broken symlink (dangling pointer) |
| **Inspection** | `ls -li` (Shows matching inode & link count) | `ls -l` (Shows `-> target` & `l` type) |

* **Disk Capacity vs. Inode Exhaustion:**
  * `df -h` : Reports remaining physical storage capacity (megabytes/gigabytes).
  * `du -sh <path>` : Reports storage consumed by files and directories under a specific path.
  * `df -i` : Reports remaining **inode allocation table slots**. A filesystem can run out of space ("No space left on device") if millions of zero-byte files exhaust available inodes, even if gigabytes of raw disk space remain free.

---

## 3. The Linux Access Control Matrix (UGO & `umask`)
* **UGO Triad:** Permissions are grouped into three 3-bit sets: **User (Owner)**, **Group**, and **Others**.
* **Permission Math:**
  * Read (`r` = 4), Write (`w` = 2), Execute (`x` = 1)
  * Summing: `7` = `rwx`, `6` = `rw-`, `5` = `r-x`, `4` = `r--`, `0` = `---`
* **File vs. Directory Permissions:**

| Permission | Regular File Meaning | Directory Meaning |
|---|---|---|
| **Read (`r` / 4)** | Read file contents (`cat`, `less`) | List directory entries (`ls`) |
| **Write (`w` / 2)** | Modify/overwrite file contents | Create, delete, or rename files inside directory |
| **Execute (`x` / 1)** | Run file as program/script | Traverse directory (`cd`) and access inner file inodes |

* **`umask` (User Creation Mask):** Subtracts permissions from system defaults (Directories start at `777`, Regular files start at `666`):
  * **`umask 022` (Standard):** Dirs: $777 - 022 = \mathbf{755}$ (`rwxr-xr-x`) \| Files: $666 - 022 = \mathbf{644}$ (`rw-r--r--`).
  * **`umask 027` (Hardened/Isolated):** Dirs: $777 - 027 = \mathbf{750}$ (`rwxr-x---`) \| Files: $666 - 027 = \mathbf{640}$ (`rw-r-----`).
* **Special Permission Bits:**
  * **SUID (`4000` / `u+s`):** Binary runs with the effective privileges of the file owner (e.g., `/usr/bin/passwd` runs as root to write to `/etc/shadow`).
  * **SGID (`2000` / `g+s`):** Binary runs with the file group's GID. When set on a directory (`chmod 2770 /shared`), newly created files automatically inherit the parent directory's group ownership.
  * **Sticky Bit (`1000` / `+t`):** When applied to a world-writable directory (e.g., `chmod 1777 /tmp` $\rightarrow$ `drwxrwxrwt`), only the file owner or root can delete or rename files within it.

---

## 4. Advanced Security: POSIX ACLs, Extended Attributes & SELinux
* **POSIX Access Control Lists (ACLs):**
  * Solves UGO group sprawl by assigning explicit permissions to specific users/groups without altering primary file ownership.
  * Modify: `setfacl -m u:alice:rw- file.txt` \| `setfacl -m g:auditors:r-- file.txt`
  * Default Inheritance: `setfacl -d -m g:devteam:rwx /shared/dir` (guarantees all future child files inherit team access).
  * Auditing: `getfacl file.txt`. Identified in `ls -l` by the trailing `+` sign (e.g. `-rw-rwxr--+`).
* **Extended Filesystem Attributes (`chattr` / `lsattr`):**
  * `+i` (Immutable): Protects files against modification, deletion, renaming, truncation, and symlink creation—even by the `root` superuser (UID 0).
  * `+a` (Append-Only): Restricts writes exclusively to append operations. Ideal for audit logs (`/var/log/audit.log`) to prevent tampering.
* **SELinux (Mandatory Access Control):**
  * Enforces kernel sandboxing based on context labels (`user:role:type:level`).
  * Type Enforcement: A process running with context `httpd_t` can only interact with files labeled `httpd_sys_content_t`. Even if an attacker achieves root within the web server, SELinux prevents reading `shadow_t` or user home files.
  * Operational Modes: `Enforcing` (blocks violations & logs), `Permissive` (logs only), `Disabled`. Commands: `getenforce`, `setenforce 0`, `setenforce 1`.

---

## 5. Storage Stack, LVM & Filesystem Mounts
* **Layered Storage Architecture:**
  $$\text{AWS EBS / NVMe Disk} \longrightarrow \text{Partition Table (GPT)} \longrightarrow \text{Partitions} \longrightarrow \text{Filesystem} \longrightarrow \text{Mount Point}$$
* **Partition Tables:**
  * **MBR (Master Boot Record):** Legacy BIOS-based; max 2TB capacity; limited to 4 primary partitions.
  * **GPT (GUID Partition Table):** Modern UEFI-based; supports multi-exabyte disks; 128+ partitions; redundant backup tables.
* **Linux Filesystems:**
  * `ext4` : Robust general-purpose default for Linux servers.
  * `XFS` : Enterprise high-performance 64-bit filesystem (standard on RHEL/Rocky).
  * `Btrfs` : Advanced copy-on-write (CoW) filesystem supporting snapshots and subvolumes.
  * `tmpfs` : Volatile RAM-backed filesystem for ultra-fast ephemeral data (`mount -t tmpfs -o size=100M tmpfs /mnt/ramdisk`).
* **Logical Volume Management (LVM):**
  $$\text{Physical Volumes (PV: block devices)} \longrightarrow \text{Volume Groups (VG: unified storage pool)} \longrightarrow \text{Logical Volumes (LV: dynamic partitions)}$$
* **Persistent Mounts (`/etc/fstab`):** 6 fields:
  `[Device / UUID]` `[Mount Point]` `[Filesystem Type]` `[Mount Options]` `[Dump (0/1)]` `[fsck Pass (0/1/2)]`

---

## 6. Defensive Bash Scripting & Systems Automation
* **The Production Header:** `#!/usr/bin/env bash` followed by `set -euo pipefail`.
* **Error Trapping:** `trap 'echo "[ERROR] Command failed at line $LINENO" >&2' ERR`.
* **Logging Standards:** Use `>>` to append audit trails to persistent logs; pipe output with `tee` for simultaneous terminal streaming and file recording.
* **Exit Codes:** `$?` captures status (`0` = success, `1-255` = failure). Always validate exit codes after critical operations.
* **Automated Scheduling:** Enforce daily compliance scanning via cron: `0 2 * * * /path/to/script.sh`.
