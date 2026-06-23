# WEEK 16 RECAP — AWS SAA EXAM PREP II: ELB, AUTO SCALING, LAMBDA & MESSAGING

## 📌 Week Overview

Week 16 focused on mastering AWS scalability, high availability, serverless computing and event-driven architectures for the AWS Solutions Architect Associate (SAA-C03) certification exam.

This week covered:

- Elastic Load Balancing (ELB)
- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Classic Load Balancer (CLB)
- Host-Based Routing
- Path-Based Routing
- Health Checks
- Target Groups
- Auto Scaling Groups (ASG)
- Launch Templates
- Scaling Policies
- Lifecycle Hooks
- AWS Lambda
- Lambda Layers
- Lambda Triggers
- Lambda Container Images
- API Gateway
- REST APIs
- HTTP APIs
- WebSocket APIs
- Amazon SQS
- Standard Queues
- FIFO Queues
- Visibility Timeout
- Dead Letter Queues
- Amazon SNS
- Fan-Out Architectures
- Amazon EventBridge
- Event Routing
- Event-Driven Architectures
- Serverless Architectures
- High Availability Architectures

The goal of this week was to understand how AWS applications scale automatically, distribute traffic efficiently, process events asynchronously and operate without managing servers.

---

# 🧠 Elastic Load Balancing (ELB)

---

# 1️⃣ What is Elastic Load Balancing?

Elastic Load Balancing distributes incoming traffic across multiple targets.

Purpose:

```text
High Availability
Fault Tolerance
Scalability
```

Benefits:

```text
Traffic Distribution
Health Monitoring
Automatic Failover
```

---

# 2️⃣ Load Balancer Types

---

## Classic Load Balancer (CLB)

```text
Legacy Load Balancer
Deprecated For New Architectures
```

Supports:

```text
HTTP
HTTPS
TCP
SSL
```

---

## Application Load Balancer (ALB)

```text
Layer 7
```

Supports:

```text
HTTP
HTTPS
WebSockets
gRPC
```

Best For:

```text
Web Applications
Microservices
Containers
```

---

## Network Load Balancer (NLB)

```text
Layer 4
```

Supports:

```text
TCP
UDP
TLS
```

Best For:

```text
Gaming
IoT
Streaming
High Performance Systems
```

---

# 3️⃣ ALB Features

---

## Host-Based Routing

```text
api.example.com
        ↓
API Service

www.example.com
        ↓
Frontend Service
```

---

## Path-Based Routing

```text
/api/*
      ↓
Backend

/*
      ↓
Frontend
```

---

## Sticky Sessions

```text
User Returns To Same Instance
```

---

## Authentication

Supports:

```text
Amazon Cognito
OIDC
```

---

# 4️⃣ NLB Features

Characteristics:

```text
Millions Of Requests Per Second
Preserves Source IP
Static IP Address
Ultra Low Latency
```

---

# 5️⃣ Health Checks

Purpose:

```text
Detect Unhealthy Instances
```

Flow:

```text
Healthy?
   ↓
Yes → Receive Traffic

No → Removed
```

---

# 🧠 Auto Scaling Groups (ASG)

---

# 6️⃣ What is Auto Scaling?

Purpose:

```text
Automatic Capacity Management
```

Benefits:

```text
Cost Optimization
High Availability
Elasticity
```

---

# 7️⃣ ASG Capacity Settings

Minimum Capacity

```text
Lowest Number Of Instances
```

Desired Capacity

```text
Target Number Of Instances
```

Maximum Capacity

```text
Highest Number Of Instances
```

---

# 8️⃣ Launch Templates

Contains:

```text
AMI
Instance Type
Security Groups
IAM Role
User Data
EBS Volumes
```

Modern replacement for:

```text
Launch Configurations
```

---

# 9️⃣ Target Tracking Policy

Example:

```text
Maintain CPU At 70%
```

AWS automatically:

```text
Scale Out
Scale In
```

Recommended policy.

---

# 🔟 Step Scaling

Example:

```text
CPU > 70%
Add 2 Instances

CPU > 90%
Add 5 Instances
```

---

# 1️⃣1️⃣ Scheduled Scaling

Example:

```text
Scale Up At 9 AM

Scale Down At 7 PM
```

Best For:

```text
Predictable Traffic
```

---

# 1️⃣2️⃣ Cooldown Period

Default:

```text
300 Seconds
```

Purpose:

```text
Prevent Rapid Scaling
```

---

# 1️⃣3️⃣ Lifecycle Hooks

States:

```text
Pending:Wait

Terminating:Wait
```

Use Cases:

```text
Backup
Log Collection
Connection Draining
```

---

# 🧠 AWS Lambda

---

# 1️⃣4️⃣ What is Lambda?

Purpose:

```text
Serverless Compute
```

AWS Handles:

```text
Infrastructure
Scaling
Patching
Availability
```

---

# 1️⃣5️⃣ Lambda Configuration

Runtime Examples:

```text
Python
Node.js
Java
Go
```

Memory:

```text
128 MB → 10 GB
```

Timeout:

```text
Maximum 15 Minutes
```

---

# 1️⃣6️⃣ Lambda Triggers

Examples:

```text
S3
SQS
SNS
API Gateway
EventBridge
ALB
DynamoDB Streams
```

---

# 1️⃣7️⃣ Lambda Layers

Purpose:

```text
Reusable Dependencies
```

Examples:

```text
NumPy
Pandas
Shared Libraries
```

---

# 1️⃣8️⃣ Lambda Container Images

Maximum Size:

```text
10 GB
```

Benefits:

```text
Large Applications
Custom Runtimes
```

---

# 🧠 API Gateway

---

# 1️⃣9️⃣ API Gateway Types

REST API

```text
Most Features
```

HTTP API

```text
Lower Cost
Lower Latency
```

WebSocket API

```text
Real-Time Communication
```

---

# 2️⃣0️⃣ API Gateway Architecture

```text
Client
   ↓
API Gateway
   ↓
Lambda
   ↓
Database
```

---

# 2️⃣1️⃣ API Gateway Stages

Examples:

```text
Dev
Staging
Production
```

Purpose:

```text
Environment Separation
```

---

# 2️⃣2️⃣ API Gateway Features

```text
Request Validation
Usage Plans
API Keys
Throttling
Mapping Templates
```

---

# 2️⃣3️⃣ Lambda Proxy Integration

```text
Request
   ↓
Lambda
   ↓
Response
```

Benefits:

```text
Simplified Backend Logic
```

---

# 🧠 Amazon SQS

---

# 2️⃣4️⃣ What is SQS?

Purpose:

```text
Message Queue
```

Benefits:

```text
Decoupling
Reliability
Scalability
```

---

# 2️⃣5️⃣ Standard Queue

Characteristics:

```text
Unlimited Throughput
At-Least-Once Delivery
Best-Effort Ordering
```

---

# 2️⃣6️⃣ FIFO Queue

Characteristics:

```text
Exactly-Once Processing
Strict Ordering
```

---

# 2️⃣7️⃣ Visibility Timeout

Purpose:

```text
Prevent Duplicate Processing
```

Default:

```text
30 Seconds
```

Maximum:

```text
12 Hours
```

---

# 2️⃣8️⃣ Dead Letter Queue (DLQ)

Purpose:

```text
Store Failed Messages
```

Benefits:

```text
Debugging
Reliability
```

---

# 🧠 SNS & EventBridge

---

# 2️⃣9️⃣ Amazon SNS

Purpose:

```text
Pub/Sub Messaging
```

Pattern:

```text
Fan-Out
```

---

# 3️⃣0️⃣ SNS Subscribers

Examples:

```text
SQS
Lambda
Email
SMS
HTTP
```

---

# 3️⃣1️⃣ SNS Fan-Out Architecture

```text
Publisher
     ↓
SNS Topic
 ↙   ↓   ↘
SQS Lambda Email
```

---

# 3️⃣2️⃣ Amazon EventBridge

Purpose:

```text
Event Routing
```

Benefits:

```text
Filtering
Automation
Scheduling
```

---

# 3️⃣3️⃣ EventBridge Architecture

```text
Event
  ↓
Rule
  ↓
Target
```

Targets:

```text
Lambda
SNS
SQS
Step Functions
```

---

# 3️⃣4️⃣ Event-Driven Architecture

```text
Producer
    ↓
Event
    ↓
Consumer
```

Benefits:

```text
Loose Coupling
Scalability
Flexibility
```

---

# 🏗️ Week 16 Architecture Pattern

```text
Users
   ↓
CloudFront
   ↓
ALB
   ↓
Auto Scaling Group
   ↓
EC2 Instances
   ↓
RDS Multi-AZ

        ↓
   ElastiCache

        ↓
        S3
```

This architecture appears frequently in AWS Solutions Architect Associate exam scenarios.

---

# 🔥 Most Important Week 16 Exam Concepts

## ALB

```text
Layer 7
HTTP/HTTPS
Path Routing
Host Routing
```

---

## NLB

```text
Layer 4
TCP/UDP
Static IP
High Performance
```

---

## ASG

```text
Desired Capacity
Automatic Scaling
```

---

## Lambda

```text
Serverless
15 Minute Limit
```

---

## API Gateway

```text
Serverless APIs
```

---

## SQS

```text
Queue
Buffer
Decoupling
```

---

## SNS

```text
Fan-Out
Notifications
```

---

## EventBridge

```text
Event Routing
Rules
Automation
```

---

# 🚀 Week 16 Outcome

By the end of Week 16, built understanding of:

- Elastic Load Balancing
- ALB
- NLB
- Host Routing
- Path Routing
- Auto Scaling Groups
- Launch Templates
- Scaling Policies
- Lifecycle Hooks
- AWS Lambda
- Lambda Layers
- API Gateway
- REST APIs
- HTTP APIs
- SQS
- FIFO Queues
- DLQs
- SNS
- EventBridge
- Event-Driven Architectures
- Serverless Architectures
- High Availability Design

---

# 📚 Week 16 Summary

Week 16 established the scalability, messaging and serverless foundation required for AWS Solutions Architect Associate certification.

This week transformed knowledge from:

- Running applications on servers

Into:

- Designing highly available, event-driven, auto-scaling and serverless cloud architectures capable of handling production workloads and AWS exam scenarios.