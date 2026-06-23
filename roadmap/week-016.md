# WEEK 16 ROADMAP — AWS SAA EXAM PREP II: ELB, AUTO SCALING, LAMBDA & MESSAGING

## 🎯 Week Goal

Master AWS scalability, high availability, serverless computing and messaging services that frequently appear in AWS Solutions Architect Associate (SAA-C03) exam scenarios.

By the end of Week 16, be able to:

- Design highly available architectures
- Configure load balancers
- Implement Auto Scaling
- Build serverless applications
- Create event-driven architectures
- Use messaging services effectively
- Solve AWS architecture scenarios confidently

---

# 📅 Day 106 — Elastic Load Balancing (ELB)

## Topics

### Elastic Load Balancer Types

Study:

```text
Classic Load Balancer (CLB)

Application Load Balancer (ALB)

Network Load Balancer (NLB)
```

---

### Application Load Balancer

Learn:

```text
Layer 7 Routing

HTTP

HTTPS

WebSockets

gRPC
```

Practice:

```text
Host-Based Routing

Path-Based Routing

Sticky Sessions

Authentication
```

---

### Network Load Balancer

Learn:

```text
Layer 4

TCP

UDP

TLS

Static IP

Source IP Preservation
```

---

### Hands-On Lab

Build:

```text
ALB

Target Groups

Health Checks

Listeners

Routing Rules
```

Architecture:

```text
Users
  ↓
 ALB
  ↓
EC2 Instances
```

---

### Deliverables

```text
ALB Created

Target Groups Configured

Health Checks Tested

Routing Rules Implemented
```

---

# 📅 Day 107 — Auto Scaling Groups (ASG)

## Topics

### Auto Scaling Fundamentals

Study:

```text
Minimum Capacity

Desired Capacity

Maximum Capacity
```

---

### Launch Templates

Configure:

```text
AMI

Instance Type

Security Groups

IAM Role

User Data

EBS Volumes
```

---

### Scaling Policies

Study:

```text
Target Tracking

Step Scaling

Scheduled Scaling
```

---

### Lifecycle Hooks

Learn:

```text
Pending:Wait

Terminating:Wait
```

---

### Hands-On Lab

Build:

```text
Launch Template

Auto Scaling Group

CloudWatch Alarm

Scaling Policy
```

Architecture:

```text
CloudWatch
     ↓
 Auto Scaling
     ↓
 EC2 Fleet
```

---

### Deliverables

```text
Launch Template Created

ASG Configured

Scaling Tested

Lifecycle Hooks Reviewed
```

---

# 📅 Day 108 — AWS Lambda

## Topics

### Lambda Fundamentals

Study:

```text
Serverless Computing

Event-Driven Execution

Pay Per Use

Automatic Scaling
```

---

### Lambda Configuration

Learn:

```text
Runtime

Memory

Timeout

Environment Variables
```

---

### Lambda Triggers

Study:

```text
S3

SQS

SNS

API Gateway

EventBridge

DynamoDB Streams
```

---

### Lambda Layers

Learn:

```text
Reusable Dependencies

Shared Libraries
```

---

### Hands-On Lab

Build:

```text
Lambda Function

SQS Trigger

DynamoDB Integration
```

Architecture:

```text
SQS
 ↓
Lambda
 ↓
DynamoDB
```

---

### Deliverables

```text
Lambda Created

Trigger Configured

DynamoDB Integration Completed
```

---

# 📅 Day 109 — API Gateway

## Topics

### API Gateway Types

Study:

```text
REST API

HTTP API

WebSocket API
```

---

### REST API Design

Create:

```text
/users

/products

/orders
```

Methods:

```text
GET

POST

DELETE
```

---

### API Gateway Features

Study:

```text
Request Validation

Usage Plans

API Keys

Throttling

Stages
```

---

### Lambda Proxy Integration

Learn:

```text
Request

Response

Event Object

Status Codes
```

---

### Hands-On Lab

Build:

```text
API Gateway

Lambda Backend

HTTP Endpoint
```

Architecture:

```text
Client
  ↓
API Gateway
  ↓
Lambda
```

---

### Deliverables

```text
REST API Created

Lambda Integrated

API Tested
```

---

# 📅 Day 110 — Amazon SQS

## Topics

### SQS Fundamentals

Study:

```text
Queue-Based Messaging

Decoupling

Message Durability

At-Least-Once Delivery
```

---

### Queue Types

Learn:

```text
Standard Queue

FIFO Queue
```

---

### Visibility Timeout

Understand:

```text
Prevent Duplicate Processing
```

---

### Dead Letter Queue

Learn:

```text
Failed Message Handling

Production Best Practice
```

---

### Hands-On Lab

Build:

```text
Producer

SQS Queue

Consumer
```

Architecture:

```text
Producer
   ↓
 SQS
   ↓
Consumer
```

---

### Deliverables

```text
Queue Created

Producer Built

Consumer Built

DLQ Configured
```

---

# 📅 Day 111 — SNS & EventBridge

## Topics

### SNS Fundamentals

Study:

```text
Pub/Sub Messaging

Topics

Subscriptions

Fan-Out Pattern
```

---

### SNS Subscribers

Learn:

```text
Email

Lambda

SQS

SMS

HTTP
```

---

### EventBridge Fundamentals

Study:

```text
Event Buses

Rules

Targets

Event Patterns
```

---

### Scheduled Events

Learn:

```text
Cron Expressions

Automation
```

---

### Hands-On Lab

Build:

```text
SNS Topic

Email Subscription

EventBridge Rule

Lambda Target
```

Architecture:

```text
Event
  ↓
EventBridge
  ↓
Lambda
  ↓
SNS
```

---

### Deliverables

```text
SNS Topic Created

Email Notifications Working

EventBridge Rule Configured
```

---

# 📅 Day 112 — Week 16 Review Project

## Build Complete Serverless Architecture

Architecture:

```text
Client
   ↓
API Gateway
   ↓
Lambda
   ↓
SQS
   ↓
Lambda
   ↓
DynamoDB
   ↓
DynamoDB Streams
   ↓
Lambda
   ↓
SNS
   ↓
Email
```

---

## Features

Implement:

```text
REST API

Async Processing

Data Persistence

Notifications

Event Processing
```

---

## Architecture Diagram

Design:

```text
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

---

## Exam Preparation

Practice:

```text
25 SAA Questions

Review Weak Areas

Analyze Explanations
```

---

## Flashcards

Create:

```text
30 Flashcards
```

Topics:

```text
ALB vs NLB

ASG Policies

Lambda Limits

SQS vs SNS

EventBridge

DLQ

Visibility Timeout
```

---

# 🏆 Week Deliverables

Complete:

```text
1 Load Balancer Lab

1 Auto Scaling Lab

1 Lambda Lab

1 API Gateway Lab

1 SQS Lab

1 SNS Lab

1 EventBridge Lab

1 Serverless Project

25 Practice Questions

30 Flashcards
```

---

# 🎯 End-of-Week Outcome

By the end of Week 16, be able to:

- Explain ALB vs NLB
- Configure Auto Scaling Groups
- Build Lambda Functions
- Create REST APIs
- Process Messages Using SQS
- Send Notifications Using SNS
- Route Events Using EventBridge
- Design Serverless Architectures
- Build Event-Driven Systems
- Solve AWS SAA Architecture Scenarios Confidently

---

# 🚀 Progress Check

```text
Day 106 ✅ ELB

Day 107 ✅ ASG

Day 108 ✅ Lambda

Day 109 ✅ API Gateway

Day 110 ✅ SQS

Day 111 ✅ SNS & EventBridge

Day 112 ✅ Review Project
```

## Status

```text
Week 16 Complete

AWS SAA Exam Readiness Increased

Serverless & Messaging Foundation Established
```