# 🚀 Automated Cloud Internship Cold Outreach Campaign (Chennai)

This directory houses the end-to-end multi-agent outreach system designed to secure a **Cloud Engineering / DevOps / Cloud Architecture Internship** across premier cloud consultancies, SaaS firms, and tech startups located in Chennai.

---

## 🎯 Candidate Profile & Pitch Positioning

* **Target Roles (Strictly Cloud):** 
  * Cloud Engineering Intern
  * Cloud & DevOps Intern
  * Cloud Architecture Intern
  * Cloud & AI Infrastructure Intern
* **Core Differentiator:** 
  * **Smart India Hackathon (SIH) "Block Train" Project:** Served as the dedicated Cloud Architect responsible for end-to-end AWS infrastructure deployment (VPC networking, serverless Lambda compute, API Gateway, resilient storage, and IAM security under hackathon timeframes).
  * **1000-Day AI Cloud Infrastructure Journey:** Publicly executing an unbroken daily commitment (Day 119+) documenting hands-on infrastructure code on GitHub.
  * **AWS Depth & Certifications:** AWS Certified Cloud Practitioner + deep Amazon S3 certifications (Cost Optimization, Disaster Recovery, Storage Classes).
  * **Featured Projects:** CloudTrain Studio (Serverless MLOps Platform) and Cloud-Morph (Serverless Event-Driven File Processing).
* **Flexibility on Compensation:** Unpaid is fine; stipend is welcome. Foremost priority is hands-on production cloud experience and learning from senior cloud teams.

---

## 🏢 Target Companies Database (`leads.json`)

| # | Company | Focus / Specialization | Location in Chennai | Verified Contact Email |
|---|---|---|---|---|
| 1 | **1CloudHub** | AWS Advanced Tier Services Partner (Cloud Migration & DevOps) | Guindy, Chennai | `recruitment@1cloudhub.com` |
| 2 | **Agilisium Consulting** | AWS Advanced Tier Partner (Cloud, Big Data & Generative AI) | Perungudi (OMR, WTC), Chennai | `talent@agilisium.com` |
| 3 | **Vembu Technologies** | Enterprise Cloud Backup, Hybrid Storage & Disaster Recovery | Chennai One IT SEZ, Thoraipakkam | `careers@vembu.com` |
| 4 | **Spritle Software** | Cloud Microservices, IoT & AI Applications | Chennai | `jobs@spritle.com` |
| 5 | **Skcript Technologies** | Boutique Cloud Engineering, Systems Automation & Architecture | Anna Nagar, Chennai | `hr@skcript.com` |
| 6 | **SecureKloud Technologies** | Enterprise Cloud Transformation, Cloud Security & Compliance | T. Nagar, Chennai | `info@securekloud.com` |
| 7 | **Ideas2IT Technologies** | High-End Product Engineering & Distributed Architectures | Guindy, Chennai | `contact@ideas2it.com` |
| 8 | **Crayon Data** | Big Data Platforms, AI Decision Engines & Cloud Workloads | Perungudi (OMR), Chennai | `hello@crayondata.ai` |

---

## ⚙️ How the Dispatch Engine Works (`send_emails.py`)

The automated dispatch script uses **Python `smtplib` via Gmail SSL (Port 465)** to send personalized pitches directly from `lkevinjosh10@gmail.com` with `certs/Kevin_Joshua_Resume.pdf` automatically attached.

### 🛡️ Deliverability & Anti-Spam Protection
- **45-second cool-down:** A built-in delay between emails ensures your Gmail account remains in good standing and doesn't trigger spam filters.
- **State persistence:** Updates `campaign.json` after every delivery with timestamp and status to avoid duplicate sends.
- **Test Mode:** Allows sending a test preview to yourself before firing live outreach.

---

## 💻 Commands

### 1. View Campaign Status
```bash
python .\internship\send_emails.py --status
```

### 2. Send Test Email to Yourself
```bash
python .\internship\send_emails.py --test
```

### 3. Send to a Specific Company (Single Target)
```bash
python .\internship\send_emails.py --send-one 1cloudhub
# or
python .\internship\send_emails.py --send-one vembu
```

### 4. Dispatch All Pending Emails (With 45s Delay)
```bash
python .\internship\send_emails.py --send-all
```
