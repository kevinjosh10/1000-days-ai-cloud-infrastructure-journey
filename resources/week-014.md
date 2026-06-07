# WEEK 14 RESOURCES — AWS CORE SERVICES IV: S3, CLOUDFRONT & ROUTE 53

## 📌 Week Overview

Week 14 focused on mastering Amazon S3, Amazon CloudFront, and Amazon Route 53, three of the most heavily used AWS services in both AWS certification exams and real-world cloud architectures.

The goal was to understand:

- S3 Storage Classes
- Storage Cost Optimization
- Versioning
- Lifecycle Policies
- Replication
- S3 Security
- CloudFront CDN
- HTTPS & SSL/TLS
- AWS WAF
- Cache Behaviors
- Route 53 DNS
- Routing Policies
- Health Checks
- Static Website Hosting
- CI/CD Automation

This document contains all learning resources used during Week 14.

---

# 📚 Primary AWS Documentation

---

## 1️⃣ Amazon S3 Documentation

Purpose:

```text
Official AWS S3 Documentation
```

Topics Covered:

- Storage Classes
- Versioning
- Lifecycle Policies
- Replication
- Bucket Policies
- Object Lock
- S3 Select

Resource:

```text
https://docs.aws.amazon.com/s3/
```

Priority:

```text
★★★★★
```

---

## 2️⃣ Amazon S3 User Guide

Purpose:

```text
Deep S3 Concepts
```

Topics Covered:

- Bucket Configuration
- Storage Classes
- Lifecycle Rules
- Security Controls
- Encryption
- Replication

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/
```

Priority:

```text
★★★★★
```

---

## 3️⃣ Amazon CloudFront Documentation

Purpose:

```text
Official AWS CloudFront Documentation
```

Topics Covered:

- Distributions
- Edge Locations
- Cache Behaviors
- HTTPS
- OAC
- CloudFront Functions
- Lambda@Edge

Resource:

```text
https://docs.aws.amazon.com/cloudfront/
```

Priority:

```text
★★★★★
```

---

## 4️⃣ Amazon Route 53 Documentation

Purpose:

```text
Official AWS Route 53 Documentation
```

Topics Covered:

- Hosted Zones
- DNS Records
- Routing Policies
- Health Checks
- Domain Management

Resource:

```text
https://docs.aws.amazon.com/route53/
```

Priority:

```text
★★★★★
```

---

# 📦 Amazon S3 Resources

---

## 5️⃣ S3 Storage Classes Guide

Purpose:

```text
Understand All S3 Storage Classes
```

Topics Covered:

- S3 Standard
- Intelligent-Tiering
- Standard-IA
- One Zone-IA
- Glacier Instant Retrieval
- Glacier Flexible Retrieval
- Glacier Deep Archive

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html
```

Priority:

```text
★★★★★
```

---

## 6️⃣ S3 Lifecycle Policies Documentation

Purpose:

```text
Automated Storage Management
```

Topics Covered:

- Transition Rules
- Expiration Rules
- Glacier Transitions
- Lifecycle Automation

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html
```

Priority:

```text
★★★★★
```

---

## 7️⃣ S3 Versioning Documentation

Purpose:

```text
Data Protection
```

Topics Covered:

- Object Versions
- Delete Markers
- Recovery
- Permanent Deletion

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html
```

Priority:

```text
★★★★★
```

---

## 8️⃣ S3 Replication Documentation

Purpose:

```text
Disaster Recovery & Compliance
```

Topics Covered:

- CRR
- SRR
- Replication Rules
- Replication Metrics

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html
```

Priority:

```text
★★★★★
```

---

## 9️⃣ S3 Security Best Practices

Purpose:

```text
Secure Bucket Management
```

Topics Covered:

- Bucket Policies
- Encryption
- Access Control
- Block Public Access

Resource:

```text
https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html
```

Priority:

```text
★★★★★
```

---

# 🌍 CloudFront Resources

---

## 🔟 CloudFront Developer Guide

Purpose:

```text
Complete CloudFront Learning
```

Topics Covered:

- CDN Architecture
- Origins
- Cache Behaviors
- Invalidations
- HTTPS

Resource:

```text
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/
```

Priority:

```text
★★★★★
```

---

## 1️⃣1️⃣ Origin Access Control (OAC) Guide

Purpose:

```text
Secure S3 Origins
```

Topics Covered:

- OAC Configuration
- Bucket Policies
- Private Content Delivery

Resource:

```text
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
```

Priority:

```text
★★★★★
```

---

## 1️⃣2️⃣ CloudFront Cache Management Guide

Purpose:

```text
Caching Optimization
```

Topics Covered:

- TTL Settings
- Cache Policies
- Cache Behaviors
- Origin Requests

Resource:

```text
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cache-key-understand-cache-policy.html
```

Priority:

```text
★★★★★
```

---

## 1️⃣3️⃣ CloudFront Functions Documentation

Purpose:

```text
Edge Computing
```

Topics Covered:

- Viewer Requests
- Viewer Responses
- Security Headers
- URL Rewrites

Resource:

```text
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html
```

Priority:

```text
★★★★☆
```

---

## 1️⃣4️⃣ Lambda@Edge Documentation

Purpose:

```text
Advanced Edge Processing
```

Topics Covered:

- Origin Requests
- Origin Responses
- Authentication
- Dynamic Content

Resource:

```text
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-at-edge.html
```

Priority:

```text
★★★★☆
```

---

# 🔐 HTTPS & Security Resources

---

## 1️⃣5️⃣ AWS Certificate Manager Documentation

Purpose:

```text
SSL/TLS Certificate Management
```

Topics Covered:

- Certificate Creation
- DNS Validation
- CloudFront Integration

Resource:

```text
https://docs.aws.amazon.com/acm/
```

Priority:

```text
★★★★★
```

---

## 1️⃣6️⃣ AWS WAF Documentation

Purpose:

```text
Web Application Protection
```

Topics Covered:

- Web ACLs
- Managed Rules
- Rate Limiting
- OWASP Protection

Resource:

```text
https://docs.aws.amazon.com/waf/
```

Priority:

```text
★★★★★
```

---

# 🌐 Route 53 Resources

---

## 1️⃣7️⃣ Route 53 Developer Guide

Purpose:

```text
Complete DNS Learning
```

Topics Covered:

- Hosted Zones
- DNS Records
- Routing Policies
- Health Checks

Resource:

```text
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/
```

Priority:

```text
★★★★★
```

---

## 1️⃣8️⃣ Route 53 Routing Policies Documentation

Purpose:

```text
Traffic Routing Strategies
```

Topics Covered:

- Simple Routing
- Weighted Routing
- Latency Routing
- Failover Routing
- Geolocation Routing
- Geoproximity Routing
- Multivalue Routing

Resource:

```text
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
```

Priority:

```text
★★★★★
```

---

## 1️⃣9️⃣ Route 53 Health Checks Guide

Purpose:

```text
Availability Monitoring
```

Topics Covered:

- HTTP Checks
- HTTPS Checks
- TCP Checks
- Failover Integration

Resource:

```text
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html
```

Priority:

```text
★★★★★
```

---

# 🐍 Python & Automation Resources

---

## 2️⃣0️⃣ Boto3 S3 Documentation

Purpose:

```text
Automate S3 Operations
```

Topics Covered:

- Bucket Creation
- File Uploads
- Lifecycle Rules
- Policies

Resource:

```text
https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html
```

Priority:

```text
★★★★★
```

---

## 2️⃣1️⃣ Boto3 CloudFront Documentation

Purpose:

```text
Automate CloudFront Operations
```

Topics Covered:

- Distributions
- Invalidations
- Cache Management

Resource:

```text
https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/cloudfront.html
```

Priority:

```text
★★★★★
```

---

## 2️⃣2️⃣ AWS CLI Documentation

Purpose:

```text
Command Line AWS Management
```

Topics Covered:

- S3 Commands
- CloudFront Commands
- Route 53 Commands

Resource:

```text
https://docs.aws.amazon.com/cli/latest/
```

Priority:

```text
★★★★★
```

---

# 🎥 Recommended Video Resources

---

## Stephane Maarek AWS SAA Course

Topics:

```text
S3
CloudFront
Route 53
```

Platform:

```text
Udemy
```

Priority:

```text
★★★★★
```

---

## AWS Skill Builder

Topics:

```text
Storage
Networking
DNS
Content Delivery
```

Platform:

```text
AWS Skill Builder
```

Priority:

```text
★★★★★
```

---

# 🔥 Most Important Resources For SAA Exam

Study These First:

1. Amazon S3 Documentation
2. S3 Storage Classes Guide
3. S3 Lifecycle Policies Documentation
4. S3 Versioning Documentation
5. CloudFront Documentation
6. OAC Documentation
7. ACM Documentation
8. AWS WAF Documentation
9. Route 53 Documentation
10. Route 53 Routing Policies Guide

---

# 🧠 Week 14 Learning Outcome

By studying these resources, built understanding of:

- S3 Architecture
- Storage Classes
- Lifecycle Management
- Versioning
- Replication
- S3 Security
- CloudFront CDN
- Edge Locations
- OAC
- HTTPS
- ACM
- AWS WAF
- Route 53 DNS
- Routing Policies
- Health Checks
- CI/CD Automation

---

# 📚 Week 14 Resource Summary

Week 14 resources established the storage, content delivery, and DNS foundation required for modern cloud-native architectures.

These resources transformed knowledge from:

```text
Basic File Storage
```

Into:

```text
Production-Grade Global Website Architecture
```

and prepared the foundation for advanced AWS networking, DevOps automation, cloud architecture design, and scalable web application deployment.

---

**Week:** 14 / AWS Core Services IV  
**Focus Area:** S3, CloudFront & Route 53 🌍  
**Resources Status:** Complete ✅