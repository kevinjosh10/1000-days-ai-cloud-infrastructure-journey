# WEEK 15 NOTES — AWS SAA EXAM PREP I: DATABASES

## 📌 Week Overview

Week 15 focused on mastering AWS database services for the AWS Solutions Architect Associate (SAA-C03) certification exam.

This week covered:

- Amazon RDS Fundamentals
- Database Engines
- RDS Parameter Groups
- RDS Option Groups
- Multi-AZ Deployments
- Read Replicas
- Automated Backups
- Point-In-Time Recovery
- Amazon Aurora Architecture
- Aurora Serverless v2
- Aurora Global Database
- Aurora Cluster Endpoints
- ElastiCache Fundamentals
- Redis vs Memcached
- Redis Cluster Modes
- DynamoDB Fundamentals
- Partition Keys
- Sort Keys
- Capacity Modes
- Consistency Models
- Global Secondary Indexes (GSI)
- Local Secondary Indexes (LSI)
- DynamoDB Accelerator (DAX)
- DynamoDB Streams
- Lambda Integration
- Event-Driven Architectures
- Time To Live (TTL)
- Sparse Indexes
- Hot Partition Prevention
- Database Selection Framework
- AWS Exam Decision Patterns

The goal of this week was to understand how AWS databases solve different business requirements and how to select the correct database service during the AWS Solutions Architect Associate exam.

---

# 🧠 Amazon RDS Fundamentals

---

# 1️⃣ What is Amazon RDS?

Amazon Relational Database Service (RDS) is AWS's managed relational database service.

Purpose:

```text
Managed SQL Databases
```

Examples:

```text
MySQL
PostgreSQL
MariaDB
Oracle
SQL Server
Aurora
```

---

## Shared Responsibility Model

AWS Manages:

```text
Infrastructure
OS Patching
Database Updates
Backups
Storage
Failover
```

You Manage:

```text
Schemas
Queries
Users
Permissions
Application Configuration
```

---

# 2️⃣ Supported Database Engines

---

## MySQL

Use Cases:

```text
Web Applications
E-Commerce
CMS Platforms
```

---

## PostgreSQL

Use Cases:

```text
Enterprise Applications
Analytics
Complex Queries
```

---

## MariaDB

MySQL-compatible database.

---

## Oracle

Enterprise database platform.

---

## SQL Server

Microsoft relational database.

---

## Aurora

AWS cloud-native relational database.

---

# 3️⃣ RDS Architecture

---

## Typical Deployment

```text
Application
      ↓
RDS
      ↓
Database Storage
```

---

## Production Best Practice

```text
Internet
    ↓
Bastion Host
    ↓
Private RDS
```

RDS should not be publicly accessible.

---

# 4️⃣ Parameter Groups

---

## Purpose

Control database engine settings.

Examples:

```text
max_connections
log_settings
query_cache
```

---

# 5️⃣ Option Groups

---

## Purpose

Enable additional database features.

Examples:

```text
Oracle APEX
SQL Server Features
```

---

# 🧠 Multi-AZ & Read Replicas

---

# 6️⃣ Multi-AZ Deployments

---

## Purpose

High Availability

Architecture:

```text
Primary
    ↓
Synchronous Replication
    ↓
Standby
```

Characteristics:

- Automatic Failover
- Different AZ
- Standby Not Readable

---

## Exam Trigger Words

```text
High Availability
Automatic Failover
Business Continuity
```

Answer:

```text
Multi-AZ
```

---

# 7️⃣ Read Replicas

---

## Purpose

Read Scaling

Architecture:

```text
Primary
    ↓
Asynchronous Replication
    ↓
Read Replica
```

Characteristics:

- Readable
- Up to 5 Replicas
- Reporting Workloads

---

## Exam Trigger Words

```text
Read Heavy
Reporting
Analytics
Scale Reads
```

Answer:

```text
Read Replica
```

---

# 8️⃣ Multi-AZ vs Read Replica

---

## Key Difference

```text
Availability?
      ↓
Multi-AZ

Performance?
      ↓
Read Replica
```

---

## Comparison

| Feature | Multi-AZ | Read Replica |
|----------|----------|----------|
| Purpose | Availability | Scalability |
| Replication | Synchronous | Asynchronous |
| Readable | No | Yes |
| Automatic Failover | Yes | No |
| Read Scaling | No | Yes |

---

# 9️⃣ Automated Backups

---

## Components

```text
Daily Snapshots
Transaction Logs
```

Retention:

```text
1 - 35 Days
```

---

## Point-In-Time Recovery

Restore database to any second within retention window.

---

# 🔟 Manual Snapshots

---

Characteristics:

```text
Retained Indefinitely
```

Used for:

```text
Long-Term Backup
Migration
Compliance
```

---

# 🧠 Amazon Aurora

---

# 1️⃣1️⃣ Aurora Architecture

---

## Storage Design

```text
3 Availability Zones
        ↓
6 Copies Of Data
```

Benefits:

- High Durability
- High Availability

---

# 1️⃣2️⃣ Aurora Performance

---

Compared to RDS:

```text
5x Faster Than MySQL

3x Faster Than PostgreSQL
```

---

## Storage Scaling

```text
Up To 128 TB
```

Automatic scaling.

---

# 1️⃣3️⃣ Aurora Read Replicas

---

Supports:

```text
15 Read Replicas
```

Compared to:

```text
RDS = 5
Aurora = 15
```

---

# 1️⃣4️⃣ Aurora Serverless v2

---

Purpose:

```text
Automatic Compute Scaling
```

Best For:

```text
Dev/Test
Variable Workloads
New Applications
```

---

# 1️⃣5️⃣ Aurora Global Database

---

Architecture:

```text
Primary Region
       ↓
Secondary Regions
```

Supports:

```text
Up To 5 Regions
```

Replication Lag:

```text
< 1 Second
```

---

## Use Cases

```text
Global Disaster Recovery
Global Applications
```

---

# 1️⃣6️⃣ Aurora Endpoints

---

## Cluster Endpoint

```text
Writes
```

---

## Reader Endpoint

```text
Load Balances Reads
```

Across all replicas.

---

# 🧠 ElastiCache

---

# 1️⃣7️⃣ What is ElastiCache?

AWS managed in-memory caching service.

Purpose:

```text
Reduce Database Load
```

---

## Use Cases

```text
Sessions
API Responses
Leaderboards
Real-Time Analytics
```

---

# 1️⃣8️⃣ Redis

---

Characteristics:

- Single-threaded
- Persistence
- Replication
- Pub/Sub
- Lua Scripting
- Geospatial Support

Data Structures:

```text
Strings
Lists
Sets
Hashes
Sorted Sets
```

---

## Exam Trigger Words

```text
Persistence
HA
Replication
Leaderboards
Complex Data
```

Answer:

```text
Redis
```

---

# 1️⃣9️⃣ Memcached

---

Characteristics:

- Multi-threaded
- Key-Value Only
- No Persistence
- No Replication

---

## Exam Trigger Words

```text
Simple Cache
High Throughput
No Persistence
```

Answer:

```text
Memcached
```

---

# 2️⃣0️⃣ Redis Cluster Modes

---

## Cluster Mode Disabled

```text
Single Shard
Up To 5 Read Replicas
```

---

## Cluster Mode Enabled

```text
Sharding
Up To 500 Nodes
```

Used for massive scale.

---

# 🧠 DynamoDB Fundamentals

---

# 2️⃣1️⃣ What is DynamoDB?

AWS fully managed NoSQL database.

Supports:

```text
Key-Value
Document Storage
```

Benefits:

```text
Serverless
Massive Scale
Millisecond Latency
```

---

# 2️⃣2️⃣ DynamoDB Components

---

## Table

Collection of data.

---

## Item

Equivalent to a row.

---

## Attribute

Equivalent to a column.

---

# 2️⃣3️⃣ Primary Keys

---

## Simple Primary Key

```text
Partition Key
```

Example:

```text
UserID
```

---

## Composite Primary Key

```text
Partition Key
+
Sort Key
```

Example:

```text
UserID
+
SessionID
```

---

# 2️⃣4️⃣ Capacity Modes

---

## Provisioned

Specify:

```text
RCU
WCU
```

Best For:

```text
Predictable Workloads
```

---

## On-Demand

Pay Per Request.

Best For:

```text
Unpredictable Traffic
Spiky Workloads
```

---

# 2️⃣5️⃣ Consistency Models

---

## Eventually Consistent

Benefits:

```text
Lower Cost
Higher Scale
```

Reads may lag briefly.

---

## Strongly Consistent

Benefits:

```text
Latest Data
```

Higher cost.

---

# 🧠 DynamoDB Advanced Features

---

# 2️⃣6️⃣ Global Secondary Index (GSI)

---

Purpose:

```text
Alternative Query Patterns
```

Characteristics:

- Different Partition Key
- Optional Sort Key
- Separate Capacity
- Up To 20 GSIs

---

## Exam Shortcut

```text
Need Different Partition Key?
          ↓
GSI
```

---

# 2️⃣7️⃣ Local Secondary Index (LSI)

---

Characteristics:

- Same Partition Key
- Different Sort Key
- Shares Capacity
- Up To 5 LSIs

Must be created at table creation.

---

## Exam Shortcut

```text
Need Different Sort Key?
          ↓
LSI
```

---

# 2️⃣8️⃣ DynamoDB Accelerator (DAX)

---

Purpose:

```text
Microsecond Read Latency
```

Architecture:

```text
Application
      ↓
DAX
      ↓
DynamoDB
```

Benefits:

- In-Memory Cache
- Fully Managed
- Reduced Database Load

---

# 2️⃣9️⃣ DynamoDB Streams

---

Purpose:

```text
Capture Data Changes
```

Events:

```text
INSERT
MODIFY
REMOVE
```

Architecture:

```text
DynamoDB
      ↓
Streams
      ↓
Lambda
```

---

## Use Cases

```text
Auditing
Notifications
Analytics
Replication
```

---

# 3️⃣0️⃣ DynamoDB Best Practices

---

## Avoid Hot Partitions

Bad:

```text
Millions Of Requests
        ↓
Single Partition Key
```

Good:

```text
Evenly Distributed Keys
```

---

## Use Sparse Indexes

Only items containing specific attributes appear in the index.

Benefits:

```text
Lower Cost
Faster Queries
```

---

## Use TTL

Purpose:

```text
Automatic Data Expiration
```

Use Cases:

```text
Sessions
Temporary Tokens
Cache Entries
```

---

# 🧠 Database Selection Framework

---

# 3️⃣1️⃣ Choosing The Right Database

---

## Relational Data

```text
RDS
Aurora
```

---

## Key-Value / NoSQL

```text
DynamoDB
```

---

## Cache

```text
ElastiCache
```

---

## Document Database

```text
DocumentDB
```

---

## Graph Database

```text
Neptune
```

---

## Time-Series Database

```text
Timestream
```

---

# 🔥 Most Important Week 15 Exam Concepts

---

## Multi-AZ

```text
Availability
```

---

## Read Replica

```text
Scalability
```

---

## Aurora

```text
High Performance SQL
```

---

## DynamoDB

```text
Massive Scale
Serverless
```

---

## GSI

```text
Different Partition Key
```

---

## LSI

```text
Same Partition Key
Different Sort Key
```

---

## Redis

```text
Persistence
HA
Advanced Features
```

---

## Memcached

```text
Simple Cache
High Throughput
```

---

## DAX

```text
Microsecond Reads
```

---

## Streams

```text
Event-Driven Architectures
```

---

# 🚀 Week 15 Outcome

By the end of Week 15, built understanding of:

- RDS
- Aurora
- Multi-AZ
- Read Replicas
- Automated Backups
- ElastiCache
- Redis
- Memcached
- DynamoDB
- Partition Keys
- Capacity Modes
- GSI
- LSI
- DAX
- Streams
- TTL
- Sparse Indexes
- Database Selection Framework

---

# 📚 Week 15 Summary

Week 15 established the database foundation required for AWS Solutions Architect Associate certification.

This week transformed knowledge from:

- Understanding individual database services

Into:

- Designing scalable, highly available, cost-optimized AWS database architectures and selecting the correct database service for any workload or AWS exam scenario.