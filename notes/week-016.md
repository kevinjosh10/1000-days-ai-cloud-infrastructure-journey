# WEEK 16 NOTES — AWS SAA EXAM PREP II: ELB, AUTO SCALING, LAMBDA & MESSAGING

## 📌 Week Overview

Week 16 focused on mastering AWS high availability, scalability, serverless computing and messaging services for the AWS Solutions Architect Associate (SAA-C03) certification exam.

This week covered:

- Elastic Load Balancing (ELB)
- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Classic Load Balancer (CLB)
- Target Groups
- Health Checks
- Host-Based Routing
- Path-Based Routing
- Auto Scaling Groups (ASG)
- Launch Templates
- Scaling Policies
- Lifecycle Hooks
- AWS Lambda
- Lambda Triggers
- Lambda Layers
- Lambda Container Images
- API Gateway
- REST APIs
- HTTP APIs
- WebSocket APIs
- API Gateway Stages
- API Gateway Throttling
- Lambda Proxy Integration
- Amazon SQS
- Standard Queues
- FIFO Queues
- Visibility Timeout
- Dead Letter Queues
- Amazon SNS
- SNS Fan-Out Pattern
- Amazon EventBridge
- Event Routing
- Event-Driven Architectures
- Serverless Architecture Patterns
- High Availability Design
- AWS Exam Decision Frameworks

The goal of this week was to understand how scalable, highly available and event-driven architectures are built on AWS and how to identify the correct services during AWS Solutions Architect Associate exam scenarios.

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
Health Checks
Traffic Distribution
Automatic Scaling Integration
```

---

# 2️⃣ Load Balancer Types

---

## Classic Load Balancer (CLB)

Legacy Load Balancer.

Supports:

```text
HTTP
HTTPS
TCP
SSL
```

Status:

```text
Deprecated
Avoid For New Deployments
```

---

## Application Load Balancer (ALB)

Layer:

```text
Layer 7
```

Protocols:

```text
HTTP
HTTPS
WebSocket
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

Layer:

```text
Layer 4
```

Protocols:

```text
TCP
UDP
TLS
```

Best For:

```text
Gaming
IoT
Real-Time Streaming
Extreme Performance
```

---

# 3️⃣ ALB Architecture

```text
Users
   ↓
ALB
   ↓
Target Group
   ↓
EC2 Instances
```

Benefits:

- Layer 7 Awareness
- Intelligent Routing
- Microservice Friendly

---

# 4️⃣ Host-Based Routing

Purpose:

Route based on hostname.

Example:

```text
api.example.com
        ↓
API Target Group

www.example.com
        ↓
Web Target Group
```

---

## Exam Trigger Words

```text
Multiple Domains
Same Load Balancer
```

Answer:

```text
Host-Based Routing
```

---

# 5️⃣ Path-Based Routing

Purpose:

Route based on URL path.

Example:

```text
/api/*
      ↓
Backend Service

/images/*
      ↓
Image Service
```

---

## Exam Trigger Words

```text
Microservices
Different Paths
Single Domain
```

Answer:

```text
Path-Based Routing
```

---

# 6️⃣ Sticky Sessions

Purpose:

```text
User Returns To Same Server
```

Benefits:

```text
Session Persistence
```

Use Cases:

```text
Legacy Applications
Shopping Carts
```

---

# 7️⃣ ALB Authentication

Supports:

```text
Amazon Cognito
OIDC
```

Benefits:

```text
Centralized Authentication
```

---

# 8️⃣ NLB Features

Characteristics:

```text
Millions Of Requests Per Second
Preserves Source IP
Static IP Address
Ultra Low Latency
```

---

# 9️⃣ Global Accelerator Integration

Architecture:

```text
Users
   ↓
Global Accelerator
   ↓
NLB
   ↓
Application
```

Benefits:

```text
Global Performance
Fast Failover
```

---

# 🔟 Health Checks

Purpose:

```text
Detect Unhealthy Targets
```

Example:

```text
/health
```

Flow:

```text
Healthy?
    ↓
Yes → Receive Traffic

No → Removed
```

---

# 🧠 Auto Scaling Groups

---

# 1️⃣1️⃣ What is Auto Scaling?

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

# 1️⃣2️⃣ ASG Capacity Settings

Minimum Capacity

```text
Lowest Instance Count
```

Desired Capacity

```text
Target Instance Count
```

Maximum Capacity

```text
Highest Instance Count
```

---

# 1️⃣3️⃣ Launch Templates

Modern replacement for:

```text
Launch Configurations
```

Contains:

```text
AMI
Instance Type
Security Groups
IAM Role
User Data
EBS Configuration
```

---

# 1️⃣4️⃣ Target Tracking Scaling

Purpose:

```text
Maintain Target Metric
```

Example:

```text
70% CPU
```

Most Recommended Policy.

---

# 1️⃣5️⃣ Step Scaling

Example:

```text
CPU > 70%
Add 2 Instances

CPU > 90%
Add 5 Instances
```

---

# 1️⃣6️⃣ Scheduled Scaling

Example:

```text
Scale Up → 9 AM

Scale Down → 7 PM
```

Best For:

```text
Predictable Workloads
```

---

# 1️⃣7️⃣ Cooldown Period

Default:

```text
300 Seconds
```

Purpose:

```text
Prevent Scaling Thrashing
```

---

# 1️⃣8️⃣ Lifecycle Hooks

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

# 1️⃣9️⃣ What is Lambda?

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

# 2️⃣0️⃣ Lambda Characteristics

Benefits:

```text
Pay Per Use
Automatic Scaling
No Server Management
```

Billing:

```text
Per Millisecond
```

---

# 2️⃣1️⃣ Lambda Configuration

Runtime Examples:

```text
Python 3.12
Node.js
Java
Go
```

---

Memory:

```text
128 MB → 10 GB
```

---

Timeout:

```text
15 Minutes Maximum
```

---

# 2️⃣2️⃣ Lambda Triggers

Examples:

```text
S3
SQS
SNS
API Gateway
DynamoDB Streams
EventBridge
ALB
```

---

# 2️⃣3️⃣ Lambda Layers

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

# 2️⃣4️⃣ Lambda Container Images

Maximum Size:

```text
10 GB
```

Benefits:

```text
Custom Runtime
Large Dependencies
```

---

# 🧠 API Gateway

---

# 2️⃣5️⃣ API Gateway Types

REST API

```text
Full Features
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

# 2️⃣6️⃣ API Architecture

```text
Client
   ↓
API Gateway
   ↓
Lambda
   ↓
DynamoDB
```

---

# 2️⃣7️⃣ API Gateway Stages

Examples:

```text
Dev
Staging
Production
```

Benefits:

```text
Environment Isolation
```

---

# 2️⃣8️⃣ API Gateway Features

```text
Request Validation
Mapping Templates
API Keys
Usage Plans
Throttling
```

---

# 2️⃣9️⃣ Lambda Proxy Integration

Flow:

```text
Entire Request
      ↓
Lambda
      ↓
Entire Response
```

Benefits:

```text
Simplified Development
```

---

# 🧠 Amazon SQS

---

# 3️⃣0️⃣ What is SQS?

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

# 3️⃣1️⃣ Standard Queue

Characteristics:

```text
Unlimited Throughput
At Least Once Delivery
Best Effort Ordering
```

---

# 3️⃣2️⃣ FIFO Queue

Characteristics:

```text
Exactly Once Processing
Strict Ordering
```

---

# 3️⃣3️⃣ Visibility Timeout

Default:

```text
30 Seconds
```

Maximum:

```text
12 Hours
```

Purpose:

```text
Prevent Duplicate Processing
```

---

# 3️⃣4️⃣ Dead Letter Queues

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

# 3️⃣5️⃣ What is SNS?

Purpose:

```text
Pub/Sub Messaging
```

Pattern:

```text
Fan-Out
```

---

# 3️⃣6️⃣ SNS Subscribers

Examples:

```text
SQS
Lambda
Email
SMS
HTTP
```

---

# 3️⃣7️⃣ SNS Fan-Out Pattern

```text
Publisher
    ↓
 SNS Topic
 ↙    ↓    ↘
SQS Lambda Email
```

---

# 3️⃣8️⃣ What is EventBridge?

Purpose:

```text
Event Routing
```

Benefits:

```text
Advanced Filtering
Scheduled Events
Cross-Service Events
```

---

# 3️⃣9️⃣ EventBridge Rules

Architecture:

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

# 4️⃣0️⃣ Event-Driven Architectures

Architecture:

```text
Event Producer
        ↓
EventBridge
        ↓
Consumers
```

Benefits:

```text
Loose Coupling
Scalability
Flexibility
```

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
Extreme Performance
```

---

## ASG

```text
Automatic Scaling
Desired Capacity
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
```

---

# 🚀 Week 16 Outcome

By the end of Week 16, built understanding of:

- Elastic Load Balancing
- ALB
- NLB
- Target Groups
- Health Checks
- Auto Scaling Groups
- Launch Templates
- Scaling Policies
- Lifecycle Hooks
- AWS Lambda
- Lambda Layers
- Lambda Triggers
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
- High Availability Patterns

---

# 📚 Week 16 Summary

Week 16 established the scalability, serverless and messaging foundation required for AWS Solutions Architect Associate certification.

This week transformed knowledge from:

- Deploying individual AWS services

Into:

- Designing highly available, event-driven, auto-scaling and serverless architectures capable of handling production-scale workloads and AWS exam scenarios.