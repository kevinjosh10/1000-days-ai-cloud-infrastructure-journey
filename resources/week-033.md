# Week 33 Resources: Linux Capstone & Networking Mastery Foundations

## 📅 Timeline: Days 225 - 231 (October 12, 2026 – October 18, 2026)

---

## Day 225 — Day 29 — Integration & Practice: Sick Server Diagnosis
- **Date:** 12 October 2026 (Calendar: October 12, 2026 (Monday))

```bash
uptime
hostname
nproc
top
```

```bash
free -h
vmstat 1
```

```bash
iostat -xz 1
```

```bash
ss -s
ss -tan
ss -lnt
ip -s link
```

```bash
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -15
```

```bash
pidstat -d 1
```

```bash
pidstat 1
```

```bash
sudo lsof /var/log/syslog
sudo lsof -p PID
sudo lsof -i
```

```bash
sudo fuser -v /path/to/file
```

```bash
sudo journalctl -k --since "15 minutes ago"
```

```bash
mkdir -p ~/day225-diagnosis
cd ~/day225-diagnosis
```

```bash
{
    date
    hostname
    uptime
    nproc
    free -h
    df -h
    df -i
    vmstat 1 5
    ss -s
    ps aux --sort=-%cpu | head -10
    ps aux --sort=-%mem | head -10
} > baseline.txt 2>&1
```

```bash
stress-ng --version
```

```bash
stress-ng --cpu 1 --timeout 60s --metrics-brief
```

```bash
top
vmstat 1
```

```bash
stress-ng --vm 1 --vm-bytes 20% --timeout 60s --metrics-brief
```

```bash
free -h
vmstat 1
ps aux --sort=-%mem | head -10
```

```bash
stress-ng --io 1 --timeout 60s --metrics-brief
```

```bash
iostat -xz 1
pidstat -d 1
```

```bash
stress-ng --cpu 1 --vm 1 --vm-bytes 20% --io 1 --timeout 60s --metrics-brief
```

```bash
uptime
top
free -h
```

```bash
vmstat 1
```

```bash
iostat -xz 1
pidstat -d 1
df -h
df -i
```

```bash
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
```

```bash
sudo lsof -p PID
```

```bash
ss -s
ss -lnt
ss -tan
ip -s link
```

```bash
sudo journalctl -k --since "15 minutes ago"
```

---

## Day 226/1000 — Linux Day 30/30: Production System Monitor
- **Date:** October 13, 2026 (Calendar: October 13, 2026 (Tuesday))

```text
projects/linux/sysmon/
├── sysmon.sh
├── sysmon.conf
├── sysmon.service
├── sysmon.timer
├── README.md
└── examples/
    ├── sample-output.txt
    └── output.json
```

```text
                             sysmon.sh
                                 │
     ┌──────────────┬────────────┼─────────────┬──────────────┐
     ▼              ▼            ▼             ▼              ▼
 CPU Metrics    Memory       Disk Storage   Network Sockets Processes & Logs
 (mpstat, ps)   (free, ps)   (df, iostat)   (ss -ltn)       (ps, journalctl)
     │              │            │             │              │
     └──────────────┴────────────┼─────────────┴──────────────┘
                                 │
                                 ▼
                     Threshold Evaluation Logic
                     (sysmon.conf: WARN / CRIT)
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
          Human Terminal View         Structured JSON
          (Color-coded status)       (--json automation)
```

```bash
sudo apt update
sudo apt install sysstat procps iproute2 util-linux
```

```bash
mkdir -p ~/projects/linux/sysmon
cd ~/projects/linux/sysmon
```

```bash
chmod +x sysmon.sh
```

```bash
bash -n sysmon.sh
```

```bash
./sysmon.sh
```

```bash
uptime
mpstat -P ALL 1 1
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4
```

```bash
free -h
free -m
ps -eo pid,comm,%mem,rss --sort=-%mem | head -n 4
```

```bash
df -h
df -P
iostat -dx 1 2
```

```bash
ss -ltn
ss -tn state established
```

```bash
ss -H -ltn | wc -l
```

```bash
ss -H -tn state established | wc -l
```

```bash
ps -e --no-headers | wc -l
ps -eo stat= | awk '$1 ~ /^Z/ {n++} END {print n+0}'
ps -eo pid,etimes,comm --sort=-etimes | head -n 4
```

```bash
journalctl -p err -n 5 --no-pager -o short-iso
```

```bash
CPU_WARN=70
CPU_CRIT=90

MEM_WARN=80
MEM_CRIT=95

DISK_WARN=80
DISK_CRIT=90
```

```bash
bash -n sysmon.sh
```

```bash
mpstat -P ALL 1 1
uptime
```

```bash
free -h
```

```bash
df -h
```

```bash
ss -ltn
ss -tn state established
```

```bash
ps -e --no-headers | wc -l
ps -eo stat= | awk '$1 ~ /^Z/ {n++} END {print n+0}'
```

```bash
journalctl -p err -n 5 --no-pager
```

```ini
[Unit]
Description=Linux System Monitor
Documentation=https://github.com/kevinjosh10/1000-days-ai-cloud-infrastructure-journey

[Service]
Type=oneshot
User=root
ExecStart=/bin/bash /opt/sysmon/sysmon.sh
StandardOutput=append:/var/log/sysmon.log
StandardError=append:/var/log/sysmon.log
```

```ini
[Unit]
Description=Run System Monitor Every Five Minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
AccuracySec=30s
Unit=sysmon.service

[Install]
WantedBy=timers.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now sysmon.timer
systemctl list-timers sysmon.timer
```

```bash
sudo systemctl start sysmon.service
sudo systemctl status sysmon.service
sudo tail -n 80 /var/log/sysmon.log
```

```text
Linux VM
   |
   v
sysmon.sh
   |
   v
Structured Metrics and Logs
   |
   v
Monitoring and Visualization
   |
   +----> Prometheus
   +----> Grafana
   +----> AWS CloudWatch
   |
   v
Alerts and Troubleshooting
```

---

## Day 227/1000 — Day 1/28: Mastering Networking
- **Date:** October 14, 2026 (Calendar: October 14, 2026 (Wednesday))

```text
+-------------------------------------------------------+
| Application Data (HTTP GET / HTTP Request Body)       |
+-------------------------------------------------------+
                           ↓  (Transport Layer adds TCP Header)
+------------+------------------------------------------+
| TCP Header | Application Data                         |  = TCP Segment
+------------+------------------------------------------+
                           ↓  (Internet Layer adds IP Header)
+-----------+------------+------------------------------+
| IP Header | TCP Header | Application Data             |  = IP Packet
+-----------+------------+------------------------------+
                           ↓  (Network Access Layer adds Frame Header & Trailer)
+-------------+-----------+------------+------------------+---------------+
| Link Header | IP Header | TCP Header | Application Data | Frame Trailer |  = Link Frame
+-------------+-----------+------------+------------------+---------------+
```

```text
Browser Client (Laptop)
       │
       ▼ [1. DNS Resolution: Query A record -> returns Public IP]
       │
       ▼ [2. TCP Handshake: SYN -> SYN/ACK -> ACK on Port 443]
       │
       ▼ [3. TLS 1.3 Handshake: Certificate negotiation & key exchange]
       │
       ▼ [4. IP Routing: Packet traverses ISP and AWS Edge Routers]
       │
       ▼ [5. AWS Internet Gateway: Routes packet to target VPC]
       │
       ▼ [6. Subnet NACL: Stateless evaluation (ALLOW Rule)]
       │
       ▼ [7. Security Group: Stateful evaluation (ALLOW Inbound 443)]
       │
       ▼ [8. EC2 Instance OS: Kernel decapsulates Ethernet -> IP -> TCP]
       │
       ▼ [9. Web Server (NGINX/Caddy): Processes HTTP request and serves response]
```

```powershell
ipconfig /all
```

```powershell
route print -4
```

```powershell
ping 1.1.1.1 -n 4
```

```powershell
tracert -d -h 10 1.1.1.1
```

```powershell
curl.exe -I https://example.com
```

---

## Day 228/1000 — Day 2/28: IPv4 Address Structure & Binary Conversion
- **Date:** 15 October 2026 (Calendar: October 15, 2026 (Thursday))

```text
192.168.1.10
 │   │  │ │
 └─┬─┘  │ └─ 4th Octet (Host)
   │    └─── 3rd Octet (Subnet/Host)
   └──────── 1st & 2nd Octets (Network)
```

```text
IP:          192.168.1.10 /24
Binary IP:   11000000.10101000.00000001 . 00001010
Mask:        11111111.11111111.11111111 . 00000000  (255.255.255.0)
             |←------- Network (24 bits) -------→|← Host (8 bits) →|
```

```text
VPC CIDR: 10.0.0.0/16 (65,536 Total IPs)
 ├── us-east-1a Public Subnet:   10.0.1.0/24  (251 usable) -> Connected to IGW
 ├── us-east-1b Public Subnet:   10.0.2.0/24  (251 usable) -> Connected to IGW
 ├── us-east-1a Private Subnet:  10.0.10.0/24 (251 usable) -> App Layer (NAT GW egress)
 ├── us-east-1b Private Subnet:  10.0.20.0/24 (251 usable) -> App Layer (NAT GW egress)
 ├── us-east-1a DB Subnet:       10.0.30.0/24 (251 usable) -> Isolated RDS
 └── us-east-1b DB Subnet:       10.0.40.0/24 (251 usable) -> Isolated RDS
```

---

## Day 229/1000 — Day 3/28: Special and Reserved IPv4 Address Ranges
- **Date:** 16 October 2026 (Calendar: October 16, 2026 (Friday))

```text
               RFC 1918 Address Space
 ┌──────────────────────────────────────────────────┐
 │ Class A: 10.0.0.0/8      (16,777,216 addresses)  │
 ├──────────────────────────────────────────────────┤
 │ Class B: 172.16.0.0/12   (1,048,576 addresses)   │
 ├──────────────────────────────────────────────────┤
 │ Class C: 192.168.0.0/16  (65,536 addresses)      │
 └──────────────────────────────────────────────────┘
```

```text
Customer LAN           Customer WAN          ISP CGNAT Pool          Public Internet
192.168.1.100  ──►  100.72.10.5 (CPE)  ──►  ISP NAT Gateways  ──►  203.0.113.1 (Public)
```

```bash
# Verify loopback interface on Linux
ip addr show lo
```

```text
EC2 Instance (OS) ───────── HTTP GET ─────────► AWS Hypervisor (169.254.169.254)
                                                 Returns: IAM Role Credentials
```

```bash
# Step 1: Request a secure session token (TTL: 6 hours)
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Step 2: Fetch metadata using the session token header
curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

```bash
ip -4 addr show
```

```bash
ip route
```

```bash
ping -c 4 127.0.0.1
getent hosts localhost
```

```bash
ip route get 127.0.0.1
ip route get 8.8.8.8
```

---

## Day 230/1000 — Day 4/28: CIDR Notation and Prefix Math
- **Date:** October 17, 2026 (Calendar: October 17, 2026 (Saturday))

*No standalone code blocks recorded for this day.*

---

## Day 231/1000 — Day 5/28: Subnetting by Hand & Route Aggregation
- **Date:** 18 October 2026 (Calendar: October 18, 2026 (Sunday))

```text
Original Address (/24):
[ 24 Network Bits ] [ 8 Host Bits ]

Borrow 2 Bits for Subnets (/26):
[ 24 Network Bits ] [ 2 Subnet Bits ] [ 6 Host Bits ]
```

```text
Prefix | Bits Borrowed (s) | Host Bits (h) | Subnets Created (2^s) | IPs per Subnet (2^h)
-------+-------------------+---------------+-----------------------+---------------------
/24    | 0                 | 8             | 1                     | 256
/25    | 1                 | 7             | 2                     | 128
/26    | 2                 | 6             | 4                     | 64
/27    | 3                 | 5             | 8                     | 32
/28    | 4                 | 4             | 16                    | 16
/29    | 5                 | 3             | 32                    | 8
/30    | 6                 | 2             | 64                    | 4
```

```text
Block Size = 256 - Mask Octet Value
```

```text
Subnet 1: 10.0.50.0/27    (Range: .1  - .30,  Broadcast: .31)
Subnet 2: 10.0.50.32/27   (Range: .33 - .62,  Broadcast: .63)
Subnet 3: 10.0.50.64/27   (Range: .65 - .94,  Broadcast: .95)
Subnet 4: 10.0.50.96/27   (Range: .97 - .126, Broadcast: .127)
Subnet 5: 10.0.50.128/27  (Range: .129 - .158, Broadcast: .159)
Subnet 6: 10.0.50.160/27  (Range: .161 - .190, Broadcast: .191)
Subnet 7: 10.0.50.192/27  (Range: .193 - .222, Broadcast: .223)
Subnet 8: 10.0.50.224/27  (Range: .225 - .254, Broadcast: .255)
```

```text
                             10.0.0.0/24 (256 IPs)
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼                                       ▼
          10.0.0.0/25 (128 IPs)                   10.0.0.128/25 (128 IPs)
                 │                                       │
         ┌───────┴───────┐                       ┌───────┴───────┐
         ▼               ▼                       ▼               ▼
   10.0.0.0/26    10.0.0.64/26            10.0.0.128/26   10.0.0.192/26
     (64 IPs)        (64 IPs)                (64 IPs)        (64 IPs)
```

```text
Multiple Specific Routes                Single Aggregate Route
10.0.0.0/24 ───┐
10.0.1.0/24 ───┼────────────────────►   10.0.0.0/22
10.0.2.0/24 ───┤
10.0.3.0/24 ───┘
```

```text
Subnet          3rd Octet Decimal   3rd Octet Binary
10.0.0.0/24     0                   0 0 0 0 0 0 | 0 0
10.0.1.0/24     1                   0 0 0 0 0 0 | 0 1
10.0.2.0/24     2                   0 0 0 0 0 0 | 1 0
10.0.3.0/24     3                   0 0 0 0 0 0 | 1 1
                                    ▲ ▲ ▲ ▲ ▲ ▲
                                    6 Common Bits
```

```text
10.0.1.0/24 -> 00000001
10.0.2.0/24 -> 00000010
```

```text
       Spoke VPC A               Spoke VPC B
     [ 10.100.0.0/24 ]         [ 10.100.1.0/24 ]
            │                         │
            └───────────┬─────────────┘
                        ▼
             AWS Transit Gateway (TGW)
            ┌─────────────────────────┐
            │ Advertises:             │
            │ 10.100.0.0/22           │  ◄── Single Summary Route
            └───────────┬─────────────┘
                        │ (BGP over Direct Connect)
                        ▼
             On-Premises Data Center
              Corporate Core Router
        (Route table only needs 1 entry!)
```

```bash
cat << 'EOF' > subnet_calc.sh
#!/usr/bin/env bash
# subnet_calc.sh - Simple Subnet & Block Size Calculator
set -euo pipefail

usage() {
    echo "Usage: $0 <IP> <PREFIX>"
    echo "Example: $0 192.168.1.75 26"
    exit 1
}

[[ $# -ne 2 ]] && usage

IP="$1"
PREFIX="$2"

IFS='.' read -r o1 o2 o3 o4 <<< "$IP"

if (( PREFIX >= 24 && PREFIX <= 30 )); then
    host_bits=$(( 32 - PREFIX ))
    total_ips=$(( 2 ** host_bits ))
    block_size=$total_ips
    mask_octet=$(( 256 - block_size ))
    
    net_o4=$(( (o4 / block_size) * block_size ))
    bcast_o4=$(( net_o4 + block_size - 1 ))
    first_o4=$(( net_o4 + 1 ))
    last_o4=$(( bcast_o4 - 1 ))
    
    echo "=========================================="
    echo "       SUBNET CALCULATION REPORT"
    echo "=========================================="
    echo "Input IP / Prefix:     ${IP}/${PREFIX}"
    echo "Subnet Mask:           255.255.255.${mask_octet}"
    echo "Block Size:            ${block_size}"
    echo "Total IP Addresses:    ${total_ips}"
    echo "Network Address:       ${o1}.${o2}.${o3}.${net_o4}"
    echo "Broadcast Address:     ${o1}.${o2}.${o3}.${bcast_o4}"
    echo "Usable Host Range:     ${o1}.${o2}.${o3}.${first_o4} - ${o1}.${o2}.${o3}.${last_o4}"
    echo "On-Prem Usable Hosts:  $(( total_ips - 2 ))"
    echo "AWS Usable Hosts:      $(( total_ips - 5 ))"
    echo "=========================================="
else
    echo "This quick script demonstrates 4th octet subnetting (/24 to /30)."
fi
EOF
chmod +x subnet_calc.sh
```

```bash
./subnet_calc.sh 192.168.1.75 26
```

```text
Subnetting Decision
       │
       ▼
How many subnets / hosts needed?
       │
       ├── Splitting a Block?
       │       │
       │       ▼
       │   Find 2^s >= N  ──► New Prefix = Old Prefix + s
       │       │
       │       ▼
       │   Block Size = 256 - Mask Octet
       │       │
       │       ▼
       │   Count by Block Size from 0
       │
       └── Aggregating Routes?
               │
               ▼
           Must be power of 2 contiguous blocks
               │
               ▼
           Convert differing octet to binary
               │
               ▼
           Count matching bits ──► New Shortened Prefix
```

```text
Bit Borrowing & Subnetting
           │
           ▼
     AWS VPC Sizing
  (Public / Private / DB)
           │
           ▼
Transit Gateway Route Tables
           │
           ▼
   Route Summarization
(Avoids 50-route AWS limits)
           │
           ▼
Kubernetes Pod CIDRs & IPAM
           │
           ▼
Production Resilience & Scale
```

---

