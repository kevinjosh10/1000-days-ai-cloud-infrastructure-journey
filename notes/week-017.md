# WEEK 17 NOTES — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

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
