# WEEK 14 ROADMAP — AWS CORE SERVICES IV: S3, CLOUDFRONT & ROUTE 53

## 📌 Week Overview

Week 14 focuses on mastering Amazon S3, Amazon CloudFront, and Amazon Route 53 — three of the most important AWS services used in cloud architecture, web hosting, content delivery, disaster recovery, and DNS management.

This week builds the foundation for designing globally distributed, highly available, secure, and cost-optimized cloud solutions.

---

# 🎯 Week Objectives

By the end of Week 14, you should be able to:

- Understand all Amazon S3 storage classes
- Optimize storage costs using lifecycle policies
- Implement versioning and object recovery
- Configure replication strategies
- Secure S3 buckets using AWS best practices
- Build and configure CloudFront distributions
- Implement HTTPS using ACM
- Configure AWS WAF protection
- Manage DNS using Route 53
- Understand all Route 53 routing policies
- Configure health checks and failover routing
- Build a complete production-grade static website architecture
- Automate deployments using GitHub Actions and boto3

---

# 📅 Day 92 — S3 Storage Classes & Pricing

## Learning Goals

- Learn all S3 storage classes
- Understand retrieval times
- Understand pricing models
- Practice storage class selection
- Explore Storage Class Analysis

### Topics

- S3 Standard
- Intelligent-Tiering
- Standard-IA
- One Zone-IA
- Glacier Instant Retrieval
- Glacier Flexible Retrieval
- Glacier Deep Archive

### Hands-On

- Create an S3 bucket
- Upload files using different storage classes
- Compare retrieval options
- Enable Storage Class Analysis

### Outcome

Understand how AWS optimizes storage costs using different storage tiers.

---

# 📅 Day 93 — S3 Versioning, Lifecycle & Replication

## Learning Goals

- Protect data using versioning
- Configure lifecycle policies
- Understand replication strategies

### Topics

- Versioning
- Delete Markers
- Object Recovery
- Lifecycle Rules
- Cross-Region Replication (CRR)
- Same-Region Replication (SRR)

### Hands-On

- Enable Versioning
- Upload multiple object versions
- Restore deleted objects
- Create lifecycle transitions
- Configure replication

### Outcome

Understand data protection, retention, and disaster recovery strategies in S3.

---

# 📅 Day 94 — S3 Security & Advanced Features

## Learning Goals

- Secure S3 resources
- Understand advanced storage features
- Learn compliance capabilities

### Topics

- Bucket Policies
- IAM Policies
- ACLs
- Block Public Access
- Pre-Signed URLs
- Object Lock
- WORM
- S3 Select

### Hands-On

- Configure bucket policies
- Enable Block Public Access
- Generate pre-signed URLs
- Query data using S3 Select

### Outcome

Learn how AWS secures object storage at scale.

---

# 📅 Day 95 — CloudFront CDN Setup & Configuration

## Learning Goals

- Understand CDN architecture
- Configure CloudFront distributions
- Secure S3 origins

### Topics

- Distributions
- Edge Locations
- Regional Edge Caches
- Origin Access Control (OAC)
- Cache Behaviors
- TTL Settings
- Custom Error Pages

### Hands-On

- Create CloudFront Distribution
- Connect S3 Origin
- Configure OAC
- Configure Cache Settings
- Test Edge Caching

### Outcome

Understand how content is delivered globally with low latency.

---

# 📅 Day 96 — CloudFront HTTPS, WAF & Invalidations

## Learning Goals

- Secure websites with HTTPS
- Protect applications using WAF
- Manage cache invalidations

### Topics

- AWS Certificate Manager (ACM)
- SSL/TLS Certificates
- HTTPS Redirection
- CloudFront Invalidations
- CloudFront Functions
- Lambda@Edge
- AWS WAF

### Hands-On

- Request ACM Certificate
- Configure HTTPS
- Create Invalidation Requests
- Configure WAF Rules
- Compare CloudFront Functions vs Lambda@Edge

### Outcome

Understand performance and security best practices for content delivery.

---

# 📅 Day 97 — Route 53 DNS & Routing Policies

## Learning Goals

- Learn DNS fundamentals
- Configure Route 53 records
- Understand routing policies

### Topics

- Hosted Zones
- A Records
- CNAME Records
- MX Records
- TXT Records
- Health Checks

### Routing Policies

- Simple Routing
- Weighted Routing
- Latency Routing
- Failover Routing
- Geolocation Routing
- Geoproximity Routing
- Multivalue Answer Routing

### Hands-On

- Create Hosted Zone
- Configure DNS Records
- Create Health Checks
- Test Weighted Routing
- Configure Failover Routing

### Outcome

Understand how AWS manages traffic routing and high availability.

---

# 📅 Day 98 — Week 14 Review Project

## Project Title

### AWS Static Website Platform

Build a complete production-grade static website architecture using AWS core services.

### Architecture

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
S3 Static Website Bucket
```

### Project Components

#### Storage Layer

- S3 Static Website Hosting
- S3 Access Logs
- Lifecycle Policies

#### CDN Layer

- CloudFront Distribution
- Edge Caching
- HTTPS
- Cache Invalidations

#### Security Layer

- ACM SSL Certificate
- HTTPS Enforcement
- OAC
- AWS WAF

#### DNS Layer

- Route 53 Hosted Zone
- Domain Routing
- Health Checks

#### Automation Layer

- GitHub Actions CI/CD
- boto3 Automation Scripts

### Deliverables

- Static Website Hosted on S3
- CloudFront Distribution
- HTTPS Enabled
- Route 53 DNS Configuration
- Lifecycle Policy
- create_s3_static_site.py
- invalidate_cloudfront.py
- GitHub Actions Workflow

### Outcome

Build a real-world AWS architecture combining storage, CDN, security, DNS, automation, and deployment best practices.

---

# 📚 Recommended Resources

## AWS Documentation

### Amazon S3

```text
https://docs.aws.amazon.com/s3/
```

### Amazon CloudFront

```text
https://docs.aws.amazon.com/cloudfront/
```

### Amazon Route 53

```text
https://docs.aws.amazon.com/route53/
```

### AWS Certificate Manager

```text
https://docs.aws.amazon.com/acm/
```

### AWS WAF

```text
https://docs.aws.amazon.com/waf/
```

---

# 🧠 Skills Acquired This Week

## Storage

- S3 Storage Classes
- Lifecycle Management
- Versioning
- Replication

## Networking

- DNS
- Route 53
- Routing Policies
- Health Checks

## Content Delivery

- CloudFront
- Edge Locations
- Caching
- CDN Architecture

## Security

- HTTPS
- SSL/TLS
- OAC
- AWS WAF

## Automation

- GitHub Actions
- boto3
- Deployment Automation

---

# 🏆 Week 14 Success Criteria

By the end of Week 14, you should be able to:

✅ Explain all S3 storage classes

✅ Configure versioning and lifecycle policies

✅ Implement replication strategies

✅ Secure S3 buckets

✅ Deploy CloudFront distributions

✅ Configure HTTPS using ACM

✅ Protect applications using AWS WAF

✅ Configure Route 53 hosted zones

✅ Implement all major routing policies

✅ Create Route 53 health checks

✅ Build a complete static website architecture

✅ Automate deployments with GitHub Actions

✅ Automate AWS operations using boto3

---

# 🚀 Week 14 Final Outcome

Week 14 transforms your knowledge from basic object storage and DNS concepts into the ability to design and deploy production-grade AWS web architectures using Amazon S3, CloudFront, Route 53, ACM, WAF, GitHub Actions, and boto3 automation.

This is one of the most important weeks in the AWS learning journey because these services appear in nearly every real-world AWS deployment and AWS certification exam.