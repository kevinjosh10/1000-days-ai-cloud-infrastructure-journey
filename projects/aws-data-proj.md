# WEEK 15 PROJECT — AWS DATABASE ARCHITECTURE LAB

## 📌 Project Overview

Week 15's project combines all major database concepts learned throughout the week into a single AWS architecture.

This project simulates a scalable e-commerce platform using:

- Amazon RDS
- Amazon Aurora
- DynamoDB
- ElastiCache Redis
- DynamoDB Streams
- DynamoDB DAX
- Read Replicas
- Multi-AZ
- TTL
- GSIs
- Event-Driven Architectures

The goal is to understand when and why each database service should be used in a real production environment.

---

# 🎯 Project Objectives

Build a database architecture that demonstrates:

### Relational Workloads

Using:

```text
Amazon RDS
Amazon Aurora
```

For:

```text
Orders
Payments
Transactions
```

---

### NoSQL Workloads

Using:

```text
DynamoDB
```

For:

```text
User Sessions
Shopping Cart
User Activity
```

---

### Caching Layer

Using:

```text
ElastiCache Redis
```

For:

```text
Session Cache
Frequently Accessed Products
Leaderboard Data
```

---

### Event Processing

Using:

```text
DynamoDB Streams
AWS Lambda
```

For:

```text
Notifications
Analytics
Audit Logs
```

---

# 🏗 Architecture Diagram

```text
                    Users
                      │
                      ▼
                 Application
                      │
 ┌────────────────────┼────────────────────┐
 │                    │                    │
 ▼                    ▼                    ▼

Aurora          DynamoDB          ElastiCache
Orders DB       Sessions          Redis Cache
Payments        Shopping Cart     Product Cache
Transactions    User Activity

 │                    │
 │                    ▼
 │             DynamoDB Streams
 │                    │
 │                    ▼
 │                Lambda
 │                    │
 │                    ▼
 │            Analytics / Events
 │
 ▼

Aurora Read Replica
(Read Scaling)

 │
 ▼

Aurora Standby
(Multi-AZ)
```

---

# 📂 Project Components

---

# 1️⃣ Aurora Database

Purpose:

```text
Relational Transactions
```

Stores:

```text
Orders
Payments
Invoices
Customers
```

Why Aurora?

```text
ACID Transactions
High Availability
Read Replicas
Automatic Scaling
```

---

# 2️⃣ DynamoDB Table

Table Name:

```text
UserSessions
```

Partition Key:

```text
userId
```

Sort Key:

```text
sessionId
```

Stores:

```text
Active Sessions
Login Activity
Shopping Cart Data
```

Benefits:

```text
Single Digit Millisecond Latency
Massive Scale
Serverless
```

---

# 3️⃣ DynamoDB GSI

GSI:

```text
email-index
```

Purpose:

```text
Query Users By Email
```

Example:

```text
Base Table:
userId

GSI:
email
```

---

# 4️⃣ DynamoDB TTL

Purpose:

```text
Automatically Remove Old Sessions
```

Flow:

```text
Session Created
       ↓
TTL Set
       ↓
Automatic Deletion
```

---

# 5️⃣ DynamoDB Streams

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

Flow:

```text
DynamoDB
      ↓
Streams
      ↓
Lambda
```

---

# 6️⃣ Lambda Processor

Triggered By:

```text
DynamoDB Streams
```

Responsibilities:

```text
Generate Notifications
Update Analytics
Create Audit Logs
```

---

# 7️⃣ ElastiCache Redis

Purpose:

```text
Reduce Database Load
```

Stores:

```text
Popular Products
Session Data
Frequently Requested Queries
```

Flow:

```text
Application
      ↓
Redis
      ↓
Aurora
```

Benefits:

```text
Microsecond Access
Reduced DB Cost
Lower Latency
```

---

# 8️⃣ Aurora Read Replica

Purpose:

```text
Read Scaling
```

Handles:

```text
Reporting
Analytics Queries
Read Traffic
```

Benefits:

```text
Reduced Load On Primary
Better Performance
```

---

# 9️⃣ Aurora Multi-AZ

Purpose:

```text
High Availability
```

Flow:

```text
Primary
    ↓
Synchronous Replication
    ↓
Standby
```

Benefits:

```text
Automatic Failover
Business Continuity
```

---

# 🔧 AWS Services Used

| Service | Purpose |
|----------|----------|
| Aurora | Transaction Database |
| DynamoDB | Sessions & Activity |
| ElastiCache Redis | Caching |
| DynamoDB Streams | Event Capture |
| Lambda | Event Processing |
| Aurora Read Replica | Read Scaling |
| Aurora Multi-AZ | High Availability |

---

# 🧪 Practical Tasks

---

## Task 1

Create:

```text
Aurora MySQL Cluster
```

Enable:

```text
Multi-AZ
```

---

## Task 2

Create:

```text
Aurora Read Replica
```

Verify:

```text
Read Scaling
```

---

## Task 3

Create:

```text
DynamoDB UserSessions Table
```

Keys:

```text
PK = userId
SK = sessionId
```

---

## Task 4

Create:

```text
Global Secondary Index
```

Index:

```text
email-index
```

---

## Task 5

Enable:

```text
TTL
```

Attribute:

```text
expirationTime
```

---

## Task 6

Enable:

```text
DynamoDB Streams
```

Options:

```text
New And Old Images
```

---

## Task 7

Create:

```text
Lambda Trigger
```

Event Source:

```text
DynamoDB Stream
```

---

## Task 8

Create:

```text
Redis Cluster
```

Store:

```text
Frequently Accessed Products
```

---

# 📈 AWS Exam Concepts Demonstrated

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

## DynamoDB

```text
Massive Scale
```

---

## GSI

```text
Alternative Query Patterns
```

---

## DAX

```text
Microsecond Reads
```

---

## Streams

```text
Event-Driven Architecture
```

---

## Redis

```text
Caching
```

---

## TTL

```text
Automatic Data Cleanup
```

---

# 🧠 Skills Gained

By completing this project you will understand:

- Relational Database Design
- Aurora Architecture
- Multi-AZ Deployments
- Read Replicas
- DynamoDB Data Modeling
- Partition Key Design
- GSI Design
- DynamoDB Streams
- Event-Driven Architectures
- Redis Caching
- High Availability
- Scalability Patterns
- AWS Database Selection Framework
- AWS SAA Exam Scenarios

---

# 🚀 Project Outcome

By the end of this project you will have built a production-style AWS database architecture demonstrating:

- High Availability
- Scalability
- Caching
- Event Processing
- Serverless Architectures
- Database Optimization
- Real AWS Solutions Architect Design Patterns

This project serves as a complete Week 15 capstone and reinforces the most heavily tested AWS SAA-C03 database concepts.