# Week 31 Roadmap

## Day 15 — User & Group Management
- **Linux Mastery:** Day 15 / 30
- **AI Cloud Infrastructure Journey:** Day 211 / 1000
- **Theme:** Lock it down. Authentication and network filtering matter.
- **Focus:** Linux users, groups, UIDs, GIDs, authentication, and account lifecycle
- **Duration:** 2.5–3 hours

### Objective
Build:

```text
bulk_user_setup.sh
```

The script should read a CSV file and automate user creation.

Architecture:

```text
CSV
 │
 ↓
bulk_user_setup.sh
 │
 ├── Validate input
 ├── Check user
 ├── Create user
 ├── Check group
 ├── Create group
 ├── Add user to group
 ├── Configure account
 └── Log actions
```

---

---

## Day 16 — Sudo & Privilege Escalation
- **Linux Mastery:** Day 16 / 30
- **AI Cloud Infrastructure Journey:** Day 212 / 1000
- **Date:** 2026-09-29
- **Theme:** Control who can become root — and exactly what they are allowed to do.
- **Organization:** CloudForge Infrastructure Team

---

## Day 213 / 1000 — SSH Hardening & Key-Based Authentication
- **Linux Mastery:** Day 17 / 30  
- **AI Cloud Infrastructure Journey:** Day 213 / 1000  
- **Date:** 2026-09-30  
- **Duration:** 3 Hours  
- **Focus:** SSH, Key-Based Authentication, SSH Hardening, Bastion Hosts  
- **Theme:** Secure Remote Access

### Objective
Understand how SSH works, how public-key authentication provides secure remote access, and how to harden an SSH server for real-world cloud infrastructure.

By the end of today, I should be able to:

- Explain how SSH authentication works
- Understand password vs public-key authentication
- Generate Ed25519 SSH keys
- Understand private and public keys
- Configure `authorized_keys`
- Configure `~/.ssh/config`
- Harden `/etc/ssh/sshd_config`
- Disable root SSH login
- Disable password authentication
- Configure SSH authentication limits
- Validate SSH configuration safely
- Restart SSH without accidentally locking myself out
- Read SSH authentication logs
- Understand `ssh-agent`
- Understand bastion / jump hosts
- Build a basic SSH hardening automation script

---

---

## Day 18 — Firewalls, UFW & Network Filtering
- **Linux Journey:** Day 18 / 30
- **AI Cloud Infrastructure Journey:** Day 214 / 1000
- **Theme:** 🔥 *“Control who can talk to your server.”*

---

## Day 19 / 30 — File Integrity & Auditd
- **> **Theme:** ** "Don't just secure the system. Know what happened."
- **For example, a Linux server may contain:** ```text
- **If someone modifies them, we want to know:** ```text
- **AIDE stands for:** ```text
- **Conceptually:** ```text
- **Example:** ```text
- **Original hash:** ABC123
- **Current hash:** XYZ789
- **Result:** FILE CHANGED
- **Conceptually:** ```text
- **Instead of only asking:** ```text
- **auditd can answer questions such as:** ```text
- **Think of it like this:** ```text
- **Basic architecture:** ```text
- **The important idea is:** > auditd creates an evidence trail of security-relevant activity.
- **Someone changes:** ```text
- **Without auditing, you might only know:** ```text
- **With auditing, you can potentially investigate:** ```text
- **This makes audit logs useful for:** * Security investigations
- **Conceptually:** ```text
- **Examples include:** ```text
- **For example, when a user runs:** ```bash
- **or:** ```bash
- **An audit rule can monitor execution activity using:** ```bash
- **Break it down:** ```text
- **Give the rule the searchable key:** ```text
- **Later we can search:** ```bash
- **Important options:** ```text
- **Example:** ```bash
- **This means:** ```text
- **Example:** ```bash
- **Where:** ```text
- **Therefore:** ```bash
- **means:** > Monitor `/etc/passwd` for writes and attribute changes.
- **Example:** ```bash
- **Now we can search for events associated with that rule:** ```bash
- **Start auditd:** ```bash
- **Check its status:** ```bash
- **Enable it:** ```bash
- **Add a rule:** ```bash
- **List the rules:** ```bash
- **You should see something similar to:** ```text
- **Consider:** ```bash
- **Breakdown:** ```text
- **Monitor:** ```text
- **For a safe lab, create a test file:** ```bash
- **Add an audit rule:** ```bash
- **Verify:** ```bash
- **Modify the file:** ```bash
- **Now search:** ```bash
- **Audit logs are normally stored under:** ```text
- **Check:** ```bash
- **You may see:** ```text
- **You can inspect the raw log:** ```bash
- **Instead, use:** ```text
- **`ausearch` means:** ```text
- **Search by key:** ```bash
- **Search today's events:** ```bash
- **Search events associated with an executable:** ```bash
- **Search password-related modifications:** ```bash
- **Think:** ```text
- **Run:** ```bash
- **It can provide summaries related to areas such as:** ```text
- **Think:** ```text
- **Example:** ```bash
- **Question:** ```text
- **Example:** ```bash
- **Question:** ```text
- **Therefore:** ```text
- **Some security-sensitive files include:** ```text
- **Contains account information such as:** ```text
- **Example rules for a lab:** ```text
- **Identity:** ```bash
- **Privilege:** ```bash
- **SSH configuration:** ```bash
- **Add an execution-monitoring rule:** ```bash
- **Check:** ```bash
- **Run some commands:** ```bash
- **Now search:** ```bash
- **Conceptually:** ```text
- **Conceptually:** ```text
- **Therefore:** > More logging is not automatically better logging.
- **When you run:** ```bash
- **Audit rules are commonly stored under:** ```text
- **Inspect the directory:** ```bash
- **Inspect existing rules:** ```bash
- **A persistent rules file can contain entries such as:** ```text
- **Check the active configuration:** ```bash
- **Examples include:** ```text
- **The important engineering concept is:** ```text
- **However:** ```text
- **Compliance usually involves multiple controls, including areas such as:** ```text
- **Consider an EC2 instance:** ```text
- **At the AWS level, you may later encounter:** ```text
- **The concepts connect:** ```text
- **The broader infrastructure mindset is:** > Know what happened at every important layer.
- **For Debian/Ubuntu:** ```bash
- **Add:** ```bash
- **Run:** ```bash
- **Search:** ```bash
- **Create:** ```text
- **The script should:** ```text
- **Create:** ```text
- **Example:** ```text
- **Also document:** ```text
- **Check:** ```bash
- **Check:** ```bash
- **Then inspect:** ```bash
- **First verify:** ```bash
- **For example:** ```bash
- **Then:** ```bash
- **Your Linux security journey is now building a clear architecture:** ```text
- **Before marking Day 19 complete, I should be able to explain:** * [ ] What file integrity monitoring means
- **Remember:** ```text
- **Linux Mastery:** Day 19 / 30
- **1000-Day Journey:** Day 215 / 1000
- **Topic:** File Integrity & Auditd
- **Status:** IN PROGRESS → COMPLETE AFTER HANDS-ON + PROJECT
- **Next:** Day 20 / 30

---

## Day 20 — Backups & Disaster Recovery
- **Linux Journey:** Day 20 / 30
- **AI Cloud Infrastructure Journey:** Day 216 / 1000
- **Date:** 2026-10-03
- **Duration:** 3 Hours
- **Theme:** Backups are not real until you can restore from them.
- **Theme:** Build it. Back it up. Break it. Restore it.

### Objective
Learn how Linux backup systems work and build a practical backup and disaster recovery workflow using:

* `tar`
* `rsync`
* Backup verification
* Logging
* Retention policies
* Cron
* Disaster recovery testing
* RPO and RTO concepts
* 3-2-1 backup strategy

---

---

## Day 21 / 30 — Week 3 Review & Integration Project
- **> **Theme:** ** Integrate Linux security, user management, SSH, sudo, auditd, and Bash automation into one realistic infrastructure workflow.
- **Build an automated Linux user onboarding system that securely:** 1. Creates a user account with a home directory
- **Important files:** ```text
- **Create a user:** ```bash
- **Check the user:** ```bash
- **Check the home directory:** ```bash
- **Check `/etc/passwd`:** ```bash
- **Create groups:** ```bash
- **Check groups:** ```bash
- **Add a user to a group:** ```bash
- **Add multiple groups:** ```bash
- **Verify:** ```bash
- **Always remember:** ```bash
- **Important files:** ```text
- **Always validate sudo configuration with:** ```bash
- **Create a restricted sudo rule:** ```text
- **Now members of the `developers` group can run:** ```bash
- **This demonstrates:** > **Principle of Least Privilege**
- **Typical SSH structure:** ```text
- **Create the directory:** ```bash
- **Copy the public key:** ```bash
- **Set ownership:** ```bash
- **sudo chown -R alice:** alice /home/alice/.ssh
- **Set permissions:** ```bash
- **Verify:** ```bash
- **Expected:** ```text
- **Check the current policy:** ```bash
- **Set maximum password age:** ```bash
- **Set warning period:** ```bash
- **Set minimum password age:** ```bash
- **Force password change:** ```bash
- **Example rule:** ```text
- **Meaning:** ```text
- **Search events:** ```bash
- **List active rules:** ```bash
- **Create a central log:** ```text
- **Example logging function:** ```bash
- **Then:** ```bash
- **log "Creating user:** $USERNAME"
- **The script should automate the following:** ```text
- **Create:** ```text
- **Create:** ```bash
- **Start with:** ```bash
- **Run the script with:** ```bash
- **The script should accept:** ```bash
- **Add:** ```bash
- **Arguments:** ```text
- **Check whether the group already exists:** ```bash
- **Verify:** ```bash
- **Verify:** ```bash
- **Define the SSH directory:** ```bash
- **Create it:** ```bash
- **Install the public key:** ```bash
- **Set ownership:** ```bash
- **chown -R "$USERNAME:** $USERNAME" "$SSH_DIR"
- **Set permissions:** ```bash
- **Set a 90-day maximum password age:** ```bash
- **Set a 14-day warning period:** ```bash
- **Verify:** ```bash
- **Generate an audit rule:** ```bash
- **Add the rule:** ```bash
- **Reload:** ```bash
- **Verify:** ```bash
- **Search:** ```bash
- **Create a sudoers file:** ```bash
- **Example rule:** ```bash
- **Set permissions:** ```bash
- **Validate:** ```bash
- **Create:** ```bash
- **Then:** ```bash
- **Username:** $USERNAME
- **Group:** $GROUP
- **Home:** /home/$USERNAME
- **SSH key:** configured
- **Password policy:** configured
- **Audit rules:** configured
- **Sudo rules:** configured
- **View it:** ```bash
- **A production Linux system can use:** ```text
- **Instead, generate the summary file:** ```text
- **Check:** ```bash
- **Expected:** ```text
- **Check:** ```bash
- **Expected approximately:** ```text
- **Verify:** ```text
- **Maximum number of days between password change:** 90
- **Number of days of warning before password expires:** 14
- **Create a test file:** ```bash
- **Search:** ```bash
- **Switch to Alice:** ```bash
- **Test:** ```bash
- **Now try:** ```bash
- **This demonstrates:** > **Least Privilege**
- **You are learning how to combine:** ```text
- **Modify the script to support:** ```bash
- **The user should belong to:** ```text
- **Make sure the script handles:** ```bash
- **If the key doesn't exist:** ```bash
- **Example:** ```text
- **ERROR:** SSH public key not found.
- **Add support for:** ```bash
- **Expected:** ```text
- **Think about this situation:** ```text
- **Should the script:** ```text
- **By the end of Week 3, you should understand:** | Topic       | Commands / Concepts                   |
- **git commit -m "Week 3:** User onboarding and security hardening"
- **Linux Mastery:** Day 21 / 30
- **1000-Day AI Cloud Infrastructure Journey:** Day 217 / 1000
- **The most important transition today is:** ```text

---

