# 🛡️ Linux Filesystem & Permission Auditor (`fs-auditor`)

> **Automated security auditing utility for Linux filesystems, permissions, SUID binaries, and POSIX ACLs.**

Developed during **Day 203 / 1000** (Linux Mastery: Day 7 / 30) of the **AI Cloud Infrastructure Journey**.

---

## 📌 Purpose

Misconfigured permissions and dangling files are among the most common root causes of privilege escalation and operational outages on Linux servers. 

`fs_auditor.sh` is a non-destructive, defensive security scanner designed to inspect critical filesystem areas, detect dangerous permission states, identify orphaned links, and generate timestamped audit reports for cloud infrastructure administrators.

---

## ✨ Features

* 🔓 **World-Writable File Detection:** Scans user directories (`/home`) for files that can be modified by unauthorized third parties (`-perm -0002`).
* 👑 **SUID & SGID Binary Auditing:** Scans the root filesystem for elevated privilege binaries (`4000` / `2000`) and automatically flags binaries located outside standard system directories (`/usr/bin`, `/sbin`, etc.) for manual security review (`[REVIEW REQUIRED]`).
* 🔗 **Orphaned Symlink Identification:** Detects broken symbolic links under `/opt`, `/home`, and `/var` that point to non-existent targets.
* 📋 **Extended ACL Discovery:** Identifies files carrying extended POSIX Access Control Lists (`+` symbol in `ls -l`) to audit permission drift.
* 📄 **Timestamped Audit Reporting:** Streams live results to stdout while saving formatted reports into `$HOME/reports/fs_audit_YYYY-MM-DD_HH-MM-SS.txt`.
* 🛡️ **Defensive Bash Architecture:** Uses `set -euo pipefail` to ensure predictable execution, robust error trapping, and zero false positives.

---

## 📋 Requirements

* Standard Linux environment (Ubuntu / Debian / RHEL / Rocky / Amazon Linux).
* Standard coreutils (`find`, `grep`, `awk`, `date`, `hostname`).
* POSIX-compliant Bash shell (`bash >= 4.0`).

---

## 🚀 Usage

### 1. Make Executable
```bash
chmod +x fs_auditor.sh
```

### 2. Run the Audit
```bash
./fs_auditor.sh
```

*(Optional: Run with `sudo` for full visibility into root-restricted paths)*:
```bash
sudo ./fs_auditor.sh
```

### 3. View Generated Reports
```bash
ls -l ~/reports/
cat ~/reports/fs_audit_*.txt
```

---

## 🔍 Audit Checks Explained

| Audit Category | Scan Scope | Target Detection | Risk & Security Impact |
|---|---|---|---|
| **World-Writable Files** | `/home` | `-perm -0002` | Unauthorized users modifying scripts, configs, or SSH keys. |
| **SUID / SGID Binaries** | `/` (System-wide) | `-perm -4000` / `-2000` | Local Privilege Escalation (LPE) if unvetted binaries run as root. |
| **Broken Symlinks** | `/opt`, `/home`, `/var` | `-xtype l` | Broken deployments, missing shared libraries, configuration failure. |
| **Extended ACLs** | `/home`, `/opt`, `/var` | `+` ACL tag | Undocumented or overly permissive access bypasses UGO baselines. |

---

## 📊 Example Output

```text
========================================
 Linux Filesystem Security Audit Report
========================================
Date:      Sun Sep 20 16:44:00 IST 2026
Host:      cloud-ec2-node
Kernel:    6.8.0-45-generic
Report:    /home/user/reports/fs_audit_2026-09-20_16-44-00.txt
========================================

========================================
 1. WORLD-WRITABLE FILES (under /home)
========================================
Searching for files writable by 'others' (perm -0002)...

[RISK] /home/user/workspace/debug_config.json

Total world-writable files found: 1

========================================
 2. SUID & SGID BINARIES
========================================
Scanning system for SUID (4000) and SGID (2000) binaries...

[STANDARD] /usr/bin/sudo
[STANDARD] /usr/bin/passwd
[REVIEW REQUIRED] /tmp/custom_installer

Total SUID/SGID binaries found: 32
Non-standard binaries flagged for review: 1

========================================
 3. BROKEN SYMBOLIC LINKS
========================================
Scanning /opt, /home, and /var for orphaned symlinks...

[BROKEN] /opt/models/current_weights.bin

Total broken symlinks found: 1

========================================
 4. FILES WITH EXTENDED ACLs (+)
========================================
Scanning /home, /opt, /var for files with POSIX ACLs...

[ACL DETECTED] /home/user/project/secrets.env

Total files with extended ACLs: 1

========================================
 AUDIT SUMMARY & STATS
========================================
World-Writable Files:     1
Total SUID/SGID Files:    32
Non-Standard SUID/SGID:   1
Broken Symlinks:          1
Extended ACL Files:       1
========================================
Audit completed at: Sun Sep 20 16:44:02 IST 2026
========================================
```

---

## ⏰ Automated Cron Scheduling

To automate daily continuous security compliance, schedule the auditor via `cron`:

```bash
crontab -e
```

Add the following entry to run every morning at 2:00 AM:
```cron
0 2 * * * /home/user/fs-auditor/fs_auditor.sh > /dev/null 2>&1
```

---

## ⚠️ Security Notes

* `fs_auditor.sh` is **strictly passive and non-destructive**. It never modifies, deletes, or alters permissions on any file.
* Flagged items (`[RISK]`, `[REVIEW REQUIRED]`, `[BROKEN]`) should be manually investigated by the security administrator.

---

## 📂 Project Structure

```text
fs-auditor/
├── fs_auditor.sh    # Executable Bash security auditing suite
└── README.md        # Comprehensive technical documentation & usage guide
```

---
*Maintained as part of the 1000-Day AI Cloud Infrastructure Journey.*
