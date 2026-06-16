# WEEK 15 RECAP — AWS SAA EXAM PREP I: DATABASES

## 📌 Week Summary

Week 15 focused on mastering AWS database services and learning how to choose the correct database architecture for different workloads.

Throughout this week, studied:

- Amazon RDS
- Multi-AZ Deployments
- Read Replicas
- Automated Backups
- Point-In-Time Recovery
- Amazon Aurora
- Aurora Serverless v2
- Aurora Global Database
- ElastiCache Redis
- ElastiCache Memcached
- DynamoDB
- Partition Keys
- Sort Keys
- Capacity Modes
- GSI
- LSI
- DynamoDB Accelerator (DAX)
- DynamoDB Streams
- Lambda Integration
- TTL
- Sparse Indexes
- Hot Partitions
- Database Selection Framework

The goal was to understand how AWS databases solve real-world business problems and how database services are tested in the AWS Solutions Architect Associate (SAA-C03) exam.

---

# 📅 Daily Progress Review

---

# Day 99 — RDS Fundamentals

Focused on Amazon RDS basics.

Learned:

- AWS managed database responsibilities
- Supported database engines
- RDS architecture
- Private database deployments
- Parameter Groups
- Option Groups

Key Takeaway:

```text
AWS Manages Infrastructure
You Manage Data
```

---

# Day 100 — Multi-AZ & Read Replicas

Focused on availability and scalability.

Learned:

- Multi-AZ architecture
- Read Replica architecture
- Automatic failover
- Read scaling
- Automated backups
- Point-In-Time Recovery

Key Takeaway:

```text
Multi-AZ = Availability

Read Replica = Scalability
```

---

# Day 101 — Amazon Aurora

Focused on AWS's custom relational database engine.

Learned:

- Aurora architecture
- Distributed storage
- 6 copies across 3 AZs
- Aurora Serverless v2
- Aurora Global Database
- Aurora Endpoints

Key Takeaway:

```text
Aurora = High Performance Relational Database
```

---

# Day 102 — ElastiCache

Focused on caching architectures.

Learned:

- Redis
- Memcached
- Cache patterns
- Session storage
- Leaderboards
- Redis cluster modes

Key Takeaway:

```text
Redis = Default Choice

Memcached = Simple Cache
```

---

# Day 103 — DynamoDB Fundamentals

Focused on NoSQL databases.

Learned:

- DynamoDB architecture
- Tables
- Items
- Attributes
- Partition Keys
- Sort Keys
- Capacity Modes
- Consistency Models

Key Takeaway:

```text
DynamoDB = Massive Scale + Serverless
```

---

# Day 104 — DynamoDB Advanced Features

Focused on advanced DynamoDB concepts.

Learned:

- Global Secondary Indexes
- Local Secondary Indexes
- DynamoDB Accelerator
- DynamoDB Streams
- Lambda Integration
- TTL
- Sparse Indexes
- Hot Partition Prevention

Key Takeaway:

```text
DynamoDB = Query Flexibility + Event Processing
```

---

# Day 105 — Database Selection Framework

Focused on AWS architecture decisions.

Learned:

- RDS vs Aurora
- DynamoDB vs RDS
- Redis vs Memcached
- Multi-AZ vs Read Replica
- GSI vs LSI
- Database decision frameworks

Key Takeaway:

```text
Choose Databases Based On Workload Requirements
```

---

# 🧠 Most Important AWS Exam Concepts

---

## Multi-AZ

Purpose:

```text
High Availability
```

Keywords:

```text
Failover
Disaster Recovery
Business Continuity
```

---

## Read Replica

Purpose:

```text
Read Scaling
```

Keywords:

```text
Reporting
Analytics
Read Heavy Applications
```

---

## Aurora

Purpose:

```text
High Performance SQL
```

Keywords:

```text
MySQL Compatible
PostgreSQL Compatible
Global Database
Serverless
```

---

## DynamoDB

Purpose:

```text
Massive Scale NoSQL
```

Keywords:

```text
Serverless
Millisecond Latency
Unpredictable Traffic
```

---

## GSI

Purpose:

```text
Alternative Query Pattern
```

Keywords:

```text
Different Partition Key
Added Later
```

---

## LSI

Purpose:

```text
Alternative Sorting
```

Keywords:

```text
Same Partition Key
Different Sort Key
Created At Table Creation
```

---

## DAX

Purpose:

```text
Microsecond Reads
```

Keywords:

```text
Caching
Read Performance
```

---

## Streams

Purpose:

```text
Event Processing
```

Keywords:

```text
Lambda
Notifications
Analytics
Replication
```

---

## Redis

Purpose:

```text
Advanced Cache
```

Keywords:

```text
Persistence
Replication
Leaderboards
Sessions
```

---

## Memcached

Purpose:

```text
Simple Cache
```

Keywords:

```text
Multi-Threaded
No Persistence
```

---

# 📊 Database Selection Framework

---

## Need SQL?

```text
RDS
Aurora
```

---

## Need Massive Scale?

```text
DynamoDB
```

---

## Need Caching?

```text
ElastiCache
```

---

## Need JSON Documents?

```text
DocumentDB
```

---

## Need Relationship Analysis?

```text
Neptune
```

---

## Need Time-Series Data?

```text
Timestream
```

---

# 📋 Service Comparison

| Service | Best For |
|----------|----------|
| RDS | Traditional Relational Workloads |
| Aurora | High Performance Relational Workloads |
| DynamoDB | Massive Scale NoSQL |
| ElastiCache Redis | Advanced Caching |
| ElastiCache Memcached | Simple Caching |
| DocumentDB | Document Databases |
| Neptune | Graph Databases |
| Timestream | Time-Series Data |

---

# 🔥 Top 10 AWS Exam Triggers

| Requirement | Answer |
|------------|---------|
| Automatic Failover | Multi-AZ |
| Read Scaling | Read Replica |
| High Performance MySQL | Aurora |
| Massive Scale | DynamoDB |
| Unpredictable Traffic | DynamoDB On-Demand |
| Different Partition Key | GSI |
| Same Partition Key Different Sort Key | LSI |
| Microsecond Reads | DAX |
| Persistence + Cache | Redis |
| Event-Driven Architecture | Streams |

---

# 🏗 Architecture Skills Gained

Built understanding of:

- Database Design
- High Availability
- Scalability
- Read Optimization
- NoSQL Modeling
- Caching Architectures
- Event-Driven Systems
- Distributed Databases
- Cloud-Native Databases
- AWS Architecture Decision Frameworks

---

# 🚀 Week 15 Outcome

By the end of Week 15, gained the ability to:

- Design relational database architectures
- Design NoSQL database architectures
- Select the correct AWS database service
- Build scalable systems
- Build highly available systems
- Optimize database performance
- Design event-driven architectures
- Answer AWS SAA database questions confidently

---

# 📚 Week 15 Final Reflection

Week 15 transformed knowledge from:

```text
Knowing AWS Database Services
```

Into:

```text
Architecting Real-World Database Solutions
```

Built a strong foundation in relational databases, NoSQL databases, caching, event-driven architectures, scalability, high availability, and AWS database selection strategies.

These concepts form one of the most heavily tested domains in the AWS Solutions Architect Associate (SAA-C03) certification exam and serve as a critical foundation for designing production-grade cloud architectures.

---

**Week Status:** Complete ✅

**Days Completed:** 99 → 105

**Focus Area:** AWS Databases

**AWS SAA Readiness:** Significantly Improved 🚀

**Progress:** Week 15 / 52 Complete