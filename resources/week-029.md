# Week 29 Resources: Linux Systems, Storage, Security & Defensive Automation

---

## 📚 Official Documentation & Manual Pages

### Filesystem & Inodes
- **Filesystem Hierarchy Standard (FHS):** `man hier` / [Linux Foundation FHS 3.0 Specification](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html)
- **Inode Data Structures:** `man inode`, `man stat`, `man ls`
- **Link Management:** `man ln`, `man readlink`
- **Filesystem Querying:** `man find`, `man df`, `man du`, `man file`

### Permissions, Access Controls & Security
- **Discretionary Access Controls (DAC):** `man chmod`, `man chown`, `man chgrp`, `man umask`
- **POSIX Access Control Lists (ACLs):** `man getfacl`, `man setfacl`, `man acl`
- **Extended Attributes:** `man chattr`, `man lsattr`
- **Security-Enhanced Linux (SELinux):** `man selinux`, `man getenforce`, `man setenforce`, `man ls` (using `-Z`), [Red Hat SELinux User's and Administrator's Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/index)
- **Linux Hardening Standards:** [Center for Internet Security (CIS) Linux Benchmarks](https://www.cisecurity.org/benchmark/distribution_independent_linux)

### Storage, Partitions & Mounting
- **Partitioning Tools:** `man fdisk`, `man parted`, `man gdisk`
- **Block Device Inspection:** `man lsblk`, `man blkid`, `man findmnt`
- **Filesystem Tools:** `man mkfs`, `man tune2fs`, `man xfs_info`, `man fsck`
- **Mounting & Persistent Tables:** `man mount`, `man umount`, `man fstab`
- **Logical Volume Management (LVM):** `man lvm`, `man pvcreate`, `man vgcreate`, `man lvcreate`
- **RAM Disks:** `man tmpfs`

### Package Management & Build Toolchains
- **Debian / Ubuntu Package Ecosystem:** `man apt`, `man apt-get`, `man dpkg`, `man sources.list`
- **RHEL / Rocky / Fedora Ecosystem:** `man dnf`, `man yum`, `man rpm`
- **Source Compilation:** `man gcc`, `man make`

---

## 📖 Recommended Books & Deep Dives

1. **The Linux Command Line (TLCL):** by William E. Shotts, Jr.
   - *Key Chapters Covered:* Chapter 1 (What Is The Shell?), Chapter 4 (Operating On Files And Directories), Chapter 7 (Seeing The World As The Shell Sees It), Chapter 9 (Permissions), Chapter 11 (Storage Media).
2. **UNIX and Linux System Administration Handbook (5th Edition):** by Evi Nemeth, Garth Snyder, Trent R. Hein, Ben Whaley, Dan Mackin.
   - *Key Chapters:* Storage Administration, The Filesystem, Access Control & Security Policies.
3. **How Linux Works: What Every Superuser Should Know (3rd Edition):** by Brian Ward.
   - *Key Chapters:* How the Kernel Boots, Devices and Disks, Inode Allocation Tables, and System Calls.

---

## 🛠️ Developed Scripts, Automation Modules & Mini-Projects

All scripts authored during Week 29 follow defensive Bash standards (`set -euo pipefail`):

| Script / Module | Path | Day | Purpose & Features |
|---|---|---|---|
| **`fs_auditor.sh`** | [`fs-auditor/fs_auditor.sh`](../fs-auditor/fs_auditor.sh) | Day 203 | **Week 1 Capstone Security Suite:** Automated auditor scanning for world-writable files, SUID/SGID non-standard binaries, broken symlinks, and POSIX ACLs with timestamped reports and cron scheduling. |
| **`fs-auditor README`** | [`fs-auditor/README.md`](../fs-auditor/README.md) | Day 203 | Comprehensive project documentation, audit check explanations, sample report streams, and compliance guides. |
| **`setup_practice_env.sh`** | `~/linux-mastery/day-02/` | Day 198 | Automated nested directory and file scaffold builder using brace expansions, directory error traps, and audit logs. |
| **`link_auditor.sh`** | `~/linux-mastery/day-03/` | Day 199 | Orphaned symbolic link detector (`find -xtype l`) and hard-link candidate collision reporter (`find -printf '%i %p'`). |
| **`secure_dir_setup.sh`** | `~/linux-mastery/day-04/` | Day 200 | Principle of Least Privilege provisioning script demonstrating `700` private, `750` shared, `640` configs, and `1777` Sticky Bit dropboxes. |
| **`acl_setup.sh`** | `~/linux-mastery/day-05/` | Day 201 | POSIX ACL provisioning engine managing granular user overrides, directory default inheritance (`-d`), and clean ACL revocation. |
