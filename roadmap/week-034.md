# Week 34 Roadmap: Cloud Networking: IPAM, IPv6, Routing, VPC Architecture & Cloud Interconnects

## 📅 Timeline: Days 232 - 238 (October 19, 2026 – October 25, 2026)

---

## Day 232/1000 — Day 6/28: Address Planning for Cloud Environments
- **Date:** 19 October 2026 (Calendar: October 19, 2026 (Monday))
- **Duration:** 2 Hours
- **Networking Mastery:** Day 6 / 28
- **AI Cloud Infrastructure Journey:** Day 232 / 1000
- **Theme:** Sizing VPCs, VLSM, Non-Overlapping CIDR Strategy & Cloud IPAM

### Objective & Goals
Master enterprise IP address planning for multi-account cloud environments, design scalable VPC topologies using Variable Length Subnet Masking (VLSM), prevent routing collisions, and understand automated IP Address Management (IPAM).

By the end of today, I should be able to:

* Size VPCs and subnets defensively for future workload growth and auto-scaling
* Apply Variable Length Subnet Masking (VLSM) to allocate IP blocks based on workload requirements without fragmentation
* Design a non-overlapping multi-account, multi-region CIDR allocation scheme for AWS Transit Gateway and hybrid connectivity
* Overcome IPv4 exhaustion in containerized clusters using AWS secondary CIDRs (CGNAT `100.64.0.0/10`)
* Understand IPAM architecture (Scopes, Top-level Pools, Regional Pools, and Automated VPC Allocations)
* Build an automated VLSM subnet calculator tool (`cloud_ipam_planner.sh`)

---

---

## Day 233 — Day 7/28: IPv6 and Dual-Stack Networking
- **Date:** October 20, 2026 (Calendar: October 20, 2026 (Tuesday))
- **Duration:** 2 Hours
- **Track:** Networking Fundamentals
- **Focus:** IPv6, CIDR Prefixes, Dual-Stack VPCs, and IPv6 Internet Connectivity

### Objective & Goals
By the end of this session, I should be able to:

- Understand IPv6 address structure and hexadecimal notation.
- Apply IPv6 address compression rules.
- Understand IPv6 prefix lengths such as `/64`, `/56`, and `/48`.
- Differentiate link-local, global unicast, and unique local addresses.
- Explain dual-stack networking in AWS VPCs.
- Understand IPv6 routing and internet connectivity.
- Explain why IPv6 generally does not require NAT for address conservation.
- Understand the role of an Egress-only Internet Gateway in AWS.

---

---

## Day 234/1000 — Routing Fundamentals
- **Date:** October 21, 2026 (Calendar: October 21, 2026 (Wednesday))
- **Track:** Day 8/28 — Mastering Networking
- **Duration:** 2 Hours
- **Focus:** Routing Tables, Next-Hop Selection, Longest Prefix Match, Default Routes, and Route Priority
- **Journey:** Day 234 / 1000 — Becoming an AI Cloud Infrastructure Engineer

### Objective & Goals
Understand how routers select the best route for a destination IP address, how packets are forwarded to their next hop, and how routing works in AWS VPC environments.

---

---

## Day 235/1000 — Networking Mastery: ARP, MAC Addresses, and Local Delivery
- **Date:** October 22, 2026 (Calendar: October 22, 2026 (Thursday))
- **Duration:** 2 Hours
- **Track:** Day 9/28 — Mastering Networking
- **Main Focus:** Same-subnet vs. cross-subnet delivery, ARP, MAC addresses, default gateways, and network troubleshooting
- **Journey:** Day 235 / 1000 — Becoming an AI Cloud Infrastructure Engineer

### Objective & Goals
Understand how devices communicate within a local network, how ARP resolves IPv4 addresses into MAC addresses, and how routers forward packets between different subnets.

By the end of this session, I should be able to explain why local communication does not normally require a gateway, why remote communication does, and how gateway failures affect network connectivity.

---

---

## Day 236/1000 — Virtual Private Cloud (VPC) Building Blocks
- **Date:** October 23, 2026 (Calendar: October 23, 2026 (Friday))
- **Journey:** 1000 Days of AI Cloud Infrastructure Engineering
- **Track:** Mastering Networking — Day 10/28
- **Duration:** 2 Hours
- **Focus:** AWS VPC, CIDR planning, public and private subnets, Internet Gateways, route tables, DHCP, and DNS.

### Objective & Goals
Plan a basic AWS VPC with public and private subnets across two Availability Zones.

### Step 1: Define the VPC

```text
VPC CIDR: 10.0.0.0/16
Region: ap-south-1
```

### Step 2: Plan the subnets

```text
Public Subnet A:  10.0.1.0/24
Public Subnet B:  10.0.2.0/24

Private Subnet A: 10.0.11.0/24
Private Subnet B: 10.0.12.0/24
```

### Step 3: Attach an Internet Gateway

Create an Internet Gateway and attach it to the VPC.

### Step 4: Configure the public route table

```text
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        Internet Gateway
```

Associate the public subnets with this route table.

### Step 5: Configure private routing

Keep the private subnets off the direct Internet Gateway route.

For a basic private network, the local route can provide connectivity to other VPC resources when security rules permit it.

If private IPv4 instances require internet egress, design a suitable NAT solution and configure the appropriate route.

### Step 6: Verify DNS settings

Check:

```text
enableDnsSupport
enableDnsHostnames
```

Understand the purpose of each attribute before changing it.

### Step 7: Validate the design

Confirm:

- The VPC CIDR contains every planned subnet.
- Subnet ranges do not overlap.
- Each subnet is assigned to the intended AZ.
- Public subnets use the public route table.
- Private subnets do not have an unintended direct IGW route.
- DNS configuration matches the application requirements.
- Security groups and network ACLs follow least-privilege principles.

### Cost precaution

Design and review the network before deploying resources.

An Internet Gateway itself does not have an hourly charge, but NAT Gateways, public IPv4 addresses, running compute, and other AWS services can incur charges. Check current AWS pricing before deployment.

---

---

## Day 237/1000 — Day 11/28: NAT and Outbound Connectivity
- **Date:** 24 October 2026 (Calendar: October 24, 2026 (Saturday))
- **Journey:** 1000 Days of AI Cloud Infrastructure Engineering
- **Track:** Networking Mastery — Day 11/28
- **Duration:** 2 Hours
- **Focus:** NAT, SNAT, DNAT, PAT, AWS NAT Gateway, outbound connectivity, and high availability.

### Objective & Goals
By the end of today's session, I should be able to:

- Explain Network Address Translation (NAT).
- Differentiate SNAT, DNAT, and Port Address Translation (PAT).
- Understand connection tracking and port mapping.
- Explain how AWS NAT Gateways provide outbound IPv4 connectivity.
- Configure and understand public and private subnet route tables.
- Explain why one NAT Gateway per Availability Zone improves resilience.
- Identify NAT costs, throughput limits, and port exhaustion risks.
- Compare NAT Gateways with self-managed NAT instances.
- Understand outbound-only IPv6 connectivity using an egress-only Internet Gateway.

---

---

## Day 238 — Day 12/28: Connecting Networks Inside the Cloud
- **Date:** October 25, 2026 (Calendar: October 25, 2026 (Sunday))
- **Journey:** Day 238/1000 — AI Cloud Infrastructure Engineer
- **Track:** Day 12/28 — Mastering Networking
- **Duration:** 2 Hours
- **Focus:** VPC Peering, Transit Gateway, VPC Endpoints, and Route Conflicts

### Objective & Goals
By the end of today's session, I should be able to:

- Explain VPC peering and why it is not transitive.
- Understand Transit Gateway and hub-and-spoke network architectures.
- Compare gateway endpoints with interface endpoints.
- Identify overlapping CIDR ranges and their routing problems.
- Troubleshoot blackhole routes and connectivity failures.
- Design scalable and secure network connectivity in AWS.

---

---

