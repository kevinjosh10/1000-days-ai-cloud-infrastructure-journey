# WEEK 13 ROADMAP — AWS CORE SERVICES III: IAM DEEP DIVE

## 📌 Week Overview

Week 13 focused on mastering AWS Identity and Access Management (IAM), one of the most important services in AWS and a critical topic for both the AWS Solutions Architect Associate (SAA) certification and real-world cloud engineering.

This week built the foundation for:

- AWS Security
- DevOps Engineering
- Cloud Governance
- Multi-Account Architectures
- Enterprise Authentication
- Kubernetes IAM Integration
- AI Cloud Infrastructure

---

# 🎯 Week Goal

Move from:

```text
Basic AWS User Management
```

To:

```text
Enterprise Identity & Access Management
```

By the end of the week, understand:

- Authentication
- Authorization
- Roles
- Policies
- STS
- Federation
- Governance
- Security Auditing

---

# 🗓️ Week 13 Learning Path

---

# Day 85 — IAM Core Concepts: Users, Groups & Policies

## Objectives

Learn:

- IAM hierarchy
- Root account security
- IAM users
- IAM groups
- IAM roles
- Managed policies
- Inline policies
- AWS IAM best practices

---

## Concepts Covered

```text
Root Account
     ↓
IAM Users
     ↓
IAM Groups
     ↓
Permissions
```

---

## Practical Tasks

- Create admin IAM user
- Enable MFA
- Generate access keys
- Create Developers group
- Create Ops group
- Create Admins group

---

## Outcome

Understand:

```text
Who Gets Access
```

Inside AWS.

---

# Day 86 — IAM Policy Structure & JSON Syntax

## Objectives

Learn:

- IAM policy structure
- JSON syntax
- ARN format
- Policy variables
- Conditions
- IAM Policy Simulator

---

## Concepts Covered

```json
{
  "Version": "2012-10-17",
  "Statement": []
}
```

---

## Practical Tasks

- Write S3 read policy
- Write bucket-specific policy
- Create user-specific S3 access
- Test policies using simulator

---

## Outcome

Understand:

```text
How Permissions Work
```

Inside AWS.

---

# Day 87 — IAM Roles: The Cloud Engineer's Most Important Tool

## Objectives

Learn:

- IAM roles
- STS
- Temporary credentials
- Instance profiles
- Cross-account access
- Trust policies

---

## Concepts Covered

```text
EC2
 ↓
Role
 ↓
STS
 ↓
Temporary Credentials
```

---

## Practical Tasks

- Create EC2 role
- Attach S3 permissions
- Retrieve temporary credentials
- Study trust policies
- Study cross-account access

---

## Outcome

Understand:

```text
How AWS Services Authenticate
```

Without access keys.

---

# Day 88 — Principle of Least Privilege & MFA

## Objectives

Learn:

- Least privilege
- MFA enforcement
- IAM Access Analyzer
- Credential Reports
- Security auditing

---

## Concepts Covered

```text
Minimum Required Permissions
```

---

## Practical Tasks

- Enable MFA
- Generate credential reports
- Review access keys
- Audit IAM users
- Study Access Analyzer

---

## Outcome

Understand:

```text
How To Secure IAM
```

Using best practices.

---

# Day 89 — Permission Boundaries & Service Control Policies

## Objectives

Learn:

- Permission Boundaries
- SCPs
- Effective permissions
- Governance controls
- Evaluation logic

---

## Concepts Covered

```text
Identity Policy
        ∩
Permission Boundary
        ↓
Effective Permissions
```

---

## Practical Tasks

- Create DevBoundary policy
- Restrict permissions
- Study AWS Organizations
- Review SCP examples

---

## Outcome

Understand:

```text
Enterprise Permission Governance
```

---

# Day 90 — IAM Roles for Services & Federation

## Objectives

Learn:

- Service-linked roles
- Lambda execution roles
- OIDC federation
- Cognito
- SAML federation
- Enterprise SSO

---

## Concepts Covered

```text
Identity Provider
       ↓
STS
       ↓
Temporary Credentials
```

---

## Practical Tasks

- Review service-linked roles
- Create Lambda role
- Study Cognito architecture
- Compare SAML vs OIDC
- Configure AWS CLI profiles

---

## Outcome

Understand:

```text
Modern Cloud Authentication
```

Architecture.

---

# Day 91 — IAM Security Audit & Review

## Objectives

Review everything learned during Week 13.

Perform:

- IAM audit
- MFA verification
- Policy review
- Access key review
- Governance validation
- IAM automation

---

## Concepts Covered

```text
Users
Groups
Roles
Policies
Permissions
      ↓
Audit
      ↓
Secure Environment
```

---

## Practical Tasks

### Security Audit

Verify:

```text
✓ MFA Enabled

✓ No Unused Access Keys

✓ No Wildcard Policies

✓ Least Privilege Applied

✓ No Excessive Permissions
```

---

### ProjectDev Role

Create:

```text
ProjectDev
```

Permissions:

```text
EC2 Management

S3 Read Access

CloudWatch Logs Access
```

Restrictions:

```text
No IAM

No Billing

us-east-1 Only
```

---

### IAM Auditor Project

Build:

```text
iam-auditor
```

Using:

```text
Python
Boto3
CSV Reporting
```

Output:

```text
Username

MFA Status

Access Key Age

Last Used

Groups
```

---

### Anki Revision

Create:

```text
25 Flashcards
```

Topics:

- IAM Policies
- IAM Roles
- Trust Policies
- SCPs
- Permission Boundaries
- Federation
- STS

---

## Outcome

Develop:

```text
Security Audit Mindset
```

---

# 🧠 Skills Built During Week 13

---

## Identity Management

Learned:

- Users
- Groups
- Roles

---

## Access Control

Learned:

- Policies
- Conditions
- ARNs
- Policy Evaluation

---

## Authentication

Learned:

- STS
- Temporary Credentials
- Federation

---

## Authorization

Learned:

- Permission Policies
- Trust Policies
- Boundaries

---

## Governance

Learned:

- SCPs
- IAM Best Practices
- Security Auditing

---

## Automation

Learned:

- AWS CLI
- Boto3 IAM Automation

---

# 🔥 Most Important Concepts To Master

---

## IAM Roles

Roles are preferred over users.

Use:

```text
Temporary Credentials
```

Instead of:

```text
Permanent Access Keys
```

---

## Least Privilege

Always grant:

```text
Only Required Permissions
```

---

## MFA

Must be enabled for:

```text
All Human Users
```

---

## Explicit Deny

Remember:

```text
Explicit Deny Always Wins
```

---

## Trust Policy vs Permission Policy

```text
Trust Policy
      ↓
WHO

Permission Policy
      ↓
WHAT
```

---

## SCP vs Permission Boundary

```text
SCP
 ↓
Account Guardrail

Permission Boundary
 ↓
Identity Guardrail
```

---

## Federation

Future AWS environments rely heavily on:

```text
OIDC

SAML

SSO

STS
```

---

# 🚀 Week 13 Deliverables

By the end of the week complete:

```text
✓ IAM Admin User

✓ IAM Groups

✓ IAM Policies

✓ EC2 Role

✓ Lambda Role

✓ Policy Simulator Practice

✓ MFA Enforcement Understanding

✓ Credential Report Review

✓ Access Analyzer Review

✓ Permission Boundary Lab

✓ SCP Understanding

✓ Federation Understanding

✓ ProjectDev Role Design

✓ IAM Auditor Project

✓ 25 Anki Cards

✓ Week Review
```

---

# 🧠 Week 13 Mindset Shift

Moved from:

```text
Creating Users & Permissions
```

To:

```text
Designing Secure Identity Architectures
```

---

# 🎯 End-of-Week Outcome

By completing Week 13, built the foundation required for:

- AWS Security Engineering
- Cloud Governance
- DevOps Security
- Enterprise AWS Architectures
- Kubernetes IAM Integration
- Multi-Account AWS Organizations
- Production Cloud Infrastructure
- AI Cloud Infrastructure Engineering

Week 13 established the identity and security foundation that every professional cloud engineer must master before moving deeper into AWS architecture and enterprise-scale deployments.

---

**Week:** 13 / AWS Core Services III  
**Focus Area:** IAM Deep Dive & Security Governance 🔐  
**Roadmap Status:** Complete ✅