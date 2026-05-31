# WEEK 13 RESOURCES — AWS CORE SERVICES III: IAM DEEP DIVE

## 📌 Week Overview

Week 13 focused on mastering AWS Identity and Access Management (IAM), the security foundation of AWS.

The goal was to understand:

- Authentication
- Authorization
- Access Control
- IAM Policies
- IAM Roles
- STS Temporary Credentials
- Federation
- MFA
- Permission Boundaries
- Service Control Policies (SCPs)
- IAM Security Auditing
- Enterprise IAM Governance

This document contains all learning resources used during Week 13.

---

# 📚 Primary AWS Documentation

---

## 1️⃣ AWS IAM Documentation

Purpose:

```text
Official AWS IAM Documentation
```

Topics Covered:

- IAM Users
- IAM Groups
- IAM Roles
- IAM Policies
- Policy Evaluation Logic
- Federation
- MFA
- IAM Best Practices

Resource:

```text
https://docs.aws.amazon.com/iam/
```

Priority:

```text
★★★★★
```

---

## 2️⃣ IAM Best Practices Guide

Purpose:

```text
Learn AWS-recommended security practices
```

Topics Covered:

- Root account protection
- MFA enforcement
- Least privilege
- Access key management
- Role-based access

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
```

Priority:

```text
★★★★★
```

---

## 3️⃣ IAM User Guide

Purpose:

```text
Deep IAM Concepts
```

Topics Covered:

- Policies
- Roles
- Federation
- STS
- Access Analyzer
- Policy Evaluation

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/
```

Priority:

```text
★★★★★
```

---

# 🧠 IAM Policies & JSON Resources

---

## 4️⃣ AWS IAM Policy Examples

Purpose:

```text
Real IAM Policy Examples
```

Topics Covered:

- S3 Policies
- EC2 Policies
- Cross-Account Policies
- Condition-Based Policies

Resource:

```text
https://github.com/awslabs/aws-iam-policy-examples
```

Priority:

```text
★★★★★
```

---

## 5️⃣ IAM JSON Policy Reference

Purpose:

```text
Complete Policy Syntax Reference
```

Topics Covered:

```text
Version

Statement

Effect

Action

Resource

Condition
```

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
```

Priority:

```text
★★★★★
```

---

## 6️⃣ AWS ARN Reference

Purpose:

```text
Understand ARN Structures
```

Topics Covered:

- S3 ARNs
- EC2 ARNs
- Lambda ARNs
- IAM ARNs

Resource:

```text
https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
```

Priority:

```text
★★★★☆
```

---

# 🛠 IAM Tools

---

## 7️⃣ IAM Policy Simulator

Purpose:

```text
Permission Testing
```

Use Cases:

- Debug access issues
- Verify policy behavior
- Test Allow/Deny results

Resource:

```text
https://policysim.aws.amazon.com
```

Priority:

```text
★★★★★
```

---

## 8️⃣ IAM Access Analyzer

Purpose:

```text
Find External Access Risks
```

Use Cases:

- Public S3 buckets
- Cross-account access
- Excessive permissions

Resource:

```text
AWS Console → IAM → Access Analyzer
```

Priority:

```text
★★★★★
```

---

## 9️⃣ IAM Credential Reports

Purpose:

```text
Audit IAM Credentials
```

Checks:

- MFA status
- Password age
- Access key age
- Credential usage

Commands:

```bash
aws iam generate-credential-report

aws iam get-credential-report
```

Priority:

```text
★★★★★
```

---

# 🔐 IAM Roles & STS Resources

---

## 🔟 AWS STS Documentation

Purpose:

```text
Temporary Credentials
```

Topics Covered:

- AssumeRole
- Session Tokens
- Credential Expiration

Resource:

```text
https://docs.aws.amazon.com/STS/latest/APIReference/
```

Priority:

```text
★★★★★
```

---

## 1️⃣1️⃣ IAM Roles Documentation

Purpose:

```text
Role-Based Access Control
```

Topics Covered:

- Trust Policies
- Permission Policies
- Service Roles
- Cross-Account Roles

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
```

Priority:

```text
★★★★★
```

---

## 1️⃣2️⃣ EC2 IAM Roles Guide

Purpose:

```text
Secure EC2 Access
```

Topics Covered:

- Instance Profiles
- STS Credentials
- Metadata Service

Resource:

```text
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
```

Priority:

```text
★★★★★
```

---

# 🛡 Security & Governance Resources

---

## 1️⃣3️⃣ AWS Security Best Practices Whitepaper

Purpose:

```text
Enterprise Security Guidance
```

Topics Covered:

- Identity Security
- Access Management
- Governance
- Compliance

Resource:

```text
https://docs.aws.amazon.com/wellarchitected/
```

Priority:

```text
★★★★★
```

---

## 1️⃣4️⃣ AWS Well-Architected Framework

Purpose:

```text
Security Pillar Learning
```

Focus Areas:

- IAM
- Least Privilege
- Access Control
- Governance

Resource:

```text
https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/
```

Priority:

```text
★★★★★
```

---

## 1️⃣5️⃣ Permission Boundaries Documentation

Purpose:

```text
Advanced IAM Governance
```

Topics Covered:

- Permission Boundaries
- Effective Permissions
- Role Restrictions

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
```

Priority:

```text
★★★★☆
```

---

## 1️⃣6️⃣ Service Control Policies (SCP) Documentation

Purpose:

```text
AWS Organizations Governance
```

Topics Covered:

- SCPs
- Organizational Units
- Account Restrictions

Resource:

```text
https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html
```

Priority:

```text
★★★★★
```

---

# 🌐 Federation Resources

---

## 1️⃣7️⃣ AWS Federation Documentation

Purpose:

```text
External Authentication
```

Topics Covered:

- OIDC
- SAML
- Identity Federation

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html
```

Priority:

```text
★★★★★
```

---

## 1️⃣8️⃣ AWS Cognito Documentation

Purpose:

```text
Managed Identity Service
```

Topics Covered:

- User Pools
- Identity Pools
- Social Login
- Federation

Resource:

```text
https://docs.aws.amazon.com/cognito/
```

Priority:

```text
★★★★☆
```

---

## 1️⃣9️⃣ SAML Federation Guide

Purpose:

```text
Enterprise Authentication
```

Topics Covered:

- SAML Assertions
- Enterprise SSO
- Corporate Login Integration

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html
```

Priority:

```text
★★★★★
```

---

## 2️⃣0️⃣ OIDC Federation Guide

Purpose:

```text
Modern Web Authentication
```

Topics Covered:

- OpenID Connect
- Web Identity Federation
- AssumeRoleWithWebIdentity

Resource:

```text
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
```

Priority:

```text
★★★★★
```

---

# 🐍 Python & Automation Resources

---

## 2️⃣1️⃣ Boto3 IAM Documentation

Purpose:

```text
Automate IAM Tasks
```

Topics Covered:

- List Users
- Audit MFA
- Access Key Reports
- Group Auditing

Resource:

```text
https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/iam.html
```

Priority:

```text
★★★★★
```

---

## 2️⃣2️⃣ AWS CLI IAM Commands

Purpose:

```text
CLI-Based IAM Management
```

Topics Covered:

- User Management
- Policy Management
- Role Management
- Credential Reports

Resource:

```text
https://docs.aws.amazon.com/cli/latest/reference/iam/
```

Priority:

```text
★★★★★
```

---

# 🎥 Recommended Video Resources

---

## AWS IAM Full Course

Topics:

```text
Users

Groups

Roles

Policies

STS

Federation
```

Platform:

```text
YouTube
AWS Skill Builder
```

Priority:

```text
★★★★★
```

---

## AWS Security & Identity Learning Path

Topics:

```text
IAM

Security

Governance

Organizations
```

Platform:

```text
AWS Skill Builder
```

Priority:

```text
★★★★★
```

---

# 🔥 Most Important Resources For SAA Exam

Study These First:

1. AWS IAM Documentation
2. IAM Best Practices Guide
3. IAM Policy Simulator
4. IAM Policy Examples Repository
5. IAM User Guide
6. STS Documentation
7. IAM Roles Documentation
8. SCP Documentation
9. Permission Boundaries Documentation
10. IAM Policy Evaluation Logic

---

# 🧠 Week 13 Learning Outcome

By studying these resources, built understanding of:

- IAM Architecture
- Policy Design
- ARN Structures
- STS Authentication
- Role-Based Access Control
- Least Privilege
- MFA Enforcement
- Security Auditing
- Federation
- Enterprise Governance
- AWS Organizations Security
- Cloud Identity Management

---

# 📚 Week 13 Resource Summary

Week 13 resources established the identity and security foundation required for every AWS workload.

These resources transformed IAM knowledge from:

```text
Basic User Management
```

Into:

```text
Enterprise Identity Architecture
```

and prepared the foundation for advanced cloud security, DevOps, multi-account AWS environments, and AI cloud infrastructure engineering.

---

**Week:** 13 / AWS Core Services III  
**Focus Area:** IAM Deep Dive & Security Governance 🔐  
**Resources Status:** Complete ✅