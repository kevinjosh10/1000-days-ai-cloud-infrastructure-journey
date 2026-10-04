# Week 31 Notes

## Day 15 — User & Group Management
---

## 🎯 Today's Objective

Understand how Linux manages identities and access through:

* Users
* Groups
* UIDs and GIDs
* `/etc/passwd`
* `/etc/shadow`
* `/etc/group`
* `/etc/gshadow`
* User creation and deletion
* Group management
* Password management
* Password aging
* System vs. regular users
* Basic identity auditing

The goal is to move from simply **running Linux commands** to understanding how Linux controls **who can access what**.

---

# 1. Linux Users

Linux is a multi-user operating system.

Every user has an identity associated with:

* Username
* UID
* Primary GID
* Supplementary groups
* Home directory
* Login shell
* Authentication information

Example:

```text
alice
 ├── UID: 1001
 ├── Primary GID: 1001
 ├── Groups: developers
 ├── Home: /home/alice
 └── Shell: /bin/bash
```

Linux ultimately uses numeric IDs rather than usernames when enforcing ownership and permissions.

---

# 2. UID — User ID

A UID is the numeric identity assigned to a Linux user.

Check the current user:

```bash
id
```

Example:

```text
uid=1000(kevz) gid=1000(kevz) groups=1000(kevz),27(sudo)
```

Check root:

```bash
id root
```

Typical result:

```text
uid=0(root) gid=0(root) groups=0(root)
```

### Important

```text
UID 0 = root
```

Root has extremely powerful privileges.

This is why running services unnecessarily as root is a security risk.

---

# 3. `/etc/passwd`

View the file:

```bash
cat /etc/passwd
```

Example:

```text
alice:x:1001:1001:Alice:/home/alice:/bin/bash
```

The structure is:

```text
username:password:UID:GID:GECOS:home:shell
```

Example:

```text
alice:x:1001:1001:Alice:/home/alice:/bin/bash
```

| Field       | Meaning            |
| ----------- | ------------------ |
| alice       | Username           |
| x           | Password reference |
| 1001        | UID                |
| 1001        | Primary GID        |
| Alice       | User description   |
| /home/alice | Home directory     |
| /bin/bash   | Login shell        |

Modern Linux systems normally keep password hashes in `/etc/shadow`, not directly in `/etc/passwd`.

---

# 4. `/etc/shadow`

View it with root privileges:

```bash
sudo cat /etc/shadow
```

Example:

```text
alice:$6$.....:20350:0:99999:14:::
```

`/etc/shadow` contains sensitive authentication information, including password hashes and password-aging information.

Check its permissions:

```bash
ls -l /etc/shadow
```

Normal users should not have unrestricted access to this file.

### Mental model

```text
/etc/passwd
      ↓
Account identity information

/etc/shadow
      ↓
Authentication + password aging information
```

Never modify `/etc/shadow` manually unless you specifically understand the format and consequences.

---

# 5. Linux Groups

Groups allow administrators to assign permissions to multiple users.

Instead of:

```text
alice → permission
bob → permission
charlie → permission
```

we can create:

```text
developers
 ├── alice
 ├── bob
 └── charlie
```

Then permissions can be assigned to the `developers` group.

This is important for:

* Shared project directories
* Application deployment
* Logs
* Docker
* CI/CD
* Web servers
* Cloud servers
* Infrastructure administration

---

# 6. `/etc/group`

View groups:

```bash
cat /etc/group
```

Example:

```text
developers:x:1002:alice,bob
```

Structure:

```text
groupname:password:GID:members
```

Example:

```text
developers:x:1002:alice,bob
```

means:

```text
Group name → developers
GID        → 1002
Members    → alice, bob
```

---

# 7. Primary vs Supplementary Groups

A user has a primary group and may have additional supplementary groups.

Example:

```text
uid=1001(alice)
gid=1001(alice)
groups=1001(alice),1002(developers),999(docker)
```

This means:

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

Check:

```bash
id alice
```

---

# 8. Creating a User

Create Alice:

```bash
sudo useradd -m -s /bin/bash alice
```

### Options

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

Verify:

```bash
id alice
```

Check the home directory:

```bash
ls -la /home/alice
```

---

# 9. Set a Password

Set Alice's password:

```bash
sudo passwd alice
```

Check password status:

```bash
sudo passwd -S alice
```

---

# 10. Create a Group

Create the developers group:

```bash
sudo groupadd developers
```

Verify:

```bash
getent group developers
```

Example:

```text
developers:x:1002:
```

---

# 11. Add a User to a Group

Add Alice:

```bash
sudo usermod -aG developers alice
```

The important option is:

```text
-aG
```

Meaning:

```text
-a → append
-G → supplementary groups
```

So:

```bash
sudo usermod -aG developers alice
```

means:

> Add Alice to the `developers` supplementary group without removing her existing supplementary group memberships.

---

# 12. Why `-a` Matters

Compare:

```bash
sudo usermod -G developers alice
```

with:

```bash
sudo usermod -aG developers alice
```

Without `-a`, the supplementary group list can be replaced.

With:

```text
-aG
```

the new group is appended.

### Rule to remember

When adding a user to an existing supplementary group:

```bash
usermod -aG group user
```

---

# 13. Verify Group Membership

Run:

```bash
id alice
```

Also:

```bash
getent group developers
```

Example:

```text
developers:x:1002:alice
```

---

# 14. `finger`

If installed:

```bash
finger alice
```

`finger` can display account information.

However, modern Linux administration commonly relies more on commands such as:

```bash
id alice
getent passwd alice
getent group developers
```

---

# 15. Password Aging

Check Alice's password-aging information:

```bash
sudo chage -l alice
```

Example:

```text
Last password change                                    : Sep 28, 2026
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change         : 0
Maximum number of days between password change         : 99999
Number of days of warning before password expires       : 7
```

---

# 16. `chage`

`chage` manages password and account aging.

It can control:

* Password expiration
* Minimum password age
* Maximum password age
* Password expiration warning
* Account expiration

Basic command:

```bash
sudo chage -l alice
```

---

# 17. Account Expiration

The original exercise uses:

```bash
sudo chage -E 2025-12-31 -W 14 alice
```

However, that date is already in the past.

For the current lab, use a future date:

```bash
sudo chage -E 2027-12-31 -W 14 alice
```

Then verify:

```bash
sudo chage -l alice
```

You should see:

```text
Account expires : Dec 31, 2027
```

and:

```text
Number of days of warning before password expires : 14
```

### Important distinction

```text
Password expiration
        ≠
Account expiration
```

Password expiration affects the password.

Account expiration affects the account itself.

---

# 18. System Users vs Regular Users

Not every Linux user represents a human.

Check:

```bash
cat /etc/passwd
```

You may find accounts such as:

```text
root
daemon
bin
sys
www-data
nobody
```

These can be used by system services and applications.

For example:

```text
Web Server
     ↓
www-data
     ↓
Limited privileges
```

This follows the principle of:

## Least Privilege

A service should have only the permissions it needs.

Avoid unnecessarily running services as:

```text
root
```

because a compromise of that service could expose extremely powerful privileges.

---

# 19. Inspect UID Information

Run:

```bash
awk -F: '{print $1, $3}' /etc/passwd
```

Example:

```text
root 0
daemon 1
bin 2
...
kevz 1000
alice 1001
```

The exact UID ranges vary by Linux distribution and configuration.

The important concepts are:

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

---

# 20. `id` — Your Most Important Command Today

Practice:

```bash
id
```

```bash
id alice
```

```bash
id root
```

It shows:

* UID
* GID
* Primary group
* Supplementary groups

When troubleshooting Linux permissions, `id` is one of the first commands you should use.

---

# 21. Identity Investigation Lab

Create Alice:

```bash
sudo useradd -m -s /bin/bash alice
```

Set password:

```bash
sudo passwd alice
```

Create group:

```bash
sudo groupadd developers
```

Add Alice:

```bash
sudo usermod -aG developers alice
```

Investigate:

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

You have now performed a basic Linux identity audit.

---

# 22. Day 15 Mini Project — Bulk User Setup

## Objective



# 23. Project Structure

Create:

```text
day-15/
├── bulk_user_setup.sh
├── users.csv
└── logs/
```

Example CSV:

```csv
username,group
alice,developers
bob,developers
charlie,developers
```

---

# 24. Script Requirements

Your script should:

1. Read the CSV file.
2. Ignore the header.
3. Validate each row.
4. Check whether the group exists.
5. Create the group if necessary.
6. Check whether the user exists.
7. Create the user if necessary.
8. Create the user's home directory.
9. Set the login shell.
10. Add the user to the group.
11. Log each operation.
12. Handle errors safely.

Expected flow:

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

---

# 25. Security Rule — Never Commit Passwords

Do NOT create a CSV such as:

```csv
username,password
alice,password123
bob,password456
```

Never commit real credentials to GitHub.

Credentials are secrets.

Use safer approaches such as:

* Temporary lab passwords
* Interactive password prompts
* Random password generation
* Locked accounts
* SSH keys
* Secret managers

This principle will become important later with:

* AWS
* Terraform
* GitHub Actions
* Docker
* Kubernetes
* CI/CD

---

# 26. Cloud Infrastructure Connection

Today's Linux identity concepts directly connect to cloud infrastructure.

Imagine an EC2 server:

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

Permissions can then be organized around groups.

For example:

```text
/opt/myapp
     │
     ├── Owner: deploy
     ├── Group: developers
     └── Permissions
```

This connects:

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

---

# 27. Infrastructure Engineer Mental Model

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

---

# 28. Commands Learned Today

| Command    | Purpose                       |
| ---------- | ----------------------------- |
| `id`       | Display user/group identity   |
| `useradd`  | Create a user                 |
| `usermod`  | Modify a user                 |
| `userdel`  | Delete a user                 |
| `groupadd` | Create a group                |
| `groupdel` | Delete a group                |
| `passwd`   | Manage passwords              |
| `chage`    | Manage password/account aging |
| `getent`   | Query system databases        |
| `finger`   | Display user information      |
| `awk`      | Process `/etc/passwd` data    |

---

# 29. Important Files

| File              | Purpose                               |
| ----------------- | ------------------------------------- |
| `/etc/passwd`     | User account information              |
| `/etc/shadow`     | Password hashes and aging information |
| `/etc/group`      | Group information                     |
| `/etc/gshadow`    | Protected group information           |
| `/etc/login.defs` | System-wide login/account defaults    |

Inspect:

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

---

# 30. Practice Questions

### Question 1

What is the difference between:

```text
UID
GID
```

### Question 2

Why is `/etc/shadow` protected?

### Question 3

What does this command do?

```bash
sudo usermod -aG developers alice
```

### Question 4

What's the difference between:

```bash
sudo usermod -G developers alice
```

and:

```bash
sudo usermod -aG developers alice
```

### Question 5

What is the difference between:

```bash
sudo userdel alice
```

and:

```bash
sudo userdel -r alice
```

### Question 6

Why should services generally avoid running as root?

### Question 7

What does `id alice` tell you?

### Question 8

What is the difference between password expiration and account expiration?

---

# 31. Day 15 Challenge

Without looking at your notes, explain this command:

```bash
sudo usermod -aG developers alice
```

You should be able to explain every component:

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

Then explain this:

```bash
sudo chage -E 2027-12-31 -W 14 alice
```

If you can explain both commands without memorizing them, you've understood today's lesson.

---

# 32. Day 15 Checklist

## Theory

* [x] Understand Linux users
* [x] Understand UID
* [x] Understand GID
* [x] Understand primary groups
* [x] Understand supplementary groups
* [x] Understand `/etc/passwd`
* [x] Understand `/etc/shadow`
* [x] Understand `/etc/group`
* [x] Understand `/etc/gshadow`
* [x] Understand system vs regular users
* [x] Understand password aging
* [x] Understand account expiration
* [x] Understand least privilege

## Hands-On

* [ ] Create Alice
* [ ] Set Alice's password
* [ ] Create developers group
* [ ] Add Alice to developers
* [ ] Verify with `id`
* [ ] Inspect `/etc/passwd`
* [ ] Inspect `/etc/group`
* [ ] Check `chage -l`
* [ ] Create Bob
* [ ] Create Charlie
* [ ] Test group membership
* [ ] Delete test users after completing the lab

## Project

* [ ] Create `bulk_user_setup.sh`
* [ ] Create `users.csv`
* [ ] Create `logs/`
* [ ] Test with 3 users
* [ ] Verify user creation
* [ ] Verify group membership
* [ ] Verify logging
* [ ] Review the script for safe error handling

---

# 🚀 Day 15 → Cloud Engineer Connection

Today's lesson can be summarized as:

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

This is the beginning of your Linux security foundation.

---

# 📊 Progress

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

---

# 🧠 Day 15 Core Takeaway

> Linux security begins with identity.

Remember:

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

And the most important principle:

```text
Least Privilege
      ↓
Give users and services
only the permissions
they actually need.
```

**Day 15/30 — Linux Users & Groups**
**Day 211/1000 — AI Cloud Infrastructure Journey**

**Next: Day 16 — SSH & Authentication**

---

## Day 16 — Sudo & Privilege Escalation
---

## 🎯 Today's Objective

Learn how Linux controls privileged operations using `sudo` and the sudoers configuration.

By the end of today, I should understand:

* How `sudo` works
* `/etc/sudoers`
* `visudo`
* Sudoers syntax
* User and group-based privileges
* `NOPASSWD`
* `sudo -l`
* `sudo -i`
* `sudo su -`
* `sudo -s`
* Sudo audit logging
* `/etc/sudoers.d/`
* Least-privilege security
* Common sudo misconfigurations
* Safe automation of sudoers configuration
* Backup, validation, and rollback

---

# 1. What is sudo?

`sudo` stands for **Superuser Do**.

It allows a normal Linux user to execute specific commands with elevated privileges.

Instead of working as `root` all the time:

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

Example:

```bash
sudo systemctl restart nginx
```

The user does not permanently become root.

Only that particular command is executed with elevated privileges.

---

# 2. Why not work as root?

The root user has extremely powerful privileges.

Root can:

* Delete files
* Modify system configuration
* Create and delete users
* Install software
* Change networking
* Modify permissions
* Stop services
* Kill processes
* Access protected files

Working permanently as root increases the chance of accidental damage.

For example:

```bash
rm -rf /
```

could have catastrophic consequences if executed with sufficient privileges.

Instead, Linux encourages using:

```bash
sudo <command>
```

only when elevated privileges are required.

---

# 3. Least Privilege

The most important security principle for today's lesson is:

> Give users only the privileges they actually need.

Suppose:

```text
Alice → Developer
Bob → DevOps Engineer
Charlie → Intern
```

Giving everyone:

```text
root
```

is unnecessary.

Instead, a developer might only need:

```text
restart nginx
```

A restricted sudo rule could therefore allow:

```text
/usr/bin/systemctl restart nginx
```

without granting unrestricted root access.

This is called:

**Least Privilege**

---

# 4. Sudo Architecture

The main sudo configuration file is:

```text
/etc/sudoers
```

Additional configuration can be stored in:

```text
/etc/sudoers.d/
```

Architecture:

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

---

# 5. `/etc/sudoers`

View the sudoers file:

```bash
sudo cat /etc/sudoers
```

Typical configurations contain rules such as:

```text
root ALL=(ALL:ALL) ALL
```

and depending on the distribution:

```text
%sudo ALL=(ALL:ALL) ALL
```

or:

```text
%wheel ALL=(ALL:ALL) ALL
```

The exact default configuration depends on the Linux distribution.

---

# 6. NEVER Directly Edit sudoers

Do NOT casually use:

```bash
sudo nano /etc/sudoers
```

or:

```bash
sudo vim /etc/sudoers
```

Instead use:

```bash
sudo visudo
```

`visudo` provides important protection:

* Locks the sudoers file during editing
* Checks sudoers syntax
* Prevents invalid configuration from being installed
* Helps prevent accidental loss of administrative access

Always use:

```bash
sudo visudo
```

when editing the main sudoers configuration.

---

# 7. Sudoers Syntax

Consider:

```text
alice ALL=(ALL) ALL
```

Break it down:

```text
alice    ALL    =    (ALL)    ALL
  |       |           |         |
 User   Hosts      Run as    Commands
```

Meaning:

```text
alice
```

The rule applies to user Alice.

```text
ALL
```

The rule applies to all hosts.

```text
(ALL)
```

Alice can run the command as any user.

```text
ALL
```

Alice can execute all commands.

Therefore:

```text
alice ALL=(ALL) ALL
```

provides very broad sudo privileges.

---

# 8. Users vs Groups

A sudo rule can target an individual user:

```text
alice ALL=(ALL) ALL
```

A `%` prefix means the target is a group:

```text
%developers ALL=(ALL) /usr/bin/systemctl
```

For example:

```text
alice
```

means user Alice.

While:

```text
%developers
```

means the `developers` group.

Group-based permissions are easier to maintain when multiple users require the same privilege.

---

# 9. Create a Test User and Group

For the lab:

```bash
sudo groupadd developers
```

Create Alice:

```bash
sudo useradd -m alice
```

Set a password:

```bash
sudo passwd alice
```

Add Alice to the developers group:

```bash
sudo usermod -aG developers alice
```

Verify:

```bash
id alice
```

The output should show the `developers` group.

---

# 10. Full Sudo Access

Using:

```bash
sudo visudo
```

temporarily add:

```text
alice ALL=(ALL) ALL
```

Switch to Alice:

```bash
su - alice
```

Check her sudo permissions:

```bash
sudo -l
```

Then:

```bash
sudo whoami
```

Expected:

```text
root
```

This demonstrates full sudo access.

---

# 11. Understanding sudo -l

Run:

```bash
sudo -l
```

This lists the commands the current user is allowed to execute through sudo.

Example:

```text
User alice may run the following commands:

(root) /usr/bin/systemctl restart nginx
```

This command is extremely useful when troubleshooting permission problems.

It answers:

> What can this user actually execute with sudo?

---

# 12. NOPASSWD

Normally, sudo may ask for the user's password.

For automation, a specific command can be configured with:

```text
NOPASSWD:
```

Example:

```text
alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

This means:

> Alice can restart nginx as root without entering her password.

This can be useful for automation.

However, avoid broad rules such as:

```text
alice ALL=(ALL) NOPASSWD: ALL
```

because this effectively gives Alice unrestricted passwordless root access.

---

# 13. Absolute Command Paths

Prefer:

```text
/usr/bin/systemctl
```

instead of:

```text
systemctl
```

Explicit paths make the authorization more precise.

For example:

```text
alice ALL=(ALL) /usr/bin/systemctl restart nginx
```

is clearer about exactly which executable and command are being authorized.

---

# 14. Group-Based systemctl Permission

The exercise asks us to understand:

```text
%developers ALL=(ALL) /usr/bin/systemctl
```

This gives members of the `developers` group permission to execute `systemctl` with sudo.

However, unrestricted `systemctl` access can be powerful.

A more restrictive rule would be:

```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```

Now the permission is limited to:

```bash
sudo systemctl restart nginx
```

This better demonstrates least privilege.

---

# 15. sudo -i

Run:

```bash
sudo -i
```

This opens a root login-style shell.

Check:

```bash
whoami
```

Expected:

```text
root
```

Exit:

```bash
exit
```

Conceptually:

```text
sudo -i
   |
   v
Root login-style environment
```

---

# 16. sudo su -

Another way to obtain a root shell is:

```bash
sudo su -
```

The command means:

```text
sudo
  |
  v
run su -
  |
  v
root shell
```

Check:

```bash
whoami
```

Expected:

```text
root
```

Exit:

```bash
exit
```

---

# 17. sudo -s

Run:

```bash
sudo -s
```

This opens a privileged shell while retaining more of the current shell environment.

Compare:

```text
sudo -i
```

with:

```text
sudo su -
```

and:

```text
sudo -s
```

General idea:

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

For normal administration, prefer executing the exact privileged command:

```bash
sudo systemctl restart nginx
```

instead of opening a root shell unnecessarily.

---

# 18. Sudo Logging

Sudo operations can be recorded in the system audit logs.

Depending on the Linux distribution, try:

```bash
sudo grep sudo /var/log/auth.log
```

or:

```bash
sudo journalctl SYSLOG_IDENTIFIER=sudo
```

You can also search the journal:

```bash
sudo journalctl | grep sudo
```

The audit trail may contain information about:

* User
* Command
* Terminal
* Working directory
* Authentication
* Time of execution

---

# 19. Why Sudo Logging Matters

Imagine a production server goes down:

```text
03:15 AM
Production service unavailable
```

The team needs to know:

> Who restarted or stopped the service?

Sudo logs can provide evidence such as:

```text
03:14:52 alice
sudo systemctl restart nginx
```

This creates accountability and helps during troubleshooting and incident investigation.

---

# 20. `/etc/sudoers.d/`

Instead of putting every rule into:

```text
/etc/sudoers
```

you can use:

```text
/etc/sudoers.d/
```

Example:

```text
/etc/sudoers.d/
├── developers
├── monitoring
├── deployment
└── backup
```

This makes sudo configuration:

* Modular
* Easier to maintain
* Easier to audit
* Easier to automate

For infrastructure environments, splitting configuration into logical files is useful.

---

# 21. Validate Sudoers Configuration

Validate the main sudoers configuration:

```bash
sudo visudo -c
```

Expected:

```text
/etc/sudoers: parsed OK
```

For a specific file:

```bash
sudo visudo -cf /etc/sudoers.d/developers
```

Never deploy a sudoers configuration without validating it.

---

# 22. Why Validation Matters

Imagine an automation script does this:

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

A safer workflow is:

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

---

# 23. Common Sudo Misconfigurations

## 23.1 Passwordless unrestricted root

Dangerous:

```text
alice ALL=(ALL) NOPASSWD: ALL
```

This gives Alice unrestricted passwordless sudo.

---

## 23.2 Unrestricted systemctl

Potentially dangerous:

```text
alice ALL=(ALL) /usr/bin/systemctl
```

`systemctl` can control system services, so unrestricted access may provide more power than intended.

---

## 23.3 Dangerous interpreters

Be careful when allowing unrestricted execution of powerful interpreters such as:

```text
/usr/bin/python3
```

or shells.

A user who can execute arbitrary code as root can potentially turn a seemingly narrow sudo rule into broad root access.

---

## 23.4 Editing sudoers directly

Avoid:

```bash
sudo nano /etc/sudoers
```

Use:

```bash
sudo visudo
```

---

## 23.5 Excessive permissions

Avoid:

```text
ALL
```

when a specific command would be sufficient.

Prefer:

```text
/usr/bin/systemctl restart nginx
```

over:

```text
/usr/bin/systemctl
```

when restarting nginx is the only required task.

---

# 24. Cloud Infrastructure Connection

Today's Linux concepts directly connect to cloud infrastructure.

### Linux

```text
sudoers
   |
   v
Who can execute what?
```

### AWS

```text
IAM
   |
   v
Who can perform what API action?
```

Linux:

```text
Least Privilege
```

AWS:

```text
Least Privilege IAM Policies
```

Linux:

```text
sudo audit logs
```

AWS:

```text
CloudTrail
```

The underlying security philosophy is similar:

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

This is why mastering Linux privilege management is important for becoming a Cloud Infrastructure Engineer.

---

# 25. Hands-On Lab

## Part A — Create Users and Groups

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

Verify:

```bash
id alice
```

---

# Part B — Test Full Sudo

Edit using:

```bash
sudo visudo
```

Add temporarily:

```text
alice ALL=(ALL) ALL
```

Switch to Alice:

```bash
su - alice
```

Check:

```bash
sudo -l
```

Test:

```bash
sudo whoami
```

Expected:

```text
root
```

Remove the broad rule after testing.

---

# Part C — Create Restricted Rule

Create:

```text
/etc/sudoers.d/developers
```

with:

```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```

Validate:

```bash
sudo visudo -cf /etc/sudoers.d/developers
```

Then:

```bash
sudo visudo -c
```

---

# Part D — Test Permissions

Switch to Alice:

```bash
su - alice
```

Run:

```bash
sudo -l
```

Test the permitted command:

```bash
sudo systemctl restart nginx
```

Test a command that isn't permitted:

```bash
sudo systemctl status ssh
```

Observe the difference.

---

# Part E — Test NOPASSWD

Use:

```text
alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

Then:

```bash
sudo -l -U alice
```

Verify that the command appears as passwordless.

---

# Part F — Audit Logging

Execute a sudo command:

```bash
sudo systemctl restart nginx
```

Then inspect:

```bash
sudo journalctl SYSLOG_IDENTIFIER=sudo
```

Or:

```bash
sudo grep sudo /var/log/auth.log
```

depending on your Linux distribution.

---

# Part G — Break and Recover

In the lab environment, intentionally create an invalid sudoers rule.

Example:

```text
%developers THIS_IS_INVALID
```

Validate:

```bash
sudo visudo -cf /etc/sudoers.d/developers
```

Observe the syntax error.

Then restore the valid configuration.

Validate again:

```bash
sudo visudo -c
```

Expected:

```text
parsed OK
```

---

# 26. apply_sudoers.sh

Create:

```text
scripts/apply_sudoers.sh
```

The script should:

1. Verify it is running as root
2. Locate the sudoers configuration
3. Create a backup
4. Generate the new rule
5. Validate it with `visudo`
6. Apply the configuration
7. Set secure permissions
8. Validate the final configuration
9. Stop safely if validation fails

Example:

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

Make it executable:

```bash
chmod +x apply_sudoers.sh
```

Run:

```bash
sudo ./apply_sudoers.sh
```

---

# 27. Security Checklist

Before considering the configuration complete:

* [ ] Used `visudo`
* [ ] Never directly edited `/etc/sudoers`
* [ ] Used `/etc/sudoers.d/` where appropriate
* [ ] Used least privilege
* [ ] Avoided `NOPASSWD: ALL`
* [ ] Used absolute executable paths
* [ ] Validated configuration with `visudo`
* [ ] Created a backup
* [ ] Tested the rule
* [ ] Tested denied commands
* [ ] Checked sudo audit logs
* [ ] Tested rollback/recovery

---

# 28. Deliverable — Sudoers Configuration for Our Team

## Organization



### Team Structure

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

### Security Principle

CloudForge follows the principle of least privilege.

Users receive only the privileged commands required for their responsibilities.

### Developers

Developers are allowed to restart the nginx service:

```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```

### Passwordless Automation

A specific automation account may be granted passwordless access to a narrowly defined command where operationally required.

Example:

```text
automation ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

Broad rules such as:

```text
automation ALL=(ALL) NOPASSWD: ALL
```

are prohibited.

### Configuration Location

Team-specific rules are stored in:

```text
/etc/sudoers.d/
```

### Validation

All changes must be validated with:

```bash
visudo -c
```

Specific files can be validated with:

```bash
visudo -cf /etc/sudoers.d/<file>
```

### Backup

Before modifying an existing rule:

```text
/etc/sudoers.d/<file>.backup
```

should be created.

### Auditing

Sudo activity should be reviewed through:

```bash
journalctl SYSLOG_IDENTIFIER=sudo
```

or the appropriate authentication log for the distribution.

---

# 29. Key Commands Learned

| Command                                  | Purpose                                    |
| ---------------------------------------- | ------------------------------------------ |
| `sudo <command>`                         | Execute a command with elevated privileges |
| `sudo -l`                                | List current user's sudo permissions       |
| `sudo -l -U alice`                       | List another user's sudo permissions       |
| `sudo -i`                                | Start root login-style shell               |
| `sudo -s`                                | Start privileged shell                     |
| `sudo su -`                              | Start root shell through `su`              |
| `sudo visudo`                            | Safely edit sudoers                        |
| `sudo visudo -c`                         | Validate sudoers configuration             |
| `sudo visudo -cf file`                   | Validate a specific sudoers file           |
| `sudo journalctl SYSLOG_IDENTIFIER=sudo` | View sudo journal entries                  |
| `id alice`                               | Display user/group information             |
| `usermod -aG`                            | Add user to a supplementary group          |

---

# 30. Day 16 Mental Model

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

The key question should always be:

> **"What exact privileged action does this user need?"**

Not:

> "How do I give this user root?"

---

# 🧠 Day 16 Quiz

Answer these without looking at your notes.

### 1.

Why should `visudo` be used instead of directly editing `/etc/sudoers`?

### 2.

What does this rule mean?

```text
alice ALL=(ALL) ALL
```

### 3.

What does `%developers` represent?

### 4.

What does this command do?

```bash
sudo -l
```

### 5.

What is the purpose of `NOPASSWD`?

### 6.

Why is this dangerous?

```text
alice ALL=(ALL) NOPASSWD: ALL
```

### 7.

Why is `/etc/sudoers.d/` useful?

### 8.

Why is this more restrictive?

```text
%developers ALL=(ALL) /usr/bin/systemctl restart nginx
```

### 9.

Where can sudo activity be logged?

### 10.

What cloud infrastructure concept is closely related to sudo's least-privilege model?

---

# 🔗 Cloud Infrastructure Connection

Today's Linux knowledge maps directly to cloud security:

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

becomes:

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

The same fundamental principle applies:

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

---

# 📊 Progress

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

---

# ✅ Day 16 Completed

Today I learned:

* [x] `sudo` architecture
* [x] `/etc/sudoers`
* [x] `visudo`
* [x] Sudoers syntax
* [x] User permissions
* [x] Group permissions
* [x] `NOPASSWD`
* [x] `sudo -l`
* [x] `sudo -i`
* [x] `sudo su -`
* [x] `sudo -s`
* [x] Sudo logging
* [x] `/etc/sudoers.d/`
* [x] Least privilege
* [x] Common sudo misconfigurations
* [x] Sudoers validation
* [x] Backup and rollback
* [x] Automation with `apply_sudoers.sh`
* [x] Connection between Linux sudo and cloud IAM

---

## 🚀 Day 16 Takeaway

> **Privilege should be granted deliberately, narrowly, and audibly.**

Linux `sudo` is not just a command for becoming root.

It is an introduction to the larger infrastructure-security model:

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

That same thinking will become essential when working with:

**Linux → AWS IAM → Kubernetes RBAC → Cloud Security → Production Infrastructure**

**Day 16 / 30 complete.**

**Next: Day 17 — SSH Security, Key-Based Authentication & Remote Access Hardening.**

---

## Day 213 / 1000 — SSH Hardening & Key-Based Authentication
---

## 🎯 Objective



# 1. What is SSH?

SSH stands for:

> Secure Shell

SSH is a protocol used to securely connect to and manage remote computers over a network.

Example:

```bash
ssh user@server-ip
```

Example:

```bash
ssh alice@192.168.1.100
```

SSH can be used to:

* Execute commands remotely
* Manage Linux servers
* Transfer files
* Deploy applications
* Restart services
* Inspect logs
* Manage cloud infrastructure
* Access EC2 instances
* Access private servers through bastion hosts

---

# 2. SSH Architecture

SSH has two major components.

## SSH Client

The client is the machine from which I connect.

Common command:

```bash
ssh
```

Client configuration:

```text
~/.ssh/config
```

Client keys:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

---

## SSH Server

The remote machine runs the SSH server.

The server process is usually:

```text
sshd
```

Server configuration:

```text
/etc/ssh/sshd_config
```

Check SSH service:

```bash
sudo systemctl status ssh
```

On some distributions:

```bash
sudo systemctl status sshd
```

---

# 3. What Happens During an SSH Connection?

When I run:

```bash
ssh alice@192.168.1.100
```

the connection roughly works like this:

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

SSH provides:

### Confidentiality

The communication is encrypted.

### Integrity

SSH helps ensure that data is not silently modified in transit.

### Authentication

SSH verifies the identity of the communicating parties.

---

# 4. Password Authentication

Traditional SSH authentication uses a username and password.

Example:

```bash
ssh alice@192.168.1.100
```

The server may ask:

```text
alice@192.168.1.100's password:
```

The problem with passwords is that they can potentially be:

* Brute-forced
* Guessed
* Reused
* Phished
* Stolen
* Exposed through credential leaks

For infrastructure systems, public-key authentication is generally preferred.

---

# 5. Public-Key Authentication

SSH public-key authentication uses a key pair:

```text
Private Key
     +
Public Key
```

Example:

```text
id_ed25519
id_ed25519.pub
```

The private key stays on my machine.

The public key is installed on the server.

```text
Client                         Server

Private Key                    Public Key
id_ed25519                     authorized_keys
     |                               |
     |---- proves identity --------->|
     |                               |
     |<------ authentication -------|
```

---

# 6. Private Key vs Public Key

## Private Key

Example:

```text
~/.ssh/id_ed25519
```

The private key must remain secret.

Never upload it to:

* GitHub
* Discord
* Slack
* Email
* Public websites
* Public repositories

Never share:

```text
id_ed25519
```

---

## Public Key

Example:

```text
~/.ssh/id_ed25519.pub
```

The public key can be installed on servers.

It is stored in:

```text
~/.ssh/authorized_keys
```

---

# 7. RSA vs ECDSA vs Ed25519

SSH supports different key algorithms.

## RSA

Generate an RSA key:

```bash
ssh-keygen -t rsa
```

RSA is widely supported and useful for compatibility.

---

## ECDSA

Generate an ECDSA key:

```bash
ssh-keygen -t ecdsa
```

ECDSA uses elliptic-curve cryptography.

---

## Ed25519

Generate an Ed25519 key:

```bash
ssh-keygen -t ed25519
```

Ed25519 is a modern choice because it provides:

* Strong security
* Small keys
* Good performance
* Fast operations
* Simple configuration
* Wide OpenSSH support

For modern infrastructure:

> Prefer Ed25519 unless compatibility requirements require another algorithm.

---

# 8. Generate an Ed25519 Key

Command:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@host"
```

Example:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "kev@laptop"
```

The command creates:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

Check:

```bash
ls -la ~/.ssh
```

---

# 9. SSH Key Permissions

The SSH directory should be protected:

```bash
chmod 700 ~/.ssh
```

Private key:

```bash
chmod 600 ~/.ssh/id_ed25519
```

Public key:

```bash
chmod 644 ~/.ssh/id_ed25519.pub
```

Check:

```bash
ls -la ~/.ssh
```

Expected permissions are approximately:

```text
drwx------ ~/.ssh
-rw------- id_ed25519
-rw-r--r-- id_ed25519.pub
```

---

# 10. authorized_keys

On the server, authorized public keys are stored in:

```text
~/.ssh/authorized_keys
```

Example:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... user@host
```

The server checks whether the public key used by the client is authorized.

Think of it as:

```text
authorized_keys
│
├── Kevin's public key
├── Alice's public key
└── CI/CD server public key
```

---

# 11. Copy Public Key to a Server

The easiest method is:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 user@host
```

Example:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 alice@192.168.1.100
```

After the key has been copied:

```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```

---

# 12. Manual Public-Key Installation

If `ssh-copy-id` is not available:

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

On the server:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Edit:

```bash
nano ~/.ssh/authorized_keys
```

Paste the public key.

Then:

```bash
chmod 600 ~/.ssh/authorized_keys
```

---

# 13. Test Key Authentication

Use:

```bash
ssh -i ~/.ssh/id_ed25519 user@host
```

Example:

```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```

For debugging:

```bash
ssh -v -i ~/.ssh/id_ed25519 alice@192.168.1.100
```

For maximum SSH debugging:

```bash
ssh -vvv alice@192.168.1.100
```

`-v` is very useful for understanding why authentication fails.

---

# 14. SSH Client Configuration

Instead of repeatedly typing:

```bash
ssh -i ~/.ssh/id_ed25519 alice@192.168.1.100
```

I can create:

```text
~/.ssh/config
```

Example:

```sshconfig
Host myserver
    HostName 192.168.1.100
    User alice
    IdentityFile ~/.ssh/id_ed25519
```

Now I can simply use:

```bash
ssh myserver
```

SSH automatically knows:

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

---

# 15. Real Cloud Example

For an EC2 server:

```sshconfig
Host production
    HostName 10.0.2.15
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
```

Then:

```bash
ssh production
```

This becomes extremely useful when managing multiple servers.

---

# 16. SSH Server Configuration

The main SSH server configuration file is:

```text
/etc/ssh/sshd_config
```

Open it carefully:

```bash
sudo nano /etc/ssh/sshd_config
```

Before changing it, create a backup:

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

---

# 17. Disable Root SSH Login

Avoid direct root SSH login:

```text
PermitRootLogin no
```

Instead:

```text
SSH
 ↓
Normal User
 ↓
sudo
 ↓
Root Privileges
```

This provides better accountability and avoids exposing direct root login.

---

# 18. Disable Password Authentication

After verifying that SSH key authentication works:

```text
PasswordAuthentication no
```

This changes the authentication model to:

```text
Password Login      ❌
Public Key Login    ✅
```

IMPORTANT:

Do not disable password authentication until key-based login has been successfully tested.

Otherwise, I could lock myself out of the server.

---

# 19. Enable Public-Key Authentication

Set:

```text
PubkeyAuthentication yes
```

This allows SSH public-key authentication.

---

# 20. Change SSH Port

Default SSH port:

```text
22
```

Example custom port:

```text
Port 2222
```

Then connect using:

```bash
ssh -p 2222 user@host
```

Example:

```bash
ssh -p 2222 alice@192.168.1.100
```

Changing the port can reduce automated scanning noise, but it is not a replacement for proper authentication and firewall controls.

---

# 21. MaxAuthTries

Example:

```text
MaxAuthTries 3
```

This limits authentication attempts for a connection.

Conceptually:

```text
Attempt 1 → Failed
Attempt 2 → Failed
Attempt 3 → Failed
Connection terminated
```

This helps limit repeated authentication attempts.

---

# 22. MaxSessions

Example:

```text
MaxSessions 5
```

This controls the number of sessions that can be opened through a single network connection.

Remember:

```text
MaxAuthTries
    ↓
Authentication attempts

MaxSessions
    ↓
Sessions per connection
```

They control different things.

---

# 23. SSH Hardening Configuration

A basic hardened configuration can contain:

```text
Port 2222

PermitRootLogin no

PubkeyAuthentication yes

PasswordAuthentication no

MaxAuthTries 3

MaxSessions 5
```

Do not blindly copy security settings into production systems.

Always understand the current configuration and test changes safely.

---

# 24. Validate SSH Configuration

Before restarting SSH, run:

```bash
sudo sshd -t
```

If there is no output, the syntax is valid.

Check the exit code:

```bash
echo $?
```

Expected:

```text
0
```

This step is extremely important.

---

# 25. Why `sshd -t` Matters

Bad workflow:

```text
Edit configuration
       ↓
Restart SSH
       ↓
Configuration error
       ↓
SSH access may be lost
```

Better workflow:

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

This is an important infrastructure engineering habit.

---

# 26. Restart SSH

Depending on the distribution:

```bash
sudo systemctl restart ssh
```

or:

```bash
sudo systemctl restart sshd
```

Check status:

```bash
sudo systemctl status ssh
```

or:

```bash
sudo systemctl status sshd
```

---

# 27. Never Immediately Close Your Existing SSH Session

When modifying SSH remotely:

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

For example:

```bash
ssh -p 2222 user@host
```

Only close the original session after confirming the new configuration works.

---

# 28. Test Custom SSH Port

If:

```text
Port 2222
```

is configured:

```bash
ssh -p 2222 user@host
```

Example:

```bash
ssh -p 2222 alice@192.168.1.100
```

---

# 29. SSH Logs

SSH authentication events can be investigated using:

```bash
journalctl -u ssh
```

Follow logs in real time:

```bash
journalctl -u ssh -f
```

On systems using `/var/log/auth.log`:

```bash
sudo tail -f /var/log/auth.log
```

Look for messages such as:

```text
Accepted publickey for alice
```

or:

```text
Failed password for alice
```

or:

```text
Failed publickey for alice
```

Logs are extremely useful when troubleshooting SSH.

---

# 30. ssh-agent

If my private key has a passphrase, I don't want to repeatedly type that passphrase for every SSH connection.

`ssh-agent` can temporarily hold keys for the session.

Start the agent:

```bash
eval "$(ssh-agent -s)"
```

Add the key:

```bash
ssh-add ~/.ssh/id_ed25519
```

Check loaded keys:

```bash
ssh-add -l
```

Remove a specific key:

```bash
ssh-add -d ~/.ssh/id_ed25519
```

Remove all keys:

```bash
ssh-add -D
```

Mental model:

```text
Private Key
     ↓
ssh-agent
     ↓
SSH Connections
```

---

# 31. Bastion / Jump Host

A bastion host is a controlled server used to reach private systems.

Example:

```text
Internet
    |
    ↓
Bastion Host
    |
    ↓
Private Server
```

Cloud architecture:

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

The private server does not need to be directly accessible from the public Internet.

---

# 32. ProxyJump

SSH supports jump hosts using:

```sshconfig
ProxyJump
```

Example:

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

Now:

```bash
ssh private-server
```

SSH automatically performs:

```text
Laptop
   ↓
Bastion
   ↓
Private Server
```

This is an important cloud infrastructure pattern.

---

# 33. SSH Hardening Lab

## Step 1 — Generate Key

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@host"
```

Check:

```bash
ls -la ~/.ssh
```

Expected:

```text
id_ed25519
id_ed25519.pub
```

---

## Step 2 — Copy Public Key

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 user@host
```

Test:

```bash
ssh -i ~/.ssh/id_ed25519 user@host
```

---

## Step 3 — Configure SSH Client

Create:

```bash
nano ~/.ssh/config
```

Add:

```sshconfig
Host myserver
    HostName 192.168.1.100
    User alice
    IdentityFile ~/.ssh/id_ed25519
```

Test:

```bash
ssh myserver
```

---

## Step 4 — Backup SSH Server Configuration

On the server:

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

Check:

```bash
ls -l /etc/ssh/sshd_config*
```

---

## Step 5 — Harden SSH

Edit:

```bash
sudo nano /etc/ssh/sshd_config
```

Configure:

```text
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222
MaxAuthTries 3
MaxSessions 5
```

---

## Step 6 — Validate

Before restarting:

```bash
sudo sshd -t
```

Then:

```bash
echo $?
```

Expected:

```text
0
```

---

## Step 7 — Restart SSH

```bash
sudo systemctl restart ssh
```

Check:

```bash
sudo systemctl status ssh
```

---

## Step 8 — Test From Another Terminal

Keep the original session open.

From another terminal:

```bash
ssh -p 2222 alice@192.168.1.100
```

Verify that:

```text
Key authentication → Works
Password authentication → Disabled
Root SSH login → Disabled
```

---

## Step 9 — Check Logs

```bash
sudo journalctl -u ssh -n 50
```

Or:

```bash
sudo tail -n 50 /var/log/auth.log
```

---

# 34. Automation Project

## `setup_ssh_hardening.sh`

The goal is to create a script that:

1. Checks whether it is running with sufficient privileges
2. Backs up `sshd_config`
3. Applies SSH hardening
4. Validates the new configuration
5. Restores the backup if validation fails
6. Restarts SSH only after successful validation
7. Checks SSH service status
8. Prints a summary

Architecture:

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

---

# 35. Defensive Automation

Never blindly do:

```bash
modify_config
systemctl restart ssh
```

Better:

```bash
modify_config

if sshd -t; then
    systemctl restart ssh
else
    echo "Invalid SSH configuration"
    restore_backup
fi
```

The most important principle:

> Validate before restarting.

---

# 36. Cloud Infrastructure Connection

SSH is directly related to cloud infrastructure.

Typical architecture:

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

SSH keys can appear in:

* EC2 access
* Git
* CI/CD
* Bastion hosts
* Deployment systems
* Automation
* Configuration management
* Infrastructure administration

As infrastructure becomes more mature, other access systems can include:

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

---

# 37. Important SSH Commands

## Connect

```bash
ssh user@host
```

## Generate Ed25519 key

```bash
ssh-keygen -t ed25519
```

## Copy public key

```bash
ssh-copy-id user@host
```

## Connect using specific key

```bash
ssh -i ~/.ssh/id_ed25519 user@host
```

## Connect using custom port

```bash
ssh -p 2222 user@host
```

## Debug SSH

```bash
ssh -v user@host
```

## Detailed debugging

```bash
ssh -vvv user@host
```

## Add key to ssh-agent

```bash
ssh-add ~/.ssh/id_ed25519
```

## Validate SSH configuration

```bash
sudo sshd -t
```

## Restart SSH

```bash
sudo systemctl restart ssh
```

## Check SSH service

```bash
sudo systemctl status ssh
```

## View SSH logs

```bash
journalctl -u ssh
```

---

# 38. Key Files to Remember

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

---

# 39. SSH Authentication Mental Model

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

---

# 40. SSH Hardening Mental Model

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

---

# 41. Day 17 Challenge

Answer these questions without looking at the notes.

### Q1

What is the difference between:

```text
id_ed25519
```

and:

```text
id_ed25519.pub
```

### Q2

Where does the server store authorized public keys?

### Q3

What does this setting do?

```text
PasswordAuthentication no
```

### Q4

Why should I run:

```bash
sudo sshd -t
```

before:

```bash
sudo systemctl restart ssh
```

### Q5

What is the difference between:

```text
MaxAuthTries
```

and:

```text
MaxSessions
```

### Q6

What is a bastion host?

### Q7

Why should I keep my existing SSH session open while testing a new configuration?

### Q8

What is the purpose of:

```text
~/.ssh/config
```

### Q9

Why is Ed25519 commonly preferred for modern SSH keys?

### Q10

What is the difference between SSH client configuration and SSH server configuration?

---

# 42. What I Learned Today

Today I learned that SSH is much more than simply connecting to a remote machine.

I learned:

* SSH client and server architecture
* SSH encryption and authentication
* Password authentication
* Public-key authentication
* Private vs public keys
* RSA
* ECDSA
* Ed25519
* SSH key generation
* `authorized_keys`
* SSH key permissions
* `~/.ssh/config`
* `sshd_config`
* Root login hardening
* Password authentication hardening
* SSH port configuration
* `MaxAuthTries`
* `MaxSessions`
* SSH configuration validation
* SSH service management
* SSH logging
* `ssh-agent`
* Bastion hosts
* Jump hosts
* `ProxyJump`
* Defensive SSH automation

---

# 43. Key Lessons

### Lesson 1

Never share the SSH private key.

```text
Private Key = Secret
Public Key  = Can be distributed
```

### Lesson 2

Prefer Ed25519 for modern SSH deployments when supported.

### Lesson 3

Disable direct root SSH login.

```text
PermitRootLogin no
```

### Lesson 4

Use key-based authentication instead of passwords where appropriate.

```text
PasswordAuthentication no
```

### Lesson 5

Always validate SSH configuration before restarting.

```bash
sudo sshd -t
```

### Lesson 6

Keep an existing SSH session open while testing changes remotely.

### Lesson 7

Logs are essential for troubleshooting authentication.

```bash
journalctl -u ssh
```

### Lesson 8

Bastion hosts allow controlled access to private infrastructure.

---

# 44. Day 17 Summary

Today I moved from basic Linux user management and privilege escalation into secure remote administration.

The core SSH security model I learned is:

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

This is an important foundation for working with:

* Linux servers
* AWS EC2
* VPCs
* Bastion hosts
* Private subnets
* Docker hosts
* Kubernetes nodes
* CI/CD infrastructure
* Cloud automation

---

# 45. Progress

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

## Milestone

> **Day 213 / 1000 — SSH Hardening & Key-Based Authentication**

> **Day 17 / 30 — Linux Security, Users, SSH & Firewalls**

---

# 46. Final Takeaway

> **Secure infrastructure starts with secure access.**

Today I learned how to replace password-based SSH access with public-key authentication, protect the SSH server, validate configuration changes safely, monitor authentication activity, and understand bastion-based access.

The next step is to combine SSH security with network-level controls such as firewalls and packet filtering.

**1000 Days. 2 Hours Daily.**

**Build. Secure. Automate. Repeat.**

---

## Day 18 — Firewalls, UFW & Network Filtering
Today is important for cloud infrastructure because a server without network filtering is like a house with every door open. In AWS, this connects directly to **Security Groups, NACLs, private/public subnets, and defense in depth**.

---

## 1. What is a Firewall?

A **firewall** controls network traffic entering or leaving a machine.

Imagine your Linux server has these ports:

```text
22    → SSH
80    → HTTP
443   → HTTPS
3306  → MySQL
8080  → Application
```

Without filtering:

```text
Internet
   │
   ├──→ 22
   ├──→ 80
   ├──→ 443
   ├──→ 3306
   └──→ 8080
```

A firewall lets you decide:

```text
Internet
   │
   ├──→ 22    ✅ Allowed
   ├──→ 80    ✅ Allowed
   ├──→ 443   ✅ Allowed
   ├──→ 3306  ❌ Blocked
   └──→ 8080  ❌ Blocked
```

### The basic firewall question

For every connection:

> **Should this traffic be allowed or denied?**

---

# 2. Stateful vs Stateless Firewalls

This is an important infrastructure concept.

## Stateless

A stateless firewall looks at each packet independently.

For example:

```text
Packet → Source IP → Destination IP → Port → Protocol
```

It doesn't necessarily remember previous connections.

---

## Stateful

A stateful firewall remembers connections.

Suppose:

```text
Client → Server
```

The server responds:

```text
Server → Client
```

A stateful firewall understands that the response belongs to an existing connection.

Conceptually:

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

The firewall tracks this connection state.

This is why **stateful filtering** is extremely common in modern infrastructure.

---

# 3. Netfilter

Now we go one layer deeper.

Linux has a packet-filtering framework called:

**Netfilter**

It operates inside the Linux kernel.

Conceptually:

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

Tools such as:

```text
iptables
nftables
UFW
```

interact with Linux's packet-filtering capabilities.

---

# 4. iptables

You may hear:

```bash
iptables
```

a lot in Linux administration.

It is a powerful firewall administration tool.

Example:

```bash
sudo iptables -L
```

This lists rules.

But raw `iptables` rules can become complicated.

For example:

```text
iptables
   ↓
Powerful
   ↓
Complex
```

This is where UFW comes in.

---

# 5. What is UFW?

UFW means:

> **Uncomplicated Firewall**

It provides a much simpler interface for managing firewall rules.

Instead of complicated firewall commands, you can write:

```bash
sudo ufw allow 22/tcp
```

Meaning:

> Allow TCP traffic to port 22.

Think:

```text
UFW
 ↓
Simpler firewall management
 ↓
Linux firewall infrastructure
```

---

# 6. First Command — Check Firewall Status

Run:

```bash
sudo ufw status
```

You might see:

```text
Status: inactive
```

or:

```text
Status: active
```

For more detail:

```bash
sudo ufw status verbose
```

Example:

```text
Status: active

Logging: on
Default: deny (incoming), allow (outgoing)
```

---

# 7. ⚠️ VERY IMPORTANT — SSH Lockout

This is one of today's most important lessons.

Imagine you're connected to a remote server through SSH:

```text
Your Laptop
     │
     │ SSH
     ▼
  Server
```

Then you execute:

```bash
sudo ufw default deny incoming
sudo ufw enable
```

You just told the firewall:

> Block incoming connections.

Your SSH connection may be terminated.

You could lose access to the server.

Therefore:

## ALWAYS allow SSH before enabling the firewall.

```bash
sudo ufw allow 22/tcp
```

Then:

```bash
sudo ufw enable
```

For a remote cloud server:

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

This is an operational safety principle you'll use in real infrastructure.

---

# 8. Default Policies

A firewall should have sensible defaults.

For example:

```bash
sudo ufw default deny incoming
```

This means:

> Incoming traffic is denied unless explicitly allowed.

And:

```bash
sudo ufw default allow outgoing
```

This means:

> Outgoing traffic is allowed by default.

So your baseline becomes:

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

This is a common **default-deny** security model.

---

# 9. Allow SSH

SSH normally uses:

```text
TCP 22
```

Allow it:

```bash
sudo ufw allow 22/tcp
```

You can also use the UFW application profile:

```bash
sudo ufw allow 'OpenSSH'
```

Check available application profiles:

```bash
sudo ufw app list
```

You might see:

```text
Available applications:

  OpenSSH
  Nginx Full
  Apache
```

This is useful because you don't always need to remember individual ports.

---

# 10. Allow HTTP

HTTP uses:

```text
TCP 80
```

Allow:

```bash
sudo ufw allow 80/tcp
```

Now:

```text
Internet
   │
   ▼
Port 80
   │
   ▼
Web Server
```

---

# 11. Allow HTTPS

HTTPS normally uses:

```text
TCP 443
```

Allow:

```bash
sudo ufw allow 443/tcp
```

Now a typical web server might have:

```text
22   → SSH
80   → HTTP
443  → HTTPS
```

---

# 12. Why Not Allow Everything?

You might be tempted to do something like:

```bash
sudo ufw allow 1:65535/tcp
```

That would expose essentially every TCP port.

Bad idea.

Instead:

```text
Required services only
        ↓
Explicitly allow them
        ↓
Everything else
        ↓
Blocked
```

This is called:

> **Least privilege**

You learned this concept earlier with users and sudo.

Today we're applying the same principle to networking.

---

# 13. Denying a Specific IP

Suppose:

```text
192.168.1.50
```

is an unwanted source.

You can deny it:

```bash
sudo ufw deny from 192.168.1.50
```

Conceptually:

```text
192.168.1.50
      │
      ▼
   FIREWALL
      │
      X
    DENIED
```

---

# 14. Allow From a Specific IP

You can also restrict access.

For example:

```bash
sudo ufw allow from 192.168.1.100 to any port 22 proto tcp
```

Meaning:

> Only this IP can access SSH.

This is much more restrictive than:

```bash
sudo ufw allow 22/tcp
```

because the second allows SSH from anywhere.

---

# 15. Rate Limiting SSH

SSH is frequently targeted by automated login attempts.

UFW provides:

```bash
sudo ufw limit 22/tcp
```

This provides rate limiting for SSH connections.

Conceptually:

```text
Normal SSH usage
       ↓
     Allow

Rapid repeated connections
       ↓
     Limit
```

This helps reduce brute-force connection attempts.

Important:

> Rate limiting is not a replacement for strong authentication and SSH hardening.

That's why yesterday's lesson on SSH key authentication connects directly with today's firewall lesson.

---

# 16. UFW Rule Inspection

Check current rules:

```bash
sudo ufw status
```

More detailed:

```bash
sudo ufw status verbose
```

Show rules in numbered form:

```bash
sudo ufw status numbered
```

Example:

```text
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW       Anywhere
[ 2] 80/tcp                     ALLOW       Anywhere
[ 3] 443/tcp                    ALLOW       Anywhere
```

The numbers are useful when deleting rules.

---

# 17. Delete a Rule

Suppose:

```bash
sudo ufw allow 8080/tcp
```

was accidentally added.

You can remove it:

```bash
sudo ufw delete allow 8080/tcp
```

Or using the numbered rule:

```bash
sudo ufw status numbered
```

Then:

```bash
sudo ufw delete 3
```

Be careful with numbered deletion because the rule numbers can change after each deletion.

---

# 18. UFW Logging

Firewall logs are extremely useful for troubleshooting.

Enable logging:

```bash
sudo ufw logging on
```

Check:

```bash
sudo ufw status verbose
```

You may see:

```text
Logging: on
```

On Ubuntu systems, UFW-related logs are commonly available through:

```bash
/var/log/ufw.log
```

You can inspect:

```bash
sudo tail /var/log/ufw.log
```

Follow the log live:

```bash
sudo tail -f /var/log/ufw.log
```

You may see blocked packets containing information such as:

```text
SRC=192.168.1.50
DST=192.168.1.10
PROTO=TCP
SPT=...
DPT=22
```

This starts teaching you how to investigate network events.

---

# 19. Understanding a Firewall Log

Imagine:

```text
SRC=203.0.113.50
DST=10.0.0.10
PROTO=TCP
DPT=22
```

Break it down:

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

So:

```text
203.0.113.50
      │
      │ TCP → port 22
      ▼
10.0.0.10
```

This is exactly the kind of information you'll use when troubleshooting cloud networking.

---

# 20. TCP vs UDP

Firewalls often distinguish between protocols.

TCP:

```bash
sudo ufw allow 443/tcp
```

UDP:

```bash
sudo ufw allow 53/udp
```

Why?

Because TCP and UDP behave differently.

### TCP

Connection-oriented:

```text
SYN
 ↓
SYN-ACK
 ↓
ACK
 ↓
DATA
```

### UDP

Connectionless:

```text
Packet
  ↓
Send
```

DNS is a classic example where UDP is commonly used.

---

# 21. Port ≠ Application

This is an important infrastructure distinction.

Port:

```text
443
```

doesn't magically mean HTTPS.

It is simply a network endpoint.

Usually:

```text
443
 ↓
HTTPS service
```

because web servers commonly listen there.

Similarly:

```text
22
 ↓
SSH
```

because SSH commonly listens there.

But technically services can listen on different ports.

For example:

```text
SSH → 2222
```

is possible.

---

# 22. Your First Firewall Lab

Let's build a safe practice configuration.

### Step 1

Check status:

```bash
sudo ufw status verbose
```

### Step 2

Set defaults:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Step 3

Allow SSH:

```bash
sudo ufw allow 22/tcp
```

### Step 4

Allow HTTP:

```bash
sudo ufw allow 80/tcp
```

### Step 5

Allow HTTPS:

```bash
sudo ufw allow 443/tcp
```

### Step 6

Enable:

```bash
sudo ufw enable
```

### Step 7

Verify:

```bash
sudo ufw status verbose
```

Expected conceptually:

```text
Status: active

Default:
deny incoming
allow outgoing

22/tcp   ALLOW
80/tcp   ALLOW
443/tcp  ALLOW
```

---

# 23. Production Thinking

Now imagine you're deploying:

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

You probably want:

```text
22  → SSH
80  → HTTP
443 → HTTPS
```

But suppose the server also has:

```text
3306 → MySQL
6379 → Redis
8080 → Internal API
```

Should these automatically be exposed?

**No.**

A better architecture might be:

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

The database doesn't need to be publicly accessible simply because the application needs it.

---

# 24. This Connects Directly to AWS

This is where today's lesson becomes important for your **AI Cloud Infrastructure Engineer** goal.

On Linux:

```text
UFW
 ↓
Host-level firewall
```

In AWS:

```text
Security Group
 ↓
Instance/network interface-level filtering
```

And:

```text
Network ACL
 ↓
Subnet-level filtering
```

Conceptually:

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

This is **defense in depth**.

---

# 25. Defense in Depth

Don't rely on a single security layer.

Think:

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

Not every architecture needs every layer, but the principle is:

> **If one security layer fails, another layer can still provide protection.**

---

# 26. Hands-On Project — `basic_firewall.sh`

Now let's turn today's theory into automation.

Create:

```bash
nano basic_firewall.sh
```

Use:

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

Make it executable:

```bash
chmod +x basic_firewall.sh
```

Run:

```bash
sudo ./basic_firewall.sh
```

---

# 27. Let's Understand the Script

## `set -e`

```bash
set -e
```

Means:

> Stop the script if a command fails.

This is useful for infrastructure automation because you don't want the script silently continuing after an important configuration command fails.

---

## Root check

```bash
if [[ $EUID -ne 0 ]]; then
```

Firewall configuration requires administrative privileges.

So:

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

---

# 28. Make the Script Configurable

A better infrastructure script shouldn't hard-code everything.

You could eventually define:

```bash
SSH_PORT=22
HTTP_PORT=80
HTTPS_PORT=443
APP_PORT=8080
```

Then:

```bash
ufw allow "$SSH_PORT"/tcp
ufw allow "$HTTP_PORT"/tcp
ufw allow "$HTTPS_PORT"/tcp
```

This starts moving you toward **configuration-driven infrastructure**.

That concept will become very important when you reach:

```text
Terraform
Ansible
Kubernetes
CI/CD
Cloud automation
```

---

# 29. Production Firewall Document

Your second deliverable is:

> **Firewall Rules for Production**

Imagine you have a production web server.

Your policy could look like:

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

The security principle is:

```text
Explicitly needed
      ↓
ALLOW

Everything else
      ↓
DENY
```

---

# 30. Your Day 18 Challenge

Don't just copy the commands.

Try this yourself.

### Challenge 1

Find the firewall status:

```bash
sudo ufw status verbose
```

---

### Challenge 2

Find available application profiles:

```bash
sudo ufw app list
```

---

### Challenge 3

Set:

```text
Incoming → DENY
Outgoing → ALLOW
```

---

### Challenge 4

Allow:

```text
SSH
HTTP
HTTPS
```

---

### Challenge 5

Enable logging:

```bash
sudo ufw logging on
```

---

### Challenge 6

Find your rules:

```bash
sudo ufw status numbered
```

---

### Challenge 7

Add a temporary test rule:

```bash
sudo ufw allow 8080/tcp
```

Then remove it:

```bash
sudo ufw delete allow 8080/tcp
```

---

### Challenge 8

Try:

```bash
sudo ufw limit 22/tcp
```

Then inspect the rules.

---

# 31. Mini Quiz

Before moving on, answer these without looking back:

### Q1

What does:

```bash
sudo ufw default deny incoming
```

do?

### Q2

Why should you allow SSH **before** enabling UFW on a remote server?

### Q3

What port does SSH normally use?

### Q4

What ports are commonly used for HTTP and HTTPS?

### Q5

What's the difference between:

```bash
ufw allow 22/tcp
```

and:

```bash
ufw limit 22/tcp
```

### Q6

What is Netfilter?

### Q7

Why is default-deny useful?

### Q8

What does defense in depth mean?

---

# 32. The Cloud Engineer Mental Model

Today's lesson isn't really about memorizing:

```bash
ufw allow 22
ufw allow 80
ufw allow 443
```

The real lesson is:

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

And in production:

```text
             Default DENY
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
       SSH       HTTP      HTTPS
        │         │         │
      ALLOW     ALLOW      ALLOW
```

This is the mindset you need when designing infrastructure.

---

# Day 18 Deliverables

By the end of today's **3 hours**, you should have:

```text
Day 18/
│
├── basic_firewall.sh
│
└── firewall-rules-for-production.md
```

And your GitHub daily log:

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

### The key sentence for today:

> **A secure server doesn't ask “what should I block?” first — it asks “what absolutely needs to be reachable?”**

Tomorrow, you're ready to build on this with **Linux networking diagnostics and troubleshooting**—where you'll start thinking like someone debugging an actual cloud network rather than just administering a Linux machine.

---

## Day 19 / 30 — File Integrity & Auditd
**Day 215 / 1000 — AI Cloud Infrastructure Engineer Journey**

> **Theme:** "Don't just secure the system. Know what happened."

---

## 📅 Day Information

* **Linux Mastery:** Day 19 / 30
* **1000-Day Journey:** Day 215 / 1000
* **Topic:** File Integrity & Auditd
* **Focus:** Linux auditing, system-call monitoring, file monitoring, audit investigation
* **Goal:** Learn how Linux records security-relevant activity and build persistent audit rules.

---

# 1. What is File Integrity Monitoring?

File Integrity Monitoring (FIM) is the process of detecting changes to important files.

For example, a Linux server may contain:

```text
/etc/passwd
/etc/shadow
/etc/group
/etc/sudoers
/etc/ssh/sshd_config
```

These files are security-sensitive.

If someone modifies them, we want to know:

```text
WHO changed it?
WHEN did they change it?
WHAT happened?
WHICH process performed the action?
```

File integrity monitoring helps detect unexpected modifications.

---

# 2. AIDE vs Tripwire vs auditd

These tools have related but different purposes.

## AIDE

AIDE stands for:

```text
Advanced Intrusion Detection Environment
```

AIDE primarily detects changes to files by maintaining a baseline.

Conceptually:

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

Example:

```text
/etc/ssh/sshd_config

Original hash:
ABC123

Current hash:
XYZ789

Result:
FILE CHANGED
```

---

## Tripwire

Tripwire is another file-integrity monitoring system.

It can maintain a baseline and detect changes to monitored files.

Conceptually:

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

---

## auditd

`auditd` has a broader purpose.

Instead of only asking:

```text
"Did this file change?"
```

auditd can answer questions such as:

```text
What activity happened?
Which user performed it?
Which process was involved?
When did it happen?
Which system call occurred?
```

Think of it like this:

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

These technologies can complement each other.

---

# 3. What is auditd?

`auditd` is the Linux Audit daemon.

It collects security-related audit events generated by the Linux kernel and records them.

Basic architecture:

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

The important idea is:

> auditd creates an evidence trail of security-relevant activity.

---

# 4. Why auditd Matters

Imagine a production Linux server.

Someone changes:

```text
/etc/ssh/sshd_config
```

Without auditing, you might only know:

```text
The configuration changed.
```

With auditing, you can potentially investigate:

```text
When?
Who?
Which UID?
Which process?
What operation?
What executable?
```

This makes audit logs useful for:

* Security investigations
* Incident response
* Troubleshooting
* Change tracking
* Compliance evidence
* Forensics
* Monitoring privileged activity

---

# 5. Linux System Calls

One of the most important concepts today is the **system call**.

Applications normally interact with the Linux kernel through system calls.

Conceptually:

```text
Application
     │
     │ system call
     ▼
Linux Kernel
```

Examples include:

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

These operations allow programs to interact with system resources.

---

# 6. What is execve()?

`execve()` is a Linux system call associated with executing a program.

For example, when a user runs:

```bash
whoami
```

or:

```bash
ls
```

the operating system performs process-execution operations.

An audit rule can monitor execution activity using:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```

Break it down:

```text
-a always,exit
```

Add a rule that evaluates the event on system-call exit.

```text
-F arch=b64
```

Filter for 64-bit architecture.

```text
-S execve
```

Monitor the `execve` system call.

```text
-k exec
```

Give the rule the searchable key:

```text
exec
```

Later we can search:

```bash
sudo ausearch -k exec
```

---

# 7. Audit Rules

Audit rules tell auditd what activity to monitor.

Important options:

```text
-w
-p
-k
```

---

## `-w` — Watch

`-w` tells auditd to watch a file or path.

Example:

```bash
-w /etc/passwd
```

This means:

```text
Watch /etc/passwd
```

---

## `-p` — Permissions

`-p` specifies the types of access/events we are interested in.

Example:

```bash
-p wa
```

Where:

```text
w = write
a = attribute change
```

Therefore:

```bash
-w /etc/passwd -p wa
```

means:

> Monitor `/etc/passwd` for writes and attribute changes.

---

## `-k` — Key

`-k` assigns a searchable name to the rule.

Example:

```bash
-k passwd_modifications
```

Now we can search for events associated with that rule:

```bash
sudo ausearch -k passwd_modifications
```

This becomes very useful when many audit rules exist.

---

# 8. First Audit Rule

Start auditd:

```bash
sudo systemctl start auditd
```

Check its status:

```bash
sudo systemctl status auditd
```

Enable it:

```bash
sudo systemctl enable auditd
```

Add a rule:

```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_modifications
```

List the rules:

```bash
sudo auditctl -l
```

You should see something similar to:

```text
-w /etc/passwd -p wa -k passwd_modifications
```

---

# 9. Understanding the Rule

Consider:

```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_modifications
```

Breakdown:

```text
sudo
```

Run with administrator privileges.

```text
auditctl
```

Manage Linux audit rules.

```text
-w /etc/passwd
```

Watch `/etc/passwd`.

```text
-p wa
```

Monitor:

```text
w = write
a = attribute change
```

```text
-k passwd_modifications
```

Assign a searchable key.

---

# 10. Testing a File Watch

For a safe lab, create a test file:

```bash
sudo touch /tmp/audit-demo
```

Add an audit rule:

```bash
sudo auditctl -w /tmp/audit-demo -p wa -k audit_demo
```

Verify:

```bash
sudo auditctl -l
```

Modify the file:

```bash
echo "Day 215 audit test" | sudo tee -a /tmp/audit-demo
```

Now search:

```bash
sudo ausearch -k audit_demo
```

You should see audit events associated with the modification.

---

# 11. Audit Logs

Audit logs are normally stored under:

```text
/var/log/audit/
```

Check:

```bash
sudo ls -lah /var/log/audit/
```

You may see:

```text
audit.log
```

You can inspect the raw log:

```bash
sudo less /var/log/audit/audit.log
```

However, manually reading huge audit logs is inconvenient.

Instead, use:

```text
ausearch
aureport
```

---

# 12. ausearch

`ausearch` means:

```text
Audit Search
```

It is used to search audit events.

Search by key:

```bash
sudo ausearch -k audit_demo
```

Search today's events:

```bash
sudo ausearch -ts today
```

Search events associated with an executable:

```bash
sudo ausearch -x /usr/bin/sudo
```

Search password-related modifications:

```bash
sudo ausearch -k passwd_modifications
```

Think:

```text
audit.log
    ↓
 ausearch
    ↓
Specific events
```

---

# 13. aureport

`aureport` generates summarized reports from audit logs.

Run:

```bash
sudo aureport
```

It can provide summaries related to areas such as:

```text
Authentication
Login activity
Executable activity
File activity
User authentication
System activity
```

Think:

```text
ausearch
    ↓
Investigate specific events

aureport
    ↓
Generate summaries
```

---

# 14. File Monitoring vs System Call Monitoring

This distinction is important.

## File Monitoring

Example:

```bash
sudo auditctl -w /etc/passwd -p wa -k identity
```

Question:

```text
"What happened to this file?"
```

---

## System Call Monitoring

Example:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```

Question:

```text
"What happened when this system call was executed?"
```

Therefore:

```text
File rule
    ↓
WHAT FILE?

System-call rule
    ↓
WHAT KERNEL OPERATION?
```

---

# 15. Important Security Files to Monitor

Some security-sensitive files include:

```text
/etc/passwd
/etc/group
/etc/shadow
/etc/sudoers
/etc/ssh/sshd_config
```

Why?

---

## `/etc/passwd`

Contains account information such as:

```text
username
UID
GID
home directory
login shell
```

Unexpected modifications may indicate account-management activity.

---

## `/etc/group`

Contains group membership information.

Changes can affect authorization.

---

## `/etc/shadow`

Contains password hashes and password-aging information.

This is highly sensitive.

---

## `/etc/sudoers`

Controls sudo privileges.

Changes can affect privilege escalation.

---

## `/etc/ssh/sshd_config`

Controls SSH server configuration.

Changes can affect remote access.

---

# 16. Example Security Rules

Example rules for a lab:

```text
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k privilege
-w /etc/ssh/sshd_config -p wa -k ssh_config
```

Now we can search by category.

Identity:

```bash
sudo ausearch -k identity
```

Privilege:

```bash
sudo ausearch -k privilege
```

SSH configuration:

```bash
sudo ausearch -k ssh_config
```

This demonstrates why meaningful audit keys are important.

---

# 17. System Call Monitoring

Add an execution-monitoring rule:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```

Check:

```bash
sudo auditctl -l
```

Run some commands:

```bash
whoami
```

```bash
id
```

```bash
ls
```

Now search:

```bash
sudo ausearch -k exec
```

Conceptually:

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

---

# 18. Why Broad execve Monitoring Can Be Expensive

Monitoring every execution event can generate a large amount of audit data on busy systems.

Conceptually:

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

Therefore:

> More logging is not automatically better logging.

Production audit rules should be designed around specific security and operational requirements.

For today's lab, broad `execve` monitoring is useful for learning.

---

# 19. Runtime vs Persistent Rules

When you run:

```bash
sudo auditctl -w /etc/passwd -p wa -k identity
```

you are adding a rule to the current running audit configuration.

This is useful for testing.

However, production systems need persistent configuration.

Audit rules are commonly stored under:

```text
/etc/audit/rules.d/
```

Inspect the directory:

```bash
sudo ls -la /etc/audit/rules.d/
```

Inspect existing rules:

```bash
sudo cat /etc/audit/rules.d/*.rules
```

Do not blindly overwrite distribution-managed rules.

---

# 20. Persistent Audit Rules

A persistent rules file can contain entries such as:

```text
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k privilege
-w /etc/ssh/sshd_config -p wa -k ssh_config
```

After configuring persistent rules, verify that your distribution's audit rule-loading mechanism recognizes them.

Check the active configuration:

```bash
sudo auditctl -l
```

The exact reload behavior can vary by distribution and audit setup.

---

# 21. Compliance and Audit Trails

Security frameworks and regulations can require organizations to maintain appropriate logging and audit trails.

Examples include:

```text
PCI DSS
HIPAA
SOC 2
ISO 27001
```

The important engineering concept is:

```text
Who accessed the system?
When?
What changed?
What privileged action occurred?
Can we investigate it later?
```

However:

```text
auditd installed
     ≠
automatically compliant
```

Compliance usually involves multiple controls, including areas such as:

```text
Access control
Logging
Monitoring
Retention
Incident response
Documentation
Configuration management
```

Auditd is one component of a broader security and compliance strategy.

---

# 22. Cloud Infrastructure Connection

The Linux skills you're learning directly connect to cloud infrastructure.

Consider an EC2 instance:

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

At the AWS level, you may later encounter:

```text
IAM
CloudTrail
CloudWatch
VPC Flow Logs
GuardDuty
```

The concepts connect:

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

The broader infrastructure mindset is:

> Know what happened at every important layer.

---

# 23. Day 19 Hands-On Lab

## Step 1 — Identify your Linux distribution

```bash
cat /etc/os-release
```

---

## Step 2 — Check auditctl

```bash
auditctl -v
```

---

## Step 3 — Install auditd if required

For Debian/Ubuntu:

```bash
sudo apt update
sudo apt install auditd audispd-plugins
```

---

## Step 4 — Check auditd

```bash
sudo systemctl status auditd
```

---

## Step 5 — Start auditd

```bash
sudo systemctl start auditd
```

---

## Step 6 — Enable auditd

```bash
sudo systemctl enable auditd
```

---

## Step 7 — Create a test file

```bash
sudo touch /tmp/audit-demo
```

---

## Step 8 — Add an audit rule

```bash
sudo auditctl -w /tmp/audit-demo -p wa -k audit_demo
```

---

## Step 9 — List rules

```bash
sudo auditctl -l
```

---

## Step 10 — Modify the file

```bash
echo "Day 215 audit test" | sudo tee -a /tmp/audit-demo
```

---

## Step 11 — Search the event

```bash
sudo ausearch -k audit_demo
```

---

## Step 12 — Generate a report

```bash
sudo aureport
```

---

# 24. Execution Monitoring Lab

Add:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec
```

Run:

```bash
whoami
```

```bash
id
```

```bash
ls
```

Search:

```bash
sudo ausearch -k exec
```

Observe how command execution produces audit events.

---

# 25. Day 19 Project

## Project Name

```text
Audit Rules Deployment
```

Create:

```text
deploy_audit_rules.sh
```

The script should:

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

---

# 26. Recommended Project Structure

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

---

# 27. What We Are Auditing and Why

Create:

```text
notes/what-we-are-auditing-and-why.md
```

Document the purpose of each rule.

Example:

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

Also document:

```text
Why the event matters
What key is used
How to search for it
How the event can be investigated
```

---

# 28. Troubleshooting

## auditctl command not found

Check:

```bash
which auditctl
```

Install the audit package appropriate for your distribution.

---

## auditd isn't running

Check:

```bash
sudo systemctl status auditd
```

Then inspect:

```bash
sudo journalctl -u auditd
```

---

## No results from ausearch

First verify:

```bash
sudo auditctl -l
```

Then generate the event again.

For example:

```bash
echo "test" | sudo tee -a /tmp/audit-demo
```

Then:

```bash
sudo ausearch -k audit_demo
```

---

# 29. Important Commands

| Command                   | Purpose                     |
| ------------------------- | --------------------------- |
| `auditctl -l`             | List active audit rules     |
| `auditctl -w`             | Watch a file/path           |
| `auditctl -a`             | Add an audit rule           |
| `ausearch`                | Search audit events         |
| `aureport`                | Generate audit reports      |
| `systemctl status auditd` | Check auditd status         |
| `journalctl -u auditd`    | View auditd service logs    |
| `ls /var/log/audit/`      | Inspect audit log directory |

---

# 30. Key Concepts to Remember

## auditd

Linux audit daemon.

```text
System activity
     ↓
auditd
     ↓
Audit records
```

---

## auditctl

Used to manage active audit rules.

```bash
sudo auditctl -l
```

---

## ausearch

Used for investigation.

```bash
sudo ausearch -k identity
```

---

## aureport

Used for summaries.

```bash
sudo aureport
```

---

## `-w`

Watch a path.

```text
-w /etc/passwd
```

---

## `-p`

Specify permissions/events.

```text
-p wa
```

---

## `-k`

Assign a searchable key.

```text
-k identity
```

---

# 31. Security Architecture Progress

Your Linux security journey is now building a clear architecture:

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

This is the important progression.

---

# 32. Day 19 Mastery Checklist

Before marking Day 19 complete, I should be able to explain:

* [ ] What file integrity monitoring means
* [ ] Difference between AIDE, Tripwire, and auditd
* [ ] What auditd does
* [ ] What a Linux system call is
* [ ] What `execve()` does
* [ ] What `auditctl` does
* [ ] What `-w` means
* [ ] What `-p` means
* [ ] What `wa` means
* [ ] What `-k` means
* [ ] How to list audit rules
* [ ] How to search events using `ausearch`
* [ ] How to generate reports using `aureport`
* [ ] Where audit logs are stored
* [ ] Difference between runtime and persistent rules
* [ ] Why `/etc/passwd` matters
* [ ] Why `/etc/shadow` matters
* [ ] Why `/etc/sudoers` matters
* [ ] Why SSH configuration should be monitored
* [ ] Why broad logging can create large volumes of data
* [ ] How auditd connects to cloud security concepts

---

# 33. Final Mental Model

Remember:

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

---

# 🧠 Day 19 One-Sentence Rule

> **auditd turns important Linux activity into an evidence trail that can be searched, investigated, and analyzed.**

---

# Day 19 Completion

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

---

## Resources

### Linux Manual Pages

```bash
man auditctl
man ausearch
man aureport
man auditd
man auditd.conf
```

### Useful directories

```text
/etc/audit/
/etc/audit/rules.d/
/var/log/audit/
```

### Core commands

```bash
sudo auditctl -l
sudo ausearch -k <key>
sudo aureport
sudo systemctl status auditd
sudo journalctl -u auditd
```

---

## Day 20 — Backups & Disaster Recovery
---

## 🎯 Objective



# 1. Backup Fundamentals

A backup is a separate copy of data that can be used to recover from:

* Accidental deletion
* Hardware failure
* Data corruption
* Ransomware
* Configuration mistakes
* Server failure
* Human error
* Disaster

The most important concept:

> A backup is only useful if it can actually be restored.

---

# 2. Full, Incremental & Differential Backups

## Full Backup

A full backup copies everything.

Example:

```text
Monday:
A B C D

Tuesday:
A B C D E

Wednesday:
A B C D E F
```

Each full backup contains all data.

### Advantages

* Simple
* Easy to restore
* Self-contained

### Disadvantages

* Uses more storage
* Takes longer
* Requires more bandwidth

---

## Incremental Backup

An incremental backup stores changes since the **previous backup**.

Example:

```text
Monday:
FULL → A B C D

Tuesday:
INCREMENTAL → E

Wednesday:
INCREMENTAL → F
```

To restore Wednesday:

```text
Monday FULL
+
Tuesday INCREMENTAL
+
Wednesday INCREMENTAL
```

### Advantages

* Smaller backups
* Faster backups
* Less storage usage

### Disadvantages

* Restore process is more complicated
* Backup chain can become important

---

## Differential Backup

A differential backup stores changes since the **last full backup**.

Example:

```text
Monday:
FULL → A B C D

Tuesday:
DIFFERENTIAL → E

Wednesday:
DIFFERENTIAL → E F
```

To restore Wednesday:

```text
Monday FULL
+
Wednesday DIFFERENTIAL
```

### Remember

```text
FULL
= Everything

INCREMENTAL
= Changes since previous backup

DIFFERENTIAL
= Changes since last full backup
```

---

# 3. The 3-2-1 Backup Rule

The classic 3-2-1 rule means:

```text
3 copies of your data
2 different media/types
1 copy stored off-site
```

Example:

```text
                 Original
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Local Backup        Off-site Backup
```

A possible infrastructure setup:

```text
Server
  │
  ├── Local backup
  │
  └── Cloud/Object Storage
```

The purpose of an off-site copy is to protect against disasters that can affect both the primary system and local backup.

Examples:

* Fire
* Flood
* Theft
* Physical destruction
* Major infrastructure failure

---

# 4. `tar`

`tar` is commonly used to create archives.

## Create a compressed backup

```bash
tar -czf backup_$(date +%F).tar.gz /home/user/data
```

### Options

```text
-c
Create archive

-z
Compress using gzip

-f
Specify archive filename
```

Example output:

```text
backup_2026-10-03.tar.gz
```

---

# 5. List Archive Contents

You don't need to extract an archive to inspect it.

```bash
tar -tzf backup_2026-10-03.tar.gz
```

Show only the first few entries:

```bash
tar -tzf backup_2026-10-03.tar.gz | head
```

### Options

```text
-t
List contents

-z
gzip compression

-f
Archive file
```

---

# 6. Extract a Backup

Create a restore directory:

```bash
mkdir -p /tmp/restore_test
```

Extract:

```bash
tar -xzf backup_2026-10-03.tar.gz -C /tmp/restore_test
```

### Options

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

---

# 7. Create the Backup Lab

Do not experiment on important production data.

Create a safe laboratory:

```bash
mkdir -p ~/backup-lab/source
mkdir -p ~/backup-lab/backups
mkdir -p ~/backup-lab/restore
mkdir -p ~/backup-lab/logs
mkdir -p ~/backup-lab/offsite
```

Create test files:

```bash
echo "Linux backup test" > ~/backup-lab/source/file1.txt
echo "Day 216" > ~/backup-lab/source/file2.txt
```

Check:

```bash
find ~/backup-lab/source -type f -print
```

---

# 8. Create the First Backup

```bash
tar -czf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
~/backup-lab/source
```

Check:

```bash
ls -lh ~/backup-lab/backups
```

---

# 9. Verify the Archive

List the contents:

```bash
tar -tzf ~/backup-lab/backups/backup_$(date +%F).tar.gz
```

If the files appear, the archive contains the expected data.

---

# 10. Restore the Backup

Extract:

```bash
tar -xzf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
-C ~/backup-lab/restore
```

Check:

```bash
find ~/backup-lab/restore -type f -print
```

---

# 11. Disaster Recovery Simulation

Create a test project:

```bash
mkdir -p ~/backup-lab/source/project
```

Create a file:

```bash
echo "production configuration" \
> ~/backup-lab/source/project/config.txt
```

Run a backup:

```bash
tar -czf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
~/backup-lab/source
```

Now simulate a disaster:

```bash
rm ~/backup-lab/source/project/config.txt
```

Verify:

```bash
ls ~/backup-lab/source/project
```

The file is gone.

Now restore:

```bash
rm -rf ~/backup-lab/restore/*
```

```bash
tar -xzf ~/backup-lab/backups/backup_$(date +%F).tar.gz \
-C ~/backup-lab/restore
```

Find the restored file:

```bash
find ~/backup-lab/restore -name config.txt
```

Read it:

```bash
find ~/backup-lab/restore \
-name config.txt \
-exec cat {} \;
```

This is a basic disaster recovery drill.

---

# 12. `rsync`

`rsync` synchronizes files between locations.

Basic syntax:

```bash
rsync -av /source/ /backup/destination/
```

Create a test destination:

```bash
mkdir -p ~/backup-lab/rsync-backup
```

Run:

```bash
rsync -av \
~/backup-lab/source/ \
~/backup-lab/rsync-backup/
```

Check:

```bash
find ~/backup-lab/rsync-backup -type f -print
```

---

# 13. `rsync --delete`

Example:

```bash
rsync -av --delete \
~/backup-lab/source/ \
~/backup-lab/rsync-backup/
```

`--delete` removes destination files that no longer exist in the source.

Example:

```text
SOURCE              BACKUP

file1.txt           file1.txt
file2.txt           file2.txt
                    old.txt
```

After:

```bash
rsync -av --delete source/ backup/
```

Result:

```text
SOURCE              BACKUP

file1.txt           file1.txt
file2.txt           file2.txt
```

## ⚠️ Important

`rsync --delete` can be dangerous.

If a file is accidentally deleted from the source, synchronization can also delete it from the destination.

Therefore:

> A simple rsync mirror is not necessarily a complete historical backup system.

Versioning, snapshots, retention, or dedicated backup software may be required.

---

# 14. Verify with `diff`

Compare two directories:

```bash
diff -r \
~/backup-lab/source \
~/backup-lab/rsync-backup
```

If nothing is printed, there are no differences detected by `diff`.

---

# 15. Retention Policies

Keeping every backup forever is usually unnecessary.

Example retention policy:

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

Example:

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

Retention requirements depend on:

* Business requirements
* Recovery requirements
* Compliance
* Storage cost
* Data importance

---

# 16. RPO — Recovery Point Objective

RPO answers:

> How much data can we afford to lose?

Example:

```text
Backup frequency = Every 24 hours
```

Worst-case potential data loss:

```text
24 hours
```

Therefore:

```text
RPO ≈ 24 hours
```

If a system requires:

```text
RPO = 1 hour
```

backups or replication need to happen frequently enough to satisfy that requirement.

---

# 17. RTO — Recovery Time Objective

RTO answers:

> How quickly must the system be restored?

Example:

```text
Server failure
     ↓
Recovery starts
     ↓
Service restored
     ↓
30 minutes
```

RTO:

```text
30 minutes
```

### Remember

```text
RPO = How much data can I lose?

RTO = How much time can I be down?
```

---

# 18. Build `daily_backup.sh`

Create:

```bash
nano ~/daily_backup.sh
```

Add:

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

Make it executable:

```bash
chmod +x ~/daily_backup.sh
```

Run:

```bash
~/daily_backup.sh
```

Check:

```bash
ls -lh ~/backup-lab/backups
```

Check logs:

```bash
cat ~/backup-lab/logs/backup_$(date +%F).log
```

---

# 19. Understand `set -euo pipefail`

This is important for reliable shell scripts.

```bash
set -e
```

Exit when a command fails.

```bash
set -u
```

Treat unset variables as errors.

```bash
set -o pipefail
```

Detect failures inside pipelines.

Combined:

```bash
set -euo pipefail
```

This makes scripts safer and more predictable.

---

# 20. Build `backup_verification.sh`

Create:

```bash
nano ~/backup_verification.sh
```

Add:

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

Make executable:

```bash
chmod +x ~/backup_verification.sh
```

Run:

```bash
~/backup_verification.sh
```

---

# 21. Simulate Off-Site Backup

For today's lab, create a simulated off-site location:

```bash
mkdir -p ~/backup-lab/offsite
```

Copy backups:

```bash
rsync -av \
~/backup-lab/backups/ \
~/backup-lab/offsite/
```

In real cloud infrastructure, an off-site location could be:

```text
Amazon S3
Object Storage
Remote Server
Another Region
Dedicated Backup Service
```

---

# 22. Cron Automation

Edit your cron jobs:

```bash
crontab -e
```

Run the backup every day at 2 AM:

```cron
0 2 * * * /home/kevz/daily_backup.sh
```

Check your home directory before using the path:

```bash
echo $HOME
```

Check current cron jobs:

```bash
crontab -l
```

---

# 23. Weekly Off-Site Copy

Example:

```cron
0 3 * * 0 rsync -av /home/kevz/backup-lab/backups/ /home/kevz/backup-lab/offsite/
```

This means:

```text
03:00
Every Sunday
```

In a real environment, replace the local destination with an actual remote/off-site backup destination.

---

# 24. Backup Workflow

The final workflow should look like:

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

---

# 25. Backup vs Disaster Recovery

## Backup

A copy of data.

```text
Data
 ↓
Backup
```

## Disaster Recovery

The complete process of recovering systems and data.

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

Therefore:

> Backup is a component of disaster recovery, not the entire disaster recovery strategy.

---

# 26. Day 20 Deliverables

## `daily_backup.sh`

Requirements:

* [ ] Create backup
* [ ] Timestamp backup
* [ ] Compress data
* [ ] Log operations
* [ ] Verify archive
* [ ] Apply retention
* [ ] Return non-zero on failure

---

## `backup_verification.sh`

Requirements:

* [ ] Find latest backup
* [ ] Verify archive readability
* [ ] Report success/failure
* [ ] Return appropriate exit status

---

## Cron

Requirements:

* [ ] Daily backup
* [ ] Weekly off-site copy

---

## Disaster Recovery

Requirements:

* [ ] Create test data
* [ ] Backup test data
* [ ] Delete test file
* [ ] Restore from backup
* [ ] Verify restored file

---

# 27. Final Challenge

Build this directory:

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

Your goal is to make the entire process reproducible.

Someone else should be able to understand:

```text
What is being backed up?
Where is it stored?
How long is it retained?
How is it verified?
When does it run?
How do I restore it?
What happens if the backup fails?
```

---

# 28. Cloud Infrastructure Connection

Today's Linux concepts directly connect to cloud infrastructure.

## Linux

```text
tar
rsync
cron
logs
restore
```

## AWS / Cloud

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

The same fundamental concepts remain:

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

---

# 🧠 Interview Questions

1. What is the difference between full, incremental and differential backups?

2. Explain the 3-2-1 backup rule.

3. Why is an `rsync` mirror not necessarily a backup?

4. What does `rsync --delete` do?

5. What does this command do?

```bash
tar -czf backup.tar.gz data/
```

6. How can you inspect a tar archive without extracting it?

```bash
tar -tzf backup.tar.gz
```

7. What is RPO?

8. What is RTO?

9. Why should backups be tested?

10. Why should one backup be stored off-site?

11. Why is backup retention important?

12. What happens if the latest backup is corrupted?

13. Why should backup scripts use logging?

14. Why should backup jobs return a non-zero exit code when they fail?

15. What is the difference between backup and disaster recovery?

---

# 🔥 Day 20 Completion Checklist

## Theory

* [ ] Full backup
* [ ] Incremental backup
* [ ] Differential backup
* [ ] 3-2-1 rule
* [ ] Backup verification
* [ ] Retention policies
* [ ] RPO
* [ ] RTO
* [ ] Disaster recovery

## Hands-On

* [ ] Created tar backup
* [ ] Listed archive contents
* [ ] Extracted backup
* [ ] Used rsync
* [ ] Tested `rsync --delete`
* [ ] Compared directories with `diff`
* [ ] Created backup script
* [ ] Added logging
* [ ] Added retention
* [ ] Created verification script
* [ ] Configured cron
* [ ] Simulated disaster
* [ ] Restored deleted file
* [ ] Tested off-site copy

---

# 🏆 Day 20 Key Takeaway

> **Don't ask "Did my backup run?" Ask "Can I restore my system when everything goes wrong?"**

A production-grade infrastructure engineer doesn't just create backups.

They design systems around:

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

**Day 20 / 30 — Mastering Linux**

**Day 216 / 1000 — AI Cloud Infrastructure Engineer**

**Progress: 20/30 Linux | 216/1000 Infrastructure**

---

## Day 21 / 30 — Week 3 Review & Integration Project
**Day 217 / 1000 — AI Cloud Infrastructure Engineer Journey**

> **Theme:** Integrate Linux security, user management, SSH, sudo, auditd, and Bash automation into one realistic infrastructure workflow.

---

## 📅 Day Information

| Field             | Details                          |
| ----------------- | -------------------------------- |
| Linux Progress    | Day 21 / 30                      |
| 1000-Day Progress | Day 217 / 1000                   |
| Week              | Week 3                           |
| Theme             | Security, Users, SSH & Firewalls |
| Project           | Onboard User Script              |
| Duration          | ~3.5 hours                       |
| Primary Skill     | Linux Security Automation        |

---

# 🎯 Today's Objective

Build an automated Linux user onboarding system that securely:

1. Creates a user account with a home directory
2. Adds the user to appropriate groups
3. Configures restricted sudo permissions
4. Installs SSH public keys
5. Configures password expiry policies
6. Creates audit rules for the user's home directory
7. Logs all actions
8. Generates an onboarding summary

The goal is to move from learning individual Linux commands to **combining them into an infrastructure automation workflow**.

---

# 🧠 Part 1 — Week 3 Review

## 1. Linux Users

Important files:

```text
/etc/passwd
/etc/shadow
/etc/group
/etc/gshadow
```

Create a user:

```bash
sudo useradd -m alice
```

Check the user:

```bash
id alice
```

Check the home directory:

```bash
ls -la /home/alice
```

Check `/etc/passwd`:

```bash
grep alice /etc/passwd
```

---

# 2. Linux Groups

Create groups:

```bash
sudo groupadd developers
sudo groupadd admins
```

Check groups:

```bash
getent group developers
getent group admins
```

Add a user to a group:

```bash
sudo usermod -aG developers alice
```

Add multiple groups:

```bash
sudo usermod -aG developers,admins alice
```

Verify:

```bash
id alice
```

### Important

Always remember:

```bash
usermod -aG
```

The `-a` means **append**.

Without `-a`, you can accidentally replace the user's supplementary groups.

---

# 3. Sudo Review

Sudo provides controlled administrative privileges.

Important files:

```text
/etc/sudoers
/etc/sudoers.d/
```

Always validate sudo configuration with:

```bash
sudo visudo -cf /etc/sudoers.d/example
```

Never blindly edit `/etc/sudoers`.

---

# 🧪 Review Quiz

## Question

How do you allow a user to restart nginx without giving them complete root access?

### Answer

Create a restricted sudo rule:

```text
%developers ALL=(root) /usr/bin/systemctl restart nginx
```

Now members of the `developers` group can run:

```bash
sudo systemctl restart nginx
```

but they don't automatically receive unrestricted root access.

This demonstrates:

> **Principle of Least Privilege**

---

# 4. SSH Key Authentication

Typical SSH structure:

```text
/home/alice/
└── .ssh/
    └── authorized_keys
```

Create the directory:

```bash
sudo mkdir -p /home/alice/.ssh
```

Copy the public key:

```bash
sudo cp alice.pub /home/alice/.ssh/authorized_keys
```

Set ownership:

```bash
sudo chown -R alice:alice /home/alice/.ssh
```

Set permissions:

```bash
sudo chmod 700 /home/alice/.ssh
sudo chmod 600 /home/alice/.ssh/authorized_keys
```

Verify:

```bash
ls -la /home/alice/.ssh
```

Expected:

```text
drwx------ .ssh
-rw------- authorized_keys
```

---

# 5. Password Expiration

Check the current policy:

```bash
sudo chage -l alice
```

Set maximum password age:

```bash
sudo chage -M 90 alice
```

Set warning period:

```bash
sudo chage -W 14 alice
```

Set minimum password age:

```bash
sudo chage -m 1 alice
```

Force password change:

```bash
sudo chage -d 0 alice
```

---

# 6. Auditd Review

Auditd provides system auditing and security event tracking.

Example rule:

```text
-w /home/alice -p wa -k user_home_alice
```

Meaning:

```text
-w  → Watch this path
-p  → Permissions/events to monitor
w   → Write
a   → Attribute changes
-k  → Searchable audit key
```

Search events:

```bash
sudo ausearch -k user_home_alice
```

List active rules:

```bash
sudo auditctl -l
```

---

# 7. Logging

Create a central log:

```text
/var/log/onboard_user.log
```

Example logging function:

```bash
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" \
        | tee -a "$LOG_FILE"
}
```

Then:

```bash
log "Creating user: $USERNAME"
log "Adding user to developers"
log "Configuring SSH"
log "Configuring auditd"
```

---

# 🚀 Part 2 — Integration Project

# Onboard User Script

The script should automate the following:

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

---

# 📁 Project Structure

Create:

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

---

# 🛠️ Step 1 — Create the Script

Create:

```bash
nano onboard_user.sh
```

Start with:

```bash
#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/onboard_user.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" \
        | tee -a "$LOG_FILE"
}
```

### Why `set -euo pipefail`?

```text
-e → Exit when a command fails
-u → Treat undefined variables as errors
-o pipefail → Detect failures inside pipelines
```

This is an important Bash scripting pattern for infrastructure automation.

---

# 🛡️ Step 2 — Check Root

User management requires administrative privileges.

```bash
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    exit 1
fi
```

Run the script with:

```bash
sudo ./onboard_user.sh
```

---

# 📥 Step 3 — Process Arguments

The script should accept:

```bash
./onboard_user.sh alice developers alice.pub
```

Add:

```bash
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <username> <group> <public-key>"
    exit 1
fi

USERNAME="$1"
GROUP="$2"
PUBLIC_KEY="$3"
```

Arguments:

```text
$1 → Username
$2 → Group
$3 → SSH public key
```

---

# 🔐 Step 4 — Validate Username

Never blindly trust user input.

```bash
if ! [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "Invalid username."
    exit 1
fi
```

---

# 👥 Step 5 — Create the Group

Check whether the group already exists:

```bash
if ! getent group "$GROUP" > /dev/null; then
    log "Creating group: $GROUP"
    groupadd "$GROUP"
else
    log "Group already exists: $GROUP"
fi
```

---

# 👤 Step 6 — Create the User

```bash
if id "$USERNAME" &>/dev/null; then
    log "User already exists: $USERNAME"
else
    log "Creating user: $USERNAME"
    useradd -m -s /bin/bash "$USERNAME"
fi
```

Verify:

```bash
id "$USERNAME"
```

---

# 👥 Step 7 — Add User to Group

```bash
usermod -aG "$GROUP" "$USERNAME"
```

Verify:

```bash
id "$USERNAME"
```

---

# 🔑 Step 8 — Configure SSH

Define the SSH directory:

```bash
SSH_DIR="/home/$USERNAME/.ssh"
```

Create it:

```bash
mkdir -p "$SSH_DIR"
```

Install the public key:

```bash
cp "$PUBLIC_KEY" "$SSH_DIR/authorized_keys"
```

Set ownership:

```bash
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"
```

Set permissions:

```bash
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
```

---

# ⏳ Step 9 — Configure Password Policy

Set a 90-day maximum password age:

```bash
chage -M 90 "$USERNAME"
```

Set a 14-day warning period:

```bash
chage -W 14 "$USERNAME"
```

Verify:

```bash
chage -l "$USERNAME"
```

---

# 🔍 Step 10 — Configure Auditd

Generate an audit rule:

```bash
AUDIT_RULE="-w /home/$USERNAME -p wa -k user_home_$USERNAME"
```

Add the rule:

```bash
echo "$AUDIT_RULE" >> /etc/audit/rules.d/onboard_user.rules
```

Reload:

```bash
augenrules --load
```

Verify:

```bash
auditctl -l
```

Search:

```bash
ausearch -k "user_home_$USERNAME"
```

---

# 🔒 Step 11 — Configure Sudo

Create a sudoers file:

```bash
SUDO_FILE="/etc/sudoers.d/$GROUP"
```

Example rule:

```bash
echo "%$GROUP ALL=(root) /usr/bin/systemctl restart nginx" \
    > "$SUDO_FILE"
```

Set permissions:

```bash
chmod 440 "$SUDO_FILE"
```

Validate:

```bash
visudo -cf "$SUDO_FILE"
```

The validation step is extremely important.

> Never activate an invalid sudo configuration.

---

# 📝 Step 12 — Generate Summary

Create:

```bash
SUMMARY_FILE="/tmp/${USERNAME}_onboarding_summary.txt"
```

Then:

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

View it:

```bash
cat "$SUMMARY_FILE"
```

---

# 📧 Step 13 — Email Notification

A production Linux system can use:

```text
mail
mailx
msmtp
Postfix
```

For today's free/local lab, don't install a complete mail server just for the exercise.

Instead, generate the summary file:

```text
/tmp/alice_onboarding_summary.txt
```

Later, this can be connected to an SMTP notification system.

---

# 🧪 Part 3 — Testing

## Test 1 — Create User

```bash
sudo ./onboard_user.sh alice developers keys/alice.pub
```

Check:

```bash
id alice
```

---

## Test 2 — Home Directory

```bash
ls -ld /home/alice
```

Expected:

```text
/home/alice
```

---

## Test 3 — SSH Configuration

```bash
ls -la /home/alice/.ssh
```

Check:

```bash
cat /home/alice/.ssh/authorized_keys
```

---

## Test 4 — Permissions

```bash
stat /home/alice/.ssh
stat /home/alice/.ssh/authorized_keys
```

Expected approximately:

```text
.ssh                700
authorized_keys     600
```

---

## Test 5 — Password Policy

```bash
sudo chage -l alice
```

Verify:

```text
Maximum number of days between password change: 90
Number of days of warning before password expires: 14
```

---

## Test 6 — Auditd

Create a test file:

```bash
sudo -u alice touch /home/alice/test.txt
```

Search:

```bash
sudo ausearch -k user_home_alice
```

You should find an audit event.

---

## Test 7 — Sudo

Switch to Alice:

```bash
su - alice
```

Test:

```bash
sudo systemctl restart nginx
```

This should work if the sudo rule is configured correctly.

Now try:

```bash
sudo cat /etc/shadow
```

This should **not** be permitted by the restricted nginx rule.

This demonstrates:

> **Least Privilege**

---

# 🧠 Part 4 — Infrastructure Engineering Concepts

Today's lesson is bigger than Linux commands.

You are learning how to combine:

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

This is the beginning of infrastructure automation.

---

# 🔥 Challenge 1 — Multiple Groups

Modify the script to support:

```bash
./onboard_user.sh alice developers admins alice.pub
```

The user should belong to:

```text
developers
admins
```

---

# 🔥 Challenge 2 — Duplicate User Protection

Make sure the script handles:

```bash
sudo ./onboard_user.sh alice developers alice.pub
```

when Alice already exists.

It should not blindly recreate the account.

---

# 🔥 Challenge 3 — Missing SSH Key

If the key doesn't exist:

```bash
./onboard_user.sh alice developers missing.pub
```

the script should stop with a useful error.

Example:

```text
ERROR: SSH public key not found.
```

---

# 🔥 Challenge 4 — Dry Run

Add support for:

```bash
sudo ./onboard_user.sh alice developers alice.pub --dry-run
```

Expected:

```text
[DRY RUN] Would create user alice
[DRY RUN] Would add alice to developers
[DRY RUN] Would configure SSH
[DRY RUN] Would configure sudo
[DRY RUN] Would configure auditd
```

Nothing should actually be changed.

---

# 🔥 Challenge 5 — Rollback Thinking

Think about this situation:

```text
User created
      ↓
Group added
      ↓
SSH configured
      ↓
Sudo configuration FAILS
```

What happens?

Should the script:

```text
A. Leave everything as-is?
B. Remove the user?
C. Restore the previous state?
D. Log the failure and stop?
```

Think about this before implementing advanced rollback.

This is an important production engineering problem.

---

# 📊 Week 3 Review

By the end of Week 3, you should understand:

| Topic       | Commands / Concepts                   |
| ----------- | ------------------------------------- |
| Users       | `useradd`, `usermod`, `userdel`       |
| Groups      | `groupadd`, `usermod -aG`             |
| Passwords   | `passwd`, `chage`                     |
| Sudo        | `sudoers`, `visudo`, `/etc/sudoers.d` |
| SSH         | keys, `authorized_keys`               |
| Permissions | `chmod`, `chown`                      |
| Firewall    | UFW                                   |
| Auditing    | `auditd`, `ausearch`                  |
| Logging     | `/var/log`, `journalctl`              |
| Automation  | Bash scripting                        |
| Security    | Least privilege                       |
| Operations  | Testing, validation, logging          |

---

# ✅ Day 21 Definition of Done

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

---

# 📦 Deliverables

```text
onboard_user.sh
config/sudoers.template
config/audit.rules.template
keys/alice.pub
examples/example-run.txt
README.md
```

---

# 📝 Git Commit

```bash
git add .
git commit -m "Week 3: User onboarding and security hardening"
git push
```

---

# 📈 Progress

```text
Linux Mastery:

Day 21 / 30
█████████████████████░░░░░░░ 70%

1000-Day AI Cloud Infrastructure Journey:

Day 217 / 1000
█████░░░░░░░░░░░░░░░░░░░░░░░ 21.7%
```

---

# 🎯 Day 21 Takeaway

The most important transition today is:

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

> **Don't just learn Linux commands. Learn how to combine Linux primitives into reliable, secure automation.**

**Day 21 / 30 — COMPLETE**

**Day 217 / 1000 — KEEP BUILDING.**

---

