# WEEK 14 RECAP — AWS CORE SERVICES IV: S3, CLOUDFRONT & ROUTE 53

**Week:** 14  
**Duration:** 7 Days  
**Focus:** Amazon S3, CloudFront CDN, Route 53 DNS, Static Website Hosting, HTTPS, Lifecycle Policies, Replication, Routing Policies & AWS Automation

---

# 🎯 Week Goal

The objective of Week 14 was to master AWS storage, content delivery, and DNS services by learning Amazon S3, CloudFront, and Route 53 in depth.

The week focused on understanding how modern applications store data, deliver content globally, secure communications with HTTPS, and intelligently route users across regions.

---

# 📦 Amazon S3

This week began with a deep dive into Amazon S3, AWS's highly scalable object storage service.

Topics Covered:

- S3 Standard
- S3 Intelligent-Tiering
- S3 Standard-IA
- S3 One Zone-IA
- Glacier Instant Retrieval
- Glacier Flexible Retrieval
- Glacier Deep Archive
- Storage Pricing
- Retrieval Times
- Storage Class Analysis

Key Learnings:

- Different storage classes are optimized for different access patterns.
- Glacier storage classes provide cost-effective archival storage.
- Storage Class Analysis helps optimize storage costs automatically.
- S3 provides 99.999999999% durability.

---

# 🔄 Versioning, Lifecycle Policies & Replication

Learned how S3 protects and manages data throughout its lifecycle.

Topics Covered:

- Versioning
- Delete Markers
- Object Recovery
- Lifecycle Rules
- Cross-Region Replication (CRR)
- Same-Region Replication (SRR)

Key Learnings:

- Versioning protects against accidental deletions and overwrites.
- Delete markers allow object recovery.
- Lifecycle policies automate transitions between storage classes.
- Replication improves availability and disaster recovery capabilities.

Example Lifecycle Flow:

```text
S3 Standard
      ↓
Standard-IA
      ↓
Glacier Flexible Retrieval
      ↓
Delete
```

---

# 🔐 S3 Security & Advanced Features

Studied multiple layers of S3 security and compliance features.

Topics Covered:

- Bucket Policies
- IAM Policies
- ACLs
- Block Public Access
- Pre-Signed URLs
- Object Lock
- WORM Protection
- S3 Select

Key Learnings:

- Bucket policies are resource-based permissions.
- IAM policies are identity-based permissions.
- Block Public Access prevents accidental public exposure.
- Pre-Signed URLs allow temporary access to private objects.
- Object Lock enables regulatory compliance and data retention.

---

# 🌍 Amazon CloudFront

Learned how CloudFront accelerates content delivery globally.

Topics Covered:

- Distributions
- Origins
- Edge Locations
- Regional Edge Caches
- Cache Behaviors
- Cache Hits
- Cache Misses
- Origin Access Control (OAC)

Key Learnings:

- CloudFront caches content closer to users.
- Edge locations reduce latency worldwide.
- OAC prevents direct access to S3 origins.
- CloudFront significantly improves website performance.

Architecture:

```text
User
 ↓
CloudFront Edge Location
 ↓
Origin (S3)
```

---

# 🔒 HTTPS, CloudFront Functions & AWS WAF

Focused on securing applications delivered through CloudFront.

Topics Covered:

- AWS Certificate Manager (ACM)
- HTTPS Configuration
- Viewer Protocol Policies
- CloudFront Functions
- Lambda@Edge
- AWS WAF
- Managed Rule Groups

Key Learnings:

- ACM provides free SSL/TLS certificates.
- CloudFront certificates must be created in us-east-1.
- HTTPS improves security and browser trust.
- CloudFront Functions provide lightweight edge processing.
- AWS WAF protects against common web attacks.

Example Security Flow:

```text
User
 ↓
HTTPS
 ↓
CloudFront
 ↓
AWS WAF
 ↓
Origin
```

---

# 🌐 Amazon Route 53

Learned how AWS manages DNS and traffic routing.

Topics Covered:

- Hosted Zones
- Public Hosted Zones
- Private Hosted Zones
- DNS Records
- Health Checks
- Traffic Policies

DNS Records:

- A Records
- CNAME Records
- MX Records
- TXT Records

Key Learnings:

- Route 53 provides highly available DNS services.
- Health checks monitor endpoint availability.
- Traffic policies control user routing behavior.

---

# 🎯 Route 53 Routing Policies

Studied all major routing policies available in Route 53.

### Simple Routing

Default routing behavior.

### Weighted Routing

Example:

```text
90% → us-east-1
10% → eu-west-1
```

Used for:

- A/B Testing
- Blue/Green Deployments

### Latency-Based Routing

Routes users to the lowest latency region.

### Failover Routing

Provides active-passive disaster recovery.

### Geolocation Routing

Routes users based on geographic location.

### Geoproximity Routing

Routes users based on distance and bias.

### Multivalue Answer Routing

Returns multiple healthy endpoints.

Key Learning:

Route 53 enables intelligent traffic routing for performance and availability.

---

# 🚀 Week 14 Project

Built a complete production-grade static website hosting platform.

Services Used:

- Amazon S3
- Amazon CloudFront
- AWS Certificate Manager
- Amazon Route 53
- GitHub Actions
- boto3

Architecture:

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
S3 Bucket
```

Features Implemented:

- Static Website Hosting
- HTTPS Encryption
- CloudFront CDN
- Route 53 DNS
- Lifecycle Policies
- Automated Deployments
- Cache Invalidations
- boto3 Automation Scripts

---

# ⚙️ GitHub Actions CI/CD

Implemented automated deployments.

Workflow:

```text
Git Push
    ↓
GitHub Actions
    ↓
S3 Sync
    ↓
CloudFront Invalidation
    ↓
Website Updated
```

Benefits:

- Faster deployments
- Reduced manual work
- Consistent release process

---

# 🐍 boto3 Automation

Created automation scripts for AWS resources.

Scripts:

### create_s3_static_site.py

Automates:

- Bucket creation
- Static hosting setup
- Policy configuration
- File uploads

### invalidate_cloudfront.py

Automates:

- CloudFront cache invalidations

Key Learning:

boto3 allows AWS infrastructure to be managed programmatically.

---

# 🧠 Most Important Concepts Learned

## Amazon S3

- Storage Classes
- Versioning
- Lifecycle Policies
- Replication
- Security

## CloudFront

- CDN Architecture
- Edge Locations
- OAC
- HTTPS
- Invalidations
- WAF

## Route 53

- DNS Management
- Hosted Zones
- Routing Policies
- Health Checks

## Automation

- GitHub Actions
- boto3
- CI/CD Workflows

---

# 📈 Skills Gained

### Storage

- Object Storage Management
- Cost Optimization
- Data Lifecycle Management

### Networking

- DNS Configuration
- Traffic Routing
- Global Content Delivery

### Security

- HTTPS
- SSL/TLS
- WAF
- Access Control

### DevOps

- CI/CD Pipelines
- Deployment Automation
- Infrastructure Automation

---

# 🏆 Week 14 Outcome

Successfully mastered AWS storage, content delivery, and DNS services by implementing real-world architectures using Amazon S3, CloudFront, and Route 53.

Built a complete production-grade static website platform while learning:

✅ S3 Storage Classes

✅ Versioning

✅ Lifecycle Policies

✅ Replication

✅ S3 Security

✅ CloudFront CDN

✅ OAC

✅ HTTPS with ACM

✅ CloudFront Functions

✅ AWS WAF

✅ Route 53 DNS

✅ Routing Policies

✅ Health Checks

✅ GitHub Actions CI/CD

✅ boto3 Automation

✅ Production Static Website Hosting

---

# 🚀 Week 14 Summary

Week 14 established the foundation for designing and operating secure, scalable, highly available, and globally distributed AWS architectures.

The combination of Amazon S3, CloudFront, and Route 53 forms one of the most common production patterns used for modern websites and cloud-native applications, making this one of the most important weeks in the AWS learning journey.