# WEEK 13 NOTES — AWS CORE SERVICES III: IAM DEEP DIVE

## 📌 Week Overview

Week 13 focused on mastering AWS Identity and Access Management (IAM), the foundation of AWS security and access control.

This week covered:
- IAM users, groups and roles
- IAM policies and JSON syntax
- IAM trust policies
- IAM roles and temporary credentials
- AWS Security Token Service (STS)
- EC2 Instance Roles
- Cross-Account Access
- Principle of Least Privilege
- Multi-Factor Authentication (MFA)
- IAM Access Analyzer
- IAM Credential Reports
- Permission Boundaries
- Service Control Policies (SCPs)
- Service-Linked Roles
- Lambda Execution Roles
- Web Identity Federation
- OpenID Connect (OIDC)
- AWS Cognito
- SAML 2.0 Federation
- Enterprise Single Sign-On (SSO)
- IAM Security Auditing
- IAM Governance

The goal of this week was to understand how AWS authenticates users, authorizes access, secures resources, and implements enterprise-grade identity management.

---

# 🧠 Core IAM Fundamentals

---

# 1️⃣ AWS Identity and Access Management (IAM)

---

## What is IAM?

IAM = Identity and Access Management.

IAM is:
- AWS authentication service
- AWS authorization framework
- Access control system

Purpose:
- Control who can access AWS
- Control what actions they can perform

---

## IAM Hierarchy

```text
Root Account
      ↓
IAM Users
      ↓
IAM Groups
      ↓
IAM Roles
```

---

## Root Account

Characteristics:
- Created when AWS account is created
- Has full permissions
- Cannot be restricted

Best Practice:

```text
Never use root for daily operations
```

Use:
- Billing management
- Emergency account recovery
- Initial account setup

---

## IAM Users

IAM Users represent:

```text
Individual People
```

Examples:

```text
Kevin
Alice
Bob
```

Characteristics:
- Permanent identity
- Can have passwords
- Can have access keys

---

## IAM Groups

Groups are collections of users.

Example:

```text
Developers
Ops
Admins
```

Purpose:
- Simplify permission management

Example:

```text
Developers Group
      ↓
PowerUserAccess
```

All users inherit permissions.

---

## IAM Roles

Roles provide:

```text
Temporary Credentials
```

Characteristics:
- No username
- No password
- No permanent access keys

Used by:
- EC2
- Lambda
- ECS
- Cross-account access
- Federated users

---

# 2️⃣ IAM Policies & JSON Structure

---

## What is an IAM Policy?

A policy is:

```text
JSON Document
```

that defines permissions.

---

## Basic Policy Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}
```

---

## Policy Components

### Version

Specifies policy language version.

Example:

```json
"Version": "2012-10-17"
```

---

### Statement

Contains permission rules.

Example:

```json
"Statement": []
```

---

### Effect

Determines outcome.

Values:

```text
Allow
Deny
```

---

### Action

Defines operations.

Examples:

```text
s3:GetObject
ec2:RunInstances
lambda:InvokeFunction
```

---

### Resource

Defines target resources.

Example:

```text
arn:aws:s3:::my-bucket/*
```

---

### Condition

Optional access restrictions.

Example:

```json
"Condition": {
  "StringEquals": {
    "aws:RequestedRegion": "us-east-1"
  }
}
```

---

# 3️⃣ Managed Policies vs Inline Policies

---

## AWS Managed Policies

Created and maintained by AWS.

Examples:

```text
AdministratorAccess
ReadOnlyAccess
PowerUserAccess
```

Benefits:
- Automatically updated
- Easy to use

---

## Customer Managed Policies

Created by customers.

Characteristics:
- Reusable
- Version controlled

Best Practice:
- Use for production environments

---

## Inline Policies

Attached directly to:

```text
User
Group
Role
```

Characteristics:
- Not reusable
- Harder to manage

Best Practice:

```text
Avoid Inline Policies
```

---

# 4️⃣ Amazon Resource Names (ARNs)

---

## ARN Format

```text
arn:partition:service:region:account-id:resource
```

---

## S3 Bucket ARN

```text
arn:aws:s3:::my-bucket
```

---

## EC2 Instance ARN

```text
arn:aws:ec2:us-east-1:123456789012:instance/i-123456789
```

---

## Lambda Function ARN

```text
arn:aws:lambda:us-east-1:123456789012:function:MyFunction
```

---

## IAM Role ARN

```text
arn:aws:iam::123456789012:role/ProjectDev
```

---

# 5️⃣ IAM Policy Variables

---

## Common Variables

```text
${aws:username}
${aws:userid}
```

---

## User-Specific S3 Access

Example:

```text
arn:aws:s3:::my-bucket/${aws:username}/*
```

Result:

```text
Kevin → /Kevin/
Alice → /Alice/
```

---

# 6️⃣ IAM Policy Simulator

---

## Purpose

Used to:

```text
Test Permissions
```

Without deploying changes.

---

## Benefits

- Debug access issues
- Verify policies
- Validate Allow/Deny behavior

---

# 7️⃣ IAM Roles & STS

---

## What is STS?

STS = Security Token Service.

Purpose:

```text
Issues Temporary Credentials
```

---

## STS Credential Flow

```text
Assume Role
      ↓
STS
      ↓
Temporary Credentials
```

---

## Temporary Credentials Include

```text
AccessKeyId
SecretAccessKey
SessionToken
Expiration
```

---

## Why Roles Are Better

Bad:

```text
Hardcoded Access Keys
```

Good:

```text
IAM Roles
```

Benefits:
- Temporary credentials
- Automatic rotation
- Better security

---

# 8️⃣ EC2 Instance Roles

---

## EC2 Access Pattern

```text
EC2
 ↓
Assume Role
 ↓
STS Credentials
 ↓
Access AWS Resources
```

---

## Example Permission

```json
"s3:GetObject"
```

Purpose:
- Allow EC2 to read S3 objects

---

## Instance Metadata Service

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

Returns:
- Temporary credentials

---

# 9️⃣ Cross-Account Access

---

## Enterprise Pattern

```text
Account A
      ↓
Assume Role
      ↓
Account B
```

Purpose:
- Secure multi-account access

---

## Trust Policy

Defines:

```text
WHO can assume role
```

---

## Permission Policy

Defines:

```text
WHAT role can do
```

---

# 🔟 Principle of Least Privilege

---

## Definition

Grant:

```text
Only Required Permissions
```

Nothing more.

---

## Bad Example

```text
AdministratorAccess
```

For every user.

---

## Good Example

```text
Read S3
Write Logs
Start EC2
```

Only if required.

---

# 1️⃣1️⃣ MFA Enforcement

---

## What is MFA?

Multi-Factor Authentication.

Requires:

```text
Password
+
MFA Code
```

---

## MFA Enforcement Logic

```text
No MFA
     ↓
Access Denied
```

---

## Security Benefit

Protects against:
- Password theft
- Credential compromise

---

# 1️⃣2️⃣ IAM Access Analyzer

---

## Purpose

Identifies:

```text
External Resource Access
```

Examples:
- Public buckets
- Cross-account permissions

---

## Benefits

- Detects security risks
- Improves governance

---

# 1️⃣3️⃣ IAM Credential Reports

---

## Purpose

Provides account-wide visibility.

Shows:

- MFA status
- Password age
- Access key age
- Last usage

---

## CLI Commands

```bash
aws iam generate-credential-report

aws iam get-credential-report
```

---

# 1️⃣4️⃣ Permission Boundaries

---

## What is a Permission Boundary?

Maximum permissions allowed for:

```text
User
Role
```

---

## Evaluation Logic

```text
Identity Policy
        ∩
Permission Boundary
        ↓
Effective Permissions
```

---

## Use Case

Developer role restricted to:

```text
EC2
S3
CloudWatch
```

Even if additional permissions are attached.

---

# 1️⃣5️⃣ Service Control Policies (SCPs)

---

## What is an SCP?

Organization-wide permission guardrail.

Applied at:

```text
AWS Organizations
```

---

## SCP Controls

```text
Maximum Account Permissions
```

---

## Important Rule

Even root users are restricted by SCPs.

---

# 1️⃣6️⃣ IAM Policy Evaluation Logic

---

## Evaluation Order

```text
Request
   ↓
SCP Check
   ↓
Permission Boundary
   ↓
Identity Policy
   ↓
Resource Policy
   ↓
Final Decision
```

---

## Most Important Rule

```text
Explicit Deny Always Wins
```

---

## Example

```text
Allow S3
+
Deny S3
=
Denied
```

---

# 1️⃣7️⃣ Service-Linked Roles

---

## What Are Service-Linked Roles?

Roles automatically created by AWS services.

Example:

```text
AWSServiceRoleForECS
```

---

## Purpose

Allows AWS services to operate securely.

---

## Characteristics

- Managed by AWS
- Service-specific
- Cannot be deleted while in use

---

# 1️⃣8️⃣ Lambda Execution Roles

---

## Lambda Permission Flow

```text
Lambda
    ↓
Execution Role
    ↓
AWS Permissions
```

---

## Common Permissions

```text
logs:CreateLogGroup
logs:CreateLogStream
logs:PutLogEvents
```

Purpose:
- Write logs to CloudWatch

---

# 1️⃣9️⃣ Federation & Identity Providers

---

# Web Identity Federation

Used by:

```text
Google
Facebook
Amazon
GitHub
```

Flow:

```text
User Login
      ↓
Identity Token
      ↓
AssumeRoleWithWebIdentity
      ↓
AWS Credentials
```

---

# OpenID Connect (OIDC)

Modern federation protocol.

Common providers:
- Google
- GitHub
- Auth0

---

# AWS Cognito

AWS-managed identity service.

Supports:
- User authentication
- Social logins
- Federation

---

# SAML 2.0 Federation

Enterprise federation standard.

Used by:

```text
Okta
Azure AD
PingIdentity
```

Flow:

```text
Employee Login
      ↓
SAML Assertion
      ↓
AssumeRoleWithSAML
      ↓
AWS Access
```

---

# Enterprise Single Sign-On (SSO)

Purpose:

```text
One Login
     ↓
Many Applications
```

Benefits:
- Better user experience
- Improved security

---

# 2️⃣0️⃣ IAM Security Auditing

---

## Security Audit Checklist

Check:

```text
✓ MFA Enabled
✓ No Unused Access Keys
✓ No Excessive Permissions
✓ Least Privilege
✓ No Wildcard Policies
```

---

## Dangerous Policy

```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

Avoid whenever possible.

---

## IAM Auditor Automation

Audit:

```text
Username
MFA Status
Access Key Age
Last Used
Groups
```

Generate:

```text
CSV Security Report
```

Using:
- Python
- Boto3

---

# 🔥 Most Important Week 13 Concepts

---

## IAM controls authentication and authorization

Identity security is the foundation of AWS security.

---

## Roles are preferred over users

Temporary credentials are more secure than permanent credentials.

---

## STS powers modern AWS authentication

Most AWS services rely on temporary credentials.

---

## Least privilege is mandatory

Grant only required permissions.

---

## MFA should be enabled for all human users

Passwords alone are insufficient.

---

## Trust Policies and Permission Policies are different

Trust = WHO can assume.

Permissions = WHAT can be done.

---

## Explicit Deny always wins

The most important IAM evaluation rule.

---

## SCPs and Permission Boundaries are guardrails

They limit maximum permissions.

---

## Federation eliminates long-term credentials

Modern cloud environments rely on federation and temporary access.

---

# 🧠 Week 13 Mindset Shift

Moved from:

> IAM is just users and permissions

To:

> IAM is a complete identity, authentication, authorization, federation and governance system that secures every AWS environment

---

# 🚀 Week 13 Outcome

By the end of Week 13, built understanding of:

- IAM architecture
- Users, Groups and Roles
- Policy creation
- ARN structures
- Temporary credentials
- STS
- Cross-account access
- Least privilege
- MFA enforcement
- Access auditing
- Permission Boundaries
- SCP governance
- Federation
- SAML and OIDC
- Enterprise SSO
- Security auditing
- Cloud identity architecture

---

# 📚 Week 13 Summary

Week 13 established the security and identity foundation required for every AWS workload.

This week transformed IAM knowledge from:

- Creating users and attaching policies

Into:

- Designing secure cloud identity architectures involving roles, federation, temporary credentials, least privilege access control, enterprise governance, and continuous security auditing.

Week 13 created the base required for:

- AWS Organizations
- Advanced Security Engineering
- DevSecOps
- Kubernetes IAM Integration
- EKS IRSA
- CI/CD Security
- Enterprise Cloud Governance
- Multi-Account AWS Environments
- Production Infrastructure
- AI Cloud Infrastructure Engineering

---