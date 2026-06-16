# WEEK 15 RESOURCES — AWS SAA EXAM PREP I: DATABASES

## 📌 Resource Overview

Week 15 focused on AWS database services that are heavily tested in the AWS Solutions Architect Associate (SAA-C03) certification exam.

Primary focus areas:

- Amazon RDS
- Multi-AZ Deployments
- Read Replicas
- Amazon Aurora
- Aurora Serverless v2
- Aurora Global Database
- ElastiCache Redis
- ElastiCache Memcached
- DynamoDB
- Partition Keys
- Capacity Modes
- GSI
- LSI
- DynamoDB DAX
- DynamoDB Streams
- TTL
- Database Selection Framework

The following resources were used to build both practical knowledge and AWS exam readiness.

---

# 📚 Core Learning Resources

---

## 1️⃣ AWS RDS Documentation

Purpose:

```text
Learn Amazon RDS Fundamentals
```

Topics:

- Database Engines
- Parameter Groups
- Option Groups
- Backups
- Multi-AZ
- Read Replicas
- Snapshots

URL:

```text
https://docs.aws.amazon.com/rds
```

Recommended Sections:

```text
User Guide
Multi-AZ Deployments
Read Replicas
Backups & Recovery
```

---

## 2️⃣ AWS Aurora Documentation

Purpose:

```text
Master Aurora Architecture
```

Topics:

- Aurora Storage
- Aurora Replicas
- Aurora Serverless v2
- Aurora Global Database
- Cluster Endpoints

URL:

```text
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide
```

Recommended Sections:

```text
Aurora Overview
Serverless v2
Global Database
Endpoints
```

---

## 3️⃣ AWS DynamoDB Documentation

Purpose:

```text
Learn NoSQL Database Design
```

Topics:

- Tables
- Items
- Attributes
- Capacity Modes
- GSI
- LSI
- DAX
- Streams
- TTL

URL:

```text
https://docs.aws.amazon.com/dynamodb
```

Recommended Sections:

```text
Developer Guide
Best Practices
Indexes
Streams
DAX
```

---

## 4️⃣ AWS ElastiCache Documentation

Purpose:

```text
Learn Redis & Memcached
```

Topics:

- Redis
- Memcached
- Cluster Modes
- Replication
- Failover
- Scaling

URL:

```text
https://docs.aws.amazon.com/elasticache
```

Recommended Sections:

```text
Redis User Guide
Cluster Mode
Replication Groups
Memcached Overview
```

---

# 🎥 Video Resources

---

## 5️⃣ Adrian Cantrill AWS SAA Course

Purpose:

```text
Deep AWS Understanding
```

Database Modules:

- RDS
- Aurora
- ElastiCache
- DynamoDB

Why Useful:

```text
Architecture Focused
Hands-On Labs
Real AWS Examples
```

URL:

```text
https://learn.cantrill.io
```

Priority:

```text
HIGHLY RECOMMENDED
```

---

## 6️⃣ AWS Skill Builder

Purpose:

```text
Official AWS Training
```

Topics:

- RDS
- Aurora
- DynamoDB
- Database Design

URL:

```text
https://skillbuilder.aws
```

Priority:

```text
Recommended
```

---

# 📝 AWS Exam Resources

---

## 7️⃣ Tutorials Dojo Practice Exams

Purpose:

```text
AWS SAA Exam Preparation
```

Focus Areas:

- Multi-AZ vs Read Replica
- Aurora Scenarios
- Redis vs Memcached
- DynamoDB Capacity Modes
- GSI vs LSI

URL:

```text
https://tutorialsdojo.com
```

Priority:

```text
MANDATORY
```

---

## 8️⃣ Tutorials Dojo Cheat Sheets

Purpose:

```text
Quick Revision
```

Topics:

- RDS
- Aurora
- DynamoDB
- ElastiCache

URL:

```text
https://tutorialsdojo.com/aws-cheat-sheets
```

Best For:

```text
Final Revision
```

---

# 🛠 Hands-On Practice Resources

---

## 9️⃣ AWS Free Tier

Purpose:

```text
Practical Experience
```

Services:

- RDS
- DynamoDB

Recommended Labs:

```text
Create RDS Instance
Create Read Replica
Create DynamoDB Table
Create GSI
Enable Streams
```

---

## 🔟 AWS CLI Documentation

Purpose:

```text
Practice Database Administration
```

Examples:

```bash
aws rds describe-db-instances
```

```bash
aws rds create-db-snapshot
```

```bash
aws dynamodb list-tables
```

URL:

```text
https://docs.aws.amazon.com/cli
```

---

# 💻 Boto3 Resources

---

## 1️⃣1️⃣ Boto3 Documentation

Purpose:

```text
AWS Automation Using Python
```

Topics:

- RDS Automation
- DynamoDB CRUD
- ElastiCache APIs

URL:

```text
https://boto3.amazonaws.com/v1/documentation/api/latest
```

Practice Files:

```text
rds_operations.py
dynamodb_crud.py
elasticache_info.py
```

---

# 📖 Must-Know AWS Whitepapers

---

## 1️⃣2️⃣ AWS Well-Architected Framework

Purpose:

```text
Learn Architecture Best Practices
```

Focus Areas:

```text
Reliability
Performance Efficiency
Cost Optimization
```

URL:

```text
https://docs.aws.amazon.com/wellarchitected
```

---

## 1️⃣3️⃣ AWS Database Blog

Purpose:

```text
Real-World Database Architectures
```

Topics:

```text
Aurora
DynamoDB
RDS
Migration
Performance
```

URL:

```text
https://aws.amazon.com/blogs/database
```

---

# 🧠 Flashcard Topics

---

## Create Flashcards For

### RDS

```text
Multi-AZ
Read Replica
Backups
Snapshots
```

---

### Aurora

```text
Storage Architecture
Endpoints
Global Database
Serverless v2
```

---

### DynamoDB

```text
Partition Keys
Sort Keys
RCU
WCU
On-Demand
Provisioned
```

---

### DynamoDB Advanced

```text
GSI
LSI
Streams
DAX
TTL
```

---

### ElastiCache

```text
Redis
Memcached
Cluster Modes
```

---

# 🔥 Most Important Resources

If time is limited, prioritize:

## Tier 1 (Must Complete)

```text
AWS Documentation
Tutorials Dojo Practice Exams
Adrian Cantrill Database Section
```

---

## Tier 2 (Strongly Recommended)

```text
AWS Skill Builder
Boto3 Documentation
AWS Database Blog
```

---

## Tier 3 (Optional)

```text
AWS Whitepapers
Additional Blog Posts
```

---

# 🎯 Week 15 Study Checklist

## RDS

- [x] RDS Fundamentals
- [x] Database Engines
- [x] Parameter Groups
- [x] Option Groups

---

## High Availability

- [x] Multi-AZ
- [x] Read Replicas
- [x] Backups
- [x] Recovery

---

## Aurora

- [x] Architecture
- [x] Serverless v2
- [x] Global Database
- [x] Endpoints

---

## ElastiCache

- [x] Redis
- [x] Memcached
- [x] Cluster Modes

---

## DynamoDB

- [x] Data Modeling
- [x] Capacity Modes
- [x] GSI
- [x] LSI
- [x] DAX
- [x] Streams
- [x] TTL

---

## AWS Exam Readiness

- [x] Database Selection Framework
- [x] Practice Questions
- [x] Flashcards
- [x] Architecture Scenarios

---

# 🚀 Week 15 Outcome

Using these resources, gained understanding of:

- Relational Databases
- NoSQL Databases
- Database High Availability
- Database Scalability
- Caching Architectures
- Event-Driven Systems
- AWS Database Selection Strategies
- AWS Solutions Architect Exam Patterns

These resources provide everything needed to confidently complete Week 15 and prepare for database-focused questions in the AWS Solutions Architect Associate (SAA-C03) certification exam.

---

**Week:** 15

**Topic:** AWS Databases

**Certification:** AWS Solutions Architect Associate (SAA-C03)

**Primary Goal:** Database Architecture Mastery 🚀