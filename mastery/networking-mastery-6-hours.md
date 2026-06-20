# Networking Mastery in 6 Hours
### The highest-ROI networking crash course for AI Infra, Cloud, Platform, DevOps, SRE & MLOps Engineers

> This is **not** a CCNA course. Every section is filtered through one question: *"Does a Cloud/K8s/AI infra engineer need this to do the job and pass the interview?"* If the answer is no, it's cut.

**How to use this doc:** Read top to bottom once. Then use the **Final Cheat Sheet** as your day-of-interview refresher.

---

## Table of Contents

- [Hour 0: Mental Models](#hour-0-mental-models)
- [Hour 1: Absolute Essentials](#hour-1--absolute-essentials)
- [Hour 2: Cloud Networking](#hour-2--how-cloud-networking-really-works)
- [Hour 3: Kubernetes Networking](#hour-3--kubernetes-networking)
- [Hour 4: Network Troubleshooting](#hour-4--network-troubleshooting)
- [Hour 5: AI Infrastructure Networking](#hour-5--ai-infrastructure-networking)
- [Hour 6: Interview Mastery (Top 100 Questions)](#hour-6--interview-mastery)
- [Final Cheat Sheet](#final-cheat-sheet)

---

## HOUR 0: MENTAL MODELS

### What is networking, really?

Strip away the jargon: **networking is the set of rules that let two pieces of software on two different machines exchange bytes and agree on what those bytes mean.**

Everything else — TCP, DNS, BGP, VPCs, CNIs — exists to solve one of three problems:

1. **Addressing** — how do I name/find the other machine?
2. **Delivery** — how do I get bytes there reliably (or fast)?
3. **Trust & isolation** — how do I make sure only the right things can talk to each other?

Keep these three buckets in your head. Every topic in this doc falls into one of them.

### How does the Internet actually work? (The physical truth)

The Internet is not a cloud — it's a **physical mesh of fiber-optic cables** connecting **routers owned by thousands of independent companies** (ISPs, cloud providers, universities), who agree to exchange traffic using one protocol: **BGP**.

```
Your Laptop → Home Router → ISP → Internet Exchange Point (IXP)
            → Tier-1 Backbone (fiber, undersea cables)
            → Destination ISP / Cloud Provider Edge
            → Load Balancer → Server
```

There is no central authority routing your packet. Instead, every network ("Autonomous System") announces "I own these IP ranges" via BGP, and routers build a path hop-by-hop based on those announcements. When you hear "BGP leak" or "BGP hijack" in the news (e.g., a country's traffic mysteriously routes through another country), this is why — BGP runs on **trust**, not verification, by default.

**Why this matters for you:** when someone asks "why is my AI API slow for users in India," the honest answer often starts with "how many physical hops and which Tier-1 backbone is that traffic crossing" — not "let's add a cache."

### How does a packet actually travel? (Encapsulation)

A packet is built like a **Russian nesting doll**. Each layer wraps the previous one in a new header, and the receiving machine unwraps it in reverse order.

```
┌─────────────────────────────────────────────┐
│ Ethernet Header (MAC addresses)              │
│  ┌────────────────────────────────────────┐  │
│  │ IP Header (Source IP, Dest IP, TTL)     │  │
│  │  ┌──────────────────────────────────┐  │  │
│  │  │ TCP/UDP Header (Source/Dest Port)│  │  │
│  │  │  ┌────────────────────────────┐  │  │  │
│  │  │  │  Your actual data (HTTP    │  │  │  │
│  │  │  │  request, gRPC call, etc.) │  │  │  │
│  │  │  └────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────┘  │  │
│  └────────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

This is **encapsulation** (going down the stack, adding headers) and **decapsulation** (going up the stack at the receiver, stripping headers). Every router on the path reads only the IP header (to decide the next hop), decrements the TTL by 1, and re-writes the Ethernet header for the next hop. The IP header itself almost never changes mid-flight (NAT is the big exception — more in Hour 1).

**The one-sentence mental model interviewers want to hear:** *"A packet is data wrapped in increasingly specific headers; routers only ever look at the IP layer to move it along, and the TTL field is what prevents infinite routing loops."*

### How do machines actually communicate? (Sockets & client-server)

At the OS level, every network conversation is a **socket** — a tuple of `(Source IP, Source Port, Dest IP, Dest Port, Protocol)`. Your laptop can have 30 browser tabs open to the same website because each tab gets a different **ephemeral source port** (a random high port, e.g. 51422), even though the destination is identical.

```
Client                                  Server
──────                                  ──────
socket(192.168.1.5:51422) ──TCP SYN──▶  socket(0.0.0.0:443) [listening]
                          ◀─SYN,ACK──   accept() → new socket
                          ──ACK──▶      (192.168.1.5:51422 ↔ 10.0.0.8:443)
```

The server has one **listening socket** per port, but spawns a **new connected socket** per client. This is why a server can be "listening on port 443" and still handle 50,000 concurrent connections — each is a distinct 4-tuple.

> 🎤 **Interview question:** "How many connections can a server handle on one port?"
> **Answer:** Theoretically up to ~4 billion per client IP (limited by the 16-bit port space combined with IP, and OS file descriptor limits in practice — typically tens of thousands per server before tuning). The "one port = one connection" myth is the #1 sign of a junior candidate.

> 🛠️ **Troubleshooting takeaway:** "Address already in use" errors almost always mean a previous process didn't release its socket (`TIME_WAIT` state) or you're trying to bind two processes to the same port. `ss -tlnp` shows you exactly who's holding it.

---

## HOUR 1 — ABSOLUTE ESSENTIALS

### OSI Model (the practical version)

You don't need to recite all 7 layers like a parrot. You need to know **which layer a tool/problem lives at**, because that determines how you debug it.

| Layer | Name | What it actually means to you | Tools/Protocols |
|---|---|---|---|
| 7 | Application | HTTP requests, gRPC calls, your API | `curl`, browsers |
| 4 | Transport | Ports, TCP/UDP, "is the port open" | `ss`, `nc`, Security Groups |
| 3 | Network | IP addresses, routing, "can I reach the host" | `ping`, `traceroute`, Route Tables |
| 2 | Data Link | MAC addresses, local segment | `arp -a` |
| 1 | Physical | Cables, NICs, "is it plugged in" | link lights |

**Why it matters:** Debugging should always go **bottom-up**. If L3 (ping) fails, don't waste time checking L7 (your app code) — the problem is routing/firewall, not your app. This single habit separates senior engineers from juniors in incident response.

> 🎤 **Interview Q:** "A Load Balancer operates at L4 vs L7 — what's the practical difference?"
> **A:** An L4 LB (e.g., AWS NLB) just forwards TCP/UDP packets by IP:port — fast, preserves client IP, can't read HTTP. An L7 LB (e.g., AWS ALB) terminates the connection, reads HTTP headers/paths/cookies, and can route `/api` vs `/static` differently — slower, more CPU, but smarter routing.

> 🛠️ **Troubleshooting Q:** "ping works but curl times out on port 443. What layer is broken?"
> **A:** L3 (ping/ICMP) is fine, so routing works. The problem is L4 (port blocked by Security Group/firewall) or L7 (the server process isn't listening, or TLS handshake hangs). Check `ss -tlnp` on the server and the Security Group/NACL rules.

---

### TCP/IP: TCP, UDP, Ports, Sockets, Connections

**TCP (Transmission Control Protocol)** — reliable, ordered, connection-oriented. Pays for reliability with overhead (handshakes, ACKs, retransmits).

**UDP (User Datagram Protocol)** — fire-and-forget, no handshake, no guaranteed delivery or order. Used when speed matters more than completeness (DNS, video calls, metrics, some AI streaming).

```
TCP 3-Way Handshake                    TCP Teardown (4-way)
Client          Server                 Client          Server
  │──── SYN ─────▶│                      │──── FIN ─────▶│
  │◀── SYN,ACK ───│                      │◀──── ACK ─────│
  │──── ACK ─────▶│                      │◀──── FIN ─────│
  │   [connected]  │                      │──── ACK ─────▶│
                                          │  [TIME_WAIT]   │
```

**Ports** are just a 16-bit number (0–65535) that lets one IP address run thousands of independent services. **Well-known ports** (0–1023) need root/admin to bind. **Ephemeral ports** (typically 32768–60999 on Linux) are randomly assigned to outbound client connections.

**A socket** = `(protocol, src IP, src port, dst IP, dst port)`. This 5-tuple uniquely identifies a connection.

> 🎤 **Interview Q:** "Why does DNS use UDP but HTTPS use TCP?"
> **A:** DNS is a single small request/response — the overhead of a TCP handshake would double latency for no benefit, and if a query is lost, retrying is cheap. HTTPS needs guaranteed, ordered, encrypted delivery of multi-packet payloads, so TCP's reliability is worth the handshake cost. (Fun fact: DNS falls back to TCP if the response exceeds 512 bytes.)

> 🛠️ **Troubleshooting Q:** "`netstat` shows 50,000 connections in `TIME_WAIT` on your API server — what's happening and how do you fix it?"
> **A:** Port/connection churn — the server is opening and closing TCP connections faster than the OS can recycle ports (each closed connection holds `TIME_WAIT` for ~60s). Fix: enable connection pooling/keep-alive, reduce `TIME_WAIT` duration, or increase the ephemeral port range.

---

### DNS: How Name Resolution Actually Works

```
Browser → OS cache → Recursive Resolver (e.g. 8.8.8.8 / your ISP)
                          │
                          ▼
                    Root Server  ("who handles .com?")
                          │
                          ▼
                    TLD Server (.com) ("who handles example.com?")
                          │
                          ▼
                Authoritative Server (example.com's own DNS)
                          │
                          ▼
                 Returns the IP → cached at every layer along the way (per TTL)
```

- **Recursive Resolver**: does the hunting on your behalf (Google's `8.8.8.8`, Cloudflare's `1.1.1.1`, or your ISP).
- **Authoritative Server**: the source of truth for a domain — this is what Route53/Cloud DNS/Azure DNS actually is.
- **Key records:** `A` (hostname → IPv4), `AAAA` (→ IPv6), `CNAME` (alias to another name), `MX` (mail), `TXT` (verification, SPF/DKIM), `NS` (which servers are authoritative).
- **TTL**: how long resolvers are allowed to cache the answer. Lower it *before* a migration, or stale traffic will hit your old server for hours.

> 🎤 **Interview Q:** "You changed a DNS A record but half your users still hit the old server. Why?"
> **A:** DNS caching at multiple layers (browser, OS, recursive resolver, ISP) honors the record's TTL. If TTL was 24 hours, some resolvers won't re-query for up to 24 hours after the change. Always lower TTL days *before* a planned migration.

> 🛠️ **Troubleshooting Q:** "How do you see the full DNS resolution chain for a domain?"
> **A:** `dig +trace example.com` — walks from root → TLD → authoritative, showing exactly where it's failing.

---

### IP Addressing: IPv4, CIDR, Subnetting, Public vs Private

**IPv4** = 32 bits, written as 4 octets (`10.0.1.5`). **CIDR notation** (`/24`) tells you how many bits are the *network* portion vs the *host* portion.

```
10.0.1.0/24
└────┬────┘└┬┘
 Network ID  Host bits (8 bits remaining → 256 addresses, 254 usable)
```

| CIDR | Host bits | Total IPs | Usable IPs | Common use |
|---|---|---|---|---|
| /16 | 16 | 65,536 | 65,534 | Whole VPC |
| /24 | 8 | 256 | 254 | A subnet |
| /28 | 4 | 16 | 14 | A tiny reserved range |
| /32 | 0 | 1 | 1 | A single host route |

**Private ranges (RFC 1918)** — never routable on the public internet:
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

Every VPC, every home router, every K8s cluster lives inside these ranges, which is exactly why **NAT** exists — to let private IPs talk to the public internet.

> 🎤 **Interview Q:** "You're setting up a VPC for an EKS (Kubernetes) cluster. Why would a `/24` be a terrible choice?"
> **A:** Kubernetes (with the AWS VPC CNI) assigns a real VPC IP to *every single Pod*. A `/24` gives you 254 IPs total — you'd run out after a couple dozen Pods across a few nodes. Always size VPCs for K8s at `/16` or at least `/20`.

> 🛠️ **Troubleshooting Q:** "How do you quickly compute the usable range and broadcast address for `192.168.5.0/27`?"
> **A:** `ipcalc 192.168.5.0/27` (Linux) — instantly shows network address, broadcast address, and usable host range. (`/27` = 5 host bits = 32 IPs, 30 usable.)

---

### NAT (Network Address Translation)

NAT rewrites IP headers so private IPs can use a shared public IP. The most common form in cloud is **PAT (Port Address Translation/"NAT overload")**: many internal IPs share *one* public IP, distinguished by port.

```
Private subnet (10.0.2.0/24)              Public Internet
   EC2 (10.0.2.15:51000) ──┐
   EC2 (10.0.2.16:51000) ──┼──▶ NAT Gateway ──▶ (54.x.x.x:62001) ──▶ destination
   EC2 (10.0.2.17:51000) ──┘     (rewrites src IP+port, tracks mapping)
```

Critically: NAT is **one-directional by design** — it lets private resources reach *out*, but the internet cannot initiate a connection *in*. That's the whole security value.

> 🎤 **Interview Q:** "SNAT vs DNAT — what's the difference?"
> **A:** SNAT (Source NAT) rewrites the *source* IP — used when internal clients reach out to the internet (NAT Gateway). DNAT (Destination NAT) rewrites the *destination* IP — used for inbound port forwarding (e.g., a public Load Balancer forwarding to a private backend IP).

> 🛠️ **Troubleshooting Q:** "Private-subnet EC2 instances can't download OS updates. What do you check?"
> **A:** Is there a NAT Gateway in a public subnet? Does the private subnet's route table send `0.0.0.0/0` to that NAT Gateway? Does the NAT Gateway's subnet route `0.0.0.0/0` to an Internet Gateway? (This 3-hop chain is the #1 AWS networking exam/interview trap.)

---

### DHCP (Dynamic Host Configuration Protocol)

Automatically assigns an IP, subnet mask, default gateway, and DNS servers to a new device — no manual config needed.

```
Client                              DHCP Server
  │── DISCOVER (broadcast) ────────▶│
  │◀──────────── OFFER ─────────────│
  │──────────── REQUEST ───────────▶│
  │◀──────────── ACK ────────────────│   ("DORA")
```

**Cloud relevance:** you'll almost never configure DHCP directly in AWS/GCP/Azure — the cloud's SDN layer auto-assigns IPs to instances. But you *will* see DHCP show up when: (a) on-prem data centers connect via VPN/Direct Connect, or (b) debugging why a new EC2 instance got a different private IP than expected after a stop/start (AWS releases the old DHCP lease).

> 🎤 **Interview Q:** "Why does an EC2 instance's private IP change after you stop and start it (but not on reboot)?"
> **A:** Stop/start releases the underlying host and its DHCP lease; the instance gets a new ENI IP from the subnet's available pool on start. A plain OS-level *reboot* keeps the same host and lease. (Elastic IPs or a fixed private IP via ENI sidestep this.)

---

### ARP (Address Resolution Protocol)

Maps a Layer 3 IP address to a Layer 2 MAC address — needed because switches forward by MAC, not IP.

```
"Who has 192.168.1.1?" ── broadcast (FF:FF:FF:FF:FF:FF) ──▶ everyone on the LAN
                       ◀── unicast reply: "192.168.1.1 is at AA:BB:CC:DD:EE:FF" ──
```

**Cloud relevance:** you almost never see raw ARP in the cloud — AWS/GCP/Azure's virtualized network layer intercepts and answers ARP centrally (broadcast traffic is actually disabled inside VPCs). But ARP concepts resurface in **Kubernetes CNI internals** (how a node's kernel learns which virtual interface maps to which Pod IP) and in any on-prem/bare-metal infra work.

> 🎤 **Interview Q:** "What is Gratuitous ARP and where would you see it in production?"
> **A:** An unsolicited ARP announcement broadcast by a host claiming an IP→MAC mapping. Used in HA failover (keepalived/VRRP): when a standby load balancer takes over a Virtual IP, it broadcasts a Gratuitous ARP so the switch instantly updates its MAC table and traffic flows to the new active node with no delay.

> 🛠️ **Troubleshooting Q:** "Two devices on the same LAN can't reach each other despite correct IPs. First thing to check?"
> **A:** `arp -a` on both — if the ARP table has a stale/wrong MAC entry, traffic goes nowhere. Clear the ARP cache and retry.

---

## HOUR 2 — HOW CLOUD NETWORKING REALLY WORKS

Cloud networking is just the concepts from Hour 1 (IP, routing, NAT, firewalls) reimplemented in software (SDN) and exposed as API objects. AWS terminology dominates interviews even for GCP/Azure roles, so we go deep on AWS first.

### VPC (Virtual Private Cloud)

**Problem it solves:** multi-tenant cloud needs to give every customer their own isolated, private IP space on shared physical hardware.
**How it works:** AWS's Nitro hypervisor enforces isolation at the hardware level — your VPC is a software-defined Layer 3 boundary; no broadcast/ARP leaks between tenants even on the same physical rack.
**Interview angle:** "Design a VPC for a 3-tier app" — expect you to know public/private subnet separation, not just "create a VPC."

### Subnets (Public vs Private)

A subnet is a CIDR slice of the VPC, **pinned to one Availability Zone**. "Public" vs "private" isn't a checkbox — it's defined entirely by the subnet's **route table**:
- **Public subnet**: route table has `0.0.0.0/0 → Internet Gateway`
- **Private subnet**: route table has `0.0.0.0/0 → NAT Gateway` (outbound only) or no internet route at all

> 🎤 **Interview Q:** "How does AWS know a subnet is 'public'?"
> **A:** It doesn't — there's no such flag. It's purely whether the subnet's route table sends `0.0.0.0/0` traffic to an Internet Gateway. This trips up almost every junior candidate.

### Route Tables

The actual decision-maker for "where does this packet go next." Every subnet is associated with exactly one route table; rules are evaluated by **most-specific match wins** (longest prefix match), not order.

### Internet Gateway (IGW)

A horizontally-scaled, redundant AWS-managed gateway that does 1:1 NAT for instances with public IPs, and is the literal "door" between a VPC and the public internet. Attaching one to a VPC does *nothing* by itself — you still need a route table entry pointing to it.

### NAT Gateway

AWS-managed, highly available **PAT** device living in a public subnet. Lets private-subnet resources initiate outbound connections (e.g., pull OS patches) **without** being reachable from the internet. Charges per-hour + per-GB — a classic surprise on AWS bills when high-volume services route through it unnecessarily (use VPC Endpoints instead for AWS service traffic — see below).

### Security Groups vs NACLs (the #1 AWS networking interview question)

| | Security Group | NACL |
|---|---|---|
| Level | Instance (ENI) | Subnet |
| State | **Stateful** (return traffic auto-allowed) | **Stateless** (must explicitly allow both directions) |
| Rules | Allow only | Allow AND Deny |
| Evaluation | All rules evaluated | Rules evaluated in numbered order, first match wins |

```
Stateful (Security Group) example:
  Inbound rule: allow TCP 443 from 0.0.0.0/0
  → Response traffic on the ephemeral port is automatically allowed back out.
     You do NOT need an outbound rule for it.

Stateless (NACL) example:
  Inbound rule: allow TCP 443 from 0.0.0.0/0
  → You ALSO need an outbound rule allowing the ephemeral port range
     (1024-65535) or the response packet gets silently dropped.
```

> 🎤 **Interview Q:** "Your app can receive requests on 443 but clients see the connection hang/never get a response. NACLs are correctly allowing inbound 443. What's wrong?"
> **A:** Classic stateless-NACL trap — outbound ephemeral ports (1024–65535) aren't allowed, so the response packet is dropped on the way out. Security Groups wouldn't have this problem because they're stateful.

### VPC Peering

A 1:1, non-transitive private connection between two VPCs (their route tables point at each other's CIDR). **Non-transitive** is the key word: if A↔B and B↔C are peered, A cannot reach C through B. This limitation is exactly why Transit Gateway exists.

### Transit Gateway

A central, regional "router in the cloud" that connects many VPCs and on-prem networks via a hub-and-spoke model, solving the N² peering-mesh explosion problem (10 VPCs fully peered = 45 connections to manage; with Transit Gateway, it's 10 attachments).

```
Without Transit Gateway (mesh):        With Transit Gateway (hub-spoke):
  VPC-A ↔ VPC-B                          VPC-A ─┐
  VPC-A ↔ VPC-C                          VPC-B ─┼─▶ Transit Gateway ◀─ VPC-D
  VPC-B ↔ VPC-C    (N² connections)      VPC-C ─┘
```

### VPC Endpoints (PrivateLink) — the underrated topic

Lets private-subnet resources reach AWS services (S3, DynamoDB, etc.) **without** going through a NAT Gateway or the public internet — traffic stays entirely inside AWS's backbone. Cheaper, faster, and more secure than the NAT Gateway path. Interviewers love asking why you'd use this over NAT.

> 🎤 **Interview Q:** "Your private EC2 instances are pulling large objects from S3 and your NAT Gateway data-transfer bill is huge. How do you fix it?"
> **A:** Add a Gateway VPC Endpoint for S3. Traffic routes over AWS's internal network for free (Gateway endpoints have no hourly/data charge), bypassing the NAT Gateway entirely.

---

### Cloud Networking: Cross-Provider Cheat Sheet

| Concept | AWS | Azure | GCP |
|---|---|---|---|
| Isolated network | VPC | Virtual Network (VNet) | VPC (global by default!) |
| Network segment | Subnet (zonal) | Subnet (regional) | Subnet (regional) |
| Internet door | Internet Gateway | Internet routing (implicit) | Default internet gateway |
| Outbound-only NAT | NAT Gateway | NAT Gateway | Cloud NAT |
| Instance firewall | Security Group (stateful) | Network Security Group (stateful) | Firewall Rules (stateful, attached to VPC not instance) |
| Subnet firewall | NACL (stateless) | N/A (NSG covers both) | N/A |
| Private network-to-network | VPC Peering | VNet Peering | VPC Peering |
| Hub-and-spoke at scale | Transit Gateway | Virtual WAN | Network Connectivity Center |
| Private service access | VPC Endpoint / PrivateLink | Private Endpoint | Private Service Connect |
| DNS | Route53 | Azure DNS | Cloud DNS |
| L4 Load Balancer | Network Load Balancer | Azure Load Balancer | Network Load Balancer |
| L7 Load Balancer | Application Load Balancer | Application Gateway | HTTP(S) Load Balancer |

**Key conceptual difference to mention in interviews:** GCP's VPC is **global** (one VPC can span all regions, subnets are regional) — AWS and Azure's are **regional** (you peer/connect across regions explicitly). This single fact is a great "I actually understand multi-cloud" signal.

---

## HOUR 3 — KUBERNETES NETWORKING

This is where most cloud-savvy candidates fall apart in interviews. K8s networking is just IP routing + iptables/eBPF + DNS, but layered in a way that confuses people who haven't traced the actual packet path.

### The Golden Rule: Every Pod Gets a Real IP

Unlike Docker's default NAT'd networking, Kubernetes mandates a **flat network**: every Pod gets its own routable IP, and **any Pod can reach any other Pod's IP directly, with no NAT**, regardless of which node they're on. This is the single most important fact in K8s networking — almost every other concept exists to implement this guarantee.

### CNI (Container Network Interface)

The plugin that actually *implements* the flat-network guarantee. When a Pod is scheduled, kubelet calls the CNI plugin to: (1) create a virtual ethernet pair (`veth`), (2) assign an IP from the cluster's Pod CIDR, (3) wire it into the node's network namespace, (4) program routes so cross-node traffic works.

```
Node A                                    Node B
┌─────────────────────┐                  ┌─────────────────────┐
│ Pod 1 (10.244.1.5)   │                  │ Pod 3 (10.244.2.7)   │
│   veth ── cni0 bridge│                  │   veth ── cni0 bridge│
│ Pod 2 (10.244.1.6)   │                  │ Pod 4 (10.244.2.8)   │
└──────────┬───────────┘                  └──────────┬───────────┘
           │         Overlay (VXLAN) or Native Routing (BGP)       │
           └───────────────────── Physical Network ────────────────┘
```

Common CNIs: **Flannel** (simple, VXLAN overlay), **Calico** (BGP-based, no overlay needed, strong NetworkPolicy support), **Cilium** (eBPF-based, fastest, replaces kube-proxy entirely, deep observability).

> 🎤 **Interview Q:** "What's the practical difference between an overlay CNI (Flannel/VXLAN) and a native-routing CNI (Calico/BGP)?"
> **A:** Overlay encapsulates Pod traffic inside another IP packet to cross the physical network (extra CPU overhead for encap/decap, but works on any underlying network). Native routing advertises Pod CIDRs as real routes via BGP — no encapsulation overhead, better performance, but requires the underlying network to support it (or "IP-in-IP" fallback).

### kube-proxy & Services

A **Service** is a stable virtual IP (ClusterIP) that load-balances across a dynamic set of Pod IPs (which churn constantly as Pods die/restart). `kube-proxy` watches the API server and programs the node's `iptables` (or IPVS) rules to implement this:

```
Client → Service ClusterIP:80 ──[iptables DNAT, random selection]──▶ Pod IP:8080
```

This is **destination NAT** under the hood — the Service IP never actually "exists" on any interface; iptables rewrites the destination to a real Pod IP per-packet.

**Service types:**
- **ClusterIP** (default): internal-only virtual IP, reachable only inside the cluster.
- **NodePort**: opens the same static port (30000–32767) on *every* node; external traffic to `<any-node-ip>:<nodeport>` reaches the Service.
- **LoadBalancer**: cloud-provider-specific — provisions a real external LB (e.g., AWS NLB) that forwards to the NodePort.

> 🎤 **Interview Q:** "Traffic to a NodePort works on Node A but not Node B, even though the Pod is only running on Node A. Why is that actually expected/unexpected?"
> **A:** It should work on *every* node by design — `kube-proxy` programs iptables rules on *all* nodes to forward NodePort traffic to the Pod wherever it lives, even cross-node. If it's failing on Node B, check that `kube-proxy` is running and healthy there, and that there's no NetworkPolicy or security group blocking inter-node Pod traffic.

### Ingress & Gateway API

A **Service** only does L4 (IP:port). **Ingress** is the L7 router: a single external Load Balancer fronts an Ingress Controller (commonly an Nginx or Envoy Pod), which reads the HTTP Host header/path and routes accordingly.

```
Internet → Cloud LB → Ingress Controller Pod (Nginx/Envoy)
                          ├── Host: api.app.com    → Service: api-svc
                          ├── Path: /images         → Service: images-svc
                          └── Path: /               → Service: frontend-svc
```

**Gateway API** is the next-generation replacement for Ingress — same idea, but with a cleaner role-based model (infra teams own `Gateway`, app teams own `HTTPRoute`), supports more protocols (gRPC, TCP, TLS passthrough), and is vendor-neutral. Expect more interview questions on this going forward as Ingress is gradually deprecated.

### CoreDNS

Resolves `<service>.<namespace>.svc.cluster.local` to a ClusterIP. **If CoreDNS goes down, the entire cluster effectively breaks** — Pods can no longer find each other by name even though raw IP connectivity still works. This is one of the most common real production outages.

> 🎤 **Interview Q:** "An app can `curl` a Service's ClusterIP directly but fails when calling it by DNS name. What's broken?"
> **A:** CoreDNS — either the CoreDNS Pods are down/crashlooping, or the Pod's `/etc/resolv.conf` isn't pointing at the cluster DNS service, or a NetworkPolicy is blocking egress to CoreDNS on port 53.

### Network Policies

A firewall for Pods, enforced by the CNI (not all CNIs support it — Flannel doesn't by default; Calico/Cilium do). **By default, Kubernetes allows all Pod-to-Pod traffic** — NetworkPolicy is opt-in, label-selector-based isolation.

```yaml
# Only allow Pods labeled role=frontend to reach Pods labeled role=database on port 5432
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
spec:
  podSelector: { matchLabels: { role: database } }
  ingress:
  - from: [{ podSelector: { matchLabels: { role: frontend } } }]
    ports: [{ port: 5432 }]
```

> 🎤 **Interview Q:** "You apply a NetworkPolicy to your database Pods, but suddenly Prometheus can't scrape their metrics anymore. Why, and what's the fix?"
> **A:** NetworkPolicies are allow-lists — once *any* policy selects a Pod, all traffic not explicitly allowed is denied, including monitoring scrapers you forgot about. Fix: add an explicit ingress rule allowing the monitoring namespace/Pods on the metrics port.

### Cilium & eBPF (why everyone's migrating)

Traditional kube-proxy uses `iptables`, which evaluates rules **linearly** — with thousands of Services, lookup time degrades badly at scale (O(n)). **Cilium** uses **eBPF** to attach programs directly into the Linux kernel's network path, giving O(1) hash-table lookups, removing the need for kube-proxy entirely, and enabling deep L3–L7 visibility (e.g., "show me every HTTP 500 between these two services") without sidecars.

> 🎤 **Interview Q:** "Why are large-scale clusters (1000s of Services) moving away from iptables-based kube-proxy?"
> **A:** iptables rule evaluation is roughly linear in the number of Services/endpoints — at scale this adds real per-packet latency and CPU load on every node. eBPF-based dataplanes (Cilium) use efficient kernel hash maps instead, keeping lookup cost flat regardless of cluster size.

### The Full Traffic Flow (memorize this diagram)

```
User
  │  DNS resolves app.company.com → Cloud LB IP
  ▼
Cloud Load Balancer (e.g. AWS NLB, provisioned by a K8s Service of type LoadBalancer)
  │
  ▼
Ingress Controller Pod (Nginx/Envoy) — reads Host/Path, L7 routing decision
  │
  ▼
Kubernetes Service (ClusterIP) — iptables/eBPF DNAT picks one healthy backend Pod
  │
  ▼
Pod (your container) — receives the request on its container port
```

### Common Production Failures (the interview gold)

1. **CoreDNS crashlooping** → entire cluster "can't find" anything by name (covered above).
2. **CNI IP exhaustion** → new Pods stuck in `ContainerCreating` because the Pod CIDR/subnet ran out of IPs.
3. **NetworkPolicy too restrictive** → silently breaks monitoring/logging sidecars that weren't accounted for.
4. **kube-proxy/iptables rule explosion** → intermittent connection resets at scale, fixed by migrating to Cilium/eBPF or IPVS mode.
5. **Ingress controller single point of failure** → wasn't scaled to multiple replicas, one Pod restart takes down all external traffic.

---

## HOUR 4 — NETWORK TROUBLESHOOTING

The entire skill of network troubleshooting is **bottom-up isolation**: confirm each OSI layer works before blaming the layer above it. Below is every tool you actually need, what it tests, and a real output to recognize.

### `ping` — L3 reachability

**Tests:** Is the host alive and reachable via ICMP?
```
$ ping -c 3 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=12.4 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=11.9 ms
3 packets transmitted, 3 received, 0% packet loss
```
**Caveat:** Many cloud security groups/firewalls block ICMP entirely — a failed ping doesn't always mean the host is down or unreachable for TCP traffic.

### `traceroute` / `tracert` — find which hop is broken

**Tests:** The exact path and where latency/loss starts.
```
$ traceroute google.com
 1  192.168.1.1   1.1 ms
 2  10.10.0.1     3.2 ms
 3  *  *  *       (timeout — hop doesn't respond to ICMP, often normal)
 4  142.250.1.1   11.4 ms
```
**Interview note:** a `* * *` hop doesn't always mean a problem — many routers deprioritize/drop ICMP for traceroute by policy. Care about where the *destination* fails to respond, not intermediate timeouts.

### `mtr` — traceroute + ping, continuously

**Tests:** Sustained packet loss/jitter per hop (great for intermittent issues `traceroute` misses).
```
$ mtr google.com
 Host                  Loss%   Avg   Best  Worst
 1. 192.168.1.1         0.0%   1.2    0.8    2.1
 2. 10.10.0.1           2.3%   4.5    3.1   15.2   ← loss starting here
 3. 142.250.1.1         2.1%  11.0    9.8   20.4
```

### `dig` / `nslookup` — DNS resolution

**Tests:** What a domain actually resolves to, and where in the chain it breaks.
```
$ dig +short example.com
93.184.216.34

$ dig +trace example.com    # full chain: root → TLD → authoritative
```

### `curl -v` — full L7 request/response, including TLS

**Tests:** HTTP status, headers, and exactly where in the TLS handshake/HTTP exchange things fail.
```
$ curl -v https://example.com
* TCP_NODELAY set
* Connected to example.com (93.184.216.34) port 443
* TLS handshake, Client hello
* TLS handshake, Server hello
< HTTP/1.1 200 OK
```
If it hangs after "Connected" but before the TLS handshake completes → firewall allows the TCP SYN but is silently dropping subsequent packets (a classic Security-Group-allows-but-NACL-blocks symptom).

### `tcpdump` — raw packet capture

**Tests:** Ground truth — see exactly what's on the wire.
```
$ sudo tcpdump -i eth0 port 443 -nn
12:01:01.123 IP 10.0.1.5.51234 > 10.0.2.8.443: Flags [S], seq 123
12:01:01.124 IP 10.0.2.8.443 > 10.0.1.5.51234: Flags [S.], seq 456, ack 124
```
**Pro move:** if you see the SYN go out but never see a SYN-ACK come back, the packet is being dropped somewhere between the two hosts (firewall/SG/NACL/routing) — not an application problem.

### `ss` — modern replacement for `netstat`

**Tests:** What's listening, and the state of every connection.
```
$ ss -tlnp
State    Local Address:Port    Process
LISTEN   0.0.0.0:443           nginx
LISTEN   127.0.0.1:5432        postgres
```

### `netstat` — legacy but still everywhere

Same idea as `ss`, slower, but muscle memory for older engineers: `netstat -tulpn`.

### `ip` / `ip route` — interface and routing table inspection

```
$ ip addr show
$ ip route show
default via 10.0.1.1 dev eth0
10.0.1.0/24 dev eth0 scope link
```
If there's no matching route and no default (`0.0.0.0/0`) entry, the kernel can't even attempt to send the packet — it fails locally before any network device sees it.

---

### Troubleshooting Flowcharts

**DNS issues:**
```
Can't reach hostname?
 └─▶ dig +short <host>   resolves? ──No──▶ Check /etc/resolv.conf,
        │                                   CoreDNS (if K8s), DNS server health
        Yes
        ▼
   ping <resolved IP>   works? ──No──▶ It's a network/firewall issue, not DNS
        │
        Yes → DNS was never the problem; debug app/TLS/port instead
```

**"Connection refused":**
```
Connection refused means the TCP SYN reached the host and the OS actively
rejected it (RST sent back) — meaning routing/firewall is FINE.
 └─▶ Check: is anything actually listening on that port? (ss -tlnp)
 └─▶ Check: is the app crashed/not started?
 └─▶ Check: wrong port number in your config?
```

**Timeout (no response at all):**
```
Timeout means the packet went nowhere, or the response never came back.
 └─▶ traceroute — does it get close to the destination? Where does it die?
 └─▶ Check Security Group / NACL / firewall rules (most common cause)
 └─▶ Check route tables — is there actually a path?
 └─▶ tcpdump on both ends — does the SYN arrive? Does the SYN-ACK leave?
```

**TLS issues:**
```
curl -v hangs/fails during handshake?
 └─▶ openssl s_client -connect host:443 — see exact handshake failure
 └─▶ Certificate expired? Wrong CN/SAN? Self-signed and not trusted?
 └─▶ SNI mismatch — client requesting wrong hostname for a multi-cert server?
 └─▶ Cipher/TLS version mismatch (old client, server requires TLS 1.2+)?
```

**Kubernetes networking issues:**
```
Pod can't reach a Service?
 ├─▶ Can the Pod reach the target Pod's IP directly? (rules out CNI/routing)
 │      No → CNI issue, IP exhaustion, or NetworkPolicy blocking
 ├─▶ Does `nslookup <service>.<namespace>` resolve from inside the Pod?
 │      No → CoreDNS issue
 └─▶ Is kube-proxy/Cilium running and healthy on the node?
        No → Service load-balancing is broken cluster-wide on that node
```

---

## HOUR 5 — AI INFRASTRUCTURE NETWORKING

This is the section that separates a generic cloud engineer from an **AI infrastructure engineer**. The core truth: **at massive GPU scale, networking — not compute — is usually the bottleneck.**

### Why networking dominates AI training cost/time

Training a large model means splitting it across hundreds or thousands of GPUs (model too big / too slow for one GPU). After every batch, GPUs must **synchronize gradients** — every GPU needs to send and receive its updated weights to/from every other GPU before the next step can start. This is **constant, massive, latency-sensitive, bursty traffic** — fundamentally different from typical web traffic.

```
Traditional web app:           AI training cluster:
  Mostly independent requests    ALL GPUs must sync before ANY can proceed
  Latency annoying but survivable  1ms of network stall = the whole multi-million
  North-South traffic dominant     dollar cluster sits idle, GPU utilization tanks
                                    East-West traffic dominates (GPU ↔ GPU)
```

A GPU that finishes its compute step but is waiting on the network to receive a peer's gradients is a **$30,000+ chip sitting idle**. This is why hyperscalers obsess over network fabric more than almost anything else in AI infra.

### East-West vs North-South Traffic

- **North-South**: traffic between users/clients and the data center (typical web traffic).
- **East-West**: traffic *between* servers inside the data center. In AI training clusters, East-West traffic (GPU-to-GPU) absolutely dwarfs North-South — this is the opposite ratio of a typical web application, and it's the single biggest architectural difference AI infra engineers need to internalize.

### GPU-to-GPU Communication: NCCL, RDMA, RoCE, InfiniBand, NVLink, GPUDirect

**NCCL (NVIDIA Collective Communications Library)** — the software layer that implements the actual communication patterns (All-Reduce, All-Gather, Broadcast) GPUs use to sync gradients. It automatically picks the fastest available hardware path (NVLink within a node, InfiniBand/RoCE across nodes).

**The hardware hierarchy (fastest to slowest):**

```
┌──────────────────────────────────────────────────────────┐
│ Within one server:                                       │
│   NVLink — direct GPU-to-GPU interconnect, hundreds of    │
│   GB/s, bypasses PCIe entirely. Fastest tier.             │
├──────────────────────────────────────────────────────────┤
│ Across servers, same rack/cluster:                        │
│   InfiniBand or RoCE (RDMA over Converged Ethernet)        │
│   — both implement RDMA: GPU memory on Node A is read      │
│   directly by the NIC on Node B's GPU memory, bypassing    │
│   the CPU and OS kernel entirely.                          │
├──────────────────────────────────────────────────────────┤
│ Standard Ethernet (no RDMA) — CPU-mediated, much higher    │
│   latency, used only for non-training traffic (storage,    │
│   management, internet egress).                            │
└──────────────────────────────────────────────────────────┘
```

**RDMA (Remote Direct Memory Access)** is the foundational concept: instead of data going NIC → kernel → user space → CPU copy → GPU (slow, CPU-bound), RDMA lets the NIC write directly into the remote GPU's memory. **GPUDirect** is NVIDIA's implementation that extends this so the *GPU itself* — not just the CPU's memory — is the RDMA endpoint, cutting out the CPU entirely.

**InfiniBand vs RoCE:** InfiniBand is a purpose-built, lossless fabric (its own switches, its own protocol) — the gold standard for the largest training clusters (this is what powers most frontier-model training runs). **RoCE** gets you RDMA's performance benefits over standard Ethernet hardware (cheaper, more familiar to ops teams) but requires careful configuration (Priority Flow Control) to achieve the lossless behavior InfiniBand gives you natively.

> 🎤 **Interview Q:** "Why can't you just train a frontier-scale model over standard Ethernet/TCP?"
> **A:** Standard Ethernet/TCP tolerates packet loss by retransmitting — fine for web traffic, catastrophic for training, where a single dropped packet stalls a synchronized All-Reduce across potentially thousands of GPUs, multiplying the delay across the whole cluster. Training fabrics (InfiniBand/RoCE with RDMA) are built to be effectively **lossless** and bypass the CPU/kernel for microsecond-level latency.

> 🎤 **Interview Q:** "What's the difference between NVLink and InfiniBand, and why do you need both?"
> **A:** NVLink connects GPUs *within* a single server at the highest bandwidth — it has no role across physical servers. InfiniBand (or RoCE) connects GPUs *across* servers. A training cluster needs both: NVLink for intra-node speed, InfiniBand for inter-node scale-out.

### Bandwidth vs Latency Bottlenecks

- **Bandwidth-bound:** large tensors (model weights, activations) take a long time to move — solved by faster links (NVLink, higher-speed InfiniBand) and overlapping communication with compute.
- **Latency-bound:** small, frequent synchronization messages where the *round-trip delay itself* — not the data size — is the bottleneck. This is why RDMA's microsecond latencies matter even more than its bandwidth numbers for some workloads.

> 🛠️ **Production diagnostic:** if GPU utilization metrics show GPUs frequently idle/waiting (not pegged at 100%) during training, suspect a network bottleneck before assuming it's a data-loading or compute problem. Tools like NVIDIA's `nccl-tests` and `dcgm` can isolate whether the stall is compute, data pipeline, or network.

### Training Traffic vs Inference (Serving) Traffic

| | Training | Inference/Serving |
|---|---|---|
| Dominant traffic | East-West (GPU↔GPU, massive, synchronized) | North-South (user↔API) |
| Latency sensitivity | High, but tolerates batching | Extremely high (user-facing) |
| Network tech | InfiniBand/RoCE, NVLink, RDMA | Standard load balancers, CDNs, API Gateways |
| Failure mode | Whole job stalls if one link is slow | Individual request is slow/fails; others unaffected |
| Pattern | Long-running, bursty all-to-all | Many small, independent, often streamed (SSE/WebSocket for token streaming) requests |

### How OpenAI-Scale Clusters Actually Communicate (the mental model)

```
                     ┌─────────────────────────────┐
                     │        Spine Switches        │  ← non-blocking fat-tree
                     └───────────┬─────────┬─────────┘
                 ┌────────────────┘         └────────────────┐
            ┌─────────┐                                 ┌─────────┐
            │ Leaf SW │                                 │ Leaf SW │
            └────┬────┘                                 └────┬────┘
        ┌─────────┴─────────┐                      ┌─────────┴─────────┐
   ┌─────────┐         ┌─────────┐             ┌─────────┐        ┌─────────┐
   │ GPU Node│         │ GPU Node│             │ GPU Node│        │ GPU Node│
   │ 8x GPUs │ NVLink  │ 8x GPUs │  InfiniBand │ 8x GPUs │        │ 8x GPUs │
   │ inside  │ ◀─────▶ │ inside  │ ◀──────────▶│ inside  │ ◀────▶ │ inside  │
   └─────────┘         └─────────┘             └─────────┘        └─────────┘
```

This is essentially the **spine-leaf topology** from Hour 0, purpose-built so that *any* two GPU nodes are always the same number of hops apart — predictable, uniform latency is more important than raw peak bandwidth for synchronized training.

### Model Serving Traffic (the part most "AI infra" tutorials skip)

A real inference architecture layers cloud-native networking concepts (Hours 2–3) on top:
1. Global Anycast DNS routes the user to the nearest regional gateway.
2. API Gateway handles auth/rate limiting.
3. L7 Load Balancer → Kubernetes Ingress → Service → inference Pod.
4. Long-lived HTTP connections (Server-Sent Events / WebSockets) stream tokens back as they're generated — this is *not* a single request/response; it's a persistent stream that load balancer/proxy idle timeouts must be tuned for.
5. Vector databases (for RAG) sit on low-latency internal VPC links — milliseconds matter because they're in the critical path of every single user request.

> 🎤 **Interview Q:** "Why would you put 'premium' users on dedicated GPU instances behind the same load balancer as free users?"
> **A:** L7 load balancers can inspect headers (e.g., a JWT claim or API key tier) and route accordingly — premium traffic to dedicated capacity/faster GPUs, free traffic to shared/oversubscribed pools, all without separate public endpoints.

---

## HOUR 6 — INTERVIEW MASTERY

### Top 100 Networking Questions

Format: **Q → Answer → what a strong candidate adds → common mistake.**

#### Fundamentals (1–20)

**1. Explain what happens when you type a URL into a browser.**
DNS resolution → TCP handshake → TLS handshake → HTTP request → server processes → response → browser renders. *Strong add:* mention connection reuse/HTTP-2 multiplexing and caching layers (CDN, browser cache). *Mistake:* forgetting DNS caching or skipping the TCP handshake entirely.

**2. TCP vs UDP — when would you choose each?**
TCP for reliability/order (APIs, file transfer); UDP for speed where some loss is tolerable (DNS, video, AI audio streaming). *Mistake:* saying "TCP is always better."

**3. What's in a TCP header that isn't in a UDP header?**
Sequence/ACK numbers, window size, flags (SYN/ACK/FIN/RST) — the machinery for reliability and flow control. UDP just has src/dst port, length, checksum.

**4. What does TTL do and why does it matter?**
Decremented at each router hop; prevents infinite routing loops; when it hits 0, the packet is dropped and an ICMP "Time Exceeded" is returned — this is literally how `traceroute` works.

**5. Explain subnetting a /24 into 4 equal subnets.**
Borrow 2 bits → four /26 subnets, each with 64 addresses (62 usable). *Mistake:* forgetting to subtract network + broadcast addresses.

**6. Public vs Private IP — why do private ranges exist?**
RFC 1918 ranges aren't routable on the public internet, allowing every organization to reuse the same address space internally; NAT bridges private↔public.

**7. What is the difference between a switch and a router?**
Switch forwards by MAC (L2) within a broadcast domain; router forwards by IP (L3) between networks. *Mistake:* saying they do the same thing "just different scales."

**8. How does DNS load balancing work?**
Multiple A records for the same name; resolvers return them often round-robin or based on policy (geolocation/latency in Route53/Cloud DNS).

**9. What's the difference between a forward and reverse proxy?**
Forward proxy represents the client (hides client identity from servers); reverse proxy represents the server (hides server topology from clients, does LB/TLS termination/caching).

**10. Explain the TCP 3-way handshake and why it exists.**
SYN, SYN-ACK, ACK — both sides confirm send/receive capability and agree on initial sequence numbers before any data flows.

**11. What is MTU and what happens when a packet exceeds it?**
Max packet size a link can carry (1500B Ethernet default); oversized packets are fragmented (or dropped with "fragmentation needed" if the Don't-Fragment bit is set) — fragmentation hurts performance.

**12. What is NAT and why does almost every home/office network use it?**
Translates many private IPs to one public IP (PAT); solves IPv4 exhaustion and adds a layer of implicit inbound protection.

**13. IPv4 vs IPv6 — why hasn't IPv6 fully taken over?**
IPv6's 128-bit space solves exhaustion, but dual-stack complexity, legacy hardware, and "it still works" inertia have slowed adoption for two decades.

**14. What's an ephemeral port?**
A randomly assigned high port (typically 32768–60999) used as the *source* port for outbound client connections, freed after the connection closes.

**15. What does "stateful" mean for a firewall?**
It tracks connection state and automatically permits return traffic for connections it has seen initiated — you don't need a separate rule for responses.

**16. Why is ARP needed if we already have IP addresses?**
IP operates at L3, but switches forward frames using L2 MAC addresses — ARP bridges the two by mapping IP→MAC on the local segment.

**17. What is a broadcast domain?**
The set of devices that receive a broadcast frame (e.g. an ARP request) — typically bounded by a switch (L2) or router (L3) boundary.

**18. Explain idempotency in HTTP methods.**
Calling the method N times has the same effect as once: GET/PUT/DELETE are idempotent, POST is not (creates a new resource each time). *Mistake:* claiming PATCH is always idempotent — it depends on implementation.

**19. What's the difference between 401 and 403?**
401 = "I don't know who you are" (missing/invalid auth). 403 = "I know who you are, you're just not allowed." *Mistake:* using them interchangeably in API design.

**20. Why does HTTP/2 multiplexing matter?**
It sends many requests over a single TCP connection in parallel, eliminating the head-of-line blocking and connection-overhead problems of HTTP/1.1's per-request connections.

#### Cloud Networking (21–40)

**21. Walk through what makes a subnet "public" in AWS.**
Its route table sends `0.0.0.0/0` to an Internet Gateway — nothing else makes it public.

**22. Security Group vs NACL — give a scenario where only NACL misconfiguration would cause an issue.**
Inbound allowed, but outbound ephemeral port range blocked at the NACL — response packets get dropped even though Security Groups (stateful) would have allowed them automatically.

**23. What problem does a NAT Gateway solve that an Internet Gateway doesn't?**
IGW allows direct bidirectional internet access (needs a public IP); NAT Gateway allows private-subnet resources outbound-only access without exposing them inbound.

**24. Why is VPC Peering non-transitive, and what replaces it at scale?**
Peering is strictly 1:1; A-B and B-C peering doesn't let A reach C. Transit Gateway provides hub-and-spoke connectivity to avoid the N² peering mesh problem.

**25. What's a VPC Endpoint and why use one over NAT Gateway for S3 access?**
Keeps traffic to AWS services inside the AWS backbone — Gateway endpoints for S3/DynamoDB are free and avoid NAT Gateway's per-GB charges.

**26. Difference between an ALB and an NLB?**
ALB = L7, terminates connections, routes on HTTP path/host, can do header-based routing. NLB = L4, ultra-low latency pass-through, preserves client source IP, handles millions of connections.

**27. How do you design network isolation for a multi-tenant SaaS on AWS?**
Options range from one VPC per tenant (max isolation, most overhead) to shared VPC with per-tenant subnets/Security Groups/IAM scoping (cheaper, needs careful policy design). *Strong add:* mention VPC Lattice or service mesh for app-layer isolation at scale.

**28. What is Direct Connect / ExpressRoute / Cloud Interconnect, and why pay for it over a VPN?**
Dedicated physical link to the cloud provider — bypasses the unpredictable public internet for guaranteed bandwidth/latency, critical for sync replication or compliance.

**29. Explain how Transit Gateway changes the blast radius of a misconfigured route.**
Centralizing routing means a single bad route table entry can affect every attached VPC — more powerful, but mistakes are more impactful; route table segmentation per attachment mitigates this.

**30. How would you debug "EC2 instance in public subnet, can't SSH in"?**
Check (in order): does it have a public IP? Does the route table send 0.0.0.0/0 to an IGW? Does the Security Group allow inbound 22 from your IP? Does the NACL allow both inbound 22 and outbound ephemeral ports?

**31. What's the purpose of a Bastion host, and what's replaced it in modern setups?**
A hardened jump box in the public subnet for SSH access into private resources; largely replaced by AWS Systems Manager Session Manager (no open SSH port, full audit logging, IAM-based access).

**32. GCP's VPC is "global" — what does that actually change architecturally?**
Subnets in different regions share one VPC without peering; simplifies multi-region design but means routing/firewall changes have global blast radius.

**33. What's the difference between a Network Load Balancer and a Layer-4 firewall rule?**
LB actively distributes/health-checks traffic across backends; a firewall rule just allows/denies — no distribution logic.

**34. Why might cross-AZ data transfer cost matter in your network design?**
Most clouds charge for inter-AZ traffic; chatty microservices spread across AZs for "HA" can incur surprising bandwidth costs — co-locate latency-sensitive/high-volume services when possible, accept the tradeoff against AZ redundancy.

**35. Explain PrivateLink/Private Service Connect conceptually.**
Lets a service in one VPC/account expose itself to another VPC/account via a private IP, without peering the whole networks — minimal exposed surface area.

**36. What's the failure mode of forgetting to associate a custom route table with a subnet?**
The subnet silently falls back to the VPC's *main* route table, which may not have the routes you intended — a classic silent misconfiguration.

**37. How does cloud DNS-based health checking (e.g. Route53) enable failover?**
The DNS service periodically health-checks an endpoint and stops returning its IP (or fails over to a secondary record) if it's unhealthy — failover at the DNS layer, not the network layer.

**38. What's the security tradeoff of a 0.0.0.0/0 Security Group rule on a database?**
Opens the resource to the entire internet on that port — even with strong app-layer auth, it dramatically increases attack surface (brute force, exploits) and should almost always be scoped to specific CIDRs/SGs.

**39. Explain "blast radius" in the context of shared VPCs.**
A shared VPC/network misconfiguration (bad route, overly broad SG) can affect every tenant/team using it — a key argument for network segmentation even at some operational cost.

**40. How do you migrate a service from on-prem to cloud without an IP conflict?**
Audit on-prem CIDR ranges before provisioning the VPC; if overlap is unavoidable, use NAT on the VPN/Direct Connect link to remap conflicting ranges — but this is a project-level headache best avoided by planning ahead.

#### Kubernetes Networking (41–60)

**41. What's the single most important networking guarantee Kubernetes makes?**
Every Pod gets a real, routable IP, and any Pod can reach any other Pod directly without NAT — this "flat network" model underlies everything else.

**42. What does kube-proxy actually do?**
Watches the API server for Services/Endpoints changes and programs node-level iptables (or IPVS/eBPF) rules to load-balance Service traffic to backend Pods.

**43. ClusterIP vs NodePort vs LoadBalancer — when do you use each?**
ClusterIP for internal-only service-to-service traffic; NodePort for simple external access (rarely used directly in prod); LoadBalancer for cloud-provisioned external endpoints, usually fronted further by Ingress.

**44. What's the practical difference between Ingress and a Service?**
Service = L4 stable virtual IP across Pods. Ingress = L7 router (host/path-based) sitting in front of multiple Services, usually backed by one external Load Balancer.

**45. Why would a cluster move from Ingress to Gateway API?**
Gateway API has clearer role separation (infra vs app teams), supports more protocols and richer routing, and is becoming the vendor-neutral standard as Ingress's extension model (annotations) is inconsistent across controllers.

**46. What breaks if CoreDNS goes down?**
Name-based service discovery cluster-wide — Pods can still reach each other by raw IP, but anything using a Service/Pod DNS name fails.

**47. Why doesn't Flannel support NetworkPolicy by default but Calico does?**
Flannel is a simple overlay-only CNI with no policy enforcement engine; Calico (and Cilium) implement NetworkPolicy enforcement via iptables/eBPF as a first-class feature.

**48. Explain how a CNI assigns an IP to a new Pod, end to end.**
Kubelet calls the CNI plugin on Pod creation → CNI creates a veth pair, assigns an IP from the node's allocated Pod CIDR block, configures routes, and connects it to the node's bridge/overlay.

**49. What does it mean that NetworkPolicies are "default deny once applied"?**
The instant any policy selects a Pod, only explicitly allowed traffic gets through — this is why adding a policy can silently break monitoring/logging traffic you forgot to allow.

**50. Why is Cilium/eBPF often faster than iptables-based kube-proxy at scale?**
iptables rule evaluation is roughly linear in the number of Services/endpoints; eBPF uses kernel hash maps for near-constant-time lookups regardless of cluster size.

**51. How would you debug "Pod can't resolve a Service by DNS name but can curl its IP directly"?**
Isolates the problem to DNS specifically — check CoreDNS Pod health, the Pod's `/etc/resolv.conf`, and whether a NetworkPolicy is blocking egress to CoreDNS on port 53.

**52. What is a headless Service and when do you use one?**
A Service with `clusterIP: None` — instead of load-balancing, DNS returns the individual Pod IPs directly. Used for stateful workloads (databases, Kafka) where clients need to address specific replicas.

**53. Explain how an overlay network (VXLAN) adds overhead vs native BGP routing.**
VXLAN encapsulates every packet inside another UDP packet to tunnel across the physical network — extra CPU for encap/decap and slightly larger packets; BGP-based routing advertises real routes with no encapsulation, but needs underlying network support.

**54. What's the risk of running out of IPs in a Pod CIDR?**
New Pods get stuck in `Pending`/`ContainerCreating` — a frequent production incident when VPC-CNI-based clusters under-provision subnet size relative to node/Pod density.

**55. How does Kubernetes Service load balancing differ from a cloud Load Balancer's algorithm?**
kube-proxy/Cilium typically does simple random or round-robin selection at the packet level; cloud LBs (and service meshes) can do more sophisticated algorithms (least-connections, latency-aware).

**56. What is a sidecar proxy (e.g., Envoy in Istio) and what networking problem does it solve?**
Injected alongside each Pod to transparently intercept all in/out traffic, enabling mTLS, retries, observability, and traffic shaping without changing app code — effectively moves L7 networking concerns out of the application.

**57. Why might you see intermittent connection resets in a high-Service-count cluster on iptables mode?**
Rule evaluation overhead and conntrack table exhaustion under load — switching to IPVS mode or an eBPF dataplane (Cilium) commonly resolves this.

**58. What's the difference between liveness and readiness probes, networking-wise?**
Readiness probe failure removes the Pod from Service endpoints (stops receiving traffic) without restarting it; liveness probe failure restarts the container. Confusing them causes either traffic to broken Pods or unnecessary restarts.

**59. How do Network Policies handle traffic to/from outside the cluster?**
Via `ipBlock` CIDR selectors in addition to pod/namespaceSelectors — letting you allow/deny based on external IP ranges, not just labels.

**60. Why is "any Pod can reach any other Pod" sometimes a security concern, and how is it mitigated?**
Flat networking by default means a compromised Pod can reach everything; NetworkPolicies (and service meshes with mTLS/authorization policies) are the mitigation layered on top.

#### AI Infrastructure Networking (61–75)

**61. Why is networking often the bottleneck in large-scale AI training, not compute?**
Synchronized gradient updates require every GPU to exchange data with every other GPU each step; any network stall idles the entire (extremely expensive) cluster, not just one node.

**62. What is RDMA and why does it matter for GPU clusters?**
Remote Direct Memory Access lets a NIC read/write a remote machine's memory directly, bypassing the CPU and OS kernel — drastically cutting latency and CPU overhead versus traditional socket-based networking.

**63. InfiniBand vs RoCE — what's the practical tradeoff?**
InfiniBand is a purpose-built lossless fabric with the best raw performance but requires its own switches/NICs; RoCE delivers RDMA over standard Ethernet hardware (cheaper, more familiar ops) but needs careful lossless configuration (Priority Flow Control) to match InfiniBand's reliability.

**64. What is NVLink and how is it different from InfiniBand?**
NVLink connects GPUs *within* one server at extremely high bandwidth; InfiniBand connects GPUs *across* servers. Training clusters use both in combination.

**65. What does GPUDirect actually eliminate from the data path?**
The CPU memory copy step — data moves directly between the NIC and GPU memory instead of NIC → CPU RAM → GPU.

**66. Why can't TCP/Ethernet just "be made fast enough" for training instead of InfiniBand?**
It's not purely about speed — TCP's loss-tolerant, retransmission-based design adds unpredictable latency under congestion; synchronized training needs near-lossless, low-jitter delivery, which is what InfiniBand/RoCE with RDMA are engineered for.

**67. What is NCCL and what does it abstract away from an ML engineer?**
NVIDIA's collective communications library — implements All-Reduce/All-Gather/Broadcast patterns and automatically selects the fastest available hardware path (NVLink, InfiniBand, etc.) so ML code doesn't need to manage low-level networking.

**68. Explain East-West vs North-South traffic in the context of an AI cluster.**
East-West = GPU-to-GPU traffic inside the cluster, which dominates during training. North-South = traffic between users and the cluster, which dominates during inference serving. Architecting for one doesn't automatically serve the other well.

**69. How would you diagnose whether a slow training run is network-bound?**
Check GPU utilization metrics — if GPUs are frequently idle/waiting rather than pegged near 100%, suspect network stalls; tools like `nccl-tests` and NVIDIA DCGM can isolate communication-specific latency/bandwidth issues from compute or data-loading bottlenecks.

**70. Why does spine-leaf topology matter specifically for GPU training clusters?**
It guarantees uniform, predictable hop-count/latency between any two GPU nodes — critical because synchronized collective operations are only as fast as the slowest path between any two participants.

**71. How does inference (serving) traffic architecture differ from training traffic architecture?**
Inference is latency-sensitive, North-South, many independent small requests (often streamed via SSE/WebSocket) — served well by standard cloud LBs/API gateways/K8s Ingress. Training is East-West, synchronized, bandwidth- and latency-critical bulk transfers — served by InfiniBand/RoCE/NVLink, not typical cloud networking.

**72. What's a practical reason model-serving APIs use Server-Sent Events or WebSockets instead of plain HTTP request/response?**
Token generation happens incrementally; streaming lets users see partial output immediately instead of waiting for the entire response, which matters a lot for perceived latency on long generations.

**73. Why might you route "premium" inference traffic differently from free-tier traffic at the load balancer?**
An L7 load balancer can inspect auth headers/tokens and route premium traffic to dedicated, faster GPU pools while free traffic shares oversubscribed capacity — without separate public endpoints.

**74. What is a Vector Database's networking requirement in a RAG pipeline, and why?**
It needs to sit on a low-latency internal network path to the inference nodes — it's queried synchronously in the critical path of every user request, so even small added latency compounds across millions of requests.

**75. Why do companies physically ship storage devices (e.g. AWS Snowmobile) instead of transferring AI training datasets over the network?**
At petabyte scale, even fast network links would take weeks/months to transfer the data; physical shipping of disks is often faster and cheaper than any feasible network transfer for one-time massive bulk loads.

#### SRE (76–88)

**76. What's the difference between latency and throughput, and why can't you fix one by improving the other?**
Latency is time-per-operation; throughput is operations-per-time. Adding bandwidth (throughput) doesn't reduce the time a single round trip takes (latency) — they're independent dimensions.

**77. How do you design a system to gracefully degrade rather than fail completely under network partition?**
Circuit breakers to stop hammering a failing dependency, fallback/cached responses, async queues to buffer writes, and clear SLOs about what "degraded but available" means for each dependency.

**78. What's a network partition in the CAP theorem context, and what does it force you to choose?**
A communication break between nodes that should be able to reach each other; you must choose Consistency (reject/delay requests until data is synced) or Availability (serve possibly-stale data).

**79. How do you set load balancer timeout values correctly relative to backend timeouts?**
The LB's idle/request timeout should be slightly *longer* than the backend's processing timeout — otherwise the LB severs connections while the backend is still legitimately working.

**80. What metric would tell you a service is network-saturated vs CPU-saturated?**
Network: rising latency/errors with flat CPU and high NIC throughput/retransmit rates. CPU-saturated: high CPU utilization correlating with latency, with network throughput well under capacity.

**81. Explain why DNS TTL matters for incident response/failover speed.**
A high TTL means clients/resolvers keep using a cached (possibly dead) IP long after you've redirected traffic — fast failover requires low TTLs configured *in advance*, not during the incident.

**82. What's the value of synthetic monitoring/canary requests for network health?**
Detects network/availability regressions from outside the system's own blind spots (e.g., a region-specific routing issue real users hit but internal health checks don't).

**83. How would you design alerting for "packet loss between two services" without being too noisy?**
Alert on sustained loss percentage over a time window (not single blips), correlate with latency/error-rate symptoms, and tier severity by whether it's affecting a critical path.

**84. What's the danger of retries during a network incident?**
Retry storms — every client retrying a failing/slow dependency multiplies load on an already-struggling system, often turning a partial outage into a total one. Exponential backoff + jitter mitigates this.

**85. Why is "the network" often wrongly blamed first during an incident, and how do you avoid that bias?**
It's invisible and complex, making it an easy scapegoat; avoid bias by checking concrete signals (packet loss %, retransmits, `tcpdump`/`mtr` data) before declaring it a network issue rather than assuming.

**86. How do you validate a firewall/Security Group change is safe before applying it in production?**
Test in a staging environment with equivalent topology, use infrastructure-as-code with peer review/diffing, and apply via canary/gradual rollout where the platform supports it.

**87. What's the operational risk of a single NAT Gateway for an entire multi-AZ VPC?**
It becomes both a single point of failure and a cross-AZ data transfer cost; best practice is one NAT Gateway per AZ.

**88. Why track p99 latency instead of average latency for network-dependent services?**
Averages hide tail latency that affects a meaningful fraction of real users; network issues (retransmits, route flaps) often show up specifically in the tail, not the average.

#### DevOps (89–100)

**89. How does a CI/CD pipeline typically reach a private Kubernetes API server securely?**
Via a VPN/Direct Connect tunnel, a bastion/jump host, or a private CI runner deployed inside the VPC — never by exposing the API server publicly without strict IP allowlisting and auth.

**90. What network considerations matter when deploying blue-green vs canary releases?**
Blue-green needs a way to atomically switch all traffic (DNS or LB target group swap); canary needs L7 routing capable of percentage-based or header-based traffic splitting.

**91. Why would you use a service mesh instead of just Kubernetes NetworkPolicies?**
NetworkPolicies only do L3/L4 allow/deny; a service mesh (Istio/Linkerd) adds L7 features — mTLS everywhere, retries, circuit breaking, fine-grained traffic shifting — at the cost of added complexity/latency.

**92. How do you handle secrets/credentials needed for network access (DB passwords, API keys) without hardcoding them in network configs?**
Centralized secrets managers (Vault, AWS Secrets Manager) injected at runtime, never committed to IaC repos or container images.

**93. What's the role of Infrastructure as Code in preventing network misconfiguration?**
Version-controlled, reviewable, diffable changes to VPCs/Security Groups/routes — catching mistakes (like an accidental 0.0.0.0/0 rule) in code review before they hit production.

**94. How would you test that a Security Group change doesn't break an existing service before merging?**
Automated integration tests against a staging environment with the same SG topology, plus tools that statically analyze IaC diffs for risky changes (e.g., open ports to the internet).

**95. What's the deployment-time risk of changing a Kubernetes Service's selector labels?**
It can instantly redirect live traffic to a different (possibly unready) set of Pods — treat label changes with the same caution as a routing change, not just a metadata update.

**96. Why is "rolling update with readiness probes" a networking concern, not just a deployment concern?**
Pods are only added to a Service's load-balancing pool once they pass readiness checks — without correct probes, traffic gets routed to Pods that aren't actually ready to serve it.

**97. How do you safely roll out a DNS-based traffic migration between two cloud regions?**
Lower TTL well in advance, use weighted/latency-based routing to shift traffic gradually, and monitor error rates at each weight step before proceeding.

**98. What's a common networking gotcha when containerizing an app that previously ran on a VM?**
Hardcoded `localhost` references that worked when everything ran on one host break once components are split into separate containers/Pods needing real network addresses.

**99. Why do GitOps-deployed Ingress/NetworkPolicy changes need extra caution compared to app deployments?**
A bad app deployment usually breaks one service; a bad network policy/Ingress change can silently cut off traffic for many services at once or open unintended access — blast radius is much larger.

**100. What's the single habit that most reliably prevents network-related production incidents?**
Treating every network change (Security Group, route table, NetworkPolicy, DNS) with the same code-review and staged-rollout rigor as application code — not as a quick manual console click.

---

## FINAL CHEAT SHEET

*Print this section. Skim it the morning of your interview.*

### 1. OSI / Debugging Layer Map

| Layer | Protocols | Debug tool |
|---|---|---|
| 7 App | HTTP, DNS, gRPC | `curl -v` |
| 4 Transport | TCP, UDP | `ss`, `nc` |
| 3 Network | IP, ICMP | `ping`, `traceroute` |
| 2 Data Link | MAC, ARP | `arp -a` |
| 1 Physical | Cables/NIC | link lights |

**Debug bottom-up.** L3 fails → don't touch app code yet.

### 2. Common Ports (memorize these cold)

| Port | Protocol | Port | Protocol |
|---|---|---|---|
| 20/21 | FTP | 443 | HTTPS |
| 22 | SSH | 445 | SMB |
| 23 | Telnet | 465/587 | SMTP (TLS) |
| 25 | SMTP | 3306 | MySQL |
| 53 | DNS | 5432 | PostgreSQL |
| 67/68 | DHCP | 6379 | Redis |
| 80 | HTTP | 8080 | Common alt-HTTP |
| 110 | POP3 | 9092 | Kafka |
| 143 | IMAP | 9200 | Elasticsearch |
| 179 | BGP | 27017 | MongoDB |
| 389 | LDAP | 30000-32767 | K8s NodePort range |

### 3. CIDR Quick Reference

| /CIDR | Hosts | /CIDR | Hosts |
|---|---|---|---|
| /32 | 1 | /24 | 254 |
| /30 | 2 | /20 | 4,094 |
| /29 | 6 | /16 | 65,534 |
| /28 | 14 | /8 | 16,777,214 |
| /27 | 30 | | |

Private ranges: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`

### 4. TCP States Cheat Sheet

`LISTEN → SYN_SENT/SYN_RECV → ESTABLISHED → FIN_WAIT → TIME_WAIT → CLOSED`

Mass `TIME_WAIT` = connection churn, fix with pooling/keepalive.
Mass `SYN_RECV` = possible SYN flood.

### 5. Cloud Networking Object Map (AWS → Azure → GCP)

| AWS | Azure | GCP |
|---|---|---|
| VPC | VNet | VPC (global) |
| Subnet | Subnet | Subnet (regional) |
| Internet Gateway | (implicit) | Default internet gw |
| NAT Gateway | NAT Gateway | Cloud NAT |
| Security Group | NSG | Firewall Rules |
| NACL | (merged into NSG) | — |
| VPC Peering | VNet Peering | VPC Peering |
| Transit Gateway | Virtual WAN | Network Connectivity Center |
| PrivateLink | Private Endpoint | Private Service Connect |
| Route53 | Azure DNS | Cloud DNS |
| ALB / NLB | App Gateway / LB | HTTP(S) LB / Network LB |

**SG vs NACL:** SG = stateful, instance-level, allow-only. NACL = stateless, subnet-level, allow+deny, ordered rules.

### 6. Kubernetes Traffic Flow (memorize the order)

```
User → DNS → Cloud LB → Ingress Controller (L7) → Service (ClusterIP, L4) → Pod
```

| Service Type | Scope |
|---|---|
| ClusterIP | Internal only |
| NodePort | Static port on every node |
| LoadBalancer | Cloud-provisioned external LB |

CNI assigns Pod IPs. kube-proxy/Cilium programs iptables/eBPF for Service routing. CoreDNS resolves Service/Pod names. NetworkPolicy = Pod firewall (default allow-all until applied).

### 7. Troubleshooting Command Reference

| Goal | Command |
|---|---|
| Is host alive? | `ping -c 3 <host>` |
| Where does it break? | `traceroute <host>` / `mtr <host>` |
| What does DNS say? | `dig +short <host>` / `dig +trace <host>` |
| Full HTTP/TLS detail | `curl -v <url>` |
| Raw packets | `sudo tcpdump -i <iface> port <p> -nn` |
| What's listening? | `ss -tlnp` |
| Routing table | `ip route` |
| ARP cache | `arp -a` |
| TLS cert detail | `openssl s_client -connect host:443` |
| UDP port test | `nc -uv <ip> <port>` |

### 8. Troubleshooting Decision Tree (one-liner version)

```
Connection refused  → host reachable, nothing listening on that port / wrong port
Timeout, no response → firewall/SG/NACL/route problem (most common)
DNS resolves wrong/no IP → resolver/CoreDNS/TTL issue
TLS handshake fails → cert/SNI/cipher mismatch
ping ok, curl fails  → L4/L7 problem (port closed, app down, or TLS issue)
```

### 9. AI Infra Networking Cheat Sheet

| Concept | One-line meaning |
|---|---|
| RDMA | NIC reads/writes remote memory directly, skips CPU/kernel |
| RoCE | RDMA over standard Ethernet (needs lossless config) |
| InfiniBand | Purpose-built lossless fabric, gold standard for training |
| NVLink | GPU-to-GPU within one server, fastest tier |
| GPUDirect | RDMA extended directly to GPU memory |
| NCCL | Library implementing All-Reduce etc., picks fastest path automatically |
| East-West | GPU↔GPU traffic — dominates training |
| North-South | User↔API traffic — dominates inference |

**Why networking is the AI bottleneck:** synchronized gradient updates mean ALL GPUs wait on the SLOWEST network link each step — idle GPU time = wasted money at massive scale.

### 10. Final Interview Reflexes

- Always answer **What problem does this solve** before **how it works**.
- Debug **bottom-up** through the OSI layers.
- For any cloud networking question, mention **the AWS term, then its Azure/GCP equivalent** — signals multi-cloud fluency.
- For any K8s question, be ready to **trace the exact packet path** (User → LB → Ingress → Service → Pod).
- For AI infra questions, always tie back to: **"network stalls = idle GPUs = wasted money."**
- When in doubt on a troubleshooting question: **ping → traceroute → dig → curl -v → tcpdump**, in that order.

---

<div align="center">
<i>You now have the highest-ROI 6 hours of networking knowledge for AI infra, cloud, K8s, SRE, and DevOps interviews. Go get it.</i>
</div>
