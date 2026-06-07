# WEEK 14 — AWS CORE SERVICES IV: S3, CLOUDFRONT & ROUTE 53

**Focus:** Deep dive into Amazon S3, CloudFront CDN, Route 53 DNS, lifecycle policies, replication, website hosting, HTTPS, routing policies, automation, and production-grade static website deployment.

---

# 📌 Week Overview

Week 14 focused on mastering three of the most important AWS services used in nearly every production environment:

- Amazon S3
- Amazon CloudFront
- Amazon Route 53

The goal was to understand storage, content delivery, DNS management, website hosting, security, automation, and traffic routing.

---

# 🧠 Amazon S3

## What is Amazon S3?

Amazon S3 (Simple Storage Service) is AWS's object storage service.

Purpose:

```text
Store Objects
```

Examples:

```text
Images
Videos
Backups
Logs
Website Files
```

### Characteristics

- Highly Durable
- Highly Available
- Infinitely Scalable
- Serverless
- Global Service

Durability:

```text
99.999999999%
(11 Nines)
```

---

# 📦 S3 Storage Classes

## S3 Standard

- Frequent Access
- Millisecond Retrieval
- Multi-AZ Storage

Use Cases:

- Websites
- Applications
- Frequently Accessed Data

---

## S3 Intelligent-Tiering

Automatically moves objects between tiers based on usage.

Use Case:

```text
Unknown Access Patterns
```

---

## S3 Standard-IA

IA = Infrequent Access

Characteristics:

- Lower Cost
- Retrieval Fee
- Millisecond Access

Minimum Storage Duration:

```text
30 Days
```

---

## S3 One Zone-IA

Characteristics:

- Single Availability Zone
- Lower Cost

Use Cases:

- Secondary Backups
- Re-creatable Data

---

## Glacier Instant Retrieval

Characteristics:

- Archive Pricing
- Millisecond Retrieval

---

## Glacier Flexible Retrieval

Characteristics:

```text
Minutes to 12 Hours Retrieval
```

Use Cases:

- Backup Archives

---

## Glacier Deep Archive

Characteristics:

```text
Up to 48 Hours Retrieval
```

Use Cases:

- Compliance Archives
- Long-Term Retention

---

# ⏱️ Retrieval Times

| Storage Class | Retrieval Time |
|--------------|---------------|
| Standard | Milliseconds |
| Standard-IA | Milliseconds |
| One Zone-IA | Milliseconds |
| Glacier Instant | Milliseconds |
| Glacier Flexible | Minutes–12 Hours |
| Glacier Deep Archive | Up to 48 Hours |

---

# 💰 S3 Pricing Factors

Pricing includes:

- Storage Cost
- PUT Requests
- COPY Requests
- POST Requests
- LIST Requests
- GET Requests
- Retrieval Fees
- Data Transfer Out

---

# 🔄 S3 Versioning

Purpose:

```text
Protect Against Accidental Deletion
Protect Against Accidental Overwrites
```

Example:

```text
file.txt (v1)
      ↓
Upload Again
      ↓
file.txt (v2)
```

Both versions remain.

---

## Delete Marker

Deleting an object creates:

```text
Delete Marker
```

The object is not actually removed.

---

## Restore Deleted Object

Delete the delete marker.

Result:

```text
Object Reappears
```

---

# 📜 Lifecycle Policies

Purpose:

Automatically move data between storage classes.

Example:

```text
Day 0
 ↓
S3 Standard

Day 30
 ↓
Standard-IA

Day 90
 ↓
Glacier Flexible Retrieval

Day 365
 ↓
Delete
```

Benefits:

- Cost Optimization
- Automated Storage Management

---

# 🌎 Replication

## Cross-Region Replication (CRR)

Example:

```text
us-east-1
      ↓
eu-west-1
```

Requirements:

- Versioning Enabled
- Both Buckets Versioned

Use Cases:

- Disaster Recovery

---

## Same-Region Replication (SRR)

Example:

```text
us-east-1
      ↓
us-east-1
```

Use Cases:

- Log Aggregation
- Compliance Copies

---

# 🔐 S3 Security

## Bucket Policies

Resource-Based Permissions

Attached To:

```text
Bucket
```

---

## IAM Policies

Identity-Based Permissions

Attached To:

```text
Users
Groups
Roles
```

---

## ACLs

Legacy Permission System

Best Practice:

```text
Use Bucket Policies
```

---

## Block Public Access

Purpose:

```text
Prevent Accidental Public Buckets
```

---

## Pre-Signed URLs

Purpose:

```text
Temporary Access To Private Objects
```

Example:

```bash
aws s3 presign s3://bucket/file.txt --expires-in 3600
```

---

## Object Lock (WORM)

WORM:

```text
Write Once Read Many
```

### Governance Mode

Admins Can Override

### Compliance Mode

Nobody Can Override

Use Cases:

- Financial Records
- Medical Records
- Compliance Data

---

## S3 Select

Query CSV and JSON files directly in S3 without downloading them.

Benefits:

- Faster Queries
- Lower Costs

---

# 🌍 Amazon CloudFront

## What is CloudFront?

AWS Content Delivery Network (CDN).

Purpose:

```text
Deliver Content Globally
```

---

## Architecture

```text
User
 ↓
Edge Location
 ↓
Origin
```

Origins:

- S3
- EC2
- ALB
- Custom Servers

---

## Edge Locations

Global AWS Caching Servers.

Purpose:

```text
Reduce Latency
```

---

## Cache Hit

```text
Content Already Cached
```

Fast Response.

---

## Cache Miss

```text
Fetch From Origin
```

Then Cache Locally.

---

# 🔒 Origin Access Control (OAC)

Purpose:

```text
Allow Only CloudFront To Access S3
```

Flow:

```text
User
 ↓
CloudFront
 ↓
S3
```

Benefits:

- Improved Security
- No Direct Bucket Access

---

# ⚙️ Cache Behaviors

## TTL Settings

### Minimum TTL

Minimum Cache Time

### Default TTL

Standard Cache Time

### Maximum TTL

Maximum Cache Time

---

## Cache-Control Headers

Can Override CloudFront TTL Settings.

---

# 🔐 HTTPS & ACM

## AWS Certificate Manager

Provides:

```text
Free SSL Certificates
```

Requirement:

```text
CloudFront Certificates Must Be In us-east-1
```

---

## Viewer Protocol Policy

Recommended:

```text
Redirect HTTP To HTTPS
```

Benefits:

- Encryption
- Browser Trust
- Security

---

# 🔄 CloudFront Invalidations

Purpose:

```text
Remove Cached Content
```

Command:

```bash
aws cloudfront create-invalidation \
--distribution-id ID \
--paths "/*"
```

Free Tier:

```text
1000 Paths / Month
```

---

# ⚡ CloudFront Functions vs Lambda@Edge

## CloudFront Functions

Characteristics:

- JavaScript
- Under 1ms
- Low Cost

Events:

- Viewer Request
- Viewer Response

---

## Lambda@Edge

Characteristics:

- Node.js / Python
- Up To 5 Seconds
- More Powerful

Events:

- Viewer Request
- Viewer Response
- Origin Request
- Origin Response

---

# 🛡️ AWS WAF

Purpose:

Protect Web Applications.

Protects Against:

- SQL Injection
- XSS
- Bots
- OWASP Top 10 Threats

Managed Rule Example:

```text
AWSManagedRulesCommonRuleSet
```

---

# 🌐 Amazon Route 53

## What is Route 53?

AWS DNS Service.

Purpose:

```text
Domain Name Resolution
```

---

## Components

- Hosted Zones
- DNS Records
- Health Checks
- Routing Policies

---

# DNS Records

## A Record

```text
Domain → IP Address
```

## CNAME

```text
Domain → Domain
```

## MX

Mail Servers

## TXT

Verification Records

---

# 🎯 Route 53 Routing Policies

## Simple Routing

Default Routing

---

## Weighted Routing

Example:

```text
90% → us-east-1
10% → eu-west-1
```

Use Cases:

- A/B Testing
- Blue/Green Deployments

---

## Latency Routing

Routes To Lowest Latency Region.

---

## Failover Routing

Primary:

```text
EC2
```

Backup:

```text
S3 Static Website
```

---

## Geolocation Routing

Routes Based On:

- Country
- Continent

---

## Geoproximity Routing

Routes By Distance.

Supports Traffic Bias.

---

## Multivalue Answer Routing

Returns Multiple Healthy Endpoints.

---

# ❤️ Route 53 Health Checks

Purpose:

Monitor Endpoint Health.

Supported:

- HTTP
- HTTPS
- TCP

Example:

```text
Primary Fails
      ↓
Route 53
      ↓
Backup Endpoint
```

---

# 🚀 WEEK 14 PROJECT — AWS STATIC WEBSITE PLATFORM

## Project Goal

Build a complete production-grade static website hosting platform using:

- Amazon S3
- CloudFront
- ACM
- Route 53
- Lifecycle Policies
- boto3 Automation
- GitHub Actions

---

# 🏗️ Architecture

```text
User
 │
 ▼
Route 53
 │
 ▼
CloudFront CDN
 │
 ▼
S3 Website Bucket
```

---

# 🔄 Deployment Pipeline

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ▼
S3 Sync
    │
    ▼
CloudFront Invalidation
    │
    ▼
Global Deployment
```

---

# 🐍 boto3 Scripts

## create_s3_static_site.py

Automates:

- Bucket Creation
- Website Hosting
- Policy Configuration
- File Uploads

---

## invalidate_cloudfront.py

Automates:

- CloudFront Cache Invalidations

---

# 📜 Lifecycle Policy

Logging Bucket Rules:

```text
30 Days
      ↓
Glacier Flexible Retrieval

365 Days
      ↓
Delete
```

---

# ⚙️ GitHub Actions Workflow

```yaml
Push To Main
      ↓
GitHub Actions
      ↓
AWS Authentication
      ↓
S3 Sync
      ↓
CloudFront Invalidation
```

---

# 📚 Week 14 Key Takeaways

- S3 provides scalable object storage.
- Storage classes optimize costs.
- Versioning protects data.
- Lifecycle policies automate storage management.
- CloudFront improves performance globally.
- OAC secures S3 origins.
- ACM enables HTTPS.
- WAF protects applications.
- Route 53 manages DNS and traffic routing.
- Health checks enable automatic failover.
- GitHub Actions automates deployments.
- boto3 enables AWS automation.

---

# 🏆 Week 14 Outcome

Successfully learned and implemented:

✅ S3 Storage Classes

✅ Versioning

✅ Lifecycle Policies

✅ Replication

✅ S3 Security

✅ CloudFront CDN

✅ HTTPS with ACM

✅ CloudFront Functions

✅ AWS WAF

✅ Route 53 DNS

✅ Routing Policies

✅ Health Checks

✅ Static Website Hosting

✅ GitHub Actions CI/CD

✅ boto3 Automation

✅ Production-Grade AWS Architecture

Week 14 established the foundation for designing secure, scalable, globally distributed AWS web architectures using S3, CloudFront, and Route 53.