# WEEK 13 PROJECT — Enterprise IAM Security & Governance Lab

## 📌 Project Overview

Week 13 focused on mastering AWS Identity and Access Management (IAM), the security foundation of every AWS environment.

This project combined all major IAM concepts learned throughout the week into a realistic enterprise IAM implementation.

The project included:

- IAM Users
- IAM Groups
- IAM Roles
- IAM Policies
- IAM Policy Simulator
- EC2 Instance Roles
- STS Temporary Credentials
- MFA Enforcement
- Least Privilege Access
- IAM Access Analyzer
- IAM Credential Reports
- Permission Boundaries
- Service Control Policies (SCPs)
- Lambda Execution Roles
- Service-Linked Roles
- Federation Concepts
- IAM Security Auditing
- Boto3 Automation

---

# 🎯 Project Objective

Design and implement a secure AWS IAM environment following enterprise security best practices.

Goals:

- Eliminate root account usage
- Enforce MFA
- Implement least privilege permissions
- Use IAM roles instead of access keys
- Create governance guardrails
- Audit IAM security posture
- Automate IAM reporting

---

# 🏗️ Architecture Built

```text
                     AWS Account
                           │
      ┌────────────────────┼────────────────────┐
      │                    │                    │
      ▼                    ▼                    ▼

 Developers Group      Ops Group         Admins Group
 (PowerUserAccess)   (ReadOnlyAccess) (AdministratorAccess)

      │                    │                    │
      └────────────────────┼────────────────────┘
                           │
                           ▼

                     IAM Policies

                           │
                           ▼

                      IAM Roles

        ┌──────────────────┼──────────────────┐
        │                  │                  │

        ▼                  ▼                  ▼

 EC2-S3-ReadOnly    LambdaExecution     ProjectDev

        │                  │                  │
        ▼                  ▼                  ▼

 Temporary         CloudWatch Logs      Dev Access
 Credentials         Permissions        Controls

                           │
                           ▼

                  IAM Security Audit

                           │
                           ▼

                   Boto3 CSV Report
```

---

# ✅ What I Implemented

---

## 1️⃣ Created Secure IAM Administrator User

Created a dedicated IAM administrator account.

Configured:

```text
✓ AdministratorAccess
✓ Console Login
✓ MFA Enabled
✓ Access Keys Generated
```

Purpose:

```text
Avoid using root account
```

Outcome:

```text
Root account reserved for emergencies only
```

---

## 2️⃣ Created IAM Groups

Created:

```text
Developers
Ops
Admins
```

Attached Policies:

```text
Developers → PowerUserAccess

Ops → ReadOnlyAccess

Admins → AdministratorAccess
```

Purpose:

```text
Centralized permission management
```

Outcome:

```text
Users inherit permissions through groups
```

---

## 3️⃣ Created Customer Managed Policies

Designed reusable IAM policies.

Examples:

```text
S3ReadOnlyPolicy

EC2DeveloperPolicy

CloudWatchLogsPolicy
```

Purpose:

```text
Fine-grained access control
```

Outcome:

```text
Reusable enterprise permissions
```

---

## 4️⃣ Practiced IAM Policy JSON Design

Created policies using:

```json
{
  "Version": "2012-10-17",
  "Statement": []
}
```

Worked with:

```text
Effect

Action

Resource

Condition
```

Outcome:

```text
Understood AWS authorization logic
```

---

## 5️⃣ Used IAM Policy Simulator

Validated:

```text
Allow Decisions

Deny Decisions

Resource Restrictions

Conditional Access
```

Purpose:

```text
Permission debugging
```

Outcome:

```text
Verified policy behavior safely
```

---

## 6️⃣ Created EC2 Instance Role

Role Name:

```text
EC2-S3-ReadOnly
```

Permissions:

```json
s3:GetObject
```

Architecture:

```text
EC2
 ↓
IAM Role
 ↓
STS
 ↓
Temporary Credentials
 ↓
S3 Access
```

Outcome:

```text
No hardcoded credentials required
```

---

## 7️⃣ Verified STS Temporary Credentials

Retrieved credentials from:

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

Observed:

```text
AccessKeyId

SecretAccessKey

SessionToken

Expiration
```

Outcome:

```text
Confirmed secure role assumption
```

---

## 8️⃣ Studied Cross-Account Access

Architecture:

```text
Account A
      ↓
Assume Role
      ↓
Account B
```

Understood:

```text
Trust Policies

Permission Policies

Role Assumption
```

Outcome:

```text
Learned enterprise account access model
```

---

## 9️⃣ Implemented Least Privilege Principles

Avoided:

```text
AdministratorAccess
```

Created permissions for:

```text
Only Required Actions
```

Examples:

```text
Read S3

Write Logs

Manage Dev EC2
```

Outcome:

```text
Reduced security risk
```

---

## 🔟 Implemented MFA Enforcement

Audited users for:

```text
MFA Enabled
```

Studied enforcement policy:

```json
{
  "Effect": "Deny"
}
```

Condition:

```text
aws:MultiFactorAuthPresent = false
```

Outcome:

```text
Improved account security posture
```

---

## 1️⃣1️⃣ Generated IAM Credential Report

Executed:

```bash
aws iam generate-credential-report

aws iam get-credential-report
```

Reviewed:

```text
Password Usage

MFA Status

Access Key Age

Credential Activity
```

Outcome:

```text
Identified security weaknesses
```

---

## 1️⃣2️⃣ Enabled IAM Access Analyzer

Reviewed:

```text
External Access Findings
```

Examples:

```text
Cross-Account Access

Public Access Risks
```

Outcome:

```text
Improved visibility into permissions
```

---

## 1️⃣3️⃣ Created Permission Boundary

Policy:

```text
DevBoundary
```

Allowed Services:

```text
EC2

S3

CloudWatch
```

Purpose:

```text
Maximum permissions limit
```

Outcome:

```text
Prevented privilege escalation
```

---

## 1️⃣4️⃣ Studied Service Control Policies (SCPs)

Learned Organization-level governance.

Architecture:

```text
AWS Organizations
        ↓
Organizational Unit
        ↓
AWS Accounts
```

Purpose:

```text
Restrict account permissions globally
```

Outcome:

```text
Understood enterprise governance controls
```

---

## 1️⃣5️⃣ Learned IAM Policy Evaluation Logic

Studied permission evaluation process.

Flow:

```text
Request
   ↓
SCP
   ↓
Permission Boundary
   ↓
Identity Policy
   ↓
Resource Policy
   ↓
Final Decision
```

Most Important Rule:

```text
Explicit Deny Always Wins
```

Outcome:

```text
Built IAM troubleshooting mindset
```

---

## 1️⃣6️⃣ Studied Service-Linked Roles

Example:

```text
AWSServiceRoleForECS
```

Learned:

```text
Created Automatically

Managed By AWS

Service Specific
```

Outcome:

```text
Understood AWS service permissions model
```

---

## 1️⃣7️⃣ Created Lambda Execution Role

Configured:

```text
CloudWatch Logs Permissions
```

Permissions:

```text
logs:CreateLogGroup

logs:CreateLogStream

logs:PutLogEvents
```

Outcome:

```text
Learned Lambda permission architecture
```

---

## 1️⃣8️⃣ Studied Federation & STS

Covered:

```text
OIDC

SAML

Cognito

AssumeRoleWithWebIdentity

AssumeRoleWithSAML
```

Identity Flow:

```text
User Login
     ↓
Identity Provider
     ↓
STS
     ↓
Temporary Credentials
```

Outcome:

```text
Understood modern cloud authentication
```

---

## 1️⃣9️⃣ Designed ProjectDev Role

Created:

```text
ProjectDev
```

Permissions:

```text
Manage EC2

Read S3

Write CloudWatch Logs
```

Restrictions:

```text
us-east-1 Only

No IAM Access

No Billing Access
```

Outcome:

```text
Built least-privilege developer role
```

---

## 2️⃣0️⃣ Built IAM Auditor Automation Concept

Designed Python Boto3 audit tool.

Report Fields:

```text
Username

MFA Status

Access Key Age

Last Used

Groups
```

Output:

```text
CSV Report
```

Repository:

```text
iam-auditor
```

Outcome:

```text
Connected IAM with automation
```

---

# 🧠 Skills Developed

- IAM Administration
- User & Group Management
- IAM Policy Design
- JSON Policy Writing
- ARN Construction
- IAM Troubleshooting
- Policy Simulation
- STS Authentication
- Role-Based Access Control
- Cross-Account Access
- Least Privilege Design
- MFA Enforcement
- IAM Security Auditing
- Access Analyzer Usage
- Permission Boundaries
- SCP Governance
- Service Roles
- Lambda Security
- Federation Concepts
- Boto3 IAM Automation

---

# 🔄 Mindset Shift

Moved from:

> IAM is just users and permissions

To:

> IAM is the security control plane of AWS that governs authentication, authorization, federation, auditing, and enterprise access management.

---

# 🚀 Project Outcome

Successfully built a complete IAM governance and security environment incorporating:

- Secure user management
- Group-based permissions
- Role-based access control
- Temporary credential architecture
- MFA security controls
- Permission guardrails
- Enterprise governance concepts
- Automated auditing mindset

The project established the identity and security foundation required for advanced AWS architecture, DevOps, cloud security engineering, and AI cloud infrastructure deployments.

---

**Project Status:** Complete ✅  
**Week:** 13 / AWS Core Services III  
**Focus Area:** IAM Deep Dive & Security Governance 🔐