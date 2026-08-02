# 🐧 The Definitive 2-Week Linux Mastery Guide for Cloud Engineers

Welcome to the ultimate guide to mastering Linux for Cloud Infrastructure. In modern cloud environments (AWS, GCP, Azure), 95% of your workloads will run on Linux. If you cannot confidently navigate the terminal, troubleshoot failing services, and parse massive log files, you cannot be an effective Cloud Engineer. This 14-day path bridges the gap between basic commands and the advanced system administration skills demanded in technical interviews.

---

## 🛠️ Week 1: The Core System, Permissions, and Data Processing

### **Day 1: The Linux File System Hierarchy & Navigation**

#### 🧠 Comprehensive Concept Breakdown
Linux treats everything as a file (even hardware devices and running processes). Understanding where things live is the first step in troubleshooting.
* **`/` (Root):** The absolute top of the filesystem.
* **`/etc`:** Stores all system-wide configuration files (e.g., `/etc/ssh/sshd_config`, `/etc/fstab`). If a service breaks, you look here first.
* **`/var`:** Variable data. Most importantly, `/var/log` contains system and application logs.
* **`/home`:** User directories.
* **`/bin` & `/sbin`:** Binaries (executable commands). `/sbin` is strictly for system administrators (e.g., `reboot`).

#### 💻 Command Walkthrough
```bash
# Print your current absolute path
pwd 

# List all files, including hidden files (-a), with detailed human-readable sizes (-lh)
ls -lah /var/log

# Quickly jump back to your previous directory (like a TV remote 'back' button)
cd -

# Find all files ending in .conf inside the /etc directory
find /etc -type f -name "*.conf"
```

#### 🚨 Common Pitfalls & Debugging
* **Error:** `find: '/etc/ssl/private': Permission denied`
* **Fix:** You are trying to search a directory owned by `root`. Prepend your command with `sudo` to execute it with superuser privileges.

#### 🎤 Technical Interview Prep
* **Q:** An application failed to start on an EC2 instance. Where is the very first place you look?
* **A:** I would immediately navigate to `/var/log` and check the specific application log, or check `/var/log/syslog` (Ubuntu) or `/var/log/messages` (Amazon Linux) to see if the kernel or `systemd` threw an error during startup.

---

### **Day 2: Permissions & Ownership (The Security Foundation)**

#### 🧠 Comprehensive Concept Breakdown
Linux uses a rigid permission system mapped to **User (u)**, **Group (g)**, and **Others (o)**.
Permissions are Read (`r` = 4), Write (`w` = 2), and Execute (`x` = 1).
When you run `ls -l`, you see a 10-character string like `-rwxr-xr--`.
* `rwx` (4+2+1 = 7): The Owner can read, write, and execute.
* `r-x` (4+0+1 = 5): The Group can read and execute, but cannot write.
* `r--` (4+0+0 = 4): Others can only read.

#### 💻 Command Walkthrough
```bash
# Change ownership of a file to user 'ubuntu' and group 'admin'
sudo chown ubuntu:admin deploy.sh

# Make a script executable for the owner only (adds +x)
chmod u+x deploy.sh

# Set strict permissions using numerical values: 
# 600 means Owner can Read/Write. Group/Others have NO access. 
# Crucial for SSH private keys!
chmod 600 private-key.pem

# Recursively change permissions of a whole directory
chmod -R 755 /var/www/html
```

#### 🎤 Technical Interview Prep
* **Q:** You downloaded an SSH key (`key.pem`) from AWS, but when you run `ssh -i key.pem user@ip`, SSH rejects it with a "WARNING: UNPROTECTED PRIVATE KEY FILE!" error. How do you fix this?
* **A:** SSH automatically rejects private keys if they are readable by other users on the system. I would run `chmod 400 key.pem` to ensure only my user has read access, and all other permissions are stripped.

---

### **Day 3: Text Processing & Pipes (`grep`, `awk`, `sed`)**

#### 🧠 Comprehensive Concept Breakdown
Cloud Engineers do not open 10-Gigabyte log files in VS Code or Notepad. They process data instantly via the CLI using **Pipes (`|`)**, which take the output of one command and pass it as the input to the next.
* **`grep`:** Filters text based on patterns.
* **`awk`:** Extracts specific columns from structured text.
* **`sed`:** Stream editor for finding and replacing text on the fly.

#### 💻 Command Walkthrough
```bash
# 1. View a live log file as it updates in real-time
tail -f /var/log/nginx/access.log

# 2. Filter the log for the word "ERROR" (case-insensitive -i)
grep -i "error" /var/log/syslog

# 3. Find all "404" errors in an Nginx log, and use AWK to print ONLY the IP address (column 1)
grep " 404 " access.log | awk '{print $1}'

# 4. Count how many unique IP addresses hit a 404
grep " 404 " access.log | awk '{print $1}' | sort | uniq -c | sort -nr

# 5. Use sed to replace the word "localhost" with "10.0.0.5" in a config file and save it in-place (-i)
sed -i 's/localhost/10.0.0.5/g' /etc/nginx/nginx.conf
```

#### 🎤 Technical Interview Prep
* **Q:** A web server is under a DDoS attack. How would you quickly find the top 5 IP addresses sending the most requests?
* **A:** I would parse the access log using: `awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -n 5`. This extracts the IP column, sorts them so identical IPs are adjacent, counts their occurrences, sorts by the count in descending order, and displays the top 5.

---

### **Day 4: Process & Resource Management**

#### 🧠 Comprehensive Concept Breakdown
When a server slows down, you must instantly identify the bottleneck (CPU, RAM, or Disk I/O) and kill runaway processes.
* **`top` / `htop`:** Real-time dashboards of system performance.
* **`ps`:** Takes a static snapshot of currently running processes.
* **`kill`:** Sends signals to a process (usually to terminate it).

#### 💻 Command Walkthrough
```bash
# View all running processes across all users, displaying a full command line
ps aux

# Find the specific Process ID (PID) of the python application
pgrep python

# Forcefully kill a runaway process with PID 1234 (SIGKILL)
kill -9 1234

# Check available memory in Megabytes
free -m
```

#### 🎤 Technical Interview Prep
* **Q:** What is the difference between `kill -15` and `kill -9`?
* **A:** `kill -15` sends a SIGTERM signal, politely asking the application to shut down. This allows the application to save data and close database connections cleanly. `kill -9` sends a SIGKILL signal directly to the kernel, which immediately terminates the process without warning. `kill -9` should only be used as a last resort because it can cause data corruption.

---

### **Day 5: Redirection & Streams**

#### 🧠 Comprehensive Concept Breakdown
Every Linux program has three data streams:
1. **Standard Input (stdin - `0`)**
2. **Standard Output (stdout - `1`)**
3. **Standard Error (stderr - `2`)**

You can redirect these streams using `>` (overwrite) and `>>` (append).

#### 💻 Command Walkthrough
```bash
# Overwrite file.txt with the word "Hello"
echo "Hello" > file.txt 

# Append "World" to the bottom of file.txt
echo "World" >> file.txt 

# Run a noisy script, but throw all ERROR messages into a black hole (/dev/null) so they don't clutter the screen
./script.sh 2> /dev/null

# Run a script and redirect BOTH Output and Errors into the same log file
./script.sh &> output.log
```

#### 🎤 Technical Interview Prep
* **Q:** What is `/dev/null`?
* **A:** It is a special device file in Linux known as the "black hole." Any data written to `/dev/null` is immediately discarded. We use it to suppress unwanted output or error messages from scripts.

---

### **Day 6: Environment Variables & The PATH**

#### 🧠 Comprehensive Concept Breakdown
Environment variables are dynamic values that affect how processes run on a computer. The most important variable is `$PATH`.
When you type `terraform`, Linux doesn't scan your entire hard drive. It looks through the directories listed in the `$PATH` variable in order. If the binary isn't in one of those directories, you get a `command not found` error.

#### 💻 Command Walkthrough
```bash
# Print all environment variables
env

# View exactly which directories are in your PATH
echo $PATH

# Add a custom directory to your PATH for the current session
export PATH=$PATH:/home/ubuntu/my-custom-scripts

# Make it permanent by adding it to your bash configuration file
echo 'export PATH=$PATH:/home/ubuntu/my-custom-scripts' >> ~/.bashrc
source ~/.bashrc
```

#### 🎤 Technical Interview Prep
* **Q:** You downloaded the `kubectl` binary, but when you type `kubectl`, you get "command not found". How do you fix this without typing the full absolute path every time?
* **A:** I need to move the binary into a directory that is already in my `$PATH` (like `/usr/local/bin`), or I need to update my `$PATH` variable in my `~/.bashrc` file to include the directory where I downloaded the binary.

---

### **Day 7: Week 1 Capstone Challenge**

#### 🧠 The Architecture Objective
Write a bash script named `health_check.sh`.
* **Requirements:**
  1. It must check the server's current RAM usage and output a warning if it exceeds 80%.
  2. It must search `/var/log/auth.log` (or `secure`) for "Failed password" and print the IP addresses trying to brute-force your server.
  3. All standard output must be redirected to `health_report.txt`, and any errors must be silently discarded to `/dev/null`.
  4. Ensure the script has the correct permissions to execute.

*Self-Assessment: This combines text processing, system monitoring, permissions, and redirection into a single cloud automation task.*

---

## 🏗️ Week 2: System Administration, Networking, and Security

### **Day 8: Networking & Troubleshooting**

#### 🧠 Comprehensive Concept Breakdown
When microservices can't talk to the database, you are the one they call. You must isolate whether the issue is DNS, a blocked port, or a dead service.
* **`ping`:** Tests basic ICMP connectivity (Are they online?). Note: AWS blocks ping by default on Security Groups!
* **`curl`:** Tests HTTP/HTTPS APIs directly from the command line.
* **`dig`:** Resolves DNS records (Is `db.example.com` pointing to the right IP?).
* **`nc` (Netcat):** Tests if a specific port is open.

#### 💻 Command Walkthrough
```bash
# Test if a web server is returning a 200 OK without downloading the whole page (-I fetches headers only)
curl -I https://google.com

# Check if a database server is accepting connections on port 3306 (MySQL)
nc -vz 10.0.1.50 3306
# Output: Connection to 10.0.1.50 3306 port [tcp/mysql] succeeded!

# Verify what IP address a domain name resolves to
dig +short api.mycompany.com

# Show all listening ports on your server (Is my app actually bound to port 8080?)
ss -tulpn
```

#### 🎤 Technical Interview Prep
* **Q:** An application server cannot connect to an RDS database. How do you troubleshoot this from the Linux command line?
* **A:** First, I would run `dig <rds-endpoint>` to ensure DNS is resolving correctly. If it resolves, I would use `nc -vz <rds-endpoint> 3306` to test if the specific port is reachable. If `nc` times out, it is a network block—most likely an AWS Security Group rule or a subnet routing issue.

---

### **Day 9: Package & Service Management (`systemd`)**

#### 🧠 Comprehensive Concept Breakdown
Enterprise applications don't run in standard terminal windows. They run as background **daemons** managed by `systemd`. `systemd` ensures your app starts automatically when the server boots and restarts if it crashes.

#### 💻 Command Walkthrough
```bash
# Debian/Ubuntu package management
sudo apt update && sudo apt install nginx -y

# Start the Nginx service
sudo systemctl start nginx

# Enable Nginx to start automatically on system boot (crucial for cloud servers!)
sudo systemctl enable nginx

# Check the exact status and view the most recent logs for the service
sudo systemctl status nginx

# View the full historical logs for a specific service using journalctl
journalctl -u nginx --since "1 hour ago"
```

#### 🎤 Technical Interview Prep
* **Q:** You start a Node.js app manually, but when you close your SSH session, the app dies. How do you fix this for production?
* **A:** I need to daemonize the application. I would write a `systemd` unit file (e.g., `myapp.service`) defining how to execute the app, place it in `/etc/systemd/system/`, and run `sudo systemctl enable --now myapp`. This ensures the app runs independently of my SSH session and restarts on failure.

---

### **Day 10: Disk Management & Storage**

#### 🧠 Comprehensive Concept Breakdown
When an EC2 instance runs out of disk space, applications crash catastrophically. You must know how to inspect disks and mount new EBS volumes.
* **`df -h`:** Displays overall free disk space on mounted file systems.
* **`du -sh`:** Calculates the size of a specific directory.
* **`/etc/fstab`:** The configuration file that tells Linux which disks to mount on boot.

#### 💻 Command Walkthrough
```bash
# Check if your main disk (/) is at 100% capacity
df -h

# You are at 99% capacity. Find out which folders are consuming the most space:
# This checks the root directory, calculates sizes, sorts them numerically, and shows the top 10.
sudo du -h -x -d 1 / | sort -hr | head -n 10

# Format a newly attached AWS EBS volume to the ext4 filesystem
sudo mkfs -t ext4 /dev/xvdf

# Mount the volume to a directory
sudo mount /dev/xvdf /data
```

#### 🎤 Technical Interview Prep
* **Q:** An EC2 instance rebooted, and the extra 100GB EBS volume you attached yesterday is gone from the filesystem. What happened?
* **A:** You mounted the volume using the `mount` command, which is temporary. To make a mount persist across reboots, you must add the volume's UUID and mount point to the `/etc/fstab` file.

---

### **Day 11: Secure Shell (SSH) & Data Transfer**

#### 🧠 Comprehensive Concept Breakdown
SSH uses asymmetric cryptography (a public key and a private key) to authenticate you securely over port 22 without passwords. 
* **`~/.ssh/authorized_keys`:** The file on the *server* that holds public keys. If your public key is in here, you can log in.
* **`scp`:** Secure Copy Protocol. Transfers files over SSH.
* **`rsync`:** A smarter, faster transfer tool that only copies the *differences* between files.

#### 💻 Command Walkthrough
```bash
# Generate a new highly secure ED25519 key pair
ssh-keygen -t ed25519 -C "admin@company.com"

# Copy your public key to a remote server so you can log in without a password
ssh-copy-id user@10.0.0.5

# Securely copy a backup file FROM your laptop TO the server
scp backup.sql user@10.0.0.5:/home/user/

# Sync a massive web directory to the server. If the connection drops and you rerun it, 
# rsync picks up exactly where it left off.
rsync -avz /var/www/html/ user@10.0.0.5:/var/www/html/
```

#### 🎤 Technical Interview Prep
* **Q:** How does SSH Key Authentication work?
* **A:** It uses public-key cryptography. I generate a key pair and place the public key on the server. When I attempt to connect, the server encrypts a challenge message using my public key. Only my private key (which never leaves my laptop) can decrypt it. If my laptop successfully decrypts the challenge and sends it back, the server grants access.

---

### **Day 12: Scheduled Tasks & Background Jobs**

#### 🧠 Comprehensive Concept Breakdown
Automation is king. If you need a script to run every night at 2:00 AM to back up a database, you use **Cron**.
If you need to run a massive database migration that takes 6 hours, you use **Tmux** or **Screen** so the command doesn't die if your internet drops.

#### 💻 Command Walkthrough
```bash
# Edit the cron table
crontab -e

# Cron syntax: Minute Hour DayOfMonth Month DayOfWeek Command
# Run a backup script every day at 2:00 AM
0 2 * * * /home/ubuntu/backup.sh >> /var/log/backup.log 2>&1

# Start a resilient terminal session that survives disconnects
tmux new -s migration
# (Run your 6-hour script here)
# Press Ctrl+B, then D to detach. You can now close your laptop.

# Later, log back into the server and reattach to the session to check progress
tmux attach -t migration
```

#### 🎤 Technical Interview Prep
* **Q:** You need to run a database export that takes 4 hours. You run it directly in your SSH terminal, but your VPN drops 10 minutes later. What happened to the export?
* **A:** Because the command was tied to the TTY (terminal session), it received a SIGHUP (hangup) signal when the SSH connection dropped, killing the export. To prevent this, I should have run the command inside a terminal multiplexer like `tmux` or `screen`, or prepended the command with `nohup` (No Hangup) and appended `&` to send it to the background.

---

### **Day 13: Firewalls & Security Basics (`ufw` & `iptables`)**

#### 🧠 Comprehensive Concept Breakdown
Even if you have an AWS Security Group, running a local OS-level firewall provides defense-in-depth.
* **UFW (Uncomplicated Firewall):** A user-friendly frontend for iptables used in Ubuntu.
* **iptables:** The hardcore kernel-level firewall utility.

#### 💻 Command Walkthrough
```bash
# Allow SSH connections (CRITICAL: Do this BEFORE enabling the firewall, or you lock yourself out!)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Deny everything else by default and enable the firewall
sudo ufw default deny
sudo ufw enable

# Check firewall status
sudo ufw status verbose
```

#### 🎤 Technical Interview Prep
* **Q:** What is "Defense in Depth"?
* **A:** It is a security strategy that uses multiple layers of protection. Instead of relying solely on an AWS Security Group at the network level, we also run `ufw` on the Linux instance itself. If a misconfiguration accidentally opens the AWS Security Group to the world, the local Linux firewall will still block the malicious traffic.

---

### **Day 14: Final Capstone & Job Readiness (The System Outage Simulation)**

#### 🧠 The Ultimate Challenge
You are handed a broken Linux server (or you can break a local VM on purpose).
1. **The Web Server is down.** (`systemctl status nginx` -> it's crashed).
2. **You try to start it.** It fails.
3. **You check the logs.** (`journalctl -u nginx` -> "no space left on device").
4. **You check the disk.** (`df -h` -> `/var` is 100% full).
5. **You find the culprit.** (`du -sh /var/log/*` -> `app.log` is 50GB).
6. **You fix it.** (Empty the log using `> /var/log/app.log`).
7. **You secure it.** (Configure `logrotate` so it never happens again).

*Self-Assessment: If you can navigate this exact troubleshooting sequence seamlessly using the CLI, you possess the operational knowledge to pass an Entry-Level Cloud/DevOps Engineering interview.*

---
*Authored for the 1000-Day AI & Cloud Infrastructure Journey.*
