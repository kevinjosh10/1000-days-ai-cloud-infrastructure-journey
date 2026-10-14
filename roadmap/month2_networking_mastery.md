# Month 2: Networking for Cloud Infrastructure Engineers — Mastery Roadmap

> **Goal:** Be able to debug "app can't reach database" end-to-end across VPCs, DNS, routing, security controls, TLS, and load balancers.

---

## 📅 Roadmap Overview

| Week | Focus Area | Key Concepts |
|---|---|---|
| **Week 1** | Addressing and Subnetting | OSI/TCP-IP models, IPv4/IPv6, CIDR math, VLSM, IPAM, Cloud-reserved IPs |
| **Week 2** | Routing, Cloud VPCs & Hybrid Connectivity | Routing tables, ARP, VPC building blocks, NAT, Peering, Transit Gateways, VPN/Direct Connect, DNS roots |
| **Week 3** | DNS in Depth, Transport & Application Protocols | DNS record types, Split-horizon DNS, Service Discovery, TCP lifecycle, MTU/MSS, UDP/QUIC |
| **Week 4** | Application Layer Security, Load Balancing & K8s | HTTP/1.1-2-3, TLS 1.3/mTLS, Security Groups/NACLs, L4/L7 Load Balancing, CNI & K8s Services, Systematic Troubleshooting |

---

## Week 1: Addressing and Subnetting

### Day 1: Network Layers and Encapsulation
- OSI model vs TCP/IP model
- What each layer does (link, network, transport, application)
- Encapsulation and decapsulation of a request
- How cloud virtual networks map onto these layers

### Day 2: IPv4 Address Structure
- 32-bit addresses, dotted decimal, binary conversion
- Network portion vs host portion
- Converting addresses between decimal and binary quickly

### Day 3: Special and Reserved Address Ranges
- Private ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 (RFC 1918)
- Carrier-grade NAT: 100.64.0.0/10
- Loopback: 127.0.0.0/8
- Link-local: 169.254.0.0/16, including the cloud instance metadata endpoint 169.254.169.254
- Multicast and reserved ranges

### Day 4: CIDR Notation and Prefix Math
- Prefix length (/16, /24, etc.) and subnet masks
- Calculating network address, broadcast address, first and last usable host
- Host count formula and why it differs per cloud provider
- Cloud-reserved IPs per subnet (AWS and Azure reserve 5, GCP reserves 4; verify against current docs)

### Day 5: Subnetting by Hand
- Borrowing bits to create subnets
- Block size as a shortcut (256 minus the mask octet)
- Splitting a block into N equal subnets
- Route aggregation (supernetting) and why it matters for route tables

### Day 6: Address Planning for Cloud Environments
- Sizing VPCs and subnets for growth
- Variable Length Subnet Masking (VLSM)
- Avoiding CIDR overlap across VPCs, accounts, regions, and on-premises networks
- IP Address Management (IPAM) concepts: pools, allocation, and tracking

### Day 7: IPv6 and Dual-Stack
- IPv6 address format and compression rules
- Prefix sizes (/64 for subnets, /56 or /48 for sites)
- Link-local vs global unicast addresses
- Dual-stack design: running IPv4 and IPv6 together in a VPC
- Why NAT is rarely needed with IPv6 and what replaces it (egress-only gateways)

---

## Week 2: Routing, Cloud Network Building Blocks, and Hybrid Connectivity

### Day 8: Routing Fundamentals
- Routing tables and next-hop selection
- Longest prefix match as the deciding rule
- Default route (0.0.0.0/0 and ::/0)
- Route priority and how static, propagated, and local routes interact

### Day 9: ARP, MAC Addresses, and Local Delivery
- Same-subnet vs cross-subnet forwarding decisions
- ARP: resolving IP to MAC
- Gateway role: how a packet leaves a subnet
- Why an unreachable gateway looks like "everything is down"

### Day 10: Virtual Private Cloud Building Blocks
- VPC CIDR and subnet placement across availability zones
- Public vs private subnets, defined by their route table, not their name
- Internet gateways and egress-only internet gateways
- Route tables, main route table, and per-subnet association
- DHCP option sets and DNS settings inside a VPC

### Day 11: NAT and Outbound Connectivity
- Source NAT (SNAT) and destination NAT (DNAT)
- Port address translation and how connections are tracked
- Managed NAT gateways: one per AZ for high availability
- Cost, throughput limits, and port exhaustion
- NAT instances vs managed NAT services

### Day 12: Connecting Networks Inside the Cloud
- VPC peering and why it is not transitive
- Transit gateways and hub-and-spoke topologies
- VPC endpoints: gateway endpoints vs interface endpoints (PrivateLink)
- Overlapping routes and how to avoid blackholing traffic

### Day 13: Hybrid Connectivity
- Site-to-site VPN: IPsec tunnels, redundancy, static vs dynamic routing
- Dedicated links: AWS Direct Connect, Azure ExpressRoute, Google Cloud Interconnect (concepts only)
- BGP basics: autonomous system numbers, route advertisement, AS path, route preference
- Route propagation between on-premises and cloud

### Day 14: DNS Fundamentals
- Name resolution flow: stub resolver, recursive resolver, root, TLD, authoritative server
- Recursive vs iterative queries
- Authoritative answers vs cached answers
- TTL and caching behavior at each hop

---

## Week 3: DNS in Depth, Transport, and Application Protocols

### Day 15: DNS Record Types for Infrastructure
- A and AAAA records
- CNAME and its limitation at the zone apex
- Alias or ANAME records (provider-specific equivalents of CNAME at the apex)
- MX, TXT (used for domain verification and SPF/DKIM), NS, SOA
- SRV for service discovery, PTR for reverse lookups, CAA for certificate issuance control

### Day 16: Cloud DNS Services
- Public vs private hosted zones
- Split-horizon DNS: same name resolving differently inside and outside the VPC
- The VPC resolver (base address plus two, for example 10.0.0.2 in a 10.0.0.0/16 VPC)
- Inbound and outbound resolver endpoints for hybrid DNS
- Conditional forwarding rules

### Day 17: DNS for Service Discovery
- Internal service names and namespaces
- Kubernetes DNS format and CoreDNS
- Search domains and the ndots setting, and why they cause extra queries
- Using DNS names instead of hard-coded IPs for database endpoints

### Day 18: Traffic Management and DNS Failure Modes
- Routing policies: weighted, latency-based, geolocation, failover
- Health checks tied to DNS answers
- Lowering TTL before a planned migration, then raising it afterward
- Negative caching (NXDOMAIN) and why errors persist
- Failure symptoms: NXDOMAIN vs SERVFAIL vs timeout

### Day 19: TCP Connection Lifecycle
- Three-way handshake and sequence/acknowledgment numbers
- Connection teardown and half-closed states
- TCP states (LISTEN, ESTABLISHED, TIME_WAIT, CLOSE_WAIT)
- Ephemeral ports and port exhaustion under high connection rates

### Day 20: TCP Performance and MTU
- Retransmission and timeout behavior
- Sliding window and flow control
- Congestion control basics (slow start, congestion avoidance)
- MTU, MSS, and path MTU discovery
- Why MTU mismatches break tunnels, VPNs, and overlay networks while small requests still work

### Day 21: UDP and Stateless Protocols
- When UDP is used: DNS, DHCP, NTP, VoIP, QUIC
- No handshake, no retransmission, and what that means for application design
- UDP in load balancers and firewall rules
- How QUIC runs on UDP to provide reliable transport

---

## Week 4: Application Layer Security, Load Balancing, Kubernetes, and Troubleshooting

### Day 22: HTTP Semantics for Infrastructure
- Methods and their idempotency
- Status code classes and what each means for the load balancer and the app
- Headers that matter in cloud: Host, X-Forwarded-For, X-Forwarded-Proto, Cache-Control, Connection
- Keep-alive and connection reuse

### Day 23: HTTP/1.1, HTTP/2, and HTTP/3
- Head-of-line blocking in HTTP/1.1
- Multiplexing in HTTP/2 and its TCP-level limits
- HTTP/3 over QUIC and removing TCP-level head-of-line blocking
- ALPN negotiation

### Day 24: TLS and Certificate Management
- TLS handshake and TLS 1.3 changes
- Certificate chains, trust stores, and certificate authorities
- Server Name Indication (SNI) and why it matters for multi-tenant load balancers
- Certificate lifecycle: issuance, renewal, rotation, and expiry failures
- Mutual TLS (mTLS) for service-to-service authentication
- Managed certificate services and where termination happens (load balancer vs app)

### Day 25: Cloud Security Controls
- Stateful vs stateless filtering
- Security groups vs network ACLs: scope, rules, and evaluation order
- Default-deny design and least-privilege ingress and egress
- Referencing security groups as sources instead of IP ranges
- Managed firewall services and web application firewalls (WAF): what each protects against

### Day 26: Load Balancing
- Layer 4 vs Layer 7 load balancing
- Application, network, and gateway load balancer types (concepts)
- Listeners, target groups, and routing rules
- Balancing algorithms: round robin, least connections, consistent hashing
- Health checks, connection draining, and cross-zone balancing
- Session affinity and its trade-offs

### Day 27: Kubernetes Networking
- Pod network model: every pod gets an IP; pods communicate without NAT
- Container Network Interface (CNI) plugins
- Service types: ClusterIP, NodePort, LoadBalancer
- kube-proxy modes (iptables, IPVS) and how Services are implemented
- Ingress vs Gateway API for external HTTP routing
- Network policies for pod-level traffic control

### Day 28: Observability and Systematic Troubleshooting
- VPC flow logs: fields, accept vs reject, and what they can and cannot show
- Path tools: traceroute, mtr, and what hop-level output means
- Packet capture: tcpdump and Wireshark filters for DNS, TCP handshakes, TLS, and RSTs
- Cloud reachability analysis tools (concepts)
- A layer-by-layer method for "app can't reach database":
  1. **Name resolution:** Does the name resolve to the right IP?
  2. **Routing:** Is there a valid route and return path?
  3. **Security controls:** Do security groups, NACLs, and firewalls allow it?
  4. **Port and listener:** Is the database listening on the expected interface and port?
  5. **TLS and application:** Does the handshake and authentication succeed?
  6. **Load balancer and target health:** Are targets healthy and registered?

---

## 🎯 Month-End Mastery Check (Concepts)

You have finished this plan when you can explain, without notes:
- How a packet from a private subnet reaches the internet and how the reply returns
- Why two VPCs with overlapping CIDRs cannot be connected directly, and what to do about it
- How DNS, routing, security groups, and TLS each fail, and how each failure looks from the client
- The difference between an ALB, an NLB, and a gateway load balancer at the concept level
- How a Kubernetes Service reaches a pod across nodes
- Which layer to check first for any connectivity failure, and why
