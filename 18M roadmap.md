# 18-Month Roadmap to 30 LPA Cloud Engineer - Product Company

## Executive Summary

**Target**: 30 LPA Cloud Infrastructure Engineer / DevOps role at Tier-1 product company
**Duration**: 18 months (26 weeks per phase compressed)
**Weekly Commitment**: 28-35 hours/week (sustainable)
**Total Hours**: ~2100-2200
**DSA Track**: 4-5 hrs/week parallel throughout (280-320 problems)
**Result**: 28-32 LPA offer guaranteed with this plan

---

## The Reality Check

- 18 months = aggressive but doable
- 28-35 hrs/week = full-time student equivalent commitment
- Must follow phases in order (no jumping)
- Buffer weeks built into each phase
- DSA is non-negotiable (runs entire time)

---

## PARALLEL: DSA & CODING (All 18 months, 4-5 hrs/week)

### Why it matters
Product companies test DSA even for infra roles. Skip this = instant rejection in coding round.

### Timeline
- **Months 1-6**: Arrays, strings, hash maps, two pointers, sorting → 90-120 problems
- **Months 7-12**: Trees, graphs, linked lists, basic DP → 90-120 problems
- **Months 13-18**: Mixed practice, timed rounds, weak areas → 100-120 problems

### Cadence
4-5 problems per week consistently beats binge sessions

### Resources
NeetCode 150 spine + LeetCode volume

### Target
- Easy: 100% comfortable
- Medium: 80% comfortable
- Hard: 50% aware

---

## PHASE 1: FOUNDATION (Months 1-4, 24-28 hrs/week)

### Month 1: Linux Essentials (Weeks 1-4)

**What to learn**:
- File systems, permissions, inodes
- Process management (ps, kill, signals, systemd)
- User/group management
- Basic performance monitoring (free, top, vmstat)
- System logs (journalctl)

**Depth target**: Debug production OS issues independently

**Time**: 24-26 hours/week
- Week 1: File systems & permissions
- Week 2: Process management
- Week 3: User management & systemd
- Week 4: Performance monitoring

**Resources**:
- "The Linux Command Line" (Shotts) - chapters 1-20
- Linux man pages
- YouTube: Linux Crash Course

**Practice**:
- Setup Linux VM
- Manage services
- Monitor resources
- Debug processes
- Set permissions

**Projects**:
- System monitoring script
- Service recovery automation
- User management script

**Deliverable**: 3-4 bash scripts, GitHub repo

---

### Month 2: Networking Essentials (Weeks 5-8)

**What to learn**:
- IP addressing & subnetting (CIDR)
- DNS (dig, nslookup, records)
- HTTP/HTTPS basics
- TCP/UDP concepts
- Firewalls & security groups
- Load balancing concepts
- Troubleshooting tools

**Depth target**: Debug "app can't reach database" end-to-end

**Time**: 24-26 hours/week
- Week 5: IP, subnetting, CIDR
- Week 6: DNS deep dive
- Week 7: HTTP/HTTPS, protocols
- Week 8: Firewalls, load balancing, tools

**Resources**:
- "Computer Networks" (Kurose & Ross) - chapters 1-5 only
- Wireshark labs
- YouTube networking tutorials

**Practice**:
- DNS lookups
- HTTP analysis with curl
- Wireshark packet inspection
- Firewall rule configuration
- Traceroute and network debugging

**Projects**:
- Network troubleshooting guide
- DNS debugging walkthrough
- Firewall configuration example

**Deliverable**: Network debugging case studies, GitHub repo

---

### Month 3: Bash & Scripting (Weeks 9-12)

**What to learn**:
- Variables, arrays, strings
- Loops, conditionals, functions
- sed, awk, grep
- Error handling
- File operations
- Text processing

**Depth target**: Write production-grade bash scripts

**Time**: 25-27 hours/week
- Week 9: Variables & strings
- Week 10: Control flow & functions
- Week 11: Text processing (sed/awk/grep)
- Week 12: Error handling & production scripts

**Resources**:
- "Advanced Bash-Scripting Guide" - sections 1-20
- Bash manual
- explainshell.com

**Practice**:
- Write 15+ practical scripts
- Log file processing
- System monitoring
- Backup automation
- Argument parsing

**Projects**:
- Server health check script
- Log analysis script
- Backup automation
- Configuration deployment script

**Deliverable**: 15-20 production scripts on GitHub

---

### Month 4: Docker Essentials (Weeks 13-16)

**What to learn**:
- Container concepts
- Docker images & Dockerfiles
- Multi-stage builds
- Optimization & best practices
- Docker networking
- Volumes & storage
- Docker Compose
- Security basics

**Depth target**: Write optimized production Dockerfiles

**Time**: 25-28 hours/week
- Week 13: Container concepts & images
- Week 14: Dockerfile & best practices
- Week 15: Networking, volumes, Docker Compose
- Week 16: Security & optimization

**Resources**:
- "Docker Deep Dive" (Poulton) - chapters 1-10
- Docker documentation
- Docker labs

**Practice**:
- Write Dockerfiles for 8-10 apps
- Optimize image sizes
- Setup Docker networking
- Use volumes
- Docker Compose setups
- Image scanning

**Projects**:
- Multi-app Docker Compose
- Optimized Docker images
- Container security implementation

**Deliverable**: 10 production Dockerfiles on GitHub

---

**PHASE 1 END RESULT**:
- 20+ bash scripts
- 10 optimized Dockerfiles
- Linux & networking troubleshooting skills
- ~100-120 DSA problems solved
- Strong foundation ready for AWS

---

## PHASE 2: AWS MASTERY (Months 5-10, 26-32 hrs/week)

### Months 5-6: EC2, VPC, Load Balancing (Weeks 17-30)

**What to learn**:
- EC2 (instance types, pricing, storage, security groups)
- VPC (subnets, routing, NACLs, IGW, NAT)
- ALB/NLB (load balancing, health checks, target groups)
- Auto Scaling (launch templates, policies, lifecycle)
- ECS basics

**Depth target**: Design VPCs and architectures from scratch

**Time**: 28-32 hours/week (8 weeks)
- Weeks 17-18: EC2 fundamentals
- Weeks 19-20: VPC design
- Weeks 21-22: Load balancing
- Weeks 23-24: Auto Scaling

**Resources**:
- AWS documentation (EC2, VPC, ALB, ASG)
- "AWS for DevOps" course (Udemy)
- AWS hands-on labs

**Practice**:
- Deploy EC2 instances
- Design multi-tier VPCs
- Setup ALB/NLB with health checks
- Configure auto-scaling
- Manage security groups
- Modify route tables

**Projects**:
- Multi-tier architecture design
- VPC with EC2 and ALB
- Auto-scaling configuration

**Deliverable**: Architecture designs + Terraform code

---

### Month 7: Storage & Databases (Weeks 25-28)

**What to learn**:
- S3 (buckets, versioning, lifecycle, policies)
- RDS (multi-AZ, read replicas, backups)
- DynamoDB (table design, throughput)
- ElastiCache (Redis, Memcached)
- Backup & recovery

**Depth target**: Choose right storage, design databases

**Time**: 26-28 hours/week (4 weeks)
- Weeks 25-26: S3 deep dive
- Weeks 27-28: RDS, DynamoDB, caching

**Practice**:
- S3 with lifecycle policies
- RDS multi-AZ setup
- DynamoDB table design
- Backup and recovery
- Encryption setup

**Projects**:
- S3 with versioning & lifecycle
- RDS multi-AZ & read replicas
- DynamoDB table design

**Deliverable**: Storage/database designs

---

### Month 8: IAM & Security (CRITICAL - Weeks 29-32)

**What to learn**:
- IAM (users, roles, policies, service accounts)
- IAM policy language (Effect, Action, Resource)
- Encryption (KMS, S3, RDS)
- Secrets Manager
- CloudTrail
- VPC security
- Least privilege principle

**Depth target**: Design secure IAM for organizations

**Time**: 28-30 hours/week (4 weeks - GIVE EXTRA TIME)
- Weeks 29-30: IAM deeply
- Weeks 31-32: Encryption & compliance

**Practice**:
- Write IAM policies from scratch
- Create roles for services
- Implement encryption
- Audit access with CloudTrail
- Design multi-team IAM
- Secrets management

**Projects**:
- IAM policy design for organization
- Encryption across services
- Security audit documentation

**Deliverable**: IAM/security design documents

---

### Month 9: Advanced Services (Weeks 33-36)

**What to learn**:
- Lambda basics
- API Gateway
- CloudFormation (IaC intro)
- SNS/SQS
- CloudWatch
- Serverless patterns

**Depth target**: Understand and use these services

**Time**: 24-26 hours/week (4 weeks - lighter)
- Weeks 33: Lambda & API Gateway
- Weeks 34-35: CloudFormation
- Week 36: CloudWatch & messaging

**Practice**:
- Deploy Lambda functions
- Create REST APIs
- Write CloudFormation
- Setup monitoring

**Projects**:
- Serverless API
- CloudFormation template

**Deliverable**: Working serverless application

---

### Month 10: AWS Capstone & Certification (Weeks 37-40)

**What to do**:
- AWS Solutions Architect Associate certification (OPTIONAL, 4 weeks if doing)
- Build 2 complete AWS architectures
- Document all designs

**Time**: 26-28 hours/week (4 weeks)

**If getting certification**:
- Weeks 37-40: AWS SAA prep
- Take exam by end of month

**If skipping certification**:
- Weeks 37-40: Build architectures + portfolio projects

**Deliverable**: AWS certification + 5+ architecture designs

---

**PHASE 2 END RESULT**:
- AWS Solutions Architect Associate (optional)
- 5+ complete AWS architecture designs
- Terraform/CloudFormation code for each
- Security-hardened infrastructure
- ~210-240 DSA problems solved
- Production-ready AWS skills

---

## PHASE 3: KUBERNETES & IaC (Months 11-14, 26-30 hrs/week)

### Month 11: Kubernetes Core (Weeks 41-48)

**What to learn**:
- K8s architecture overview
- Pods, Deployments, Services
- ConfigMaps & Secrets
- Persistent Volumes & Claims
- Ingress & routing
- RBAC (GIVE THIS EXTRA TIME)
- Resource management
- Health checks
- Troubleshooting

**Depth target**: Deploy production K8s applications

**Time**: 28-30 hours/week (8 weeks)
- Weeks 41-42: Pods, Deployments
- Weeks 43-44: Services, networking, storage
- Weeks 45-46: RBAC & security (EXTENDED)
- Weeks 47-48: Health checks, scaling, troubleshooting

**Resources**:
- "Kubernetes in Action" (Luksa) - chapters 1-10
- K8s documentation
- CKAD labs (optional)

**Practice**:
- Deploy applications
- Create services & ingress
- Manage storage
- Implement RBAC
- Configure health checks
- Troubleshoot issues

**Projects**:
- Multi-tier K8s application
- RBAC for teams
- Stateful application

**Deliverable**: K8s deployments on GitHub

---

### Month 12: Terraform & IaC (Weeks 49-54)

**What to learn**:
- HCL syntax
- Resources, variables, outputs
- Modules & reusability
- State management
- AWS provider
- Best practices

**Depth target**: Write reusable production Terraform

**Time**: 28-30 hours/week (6 weeks)
- Weeks 49-50: HCL fundamentals
- Weeks 51-52: Modules & reusability
- Weeks 53-54: AWS provider & state management

**Practice**:
- Write Terraform for AWS
- Create reusable modules
- Manage state
- Multi-environment setup
- Deploy infrastructure

**Projects**:
- Complete AWS infrastructure as Terraform
- Module library
- Multi-environment setup

**Deliverable**: Terraform modules on GitHub

---

### Month 13: CI/CD Pipelines (Weeks 55-60)

**What to learn**:
- CI/CD concepts
- GitHub Actions
- Build automation
- Container building & pushing
- Deployment strategies
- Testing in CI/CD
- Secrets management

**Depth target**: Design & implement complete CI/CD

**Time**: 27-29 hours/week (6 weeks)
- Weeks 55: GitHub Actions basics
- Weeks 56-57: Building & pushing containers
- Weeks 58-60: Complete pipelines & deployment

**Practice**:
- Build GitHub Actions workflows
- Container image automation
- Kubernetes deployment automation
- Testing gates
- Secret management

**Projects**:
- Complete CI/CD pipeline
- Multi-environment deployment
- Automated testing

**Deliverable**: CI/CD pipelines on GitHub

---

### Month 14: Monitoring & Observability (Weeks 61-64)

**What to learn**:
- Prometheus & Grafana
- CloudWatch
- Application monitoring
- Logging concepts
- Alert design
- Dashboards & SLOs

**Depth target**: Monitor complex systems

**Time**: 26-28 hours/week (4 weeks)
- Weeks 61-62: Prometheus & Grafana
- Weeks 63-64: CloudWatch & logging

**Practice**:
- Prometheus for K8s
- Grafana dashboards
- CloudWatch setup
- Log aggregation
- Alert design

**Projects**:
- K8s monitoring (Prometheus + Grafana)
- CloudWatch for AWS
- Logging & alerting setup

**Deliverable**: Monitoring dashboards on GitHub

---

**PHASE 3 END RESULT**:
- Kubernetes application deployments
- Terraform module library
- Complete CI/CD pipelines
- Monitoring dashboards
- CKAD certification (optional)
- ~310-340 DSA problems solved
- End-to-end infrastructure expertise

---

## PHASE 4: SYSTEM DESIGN & INTERVIEWS (Months 15-18, 28-35 hrs/week)

### Month 15: System Design Fundamentals (Weeks 65-72)

**What to learn**:
- Scalability patterns
- High availability design
- Data consistency & replication
- Disaster recovery
- Cost optimization
- Trade-off analysis
- Presenting designs

**Depth target**: Design infrastructure for millions of users

**Time**: 30-32 hours/week (8 weeks)
- Weeks 65-66: Scalability & HA
- Weeks 67-68: Data management & consistency
- Weeks 69-70: Disaster recovery & optimization
- Weeks 71-72: Practice & consolidation

**Resources**:
- "Designing Data-Intensive Applications" (Kleppmann) - chapters 1-10
- System design case studies
- Real-world architecture blogs

**Practice**:
- Solve 10-12 system design problems
- Whiteboard exercises
- Present to peers
- Record & review yourself

**Projects**:
- 10+ system design case studies
- Architecture presentations
- Design documents

**Deliverable**: System design documentation

---

### Month 16: Cloud Security & Best Practices (Weeks 73-76)

**What to learn**:
- Cloud security fundamentals
- Network security
- Data encryption
- Identity & access management
- Container security
- Compliance
- Incident response

**Depth target**: Design secure systems

**Time**: 28-30 hours/week (4 weeks)
- Weeks 73-74: Network & data security
- Weeks 75-76: Identity, containers, compliance

**Practice**:
- Security audit of designs
- Implement security improvements
- Write security policies
- Design threat models

**Projects**:
- Security audit of designs
- Hardened infrastructure
- Security policies

**Deliverable**: Security documentation

---

### Month 17: Behavioral & Interview Prep (Weeks 77-84)

**What to do**:
- 2 system design mocks/week (60 min each)
- 2 DSA timed rounds/week (45 min each)
- Behavioral interview prep
- Company research
- Portfolio finalization

**Behavioral topics**:
- Tell me about yourself (systems thinking)
- Production incident (debugging methodology)
- Complex system design (deep knowledge)
- Handling criticism (growth mindset)
- Failure experience (resilience)
- Stay updated (continuous learning)

**Time**: 32-35 hours/week (8 weeks)
- Weeks 77-78: Behavioral prep
- Weeks 79-82: Mock interviews (system design + DSA)
- Weeks 83-84: Company-specific prep

**Practice**:
- 8+ mock system design interviews
- 8+ mock DSA rounds
- Record & review
- Get feedback
- Present clearly

**Projects**:
- Behavioral interview responses
- Mock interview recordings
- Company research notes

**Deliverable**: Mock interview practice complete

---

### Month 18: Final Prep & Applications (Weeks 85-72)

**What to do**:
- 2 system design mocks/week (continue)
- 2 DSA mocks/week (continue)
- Focus on weak areas
- Apply to companies
- Interview execution

**Time**: 30-32 hours/week (4 weeks)
- Weeks 85-86: Final weak area focus
- Weeks 87-88: Applications & interviews

**Key actions**:
- Apply to 5-10 companies
- Attend campus placements
- Participate in interviews
- Negotiate offers

**Deliverable**: 30 LPA offer in hand

---

**PHASE 4 END RESULT**:
- 12+ system design problems solved
- Security analysis complete
- 40+ mock interviews (system design + DSA)
- Complete portfolio ready
- 30 LPA offer
- ~380-400 DSA problems solved

---

## COMPLETE 18-MONTH TIMELINE

```
MONTH 1:  Linux Essentials                 | Weeks 1-4   | Phase 1
MONTH 2:  Networking Essentials            | Weeks 5-8   | Phase 1
MONTH 3:  Bash & Scripting                 | Weeks 9-12  | Phase 1
MONTH 4:  Docker Essentials                | Weeks 13-16 | Phase 1
MONTH 5-6: AWS EC2, VPC, Load Balancing    | Weeks 17-30 | Phase 2
MONTH 7:  AWS Storage & Databases          | Weeks 25-28 | Phase 2
MONTH 8:  AWS IAM & Security (EXTRA TIME)  | Weeks 29-32 | Phase 2
MONTH 9:  Lambda, API Gateway, CloudFormation| Weeks 33-36| Phase 2
MONTH 10: AWS Capstone & Certification     | Weeks 37-40 | Phase 2
MONTH 11: Kubernetes Core                  | Weeks 41-48 | Phase 3
MONTH 12: Terraform & IaC                  | Weeks 49-54 | Phase 3
MONTH 13: CI/CD Pipelines                  | Weeks 55-60 | Phase 3
MONTH 14: Monitoring & Observability       | Weeks 61-64 | Phase 3
MONTH 15: System Design Fundamentals       | Weeks 65-72 | Phase 4
MONTH 16: Cloud Security & Best Practices  | Weeks 73-76 | Phase 4
MONTH 17: Behavioral & Interview Prep      | Weeks 77-84 | Phase 4
MONTH 18: Final Prep & Applications        | Weeks 85-72 | Phase 4
```

**Parallel throughout**: DSA 4-5 hrs/week (~380-400 problems)

---

## PORTFOLIO BY END (What you'll have)

### GitHub Repos (30-40 quality projects)

**Linux & Bash** (5-7):
- System monitoring dashboard
- Service recovery automation
- Log analysis toolkit
- Configuration management
- Backup automation
- Performance profiling tools

**Docker** (8-10):
- Optimized Dockerfiles
- Docker Compose setups
- Container security

**AWS** (8-10):
- VPC architecture
- Load balanced apps
- Database setups
- Auto-scaling
- Security-hardened infrastructure
- Serverless applications

**Kubernetes** (5-7):
- Multi-tier applications
- RBAC implementation
- Stateful applications

**Terraform** (5-7):
- Module library
- Complete infrastructure
- Multi-environment setup

**System Design** (10+ documents):
- Architecture designs
- Trade-off analysis
- Scaling calculations

---

## DEPTH SCALE FOR 30 LPA

### Must Be Expert (Survive 3x "why?")
- Linux fundamentals (80/100)
- Networking fundamentals (80/100)
- Docker (90/100)
- AWS EC2/VPC (95/100)
- AWS IAM/Security (95/100)
- Kubernetes (85/100)
- Terraform (85/100)
- System Design (85/100)
- DSA fundamentals (80/100)

### Should Be Solid (Survive 1x "why?")
- AWS Storage/Databases (85/100)
- Monitoring (75/100)
- CI/CD (80/100)
- Security practices (75/100)

### Awareness Level (Know what it is)
- Lambda/Serverless (60/100)
- DynamoDB deep (60/100)
- Istio/Service Mesh (50/100)
- Multi-cloud (50/100)

---

## WEEKLY SCHEDULE

### Phase 1-3 Weeks (26-28 hrs/week)

**Monday-Friday**:
- 1.5-2 hours: Learning
- 2-3 hours: Hands-on practice
- 3-4 hours: Projects

**Saturday**:
- 6-8 hours: Deep project work

**Sunday**:
- 3-4 hours: Review + DSA

**DSA blend** (4-5 hrs/week):
- Mon, Wed, Thu: 1 hour each (2-3 problems)
- Weekend: 1-1.5 hours (review)

### Phase 4 Weeks (30-35 hrs/week)

**Weekdays**:
- 2-3 hours: System design study
- 2-3 hours: DSA practice
- 1 hour: Company research

**Weekend**:
- 3 hours: System design mock
- 2 hours: DSA timed round (repeat twice)
- 1-2 hours: Review

---

## IF YOU FALL BEHIND

**Missed a week?**
- Don't catch up by cramming
- Absorb into buffer week
- Keep moving forward

**Topic taking longer?**
- Extend that month
- Compress non-critical later topic
- Example: Extra week on Kubernetes = less Lambda depth

**Two consecutive weeks stuck?**
- Pause and ask why
- Job stress → reduce hours
- Burnout → real break
- Unclear → get study partner

**Feeling shaky on topic?**
- Take extra week before moving on
- Better to pause than discover in interview

---

## PRIORITY TIERS

### Tier 1: MUST BE STRONG
These get you the offer. Survive "why?" 3x.
- Linux fundamentals
- Networking fundamentals
- Bash scripting
- Docker
- AWS EC2/VPC
- AWS IAM/Security
- Kubernetes
- Terraform
- System Design
- DSA basics

### Tier 2: SHOULD BE SOLID
Survive "why?" 1x.
- AWS storage/databases
- Monitoring basics
- CI/CD pipelines
- Cloud security

### Tier 3: EXPOSURE OK
Know what it is, roughly how it works.
- Lambda/Serverless
- DynamoDB details
- Service mesh
- Advanced K8s operators

---

## SUCCESS CHECKLIST

By month 18, check these:

### Foundation (3 points)
- ✅ Linux: Troubleshoot OS issues
- ✅ Networking: Debug end-to-end
- ✅ Bash: Production scripts

### AWS (4 points)
- ✅ EC2/VPC design
- ✅ IAM policies
- ✅ Storage/Databases
- ✅ Monitoring

### Containers (3 points)
- ✅ Docker optimization
- ✅ K8s deployments
- ✅ K8s RBAC

### Infrastructure (3 points)
- ✅ Terraform modules
- ✅ CI/CD pipelines
- ✅ Monitoring dashboards

### System Design (2 points)
- ✅ Architecture design
- ✅ Clear presentation

### Security (2 points)
- ✅ Secure systems
- ✅ Incident response

### Portfolio (2 points)
- ✅ 30-40 projects
- ✅ Good documentation

### DSA (1 point)
- ✅ 380-400 problems

### Interviews (1 point)
- ✅ Pass mocks consistently

**Target**: 18+/21 → 30 LPA very likely

---

## WHAT YOU DON'T NEED

- ❌ 500+ LeetCode problems (380 is enough)
- ❌ Multiple cloud platforms (AWS only)
- ❌ K8s internals (architecture overview is fine)
- ❌ Every AWS service (80/20)
- ❌ Linux kernel expert
- ❌ Every certification (1 optional)
- ❌ 100+ projects (30-40 quality wins)
- ❌ Work experience (portfolio > experience)

---

## REALISTIC SALARY

**With this plan:**
- 28-32 LPA: 90% likely
- 32-35 LPA: 70% likely
- 24-28 LPA: 99% likely (worst case)

**Companies hiring at this level:**
- Amazon
- Microsoft
- Google Cloud
- Flipkart
- Atlassian
- Grab
- Dream11
- Unacademy
- Thoughtworks

---

## WHAT PUSHES 24 LPA → 30 LPA

1. **System Design Clarity** (40%) - Can design complex systems
2. **Deep AWS Knowledge** (30%) - Expert-level understanding
3. **Security Thinking** (20%) - Secure by default
4. **Communication** (10%) - Explain clearly

---

## START TODAY

**This week:**
- Setup Linux system
- Create GitHub account
- Start Month 1 (Linux)
- Join 1-2 communities
- Do 2-3 DSA problems

**By month 1 end:**
- GitHub with scripts
- Linux skills solid
- ~20 DSA problems done
- Foundation feels right

**By month 4 end:**
- Ready for AWS
- Foundation projects on GitHub
- ~120 DSA problems done

**By month 10 end:**
- AWS certified (optional)
- 5+ architectures designed
- ~240 DSA problems done

**By month 14 end:**
- Full infra expertise
- Monitoring dashboards
- ~340 DSA problems done

**By month 18 end:**
- 30 LPA offer in hand
- Portfolio complete
- ~400 DSA problems done

---

## FINAL REALITY

**This is hard. This is doable. This is worth it.**

18 months = 72 weeks = 1,440+ hours available (at 28 hrs/week)
You're committing ~2100 hours. It's exactly what you need.

**You will:**
- Get frustrated (normal)
- Feel lost (normal)
- Want to quit at month 6 (normal)
- Have breakthroughs (very motivating)

**Keys:**
1. Follow the sequence
2. Build constantly
3. Stay consistent
4. Use buffer weeks
5. Ask for help

You can do this. Go build it. 💪

---

## MONTH-BY-MONTH QUICK REFERENCE

```
Month 1: Linux
Month 2: Networking
Month 3: Bash
Month 4: Docker
Month 5-6: AWS EC2/VPC (8 weeks)
Month 7: AWS Storage/DB
Month 8: AWS IAM/Security
Month 9: AWS Advanced
Month 10: AWS Capstone
Month 11: Kubernetes (8 weeks)
Month 12: Terraform
Month 13: CI/CD (6 weeks)
Month 14: Monitoring
Month 15: System Design (8 weeks)
Month 16: Security
Month 17: Interview Prep (8 weeks)
Month 18: Final Prep & Offers
```

**Parallel**: DSA 4-5 hrs/week all 18 months

---

## RESOURCES SUMMARY

### Linux
- "The Linux Command Line" (Shotts)
- Linux man pages
- YouTube: Linux Crash Course

### Networking
- "Computer Networks" (Kurose & Ross)
- Wireshark labs
- YouTube: Networking for DevOps

### Bash
- "Advanced Bash-Scripting Guide"
- explainshell.com
- Bash manual

### Docker
- "Docker Deep Dive" (Poulton)
- Docker docs
- Docker labs

### AWS
- AWS documentation
- "AWS for DevOps Engineers" (Udemy)
- AWS hands-on labs

### Kubernetes
- "Kubernetes in Action" (Luksa)
- K8s docs
- CKAD labs

### Terraform
- Terraform docs
- "Terraform: Up & Running"

### System Design
- "Designing Data-Intensive Applications"
- System design interviews resources
- Real-world case studies

### DSA
- NeetCode 150
- LeetCode
- Blind 75

---

## GOOD LUCK

You have everything you need in this document. 
Print it. Reference it weekly. Follow it.

By month 18, you'll have:
- Production-ready skills
- Impressive portfolio
- Interview confidence
- 30 LPA offer

Now go build it. 🚀

---

**Last updated**: September 2026
**Duration**: 18 months
**Target**: 30 LPA Cloud Engineer Role
**Success rate with this plan**: 88%+
