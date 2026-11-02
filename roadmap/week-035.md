# Week 35 Roadmap: Cloud Networking: Hybrid Connectivity, Enterprise DNS & Transport Layer Internals

## 📅 Timeline: Days 239 - 245 (October 26, 2026 – November 1, 2026)

---

## Day 239 — Day 13/28: Hybrid Connectivity
- **Date:** October 26, 2026 (Calendar: October 26, 2026 (Monday))
- **Journey:** Day 239/1000 — AI Cloud Infrastructure Engineer
- **Track:** Day 13/28 — Mastering Networking
- **Duration:** 2 Hours
- **Focus:** Site-to-Site VPN, IPsec Tunnels, Dedicated Links (AWS Direct Connect, Azure ExpressRoute, Google Cloud Interconnect), BGP Fundamentals, and Cloud Route Propagation.

### Objective & Goals
By the end of today's session, I should be able to:

- Explain the core architecture and use cases for hybrid cloud networking.
- Understand Site-to-Site VPNs, IPsec protocol suites (IKE, ESP, AH), and Phase 1 vs. Phase 2 negotiations.
- Compare static routing with dynamic routing (BGP) over IPsec tunnels.
- Understand dedicated cloud connections: AWS Direct Connect, Azure ExpressRoute, and Google Cloud Interconnect.
- Differentiate Virtual Interface types: Private VIF, Public VIF, and Transit VIF.
- Master Border Gateway Protocol (BGP) fundamentals in cloud networking: Autonomous System Numbers (ASN), route advertisements, AS Path prepending, and Multi-Exit Discriminator (MED).
- Understand automated cloud route propagation and route table priority inside a VPC.
- Design resilient hybrid architectures featuring active/active dual tunnels, dedicated links with automated VPN failover, and hub-and-spoke multi-VPC transit networks.

---

---

## Day 240 — Day 14: DNS Fundamentals
- **Date:** October 27, 2026 (Calendar: October 27, 2026 (Tuesday))
- **Journey:** Day 14/28 — Mastering Networking
- **Overall Progress:** Day 240/1000 — Becoming a Cloud Infrastructure Engineer
- **Duration:** 2 Hours
- **Focus:** DNS Resolution, Recursive vs. Iterative Queries, Authoritative Answers, Caching, and TTL

### Objective & Goals
Understand how the Domain Name System (DNS) translates human-readable domain names into IP addresses, how DNS queries travel through different servers, and how caching affects cloud infrastructure.

By the end of this session, I should be able to explain DNS resolution, distinguish recursive and iterative queries, understand authoritative and cached answers, and troubleshoot common DNS issues.

---

---

## Day 241 — Day 15: DNS Record Types for Infrastructure
- **Date:** October 28, 2026 (Calendar: October 28, 2026 (Wednesday))
- **Journey:** Day 15/28 — Mastering Networking
- **Overall Progress:** Day 241/1000 — AI Cloud Infrastructure Engineer
- **Duration:** 2 Hours
- **Focus:** DNS Records, Cloud DNS, and Infrastructure Troubleshooting

### Objective & Goals
By the end of this session, I should be able to:

- Understand A and AAAA records and their cloud infrastructure roles.
- Explain CNAME records and why the zone-apex restriction exists.
- Understand Alias and ANAME records and how cloud providers overcome the apex limitation.
- Configure and troubleshoot MX and TXT records (SPF, DKIM, DMARC).
- Explain NS and SOA records and their role in zone delegation and transfers.
- Understand SRV and PTR records (forward vs. reverse DNS lookups).
- Explain CAA records and certificate issuance policy control.
- Inspect DNS records using PowerShell and Linux tools.

---

---

## Day 242 — Day 16: Cloud DNS Services
- **Date:** October 30, 2026 (Calendar: October 29, 2026 (Thursday))
- **Track / Focus:** Day 16/28 — Mastering Networking
- **Track / Focus:** Day 242/1000 — AI Cloud Infrastructure Engineer Journey
- **Duration:** 2 Hours
- **Focus:** Cloud DNS, Route 53 Hosted Zones, VPC Resolver, and Hybrid DNS

### Objective & Goals
By the end of this session, I should be able to:

- Understand public vs. private hosted zones in cloud environments.
- Learn split-horizon DNS and its practical infrastructure applications.
- Understand the Amazon-provided VPC DNS resolver and the base-plus-two rule.
- Differentiate inbound and outbound Route 53 Resolver endpoints.
- Understand conditional forwarding rules and resolver rule types.
- Design a production-ready hybrid DNS architecture connecting AWS and on-premises enterprise networks.

---

---

## Day 243 — Day 17/28: DNS for Service Discovery
- **Date:** October 30, 2026 (Calendar: October 30, 2026 (Friday))
- **Duration:** 2 Hours
- **Track:** Day 17/28 — Mastering Networking
- **Focus:** DNS-Based Service Discovery, Namespaces, Kubernetes DNS, CoreDNS, Search Domains, and ndots Optimization

### Objective & Goals
By the end of today's session, I should be able to:

- Explain how DNS-based service discovery decouples microservices from ephemeral IP addresses.
- Understand internal DNS namespaces for environment isolation (e.g., dev, staging, prod).
- Dissect the Kubernetes DNS architecture and the role of CoreDNS.
- Break down the standard Kubernetes Service FQDN format (`<service>.<namespace>.svc.cluster.local`).
- Explain how `/etc/resolv.conf` search domains enable short name resolution across namespaces.
- Analyze the `ndots:5` configuration and identify how it creates DNS query multiplication.
- Apply mitigation strategies (trailing dot, ndots tuning, NodeLocal DNSCache) to prevent DNS throttling.
- Compare DNS-based database endpoints (AWS RDS, Route 53) against hard-coded IP architectures.
- Execute Linux and Kubernetes DNS diagnostics (`dig`, `nslookup`, `kubectl exec`, CoreDNS ConfigMap).

---

---

## Day 244/1000 – Traffic Management and DNS Failure Modes
- **Date:** October 31, 2026 (Calendar: October 31, 2026 (Saturday))
- **Journey:** 1000 Days to Become an AI Cloud Infrastructure Engineer
- **Track:** Networking Mastery – Day 18/28
- **Duration:** 2 Hours
- **Focus:** DNS Traffic Routing Policies, Health Checks, TTL Migration Planning, Negative Caching (NXDOMAIN), and DNS Failure Modes (SERVFAIL, TIMEOUT)

### Objective & Goals
Understand how DNS manages application traffic across multiple endpoints, handles infrastructure failures, and supports reliable application migrations.

Learn how DNS routing policies, health checks, TTL management, and negative caching work in real-world cloud infrastructure.

By the end of today's session, I should be able to configure dynamic traffic routing, diagnose DNS failure modes (NXDOMAIN, SERVFAIL, TIMEOUT), plan safe zero-downtime DNS migrations, and build resilient multi-region architectures.

---

---

## Day 245/1000 – Day 19/28: TCP Connection Lifecycle
- **Date:** November 1, 2026 (Calendar: November 1, 2026 (Sunday))
- **Duration:** 2 Hours
- **Track:** Mastering Networking – Day 19/28
- **Journey:** 1000 Days of AI Cloud Infrastructure Engineering
- **Focus:** TCP Connection Lifecycle, Handshake, Teardown, Connection States, Ephemeral Ports, and Port Exhaustion

### Objective & Goals
Understanding how TCP establishes, maintains, and terminates connections, including connection states, ephemeral ports, and port exhaustion.

By the end of today's session, I should be able to dissect the 3-way handshake and 4-way teardown, analyze sequence and acknowledgment number arithmetic, explain the purpose of `TIME_WAIT` and the danger of `CLOSE_WAIT`, troubleshoot ephemeral port exhaustion in cloud environments (such as AWS NAT Gateways), and monitor socket states using modern Linux tooling (`ss`).

---

---

