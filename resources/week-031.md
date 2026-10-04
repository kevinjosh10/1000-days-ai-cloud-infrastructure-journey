# Week 31 Resources

## Day 15 — User & Group Management
```text
alice
 ├── UID: 1001
 ├── Primary GID: 1001
 ├── Groups: developers
 ├── Home: /home/alice
 └── Shell: /bin/bash
```
```bash
id
```
```text
uid=1000(kevz) gid=1000(kevz) groups=1000(kevz),27(sudo)
```
```bash
id root
```
```text
uid=0(root) gid=0(root) groups=0(root)
```
```text
UID 0 = root
```
```bash
cat /etc/passwd
```
```text
alice:x:1001:1001:Alice:/home/alice:/bin/bash
```
```text
username:password:UID:GID:GECOS:home:shell
```
```text
alice:x:1001:1001:Alice:/home/alice:/bin/bash
```
```bash
sudo cat /etc/shadow
```
```text
alice:$6$.....:20350:0:99999:14:::
```
```bash
ls -l /etc/shadow
```
```text
/etc/passwd
      ↓
Account identity information

/etc/shadow
      ↓
Authentication + password aging information
```
```text
alice → permission
bob → permission
charlie → permission
```
```text
developers
 ├── alice
 ├── bob
 └── charlie
```
```bash
cat /etc/group
```
```text
developers:x:1002:alice,bob
```
```text
groupname:password:GID:members
```
```text
developers:x:1002:alice,bob
```
```text
Group name → developers
GID        → 1002
Members    → alice, bob
```
```text
uid=1001(alice)
gid=1001(alice)
groups=1001(alice),1002(developers),999(docker)
```
```text
User
 ↓
alice

Primary group
 ↓
alice

Supplementary groups
 ↓
developers
docker
```
```bash
id alice
```
```bash
sudo useradd -m -s /bin/bash alice
```
```text
useradd
   │
   ├── -m
   │    ↓
   │    Create home directory
   │
   └── -s /bin/bash
        ↓
        Set login shell
```
```bash
id alice
```
```bash
ls -la /home/alice
```
```bash
sudo passwd alice
```
```bash
sudo passwd -S alice
```
```bash
sudo groupadd developers
```
```bash
getent group developers
```
```text
developers:x:1002:
```
```bash
sudo usermod -aG developers alice
```
```text
-aG
```
```text
-a → append
-G → supplementary groups
```
```bash
sudo usermod -aG developers alice
```
```bash
sudo usermod -G developers alice
```
```bash
sudo usermod -aG developers alice
```
```text
-aG
```
```bash
usermod -aG group user
```
```bash
id alice
```
```bash
getent group developers
```
```text
developers:x:1002:alice
```
```bash
finger alice
```
```bash
id alice
getent passwd alice
getent group developers
```
```bash
sudo chage -l alice
```
```text
Last password change                                    : Sep 28, 2026
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change         : 0
Maximum number of days between password change         : 99999
Number of days of warning before password expires       : 7
```
```bash
sudo chage -l alice
```
```bash
sudo chage -E 2025-12-31 -W 14 alice
```
```bash
sudo chage -E 2027-12-31 -W 14 alice
```
```bash
sudo chage -l alice
```
```text
Account expires : Dec 31, 2027
```
```text
Number of days of warning before password expires : 14
```
```text
Password expiration
        ≠
Account expiration
```
```bash
cat /etc/passwd
```
```text
root
daemon
bin
sys
www-data
nobody
```
```text
Web Server
     ↓
www-data
     ↓
Limited privileges
```
```text
root
```
```bash
awk -F: '{print $1, $3}' /etc/passwd
```
```text
root 0
daemon 1
bin 2
...
kevz 1000
alice 1001
```
```text
UID 0
 ↓
root

System/service identities
 ↓
Usually lower/system UID ranges

Regular users
 ↓
Usually higher UID ranges
```
```bash
id
```
```bash
id alice
```
```bash
id root
```
```bash
sudo useradd -m -s /bin/bash alice
```
```bash
sudo passwd alice
```
```bash
sudo groupadd developers
```
```bash
sudo usermod -aG developers alice
```
```bash
id alice
```
```bash
getent passwd alice
```
```bash
getent group developers
```
```bash
sudo chage -l alice
```
```text
bulk_user_setup.sh
```
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
```text
day-15/
├── bulk_user_setup.sh
├── users.csv
└── logs/
```
```csv
username,group
alice,developers
bob,developers
charlie,developers
```
```text
Read CSV
   ↓
Validate row
   ↓
Group exists?
   ├── No → Create group
   └── Yes
   ↓
User exists?
   ├── No → Create user
   └── Yes
   ↓
Add user to group
   ↓
Log result
```
```csv
username,password
alice,password123
bob,password456
```
```text
EC2 Linux Server
       │
       ├── ubuntu
       ├── deploy
       ├── monitoring
       │
       └── developers
              ├── developer1
              ├── developer2
              └── developer3
```
```text
/opt/myapp
     │
     ├── Owner: deploy
     ├── Group: developers
     └── Permissions
```
```text
Linux Users
     ↓
Linux Groups
     ↓
File Permissions
     ↓
SSH Authentication
     ↓
sudo
     ↓
Firewall
     ↓
Cloud Security
     ↓
AWS IAM
```
```text
                    LINUX IDENTITY
                         │
             ┌───────────┴───────────┐
             ↓                       ↓
           USER                    GROUP
             │                       │
           UID                     GID
             │                       │
             └───────────┬───────────┘
                         ↓
                    PERMISSIONS
                         │
             ┌───────────┴───────────┐
             ↓                       ↓
        FILE ACCESS             SERVICE ACCESS
                                     │
                                     ↓
                                  SECURITY
```
```bash
cat /etc/passwd
```
```bash
cat /etc/group
```
```bash
sudo cat /etc/shadow
```
```bash
cat /etc/login.defs
```
```text
UID
GID
```
```bash
sudo usermod -aG developers alice
```
```bash
sudo usermod -G developers alice
```
```bash
sudo usermod -aG developers alice
```
```bash
sudo userdel alice
```
```bash
sudo userdel -r alice
```
```bash
sudo usermod -aG developers alice
```
```text
sudo
 ↓
usermod
 ↓
-a
 ↓
-G
 ↓
developers
 ↓
alice
```
```bash
sudo chage -E 2027-12-31 -W 14 alice
```
```text
Who are you?
     ↓
UID

What groups are you in?
     ↓
GID / Supplementary Groups

What can you access?
     ↓
Permissions

How do you authenticate?
     ↓
Password / SSH

What can you administer?
     ↓
sudo / privileges

What network services can you reach?
     ↓
Firewall

What cloud resources can you access?
     ↓
IAM
```
```text
Linux Mastery
Day 15 / 30

[███████████████░░░░░░░░░░░░░░░] 50%
```
```text
AI Cloud Infrastructure Journey
Day 211 / 1000

[██████░░░░░░░░░░░░░░░░░░░░░░░░] 21.1%
```
```text
/etc/passwd  → User identity
/etc/shadow  → Authentication
/etc/group   → Groups
id           → Identity inspection
useradd      → Create users
usermod      → Modify users
groupadd     → Create groups
passwd       → Password management
chage        → Account/password aging
```
```text
Least Privilege
      ↓
Give users and services
only the permissions
they actually need.
```

---

## Day 16 — Sudo & Privilege Escalation
```text
Normal User
     |
     | sudo
     v
Privilege Check
     |
     v
Root Privileges
     |
     v
Specific Command
```
```bash
sudo systemctl restart nginx
```
```bash
rm -rf /
```
```bash
sudo <command>
```
```text
Alice → Developer
Bob → DevOps Engineer
Charlie → Intern
```
```text
root
```
```text
restart nginx
```
```text
/usr/bin/systemctl restart nginx
```
```text
/etc/sudoers
```
```text
/etc/sudoers.d/
```
```text
User
 |
 | sudo
 v
sudo
 |
 v
/etc/sudoers
 |
 +---- /etc/sudoers.d/
 |
 v
Authorization Check
 |
 v
Execute command
 |
 v
Audit Log
```
```bash
sudo cat /etc/sudoers
```
```text
root ALL=(ALL:ALL) ALL
```
```text
%sudo ALL=(ALL:ALL) ALL
```
```text
%wheel ALL=(ALL:ALL) ALL
```
```bash
sudo nano /etc/sudoers
```
```bash
sudo vim /etc/sudoers
```
```bash
sudo visudo
```
```bash
sudo visudo
```
```text
alice ALL=(ALL) ALL
```
```text
alice    ALL    =    (ALL)    ALL
  |       |           |         |
 User   Hosts      Run as    Commands
```
```text
alice
```
```text
ALL
```
```text
(ALL)
```
```text
ALL
```
```text
alice ALL=(ALL) ALL
```
```text
alice ALL=(ALL) ALL
```
```text
%developers ALL=(ALL) /usr/bin/systemctl
```
```text
alice
```
```text
%developers
```
```bash
sudo groupadd developers
```
```bash
sudo useradd -m alice
```
```bash
sudo passwd alice
```
```bash
sudo usermod -aG developers alice
```
```bash
id alice
```
```bash
sudo visudo
```
```text
alice ALL=(ALL) ALL
```
```bash
su - alice
```
```bash
sudo -l
```
```bash
sudo whoami
```
```text
root
```
```bash
sudo -l
```
```text
User alice may run the following commands:

(root) /usr/bin/systemctl restart nginx
```
```text
NOPASSWD:
```
```text
alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```
```text
alice ALL=(ALL) NOPASSWD: ALL
```
```text
/usr/bin/systemctl
```
```text
systemctl
```
```text
alice ALL=(ALL) /usr/bin/systemctl restart nginx
```
```text
%developers ALL=(ALL) /usr/bin/systemctl
```
```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```
```bash
sudo systemctl restart nginx
```
```bash
sudo -i
```
```bash
whoami
```
```text
root
```
```bash
exit
```
```text
sudo -i
   |
   v
Root login-style environment
```
```bash
sudo su -
```
```text
sudo
  |
  v
run su -
  |
  v
root shell
```
```bash
whoami
```
```text
root
```
```bash
exit
```
```bash
sudo -s
```
```text
sudo -i
```
```text
sudo su -
```
```text
sudo -s
```
```text
sudo -i
    |
    +-- Root login-style environment

sudo su -
    |
    +-- su login shell executed through sudo

sudo -s
    |
    +-- Privileged shell using current environment
```
```bash
sudo systemctl restart nginx
```
```bash
sudo grep sudo /var/log/auth.log
```
```bash
sudo journalctl SYSLOG_IDENTIFIER=sudo
```
```bash
sudo journalctl | grep sudo
```
```text
03:15 AM
Production service unavailable
```
```text
03:14:52 alice
sudo systemctl restart nginx
```
```text
/etc/sudoers
```
```text
/etc/sudoers.d/
```
```text
/etc/sudoers.d/
├── developers
├── monitoring
├── deployment
└── backup
```
```bash
sudo visudo -c
```
```text
/etc/sudoers: parsed OK
```
```bash
sudo visudo -cf /etc/sudoers.d/developers
```
```text
Deploy
   |
   v
Modify sudoers
   |
   v
Syntax Error
   |
   v
sudo broken
   |
   v
Administrative access problem
```
```text
Create configuration
       |
       v
Validate with visudo
       |
       v
Backup existing configuration
       |
       v
Install new configuration
       |
       v
Validate again
```
```text
alice ALL=(ALL) NOPASSWD: ALL
```
```text
alice ALL=(ALL) /usr/bin/systemctl
```
```text
/usr/bin/python3
```
```bash
sudo nano /etc/sudoers
```
```bash
sudo visudo
```
```text
ALL
```
```text
/usr/bin/systemctl restart nginx
```
```text
/usr/bin/systemctl
```
```text
sudoers
   |
   v
Who can execute what?
```
```text
IAM
   |
   v
Who can perform what API action?
```
```text
Least Privilege
```
```text
Least Privilege IAM Policies
```
```text
sudo audit logs
```
```text
CloudTrail
```
```text
Identity
   |
   v
Authorization Policy
   |
   v
Allowed Action
   |
   v
Audit
```
```bash
sudo groupadd developers
```
```bash
sudo useradd -m alice
```
```bash
sudo passwd alice
```
```bash
sudo usermod -aG developers alice
```
```bash
id alice
```
```bash
sudo visudo
```
```text
alice ALL=(ALL) ALL
```
```bash
su - alice
```
```bash
sudo -l
```
```bash
sudo whoami
```
```text
root
```
```text
/etc/sudoers.d/developers
```
```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```
```bash
sudo visudo -cf /etc/sudoers.d/developers
```
```bash
sudo visudo -c
```
```bash
su - alice
```
```bash
sudo -l
```
```bash
sudo systemctl restart nginx
```
```bash
sudo systemctl status ssh
```
```text
alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```
```bash
sudo -l -U alice
```
```bash
sudo systemctl restart nginx
```
```bash
sudo journalctl SYSLOG_IDENTIFIER=sudo
```
```bash
sudo grep sudo /var/log/auth.log
```
```text
%developers THIS_IS_INVALID
```
```bash
sudo visudo -cf /etc/sudoers.d/developers
```
```bash
sudo visudo -c
```
```text
parsed OK
```
```text
scripts/apply_sudoers.sh
```
```bash
#!/bin/bash

set -euo pipefail

RULE_FILE="/etc/sudoers.d/developers"
BACKUP_FILE="/etc/sudoers.d/developers.backup"

echo "=== Sudoers Configuration Installer ==="

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "[1/5] Creating backup..."

if [[ -f "$RULE_FILE" ]]; then
    cp "$RULE_FILE" "$BACKUP_FILE"
    echo "Backup created: $BACKUP_FILE"
fi

echo "[2/5] Creating temporary rule..."

TEMP_FILE=$(mktemp)

cat > "$TEMP_FILE" <<EOF
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
EOF

echo "[3/5] Validating sudoers syntax..."

if visudo -cf "$TEMP_FILE"; then
    echo "Syntax validation passed."
else
    echo "ERROR: Invalid sudoers syntax."
    rm -f "$TEMP_FILE"
    exit 1
fi

echo "[4/5] Installing rule..."

cp "$TEMP_FILE" "$RULE_FILE"

chmod 0440 "$RULE_FILE"

rm -f "$TEMP_FILE"

echo "[5/5] Validating final configuration..."

visudo -c

echo
echo "Sudoers configuration successfully applied."
echo "Rule: $RULE_FILE"
```
```bash
chmod +x apply_sudoers.sh
```
```bash
sudo ./apply_sudoers.sh
```
```text
CloudForge
│
├── Developers
│   └── developers
│
├── DevOps
│   └── devops
│
└── Monitoring
    └── monitoring
```
```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```
```text
automation ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```
```text
automation ALL=(ALL) NOPASSWD: ALL
```
```text
/etc/sudoers.d/
```
```bash
visudo -c
```
```bash
visudo -cf /etc/sudoers.d/<file>
```
```text
/etc/sudoers.d/<file>.backup
```
```bash
journalctl SYSLOG_IDENTIFIER=sudo
```
```text
                 SUDO
                  |
       +----------+----------+
       |          |          |
    Identity    Policy     Command
       |          |          |
     alice      sudoers    systemctl
       |          |          |
       +----------+----------+
                  |
             Authorization
                  |
                  v
             Root Action
                  |
                  v
              Audit Log
```
```text
alice ALL=(ALL) ALL
```
```bash
sudo -l
```
```text
alice ALL=(ALL) NOPASSWD: ALL
```
```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```
```text
Linux User
     |
     v
sudoers
     |
     v
Allowed Command
     |
     v
Audit Log
```
```text
AWS Identity
     |
     v
IAM Policy
     |
     v
Allowed API Action
     |
     v
CloudTrail
```
```text
IDENTITY
   ↓
AUTHORIZATION
   ↓
LEAST PRIVILEGE
   ↓
ACTION
   ↓
AUDIT
```
```text
Linux Mastery

Day 16 / 30
████████████████░░░░░░░░░░░░ 53.3%
```
```text
AI Cloud Infrastructure Journey

Day 212 / 1000
█████░░░░░░░░░░░░░░░░░░░░░░░ 21.2%
```
```text
WHO
 ↓
CAN DO WHAT
 ↓
ON WHICH SYSTEM
 ↓
UNDER WHICH CONDITIONS
 ↓
AND WHERE IS IT LOGGED?
```

---

## Day 213 / 1000 — SSH Hardening & Key-Based Authentication
```bash
ssh user@server-ip
```
```bash
ssh alice@192.168.1.100
```
```bash
ssh
```
```text
~/.ssh/config
```
```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```
```text
sshd
```
```text
/etc/ssh/sshd_config
```
```bash
sudo systemctl status ssh
```
```bash
sudo systemctl status sshd
```
```bash
ssh alice@192.168.1.100
```
```text
Client
   |
   | Connect
   ↓
SSH Server
   |
   | Negotiate encryption
   ↓
Authentication
   |
   | Verify identity
   ↓
Authenticated Session
   |
   ↓
Encrypted Shell
```
```bash
ssh alice@192.168.1.100
```
```text
alice@192.168.1.100's password:
```
```text
Private Key
     +
Public Key
```
```text
id_ed25519
id_ed25519.pub
```
```text
Client                         Server

Private Key                    Public Key
id_ed25519                     authorized_keys
     |                               |
     |---- proves identity --------->|
     |                               |
     |<------ authentication -------|
```
```text
~/.ssh/id_ed25519
```
```text
id_ed25519
```
```text
~/.ssh/id_ed25519.pub
```
```text
~/.ssh/authorized_keys
```
```bash
ssh-keygen -t rsa
```
```bash
ssh-keygen -t ecdsa
```
```bash
ssh-keygen -t ed25519
```
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@host"
```
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "kev@laptop"
```
```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```
```bash
ls -la ~/.ssh
```
```bash
chmod 700 ~/.ssh
```
```bash
chmod 600 ~/.ssh/id_ed25519
```
```bash
chmod 644 ~/.ssh/id_ed25519.pub
```
```bash
ls -la ~/.ssh
```
```text
drwx------ ~/.ssh
-rw------- id_ed25519
-rw-r--r-- id_ed25519.pub
```
```text
~/.ssh/authorized_keys
```
```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... user@host
```
```text
authorized_keys
│
├── Kevin's public key
├── Alice's public key
└── CI/CD server public key
```
```bash
ssh-copy-id -i ~/.ssh/id_ed25519 user@host
```
```bash
ssh-copy-id -i ~/.ssh/id_ed25519 alice@192.168.1.100
```
```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```
```bash
cat ~/.ssh/id_ed25519.pub
```
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```
```bash
nano ~/.ssh/authorized_keys
```
```bash
chmod 600 ~/.ssh/authorized_keys
```
```bash
ssh -i ~/.ssh/id_ed25519 user@host
```
```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```
```bash
ssh -v -i ~/.ssh/id_ed25519 alice@192.168.1.100
```
```bash
ssh -vvv alice@192.168.1.100
```
```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```
```text
~/.ssh/config
```
```sshconfig
Host myserver
    HostName 192.168.1.100
    User alice
    IdentityFile ~/.ssh/id_ed25519
```
```bash
ssh myserver
```
```text
Host:
myserver

HostName:
192.168.1.100

User:
alice

IdentityFile:
~/.ssh/id_ed25519
```
```sshconfig
Host production
    HostName 10.0.2.15
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
```
```bash
ssh production
```
```text
/etc/ssh/sshd_config
```
```bash
sudo nano /etc/ssh/sshd_config
```
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```
```text
PermitRootLogin no
```
```text
SSH
 ↓
Normal User
 ↓
sudo
 ↓
Root Privileges
```
```text
PasswordAuthentication no
```
```text
Password Login      ❌
Public Key Login    ✅
```
```text
PubkeyAuthentication yes
```
```text
22
```
```text
Port 2222
```
```bash
ssh -p 2222 user@host
```
```bash
ssh -p 2222 alice@192.168.1.100
```
```text
MaxAuthTries 3
```
```text
Attempt 1 → Failed
Attempt 2 → Failed
Attempt 3 → Failed
Connection terminated
```
```text
MaxSessions 5
```
```text
MaxAuthTries
    ↓
Authentication attempts

MaxSessions
    ↓
Sessions per connection
```
```text
Port 2222

PermitRootLogin no

PubkeyAuthentication yes

PasswordAuthentication no

MaxAuthTries 3

MaxSessions 5
```
```bash
sudo sshd -t
```
```bash
echo $?
```
```text
0
```
```text
Edit configuration
       ↓
Restart SSH
       ↓
Configuration error
       ↓
SSH access may be lost
```
```text
Edit configuration
       ↓
Backup configuration
       ↓
Validate with sshd -t
       ↓
Restart SSH
       ↓
Test new connection
```
```bash
sudo systemctl restart ssh
```
```bash
sudo systemctl restart sshd
```
```bash
sudo systemctl status ssh
```
```bash
sudo systemctl status sshd
```
```text
Existing SSH Session
        |
        +---- Keep this open
        |
        +---- Open another terminal
                    |
                    ↓
             Test new SSH connection
```
```bash
ssh -p 2222 user@host
```
```text
Port 2222
```
```bash
ssh -p 2222 user@host
```
```bash
ssh -p 2222 alice@192.168.1.100
```
```bash
journalctl -u ssh
```
```bash
journalctl -u ssh -f
```
```bash
sudo tail -f /var/log/auth.log
```
```text
Accepted publickey for alice
```
```text
Failed password for alice
```
```text
Failed publickey for alice
```
```bash
eval "$(ssh-agent -s)"
```
```bash
ssh-add ~/.ssh/id_ed25519
```
```bash
ssh-add -l
```
```bash
ssh-add -d ~/.ssh/id_ed25519
```
```bash
ssh-add -D
```
```text
Private Key
     ↓
ssh-agent
     ↓
SSH Connections
```
```text
Internet
    |
    ↓
Bastion Host
    |
    ↓
Private Server
```
```text
Internet
    |
    ↓
Bastion
10.0.1.10
    |
    ↓
Application Server
10.0.2.20
```
```sshconfig
ProxyJump
```
```sshconfig
Host bastion
    HostName 203.0.113.10
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519

Host private-server
    HostName 10.0.2.20
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
    ProxyJump bastion
```
```bash
ssh private-server
```
```text
Laptop
   ↓
Bastion
   ↓
Private Server
```
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@host"
```
```bash
ls -la ~/.ssh
```
```text
id_ed25519
id_ed25519.pub
```
```bash
ssh-copy-id -i ~/.ssh/id_ed25519 user@host
```
```bash
ssh -i ~/.ssh/id_ed25519 user@host
```
```bash
nano ~/.ssh/config
```
```sshconfig
Host myserver
    HostName 192.168.1.100
    User alice
    IdentityFile ~/.ssh/id_ed25519
```
```bash
ssh myserver
```
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```
```bash
ls -l /etc/ssh/sshd_config*
```
```bash
sudo nano /etc/ssh/sshd_config
```
```text
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222
MaxAuthTries 3
MaxSessions 5
```
```bash
sudo sshd -t
```
```bash
echo $?
```
```text
0
```
```bash
sudo systemctl restart ssh
```
```bash
sudo systemctl status ssh
```
```bash
ssh -p 2222 alice@192.168.1.100
```
```text
Key authentication → Works
Password authentication → Disabled
Root SSH login → Disabled
```
```bash
sudo journalctl -u ssh -n 50
```
```bash
sudo tail -n 50 /var/log/auth.log
```
```text
Script
  |
  ↓
Check privileges
  |
  ↓
Backup sshd_config
  |
  ↓
Apply hardening
  |
  ↓
sshd -t
  |
  ├── FAIL → Restore backup
  |
  └── PASS
        |
        ↓
Restart SSH
        |
        ↓
Check status
        |
        ↓
Print result
```
```bash
modify_config
systemctl restart ssh
```
```bash
modify_config

if sshd -t; then
    systemctl restart ssh
else
    echo "Invalid SSH configuration"
    restore_backup
fi
```
```text
Laptop
   |
   ↓
SSH
   |
   ↓
Bastion Host
   |
   ↓
Private EC2
   |
   ↓
Docker
   |
   ↓
Kubernetes
```
```text
SSH
 ↓
IAM
 ↓
SSM
 ↓
Centralized Access
 ↓
Zero Trust
```
```bash
ssh user@host
```
```bash
ssh-keygen -t ed25519
```
```bash
ssh-copy-id user@host
```
```bash
ssh -i ~/.ssh/id_ed25519 user@host
```
```bash
ssh -p 2222 user@host
```
```bash
ssh -v user@host
```
```bash
ssh -vvv user@host
```
```bash
ssh-add ~/.ssh/id_ed25519
```
```bash
sudo sshd -t
```
```bash
sudo systemctl restart ssh
```
```bash
sudo systemctl status ssh
```
```bash
journalctl -u ssh
```
```text
Client
│
├── ~/.ssh/
│   ├── config
│   ├── id_ed25519
│   └── id_ed25519.pub
│
Server
│
├── /etc/ssh/sshd_config
└── ~/.ssh/authorized_keys
```
```text
Client
  |
  | Private Key
  ↓
SSH Authentication
  |
  ↓
Server
  |
  | Checks Public Key
  ↓
authorized_keys
  |
  ↓
Authentication Successful
  |
  ↓
Encrypted Session
```
```text
Disable Root Login
        +
Disable Password Authentication
        +
Use Public-Key Authentication
        +
Use Ed25519
        +
Limit Authentication Attempts
        +
Restrict Network Access
        +
Monitor Authentication Logs
        +
Use Bastion / Jump Hosts
        =
Stronger SSH Security
```
```text
id_ed25519
```
```text
id_ed25519.pub
```
```text
PasswordAuthentication no
```
```bash
sudo sshd -t
```
```bash
sudo systemctl restart ssh
```
```text
MaxAuthTries
```
```text
MaxSessions
```
```text
~/.ssh/config
```
```text
Private Key = Secret
Public Key  = Can be distributed
```
```text
PermitRootLogin no
```
```text
PasswordAuthentication no
```
```bash
sudo sshd -t
```
```bash
journalctl -u ssh
```
```text
SSH Key
   ↓
Public-Key Authentication
   ↓
No Direct Root Login
   ↓
Reduced Password Exposure
   ↓
Authentication Limits
   ↓
Logging
   ↓
Controlled Network Access
   ↓
Secure Remote Administration
```
```text
Linux Mastery
Day 17 / 30

█████████████████░░░░░░░░░░░░░ 56.7%
```
```text
AI Cloud Infrastructure Journey
Day 213 / 1000

█████████████████████░░░░░░░░░ 21.3%
```

---

## Day 18 — Firewalls, UFW & Network Filtering
```text
22    → SSH
80    → HTTP
443   → HTTPS
3306  → MySQL
8080  → Application
```
```text
Internet
   │
   ├──→ 22
   ├──→ 80
   ├──→ 443
   ├──→ 3306
   └──→ 8080
```
```text
Internet
   │
   ├──→ 22    ✅ Allowed
   ├──→ 80    ✅ Allowed
   ├──→ 443   ✅ Allowed
   ├──→ 3306  ❌ Blocked
   └──→ 8080  ❌ Blocked
```
```text
Packet → Source IP → Destination IP → Port → Protocol
```
```text
Client → Server
```
```text
Server → Client
```
```text
Client
  │
  │ TCP SYN
  ▼
Server
  │
  │ TCP SYN-ACK
  ▼
Client
```
```text
Network Interface
       │
       ▼
    Linux
       │
       ▼
   Netfilter
       │
       ├── Accept
       ├── Drop
       └── Reject
```
```text
iptables
nftables
UFW
```
```bash
iptables
```
```bash
sudo iptables -L
```
```text
iptables
   ↓
Powerful
   ↓
Complex
```
```bash
sudo ufw allow 22/tcp
```
```text
UFW
 ↓
Simpler firewall management
 ↓
Linux firewall infrastructure
```
```bash
sudo ufw status
```
```text
Status: inactive
```
```text
Status: active
```
```bash
sudo ufw status verbose
```
```text
Status: active

Logging: on
Default: deny (incoming), allow (outgoing)
```
```text
Your Laptop
     │
     │ SSH
     ▼
  Server
```
```bash
sudo ufw default deny incoming
sudo ufw enable
```
```bash
sudo ufw allow 22/tcp
```
```bash
sudo ufw enable
```
```text
1. Connect through SSH
        ↓
2. Allow SSH
        ↓
3. Configure firewall
        ↓
4. Enable firewall
        ↓
5. Verify SSH still works
```
```bash
sudo ufw default deny incoming
```
```bash
sudo ufw default allow outgoing
```
```text
                    SERVER
                      │
             ┌────────┴────────┐
             │                 │
         Incoming           Outgoing
             │                 │
          DENY             ALLOW
       by default         by default
```
```text
TCP 22
```
```bash
sudo ufw allow 22/tcp
```
```bash
sudo ufw allow 'OpenSSH'
```
```bash
sudo ufw app list
```
```text
Available applications:

  OpenSSH
  Nginx Full
  Apache
```
```text
TCP 80
```
```bash
sudo ufw allow 80/tcp
```
```text
Internet
   │
   ▼
Port 80
   │
   ▼
Web Server
```
```text
TCP 443
```
```bash
sudo ufw allow 443/tcp
```
```text
22   → SSH
80   → HTTP
443  → HTTPS
```
```bash
sudo ufw allow 1:65535/tcp
```
```text
Required services only
        ↓
Explicitly allow them
        ↓
Everything else
        ↓
Blocked
```
```text
192.168.1.50
```
```bash
sudo ufw deny from 192.168.1.50
```
```text
192.168.1.50
      │
      ▼
   FIREWALL
      │
      X
    DENIED
```
```bash
sudo ufw allow from 192.168.1.100 to any port 22 proto tcp
```
```bash
sudo ufw allow 22/tcp
```
```bash
sudo ufw limit 22/tcp
```
```text
Normal SSH usage
       ↓
     Allow

Rapid repeated connections
       ↓
     Limit
```
```bash
sudo ufw status
```
```bash
sudo ufw status verbose
```
```bash
sudo ufw status numbered
```
```text
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW       Anywhere
[ 2] 80/tcp                     ALLOW       Anywhere
[ 3] 443/tcp                    ALLOW       Anywhere
```
```bash
sudo ufw allow 8080/tcp
```
```bash
sudo ufw delete allow 8080/tcp
```
```bash
sudo ufw status numbered
```
```bash
sudo ufw delete 3
```
```bash
sudo ufw logging on
```
```bash
sudo ufw status verbose
```
```text
Logging: on
```
```bash
/var/log/ufw.log
```
```bash
sudo tail /var/log/ufw.log
```
```bash
sudo tail -f /var/log/ufw.log
```
```text
SRC=192.168.1.50
DST=192.168.1.10
PROTO=TCP
SPT=...
DPT=22
```
```text
SRC=203.0.113.50
DST=10.0.0.10
PROTO=TCP
DPT=22
```
```text
SRC
 ↓
Source IP

DST
 ↓
Destination IP

PROTO
 ↓
Protocol

DPT
 ↓
Destination port
```
```text
203.0.113.50
      │
      │ TCP → port 22
      ▼
10.0.0.10
```
```bash
sudo ufw allow 443/tcp
```
```bash
sudo ufw allow 53/udp
```
```text
SYN
 ↓
SYN-ACK
 ↓
ACK
 ↓
DATA
```
```text
Packet
  ↓
Send
```
```text
443
```
```text
443
 ↓
HTTPS service
```
```text
22
 ↓
SSH
```
```text
SSH → 2222
```
```bash
sudo ufw status verbose
```
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
```bash
sudo ufw allow 22/tcp
```
```bash
sudo ufw allow 80/tcp
```
```bash
sudo ufw allow 443/tcp
```
```bash
sudo ufw enable
```
```bash
sudo ufw status verbose
```
```text
Status: active

Default:
deny incoming
allow outgoing

22/tcp   ALLOW
80/tcp   ALLOW
443/tcp  ALLOW
```
```text
                    INTERNET
                       │
                       ▼
                ┌─────────────┐
                │ Web Server  │
                └─────────────┘
                  │    │    │
                 22   80   443
```
```text
22  → SSH
80  → HTTP
443 → HTTPS
```
```text
3306 → MySQL
6379 → Redis
8080 → Internal API
```
```text
                 INTERNET
                    │
              ┌─────┴─────┐
              │           │
             80          443
              │           │
              └─────┬─────┘
                    ▼
                WEB SERVER
                    │
             Internal network
               │          │
              3306       6379
               │          │
              DB         Redis
```
```text
UFW
 ↓
Host-level firewall
```
```text
Security Group
 ↓
Instance/network interface-level filtering
```
```text
Network ACL
 ↓
Subnet-level filtering
```
```text
Internet
   │
   ▼
AWS Network
   │
   ▼
Security Group
   │
   ▼
EC2
   │
   ▼
UFW
   │
   ▼
Application
```
```text
                 INTERNET
                     │
                     ▼
              ┌─────────────┐
              │     WAF     │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │     NACL    │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │   Security  │
              │    Group    │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │     UFW     │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │ Application │
              └─────────────┘
```
```bash
nano basic_firewall.sh
```
```bash
#!/bin/bash

set -e

echo "======================================"
echo "       Basic UFW Firewall Setup"
echo "======================================"

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "[1/6] Setting default policies..."

ufw default deny incoming
ufw default allow outgoing

echo "[2/6] Allowing SSH..."

ufw allow 22/tcp

echo "[3/6] Allowing HTTP..."

ufw allow 80/tcp

echo "[4/6] Allowing HTTPS..."

ufw allow 443/tcp

echo "[5/6] Enabling UFW..."

ufw --force enable

echo "[6/6] Firewall status..."

ufw status verbose

echo
echo "Firewall configuration complete."
```
```bash
chmod +x basic_firewall.sh
```
```bash
sudo ./basic_firewall.sh
```
```bash
set -e
```
```bash
if [[ $EUID -ne 0 ]]; then
```
```text
Normal user
    ↓
Script
    ↓
Check privileges
    ↓
Not root?
    ↓
Exit
```
```bash
SSH_PORT=22
HTTP_PORT=80
HTTPS_PORT=443
APP_PORT=8080
```
```bash
ufw allow "$SSH_PORT"/tcp
ufw allow "$HTTP_PORT"/tcp
ufw allow "$HTTPS_PORT"/tcp
```
```text
Terraform
Ansible
Kubernetes
CI/CD
Cloud automation
```
```text
Rule 1
SSH
TCP 22
Restricted administrative access

Rule 2
HTTP
TCP 80
Public web traffic

Rule 3
HTTPS
TCP 443
Public encrypted web traffic

Rule 4
Database
TCP 3306
NOT publicly accessible

Rule 5
Redis
TCP 6379
NOT publicly accessible

Rule 6
Unknown inbound traffic
DENY
```
```text
Explicitly needed
      ↓
ALLOW

Everything else
      ↓
DENY
```
```bash
sudo ufw status verbose
```
```bash
sudo ufw app list
```
```text
Incoming → DENY
Outgoing → ALLOW
```
```text
SSH
HTTP
HTTPS
```
```bash
sudo ufw logging on
```
```bash
sudo ufw status numbered
```
```bash
sudo ufw allow 8080/tcp
```
```bash
sudo ufw delete allow 8080/tcp
```
```bash
sudo ufw limit 22/tcp
```
```bash
sudo ufw default deny incoming
```
```bash
ufw allow 22/tcp
```
```bash
ufw limit 22/tcp
```
```bash
ufw allow 22
ufw allow 80
ufw allow 443
```
```text
                    NETWORK
                       │
                       ▼
              Who is connecting?
                       │
                       ▼
                Which protocol?
                       │
                       ▼
                  Which port?
                       │
                       ▼
              Should it be allowed?
                       │
              ┌────────┴────────┐
              ▼                 ▼
            ALLOW              DENY
```
```text
             Default DENY
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
       SSH       HTTP      HTTPS
        │         │         │
      ALLOW     ALLOW      ALLOW
```
```text
Day 18/
│
├── basic_firewall.sh
│
└── firewall-rules-for-production.md
```
```text
Day 214 / 1000
Linux Day 18 / 30

Topic:
Firewalls, UFW & Network Filtering

Learned:
- Stateful vs stateless firewalls
- Netfilter
- iptables
- UFW
- Default-deny policies
- Allow/deny rules
- SSH protection
- Rate limiting
- Firewall logging
- Rule inspection
- Defense in depth
- Relationship between UFW and AWS Security Groups
```

---

## Day 19 / 30 — File Integrity & Auditd
```text
/etc/passwd
/etc/shadow
/etc/group
/etc/sudoers
/etc/ssh/sshd_config
```
```text
WHO changed it?
WHEN did they change it?
WHAT happened?
WHICH process performed the action?
```
```text
Advanced Intrusion Detection Environment
```
```text
Original system
      ↓
Create baseline
      ↓
Store file metadata/hashes
      ↓
Later scan
      ↓
Compare against baseline
      ↓
Detect changes
```
```text
/etc/ssh/sshd_config

Original hash:
ABC123

Current hash:
XYZ789

Result:
FILE CHANGED
```
```text
Baseline
   ↓
File metadata
   ↓
Hashes
   ↓
Periodic comparison
   ↓
Detect modifications
```
```text
"Did this file change?"
```
```text
What activity happened?
Which user performed it?
Which process was involved?
When did it happen?
Which system call occurred?
```
```text
AIDE
  ↓
"Is this file different?"

Tripwire
  ↓
"Is this file different?"

auditd
  ↓
"What happened on the system?"
```
```text
User
  ↓
Application / Shell
  ↓
System Call
  ↓
Linux Kernel
  ↓
Audit Subsystem
  ↓
auditd
  ↓
/var/log/audit/
  ↓
ausearch / aureport
```
```text
/etc/ssh/sshd_config
```
```text
The configuration changed.
```
```text
When?
Who?
Which UID?
Which process?
What operation?
What executable?
```
```text
Application
     │
     │ system call
     ▼
Linux Kernel
```
```text
read()
write()
open()
execve()
fork()
clone()
unlink()
chmod()
chown()
```
```bash
whoami
```
```bash
ls
```
```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```
```text
-a always,exit
```
```text
-F arch=b64
```
```text
-S execve
```
```text
-k exec
```
```text
exec
```
```bash
sudo ausearch -k exec
```
```text
-w
-p
-k
```
```bash
-w /etc/passwd
```
```text
Watch /etc/passwd
```
```bash
-p wa
```
```text
w = write
a = attribute change
```
```bash
-w /etc/passwd -p wa
```
```bash
-k passwd_modifications
```
```bash
sudo ausearch -k passwd_modifications
```
```bash
sudo systemctl start auditd
```
```bash
sudo systemctl status auditd
```
```bash
sudo systemctl enable auditd
```
```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_modifications
```
```bash
sudo auditctl -l
```
```text
-w /etc/passwd -p wa -k passwd_modifications
```
```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_modifications
```
```text
sudo
```
```text
auditctl
```
```text
-w /etc/passwd
```
```text
-p wa
```
```text
w = write
a = attribute change
```
```text
-k passwd_modifications
```
```bash
sudo touch /tmp/audit-demo
```
```bash
sudo auditctl -w /tmp/audit-demo -p wa -k audit_demo
```
```bash
sudo auditctl -l
```
```bash
echo "Day 215 audit test" | sudo tee -a /tmp/audit-demo
```
```bash
sudo ausearch -k audit_demo
```
```text
/var/log/audit/
```
```bash
sudo ls -lah /var/log/audit/
```
```text
audit.log
```
```bash
sudo less /var/log/audit/audit.log
```
```text
ausearch
aureport
```
```text
Audit Search
```
```bash
sudo ausearch -k audit_demo
```
```bash
sudo ausearch -ts today
```
```bash
sudo ausearch -x /usr/bin/sudo
```
```bash
sudo ausearch -k passwd_modifications
```
```text
audit.log
    ↓
 ausearch
    ↓
Specific events
```
```bash
sudo aureport
```
```text
Authentication
Login activity
Executable activity
File activity
User authentication
System activity
```
```text
ausearch
    ↓
Investigate specific events

aureport
    ↓
Generate summaries
```
```bash
sudo auditctl -w /etc/passwd -p wa -k identity
```
```text
"What happened to this file?"
```
```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```
```text
"What happened when this system call was executed?"
```
```text
File rule
    ↓
WHAT FILE?

System-call rule
    ↓
WHAT KERNEL OPERATION?
```
```text
/etc/passwd
/etc/group
/etc/shadow
/etc/sudoers
/etc/ssh/sshd_config
```
```text
username
UID
GID
home directory
login shell
```
```text
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k privilege
-w /etc/ssh/sshd_config -p wa -k ssh_config
```
```bash
sudo ausearch -k identity
```
```bash
sudo ausearch -k privilege
```
```bash
sudo ausearch -k ssh_config
```
```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```
```bash
sudo auditctl -l
```
```bash
whoami
```
```bash
id
```
```bash
ls
```
```bash
sudo ausearch -k exec
```
```text
Command
   ↓
Process execution
   ↓
System call
   ↓
auditd
   ↓
Audit event
```
```text
More audit rules
      ↓
More events
      ↓
More log volume
      ↓
More storage
      ↓
More processing
```
```bash
sudo auditctl -w /etc/passwd -p wa -k identity
```
```text
/etc/audit/rules.d/
```
```bash
sudo ls -la /etc/audit/rules.d/
```
```bash
sudo cat /etc/audit/rules.d/*.rules
```
```text
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k privilege
-w /etc/ssh/sshd_config -p wa -k ssh_config
```
```bash
sudo auditctl -l
```
```text
PCI DSS
HIPAA
SOC 2
ISO 27001
```
```text
Who accessed the system?
When?
What changed?
What privileged action occurred?
Can we investigate it later?
```
```text
auditd installed
     ≠
automatically compliant
```
```text
Access control
Logging
Monitoring
Retention
Incident response
Documentation
Configuration management
```
```text
EC2
 │
 ├── Users
 ├── sudo
 ├── SSH
 ├── UFW / firewall
 ├── auditd
 └── application processes
```
```text
IAM
CloudTrail
CloudWatch
VPC Flow Logs
GuardDuty
```
```text
Linux auditd
      ↓
Host-level activity

CloudTrail
      ↓
AWS API activity

VPC Flow Logs
      ↓
Network flow activity

CloudWatch
      ↓
Metrics / logs / monitoring
```
```bash
cat /etc/os-release
```
```bash
auditctl -v
```
```bash
sudo apt update
sudo apt install auditd audispd-plugins
```
```bash
sudo systemctl status auditd
```
```bash
sudo systemctl start auditd
```
```bash
sudo systemctl enable auditd
```
```bash
sudo touch /tmp/audit-demo
```
```bash
sudo auditctl -w /tmp/audit-demo -p wa -k audit_demo
```
```bash
sudo auditctl -l
```
```bash
echo "Day 215 audit test" | sudo tee -a /tmp/audit-demo
```
```bash
sudo ausearch -k audit_demo
```
```bash
sudo aureport
```
```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```
```bash
whoami
```
```bash
id
```
```bash
ls
```
```bash
sudo ausearch -k exec
```
```text
Audit Rules Deployment
```
```text
deploy_audit_rules.sh
```
```text
1. Check root privileges
2. Check whether auditd is installed
3. Check auditd status
4. Create/verify the audit rules directory
5. Configure security-sensitive audit rules
6. Load or validate the rules
7. Display the active rules
8. Print a useful completion message
```
```text
day-215-auditd/
│
├── deploy_audit_rules.sh
│
├── README.md
│
└── notes/
    └── what-we-are-auditing-and-why.md
```
```text
notes/what-we-are-auditing-and-why.md
```
```text
/etc/passwd
→ Monitor account-related changes.

/etc/group
→ Monitor group configuration changes.

/etc/shadow
→ Monitor sensitive authentication database changes.

/etc/sudoers
→ Monitor privilege configuration changes.

/etc/ssh/sshd_config
→ Monitor SSH server configuration changes.
```
```text
Why the event matters
What key is used
How to search for it
How the event can be investigated
```
```bash
which auditctl
```
```bash
sudo systemctl status auditd
```
```bash
sudo journalctl -u auditd
```
```bash
sudo auditctl -l
```
```bash
echo "test" | sudo tee -a /tmp/audit-demo
```
```bash
sudo ausearch -k audit_demo
```
```text
System activity
     ↓
auditd
     ↓
Audit records
```
```bash
sudo auditctl -l
```
```bash
sudo ausearch -k identity
```
```bash
sudo aureport
```
```text
-w /etc/passwd
```
```text
-p wa
```
```text
-k identity
```
```text
DAY 15
Users & Groups
      ↓
WHO are you?

DAY 16
sudo
      ↓
WHAT privileges can you obtain?

DAY 17
SSH
      ↓
HOW do you authenticate remotely?

DAY 18
UFW
      ↓
WHO can connect?

DAY 19
auditd
      ↓
WHAT DID THEY DO?
```
```text
                    LINUX SERVER
                         │
        ┌────────────────┼────────────────┐
        │                │                │
      Users             SSH             Files
        │                │                │
        └────────────────┼────────────────┘
                         │
                         ▼
                   System Calls
                         │
                         ▼
                    Linux Kernel
                         │
                         ▼
                      auditd
                         │
                         ▼
                  /var/log/audit/
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
          ausearch               aureport
              │                     │
              ▼                     ▼
       Investigation            Summary
```
```text
Linux Mastery:
Day 19 / 30

1000-Day Journey:
Day 215 / 1000

Topic:
File Integrity & Auditd

Status:
IN PROGRESS → COMPLETE AFTER HANDS-ON + PROJECT

Next:
Day 20 / 30
Linux Logging, Logrotate & Centralized Logging
```
```bash
man auditctl
man ausearch
man aureport
man auditd
man auditd.conf
```
```text
/etc/audit/
/etc/audit/rules.d/
/var/log/audit/
```
```bash
sudo auditctl -l
sudo ausearch -k <key>
sudo aureport
sudo systemctl status auditd
sudo journalctl -u auditd
```

---

## Day 20 — Backups & Disaster Recovery
```text
Monday:
A B C D

Tuesday:
A B C D E

Wednesday:
A B C D E F
```
```text
Monday:
FULL → A B C D

Tuesday:
INCREMENTAL → E

Wednesday:
INCREMENTAL → F
```
```text
Monday FULL
+
Tuesday INCREMENTAL
+
Wednesday INCREMENTAL
```
```text
Monday:
FULL → A B C D

Tuesday:
DIFFERENTIAL → E

Wednesday:
DIFFERENTIAL → E F
```
```text
Monday FULL
+
Wednesday DIFFERENTIAL
```
```text
FULL
= Everything

INCREMENTAL
= Changes since previous backup

DIFFERENTIAL
= Changes since last full backup
```
```text
3 copies of your data
2 different media/types
1 copy stored off-site
```
```text
                 Original
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Local Backup        Off-site Backup
```
```text
Server
  │
  ├── Local backup
  │
  └── Cloud/Object Storage
```
```bash
tar -czf backup_$(date +%F).tar.gz /home/user/data
```
```text
-c
Create archive

-z
Compress using gzip

-f
Specify archive filename
```
```text
backup_2026-10-03.tar.gz
```
```bash
tar -tzf backup_2026-10-03.tar.gz
```
```bash
tar -tzf backup_2026-10-03.tar.gz | head
```
```text
-t
List contents

-z
gzip compression

-f
Archive file
```
```bash
mkdir -p /tmp/restore_test
```
```bash
tar -xzf backup_2026-10-03.tar.gz -C /tmp/restore_test
```
```text
-x
Extract

-z
gzip compression

-f
Archive file

-C
Change extraction directory
```
```bash
mkdir -p ~/backup-lab/source
mkdir -p ~/backup-lab/backups
mkdir -p ~/backup-lab/restore
mkdir -p ~/backup-lab/logs
mkdir -p ~/backup-lab/offsite
```
```bash
echo "Linux backup test" > ~/backup-lab/source/file1.txt
echo "Day 216" > ~/backup-lab/source/file2.txt
```
```bash
find ~/backup-lab/source -type f -print
```
```bash
tar -czf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
~/backup-lab/source
```
```bash
ls -lh ~/backup-lab/backups
```
```bash
tar -tzf ~/backup-lab/backups/backup_$(date +%F).tar.gz
```
```bash
tar -xzf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
-C ~/backup-lab/restore
```
```bash
find ~/backup-lab/restore -type f -print
```
```bash
mkdir -p ~/backup-lab/source/project
```
```bash
echo "production configuration" \
> ~/backup-lab/source/project/config.txt
```
```bash
tar -czf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
~/backup-lab/source
```
```bash
rm ~/backup-lab/source/project/config.txt
```
```bash
ls ~/backup-lab/source/project
```
```bash
rm -rf ~/backup-lab/restore/*
```
```bash
tar -xzf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
-C ~/backup-lab/restore
```
```bash
find ~/backup-lab/restore -name config.txt
```
```bash
find ~/backup-lab/restore \
-name config.txt \
-exec cat {} \;
```
```bash
rsync -av /source/ /backup/destination/
```
```bash
mkdir -p ~/backup-lab/rsync-backup
```
```bash
rsync -av \
~/backup-lab/source/ \
~/backup-lab/rsync-backup/
```
```bash
find ~/backup-lab/rsync-backup -type f -print
```
```bash
rsync -av --delete \
~/backup-lab/source/ \
~/backup-lab/rsync-backup/
```
```text
SOURCE              BACKUP

file1.txt           file1.txt
file2.txt           file2.txt
                    old.txt
```
```bash
rsync -av --delete source/ backup/
```
```text
SOURCE              BACKUP

file1.txt           file1.txt
file2.txt           file2.txt
```
```bash
diff -r \
~/backup-lab/source \
~/backup-lab/rsync-backup
```
```text
Daily:
Keep 7

Weekly:
Keep 4

Monthly:
Keep 12

Yearly:
Keep 1
```
```text
Daily
├── Monday
├── Tuesday
├── Wednesday
├── Thursday
├── Friday
├── Saturday
└── Sunday

Weekly
├── Week 1
├── Week 2
├── Week 3
└── Week 4

Monthly
├── January
├── February
└── ...
```
```text
Backup frequency = Every 24 hours
```
```text
24 hours
```
```text
RPO ≈ 24 hours
```
```text
RPO = 1 hour
```
```text
Server failure
     ↓
Recovery starts
     ↓
Service restored
     ↓
30 minutes
```
```text
30 minutes
```
```text
RPO = How much data can I lose?

RTO = How much time can I be down?
```
```bash
nano ~/daily_backup.sh
```
```bash
#!/bin/bash

set -euo pipefail

SOURCE="$HOME/backup-lab/source"
BACKUP_DIR="$HOME/backup-lab/backups"
LOG_DIR="$HOME/backup-lab/logs"

DATE=$(date +%F)

BACKUP_FILE="$BACKUP_DIR/backup_${DATE}.tar.gz"
LOG_FILE="$LOG_DIR/backup_${DATE}.log"

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

exec >> "$LOG_FILE" 2>&1

echo "======================================"
echo "Backup started: $(date)"
echo "======================================"

echo "Source: $SOURCE"
echo "Destination: $BACKUP_FILE"

tar -czf "$BACKUP_FILE" "$SOURCE"

echo "Backup created successfully."

echo "Checking archive..."

tar -tzf "$BACKUP_FILE" > /dev/null

echo "Archive verification successful."

echo "Applying retention policy..."

find "$BACKUP_DIR" \
    -type f \
    -name "backup_*.tar.gz" \
    -mtime +7 \
    -delete

echo "Backup completed: $(date)"
```
```bash
chmod +x ~/daily_backup.sh
```
```bash
~/daily_backup.sh
```
```bash
ls -lh ~/backup-lab/backups
```
```bash
cat ~/backup-lab/logs/backup_$(date +%F).log
```
```bash
set -e
```
```bash
set -u
```
```bash
set -o pipefail
```
```bash
set -euo pipefail
```
```bash
nano ~/backup_verification.sh
```
```bash
#!/bin/bash

set -euo pipefail

BACKUP_DIR="$HOME/backup-lab/backups"

LATEST_BACKUP=$(
    find "$BACKUP_DIR" \
        -type f \
        -name "backup_*.tar.gz" \
        -printf '%T@ %p\n' |
    sort -nr |
    head -n 1 |
    cut -d' ' -f2-
)

if [ -z "$LATEST_BACKUP" ]; then
    echo "ERROR: No backup found."
    exit 1
fi

echo "Testing backup:"
echo "$LATEST_BACKUP"

if tar -tzf "$LATEST_BACKUP" > /dev/null; then
    echo "SUCCESS: Backup archive is readable."
else
    echo "ERROR: Backup verification failed."
    exit 1
fi
```
```bash
chmod +x ~/backup_verification.sh
```
```bash
~/backup_verification.sh
```
```bash
mkdir -p ~/backup-lab/offsite
```
```bash
rsync -av \
~/backup-lab/backups/ \
~/backup-lab/offsite/
```
```text
Amazon S3
Object Storage
Remote Server
Another Region
Dedicated Backup Service
```
```bash
crontab -e
```
```cron
0 2 * * * /home/kevz/daily_backup.sh
```
```bash
echo $HOME
```
```bash
crontab -l
```
```cron
0 3 * * 0 rsync -av /home/kevz/backup-lab/backups/ /home/kevz/backup-lab/offsite/
```
```text
03:00
Every Sunday
```
```text
                    SOURCE DATA
                         │
                         ▼
                  daily_backup.sh
                         │
                         ▼
                  Create Backup
                         │
                         ▼
                   Verify Archive
                         │
                         ▼
                  Apply Retention
                         │
                         ▼
                   Local Backup
                         │
                         ▼
                 Weekly Off-site
                         │
                         ▼
                  Disaster Recovery
                         │
                         ▼
                       RESTORE
```
```text
Data
 ↓
Backup
```
```text
Failure
 ↓
Detect
 ↓
Recover
 ↓
Restore
 ↓
Verify
 ↓
Resume service
```
```text
~/backup-system/
│
├── scripts/
│   ├── daily_backup.sh
│   └── backup_verification.sh
│
├── backups/
│
├── logs/
│
├── restore/
│
└── README.md
```
```text
What is being backed up?
Where is it stored?
How long is it retained?
How is it verified?
When does it run?
How do I restore it?
What happens if the backup fails?
```
```text
tar
rsync
cron
logs
restore
```
```text
EC2
 │
 ├── EBS Snapshots
 ├── S3
 ├── S3 Lifecycle
 ├── AWS Backup
 ├── CloudWatch
 ├── SNS
 └── Multi-Region Disaster Recovery
```
```text
Backup
+
Retention
+
Verification
+
Monitoring
+
Recovery
```
```bash
tar -czf backup.tar.gz data/
```
```bash
tar -tzf backup.tar.gz
```
```text
BACKUP
   ↓
VERIFY
   ↓
RETAIN
   ↓
MONITOR
   ↓
REPLICATE
   ↓
RESTORE
   ↓
TEST AGAIN
```

---

## Day 21 / 30 — Week 3 Review & Integration Project
```text
/etc/passwd
/etc/shadow
/etc/group
/etc/gshadow
```
```bash
sudo useradd -m alice
```
```bash
id alice
```
```bash
ls -la /home/alice
```
```bash
grep alice /etc/passwd
```
```bash
sudo groupadd developers
sudo groupadd admins
```
```bash
getent group developers
getent group admins
```
```bash
sudo usermod -aG developers alice
```
```bash
sudo usermod -aG developers,admins alice
```
```bash
id alice
```
```bash
usermod -aG
```
```text
/etc/sudoers
/etc/sudoers.d/
```
```bash
sudo visudo -cf /etc/sudoers.d/example
```
```text
%developers ALL=(root) /usr/bin/systemctl restart nginx
```
```bash
sudo systemctl restart nginx
```
```text
/home/alice/
└── .ssh/
    └── authorized_keys
```
```bash
sudo mkdir -p /home/alice/.ssh
```
```bash
sudo cp alice.pub /home/alice/.ssh/authorized_keys
```
```bash
sudo chown -R alice:alice /home/alice/.ssh
```
```bash
sudo chmod 700 /home/alice/.ssh
sudo chmod 600 /home/alice/.ssh/authorized_keys
```
```bash
ls -la /home/alice/.ssh
```
```text
drwx------ .ssh
-rw------- authorized_keys
```
```bash
sudo chage -l alice
```
```bash
sudo chage -M 90 alice
```
```bash
sudo chage -W 14 alice
```
```bash
sudo chage -m 1 alice
```
```bash
sudo chage -d 0 alice
```
```text
-w /home/alice -p wa -k user_home_alice
```
```text
-w  → Watch this path
-p  → Permissions/events to monitor
w   → Write
a   → Attribute changes
-k  → Searchable audit key
```
```bash
sudo ausearch -k user_home_alice
```
```bash
sudo auditctl -l
```
```text
/var/log/onboard_user.log
```
```bash
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" \
        | tee -a "$LOG_FILE"
}
```
```bash
log "Creating user: $USERNAME"
log "Adding user to developers"
log "Configuring SSH"
log "Configuring auditd"
```
```text
                    onboard_user.sh
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
   User Creation      Group Assignment    SSH Access
        │                  │                  │
        ▼                  ▼                  ▼
   /home/user          developers          authorized_keys
                           │
                           ▼
                      Sudo Rules
                           │
                           ▼
                    Password Policy
                           │
                           ▼
                     Auditd Rules
                           │
                           ▼
                         Logs
                           │
                           ▼
                       Summary
```
```text
linux-day-217/
│
├── onboard_user.sh
│
├── config/
│   ├── sudoers.template
│   └── audit.rules.template
│
├── keys/
│   └── alice.pub
│
├── logs/
│
├── examples/
│   └── example-run.txt
│
└── README.md
```
```bash
nano onboard_user.sh
```
```bash
#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/onboard_user.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" \
        | tee -a "$LOG_FILE"
}
```
```text
-e → Exit when a command fails
-u → Treat undefined variables as errors
-o pipefail → Detect failures inside pipelines
```
```bash
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    exit 1
fi
```
```bash
sudo ./onboard_user.sh
```
```bash
./onboard_user.sh alice developers alice.pub
```
```bash
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <username> <group> <public-key>"
    exit 1
fi

USERNAME="$1"
GROUP="$2"
PUBLIC_KEY="$3"
```
```text
$1 → Username
$2 → Group
$3 → SSH public key
```
```bash
if ! [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "Invalid username."
    exit 1
fi
```
```bash
if ! getent group "$GROUP" > /dev/null; then
    log "Creating group: $GROUP"
    groupadd "$GROUP"
else
    log "Group already exists: $GROUP"
fi
```
```bash
if id "$USERNAME" &>/dev/null; then
    log "User already exists: $USERNAME"
else
    log "Creating user: $USERNAME"
    useradd -m -s /bin/bash "$USERNAME"
fi
```
```bash
id "$USERNAME"
```
```bash
usermod -aG "$GROUP" "$USERNAME"
```
```bash
id "$USERNAME"
```
```bash
SSH_DIR="/home/$USERNAME/.ssh"
```
```bash
mkdir -p "$SSH_DIR"
```
```bash
cp "$PUBLIC_KEY" "$SSH_DIR/authorized_keys"
```
```bash
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"
```
```bash
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
```
```bash
chage -M 90 "$USERNAME"
```
```bash
chage -W 14 "$USERNAME"
```
```bash
chage -l "$USERNAME"
```
```bash
AUDIT_RULE="-w /home/$USERNAME -p wa -k user_home_$USERNAME"
```
```bash
echo "$AUDIT_RULE" >> /etc/audit/rules.d/onboard_user.rules
```
```bash
augenrules --load
```
```bash
auditctl -l
```
```bash
ausearch -k "user_home_$USERNAME"
```
```bash
SUDO_FILE="/etc/sudoers.d/$GROUP"
```
```bash
echo "%$GROUP ALL=(root) /usr/bin/systemctl restart nginx" \
    > "$SUDO_FILE"
```
```bash
chmod 440 "$SUDO_FILE"
```
```bash
visudo -cf "$SUDO_FILE"
```
```bash
SUMMARY_FILE="/tmp/${USERNAME}_onboarding_summary.txt"
```
```bash
cat > "$SUMMARY_FILE" <<EOF
User onboarding completed.

Username: $USERNAME
Group: $GROUP
Home: /home/$USERNAME
SSH key: configured
Password policy: configured
Audit rules: configured
Sudo rules: configured
EOF
```
```bash
cat "$SUMMARY_FILE"
```
```text
mail
mailx
msmtp
Postfix
```
```text
/tmp/alice_onboarding_summary.txt
```
```bash
sudo ./onboard_user.sh alice developers keys/alice.pub
```
```bash
id alice
```
```bash
ls -ld /home/alice
```
```text
/home/alice
```
```bash
ls -la /home/alice/.ssh
```
```bash
cat /home/alice/.ssh/authorized_keys
```
```bash
stat /home/alice/.ssh
stat /home/alice/.ssh/authorized_keys
```
```text
.ssh                700
authorized_keys     600
```
```bash
sudo chage -l alice
```
```text
Maximum number of days between password change: 90
Number of days of warning before password expires: 14
```
```bash
sudo -u alice touch /home/alice/test.txt
```
```bash
sudo ausearch -k user_home_alice
```
```bash
su - alice
```
```bash
sudo systemctl restart nginx
```
```bash
sudo cat /etc/shadow
```
```text
Users
  +
Groups
  +
SSH
  +
Sudo
  +
Password Policies
  +
Auditd
  +
Logging
  +
Bash
      ↓
Secure User Onboarding
```
```bash
./onboard_user.sh alice developers admins alice.pub
```
```text
developers
admins
```
```bash
sudo ./onboard_user.sh alice developers alice.pub
```
```bash
./onboard_user.sh alice developers missing.pub
```
```text
ERROR: SSH public key not found.
```
```bash
sudo ./onboard_user.sh alice developers alice.pub --dry-run
```
```text
[DRY RUN] Would create user alice
[DRY RUN] Would add alice to developers
[DRY RUN] Would configure SSH
[DRY RUN] Would configure sudo
[DRY RUN] Would configure auditd
```
```text
User created
      ↓
Group added
      ↓
SSH configured
      ↓
Sudo configuration FAILS
```
```text
A. Leave everything as-is?
B. Remove the user?
C. Restore the previous state?
D. Log the failure and stop?
```
```text
[ ] onboard_user.sh created
[ ] User creation works
[ ] Home directory created
[ ] Group management works
[ ] SSH key installation works
[ ] SSH permissions configured
[ ] Sudo configuration works
[ ] sudoers validation implemented
[ ] Password expiry configured
[ ] auditd rule created
[ ] Audit rule tested
[ ] Logging implemented
[ ] Summary generated
[ ] README created
[ ] Example run documented
[ ] Script tested
[ ] Git commit completed
```
```text
onboard_user.sh
config/sudoers.template
config/audit.rules.template
keys/alice.pub
examples/example-run.txt
README.md
```
```bash
git add .
git commit -m "Week 3: User onboarding and security hardening"
git push
```
```text
Linux Mastery:

Day 21 / 30
█████████████████████░░░░░░░ 70%

1000-Day AI Cloud Infrastructure Journey:

Day 217 / 1000
█████░░░░░░░░░░░░░░░░░░░░░░░ 21.7%
```
```text
Day 15–20
Learn Linux security components
        ↓
Day 21
Integrate them
        ↓
Automation
        ↓
Infrastructure Engineering
        ↓
Cloud Infrastructure
        ↓
Distributed Systems
        ↓
AI Cloud Infrastructure Engineer
```

---

