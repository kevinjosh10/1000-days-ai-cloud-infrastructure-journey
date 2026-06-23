# 🚀 WEEK 16 PROJECT — SERVERLESS ORDER PROCESSING SYSTEM

## 📌 Project Overview

Build a complete event-driven serverless application using AWS managed services.

The system receives customer orders through an API, processes them asynchronously, stores results in DynamoDB, and automatically sends notifications to users.

This project combines all major Week 16 concepts:

- API Gateway
- AWS Lambda
- Amazon SQS
- DynamoDB
- DynamoDB Streams
- Amazon SNS
- EventBridge
- Event-Driven Architecture

---

# 🎯 Project Objectives

By completing this project, learn how to:

- Build a Serverless REST API
- Process requests asynchronously
- Decouple services using SQS
- Trigger Lambda functions automatically
- Store data in DynamoDB
- Generate notifications using SNS
- Use DynamoDB Streams
- Implement EventBridge automation
- Design production-grade AWS architectures
- Practice AWS Solutions Architect patterns

---

# 🏗️ Final Architecture

```text
Client
   │
   ▼
API Gateway
   │
   ▼
Lambda (Order API)
   │
   ▼
SQS Queue
   │
   ▼
Lambda (Order Processor)
   │
   ▼
DynamoDB
   │
   ▼
DynamoDB Streams
   │
   ▼
Lambda (Notification Service)
   │
   ▼
SNS Topic
   │
   ▼
Email Subscriber
```

---

# 📋 Business Scenario

Imagine an E-Commerce platform.

Customer submits an order.

Instead of processing immediately:

- API receives request
- Queue stores request
- Background worker processes order
- Database stores results
- SNS sends notifications

This architecture provides:

```text
High Availability
Scalability
Reliability
Fault Tolerance
Loose Coupling
```

---

# 🧠 AWS SERVICES USED

---

# 1️⃣ API Gateway

Purpose:

```text
Expose REST API
```

Example Endpoint:

```http
POST /orders
```

Request:

```json
{
  "orderId": "1001",
  "customer": "Kevin",
  "product": "AWS Course"
}
```

Responsibilities:

- Authentication
- Request Routing
- Throttling
- Monitoring

---

# 2️⃣ Lambda Function (Order API)

Purpose:

```text
Receive Orders
Validate Data
Send To Queue
```

Flow:

```text
API Gateway
      ↓
 Lambda
      ↓
   SQS
```

Example:

```python
import boto3
import json

sqs = boto3.client('sqs')

def lambda_handler(event, context):

    body = json.loads(event['body'])

    sqs.send_message(
        QueueUrl='QUEUE_URL',
        MessageBody=json.dumps(body)
    )

    return {
        'statusCode': 200,
        'body': 'Order Accepted'
    }
```

---

# 3️⃣ Amazon SQS

Purpose:

```text
Decouple Services
Buffer Traffic
```

Benefits:

```text
Reliable
Durable
Scalable
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

# 4️⃣ Lambda Function (Order Processor)

Purpose:

```text
Read Queue Messages
Process Orders
Store Results
```

Flow:

```text
SQS
 ↓
Lambda
 ↓
DynamoDB
```

Example:

```python
import boto3
import json

table = boto3.resource(
    'dynamodb'
).Table('Orders')

def lambda_handler(event, context):

    for record in event['Records']:

        order = json.loads(
            record['body']
        )

        table.put_item(
            Item=order
        )
```

---

# 5️⃣ DynamoDB

Purpose:

```text
Store Orders
```

Table:

```text
Orders
```

Primary Key:

```text
orderId
```

Example Item:

```json
{
  "orderId": "1001",
  "customer": "Kevin",
  "product": "AWS Course",
  "status": "Completed"
}
```

Benefits:

```text
Serverless
Scalable
Millisecond Latency
```

---

# 6️⃣ DynamoDB Streams

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

# 7️⃣ Lambda Function (Notification Service)

Purpose:

```text
Receive Stream Event
Publish Notification
```

Flow:

```text
Streams
   ↓
Lambda
   ↓
SNS
```

Example:

```python
import boto3

sns = boto3.client('sns')

def lambda_handler(event, context):

    sns.publish(
        TopicArn='TOPIC_ARN',
        Subject='New Order',
        Message='Order Processed'
    )
```

---

# 8️⃣ Amazon SNS

Purpose:

```text
Fan-Out Notifications
```

Architecture:

```text
Lambda
   ↓
 SNS
   ↓
Email
```

Example Notification:

```text
Subject:
New Order Processed

Message:
Order 1001 Completed
```

---

# 9️⃣ EventBridge Automation

Purpose:

```text
Automated Event Handling
```

Example:

```text
Order Processed
      ↓
EventBridge Rule
      ↓
Lambda
```

Use Cases:

```text
Auditing
Monitoring
Reporting
Remediation
```

---

# 🔟 Security Configuration

IAM Roles:

```text
Lambda → SQS
Lambda → DynamoDB
Lambda → SNS
```

Principle:

```text
Least Privilege
```

---

# 📊 Monitoring

CloudWatch Metrics:

```text
Lambda Invocations
Lambda Errors
SQS Queue Depth
SNS Deliveries
DynamoDB Throughput
```

CloudWatch Alarms:

```text
Lambda Errors > 5
DLQ Messages > 0
```

---

# 🔥 Failure Handling

Dead Letter Queue:

```text
Main Queue
    ↓
 Failed
    ↓
  DLQ
```

Benefits:

```text
No Data Loss
Debugging
Reliability
```

---

# 🚀 Production Improvements

Add:

```text
CloudFront
WAF
Cognito
X-Ray
KMS Encryption
```

Benefits:

```text
Security
Performance
Observability
```

---

# 🏆 AWS SAA Concepts Covered

This project covers:

- API Gateway
- Lambda
- SQS
- SNS
- DynamoDB
- DynamoDB Streams
- EventBridge
- IAM
- CloudWatch
- DLQ
- Serverless Architecture
- Event-Driven Architecture
- High Availability Design

---

# 🎯 Learning Outcome

After completing this project, understand:

- How serverless applications work
- How AWS services communicate
- How event-driven architectures are designed
- How asynchronous processing improves scalability
- How notifications are automated
- How AWS architects build production systems

---

# 📚 Portfolio Description

Built a production-style Serverless Order Processing System using AWS API Gateway, Lambda, SQS, DynamoDB, DynamoDB Streams, SNS and EventBridge.

Implemented asynchronous message processing, event-driven notifications, automated workflows and highly scalable serverless architecture patterns commonly used in modern cloud-native applications and AWS Solutions Architect Associate exam scenarios.