# WEEK 15 ROADMAP — AWS SAA EXAM PREP I: DATABASES

## 🎯 Week Goal

Master AWS database services for the AWS Solutions Architect Associate (SAA-C03) exam.

By the end of this week, be able to:

- Choose the correct AWS database service for any workload
- Design highly available database architectures
- Design scalable database solutions
- Understand Aurora architecture
- Implement DynamoDB data models
- Compare Redis vs Memcached
- Solve AWS SAA database scenario questions confidently

---

# 📅 WEEK 15 LEARNING PATH

```text
RDS Fundamentals
       ↓
Multi-AZ & Read Replicas
       ↓
Aurora
       ↓
ElastiCache
       ↓
DynamoDB
       ↓
DynamoDB Advanced Features
       ↓
Database Selection Framework
```

---

# DAY 99 — RDS Fundamentals

## Focus

Amazon Relational Database Service (RDS)

---

## Learn

### Managed Database Concepts

Understand:

```text
AWS Manages:
- Infrastructure
- OS Patching
- Database Updates
- Backups
- Failover

You Manage:
- Schemas
- Queries
- Users
- Permissions
```

---

### Database Engines

Study:

```text
MySQL
PostgreSQL
MariaDB
Oracle
SQL Server
Aurora
```

---

### RDS Networking

Learn:

```text
Private Subnets
Security Groups
Bastion Hosts
```

---

### Database Administration

Study:

```text
Parameter Groups
Option Groups
```

---

## Hands-On

### Launch RDS Instance

```text
MySQL
db.t2.micro
20GB Storage
Private Subnet
```

---

### Connect From EC2

```bash
mysql -h endpoint -u admin -p
```

Verify:

```sql
SHOW DATABASES;
```

---

## AWS Exam Focus

```text
Shared Responsibility Model
RDS Engines
Parameter Groups
Option Groups
```

---

# DAY 100 — Multi-AZ & Read Replicas

## Focus

Availability vs Scalability

---

## Learn

### Multi-AZ

Architecture:

```text
Primary
    ↓
Synchronous Replication
    ↓
Standby
```

Purpose:

```text
High Availability
```

---

### Read Replicas

Architecture:

```text
Primary
    ↓
Asynchronous Replication
    ↓
Replica
```

Purpose:

```text
Read Scaling
```

---

### Automated Backups

Learn:

```text
Snapshots
Transaction Logs
PITR
```

---

## Hands-On

### Create Read Replica

Observe:

```text
Replication Lag
Read Traffic
```

---

### Promote Replica

```bash
aws rds promote-read-replica \
--db-instance-identifier my-replica
```

---

## AWS Exam Focus

```text
Multi-AZ = Availability

Read Replica = Scalability
```

---

# DAY 101 — Amazon Aurora

## Focus

AWS Cloud-Native Relational Database

---

## Learn

### Aurora Architecture

Study:

```text
3 AZs
6 Data Copies
Distributed Storage
```

---

### Aurora Performance

Compare:

```text
Aurora vs RDS
```

---

### Aurora Serverless v2

Learn:

```text
Auto Scaling Compute
```

---

### Aurora Global Database

Learn:

```text
Cross-Region Replication
Global DR
```

---

### Aurora Endpoints

Study:

```text
Cluster Endpoint
Reader Endpoint
```

---

## Hands-On

### Launch Aurora Cluster

Explore:

```text
Endpoints
Replicas
Monitoring
```

---

## AWS Exam Focus

```text
Aurora
Serverless v2
Global Database
Reader Endpoint
```

---

# DAY 102 — ElastiCache

## Focus

Redis vs Memcached

---

## Learn

### Redis

Study:

```text
Persistence
Replication
Pub/Sub
Data Structures
```

---

### Memcached

Study:

```text
Simple Cache
Multi-Threaded
No Persistence
```

---

### Redis Cluster Modes

Learn:

```text
Cluster Mode Disabled
Cluster Mode Enabled
```

---

## Hands-On

### Create Redis Cluster

Practice:

```text
Caching
Monitoring
Failover
```

---

## AWS Exam Focus

```text
Redis = Advanced Cache

Memcached = Simple Cache
```

---

# DAY 103 — DynamoDB Fundamentals

## Focus

NoSQL Data Modeling

---

## Learn

### DynamoDB Basics

Study:

```text
Tables
Items
Attributes
```

---

### Primary Keys

Learn:

```text
Partition Key

Partition Key
+
Sort Key
```

---

### Capacity Modes

Study:

```text
Provisioned
On-Demand
```

---

### Consistency Models

Learn:

```text
Eventually Consistent

Strongly Consistent
```

---

## Hands-On

### Create Sessions Table

Keys:

```text
PK = userId
SK = sessionId
```

---

### CRUD Operations

Practice:

```text
Put
Get
Query
Delete
```

---

## AWS Exam Focus

```text
Partition Keys
Capacity Modes
Consistency
```

---

# DAY 104 — DynamoDB Advanced Features

## Focus

Indexes, DAX & Streams

---

## Learn

### GSI

Study:

```text
Different Partition Key
```

Maximum:

```text
20
```

---

### LSI

Study:

```text
Same Partition Key
Different Sort Key
```

Maximum:

```text
5
```

---

### DAX

Learn:

```text
Microsecond Reads
```

---

### Streams

Learn:

```text
Event Processing
Lambda Integration
```

---

### Optimization

Study:

```text
TTL
Sparse Indexes
Hot Partitions
```

---

## Hands-On

### Create GSI

Query:

```text
Alternative Access Pattern
```

---

### Enable Streams

Trigger:

```text
Lambda
```

---

## AWS Exam Focus

```text
GSI vs LSI
DAX
Streams
TTL
```

---

# DAY 105 — Database Selection Framework

## Focus

Architecture Decisions

---

## Learn

### Database Categories

```text
RDS/Aurora
DynamoDB
ElastiCache
DocumentDB
Neptune
Timestream
```

---

### Service Comparison

Compare:

```text
Cost
Scalability
Consistency
Use Cases
```

---

### Decision Framework

```text
Need SQL?
      ↓
RDS/Aurora

Need NoSQL?
      ↓
DynamoDB

Need Cache?
      ↓
ElastiCache

Need Documents?
      ↓
DocumentDB

Need Graph?
      ↓
Neptune

Need Time-Series?
      ↓
Timestream
```

---

## Hands-On

### Create boto3 Scripts

Files:

```text
rds_operations.py
dynamodb_crud.py
elasticache_info.py
```

---

### Review Notes

Create:

```text
Comparison Tables
Flashcards
Decision Trees
```

---

## AWS Exam Focus

```text
Service Selection
Architecture Scenarios
Decision Making
```

---

# 🏆 Week 15 Deliverables

## Notes

- [ ] Day 99 Notes
- [ ] Day 100 Notes
- [ ] Day 101 Notes
- [ ] Day 102 Notes
- [ ] Day 103 Notes
- [ ] Day 104 Notes
- [ ] Day 105 Notes

---

## Project

- [ ] AWS Database Architecture Lab Completed

---

## Revision

- [ ] 30 Flashcards Created
- [ ] 20 Practice Questions Solved
- [ ] Database Comparison Table Created

---

# 🔥 Most Important SAA-C03 Topics

Priority Order:

```text
1. Multi-AZ vs Read Replica

2. Aurora Architecture

3. DynamoDB Partition Keys

4. GSI vs LSI

5. DynamoDB Capacity Modes

6. Redis vs Memcached

7. DAX

8. Streams

9. Backups & Recovery

10. Database Selection Framework
```

---

# 🚀 End-of-Week Outcome

By completing Week 15, you will be able to:

- Design highly available databases
- Design scalable databases
- Choose the right AWS database service
- Build caching architectures
- Build event-driven architectures
- Understand DynamoDB deeply
- Understand Aurora deeply
- Solve database-heavy AWS SAA questions confidently

---

**Week:** 15

**Theme:** AWS Databases

**Certification Track:** AWS Solutions Architect Associate (SAA-C03)

**Days Covered:** 99 → 105

**Milestone:** Database Architecture Foundations Complete 🚀