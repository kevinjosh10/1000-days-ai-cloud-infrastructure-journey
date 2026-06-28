# WEEK 17 RECAP — AWS SAA EXAM PREP III: MONITORING, STORAGE & COST OPTIMIZATION

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
