import os

base_dir = r"c:\Users\ADMIN\OneDrive\Desktop\1000-days-ai-cloud-infrastructure-journey"

notes_content = """# WEEK 17 NOTES — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

## 📌 Week Overview

Week 17 focused on mastering CloudWatch monitoring and alerting, CloudTrail auditing, AWS Config compliance, hybrid storage services, and cost optimization strategies for the AWS Solutions Architect Associate (SAA-C03) certification exam.

This week covered:

- Amazon CloudWatch
- CloudWatch Metrics
- CloudWatch Dimensions
- CloudWatch Alarms
- CloudWatch Dashboards
- Custom Metrics
- CloudWatch Logs Insights
- CloudWatch Agent
- Container Insights
- Metric Math
- Anomaly Detection
- AWS CloudTrail
- Management Events
- Data Events
- Insights Events
- Log File Validation
- AWS Config
- Configuration Recorder
- Config Rules
- AWS Security Hub
- Amazon EFS
- EFS Mount Targets
- EFS Storage Classes
- Amazon FSx
- FSx for Windows File Server
- FSx for Lustre
- FSx for NetApp ONTAP
- FSx for OpenZFS
- AWS Storage Gateway
- File Gateway
- Volume Gateway
- Tape Gateway
- AWS Snow Family
- Snowcone
- Snowball Edge
- Snowmobile
- AWS DataSync
- AWS Cost Explorer
- AWS Budgets
- AWS Compute Optimizer
- Reserved Instances
- S3 Cost Optimization
- Infracost

The goal of this week was to understand how to monitor AWS environments, ensure compliance, choose the right hybrid storage solutions, and optimize costs for exam scenarios.

---

# 🧠 Amazon CloudWatch

---

# 1️⃣ What is Amazon CloudWatch?

CloudWatch is a monitoring and observability service.

Purpose:

```text
Monitor Applications
Respond To System-Wide Performance Changes
Optimize Resource Utilization
Get Unified View Of Operational Health
```

Benefits:

```text
Visibility
Automation
Troubleshooting
```

---

# 2️⃣ CloudWatch Metrics Hierarchy

Namespace

```text
Container For CloudWatch Metrics
```

Example:

```text
AWS/EC2
```

Metric

```text
Fundamental Concept In CloudWatch
Represents A Time-Ordered Set Of Data Points
```

Example:

```text
CPUUtilization
```

Dimension

```text
Name/Value Pair That Partitions A Metric
```

Example:

```text
InstanceId
```

---

# 3️⃣ CloudWatch Alarms

Purpose:

```text
Watch A Single Metric
Perform Actions Based On Thresholds
```

Alarm States:

```text
OK
ALARM
INSUFFICIENT_DATA
```

Example Flow:

```text
EC2 CPU > 80% For 5 Minutes
        ↓
Trigger SNS Notification
        ↓
Trigger ASG Scale-Out
```

---

# 4️⃣ CloudWatch Dashboards

Purpose:

```text
Operations Overview
```

Widgets:

```text
EC2 CPU
RDS Connections
ALB Request Count
Lambda Error Rate
SQS Queue Depth
```

Benefits:

```text
Customizable Views
Cross-Region Visibility
Single Pane Of Glass
```

---

# 5️⃣ Custom Metrics

Publishing:

```text
cloudwatch.put_metric_data()
```

Example:

```text
Track Number Of Orders Processed Per Minute From Lambda
```

Limits:

```text
Standard Resolution: 1 Minute
High Resolution: 1 Second
```

---

# 6️⃣ CloudWatch Logs Insights

Purpose:

```text
Query Application Logs
```

Syntax:

```text
SQL-Like
```

Example Query:

```text
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20
```

Benefits:

```text
Invaluable For Debugging
Interactive Searching
```

---

# 7️⃣ CloudWatch Agent

Purpose:

```text
Collect System-Level Metrics & Logs
```

Installation:

```text
sudo yum install amazon-cloudwatch-agent
```

Metrics Not Available By Default:

```text
Memory Utilization
Disk Space/Usage
```

Configuration:

```text
JSON Config Wizard
```

---

# 8️⃣ Container Insights & Metric Math

Container Insights:

```text
EKS/ECS Metrics
Cluster Level
Node Level
Pod Level
Task Level
No Code Changes Needed
```

Metric Math:

```text
Calculate Single Widget Using Multiple Metrics
```

Example:

```text
Error Rate = Errors / Total Requests * 100
```

---

# 9️⃣ Anomaly Detection

Purpose:

```text
Baseline Metric Using Machine Learning
Detect Unusual Traffic Patterns Automatically
```

Benefits:

```text
Reduces False Positives
Adapts To Metric Trends Over Time
```

---

# 🧠 Auditing & Compliance

---

# 🔟 AWS CloudTrail

Purpose:

```text
Records EVERY API Call
Who
What
When
From Where
```

Event Types:

```text
Management Events
Data Events
Insights Events
```

---

# 1️⃣1️⃣ CloudTrail Trail Configuration

Best Practices:

```text
Enable In All Regions
Store In S3 Bucket
Server-Side Encryption (SSE-KMS)
Enable Log File Validation (Prevents Tampering)
Set Retention To 90 Days
```

---

# 1️⃣2️⃣ CloudWatch Metrics Filter + Alarm

Purpose:

```text
Alert On Specific Log Events
```

Example (Root Account Usage):

```json
{$.userIdentity.type = 'Root'}
```

AWS Recommendation:

```text
Security Hub Recommended Alarm
```

---

# 1️⃣3️⃣ AWS Config

Purpose:

```text
Continuous Compliance Monitoring
Records Configuration Changes Over Time
```

Config Rules:

```text
EC2_INSTANCE_NO_PUBLIC_IP
```

Result:

```text
Any EC2 With Public IP Triggers NON_COMPLIANT
```

---

# 1️⃣4️⃣ AWS Security Hub

Purpose:

```text
Aggregates Findings
```

Sources:

```text
GuardDuty
Config
Inspector
Macie
```

Benefits:

```text
Security Score For Account
Remediate Critical Findings
```

---

# 🧠 Hybrid Storage

---

# 1️⃣5️⃣ Amazon EFS (Elastic File System)

Purpose:

```text
Fully Managed NFS File System
```

Characteristics:

```text
Scales Automatically
Shared Access From Multiple EC2 Instances SIMULTANEOUSLY
Different From EBS (Which Attaches To One Instance)
```

---

# 1️⃣6️⃣ EFS Configuration

Mount Targets:

```text
In Each AZ Of Your VPC
```

Security Group:

```text
Allow NFS (Port 2049) From EC2 Security Group
```

Mount Command:

```text
sudo mount -t efs fs-XXXXXXXX:/ /mnt/efs
```

---

# 1️⃣7️⃣ EFS Storage Classes

Standard:

```text
Frequent Access
```

EFS-IA (Infrequent Access):

```text
92% Cheaper
```

Lifecycle Management:

```text
Files Not Accessed In 30 Days Automatically Move To IA
```

---

# 1️⃣8️⃣ Amazon FSx Family

FSx for Windows File Server:

```text
SMB Protocol
AD Integration
For Windows Workloads
```

FSx for Lustre:

```text
High-Performance
Integrates With S3
For ML Training Data
```

Other Flavors:

```text
FSx for NetApp ONTAP
FSx for OpenZFS
```

---

# 1️⃣9️⃣ AWS Storage Gateway

Purpose:

```text
Hybrid Storage Bridge Between On-Premises And AWS
```

Types:

```text
File Gateway
Volume Gateway
Tape Gateway
```

---

# 2️⃣0️⃣ File Gateway

Protocols:

```text
NFS / SMB To S3
```

Use Case:

```text
On-Premises Applications Write Files To NFS Share
Storage Gateway Uploads To S3 Asynchronously
Popular For Backup And Archival Scenarios
```

---

# 2️⃣1️⃣ Volume Gateway

Protocols:

```text
iSCSI Block Storage
```

Modes:

```text
Cached Volume
Stored Volume
```

---

# 2️⃣2️⃣ AWS Snow Family

Purpose:

```text
Large-Scale Data Migration
When Internet Bandwidth Is Insufficient
```

Snowcone:

```text
8TB / 14TB
Smallest
```

Snowball Edge Storage Optimized:

```text
80TB
```

Snowball Edge Compute Optimized:

```text
28TB + GPU
```

Snowmobile:

```text
100PB (A Truck)
```

---

# 2️⃣3️⃣ Snow Family Rule of Thumb

Rule:

```text
If Data Transfer Via Internet Takes > 1 Week, Use Snowball
```

Calculate:

```text
1TB At 100Mbps Takes ~22 Hours
100TB Takes ~92 Days (Snowball Wins)
```

---

# 2️⃣4️⃣ AWS DataSync

Purpose:

```text
Online Data Transfer Service
```

Migrate Data From:

```text
On-Premises NFS/SMB/HDFS
```

Migrate Data To:

```text
S3 / EFS / FSx
```

Characteristics:

```text
Faster Than Standard File Copy
Uses Agents
Schedules Transfers Automatically
```

---

# 🧠 Cost Optimization

---

# 2️⃣5️⃣ AWS Cost Explorer

Purpose:

```text
Analyze Spending
```

Filters:

```text
By Service
By Region
By Tag
By Usage Type
```

---

# 2️⃣6️⃣ AWS Budgets

Purpose:

```text
Set Monthly Budgets
SNS Alerts
```

Command:

```text
aws budgets create-budget
```

Alerting:

```text
Alert At 80% And 100% Of Monthly Budget
```

---

# 2️⃣7️⃣ AWS Compute Optimizer

Purpose:

```text
Analyzes Usage Patterns
Recommends Right-Sizing
```

Supports:

```text
EC2
Lambda
EBS
ECS
```

Cost:

```text
Free To Enable
```

---

# 2️⃣8️⃣ Reserved Instance Strategy

Standard RIs (1-Year):

```text
For Baseline Load (Always-On Workloads)
Production EC2 And RDS
```

On-Demand:

```text
For Peaks
```

Spot:

```text
For Batch / ML Training
```

---

# 2️⃣9️⃣ S3 Cost Optimization

S3 Intelligent-Tiering:

```text
For Data With Unknown Access Patterns
```

Lifecycle Policies:

```text
Set On ALL Buckets
```

S3 Storage Lens:

```text
Identify Waste
```

---

# 3️⃣0️⃣ Infracost

Purpose:

```text
Cost Estimation For Terraform
```

Usage:

```text
infracost breakdown --path .
```

Benefits:

```text
Shows Monthly Cost Estimate Before Applying
Critical For Responsible Cloud Engineering
```

---

# 🧠 Week 17 Review

---

# 3️⃣1️⃣ SAA Domain Coverage Check

Domains:

```text
Domain 1 (Secure Architectures 30%)
Domain 2 (Resilient Architectures 26%)
Domain 3 (High-Performing Architectures 24%)
Domain 4 (Cost-Optimized Architectures 20%)
```

---

# 3️⃣2️⃣ Targeted Deep-Dive

Action:

```text
Identify Top 3 Weak Areas
2-Hour Deep-Dive On Weakest Topic Using AWS Documentation
```

---

# 3️⃣3️⃣ Practice Exams

Action:

```text
Full 65-Question Timed SAA Practice Exam
Tutorials Dojo
130 Minutes
Record Score And Every Incorrect Answer
```

---

# 3️⃣4️⃣ Final Review

Action:

```text
Review All Anki Flashcards (Weeks 11-17)
Write 1-Page Study Summary For Each SAA Domain
```
"""

resources_content = """# WEEK 17 RESOURCES — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

## 📌 Week Objective

Master CloudWatch monitoring and alerting, CloudTrail auditing, AWS Config compliance, hybrid storage services (EFS, FSx, Storage Gateway, Snowball), and cost optimization strategies that frequently appear in AWS Solutions Architect Associate (SAA-C03) exam scenarios.

Focus Areas:

- Amazon CloudWatch
- AWS CloudTrail
- AWS Config
- Amazon EFS
- Amazon FSx
- AWS Storage Gateway
- AWS Snow Family
- Cost Optimization Tools
- SAA Exam Practice

---

# 📚 Primary Learning Resources

---

## 1️⃣ Stephane Maarek AWS Solutions Architect Associate Course

### Sections To Complete

```text
Monitoring & Audit (CloudWatch, CloudTrail, Config)

Storage Extras (EFS, FSx, Storage Gateway, Snow Family)

Cost Management
```

### Why This Resource?

```text
Best SAA-C03 Course

Exam-Oriented

Real AWS Demonstrations

Architecture Explanations

Hands-On Labs
```

### Goal

```text
Complete All Week 17 Sections

Take Notes

Create Flashcards
```

---

## 2️⃣ Jon Bonso / Tutorials Dojo Practice Exams

### Focus Areas

```text
CloudWatch Alarms

CloudTrail Use Cases

EFS vs EBS

FSx Selection

Storage Gateway Types

Snow Family Calculation

Cost Optimization
```

### Goal

```text
Full 65-Question Timed Exam

Review Wrong Answers

Understand AWS Logic
```

### Why This Resource?

```text
Closest To Real Exam Questions

Detailed Explanations

Architecture-Based Questions
```

---

# 📖 AWS Documentation

---

## 3️⃣ Amazon CloudWatch Documentation

Topics:

```text
Metrics

Alarms

Dashboards

CloudWatch Agent

Logs Insights

Container Insights
```

Study:

```text
Namespace / Metric / Dimension

Alarm States

Custom Metrics
```

---

## 4️⃣ AWS CloudTrail Documentation

Topics:

```text
Management Events

Data Events

Insights Events

Trail Configuration
```

Study:

```text
Log File Validation

S3 KMS Encryption

Event History
```

---

## 5️⃣ AWS Config Documentation

Topics:

```text
Configuration Recorder

Config Rules

Conformance Packs
```

Important Exam Topics:

```text
Continuous Compliance

Remediation Actions
```

---

## 6️⃣ Amazon EFS & FSx Documentation

Topics:

```text
EFS Storage Classes

EFS Lifecycle Management

FSx for Windows File Server

FSx for Lustre
```

Important Concepts:

```text
Simultaneous Access

SMB vs NFS

Machine Learning Workloads
```

---

## 7️⃣ AWS Storage Gateway Documentation

Topics:

```text
File Gateway

Volume Gateway

Tape Gateway
```

Important Concepts:

```text
Hybrid Cloud

NFS/SMB to S3

iSCSI Block Storage
```

---

## 8️⃣ AWS Snow Family Documentation

Topics:

```text
Snowcone

Snowball Edge

Snowmobile
```

Important Concepts:

```text
Migration Rules Of Thumb

Offline Data Transfer
```

---

## 9️⃣ Cost Optimization Whitepapers

Topics:

```text
AWS Well-Architected Framework

Cost Optimization Pillar
```

Important Concepts:

```text
Right-Sizing

Reserved Instances

Spot Instances
```

---

# 🎥 YouTube Resources

---

## 1️⃣ AWS In 10 Minutes — CloudWatch

Study:

```text
Metrics

Alarms

Logs
```

---

## 2️⃣ Be A Better Dev — CloudTrail Explained

Study:

```text
Audit Logging

Security Events

Compliance
```

---

## 3️⃣ TechWorld with Nana — Storage Gateway

Study:

```text
Hybrid Storage

File vs Volume Gateway
```

---

## 4️⃣ AWS Tutorials — Cost Explorer & Budgets

Study:

```text
Cost Tracking

Billing Alarms
```

---

# 🧪 Hands-On Labs

---

## Lab 1 — CloudWatch Alarms & Dashboards

Build:

```text
CloudWatch Dashboard

EC2 CPU Alarm

SNS Notification
```

Practice:

```text
Simulate High CPU

Verify Alarm State
```

---

## Lab 2 — CloudWatch Agent Setup

Build:

```text
EC2 Instance

IAM Role

CloudWatch Agent Config
```

Practice:

```text
View Memory Utilization

View Disk Space
```

---

## Lab 3 — CloudTrail & Config

Build:

```text
CloudTrail Trail

S3 Bucket (SSE-KMS)

AWS Config Rule
```

Practice:

```text
Test EC2_INSTANCE_NO_PUBLIC_IP Rule
```

---

## Lab 4 — Amazon EFS

Build:

```text
EFS File System

2 EC2 Instances

Mount Targets
```

Practice:

```text
Mount EFS Concurrently

Create Shared Files
```

---

## Lab 5 — Cost Optimization

Build:

```text
AWS Cost Explorer

AWS Budgets

Infracost (Local)
```

Practice:

```text
Set 80% Budget Alert

Run Infracost Breakdown
```

---

# 🧠 Flashcard Topics

Create Flashcards For:

```text
CloudWatch Metric Hierarchy

Alarm States

CloudWatch Agent Default Metrics

CloudTrail Management vs Data Events

AWS Config Rules

EFS Standard vs IA

FSx for Windows vs Lustre

File vs Volume Gateway

Snowball Edge Capacity

AWS Compute Optimizer
```

Goal:

```text
25 Flashcards
```

---

# 📝 Exam Focus Topics

Most Important Week 17 Topics:

```text
EBS vs EFS

FSx Selection

Storage Gateway Types

Snow Family Calculation

CloudWatch vs CloudTrail

Reserved Instances Strategy

S3 Lifecycle Policies
```

---

# 🎯 Week 17 Success Criteria

Complete:

```text
Stephane Maarek Sections

AWS Documentation Review

Full Timed Practice Exam

25 Flashcards

5 Hands-On Labs

Domain Coverage Check
```

---

# 🚀 Final Outcome

By the end of Week 17, be able to:

- Monitor AWS resources effectively
- Audit API activity across the account
- Implement continuous compliance
- Design hybrid storage architectures
- Execute large-scale data migrations
- Optimize AWS costs structurally
- Pass SAA-C03 mock exams
"""

roadmap_content = """# WEEK 17 ROADMAP — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

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
"""

recap_content = """# WEEK 17 RECAP — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

## 📌 Week Overview

Week 17 focused on mastering CloudWatch monitoring and alerting, CloudTrail auditing, AWS Config compliance, hybrid storage services (EFS, FSx, Storage Gateway, Snowball), and cost optimization strategies for the AWS Solutions Architect Associate (SAA-C03) certification exam.

This week covered:

- Amazon CloudWatch
- CloudWatch Agent
- CloudWatch Dashboards
- CloudWatch Alarms
- CloudWatch Logs Insights
- Container Insights
- Metric Math
- Anomaly Detection
- AWS CloudTrail
- Management vs Data Events
- Log File Validation
- AWS Config
- Config Rules
- AWS Security Hub
- Amazon EFS
- EFS Storage Classes
- Amazon FSx
- FSx for Windows
- FSx for Lustre
- AWS Storage Gateway
- File Gateway
- Volume Gateway
- Tape Gateway
- AWS Snow Family
- AWS DataSync
- AWS Cost Explorer
- AWS Budgets
- AWS Compute Optimizer
- Reserved Instances
- S3 Cost Optimization
- Infracost

The goal of this week was to understand how to monitor systems, enforce compliance, configure hybrid storage, and optimize costs, concluding the core SAA-C03 service knowledge.

---

# 🧠 Monitoring & Compliance

---

# 1️⃣ Amazon CloudWatch

```text
Hierarchy: Namespace → Metric → Dimension
Dashboards: Combine metrics into a single view
Alarms: OK, ALARM, INSUFFICIENT_DATA
Custom Metrics: cloudwatch.put_metric_data()
```

---

# 2️⃣ CloudWatch Agent & Insights

```text
CloudWatch Agent: Collect Memory & Disk Usage
Logs Insights: SQL-like querying for log data
Container Insights: Native monitoring for EKS/ECS
Anomaly Detection: ML-baselining for unusual traffic
```

---

# 3️⃣ AWS CloudTrail & Config

```text
CloudTrail: Audits WHO, WHAT, WHEN, WHERE for API calls
CloudTrail Trails: Store in S3 with Log File Validation
AWS Config: Continuous configuration state compliance
Security Hub: Centralized security posture management
```

---

# 🧠 Hybrid Storage

---

# 4️⃣ Amazon EFS (Elastic File System)

```text
Multi-AZ, scalable NFS file system
Mountable to multiple EC2 instances simultaneously
Standard and EFS-IA storage classes
Lifecycle rules to shift files to EFS-IA
```

---

# 5️⃣ Amazon FSx

```text
FSx for Windows: SMB Protocol, AD Integration
FSx for Lustre: High performance for ML/HPC, S3 linked
```

---

# 6️⃣ AWS Storage Gateway

```text
File Gateway: NFS/SMB to S3
Volume Gateway: iSCSI block storage
Tape Gateway: Virtual tape backups
```

---

# 7️⃣ AWS Snow Family & DataSync

```text
Use Snowball when Internet transfer takes > 1 week
Snowcone: Small/Edge
Snowball Edge: Storage / Compute
Snowmobile: Exabyte scale migration (Truck)
DataSync: Online data transfer automation
```

---

# 🧠 Cost Optimization

---

# 8️⃣ Cost Management Tools

```text
AWS Cost Explorer: Visualize, understand, and manage costs
AWS Budgets: Alerting based on spending thresholds
AWS Compute Optimizer: ML-driven right-sizing recommendations
Infracost: Terraform pull-request cost estimation
```

---

# 9️⃣ Compute & Storage Cost Strategies

```text
Compute: Baseline with RIs, Peak with On-Demand, Batch with Spot
S3: Intelligent-Tiering for unknown patterns, Lifecycle policies
```

---

# 🏗️ Week 17 Architecture Pattern

```text
On-Premises
    ↓
AWS Storage Gateway (File Gateway)
    ↓
Amazon S3
    ↓
Lifecycle Policy → Glacier
```

This architecture appears frequently in AWS Solutions Architect Associate exam scenarios involving hybrid backup.

---

# 🔥 Most Important Week 17 Exam Concepts

## CloudWatch vs CloudTrail

```text
CloudWatch = Performance Monitoring
CloudTrail = API Auditing
```

---

## EFS vs EBS

```text
EFS = Multi-Attach, NFS, Network Based
EBS = Single-Attach, Block Storage, AZ Bound
```

---

## Storage Gateway Selection

```text
Need S3 Files? = File Gateway
Need Block Storage? = Volume Gateway
Need Tape Backups? = Tape Gateway
```

---

## Data Migration Selection

```text
Over Internet? = DataSync
Too Slow For Internet? = Snowball Edge
Exabyte Scale? = Snowmobile
```

---

# 🎯 End-of-Week Outcome

By the end of Week 17, be able to:

- Setup CloudWatch alarms, dashboards, and the CloudWatch agent.
- Understand the difference between CloudTrail, CloudWatch, and AWS Config.
- Choose between EBS, EFS, FSx, and S3 based on use cases.
- Select the correct Storage Gateway or Snow Family device for migrations.
- Apply AWS Cost Optimization pillars to architectures.
- Take and review full SAA practice exams with confidence.
"""

def write_file(path, content):
    with open(os.path.join(base_dir, path), "w", encoding="utf-8") as f:
        f.write(content)

write_file(r"notes\week-017.md", notes_content)
write_file(r"resources\week-017.md", resources_content)
write_file(r"roadmap\week-017.md", roadmap_content)
write_file(r"recap\week-017.md", recap_content)
