# Week 36 Roadmap: Cloud Networking: Transport Protocols, HTTP Evolution, TLS & Edge Load Balancing

## 📅 Timeline: Days 246 - 252 (November 2, 2026 – November 8, 2026)

---

## Day 246 / 1000 – TCP Performance and MTU
- **Date:** November 2, 2026 (Calendar: November 2, 2026 (Monday))
- **Track / Focus:** Networking Mastery: Day 20/28
- **Duration:** 2 Hours
- **Journey:** 1000 Days of AI Cloud Infrastructure Engineering
- **Focus:** TCP Performance, Retransmission, Sliding Window, Congestion Control, MTU, and Path MTU Discovery (PMTUD)

### Objective & Goals
By the end of today's session, I should be able to:

- Dissect TCP retransmission timers, Retransmission Timeout (RTO) calculations, and Fast Retransmit.
- Understand Selective Acknowledgment (SACK) and how it optimizes loss recovery.
- Explain the sliding window mechanism, flow control, and the difference between `rwnd` and `cwnd`.
- Master TCP congestion control phases: Slow Start, Congestion Avoidance, and Fast Recovery.
- Compare modern congestion control algorithms (CUBIC vs. BBR).
- Calculate Maximum Transmission Unit (MTU) and Maximum Segment Size (MSS) across IPv4 and IPv6.
- Analyze Path MTU Discovery (PMTUD) and diagnose the catastrophic "MTU Black Hole" failure mode.
- Understand encapsulation overhead in VPNs (IPsec/WireGuard) and Kubernetes overlay networks (VXLAN/Geneve).
- Troubleshoot TCP performance bottlenecks and MTU mismatches using Linux command-line utilities.

---

---

## Day 247 / 1000 – UDP and Stateless Protocols
- **Date:** November 3, 2026 (Calendar: November 3, 2026 (Tuesday))
- **Journey:** 1000 Days of Becoming an AI Cloud Infrastructure Engineer
- **Track:** Networking Mastery – Day 21/28
- **Duration:** 2 Hours
- **Focus:** UDP, Stateless Communication, QUIC, and Cloud Network Traffic

### Objective & Goals
Understand UDP (User Datagram Protocol), its connectionless communication model, real-world applications, and how it is used in modern cloud infrastructure. Explore how QUIC provides reliable transport over UDP and how cloud load balancers and firewalls handle UDP traffic.

By the end of today's session, I should be able to analyze the 8-byte UDP header, contrast TCP and UDP transport models, evaluate latency-critical protocols (DNS, DHCP, NTP, VoIP, QUIC/HTTP/3), configure AWS Network Load Balancers and stateful firewalls for UDP, and inspect UDP socket states using Linux command-line utilities.

---

---

## Day 248 — Day 22: HTTP Semantics for Infrastructure
- **Date:** November 4, 2026 (Calendar: November 4, 2026 (Wednesday))
- **Track / Focus:** Day 22 / 28 – Mastering Networking
- **Track / Focus:** Day 248 / 1000 – Becoming an AI Cloud Infrastructure Engineer
- **Duration:** 2 Hours
- **Focus:** HTTP Methods, Idempotency, Status Codes, Headers, Keep-Alive, and Connection Reuse

### Objective & Goals
Master HTTP Methods, Idempotency, Status Codes, Headers, Keep-Alive, and Connection Reuse.

HTTP (**Hypertext Transfer Protocol**) is the foundational application-layer protocol (OSI Layer 7) enabling communication between clients (browsers, mobile apps, microservices) and servers (reverse proxies, load balancers, backend APIs).

---

## Day 249 — Day 23: HTTP/1.1, HTTP/2, and HTTP/3
- **Date:** 5 November 2026 (Calendar: November 5, 2026 (Thursday))
- **Journey:** Day 249 / 1000 – AI Cloud Infrastructure Engineer
- **Networking Mastery:** Day 23 / 28
- **Duration:** 2 Hours
- **Focus:** HTTP Protocol Evolution, Multiplexing, QUIC, and ALPN

### Objective & Goals
By the end of today's session, I should be able to:

- Dissect head-of-line (HOL) blocking in HTTP/1.1 and its impact on web latency.
- Understand binary framing, streams, and multiplexing in HTTP/2.
- Analyze why HTTP/2 still suffers from TCP-level head-of-line blocking during packet loss.
- Master HTTP/3 architecture and the role of QUIC over UDP.
- Explain how QUIC eliminates TCP-level head-of-line blocking between independent streams.
- Understand Application-Layer Protocol Negotiation (ALPN) and the `Alt-Svc` discovery mechanism.
- Compare HPACK and QPACK header compression.
- Evaluate real-world HTTP protocol termination in cloud infrastructure (CDNs, ALBs, and firewalls).
- Perform hands-on protocol testing using PowerShell and `curl.exe`.

---

---

## Day 250/1000 – TLS and Certificate Management
- **Date:** 6 November 2026 (Calendar: November 6, 2026 (Friday))
- **Networking Track:** Day 24/28 – Mastering Networking
- **Main Journey:** Day 250/1000 – Becoming an AI Cloud Infrastructure Engineer
- **Duration:** 2 Hours
- **Focus:** TLS, HTTPS, Certificate Authorities, SNI, mTLS, Certificate Lifecycle, and Cloud Certificate Management

### Objective & Goals
Master TLS, HTTPS, Certificate Authorities, SNI, mTLS, Certificate Lifecycle, and Cloud Certificate Management.

**Transport Layer Security (TLS)** (standardized in RFC 8446 for TLS 1.3) is an industry-standard cryptographic protocol operating above Layer 4 (Transport) and beneath Layer 7 (Application) that establishes an encrypted, authenticated, and tamper-proof communications channel over insecure IP networks.

When a client navigates to an HTTPS endpoint (e.g., `https://www.amazon.com`), TLS negotiates cryptographic keys and authenticates the remote endpoint before transmitting application data.

---

## Day 251 / 1000 – Cloud Security Controls
- **Date:** 7 November 2026 (Calendar: November 7, 2026 (Saturday))
- **Journey:** 1000 Days of Becoming an AI Cloud Infrastructure Engineer
- **Networking Track:** Day 25 / 28 – Mastering Networking
- **Overall Progress:** 251 / 1000 (25.1%)
- **Networking Progress:** 25 / 28 (89.3%)
- **Duration:** 2 Hours
- **Focus:** Stateful vs. Stateless Filtering, AWS Security Groups vs. Network ACLs, Default-Deny Architecture, Security Group Referencing, and Defense-in-Depth VPC Design

### Objective & Goals
By the end of today's session, I should be able to:

- Differentiate stateful packet inspection from stateless packet filtering.
- Compare AWS Security Groups (resource-level) and Network ACLs (subnet-level).
- Understand NACL rule evaluation order and the critical role of ephemeral ports.
- Implement default-deny architecture and the principle of least-privilege networking.
- Configure Security Group referencing to support resilient autoscaling without hard-coded IPs.
- Distinguish AWS Network Firewall (Layers 3–7 network inspection) from AWS WAF (Layer 7 application protection).
- Architect a production-grade secure three-tier AWS VPC with defense-in-depth security layers.

---

---

## Day 252/1000 – Load Balancing
- **Date:** 8 November 2026 (Calendar: November 8, 2026 (Sunday))
- **Duration:** 2 Hours
- **Track:** Networking Mastery
- **Goal:** Becoming an AI Cloud Infrastructure Engineer by 2030
- **Overall Progress:** 252 / 1000 (25.2%)
- **Networking Progress:** 26 / 28 (92.8%)
- **Focus:** Layer 4 vs. Layer 7 Load Balancing, ALB, NLB, GWLB, Listeners, Target Groups, Routing Algorithms, Health Checks, Connection Draining, Cross-Zone Balancing, and Session Affinity

### Objective & Goals
Master Layer 4 vs. Layer 7 Load Balancing, ALB, NLB, GWLB, Listeners, Target Groups, Routing Algorithms, Health Checks, Connection Draining, Cross-Zone Balancing, and Session Affinity.

**Load balancing** is the architectural process of distributing incoming network traffic across a pool of backend compute resources (virtual machines, containers, serverless functions) to optimize throughput, minimize response latency, eliminate resource bottlenecks, and guarantee high availability.

A load balancer acts as an authoritative reverse proxy and reverse traffic director situated between external clients and backend application fleets.

---

