# Week 34 Resources: Cloud Networking: IPAM, IPv6, Routing, VPC Architecture & Cloud Interconnects

## 📅 Timeline: Days 232 - 238 (October 19, 2026 – October 25, 2026)

---

## Day 232/1000 — Day 6/28: Address Planning for Cloud Environments
- **Date:** 19 October 2026 (Calendar: October 19, 2026 (Monday))

```text
               VPC Sizing Spectrum
 ┌────────────────────────────────────────────────────────┐
 │ /16 (65,536 IPs)   ── Default for Monolithic / Core    │
 │ /20 (4,096 IPs)    ── Standard for Single Microservice │
 │ /22 (1,024 IPs)    ── Lean Workload / Isolated Sandbox │
 │ /24 (256 IPs)      ── Specialized Edge / Bastion VPC   │
 └────────────────────────────────────────────────────────┘
```

```text
                    VPC: 10.0.0.0/20 (4,096 IPs)
                                  │
         ┌────────────────────────┼────────────────────────┐
         ▼                        ▼                        ▼
  Container Tier           Database Tier              Public ALB Tier
  10.0.0.0/22 (AZ-a)       10.0.8.0/26 (AZ-a)         10.0.9.0/27 (AZ-a)
  10.0.4.0/22 (AZ-b)       10.0.8.64/26 (AZ-b)        10.0.9.32/27 (AZ-b)
  (1,019 IPs per AZ)       (59 IPs per AZ)            (27 IPs per AZ)
```

```text
INCORRECT (Fragmented):
[ /28 ][ ... Unusable Gap ... ][    /22 Subnet    ]

CORRECT (Contiguous & Packed):
[         /22 Subnet         ][ /24 Subnet ][ /26 ][ /28 ]
```

```text
                      Enterprise WAN (10.0.0.0/8)
                                  │
         ┌────────────────────────┼────────────────────────┐
         ▼                        ▼                        ▼
   US-East Region          EU-West Region             On-Premises Data Center
   (10.0.0.0/12)           (10.16.0.0/12)             (10.128.0.0/10)
         │                        │
   ┌─────┴─────┐            ┌─────┴─────┐
   ▼           ▼            ▼           ▼
Prod-VPC    Dev-VPC      Prod-VPC    Dev-VPC
10.0.0.0/16 10.1.0.0/16  10.16.0.0/16 10.17.0.0/16
```

```text
                  AWS Organization Root
                            │
               ┌────────────┴────────────┐
               ▼                         ▼
         Private Scope              Public Scope
         (Internal RFC 1918)       (BYOIP / Public IPv4)
               │
      Top-Level Pool (10.0.0.0/8)
               │
    ┌──────────┴──────────┐
    ▼                     ▼
Regional Pool         Regional Pool
us-east-1 (10.0.0.0/12) eu-west-1 (10.16.0.0/12)
    │
    ▼
Prod Pool (10.0.0.0/16)
    │
    ▼ (Automated Sub-allocation via Terraform)
VPC-01 (10.0.0.0/20)
```

```bash
cat << 'EOF' > cloud_ipam_planner.sh
#!/usr/bin/env bash
# cloud_ipam_planner.sh - VLSM Subnet Planning & Validation Tool
set -euo pipefail

echo "=========================================================="
echo "         CLOUD INFRASTRUCTURE VLSM IPAM PLANNER           "
echo "=========================================================="

# Display a planned VPC architecture from 10.0.0.0/20
VPC_CIDR="10.0.0.0/20"
echo "Base VPC CIDR: $VPC_CIDR (Total IPs: 4,096)"
echo "----------------------------------------------------------"

declare -a SUB_TIERS=(
    "EKS-Pods-AZ1|10.0.0.0/22|1024|1019|Container Tier AZ-a"
    "EKS-Pods-AZ2|10.0.4.0/22|1024|1019|Container Tier AZ-b"
    "App-Nodes-AZ1|10.0.8.0/24|256|251|EC2 Application AZ-a"
    "App-Nodes-AZ2|10.0.9.0/24|256|251|EC2 Application AZ-b"
    "RDS-DB-AZ1|10.0.10.0/26|64|59|Aurora Primary AZ-a"
    "RDS-DB-AZ2|10.0.10.64/26|64|59|Aurora Replica AZ-b"
    "Public-ALB-AZ1|10.0.10.128/27|32|27|Ingress Controller AZ-a"
    "Public-ALB-AZ2|10.0.10.160/27|32|27|Ingress Controller AZ-b"
)

printf "%-16s %-16s %-10s %-10s %-20s\n" "TIER NAME" "CIDR BLOCK" "TOTAL" "AWS USABLE" "ROLE"
echo "----------------------------------------------------------------------------------"

TOTAL_ALLOCATED=0
for entry in "${SUB_TIERS[@]}"; do
    IFS='|' read -r name cidr total usable role <<< "$entry"
    printf "%-16s %-16s %-10s %-10s %-20s\n" "$name" "$cidr" "$total" "$usable" "$role"
    TOTAL_ALLOCATED=$(( TOTAL_ALLOCATED + total ))
done

RESERVED_SPARE=$(( 4096 - TOTAL_ALLOCATED ))
PCT_USED=$(awk -v u="$TOTAL_ALLOCATED" 'BEGIN {printf "%.1f", (u / 4096) * 100}')

echo "----------------------------------------------------------------------------------"
echo "Allocated Addresses:  ${TOTAL_ALLOCATED} / 4,096 (${PCT_USED}%)"
echo "Unallocated Reserve:  ${RESERVED_SPARE} IPs (Available for AZ-c & Future Growth)"
echo "=========================================================="
EOF
chmod +x cloud_ipam_planner.sh
```

```bash
./cloud_ipam_planner.sh
```

```text
Enterprise IP Planning Request
              │
              ▼
    Define Region & Environment
              │
              ▼
   Query Regional IPAM Pool
              │
              ▼
 Allocate Non-Overlapping VPC CIDR
              │
              ▼
 Order Subnet Tiers (Largest to Smallest)
              │
       ┌──────┴──────┐
       ▼             ▼
   Deploy via     Validate Zero Overlap
   Terraform      in Route Tables
```

```text
Hierarchical IPAM Planning
             │
             ▼
     Multi-Account AWS
   (VPC / Subnet CIDRs)
             │
             ▼
  Transit Gateway & Direct Connect
(Seamless Non-Overlapping Peering)
             │
             ▼
 High-Density EKS VPC CNI
(Secondary 100.64.0.0/10 Pod CIDRs)
             │
             ▼
Zero-Downtime Enterprise Scale
```

---

## Day 233 — Day 7/28: IPv6 and Dual-Stack Networking
- **Date:** October 20, 2026 (Calendar: October 20, 2026 (Tuesday))

```powershell
ipconfig
```

```powershell
Get-NetIPAddress -AddressFamily IPv6
```

```powershell
Get-NetIPAddress |
    Select-Object InterfaceAlias, AddressFamily, IPAddress
```

```bash
ip -6 addr show
```

```bash
ip -6 route show
```

```bash
ping -6 2606:4700:4700::1111
```

---

## Day 234/1000 — Routing Fundamentals
- **Date:** October 21, 2026 (Calendar: October 21, 2026 (Wednesday))

```text
                  Incoming Packet (Dest IP: 10.1.2.50)
                               │
                               ▼
                   ┌───────────────────────┐
                   │ Routing Table Lookup  │ ◄── [Control Plane: Routing]
                   │ (Longest Prefix Match)│
                   └───────────┬───────────┘
                               │ Next-hop decided
                               ▼
                   ┌───────────────────────┐
                   │ Transmit out eth0     │ ◄── [Data Plane: Forwarding]
                   │ to Router C MAC       │
                   └───────────────────────┘
```

```bash
ip route
```

```bash
ip -6 route
```

```bash
ip route get 8.8.8.8
ip route get 1.1.1.1
```

```text
8.8.8.8 via 192.168.1.1 dev eth0 src 192.168.1.50 uid 1000
    cache 
```

```text
Prefix Length    Coverage Scope             Specificity
/0               Whole IPv4 Universe (4.3B) Least Specific (Catch-All)
 │
/8               Class A (16.7M IPs)        Broad
 │
/16              VPC Network (65.5K IPs)    Medium
 │
/24              Subnet (256 IPs)           High
 │
/32              Single Host (1 IP)         Maximum Specificity (Host Route)
```

```text
0.0.0.0/0
```

```text
::/0
```

```text
On-Premises Data Center
(Advertises 192.168.0.0/16 via BGP)
             │
             ▼ [IPsec VPN / Direct Connect]
AWS Virtual Private Gateway (VGW)
             │
             ▼ [Route Propagation: ENABLED]
VPC Route Table
Destination: 192.168.0.0/16  |  Target: vgw-xxxx  |  Type: Propagated
```

```text
Destination: 10.0.0.0/16  |  Target: local
```

```text
                      Incoming Destination IP
                                 │
                                 ▼
             ┌───────────────────────────────────────┐
             │ Stage 1: Longest Prefix Match (LPM)   │
             │   Does one route have a longer prefix?│
             └───────────────────┬───────────────────┘
                                 │
                 ┌───────────────┴───────────────┐
                 ▼ YES                           ▼ NO (Prefixes are Equal)
         Select Route with               ┌───────────────────────────────┐
         Longest Prefix                  │ Stage 2: AWS Route Priority   │
         (e.g., /24 beats /16)           │   Evaluate Route Origin Type  │
                                         └───────────────┬───────────────┘
                                                         │
                                         ┌───────────────┴───────────────┐
                                         ▼                               ▼
                                   Static Route                  Propagated Route
                                   WINS PRECEDENCE               OVERRIDDEN
```

```text
                       [ Internet ]
                            │
                            ▼
               ┌────────────────────────┐
               │ Internet Gateway (IGW) │
               └────────────┬───────────┘
                            │
               ┌────────────┴───────────┐
               │  Public Subnet (10.0.1.0/24)
               │  - Route: 0.0.0.0/0 -> IGW
               │  - NAT Gateway (10.0.1.50)
               └────────────┬───────────┘
                            │ Outbound Egress via NAT
                            ▼
               ┌────────────────────────┐
               │ Private Subnet (10.0.2.0/24)
               │ - Route: 10.0.0.0/16 -> local
               │ - Route: 0.0.0.0/0 -> nat-0123456789
               └────────────────────────┘
```

```bash
ip route show
```

```text
default via 192.168.1.1 dev eth0 proto dhcp metric 100 
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.50 metric 100 
```

```bash
ip -6 route show
```

```bash
ip route get 8.8.8.8
ip route get 10.0.5.25
```

---

## Day 235/1000 — Networking Mastery: ARP, MAC Addresses, and Local Delivery
- **Date:** October 22, 2026 (Calendar: October 22, 2026 (Thursday))

```text
       [ Laptop A ]                   [ Computer B ]
      192.168.1.10                    192.168.1.20
            │                               │
            └───────────────┬───────────────┘
                            ▼
                  [ Layer 2 Switch ]
                            │
               ┌────────────┴────────────┐
               ▼                         ▼
      Same-Subnet Delivery       [ Default Gateway ]
     (Direct MAC-to-MAC,            192.168.1.1
      No Router Traversal)               │
                                         ▼ (Routed Layer 3 Hop)
                                   [ Server C ]
                                   192.168.2.50
```

```text
Laptop A (192.168.1.10)                           Computer B (192.168.1.20)
       │                                                      │
       │─── ARP Request (Broadcast: FF:FF:FF:FF:FF:FF) ──────►│
       │    "Who has 192.168.1.20? Tell 192.168.1.10"        │
       │                                                      │
       │◄── ARP Reply (Unicast to AA:AA:AA:AA:AA:01) ─────────│
       │    "192.168.1.20 is at BB:BB:BB:BB:BB:02"            │
       │                                                      │
  [Caches Entry in ARP Table]                                 │
       │                                                      │
       │─── Data Frame (Dest MAC: BB:BB:BB:BB:BB:02) ────────►│
```

```text
[ Laptop A ] ──(Link 1)──► [ Router Interface 1 | Router Interface 2 ] ──(Link 2)──► [ Server C ]
```

```text
                  Local Wi-Fi Subnet
      [ Laptop ] ──────────────────── [ Printer ]   ✔ Works locally!
          │
          ✕ (Gateway Unreachable / Down)
          ▼
   [ Default Gateway ]
          │
          ▼
    [ Internet ]                                     ✖ Appears totally down!
```

```powershell
ipconfig /all
```

```powershell
arp -a
```

```powershell
# Ping gateway to ensure fresh entry
ping 192.168.1.1 -n 2
arp -a | findstr "192.168.1.1"
```

```powershell
route print -4
```

```powershell
tracert -d -h 5 1.1.1.1
```

```bash
# View IP and MAC addresses
ip -br addr show

# View the Linux ARP / Neighbor cache
ip neigh show

# View routing table
ip route show

# Trace route decisions
ip route get 8.8.8.8
```

```text
               AWS VPC: 10.0.0.0/16
 ┌─────────────────────────────────────────────────────────┐
 │  Subnet A (10.0.1.0/24)        Subnet B (10.0.2.0/24)   │
 │   ┌───────────────┐             ┌───────────────┐       │
 │   │  EC2 Instance │             │  RDS Database │       │
 │   │  (10.0.1.10)  │             │  (10.0.2.50)  │       │
 │   └───────┬───────┘             └───────┬───────┘       │
 │           │                             │               │
 │           ▼                             ▲               │
 │     AWS Nitro ENI                 AWS Nitro ENI         │
 │           │                             │               │
 │           └────────► VPC Router ────────┘               │
 │                     (10.0.1.1)                          │
 └─────────────────────────────────────────────────────────┘
```

---

## Day 236/1000 — Virtual Private Cloud (VPC) Building Blocks
- **Date:** October 23, 2026 (Calendar: October 23, 2026 (Friday))

```text
AWS Region: ap-south-1 (Mumbai)
|
+-- VPC: 10.0.0.0/16
    |
    +-- Availability Zone A
    |   |
    |   +-- Public Subnet A: 10.0.1.0/24
    |   +-- Private Subnet A: 10.0.11.0/24
    |
    +-- Availability Zone B
        |
        +-- Public Subnet B: 10.0.2.0/24
        +-- Private Subnet B: 10.0.12.0/24
```

```text
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        igw-12345678
```

```text
Destination      Target
10.0.0.0/16      local
```

```text
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        igw-12345678
```

```text
Destination       Target
2001:db8:1234::/56 local
::/0               eigw-12345678
```

```text
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        igw-12345678
```

```text
10.0.0.0/16      local
10.0.1.0/24      SomeOtherTarget
0.0.0.0/0        igw-12345678
```

```text
VPC
|
+-- Main Route Table
|   |
|   +-- Subnets without explicit associations
|
+-- Public Route Table
|   |
|   +-- Public Subnet A
|   +-- Public Subnet B
|
+-- Private Route Table A
|   |
|   +-- Private Subnet A
|
+-- Private Route Table B
    |
    +-- Private Subnet B
```

```text
IP address:       10.0.1.25
Subnet mask:      255.255.255.0
Default gateway:  10.0.1.1
DNS resolver:     AmazonProvidedDNS
```

```text
example.com -> IP address
```

```text
Internet
   |
   v
Internet Gateway
   |
   v
VPC: 10.0.0.0/16
   |
   +-- Availability Zone A
   |   |
   |   +-- Public Subnet: 10.0.1.0/24
   |   |   |
   |   |   +-- Web Server
   |   |
   |   +-- Private Subnet: 10.0.11.0/24
   |       |
   |       +-- Application Server
   |
   +-- Availability Zone B
       |
       +-- Public Subnet: 10.0.2.0/24
       |   |
       |   +-- Web Server
       |
       +-- Private Subnet: 10.0.12.0/24
           |
           +-- Application Server
```

```text
VPC CIDR: 10.0.0.0/16
Region: ap-south-1
```

```text
Public Subnet A:  10.0.1.0/24
Public Subnet B:  10.0.2.0/24

Private Subnet A: 10.0.11.0/24
Private Subnet B: 10.0.12.0/24
```

```text
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        Internet Gateway
```

```text
enableDnsSupport
enableDnsHostnames
```

---

## Day 237/1000 — Day 11/28: NAT and Outbound Connectivity
- **Date:** 24 October 2026 (Calendar: October 24, 2026 (Saturday))

```text
Private Subnet (RFC 1918)             NAT Device                Public Internet
┌─────────────────────────┐     ┌───────────────────────┐     ┌─────────────────┐
│ EC2 Instance: 10.0.2.10 │ ──► │ Translates Source IP  │ ──► │ External Server │
│                         │     │ to 198.51.100.10      │     │ 142.250.0.1:443 │
└─────────────────────────┘     └───────────────────────┘     └─────────────────┘
```

```text
Before Translation (Internal Link):
Source:      10.0.2.10:52410
Destination: 142.250.0.1:443

After Translation (Internet Egress):
Source:      198.51.100.10:41002 (NAT Gateway Public Elastic IP)
Destination: 142.250.0.1:443
```

```text
Before Translation (Public Ingress):
Source:      203.0.113.20:61000
Destination: 198.51.100.20:80 (Public IP of Firewall / Gateway)

After Translation (Internal Routing):
Source:      203.0.113.20:61000
Destination: 10.0.2.10:8080 (Private Internal Web Server)
```

```text
Private Host A (10.0.2.10:51500) ──┐
                                   ├──► [ NAT Gateway (198.51.100.10) ] ──► External Server (142.250.0.1:443)
Private Host B (10.0.2.11:51500) ──┘    Maps Host A -> 198.51.100.10:40001
                                        Maps Host B -> 198.51.100.10:40002
```

```text
1. Outbound Request:
   10.0.2.10:51500 ──► [NAT Gateway: Record Session] ──► 142.250.0.1:443

2. NAT State Entry Created:
   [TCP | 10.0.2.10:51500 <---> 198.51.100.10:40001 <---> 142.250.0.1:443 | ESTABLISHED]

3. Inbound Response:
   142.250.0.1:443 ──► [NAT Gateway: Match Entry] ──► 10.0.2.10:51500
```

```text
[ VPC: 10.0.0.0/16 ]
 │
 ├── [ Public Subnet (10.0.1.0/24) ]
 │    - Route: 0.0.0.0/0 ──► Internet Gateway (igw-xxxx)
 │    - NAT Gateway (Elastic IP: 198.51.100.10)
 │
 └── [ Private Subnet (10.0.2.0/24) ]
      - Route: 10.0.0.0/16 ──► local
      - Route: 0.0.0.0/0    ──► NAT Gateway (nat-xxxx)
      - EC2 Instance (10.0.2.10)
```

```text
                  [ Internet Gateway ]
                            │
         ┌──────────────────┴──────────────────┐
         ▼                                     ▼
   Availability Zone A                   Availability Zone B
   ┌───────────────────────────────┐     ┌───────────────────────────────┐
   │ Public Subnet A               │     │ Public Subnet B               │
   │  - NAT Gateway A (EIP 1)      │     │  - NAT Gateway B (EIP 2)      │
   ├───────────────────────────────┤     ├───────────────────────────────┤
   │ Private Subnet A              │     │ Private Subnet B              │
   │  - Route: 0.0.0.0/0 -> NAT-A  │     │  - Route: 0.0.0.0/0 -> NAT-B  │
   │  - Workload Nodes             │     │  - Workload Nodes             │
   └───────────────────────────────┘     └───────────────────────────────┘
```

---

## Day 238 — Day 12/28: Connecting Networks Inside the Cloud
- **Date:** October 25, 2026 (Calendar: October 25, 2026 (Sunday))

```text
       VPC A (10.0.0.0/16)                    VPC B (10.1.0.0/16)
 ┌─────────────────────────────┐        ┌─────────────────────────────┐
 │ App Server (10.0.1.10)      │        │ DB Server (10.1.2.50)       │
 └──────────────┬──────────────┘        └──────────────┬──────────────┘
                │                                      │
                └────────► [ VPC Peering (pcx) ] ◄─────┘
                            Direct Layer-3 Path
```

```text
VPC A (10.0.0.0/16) ◄──[pcx-ab]──► VPC B (10.1.0.0/16) ◄──[pcx-bc]──► VPC C (10.2.0.0/16)
        │                                                                    │
        ✕ ─── NO DIRECT ROUTING (VPC B cannot act as a transit router!) ─────✕
```

```text
                          AWS Transit Gateway (Hub)
                               ┌─────────────┐
                               │     TGW     │
                               └──────┬──────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
     VPC A: Application      VPC B: Database         VPC C: AI Workloads
       (10.0.0.0/16)           (10.1.0.0/16)           (10.2.0.0/16)
```

```text
Full-Mesh Peering (190 Links)             Transit Gateway (20 Links)
       ┌───┐     ┌───┐                          ┌───┐     ┌───┐
       │VPC│─────│VPC│                          │VPC│     │VPC│
       └─┬─┘╲   ╱└─┬─┘                          └──┬┘     └─┬─┘
         │   ╲ ╱   │                                ╲     ╱
         │    ╳    │                               ┌──┴─┴──┐
         │   ╱ ╲   │                               │  TGW  │
       ┌─┴─┐╱   ╲┌─┴─┐                             └──┬─┬──┘
       │VPC│─────│VPC│                              ╱     ╲
       └───┘     └───┘                          ┌──┴┐     ┌─┴─┐
   Complex, Unmaintainable                      │VPC│     │VPC│
                                                └───┘     └───┘
                                             Clean Hub-and-Spoke
```

```text
                      Private EC2 Instance (10.0.2.10)
                                    │
                   ┌────────────────┴────────────────┐
                   ▼                                 ▼
         Gateway Endpoint                   Interface Endpoint
        (S3 and DynamoDB)                (CloudWatch, SSM, Secrets)
                   │                                 │
                   ▼                                 ▼
           Route Table Target                  ENI with Private IP
                   │                                 │
                   ▼                                 ▼
             Amazon S3 API                   AWS Secrets Manager
```

```text
EC2 Instance ──► DNS Query: secretsmanager.us-east-1.amazonaws.com
                 └──► Resolves to Private IP: 10.0.2.145 (Interface Endpoint ENI)
                      └──► Connects privately over HTTPS (Port 443)
```

```text
VPC A: 10.0.0.0/16                                      VPC B: 10.0.0.0/16
Node:  10.0.1.25                                        Node:  10.0.1.25
        │                                                       │
        └───► Destination IP: 10.0.1.25 ◄───────────────────────┘
              Which node is this packet meant for? (AMBIGUOUS!)
```

```text
AWS VPC Route Table:
Destination      Target                   Status
10.1.0.0/16      pcx-0123456789abcdef     Blackhole ◄── Packets dropped silently!
```

```text
1. Identify exact Source and Destination IPs
                      │
                      ▼
2. Check Source Subnet Route Table (Does target route exist and is it ACTIVE?)
                      │
                      ▼
3. Check Target Attachment / Peering Status (Active vs Blackhole?)
                      │
                      ▼
4. Check Transit Gateway Route Table & Propagation (If TGW in path)
                      │
                      ▼
5. Check Destination Subnet Route Table (Does RETURN ROUTE exist?)
                      │
                      ▼
6. Check Destination Security Group (Allows Inbound on Target Port?)
                      │
                      ▼
7. Check Subnet Network ACLs (Allows Inbound AND Outbound Ephemeral?)
                      │
                      ▼
8. Verify DNS Resolution (Does hostname resolve to expected Private IP?)
                      │
                      ▼
9. Verify Target Application Listener (ss -ltn / service running?)
```

---

