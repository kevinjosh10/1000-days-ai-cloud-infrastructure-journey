# WEEK 13 RECAP — AWS CORE SERVICES III: IAM DEEP DIVE

## 📌 Week Overview

Week 13 focused on mastering AWS Identity and Access Management (IAM), the security foundation of every AWS environment.

This week covered:

- IAM Users
- IAM Groups
- IAM Roles
- IAM Policies
- IAM Policy JSON Structure
- IAM Policy Simulator
- IAM Best Practices
- ARNs
- Policy Variables
- STS Temporary Credentials
- EC2 Instance Roles
- Cross-Account Access
- Trust Policies
- Permission Policies
- Principle of Least Privilege
- MFA Enforcement
- IAM Credential Reports
- IAM Access Analyzer
- Permission Boundaries
- Service Control Policies (SCPs)
- Service-Linked Roles
- Lambda Execution Roles
- Web Identity Federation
- OpenID Connect (OIDC)
- AWS Cognito
- SAML Federation
- Enterprise SSO
- IAM Security Auditing
- Boto3 IAM Automation

---

# 🎯 Week Goal

The goal of Week 13 was to understand how AWS authenticates identities, authorizes actions, secures resources, and governs access across cloud environments.

By the end of the week, the objective was to move beyond simply creating users and permissions and begin thinking like a cloud security engineer.

---

# 📅 Day-by-Day Breakdown

---

# Day 85 — IAM Core Concepts: Users, Groups & Policies

Learned:

- IAM hierarchy
- Root account responsibilities
- IAM users
- IAM groups
- IAM roles
- AWS managed policies
- Customer managed policies
- Inline policies
- IAM security best practices

Built:

```text
Root Account
      ↓
IAM Users
      ↓
IAM Groups
      ↓
Permissions
```

Key Takeaway:

```text
Never use the root account for daily operations.
```

---

# Day 86 — IAM Policy Structure & JSON Syntax

Learned:

- IAM policy JSON structure
- Effect
- Action
- Resource
- Condition
- ARN construction
- Policy variables
- IAM Policy Simulator

Built:

```json
{
  "Version": "2012-10-17",
  "Statement": []
}
```

Key Takeaway:

```text
Every AWS permission is controlled through policy evaluation.
```

---

# Day 87 — IAM Roles: The Cloud Engineer's Most Important Tool

Learned:

- IAM roles
- STS
- Temporary credentials
- EC2 instance roles
- Cross-account access
- Trust policies
- Permission policies

Built:

```text
EC2
 ↓
IAM Role
 ↓
STS
 ↓
Temporary Credentials
```

Key Takeaway:

```text
Use roles instead of access keys whenever possible.
```

---

# Day 88 — Principle of Least Privilege & MFA

Learned:

- Least privilege principles
- MFA enforcement
- IAM Access Analyzer
- IAM Credential Reports
- Security auditing

Built:

```text
User
 ↓
Least Privilege
 ↓
Minimum Required Access
```

Key Takeaway:

```text
Permissions should be granted only when necessary.
```

---

# Day 89 — Permission Boundaries & Service Control Policies

Learned:

- Permission Boundaries
- Service Control Policies (SCPs)
- Effective permissions
- Permission evaluation logic
- Governance controls

Built:

```text
Identity Policy
        ∩
Permission Boundary
        ↓
Effective Permissions
```

Key Takeaway:

```text
Explicit Deny always wins.
```

---

# Day 90 — IAM Roles for Services & Federation

Learned:

- Service-linked roles
- Lambda execution roles
- Web identity federation
- OpenID Connect (OIDC)
- AWS Cognito
- SAML federation
- Enterprise SSO
- AWS CLI profiles

Built:

```text
Identity Provider
        ↓
STS
        ↓
Temporary Credentials
```

Key Takeaway:

```text
Modern cloud environments rely on federation and temporary credentials.
```

---

# Day 91 — IAM Security Audit & Access Governance

Learned:

- IAM auditing
- MFA compliance reviews
- Access key audits
- Wildcard permission detection
- Policy reviews
- Governance validation
- Security posture assessment
- Boto3 IAM auditing automation

Built:

```text
Users
Roles
Policies
      ↓
Audit
      ↓
Secure Environment
```

Key Takeaway:

```text
Security is not creating permissions.
Security is continuously auditing them.
```

---

# 🧠 Most Important Concepts Learned

---

## IAM Users

Represent:

```text
Individual Human Identities
```

Examples:

```text
Developers
Administrators
Operators
```

---

## IAM Groups

Purpose:

```text
Permission Management
```

Example:

```text
Developers Group
      ↓
PowerUserAccess
```

---

## IAM Roles

Purpose:

```text
Temporary Access
```

Used by:

```text
EC2
Lambda
ECS
Cross-Account Users
Federated Users
```

---

## IAM Policies

Purpose:

```text
Define Permissions
```

Components:

```text
Effect

Action

Resource

Condition
```

---

## STS

STS = Security Token Service

Purpose:

```text
Issue Temporary Credentials
```

Components:

```text
Access Key

Secret Key

Session Token

Expiration
```

---

## Trust Policies

Define:

```text
WHO can assume a role
```

---

## Permission Policies

Define:

```text
WHAT the role can do
```

---

## Principle of Least Privilege

Definition:

```text
Grant only required permissions.
```

Nothing more.

---

## MFA

Purpose:

```text
Multi-Factor Authentication
```

Benefits:

- Prevents unauthorized access
- Protects accounts
- Reduces compromise risk

---

## IAM Access Analyzer

Purpose:

```text
Identify Excessive Access
```

Examples:

- Public access
- External access
- Cross-account exposure

---

## Permission Boundaries

Purpose:

```text
Maximum Permission Limit
```

Applied to:

```text
Users
Roles
```

---

## Service Control Policies (SCPs)

Purpose:

```text
Maximum Account Permissions
```

Applied to:

```text
AWS Organizations
```

---

## Service-Linked Roles

Purpose:

```text
AWS Service Permissions
```

Example:

```text
AWSServiceRoleForECS
```

---

## Lambda Execution Roles

Purpose:

```text
Grant Lambda Permissions
```

Common Permissions:

```text
logs:CreateLogGroup

logs:CreateLogStream

logs:PutLogEvents
```

---

## Federation

Purpose:

```text
External Authentication
```

Methods:

```text
OIDC

SAML

Cognito
```

---

## IAM Security Auditing

Review:

```text
Users

Roles

Policies

Access Keys

MFA

Permissions
```

Purpose:

```text
Maintain Secure AWS Environment
```

---

# 🔥 Most Important Exam Concepts

---

## Explicit Deny Always Wins

Example:

```text
Allow S3
+
Deny S3
=
Denied
```

---

## Roles Are Preferred Over Users

Use:

```text
Temporary Credentials
```

Avoid:

```text
Permanent Access Keys
```

---

## Least Privilege Is Mandatory

Grant:

```text
Only Necessary Permissions
```

---

## MFA Should Be Enabled

For:

```text
All Human Users
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
Account Limit

Permission Boundary
 ↓
Identity Limit
```

---

## OIDC vs SAML

```text
OIDC
 ↓
Customers / Applications

SAML
 ↓
Enterprise Employees
```

---

# 🏗️ Architecture Built During Week 13

```text
Users
  ↓
Groups
  ↓
Policies
  ↓
Roles
  ↓
STS
  ↓
Temporary Credentials
  ↓
AWS Resources
```

Governance Layer:

```text
MFA
Credential Reports
Access Analyzer
Permission Boundaries
SCPs
Security Audits
```

---

# 🧠 Week 13 Mindset Shift

Moved from:

> IAM is simply creating users and attaching permissions

To:

> IAM is the identity security control plane of AWS responsible for authentication, authorization, federation, governance and continuous security auditing.

---

# 🚀 Week 13 Outcome

By the end of Week 13, built understanding of:

- AWS identity architecture
- IAM administration
- Policy design
- Role-based access control
- Temporary credential systems
- STS authentication
- Federation technologies
- Enterprise governance
- Security auditing
- Cloud access management

Week 13 established the security foundation required for:

- DevOps Engineering
- Cloud Security Engineering
- AWS Solutions Architecture
- Kubernetes Security
- Enterprise AWS Governance
- Multi-Account Architectures
- AI Cloud Infrastructure Engineering

---

# 📚 Week 13 Summary

Week 13 transformed IAM knowledge from:

```text
Creating Users
```

Into:

```text
Designing Secure Cloud Identity Systems
```

The week established a strong understanding of how AWS secures identities, permissions and resources using roles, policies, temporary credentials, federation, governance controls and continuous auditing.

This knowledge forms the foundation for every production AWS environment and is one of the most heavily tested areas on the AWS Solutions Architect Associate certification.

---

**Week Status:** Complete ✅  
**Week:** 13 / AWS Core Services III  
**Focus Area:** IAM Deep Dive & Security Governance 🔐