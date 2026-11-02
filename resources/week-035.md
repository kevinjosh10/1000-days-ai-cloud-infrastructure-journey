# Week 35 Resources: Cloud Networking: Hybrid Connectivity, Enterprise DNS & Transport Layer Internals

## 📅 Timeline: Days 239 - 245 (October 26, 2026 – November 1, 2026)

---

## Day 239 — Day 13/28: Hybrid Connectivity
- **Date:** October 26, 2026 (Calendar: October 26, 2026 (Monday))

```text
 ┌────────────────────────────────────────────────────────┐
 │            ON-PREMISES ENTERPRISE NETWORK             │
 │  Corporate Data Center (192.168.0.0/16)                │
 │  Database Clusters, Legacy ERP, Active Directory       │
 └──────────────────────────┬─────────────────────────────┘
                            │
              Hybrid Connectivity Layer
    ┌───────────────────────┴───────────────────────┐
    │                                               │
    ▼                                               ▼
[ Site-to-Site IPsec VPN ]             [ Dedicated Private Link ]
Encrypted tunnel over internet        Direct physical fiber circuit
(Cost-effective, rapid setup)          (High throughput, low latency)
    │                                               │
    └───────────────────────┬───────────────────────┘
                            │
 ┌──────────────────────────▼─────────────────────────────┐
 │                AWS / CLOUD INFRASTRUCTURE              │
 │  Virtual Private Cloud (VPC) (10.0.0.0/16)             │
 │  Kubernetes Clusters, Cloud Microservices, S3 Storage  │
 └────────────────────────────────────────────────────────┘
```

```text
  On-Premises Data Center                                AWS Cloud
┌─────────────────────────┐                        ┌────────────────────────┐
│ Customer Gateway (CGW)  │                        │ Virtual Private Gateway│
│ Public IP: 203.0.113.10 │                        │        (VGW/TGW)       │
│ Subnet: 192.168.0.0/16  │                        │ Subnet: 10.0.0.0/16    │
└────────────┬────────────┘                        └───────────┬────────────┘
             │                                                 │
             │===== Tunnel 1 (Encrypted IPsec / Public IP A) ==│
             │                                                 │
             │===== Tunnel 2 (Encrypted IPsec / Public IP B) ==│
             │                                                 │
             └────────────── Public Internet ──────────────────┘
```

```text
Original IPv4 Packet:
┌─────────────────┬─────────────────┬───────────────────────────────┐
│ Original IP Hdr │  TCP/UDP Header │            Payload            │
└─────────────────┴─────────────────┴───────────────────────────────┘

IPsec Tunnel Mode (ESP):
┌────────────┬─────────────┬─────────────────┬──────────┬─────────┬─────────────┬──────────┐
│ New IP Hdr │ ESP Header  │ Original IP Hdr │ TCP Hdr  │ Payload │ ESP Trailer │ ESP Auth │
└────────────┴─────────────┴─────────────────┴──────────┴─────────┴─────────────┴──────────┘
             │◄────────────────────── ENCRYPTED ─────────────────►│             │
             │◄─────────────────────── AUTHENTICATED ──────────────────────────►│
```

```text
Step 1: IKE Phase 1 (Control Channel)
CGW <=======================================================> AWS VGW/TGW
     - Negotiate IKE SA (Security Association)
     - Diffie-Hellman Key Exchange (DH Groups 14, 19, 20, 21)
     - Authenticate via Pre-Shared Key (PSK) or X.509 Certificate
     - Result: Secure encrypted bidirectional management channel (ISAKMP SA)

Step 2: IKE Phase 2 (Data Tunnels)
CGW <=======================================================> AWS VGW/TGW
     - Negotiate IPsec SA parameters within the secure Phase 1 channel
     - Select Encryption (AES-256, AES-GCM-128/256)
     - Select Hashing/Integrity (SHA-256, SHA-384, SHA-512)
     - Establish Traffic Selectors (0.0.0.0/0 for route-based or specific CIDRs)
     - Result: Bidirectional IPsec SAs for user payload traffic forwarding
```

```text
Static Routing (Policy or Route-based):
  [CGW] ──── Static Route: 10.0.0.0/16 ────► [VGW Tunnel 1]
  [CGW] ──── Static Route: 10.0.0.0/16 ────► [VGW Tunnel 2 (Standby)]
  * Problem: Manual configuration. Requires Dead Peer Detection (DPD) to failover.
  * Limitation: No equal-cost multi-path (ECMP) aggregation across tunnels.

Dynamic Routing (BGP):
  [CGW (AS 65001)] ◄──── BGP Route Exchange ────► [VGW (AS 64512)]
  * Auto-discovers new subnets without router configuration changes.
  * Sub-second path failover using BFD (Bidirectional Forwarding Detection).
  * Supports ECMP (Equal-Cost Multi-Path) across both tunnels for up to 2.5 Gbps aggregate throughput.
```

```text
 On-Premises Data Center         Colocation Facility (Direct Connect Location)        AWS Cloud
┌─────────────────────────┐      ┌──────────────────────────────────────────────┐    ┌─────────────────┐
│ Enterprise Core Router  │──────│ Customer Cage  ◄─ Cross-Connect ─► AWS Cage  │────│ Direct Connect  │
│ (10G/100G Fiber Uplink) │      │ (Partner Routers)    (Fiber Patch) (AWS Edge)│    │ Location Router │
└─────────────────────────┘      └──────────────────────────────────────────────┘    └────────┬────────┘
                                                                                              │
                                  Dedicated Private Layer-2/3 Physical Circuit                ▼
                                  (Predictable latency, zero internet jitter)          [ Direct Connect ]
                                                                                       [    Gateway     ]
                                                                                              │
                                                      ┌───────────────────────────────────────┴──────────┐
                                                      ▼                                                  ▼
                                            ┌───────────────────┐                              ┌───────────────────┐
                                            │ VPC A (Production)│                              │ VPC B (Analytics) │
                                            └───────────────────┘                              └───────────────────┘
```

```text
                               Direct Connect Link (Physical 10G)
                                                │
                                    ┌───────────┴───────────┐
                                    │ Direct Connect Port   │
                                    └───────────┬───────────┘
                                                │
              ┌─────────────────────────────────┼─────────────────────────────────┐
              ▼                                 ▼                                 ▼
      [ Private VIF ]                    [ Public VIF ]                    [ Transit VIF ]
      VLAN 100                           VLAN 200                          VLAN 300
      BGP Peer: Private ASN              BGP Peer: Public ASN              BGP Peer: DXGW ASN
      Target: Single VPC / VGW           Target: AWS S3 & DynamoDB         Target: AWS Transit Gateway
      IP Space: 10.0.0.0/16              IP Space: AWS Public IPs          IP Space: Hundreds of VPCs
```

```text
   On-Premises Autonomous System                        AWS Autonomous System
            AS 65001                                            AS 64512
 ┌─────────────────────────────┐                     ┌─────────────────────────────┐
 │ Customer Edge Router (BGP)  │◄─── eBGP Peering ──►│ AWS Virtual Private Gateway │
 │ BGP Router ID: 192.168.1.1  │     (TCP Port 179)  │ BGP Router ID: 169.254.10.1 │
 └──────────────┬──────────────┘                     └──────────────┬──────────────┘
                │                                                   │
  Advertises: 192.168.0.0/16                           Advertises: 10.0.0.0/16
  AS Path: [65001]                                     AS Path: [64512]
```

```text
           BGP Route Selection Decision Hierarchy (Simplified)
   ┌─────────────────────────────────────────────────────────────────┐
   │ 1. Highest Weight (Cisco-specific, local router only)          │
   ├─────────────────────────────────────────────────────────────────┤
   │ 2. Highest Local Preference (LOCAL_PREF - intra-AS priority)    │
   ├─────────────────────────────────────────────────────────────────┤
   │ 3. Locally Originated Routes (Locally injected via network cmd) │
   ├─────────────────────────────────────────────────────────────────┤
   │ 4. Shortest AS Path (AS_PATH - fewest ASNs traversed)           │
   ├─────────────────────────────────────────────────────────────────┤
   │ 5. Lowest Origin Type (IGP < EGP < Incomplete)                 │
   ├─────────────────────────────────────────────────────────────────┤
   │ 6. Lowest Multi-Exit Discriminator (MED - inbound metric)      │
   ├─────────────────────────────────────────────────────────────────┤
   │ 7. eBGP over iBGP                                               │
   ├─────────────────────────────────────────────────────────────────┤
   │ 8. Lowest IGP metric to BGP next hop                            │
   ├─────────────────────────────────────────────────────────────────┤
   │ 9. Lowest Router ID                                             │
   └─────────────────────────────────────────────────────────────────┘
```

```text
On-Premises DC (AS 65001)                              AWS Cloud (AS 64512)
 ┌──────────────────────┐                               ┌──────────────────────┐
 │                      │── Primary DX: [65001] (Length 1) ──►│ PREFERRED PATH       │
 │   Customer Router    │                               │                      │
 │                      │── Backup VPN: [65001 65001 65001] ─►│ IGNORED AS LONGER   │
 └──────────────────────┘   (Prepended 3 times, Length 3) └──────────────────────┘
```

```text
                Virtual Private Gateway (VGW)
               Learns on-prem BGP route: 192.168.0.0/16
                              │
                              ▼
                [ Route Propagation: ENABLED ]
                              │
                              ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                 VPC Private Route Table                     │
  ├───────────────────┬──────────────────────┬──────────────────┤
  │ Destination       │ Target               │ Status / Type    │
  ├───────────────────┼──────────────────────┼──────────────────┤
  │ 10.0.0.0/16       │ local                │ Active (Local)   │
  │ 192.168.0.0/16    │ vgw-0a1b2c3d         │ Active (Propagated)│
  │ 0.0.0.0/0         │ nat-09876543         │ Active (Static)  │
  └───────────────────┴──────────────────────┴──────────────────┘
```

```text
Prefix Priority Rule of Thumb:
Most Specific CIDR (/28 > /24 > /16)
   └──► Local VPC Route
         └──► Static Route
               └──► Direct Connect Propagated Route
                     └──► VPN Propagated Route (Shortest AS Path)
```

```text
                             Direct Connect (Primary Path)
                      ┌────────────────────────────────────────┐
                      │ High Throughput / Low Latency (No Enc) │
                      ▼                                        ▼
   On-Premises Data Center                                AWS Cloud (VPC)
  ┌───────────────────────┐                              ┌─────────────────┐
  │ Customer Edge Router  │                              │ Transit Gateway │
  │ (AS 65001)            │                              │ (AS 64512)      │
  └───────────────────────┘                              └─────────────────┘
                      ▲                                        ▲
                      │                                        │
                      └────────────────────────────────────────┘
                              Site-to-Site VPN (Backup Path)
                              AS Path Prepended: [65001 65001 65001]
```

```text
                Hybrid Connectivity Troubleshooting Funnel
       ┌─────────────────────────────────────────────────────────┐
       │ Layer 1 / 2: Physical Link & Cross-Connect Status      │
       │ (Port light, SFP integrity, VLAN tags 802.1Q)           │
       └────────────────────────────┬────────────────────────────┘
                                    ▼
       ┌─────────────────────────────────────────────────────────┐
       │ Layer 3: Point-to-Point IP Ping Reachability            │
       │ (Transit IPs 169.254.x.x, MTU mismatches, MSS clamping) │
       └────────────────────────────┬────────────────────────────┘
                                    ▼
       ┌─────────────────────────────────────────────────────────┐
       │ Layer 4 / Control: IPsec Phase 1 & 2 / BGP State        │
       │ (UDP 500/4500, ESP 50, TCP 179, ASN & MD5 password)    │
       └────────────────────────────┬────────────────────────────┘
                                    ▼
       ┌─────────────────────────────────────────────────────────┐
       │ Routing & Security: VPC Route Tables, NACLs, SGs        │
       │ (Route propagation enabled, stateful firewall rules)    │
       └─────────────────────────────────────────────────────────┘
```

```text
! Step 1: Define BGP Routing Process
router bgp 65001
 bgp router-id 192.168.1.1
 bgp log-neighbor-changes
 
 ! Step 2: Configure AWS VGW as BGP Neighbor over Tunnel 1
 neighbor 169.254.10.1 remote-as 64512
 neighbor 169.254.10.1 description AWS-VGW-Tunnel-1
 neighbor 169.254.10.1 timers 10 30 90
 neighbor 169.254.10.1 fall-over bfd
 
 ! Step 3: Configure AWS VGW as BGP Neighbor over Tunnel 2 (Backup)
 neighbor 169.254.10.5 remote-as 64512
 neighbor 169.254.10.5 description AWS-VGW-Tunnel-2
 neighbor 169.254.10.5 timers 10 30 90
 
 ! Step 4: Advertise On-Premises Subnets to Cloud
 address-family ipv4
  network 192.168.0.0 mask 255.255.0.0
  
  ! Apply Route Map to prepend AS path on Tunnel 2 (Secondary)
  neighbor 169.254.10.5 route-map PREPEND_BACKUP out
  neighbor 169.254.10.1 activate
  neighbor 169.254.10.5 activate
 exit-address-family

! Step 5: Route Map for AS Path Prepending
route-map PREPEND_BACKUP permit 10
 set as-path prepend 65001 65001 65001
```

---

## Day 240 — Day 14: DNS Fundamentals
- **Date:** October 27, 2026 (Calendar: October 27, 2026 (Tuesday))

```text
Domain Name: www.example.com
IPv4 Address: 93.184.216.34
```

```text
                      Hierarchical DNS Tree Architecture
                                     [ . ]
                                 (Root Servers)
                                  13 Root IP Sets
                                  (a.root-servers.net ... m.root-servers.net)
                                       │
            ┌──────────────────────────┼──────────────────────────┐
            ▼                          ▼                          ▼
         [ .com ]                   [ .org ]                   [ .net ]
       (TLD Servers)              (TLD Servers)              (TLD Servers)
            │
            ▼
    [ example.com ]
  (Authoritative Servers)
   ns1.example.com
            │
            ▼
   www.example.com ──► 93.184.216.34 (Resource Record)
```

```text
www.example.com → 93.184.216.34
```

```text
1. User enters www.example.com
              │
              ▼
2. Stub Resolver
   (User's operating system)
              │
              ▼ (Recursive Query)
3. Recursive Resolver
   (ISP, corporate DNS, or 8.8.8.8)
              │
              ├────── 1. Query: Where is www.example.com? ──────► [ 4. Root DNS Server ]
              │◄───── 2. Referral: Ask .com TLD servers ────────┘
              │
              ├────── 3. Query: Where is www.example.com? ──────► [ 5. .com TLD Server ]
              │◄───── 4. Referral: Ask ns1.example.com ──────────┘
              │
              ├────── 5. Query: Where is www.example.com? ──────► [ 6. Authoritative Server ]
              │◄───── 6. Authoritative Answer: 93.184.216.34 ────┘ (ns1.example.com)
              │
              ▼
7. Recursive Resolver caches the answer (stores with TTL)
              │
              ▼ (Final Answer)
8. Resolver returns the answer to Stub Resolver / OS
              │
              ▼
9. Browser connects to destination IP (93.184.216.34:443 via TCP/TLS)
```

```text
  Recursive Query: "Give me the final answer or tell me it doesn't exist."
  ┌──────────────┐         Recursive Query         ┌────────────────────┐
  │ Stub Client  │ ──────────────────────────────► │ Recursive Resolver │
  │              │ ◄────────────────────────────── │ (Delegated Worker) │
  └──────────────┘           Final Answer          └────────────────────┘

  Iterative Query: "If you know the answer, tell me. Otherwise, tell me who to ask next."
  ┌────────────────────┐    Iterative Query        ┌────────────────────┐
  │ Recursive Resolver │ ────────────────────────► │ Root / TLD Server  │
  │ (Does the work)    │ ◄──────────────────────── │                    │
  └────────────────────┘    Referral / Next Hop    └────────────────────┘
```

```text
Laptop → Recursive Resolver
Question: What is the IP address of www.example.com?

Recursive Resolver → Laptop
Answer: 93.184.216.34
```

```text
Recursive Resolver → Root Server
Root Server → Referral to .com servers

Recursive Resolver → .com TLD Server
TLD Server → Referral to authoritative servers

Recursive Resolver → Authoritative Server
Authoritative Server → Requested DNS record (Authoritative Answer)
```

```text
app.example.com → 203.0.113.10
```

```text
DNS Record: app.example.com
IP Address: 203.0.113.10
Configured TTL: 300 seconds
```

```text
Domain: app.example.com
IP Address: 203.0.113.10
TTL: 600 seconds (10 minutes)
```

```text
Timeline:
T = 0s    Resolver queries Authoritative Server ──► TTL received: 600s
T = 150s  Client B queries Resolver             ──► TTL returned: 450s
T = 400s  Client C queries Resolver             ──► TTL returned: 200s
T = 600s  Record EXPIRES from cache
T = 601s  Client D queries Resolver             ──► Resolver queries Authoritative Server again
```

```text
1. DNS Administrator updates Authoritative DNS Record to 203.0.113.50.
2. Resolver Cache still holds 203.0.113.10 with 300s TTL remaining.
3. For the next 300 seconds, clients querying this resolver receive old IP (203.0.113.10).
4. Once TTL reaches 0, the next query triggers a lookup to the authoritative server.
5. The resolver learns and caches the new IP (203.0.113.50).
```

```text
 ┌────────────────────────────────────────────────────────────────────────┐
 │ 1. Browser Cache (Chrome: chrome://net-internals/#dns)                │
 │    Retains records for 60 seconds internally                           │
 └──────────────────────────────────┬─────────────────────────────────────┘
                                    │ Miss
                                    ▼
 ┌────────────────────────────────────────────────────────────────────────┐
 │ 2. Operating System Cache (Windows DNS Client Cache / systemd-resolved)│
 │    Viewed via `ipconfig /displaydns`                                  │
 └──────────────────────────────────┬─────────────────────────────────────┘
                                    │ Miss
                                    ▼
 ┌────────────────────────────────────────────────────────────────────────┐
 │ 3. Local Network / Forwarder (Home router, corporate internal DNS)     │
 └──────────────────────────────────┬─────────────────────────────────────┘
                                    │ Miss
                                    ▼
 ┌────────────────────────────────────────────────────────────────────────┐
 │ 4. Recursive Resolver (ISP, 8.8.8.8, AWS Route 53 Resolver)            │
 └──────────────────────────────────┬─────────────────────────────────────┘
                                    │ Miss
                                    ▼
 ┌────────────────────────────────────────────────────────────────────────┐
 │ 5. Authoritative DNS Server (Origin of Truth)                          │
 └────────────────────────────────────────────────────────────────────────┘
```

```text
                      Cloud DNS Ingress Architecture
                               app.example.com
                                      │
                                      ▼
                        [ Amazon Route 53 (DNS) ]
                                      │
                                      ▼
                      [ Application Load Balancer ]
                               (Dual-Stack)
                                      │
                 ┌────────────────────┴────────────────────┐
                 ▼                                         ▼
     ┌───────────────────────┐                 ┌───────────────────────┐
     │ Target Group (AZ-1a)  │                 │ Target Group (AZ-1b)  │
     │ EC2 / ECS / EKS Pods  │                 │ EC2 / ECS / EKS Pods  │
     └───────────────────────┘                 └───────────────────────┘
```

```text
my-alb-123456789.us-east-1.elb.amazonaws.com
```

```text
db.internal.production
          │
          ▼
 Route 53 Private Hosted Zone
          │
          ▼
   10.0.14.82 (Private IP)
          │
          ▼
 Amazon Aurora Database Cluster
```

```powershell
nslookup example.com
```

```powershell
nslookup example.com 8.8.8.8
```

```powershell
Resolve-DnsName example.com -Type A
```

```powershell
Resolve-DnsName example.com -Type AAAA
```

```powershell
Resolve-DnsName example.com -Type MX
```

```powershell
Resolve-DnsName example.com -Type NS
```

```powershell
ipconfig /displaydns
```

```powershell
ipconfig /flushdns
```

---

## Day 241 — Day 15: DNS Record Types for Infrastructure
- **Date:** October 28, 2026 (Calendar: October 28, 2026 (Wednesday))

```text
Host Resolution Mapping:
┌─────────────────────────┐         ┌─────────────────────────┐
│ Hostname:               │ ── A ──►│ IPv4: 203.0.113.10      │ (32-bit)
│ cloudmorph.example      │         └─────────────────────────┘
│                         │        ┌─────────────────────────┐
│                         │ ─AAAA─►│ IPv6: 2001:db8::10      │ (128-bit)
└─────────────────────────┘        └─────────────────────────┘
```

```dns
cloudmorph.example. 300 IN A 203.0.113.10
```

```dns
cloudmorph.example. 300 IN AAAA 2001:db8::10
```

```text
CNAME Resolution Flow:
1. Client queries: www.cloudmorph.example
                   │
                   ▼
2. Authoritative Server returns: CNAME cloudmorph.example
                   │
                   ▼
3. Client / Resolver queries canonical name: cloudmorph.example
                   │
                   ▼
4. Authoritative Server returns: A 203.0.113.10
```

```dns
www.cloudmorph.example. 300 IN CNAME cloudmorph.example.
```

```text
cloudmorph.example
```

```dns
; INVALID according to DNS RFCs:
cloudmorph.example. IN CNAME my-alb-123.us-east-1.elb.amazonaws.com.
; (Conflicts with mandatory SOA and NS records on cloudmorph.example)

; VALID: Subdomains can freely use CNAME:
www.cloudmorph.example. IN CNAME my-alb-123.us-east-1.elb.amazonaws.com.
```

```text
Conventional CNAME (2 Queries, Prohibited at Apex):
Client ──► Resolver ──► Queries www.example.com ──► Returns CNAME lb.aws.com
Client ──► Resolver ──► Queries lb.aws.com      ──► Returns A 203.0.113.10

Route 53 Alias at Zone Apex (1 Query, Legal at Apex):
Client ──► Route 53 Resolver ──► Queries example.com (Apex)
           Route 53 evaluates AWS resource target internally
       ◄── Returns direct A Record: 203.0.113.10 (Zero extra lookups, zero cost!)
```

```dns
cloudmorph.example. 300 IN MX 10 mail1.cloudmorph.example.
cloudmorph.example. 300 IN MX 20 mail2.cloudmorph.example.
```

```text
Incoming Email to user@cloudmorph.example:
  Sending MTA (e.g. Gmail)
           │
           ▼ (Queries MX for cloudmorph.example)
  ┌───────────────────────────────────────────────────┐
  │ Primary:   mail1.cloudmorph.example (Priority 10) │ ──► Attempt First
  │ Secondary: mail2.cloudmorph.example (Priority 20) │ ──► Fallback if 10 is down
  └───────────────────────────────────────────────────┘
```

```dns
cloudmorph.example. 300 IN TXT "google-site-verification=rXOxyZounn2uXClZ5..."
cloudmorph.example. 300 IN TXT "ms=ms12345678"
```

```dns
cloudmorph.example. 300 IN TXT "v=spf1 ip4:203.0.113.10 include:_spf.google.com -all"
```

```text
  Sending Mail Server                       Receiving Mail Server
┌─────────────────────────┐               ┌─────────────────────────┐
│ Generates private key   │               │ Extracts signature from │
│ signature in email hdr  │ ── Email ───► │ DKIM-Signature header   │
└─────────────────────────┘               └───────────┬─────────────┘
                                                      │
                       DNS Query for Public Key       ▼
             selector1._domainkey.cloudmorph.example  │
             ┌────────────────────────────────────────┴────────────┐
             │ Reads TXT record containing public key (p=MIGfMA0G) │
             │ Cryptographically validates digital signature       │
             └─────────────────────────────────────────────────────┘
```

```dns
selector1._domainkey.cloudmorph.example. 300 IN TXT "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC..."
```

```dns
_dmarc.cloudmorph.example. 300 IN TXT "v=DMARC1; p=reject; rua=mailto:dmarc-reports@cloudmorph.example; pct=100"
```

```text
                   .com TLD Servers
                          │
       Delegates via NS records for cloudmorph.example:
                          ▼
       ┌──────────────────────────────────────┐
       │ ns1.awsdns.example.com               │
       │ ns2.awsdns.example.com               │
       └──────────────────┬───────────────────┘
                          │
                          ▼
             Authoritative Zone Answers:
               A, AAAA, MX, TXT, SRV
```

```dns
cloudmorph.example. 172800 IN NS ns-1024.awsdns-00.org.
cloudmorph.example. 172800 IN NS ns-512.awsdns-00.com.
```

```dns
cloudmorph.example. 300 IN SOA ns1.dns-provider.example. hostmaster.cloudmorph.example. (
    2026102801 ; Serial number (YYYYMMDDNN)
    3600       ; Refresh timer (1 hour)
    600        ; Retry timer (10 minutes)
    1209600    ; Expire timer (2 weeks)
    300        ; Minimum TTL / Negative cache TTL (5 minutes)
)
```

```dns
_service._proto.name.              TTL CLASS SRV Priority Weight Port Target
_sip._tcp.cloudmorph.example.      300 IN    SRV 10       5      5060 sipserver1.cloudmorph.example.
_sip._tcp.cloudmorph.example.      300 IN    SRV 10       10     5060 sipserver2.cloudmorph.example.
_sip._tcp.cloudmorph.example.      300 IN    SRV 20       0      5060 backupsip.cloudmorph.example.
```

```text
Forward DNS Lookup (Name to IP):
  cloudmorph.example ──► 203.0.113.10

Reverse DNS Lookup (IP to Name):
  10.113.0.203.in-addr.arpa ──► server.cloudmorph.example
```

```text
  10.113.0.203.in-addr.arpa
  ```

```text
  0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa
  ```

```text
Certificate Issuance Workflow with CAA:
1. Attacker or rogue admin requests TLS cert for cloudmorph.example from DigiCert.
2. DigiCert mandatory check queries CAA records for cloudmorph.example.
3. CAA Record: 0 issue "letsencrypt.org"
4. DigiCert observes that it is NOT listed in the CAA record.
5. DigiCert REFUSES to issue the certificate and triggers a policy alert!
```

```dns
cloudmorph.example. 300 IN CAA 0 issue "letsencrypt.org"
cloudmorph.example. 300 IN CAA 0 issue "amazon.com"
cloudmorph.example. 300 IN CAA 0 issuewild ";"
cloudmorph.example. 300 IN CAA 0 iodef "mailto:security@cloudmorph.example"
```

```text
Pre-Migration TTL Reduction Strategy:
T - 48 Hours: Lower TTL from 86400 (24h) down to 300s (5m)
              [All global caches refresh their records with new short TTL]
T = 0 (Cutover): Switch IP from Server A (203.0.113.10) to Server B (203.0.113.50)
T + 5 Minutes: 100% of worldwide traffic shifts cleanly to Server B!
T + 24 Hours: Increase TTL back to 86400 (24h) for caching efficiency.
```

```powershell
# 1. Inspect IPv4 A Records
Resolve-DnsName google.com -Type A

# 2. Inspect IPv6 AAAA Records
Resolve-DnsName google.com -Type AAAA

# 3. Inspect Mail Exchanger (MX) Records & Priority
Resolve-DnsName google.com -Type MX

# 4. Inspect TXT Records (SPF and verification tokens)
Resolve-DnsName google.com -Type TXT

# 5. Inspect Name Server (NS) Delegation Records
Resolve-DnsName google.com -Type NS

# 6. Inspect Start of Authority (SOA) Zone Timers
Resolve-DnsName google.com -Type SOA

# 7. Inspect Certification Authority Authorization (CAA) Records
Resolve-DnsName google.com -Type CAA

# 8. Inspect Reverse DNS (PTR) Record
Resolve-DnsName 8.8.8.8 -Type PTR
```

```bash
# Query specific record types cleanly
dig example.com A +short
dig example.com AAAA +short
dig example.com MX +short
dig example.com TXT +short
dig example.com NS +short
dig example.com SOA +multiline
dig example.com CAA +short

# Reverse DNS lookup
dig -x 8.8.8.8 +short

# Trace full hierarchical delegation from Root down to Authoritative Servers
dig +trace example.com
```

---

## Day 242 — Day 16: Cloud DNS Services
- **Date:** October 30, 2026 (Calendar: October 29, 2026 (Thursday))

```text
               ┌─────────────────────────────────────────────────────────┐
               │             Route 53 Hosted Zones Concept               │
               └────────────────────────────┬────────────────────────────┘
                                            │
                    ┌───────────────────────┴───────────────────────┐
                    ▼                                               ▼
       ┌─────────────────────────┐                     ┌─────────────────────────┐
       │   Public Hosted Zone    │                     │   Private Hosted Zone   │
       ├─────────────────────────┤                     ├─────────────────────────┤
       │ Target: Public Internet │                     │ Target: Associated VPCs │
       │ Resolution: Anycast DNS │                     │ Resolution: VPC .2 IP   │
       │ Scope: Global           │                     │ Scope: Internal Only    │
       └─────────────────────────┘                     └─────────────────────────┘
```

```text
                               Split-Horizon Architecture
                                    app.example.com
                                           │
                   ┌───────────────────────┴───────────────────────┐
                   │                                               │
   External Client on Internet                     Internal EC2 Instance in VPC
                   │                                               │
                   ▼                                               ▼
         Public Recursive DNS                            VPC Resolver (10.0.0.2)
                   │                                               │
                   ▼                                               ▼
       Route 53 Public Zone                            Route 53 Private Zone
                   │                                               │
                   ▼                                               ▼
         Public IP: 203.0.113.10                         Private IP: 10.0.2.25
        (Internet Gateway / Public ALB)                 (Internal ALB / Private Microservice)
```

```text
app.example.com → 203.0.113.10
```

```text
app.example.com → 10.0.2.25
```

```text
       VPC Network: 10.0.0.0/16
  ┌─────────────────────────────────────────────────────────────────┐
  │ 10.0.0.0 — Network Base Address (Reserved)                      │
  │ 10.0.0.1 — AWS VPC Router Interface (Reserved)                  │
  │ 10.0.0.2 — AWS Route 53 DNS Resolver (Reserved) ◄── [DNS Server]│
  │ 10.0.0.3 — AWS Future Use (Reserved)                            │
  │ ...                                                             │
  │ 10.0.1.10 — Application EC2 Instance                            │
  └─────────────────────────────────────────────────────────────────┘
```

```text
169.254.169.253
```

```text
       On-Premises Corporate DC                               AWS Cloud VPC
┌─────────────────────────────────────┐                  ┌─────────────────────────────────────┐
│ Corporate DNS Server (192.168.1.10) │                  │ Private Hosted Zone (internal.aws)  │
└──────────────────┬──────────────────┘                  └──────────────────┬──────────────────┘
                   │                                                        │
                   │           Hybrid Link (VPN or Direct Connect)          │
                   ├────────────────────────────────────────────────────────┤
                   │                                                        │
                   ▼ (1) Inbound Query: Where is db.internal.aws?           │
        [ Inbound Resolver Endpoint ] ──────────────────────────────────────┘
         (ENI IP: 10.0.1.50 in Subnet A)
         (ENI IP: 10.0.2.50 in Subnet B)
                   │
                   │ (2) Outbound Query: Where is server.corp.com?
        [ Outbound Resolver Endpoint ] ◄────────────────────────────────────┐
         (ENI IP: 10.0.1.60 in Subnet A)                                    │
         (ENI IP: 10.0.2.60 in Subnet B)                           [ EC2 Instance ]
                   │                                                Queries: 10.0.0.2
                   ▼                                                        │
        Forwarded to On-Prem (192.168.1.10) ────────────────────────────────┘
```

```text
  app.internal.example.com
  ```

```text
  server.corp.example.com
  ```

```text
                  Route 53 Resolver Rule Processing Pipeline
                               EC2 DNS Query
                                     │
                                     ▼
                      Query: db.corp.example.com
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │  Does query match a Rule?       │
                    └────────────────┬────────────────┘
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼ YES                                   ▼ NO
     Matches: corp.example.com                     Fallback to:
     Target: Outbound Endpoint                     1. Private Hosted Zones
     Forward to: 192.168.1.10                      2. Public Recursive DNS
```

```text
                      PRODUCTION HYBRID DNS ARCHITECTURE

  ══════════════════════════════════════════════════════════════════════════════════
                                PUBLIC INTERNET
  ══════════════════════════════════════════════════════════════════════════════════
                                        │
                                        ▼
                         [ Route 53 Public Hosted Zone ]
                                www.example.com
                                        │
                 ┌──────────────────────┴──────────────────────┐
                 ▼                                             ▼
  ┌─────────────────────────────┐               ┌─────────────────────────────┐
  │         AWS CLOUD           │               │      ON-PREMISES DC         │
  │     VPC: 10.0.0.0/16        │               │   Subnet: 192.168.1.0/24    │
  ├─────────────────────────────┤               ├─────────────────────────────┤
  │                             │               │                             │
  │  EC2 Application Instance   │               │  On-Prem Client Workstation │
  │  IP: 10.0.1.10              │               │  IP: 192.168.1.50           │
  │        │                    │               │        │                    │
  │        ▼                    │               │        ▼                    │
  │  VPC Resolver (10.0.0.2)    │               │  Corporate DNS Server       │
  │        │                    │               │  IP: 192.168.1.10           │
  │        ├───────────┐        │               │        │                    │
  │        ▼           ▼        │               │        │                    │
  │  Private Zone   Outbound    │               │        ▼                    │
  │  (internal.aws) Endpoint    │               │  Forwarder: *.internal.aws  │
  │        │        (10.0.1.60) │               │        │                    │
  │        ▼           │        │               │        │                    │
  │  db.internal.aws   │        │               │        │                    │
  │                    │        │               │        │                    │
  │  Inbound Endpoint  │        │               │        │                    │
  │  (10.0.1.50) ◄─────┼────────┼─── Direct ────┼────────┘                    │
  │        │           │        │    Connect /  │                             │
  │        │           └───────►│    Site-to-   │                             │
  │        ▼                    │    Site VPN   │                             │
  │  Resolves internal.aws      │               │  Resolves corp.example.com  │
  └─────────────────────────────┘               └─────────────────────────────┘
```

```powershell
Resolve-DnsName example.com
```

```powershell
# Query IPv4 A Record
Resolve-DnsName example.com -Type A

# Query IPv6 AAAA Record
Resolve-DnsName example.com -Type AAAA

# Query Mail Exchanger (MX) Records
Resolve-DnsName example.com -Type MX
```

```powershell
Resolve-DnsName example.com -Server 8.8.8.8
```

```powershell
ipconfig /all
```

---

## Day 243 — Day 17/28: DNS for Service Discovery
- **Date:** October 30, 2026 (Calendar: October 30, 2026 (Friday))

```text
Hard-Coded IP Architecture (Brittle & Fragile):
┌─────────────────────────┐     TCP Connection      ┌─────────────────────────┐
│ Frontend Microservice   │ ──────────────────────► │ Database Cluster        │
│ Config: DB=10.0.2.15    │    Direct Hard-Coded IP │ IP: 10.0.2.15           │
└─────────────────────────┘                         └─────────────────────────┘
                                                     * DB fails over / reboots
                                                     * New IP: 10.0.3.25
                                                     * Outage: Frontend crashes!

DNS-Based Discovery Architecture (Decoupled & Scalable):
┌─────────────────────────┐    DNS Query: db.internal    ┌─────────────────────────┐
│ Frontend Microservice   │ ───────────────────────────► │ Route 53 / CoreDNS      │
│ Config: db.internal     │ ◄─────────────────────────── │ Returns: 10.0.2.15      │
└────────────┬────────────┘     Terminal A Record        └─────────────────────────┘
             │                                                        ▲
             │ TCP 5432                                               │ Automatic Record
             ▼                                                        │ Update on Failover
┌────────────────────────────────────────────────────────┐            │
│ Target Instance: Primary Database (10.0.2.15)          │ ───────────┘
└────────────────────────────────────────────────────────┘
```

```text
                                DNS Namespace Hierarchy
                                      [ .internal ]
                                            │
                    ┌───────────────────────┴───────────────────────┐
                    ▼                                               ▼
         [ production.internal ]                         [ staging.internal ]
                    │                                               │
       ┌────────────┴────────────┐                     ┌────────────┴────────────┐
       ▼                         ▼                     ▼                         ▼
 api.production.internal   db.production.internal  api.staging.internal   db.staging.internal
   (10.0.1.10)              (10.0.2.20)              (10.1.1.10)            (10.1.2.20)
```

```env
DATABASE_HOST=db.${ENVIRONMENT}.internal
API_SERVICE_HOST=api.${ENVIRONMENT}.internal
```

```dns
$ORIGIN production.internal.
api    300 IN A 10.0.1.10
db     300 IN A 10.0.2.20
cache  300 IN A 10.0.3.30
```

```text
Pod Lifecycle Volatility:
T0: App Pod-A ──► 10.244.1.5
T1: Node crashes, Kubernetes recreates Pod-A on Node-B
T2: App Pod-A ──► 10.244.2.18 (New IP!)
```

```text
                  Kubernetes Service Discovery Workflow
┌─────────────────────────┐
│ Frontend Web Pod        │
│ IP: 10.244.1.12         │
└────────────┬────────────┘
             │ 1. DNS Query: mysql.database.svc.cluster.local
             ▼
┌─────────────────────────┐
│ CoreDNS Pods            │ ──► Translates Service name to ClusterIP (10.96.0.150)
│ (kube-system namespace) │
└────────────┬────────────┘
             │ 2. Returns ClusterIP: 10.96.0.150
             ▼
┌────────────────────────────────────────────────────────┐
│ Kubernetes Service: mysql (ClusterIP: 10.96.0.150)     │
│ (iptables / IPVS kernel load balancing)                │
└────────────────────────────┬───────────────────────────┘
                             │
             ┌───────────────┴───────────────┐
             ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────┐
│ MySQL Pod 1             │     │ MySQL Pod 2             │
│ IP: 10.244.1.50:3306    │     │ IP: 10.244.2.85:3306    │
└─────────────────────────┘     └─────────────────────────┘
```

```text
mysql.database.svc.cluster.local
```

```text
  <pod-name>.<service-name>.<namespace>.svc.cluster.local
  mysql-0.mysql.database.svc.cluster.local
  mysql-1.mysql.database.svc.cluster.local
  ```

```bash
# Check CoreDNS Pod health and replica count
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Inspect Kubernetes ClusterIP Service for DNS
kubectl get service kube-dns -n kube-system -o wide

# View live CoreDNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# Inspect CoreDNS runtime logs
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50
```

```text
nameserver 10.96.0.10
search frontend.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

```text
Cross-Namespace Query Hierarchy:
mysql.database
   ├── 1. mysql.database.frontend.svc.cluster.local  ──► NXDOMAIN (Miss)
   ├── 2. mysql.database.svc.cluster.local           ──► SUCCESS! (Found)
   └── (Stops, returns ClusterIP)
```

```text
Rule:
If (number of dots in hostname < ndots):
    Apply search domains sequentially first.
Else:
    Query the name directly as an absolute domain.
```

```text
options ndots:5
```

```text
api.github.com
```

```text
Query 1: api.github.com.frontend.svc.cluster.local  ──► CoreDNS returns NXDOMAIN
Query 2: api.github.com.svc.cluster.local           ──► CoreDNS returns NXDOMAIN
Query 3: api.github.com.cluster.local               ──► CoreDNS returns NXDOMAIN
Query 4: api.github.com                             ──► CoreDNS forwards to Upstream (Success!)
```

```text
                  The 4x Query Multiplication Penalty
                      App calls: api.stripe.com
                                   │
              ┌────────────────────┴────────────────────┐
              ▼ (1) NXDOMAIN                            ▼ (2) NXDOMAIN
api.stripe.com.frontend.svc.cluster.local   api.stripe.com.svc.cluster.local
              │                                         │
              └────────────────────┬────────────────────┘
                                   │
              ┌────────────────────┴────────────────────┐
              ▼ (3) NXDOMAIN                            ▼ (4) SUCCESS!
api.stripe.com.cluster.local                api.stripe.com (External DNS)
```

```env
# Before (Triggers 4x DNS lookup cycle):
EXTERNAL_API_URL=https://api.github.com

# After (Immediately treated as absolute, 1 lookup):
EXTERNAL_API_URL=https://api.github.com.
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-crawler
spec:
  template:
    spec:
      dnsConfig:
        options:
          - name: ndots
            value: "2"
      containers:
        - name: crawler
          image: my-crawler:latest
```

```env
DATABASE_HOST=10.0.2.15
DATABASE_PORT=5432
```

```env
DATABASE_HOST=aurora-cluster.production.internal
DATABASE_PORT=5432
```

```text
               Cloud Database High Availability Failover
                 aurora-cluster.production.internal
                                 │
                   Route 53 CNAME / RDS Endpoint
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
      ┌──────────────────────────┐   ┌──────────────────────────┐
      │ Primary DB (AZ-1a)       │   │ Standby Replica (AZ-1b)  │
      │ IP: 10.0.2.15 (Active)   │   │ IP: 10.0.3.50 (Standby)  │
      └──────────────────────────┘   └──────────────────────────┘
                    │                              ▲
                    │ Failover Event               │
                    └───────► DNS updates to ──────┘
```

```properties
   networkaddress.cache.ttl=30
   ```

```bash
# View active nameservers, search domains, and ndots
cat /etc/resolv.conf
```

```bash
# Standard lookup
dig google.com +short

# Trace resolution step-by-step
dig google.com +trace

# Force absolute lookup with trailing dot
dig google.com. +short
```

```bash
# Launch a temporary debugging Pod with DNS tools
kubectl run dns-test --rm -it --image=infoblox/dnstools --restart=Never

# Inside the test pod:
# Check pod resolv.conf
cat /etc/resolv.conf

# Test same-namespace resolution
nslookup kubernetes

# Test cross-namespace resolution
nslookup kube-dns.kube-system

# Test full FQDN
nslookup kube-dns.kube-system.svc.cluster.local
```

```bash
kubectl get configmap coredns -n kube-system -o yaml
```

```text
.:53 {
    errors
    health
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

---

## Day 244/1000 – Traffic Management and DNS Failure Modes
- **Date:** October 31, 2026 (Calendar: October 31, 2026 (Saturday))

```text
                                DNS Routing Engine
                                 app.example.com
                                        │
             ┌──────────────────────────┼──────────────────────────┐
             ▼                          ▼                          ▼
     [ Weighted Policy ]       [ Latency Policy ]       [ Failover Policy ]
      Canary / A/B Testing       Lowest Ping Time         Active / Standby DR
      (80% Prod / 20% V2)        (Mumbai vs Singapore)    (Primary vs Backup)
```

```text
                  Weighted Routing (Canary Deployment)
                             User Queries
                                  │
                                  ▼
                        [ Route 53 Resolver ]
                                  │
                 ┌────────────────┴────────────────┐
          80% of │                                 │ 20% of
         queries │                                 │ queries
                 ▼                                 ▼
       ┌───────────────────┐             ┌───────────────────┐
       │ Server A (v1.0)   │             │ Server B (v2.0)   │
       │ Weight: 80        │             │ Weight: 20        │
       └───────────────────┘             └───────────────────┘
```

```text
                     Latency-Based Routing Evaluation
                  Client located in Chennai, India
                                  │
                                  ▼
                         [ Amazon Route 53 ]
                 Evaluates Global Latency Probe Data
                                  │
       ┌──────────────────────────┼──────────────────────────┐
       ▼ (35 ms Latency)          ▼ (65 ms Latency)          ▼ (150 ms Latency)
 ┌───────────┐              ┌───────────┐              ┌───────────┐
 │  Mumbai   │              │ Singapore │              │  London   │
 │ ap-south-1│              │ap-seast-1 │              │ eu-west-2 │
 └───────────┘              └───────────┘              └───────────┘
       ▲
       │
   SELECTED: Route 53 returns Mumbai IP (35 ms)
```

```text
                     Geolocation Routing Logic
                     Client Queries app.example.com
                                  │
                                  ▼
                       [ GeoIP Lookup Engine ]
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼ (Client: India)         ▼ (Client: Germany)       ▼ (Default Fallback)
┌────────────────┐        ┌────────────────┐        ┌────────────────┐
│  Mumbai Region │        │Frankfurt Region│        │ Virginia Region│
│  (Data: India) │        │ (GDPR Compliant)│       │ (Rest of World)│
└────────────────┘        └────────────────┘        └────────────────┘
```

```text
               Failover Routing (Disaster Recovery)

        [ NORMAL STATE ]                            [ FAILURE STATE ]
     Route 53 (Health: OK)                       Route 53 (Health: FAILED!)
              │                                               │
              ▼                                               ▼
┌───────────────────────────┐                   ┌───────────────────────────┐
│ Primary Endpoint (Mumbai) │                   │ Secondary (Singapore)     │
│ Status: HEALTHY (Active)  │                   │ Status: STANDBY (Active)  │
└───────────────────────────┘                   └───────────────────────────┘
```

```text
                       Route 53 Health Checking Loop
               ┌─────────────────────────────────────────┐
               │ AWS Global Health Checkers (15+ Regions)│
               └────────────────────┬────────────────────┘
                                    │
                                    │ Periodic HTTP GET /health
                                    ▼
                      ┌───────────────────────────┐
                      │ Application Load Balancer │
                      │ Primary Server (10.0.1.10)│
                      └─────────────┬─────────────┘
                                    │
              ┌─────────────────────┴─────────────────────┐
              ▼ (Status 200 OK)                           ▼ (Status 500 / Timeout)
   ┌───────────────────────┐                   ┌───────────────────────┐
   │ Endpoint: HEALTHY     │                   │ Endpoint: UNHEALTHY   │
   │ Keep IP in DNS pool   │                   │ Remove IP from DNS    │
   └───────────────────────┘                   └───────────────────────┘
```

```python
from flask import Flask, jsonify
import psycopg2
import redis

app = Flask(__name__)

@app.route("/health")
def health():
    """Liveness check: verifies process is responsive."""
    return jsonify({"status": "healthy"}), 200

@app.route("/ready")
def readiness():
    """Readiness check: verifies all backend dependencies are online."""
    try:
        # 1. Verify PostgreSQL Database connection
        db_conn = psycopg2.connect("dbname=app user=postgres host=10.0.2.20 connect_timeout=2")
        db_conn.close()

        # 2. Verify Redis Cache connection
        r = redis.Redis(host="10.0.3.30", port=6379, socket_timeout=2)
        r.ping()

        return jsonify({
            "status": "ready",
            "database": "connected",
            "cache": "connected"
        }), 200

    except Exception as e:
        # Return 503 Service Unavailable so Route 53 marks endpoint UNHEALTHY
        return jsonify({
            "status": "unready",
            "error": str(e)
        }), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

```text
┌───────────────────────────────────────┬───────────────────────────────────────┐
│           Liveness Check              │           Readiness Check             │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ "Is the application process running?" │ "Can the application serve traffic?"  │
│ Checks internal thread / web server.  │ Checks database, cache, disk, storage.│
│ If failed: Restart container / daemon.│ If failed: Remove from DNS/load pool. │
└───────────────────────────────────────┴───────────────────────────────────────┘
```

```text
Default TTL: 3600 seconds (1 hour)
Migration Cutover: Change IP from 10.0.1.10 to 10.0.2.10

Without TTL Preparation (Catastrophe):
Resolvers hold old IP for up to 3600 seconds.
Split traffic, stale data writes, and 1-hour customer downtime!

With Pre-Planned TTL Reduction (Zero Downtime):
TTL lowered to 60s well in advance.
When switch occurs, 100% of global traffic transitions in 60 seconds!
```

```text
Timeline:
T - 48 Hours: [ Step 1: Lower TTL ] ──────► Lower TTL from 3600s (1h) down to 60s
T - 24 Hours: [ Step 2: Soak Time ] ──────► Wait 24-48h for old long-lived caches to expire
T = 0:        [ Step 3: Cutover ]   ──────► Switch A/Alias record: 10.0.1.10 ──► 10.0.2.10
T + 60s:      [ Step 4: Validate ]  ──────► Traffic shifts cleanly; verify telemetry & logs
T + 24 Hours: [ Step 5: Restore ]   ──────► Restore TTL back to 3600s (1h)
```

```text
                       Negative Caching Mechanism
1. Client queries: dev.example.com (Not yet created)
                         │
                         ▼
2. Authoritative DNS returns: NXDOMAIN + SOA Minimum TTL (300s)
                         │
                         ▼
3. Recursive Resolver CACHES the negative response for 300 seconds!
                         │
4. Administrator creates dev.example.com in Route 53 (T = 10s)
                         │
5. Client re-queries dev.example.com (T = 30s)
                         │
                         ▼
6. Resolver serves CACHED NXDOMAIN! (Record appears broken to client)
                         │
7. At T = 301s: Negative cache expires; resolver fetches fresh A record!
```

```dns
example.com. IN SOA ns1.awsdns.com. hostmaster.example.com. (
    2026103101 ; Serial
    7200       ; Refresh
    3600       ; Retry
    1209600    ; Expire
    300        ; Negative Cache TTL (Minimum TTL = 5 minutes)
)
```

```text
                          DNS Failure Diagnosis Funnel
                             Application Connection Error
                                          │
                  ┌───────────────────────┼───────────────────────┐
                  ▼                       ▼                       ▼
            [ NXDOMAIN ]            [ SERVFAIL ]             [ TIMEOUT ]
            "Name does not exist"   "Server failed"          "No response"
                  │                       │                       │
      ┌───────────┴───────────┐           │           ┌───────────┴───────────┐
      ▼                       ▼           ▼           ▼                       ▼
Typo in name           Negative cache   DNSSEC error  Port 53 firewall   Network drop
Record missing in zone expired wait     Lame NS del.  UDP packet loss    Server dead
```

```bash
  dig wrong.example.com
  # Look for: status: NXDOMAIN
  ```

```bash
  # Check if DNSSEC is failing validation
  dig example.com +dnssec
  # Bypass DNSSEC validation to test hypothesis (CD = Checking Disabled)
  dig example.com +cdflag
  ```

```bash
  # Test UDP/53
  dig @8.8.8.8 example.com
  # Test TCP/53 (bypasses UDP fragmentation drops)
  dig @8.8.8.8 example.com +tcp
  ```

```bash
sudo apt update && sudo apt install dnsutils iputils-ping -y
```

```bash
dig google.com
```

```bash
dig non-existent-server-test-12345.example.com
```

```text
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 48123
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
;; AUTHORITY SECTION:
example.com.    300    IN    SOA    ns1.example.com. hostmaster.example.com. ...
```

```bash
# Query Google Public DNS
dig @8.8.8.8 google.com +stats | grep -E "(Query time|SERVER)"

# Query Cloudflare Public DNS
dig @1.1.1.1 google.com +stats | grep -E "(Query time|SERVER)"

# Query Quad9 Public DNS
dig @9.9.9.9 google.com +stats | grep -E "(Query time|SERVER)"
```

```bash
dig +trace google.com
```

```bash
# Force DNS over TCP (essential for DNSSEC and responses > 512 bytes)
dig @8.8.8.8 google.com +tcp
```

```text
                  Multi-Region High Availability Architecture
                             Global Route 53
                        [ Failover Routing Policy ]
                                    │
                 ┌──────────────────┴──────────────────┐
                 │                                     │
           Health Check:                         Health Check:
           Status: HEALTHY                       Status: STANDBY
                 │                                     │
                 ▼                                     ▼
        ┌───────────────────┐                 ┌───────────────────┐
        │  Primary Region   │                 │ Secondary Region  │
        │ Mumbai ap-south-1 │                 │Singapore ap-seast1│
        ├───────────────────┤                 ├───────────────────┤
        │ Public ALB        │                 │ Public ALB        │
        │ Auto Scaling Group│                 │ Auto Scaling Group│
        │ Multi-AZ EC2 Fleet│                 │ Multi-AZ EC2 Fleet│
        │ Aurora Primary DB │◄── Cross-Region ──┤ Aurora Read Replica│
        └───────────────────┘    Replication  └───────────────────┘
```

---

## Day 245/1000 – Day 19/28: TCP Connection Lifecycle
- **Date:** November 1, 2026 (Calendar: November 1, 2026 (Sunday))

```text
                        TCP Connection Lifecycle Phases
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ 1. Connection Establishment: 3-Way Handshake (SYN -> SYN-ACK -> ACK)        │
 │    Negotiates initial sequence numbers (ISN), MSS, Window Scaling, and SACK.│
 └──────────────────────────────────────┬──────────────────────────────────────┘
                                        │
                                        ▼
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ 2. Data Transfer: Full-Duplex Streaming & Sliding Window                    │
 │    Data segments acknowledged via SEQ/ACK arithmetic; flow & congestion ctrl│
 └──────────────────────────────────────┬──────────────────────────────────────┘
                                        │
                                        ▼
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ 3. Connection Teardown: 4-Way Handshake (FIN -> ACK -> FIN -> ACK)          │
 │    Graceful, independent closure of both unidirectional transmission paths. │
 └─────────────────────────────────────────────────────────────────────────────┘
```

```text
Client (e.g., 192.168.1.10:51234)                Server (e.g., 10.0.1.20:443)
  [CLOSED]                                           [LISTEN]
     │                                                   │
     │ 1. SYN (SEQ = 1000, ACK = 0, CTL = SYN)           │
     ├──────────────────────────────────────────────────►│ [SYN_RECEIVED]
     │                                                   │
     │ 2. SYN-ACK (SEQ = 5000, ACK = 1001, CTL = SYN+ACK)│
     │◄──────────────────────────────────────────────────┤
  [ESTABLISHED]                                          │
     │                                                   │
     │ 3. ACK (SEQ = 1001, ACK = 5001, CTL = ACK)        │
     ├──────────────────────────────────────────────────►│ [ESTABLISHED]
     │                                                   │
     ▼                                                   ▼
     ═════════════════ DATA TRANSFER PHASE ═══════════════
```

```text
Sequence Number Arithmetic Example:
Client sends 500 bytes of HTTP POST data starting at SEQ = 1001.

  Segment: [ SEQ = 1001 | Length = 500 bytes | Payload: Bytes 1001 to 1500 ]
                                 │
                                 ▼
              Server receives all 500 bytes successfully.
              Server calculates: Next Expected Byte = 1001 + 500 = 1501.
                                 │
                                 ▼
  Response: [ ACK = 1501 | SEQ = 5001 | Acknowledges bytes up to 1500 ]
```

```text
Client (Active Closer)                            Server (Passive Closer)
  [ESTABLISHED]                                      [ESTABLISHED]
     │                                                   │
     │ 1. FIN (SEQ = 2500, ACK = 6000)                   │
     ├──────────────────────────────────────────────────►│ [CLOSE_WAIT]
  [FIN_WAIT_1]                                           │
     │                                                   │
     │ 2. ACK (ACK = 2501, SEQ = 6000)                   │
     │◄──────────────────────────────────────────────────┤
  [FIN_WAIT_2]                                           │ (Server application cleans
     │                                                   │  up resources & closes fd)
     │                                                   │
     │ 3. FIN (SEQ = 6000, ACK = 2501)                   │
     │◄──────────────────────────────────────────────────┤ [LAST_ACK]
     │                                                   │
  [TIME_WAIT]                                            │
     │ 4. ACK (ACK = 6001, SEQ = 2501)                   │
     ├──────────────────────────────────────────────────►│ [CLOSED]
     │                                                   │
   (Waits 2 * MSL)                                       │
     │                                                   │
  [CLOSED]                                               ▼
```

```text
                               Half-Closed Connection
┌─────────────────────────┐                               ┌─────────────────────────┐
│ Client                  │                               │ Server                  │
├─────────────────────────┤                               ├─────────────────────────┤
│ Finished uploading file │ ──── FIN (Upload Complete) ─► │ Receives FIN (CLOSE_WAIT)│
│ State: FIN_WAIT_2       │ ◄─── ACK (Acknowledged) ───── │                         │
│                         │                               │ Processing large data...│
│ (Reads data from server)│ ◄─── DATA (Processing Result)─ │ Sends results...        │
│                         │ ──── ACK ───────────────────► │                         │
│                         │ ◄─── FIN (All Done) ───────── │ Server closes socket    │
│ State: TIME_WAIT        │ ──── ACK ───────────────────► │ State: CLOSED           │
└─────────────────────────┘                               └─────────────────────────┘
```

```text
               Complete TCP Finite State Machine (Simplified)

                      ┌──────────────────────┐
                      │        CLOSED        │
                      └──────────┬───────────┘
               Passive Open (App)│      │ Active Open (App)
                                 ▼      ▼
                      ┌──────────────┐ ┌──────────────┐
                      │    LISTEN    │ │   SYN_SENT   │
                      └──────┬───────┘ └──────┬───────┘
                     Receive │ SYN            │ Receive SYN+ACK,
                     Send    │ SYN+ACK        │ Send ACK
                             ▼                ▼
                      ┌──────────────┐ ┌──────────────┐
                      │ SYN_RECEIVED │ │              │
                      └──────┬───────┘ │              │
                     Receive │ ACK     │              │
                             ▼         │              │
                      ┌────────────────┴──────┐       │
                      │      ESTABLISHED      │◄──────┘
                      └──────────┬────────────┘
               Active Close (FIN)│      │ Passive Close (Receive FIN)
                                 ▼      ▼
                      ┌──────────────┐ ┌──────────────┐
                      │  FIN_WAIT_1  │ │  CLOSE_WAIT  │
                      └──────┬───────┘ └──────┬───────┘
                     Receive │ ACK    App Close│ Send FIN
                             ▼                ▼
                      ┌──────────────┐ ┌──────────────┐
                      │  FIN_WAIT_2  │ │   LAST_ACK   │
                      └──────┬───────┘ └──────┬───────┘
                     Receive │ FIN    Receive │ ACK
                             ▼                ▼
                      ┌──────────────┐ ┌──────────────┐
                      │  TIME_WAIT   │ │    CLOSED    │
                      └──────┬───────┘ └──────────────┘
                     Timeout │ 2*MSL
                             ▼
                      ┌──────────────┐
                      │    CLOSED    │
                      └──────────────┘
```

```text
           Client Host (192.168.1.10)                    Target Server (10.0.1.20)
┌───────────────────────────────────────────────┐     ┌────────────────────────────┐
│ Process A: Outbound to Port 443               │     │ Web Server Listening       │
│ Source Port: 52140 (Ephemeral) ───────────────┼────►│ Destination Port: 443      │
│                                               │     │                            │
│ Process B: Outbound to Port 443               │     │                            │
│ Source Port: 52141 (Ephemeral) ───────────────┼────►│ Destination Port: 443      │
└───────────────────────────────────────────────┘     └────────────────────────────┘
```

```bash
# Check current ephemeral port range
cat /proc/sys/net/ipv4/ip_local_port_range
```

```text
32768   60999
```

```text
                  The Port Exhaustion Bottleneck
  Client VM (1 IP)                           Single External API (1 IP: 443)
┌──────────────────┐                              ┌──────────────────┐
│ Microservice     │ ── 28,232 Active Sockets ──► │ SaaS Gateway     │
│ Port 32768-60999 │    (or in TIME_WAIT)         │ 203.0.113.50:443 │
└────────┬─────────┘                              └──────────────────┘
         │
         ▼
 Attempt 28,233: Kernel returns `EADDRNOTAVAIL` (Cannot assign requested address)!
 Result: Connection drops, API timeouts, cascading microservice failure!
```

```text
  Private Subnet (EC2 Instances)              AWS NAT Gateway              External SaaS APIs
┌───────────────────────────────┐        ┌───────────────────────┐        ┌──────────────────┐
│ EC2 Instance A (10.0.1.10)    │ ─────► │ Elastic IP:           │ ─────► │ External API     │
│ EC2 Instance B (10.0.1.20)    │ ─────► │ 198.51.100.25         │ ─────► │ 142.250.0.1:443  │
│ EC2 Instance C (10.0.1.30)    │ ─────► │ (Max 55,000 Ports)    │        └──────────────────┘
└───────────────────────────────┘        └───────────────────────┘
```

```bash
# 1. View all active established TCP connections
ss -t

# 2. Display all TCP sockets (listening and non-listening) with numeric ports
ss -tan

# 3. Filter specifically for sockets stuck in CLOSE_WAIT (Application Leaks)
ss -tan state close-wait

# 4. Filter specifically for sockets in TIME_WAIT
ss -tan state time-wait

# 5. Display high-level summary of all kernel socket allocations
ss -s

# 6. Real-time breakdown of all TCP states across the server
ss -tan | awk 'NR > 1 {count[$1]++} END {for (state in count) print state, count[state]}'

# 7. View configured ephemeral port range
cat /proc/sys/net/ipv4/ip_local_port_range

# 8. View low-level kernel socket memory allocation
cat /proc/net/sockstat
```

```bash
#!/bin/bash
# ==============================================================================
# Script: tcp_connection_monitor.sh
# Purpose: Real-time diagnostic tool for auditing TCP connection health,
#          ephemeral port allocation, and application socket leaks.
# ==============================================================================

set -euo pipefail

echo "=========================================================="
echo "          ENTERPRISE TCP CONNECTION MONITOR              "
echo "=========================================================="
echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "Hostname:  $(hostname)"
echo ""

echo "--- [1] KERNEL SOCKET SUMMARY ---"
ss -s
echo ""

echo "--- [2] TCP CONNECTION STATE DISTRIBUTION ---"
printf "%-15s %-10s\n" "STATE" "COUNT"
printf "%-15s %-10s\n" "---------------" "----------"
ss -Htan | awk '{count[$1]++} END {for (state in count) printf "%-15s %-10d\n", state, count[state]}'
echo ""

echo "--- [3] EPHEMERAL PORT RANGE AUDIT ---"
PORT_RANGE=$(cat /proc/sys/net/ipv4/ip_local_port_range)
MIN_PORT=$(echo "$PORT_RANGE" | awk '{print $1}')
MAX_PORT=$(echo "$PORT_RANGE" | awk '{print $2}')
TOTAL_PORTS=$((MAX_PORT - MIN_PORT + 1))
echo "Configured Range: $MIN_PORT to $MAX_PORT ($TOTAL_PORTS available ports)"
echo ""

echo "--- [4] LOW-LEVEL SOCKET MEMORY (sockstat) ---"
cat /proc/net/sockstat
echo ""

echo "--- [5] HEALTH CHECK: APPLICATION LEAK DETECTION ---"
CLOSE_WAIT_COUNT=$(ss -Htan state close-wait | wc -l)
TIME_WAIT_COUNT=$(ss -Htan state time-wait | wc -l)

echo "Current CLOSE_WAIT Sockets: $CLOSE_WAIT_COUNT"
echo "Current TIME_WAIT Sockets:  $TIME_WAIT_COUNT"

# Evaluation against thresholds
if [ "$CLOSE_WAIT_COUNT" -gt 50 ]; then
    echo ">> [CRITICAL ALERT]: Elevated CLOSE_WAIT count ($CLOSE_WAIT_COUNT > 50)!"
    echo ">> Root Cause: Application process is leaking file descriptors without closing sockets."
else
    echo ">> [HEALTHY]: CLOSE_WAIT count is within normal baseline parameters."
fi

if [ "$TIME_WAIT_COUNT" -gt 5000 ]; then
    echo ">> [WARNING]: Elevated TIME_WAIT count ($TIME_WAIT_COUNT > 5000)."
    echo ">> Consider enabling net.ipv4.tcp_tw_reuse or implementing HTTP connection pooling."
fi

echo ""
echo "=========================================================="
echo "                Audit Completed Successfully              "
echo "=========================================================="
```

```bash
  ss -tan | awk 'NR > 1 {count[$1]++} END {for (state in count) print state, count[state]}'
  ```

```text
  ESTABLISHED:  350
  TIME-WAIT:    28,100
  CLOSE-WAIT:   12
  ```

```bash
ss -tan state close-wait
```

```bash
ss -Htan state close-wait | wc -l
```

---

