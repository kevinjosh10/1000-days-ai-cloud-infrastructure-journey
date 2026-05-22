# AWS Network Project 1 – NACLs vs Security Groups Lab

## 📌 Project Overview

This project focused on understanding AWS subnet-level and instance-level security using Network ACLs (NACLs) and Security Groups.

The lab involved:
- Creating and configuring custom NACLs
- Understanding stateless vs stateful firewalls
- Configuring inbound and outbound subnet rules
- Allowing HTTP/HTTPS traffic
- Working with ephemeral ports
- Creating explicit deny rules
- Associating NACLs with public subnets
- Hosting an NGINX web server on EC2
- Testing traffic flow behavior
- Simulating networking failures and restoring connectivity

The project demonstrated how enterprise AWS environments secure infrastructure using layered network protection.

---

# 🏗️ Architecture

```text
Internet
    ↓
Internet Gateway
    ↓
Route Table
    ↓
Public Subnet
    ↓
NACL (Subnet Firewall)
    ↓
Security Group (Instance Firewall)
    ↓
EC2 Instance
    ↓
NGINX Web Server
```

---

# 🎯 Objectives

- Understand Network ACL architecture
- Compare NACLs vs Security Groups
- Learn stateless firewall behavior
- Configure subnet-level traffic filtering
- Create explicit deny rules
- Understand ephemeral ports
- Test AWS network traffic flow
- Simulate real-world connectivity failures
- Troubleshoot timeout issues
- Build production-style AWS network security knowledge

---

# 🧠 Key Concepts Learned

| Concept | Understanding |
|---|---|
| Security Groups | Stateful instance-level firewall |
| NACLs | Stateless subnet-level firewall |
| Explicit DENY | Supported only in NACLs |
| Ephemeral Ports | Required for return traffic |
| Rule Evaluation | Lowest rule number processed first |
| Defense in Depth | Multiple security layers |
| Public Subnet Security | Protected using NACL + SG |
| Stateless Networking | Requires inbound + outbound rules |

---

# 🛠️ AWS Services Used

- Amazon VPC
- EC2
- Security Groups
- Network ACLs
- Route Tables
- Internet Gateway
- NGINX

---

# ⚙️ Project Steps

## 1️⃣ Created EC2 Instance

Launched:

```text
t2.micro EC2 instance
```

Configured:
- Public subnet
- Public IP
- Security Group allowing HTTP

---

## 2️⃣ Installed NGINX

Installed NGINX web server on EC2.

Validated using:

```text
http://13.126.146.244
```

Result:

```text
Welcome to nginx!
```

---

## 3️⃣ Created Custom NACL

Created:

```text
public-web-nacl
```

Inside VPC console.

---

## 4️⃣ Configured Inbound Rules

Added rules:

| Rule # | Type | Port | Action |
|---|---|---|---|
| 90 | ALL Traffic | ALL | DENY bad IP |
| 100 | HTTP | 80 | ALLOW |
| 110 | HTTPS | 443 | ALLOW |
| 120 | TCP | 1024-65535 | ALLOW |

---

## 5️⃣ Configured Outbound Rules

Added:

| Rule # | Type | Action |
|---|---|---|
| 100 | ALL Traffic | ALLOW |

---

## 6️⃣ Associated NACL with Public Subnet

Associated custom NACL with:

```text
subnet-01df581c6b48c10e8
```

Understood:
- NACLs operate at subnet level
- NACL becomes active only after subnet association

---

## 7️⃣ Tested Website Connectivity

Validated website access.

Traffic flow:

```text
Browser
   ↓
Internet Gateway
   ↓
NACL
   ↓
Security Group
   ↓
NGINX
```

Website loaded successfully.

---

## 8️⃣ Tested Stateless Firewall Behavior

Removed outbound allow rule.

Result:

```text
ERR_CONNECTION_TIMED_OUT
```

Understood:
- NACLs are stateless
- Return traffic requires outbound permission

---

## 9️⃣ Restored Connectivity

Re-added outbound allow rule.

Website became accessible again.

Validated:
- Correct subnet firewall configuration
- Proper return traffic handling

---

# 🔥 Important Networking Concepts

## Security Groups

- Stateful
- Instance-level
- Allow rules only

Example:

```text
Inbound allowed
→ Response automatically allowed
```

---

## NACLs

- Stateless
- Subnet-level
- Allow + Deny rules

Example:

```text
Inbound allowed
→ Outbound must ALSO be allowed
```

---

# 🌐 Ephemeral Ports

Learned:

```text
1024-65535
```

are required for return traffic.

Example:

```text
Browser → Server:80
Server → Browser:53211
```

Blocking ephemeral ports breaks communication.

---

# 🚨 Troubleshooting Performed

| Problem | Cause |
|---|---|
| Website timeout | Missing outbound rule |
| Broken return traffic | Stateless firewall |
| NACL not active | Missing subnet association |
| Deny rule not working | Wrong rule order |

---

# 🏢 Real-World Use Cases

NACLs are commonly used for:

- Blocking malicious IP ranges
- Public subnet hardening
- Compliance filtering
- Enterprise subnet protection
- Defense-in-depth security architecture

---

# 🧠 AI Infrastructure Relevance

Connected networking concepts to AI cloud systems.

Learned:
- AI infrastructure often runs in isolated subnets
- GPU clusters require subnet protection
- AI APIs use layered network security
- Enterprise AI systems rely on VPC segmentation

Example:

```text
AI Infrastructure
      ↓
Protected by NACL + Security Groups
```

---

# 📊 Skills Gained

- AWS VPC networking
- NACL configuration
- Security Group management
- Subnet-level security
- Stateless networking
- Firewall troubleshooting
- Route flow understanding
- Production traffic debugging
- Enterprise cloud security concepts

---

# ✅ Final Outcome

Successfully built and tested a working AWS network security architecture using:

- Public subnet
- EC2
- NGINX
- Security Groups
- Network ACLs
- Explicit deny rules
- Stateless firewall behavior

Validated real-world AWS traffic flow and learned production-grade subnet security fundamentals.

---

# 🚀 Future Improvements

Possible future enhancements:

- Private subnet architecture
- NAT Gateway integration
- Bastion Host SSH access
- Multi-tier application architecture
- Load Balancer integration
- Web Application Firewall (WAF)
- VPC Flow Logs monitoring
- Multi-AZ secure deployment

---

# 📌 Project Status

✅ Completed Successfully