# 🚀 User Onboarding & Security Hardening Suite

An automated, defensive Bash engine designed to provision new Linux team members with least-privilege access, hardened SSH keys, password expiry compliance, and kernel-level `auditd` monitoring.

---

## 📌 Features

- **Automated User & Group Provisioning**: Safe user creation with dedicated home directory (`-m`), standard login shell (`/bin/bash`), and idempotent group memberships (`usermod -aG`).
- **Hardened SSH Key Deployment**: Auto-creates `~/.ssh` with strictly enforced permissions (`700` for `~/.ssh` directory, `600` for `authorized_keys`) owned by the target user.
- **Compliance-Driven Password Aging**: Enforces 90-day password maximum age (`chage -M 90`) and 14-day expiry warning (`chage -W 14`).
- **Kernel-Level Auditd Integration**: Dynamically registers persistent file integrity watch rules (`-w /home/<user> -p wa -k user_home_<user>`) to detect unauthorized modifications.
- **Defensive Sudoers Provisioning**: Grants granular, least-privilege operational permissions verified via `visudo -cf` syntax checking before installation in `/etc/sudoers.d/`.
- **Dry-Run Mode & Persistent Audit Logging**: Full simulation support (`--dry-run`) and append-only activity tracking in `/var/log/onboard_user.log`.

---

## 🏗️ Architecture Workflow

```text
                    onboard_user.sh
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
   User Creation      Group Assignment    SSH Access
        │                  │                  │
        ▼                  ▼                  ▼
   /home/user          developers          authorized_keys (700/600)
                           │
                           ▼
                      Sudo Rules (visudo -cf verified)
                           │
                           ▼
                    Password Policy (90d max, 14d warn)
                           │
                           ▼
                     Auditd Rules (-w /home/<user> -p wa)
                           │
                           ▼
                     Summary & Logs (/var/log/onboard_user.log)
```

---

## 📂 Directory Layout

```text
projects/linux/user-onboarding/
├── onboard_user.sh           # Main provisioning script
├── config/
│   ├── sudoers.template      # Sudo permission template
│   └── audit.rules.template  # Auditd watch template
├── keys/
│   └── alice.pub             # Sample public key
├── examples/
│   └── example-run.txt       # Sample execution transcript
└── README.md                 # Project documentation
```

---

## 🚀 Usage

### Standard Execution (Root / Sudo)
```bash
sudo ./onboard_user.sh <username> <group> <public-key-path>
```

Example:
```bash
sudo ./onboard_user.sh alice developers keys/alice.pub
```

### Dry-Run Mode (Simulation)
```bash
./onboard_user.sh alice developers keys/alice.pub --dry-run
```

---

## 🔍 Verification & Testing

1. **Verify Identity & Supplementary Groups**:
   ```bash
   id alice
   ```
2. **Inspect SSH Permissions**:
   ```bash
   ls -la /home/alice/.ssh
   ```
3. **Check Password Aging Compliance**:
   ```bash
   sudo chage -l alice
   ```
4. **Inspect Auditd Events**:
   ```bash
   sudo ausearch -k user_home_alice
   ```
5. **Verify Sudo Privileges**:
   ```bash
   sudo -l -U alice
   ```
