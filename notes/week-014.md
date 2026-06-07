# WEEK 14 NOTES — AWS CORE SERVICES IV: S3, CLOUDFRONT & ROUTE 53

## 📌 Week Overview

Week 14 focused on mastering Amazon S3, Amazon CloudFront, and Amazon Route 53 — three of the most important AWS services used in nearly every AWS architecture.

This week covered:

- S3 Storage Classes
- Storage Pricing
- Retrieval Times
- S3 Versioning
- Delete Markers
- Lifecycle Policies
- Cross-Region Replication (CRR)
- Same-Region Replication (SRR)
- Bucket Policies
- ACLs
- IAM Policies
- Block Public Access
- Pre-Signed URLs
- Object Lock
- WORM Protection
- S3 Select
- CloudFront Architecture
- Edge Locations
- Origin Access Control (OAC)
- Cache Behaviors
- TTL Settings
- HTTPS & SSL/TLS
- CloudFront Functions
- Lambda@Edge
- AWS WAF
- Route 53 Hosted Zones
- DNS Records
- Health Checks
- Routing Policies
- Production Static Website Hosting

The goal of this week was to understand storage, content delivery, DNS management, website hosting, security, and traffic routing in AWS production environments.

---

# 🧠 Amazon S3 Fundamentals

---

# 1️⃣ Amazon S3 (Simple Storage Service)

---

## What is Amazon S3?

Amazon S3 is AWS's object storage service.

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

---

## S3 Characteristics

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

## S3 Structure

```text
Bucket
   ↓
Objects
```

Example:

```text
my-bucket
   ├── image.jpg
   ├── video.mp4
   └── index.html
```

---

# 2️⃣ S3 Storage Classes

---

## S3 Standard

Purpose:

```text
Frequent Access
```

Characteristics:

- Millisecond retrieval
- Multi-AZ storage
- Highest availability

Use Cases:

- Websites
- Mobile apps
- Frequently accessed data

---

## S3 Intelligent-Tiering

Purpose:

```text
Automatic Cost Optimization
```

Characteristics:

- Moves objects automatically
- Based on access patterns

Use Cases:

- Unknown access patterns

---

## S3 Standard-IA

IA = Infrequent Access

Characteristics:

- Millisecond retrieval
- Lower storage cost
- Retrieval charges apply

Minimum Storage Duration:

```text
30 Days
```

---

## S3 One Zone-IA

Characteristics:

- Stored in one AZ
- Cheaper than Standard-IA

Use Cases:

- Secondary backups
- Re-creatable data

---

## Glacier Instant Retrieval

Characteristics:

- Millisecond retrieval
- Archive pricing

Use Cases:

- Rarely accessed archives

---

## Glacier Flexible Retrieval

Characteristics:

- Retrieval:
  - Minutes
  - Hours

Use Cases:

- Backup archives

---

## Glacier Deep Archive

Characteristics:

- Cheapest storage
- Retrieval up to 48 hours

Use Cases:

- Long-term retention
- Compliance archives

---

# 3️⃣ Retrieval Times

---

## Storage Class Comparison

```text
Standard
        ↓
Milliseconds

Standard-IA
        ↓
Milliseconds

One Zone-IA
        ↓
Milliseconds

Glacier Instant
        ↓
Milliseconds

Glacier Flexible
        ↓
Minutes to 12 Hours

Glacier Deep Archive
        ↓
Up to 48 Hours
```

---

# 4️⃣ S3 Pricing Components

---

## Storage Cost

```text
Per GB / Month
```

---

## Request Cost

Examples:

```text
PUT
COPY
POST
LIST
GET
```

---

## Retrieval Cost

Applies to:

```text
Standard-IA
Glacier Classes
```

---

## Data Transfer Cost

Charged when:

```text
Data Leaves AWS
```

---

# 5️⃣ S3 Versioning

---

## Purpose

Protect against:

```text
Accidental Deletion
Accidental Overwrites
```

---

## Versioning Flow

```text
File v1
      ↓
Upload Again
      ↓
File v2
```

Both versions remain.

---

## Delete Marker

When deleting:

```text
Object Not Deleted
```

Instead:

```text
Delete Marker Created
```

---

## Restore Deleted Object

Delete:

```text
Delete Marker
```

Result:

```text
Object Reappears
```

---

# 6️⃣ Lifecycle Policies

---

## Purpose

Automatically move data between storage classes.

---

## Example Lifecycle

```text
Day 0
 ↓
S3 Standard

Day 30
 ↓
Standard-IA

Day 90
 ↓
Glacier Flexible

Day 365
 ↓
Delete
```

---

## Benefits

- Cost optimization
- Automated management

---

# 7️⃣ Replication

---

## Cross Region Replication (CRR)

```text
us-east-1
      ↓
eu-west-1
```

Characteristics:

- Different regions
- Disaster recovery

Requirements:

```text
Versioning Enabled
```

On both buckets.

---

## Same Region Replication (SRR)

```text
us-east-1
      ↓
us-east-1
```

Use Cases:

- Log aggregation
- Compliance copies

---

# 8️⃣ S3 Security

---

## Bucket Policies

Resource-based permissions.

Attached to:

```text
Bucket
```

---

## IAM Policies

Identity-based permissions.

Attached to:

```text
Users
Groups
Roles
```

---

## ACLs

Legacy permission model.

Modern Best Practice:

```text
Use Bucket Policies
```

---

## Block Public Access

Account-wide protection.

Purpose:

```text
Prevent Public Buckets
```

---

## Pre-Signed URLs

Purpose:

```text
Temporary Access
```

To private objects.

Example:

```bash
aws s3 presign s3://bucket/file.txt --expires-in 3600
```

---

# 9️⃣ Object Lock & WORM

---

## WORM

Write Once Read Many

Purpose:

```text
Prevent Modification
```

---

## Governance Mode

Admins can override.

---

## Compliance Mode

Nobody can override.

Used for:

- Financial records
- Medical records
- Compliance data

---

# 🔟 S3 Select

---

## Purpose

Query objects directly in S3.

Without downloading.

Supports:

```text
CSV
JSON
```

Benefits:

- Faster queries
- Lower costs

---

# 1️⃣1️⃣ CloudFront Fundamentals

---

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

```text
S3
EC2
ALB
Custom Servers
```

---

## Edge Locations

Global caching servers.

Purpose:

```text
Reduce Latency
```

---

## Cache Hit

```text
Content Already Cached
```

Fast response.

---

## Cache Miss

```text
Fetch From Origin
```

Then cache locally.

---

# 1️⃣2️⃣ Origin Access Control (OAC)

---

## Purpose

Prevent direct S3 access.

Flow:

```text
User
 ↓
CloudFront
 ↓
S3
```

Only CloudFront can access S3.

---

## Benefit

Improved security.

---

# 1️⃣3️⃣ Cache Behaviors

---

## TTL Settings

### Minimum TTL

Minimum cache duration.

### Default TTL

Standard cache duration.

### Maximum TTL

Maximum cache duration.

---

## Cache-Control Header

Can override CloudFront settings.

---

# 1️⃣4️⃣ HTTPS & ACM

---

## AWS Certificate Manager

Provides:

```text
Free SSL Certificates
```

---

## Requirement

CloudFront certificates must be in:

```text
us-east-1
```

---

## Viewer Protocol Policy

Recommended:

```text
Redirect HTTP to HTTPS
```

---

# 1️⃣5️⃣ CloudFront Invalidations

---

## Purpose

Remove old cached content.

Command:

```bash
aws cloudfront create-invalidation \
--distribution-id ID \
--paths "/*"
```

---

## Free Tier

```text
1000 Paths / Month
```

---

# 1️⃣6️⃣ CloudFront Functions vs Lambda@Edge

---

## CloudFront Functions

Characteristics:

- JavaScript
- Under 1 ms
- Low cost

Events:

```text
Viewer Request
Viewer Response
```

---

## Lambda@Edge

Characteristics:

- Node.js / Python
- Up to 5 seconds
- More powerful

Events:

```text
Viewer Request
Viewer Response
Origin Request
Origin Response
```

---

# 1️⃣7️⃣ AWS WAF

---

## Purpose

Protect web applications.

---

## Common Protection

OWASP Top 10:

- SQL Injection
- XSS
- Bad Bots

---

## Managed Rules

Example:

```text
AWSManagedRulesCommonRuleSet
```

---

# 1️⃣8️⃣ Route 53 Fundamentals

---

## What is Route 53?

AWS DNS Service.

Purpose:

```text
Domain Name Resolution
```

---

## Components

- Hosted Zones
- Records
- Health Checks
- Routing Policies

---

# 1️⃣9️⃣ DNS Records

---

## A Record

Maps:

```text
Domain → IP
```

---

## CNAME

Maps:

```text
Domain → Domain
```

---

## MX Record

Mail servers.

---

## TXT Record

Verification records.

---

# 2️⃣0️⃣ Route 53 Routing Policies

---

## Simple Routing

Default routing.

---

## Weighted Routing

Traffic split.

Example:

```text
90% → us-east-1
10% → eu-west-1
```

---

## Latency Routing

Routes to lowest latency region.

---

## Failover Routing

Primary:

```text
EC2
```

Backup:

```text
S3 Website
```

---

## Geolocation Routing

Based on:

```text
Country
Continent
```

---

## Geoproximity Routing

Routes by distance.

Supports bias adjustments.

---

## Multivalue Answer Routing

Returns multiple healthy records.

---

# 2️⃣1️⃣ Route 53 Health Checks

---

## Purpose

Monitor endpoint health.

Checks:

```text
HTTP
HTTPS
TCP
```

---

## Failover Example

```text
Primary Fails
      ↓
Route 53
      ↓
Backup Endpoint
```

---

# 2️⃣2️⃣ Production Static Website Architecture

---

## Architecture

```text
User
 │
 ▼
Route 53
 │
 ▼
CloudFront
 │
 ▼
S3
```

---

## HTTPS Flow

```text
ACM
 ↓
CloudFront
 ↓
HTTPS
```

---

## Deployment Flow

```text
GitHub
    ↓
GitHub Actions
    ↓
S3 Sync
    ↓
CloudFront Invalidation
```

---

# 🔥 Most Important Week 14 Concepts

---

## S3 Storage Classes Optimize Cost

Choose storage class based on access frequency.

---

## Versioning Protects Data

Delete markers allow recovery.

---

## Lifecycle Policies Save Money

Automatically transition and delete data.

---

## CloudFront Improves Performance

Content served from edge locations.

---

## OAC Secures S3 Origins

Prevent direct public bucket access.

---

## ACM Enables HTTPS

Free SSL certificates for CloudFront.

---

## Route 53 Controls Traffic

Advanced routing improves availability.

---

## Health Checks Enable Failover

Automatic disaster recovery.

---

# 🚀 Week 14 Outcome

By the end of Week 14, built understanding of:

- S3 Storage Classes
- Versioning
- Lifecycle Policies
- Replication
- S3 Security
- CloudFront CDN
- OAC
- HTTPS
- WAF
- Cache Invalidations
- Route 53 DNS
- Routing Policies
- Health Checks
- Production Static Website Hosting

---

# 📚 Week 14 Summary

Week 14 established the storage, content delivery, and DNS foundation required for modern cloud architectures.

This week transformed knowledge from:

- Uploading files into S3

Into:

- Designing secure, scalable, globally distributed web architectures using S3, CloudFront, Route 53, HTTPS, caching, lifecycle management, and intelligent traffic routing.