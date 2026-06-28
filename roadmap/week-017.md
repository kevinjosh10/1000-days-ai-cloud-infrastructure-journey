# WEEK 17 ROADMAP — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

## 🎯 Week Goal

Master CloudWatch monitoring and alerting, CloudTrail auditing, AWS Config compliance, hybrid storage services (EFS, FSx, Storage Gateway, Snowball), and cost optimization strategies. These complete the core SAA-C03 service knowledge.

By the end of Week 17, be able to:

- Design monitoring solutions
- Enforce security and compliance
- Architect hybrid storage solutions
- Plan data migrations
- Optimize cloud spending
- Solve AWS architecture scenarios confidently

---

# 📅 Day 113 — CloudWatch: Metrics, Alarms & Dashboards

## Topics

### CloudWatch Fundamentals

Study:

```text
Namespace

Metric

Dimension
```

### CloudWatch Alarms

Practice:

```text
EC2 CPU > 80% For 5 Minutes

Send SNS Notification

Trigger ASG Scale-Out

OK, ALARM, INSUFFICIENT_DATA
```

---

### Dashboards & Custom Metrics

Build:

```text
CloudWatch Dashboard

cloudwatch.put_metric_data()
```

---

### CloudWatch Logs Insights

Learn:

```text
Query Application Logs

SQL-Like Syntax
```

---

### Hands-On Lab

Build:

```text
CloudWatch Dashboard

EC2 Alarms
```

Architecture:

```text
EC2
 ↓
CloudWatch
 ↓
SNS
```

---

### Deliverables

```text
Alarms Created

Dashboard Configured

Logs Queried
```

---

# 📅 Day 114 — CloudWatch Agent, Container Insights & Anomaly Detection

## Topics

### CloudWatch Agent

Configure:

```text
sudo yum install amazon-cloudwatch-agent

Memory Utilization

Disk Usage

JSON Config Wizard
```

---

### Advanced Monitoring

Study:

```text
Container Insights

EKS / ECS Native Metrics
```

---

### Metric Math & Anomaly Detection

Learn:

```text
Metric Math Expressions

Machine Learning Baselining
```

---

### Hands-On Lab

Build:

```text
EC2 Instance

IAM Role

CloudWatch Agent
```

Architecture:

```text
EC2 (Agent)
 ↓
CloudWatch Logs
```

---

### Deliverables

```text
Agent Installed

Memory Metrics Visible

Anomaly Detection Enabled
```

---

# 📅 Day 115 — CloudTrail & AWS Config

## Topics

### AWS CloudTrail

Learn:

```text
Records API Calls

Management Events

Data Events
```

---

### Trail Configuration

Configure:

```text
Store In S3

SSE-KMS

Log File Validation
```

---

### AWS Config

Study:

```text
Continuous Compliance

Config Rules
```

---

### Hands-On Lab

Build:

```text
CloudTrail Trail

CloudWatch Metric Filter

AWS Config Rule
```

Architecture:

```text
API Call
 ↓
CloudTrail
 ↓
S3 / CloudWatch
```

---

### Deliverables

```text
Trail Created

Metric Filter Working

Config Rule Tested
```

---

# 📅 Day 116 — Elastic File System (EFS) & FSx

## Topics

### Amazon EFS

Practice:

```text
NFS File System

Shared Access Simultaneously

Standard vs EFS-IA
```

---

### Amazon FSx

Learn:

```text
FSx for Windows File Server (SMB)

FSx for Lustre (S3 Integration)
```

---

### Hands-On Lab

Build:

```text
EFS File System

Mount Targets

2 EC2 Instances
```

Architecture:

```text
EC2 (A)
  ↘
   EFS
  ↗
EC2 (B)
```

---

### Deliverables

```text
EFS Created

Mounted Concurrently

Files Shared
```

---

# 📅 Day 117 — Storage Gateway & Snow Family

## Topics

### AWS Storage Gateway

Study:

```text
File Gateway (NFS/SMB to S3)

Volume Gateway (iSCSI)

Tape Gateway
```

---

### AWS Snow Family

Learn:

```text
Snowcone

Snowball Edge

Snowmobile
```

---

### AWS DataSync

Study:

```text
Online Data Transfer

NFS/SMB/HDFS to S3/EFS/FSx
```

---

### Hands-On Lab

Study:

```text
Architecture Diagrams For Migration
```

Architecture:

```text
On-Premises
 ↓
Storage Gateway
 ↓
S3
```

---

### Deliverables

```text
Migration Strategy Notes

Gateway Types Understood
```

---

# 📅 Day 118 — Cost Optimization on AWS

## Topics

### Cost Management Tools

Practice:

```text
AWS Cost Explorer

AWS Budgets

AWS Compute Optimizer
```

---

### Cost Strategies

Learn:

```text
Reserved Instances Strategy

Spot Instances

S3 Intelligent-Tiering
```

---

### Infracost

Study:

```text
Terraform Cost Estimates
```

---

### Hands-On Lab

Build:

```text
AWS Budget Alert

Infracost Breakdown
```

Architecture:

```text
Terraform
 ↓
Infracost
 ↓
Cost Estimate
```

---

### Deliverables

```text
Budgets Created

Cost Explorer Analyzed

Infracost Tested
```

---

# 📅 Day 119 — Week 17 Review

## Final Exam Prep Tasks

Complete:

```text
SAA Domain Coverage Self-Assessment

Targeted 2-Hour Deep-Dive

Full 65-Question Timed Practice Exam
```

---

## Study Summary

Write:

```text
1-Page Summary For Each Domain

Review Flashcards
```

---

# 🏆 Week Deliverables

Complete:

```text
CloudWatch Configured

EFS Mounted

Cost Tools Explored

1 Timed SAA Practice Exam Passed
```

---

# 🎯 End-of-Week Outcome

By the end of Week 17, be able to:

- Configure comprehensive monitoring
- Implement strict compliance controls
- Architect resilient hybrid storage
- Confidently answer SAA-C03 exam questions
