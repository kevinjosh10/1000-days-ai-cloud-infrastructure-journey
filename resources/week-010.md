# WEEK 10 – RESOURCES & REFERENCES

**Week:** 10  
**Focus:** Git Internals, Branching Strategies, Rebasing, Pull Requests, GitHub Actions & Professional Git Workflows  

---

# 🎯 Week 10 Learning Goals

The primary objective of Week 10 was to develop professional-level Git and GitHub workflow skills used in real-world software engineering and cloud infrastructure teams.

Main focus areas:
- Git internals
- Branching strategies
- Merge vs rebase workflows
- Interactive rebasing
- Pull Requests and code review
- Conventional commits
- `.gitignore` best practices
- GitHub Actions CI/CD basics
- Repository hygiene and collaboration workflows

---

# 📚 Primary Learning Resources

## 1️⃣ Pro Git Book

### Purpose
Used for:
- Understanding Git internals
- Advanced workflows
- Repository structure
- Professional Git practices

### Topics Studied
- Git object model
- SHA1 hashes
- Staging area
- Rebasing
- Branch management
- Merge workflows
- Interactive rebasing

### Key Learnings
- Git stores snapshots, not file diffs
- Understanding `.git` internals improves debugging
- Rebasing creates cleaner project history

Resource:
:contentReference[oaicite:0]{index=0}

---

# 2️⃣ Learn Git Branching

### Purpose
Interactive visual Git learning platform used to practice:
- Branching
- Rebasing
- Merging
- Cherry-picking
- Commit movement

### Sections Completed
- Introduction Sequence
- Ramping Up
- Moving Work Around
- Main section exercises

### Key Learnings
- Visual understanding of branch movement
- Rebase behavior visualization
- Merge conflict understanding
- Commit graph navigation

### Important Concepts Practiced
Commands:
    git branch
    git switch
    git merge
    git rebase
    git cherry-pick

Resource:
:contentReference[oaicite:1]{index=1}

---

# 3️⃣ GitHub Skills

### Purpose
Used for guided GitHub workflow training.

### Topics Practiced
- Pull Requests
- GitHub Flow
- Branch management
- Collaboration workflows
- GitHub Actions basics

### Key Learnings
- Real Pull Request workflow
- Collaboration and review process
- Branch protection concepts
- GitHub repository management

Resource:
:contentReference[oaicite:2]{index=2}

---

# 4️⃣ Conventional Commits

### Purpose
Learned professional commit message formatting standards.

### Format Learned
    type(scope): description

### Commit Types Studied
- feat
- fix
- docs
- style
- refactor
- test
- chore
- ci

### Examples Practiced
    feat(api): add monitoring endpoint
    fix(terraform): resolve provider issue
    docs: update README

### Key Learnings
- Standardized commit history
- Better collaboration
- Easier changelog generation
- Cleaner repository maintenance

Resource:
:contentReference[oaicite:3]{index=3}

---

# 📖 Git Commands Practiced During Week 10

## Git Status & Inspection

Commands:
    git status
    git diff
    git diff --staged
    git show COMMIT_HASH

Purpose:
- Inspect repository changes
- Compare staged vs unstaged modifications
- Analyze commit contents

---

# 📖 Branching Commands

Commands:
    git branch feature-name
    git switch feature-name
    git switch -c new-branch

Purpose:
- Create feature branches
- Isolate development safely
- Manage workflows professionally

---

# 📖 Merge & Rebase Commands

Commands:
    git merge feature-branch
    git rebase main
    git rebase -i HEAD~3

Purpose:
- Combine histories
- Create cleaner commit history
- Rewrite commits professionally

---

# 📖 Conflict Resolution Commands

Commands:
    git add .
    git rebase --continue
    git merge --continue

Purpose:
- Resolve merge conflicts manually
- Continue interrupted workflows

---

# 📖 Git History Visualization

Commands:
    git log --oneline --graph --all

Configured Alias:
    git config --global alias.lg "log --oneline --graph --all"

Purpose:
- Visualize branch history
- Understand commit relationships

---

# 📖 Git Configuration Commands

Commands:
    git config --global user.name "Kevin Joshua"
    git config --global user.email "your-email@example.com"
    git config --global core.editor "code --wait"
    git config --global init.defaultBranch main

Purpose:
- Configure professional Git environment

---

# 📖 Git Alias Commands

Commands:
    git config --global alias.st status
    git config --global alias.cm "commit -m"
    git config --global alias.br branch
    git config --global alias.co checkout

Purpose:
- Improve workflow speed
- Reduce repetitive typing

---

# 📖 Force Push & History Cleanup

Commands:
    git push --force-with-lease

Purpose:
- Update rewritten history safely
- Push rebased commits securely

---

# 📚 GitHub Actions Resources

## GitHub Actions Documentation

### Topics Learned
- workflows
- jobs
- steps
- runners
- triggers

### Workflow Structure
    .github/workflows/

### Example Workflow Files
    lint.yml
    test.yml

Resource:
:contentReference[oaicite:4]{index=4}

---

# 📚 GitHub gitignore Templates

### Purpose
Used official `.gitignore` templates for:
- Python
- Terraform
- Node.js

### Files Ignored
    __pycache__/
    *.pyc
    .terraform/
    *.tfstate
    .env
    *.pem

### Key Learnings
- Prevent secrets from being committed
- Maintain cleaner repositories

Resource:
:contentReference[oaicite:5]{index=5}

---

# 🧠 Major Concepts Learned From Week 10 Resources

## Git Internals
- SHA1 hashes
- Git object model
- Repository snapshots

---

## Professional Workflows
- Git Flow
- GitHub Flow
- Trunk-Based Development

---

## Repository Management
- Conventional Commits
- `.gitignore`
- README improvements

---

## Collaboration
- Pull Requests
- Code review etiquette
- Review comments
- Squash merges

---

## CI/CD Automation
- GitHub Actions
- YAML workflows
- Automated linting
- Automated testing

---

# 🚀 Most Valuable Resources This Week

## Best Interactive Learning
Learn Git Branching

Reason:
- Excellent Git visualization
- Hands-on branch movement practice
- Easy understanding of rebase concepts

---

## Best Deep Technical Resource
Pro Git Book

Reason:
- Strong Git internals explanation
- Advanced professional workflows
- Comprehensive Git knowledge

---

## Best Practical Collaboration Resource
GitHub Skills

Reason:
- Real GitHub workflow simulation
- Pull Request practice
- Collaboration-focused learning

---

# 💭 Week 10 Resource Reflection

Week 10 resources significantly improved my understanding of professional engineering workflows.

The combination of:
- theory
- visualization
- practical exercises
- repository management
- automation

helped transform Git knowledge into real engineering workflow skills.

This week built strong foundations for:
- DevOps
- Cloud Engineering
- Platform Engineering
- Infrastructure Automation
- CI/CD workflows
- Open-source collaboration

---

# 📈 Progress Update

**Week Completed:** 10 / 143  
**Days Completed:** 70 / 1000 🚀  
**Current Goal:** Becoming an AI Cloud Infrastructure Engineer  

---