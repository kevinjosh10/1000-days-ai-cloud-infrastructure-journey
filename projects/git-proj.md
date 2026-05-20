# WEEK 10 – PROJECTS & HANDS-ON PRACTICE

**Focus:** Git Internals, Branching Strategies, Rebasing, Pull Requests, GitHub Actions & Professional Repository Workflows  

---

# 🎯 Week 10 Project Objectives

This week focused on building real-world Git and GitHub workflow experience used by professional software engineers, DevOps engineers, and cloud infrastructure teams.

Main goals:
- Understand Git internals deeply
- Practice professional branching workflows
- Learn rebasing and history cleanup
- Handle merge conflicts manually
- Build CI/CD workflows using GitHub Actions
- Improve repository hygiene and organization
- Simulate real engineering collaboration practices

---

# 📁 Project 1 – Git Internals Sandbox Repository

## 📌 Objective

Build a practice repository to understand how Git stores commits, tracks changes, and manages snapshots internally.

---

## ✅ Tasks Performed

### Repository Initialization

Commands used:
    git init git-internals-lab

Configured repository:
    git config user.name
    git config user.email

---

### Created Multiple Commits

Added:
- Python files
- README updates
- Configuration changes

Created 5+ commits to study commit history.

---

### Practiced Git Inspection Commands

Commands used:
    git status
    git diff
    git diff --staged
    git log --oneline --graph --all
    git show COMMIT_HASH

---

### Practiced Interactive Staging

Command used:
    git add -p

Learned:
- Partial file staging
- Selective commit creation
- Cleaner commit management

---

## 🧠 Skills Gained

- Understanding Git internals
- SHA1 commit structure awareness
- Commit inspection and debugging
- Difference between staged and unstaged changes

---

# 📁 Project 2 – Branching Strategy Simulation

## 📌 Objective

Practice real-world branching workflows used in software engineering teams.

---

## ✅ Tasks Performed

### Created Feature Branches

Commands used:
    git branch feature-login
    git switch feature-login

Created additional branches:
- feature-api
- bugfix-auth
- release-v1

---

### Simulated Git Flow

Implemented:
- main branch
- develop branch
- feature branches
- hotfix branch

Practiced:
- merging feature branches into develop
- preparing release workflow

---

### Simulated GitHub Flow

Workflow practiced:
    main → feature branch → PR → merge

Learned:
- Simpler deployment workflow
- Continuous integration mindset

---

### Studied Trunk-Based Development

Practiced:
- Short-lived branches
- Frequent merges into main
- Smaller commits

Understood:
- Why companies like Google and NVIDIA use this workflow

---

## 🧠 Skills Gained

- Branch management
- Team collaboration workflows
- Understanding modern development strategies
- Real-world Git branching practices

---

# 📁 Project 3 – Merge & Rebase Laboratory

## 📌 Objective

Master merge operations, rebasing, interactive rebasing, and merge conflict resolution.

---

## ✅ Tasks Performed

### Practiced Merge Operations

Commands used:
    git merge feature-branch

Tested:
- Fast-forward merge
- Recursive merge

Learned:
- Linear vs non-linear history

---

### Practiced Rebasing

Command used:
    git rebase main

Compared:
- Merge workflow
- Rebase workflow

Observed:
- Cleaner commit history after rebasing

---

### Interactive Rebasing

Command used:
    git rebase -i HEAD~5

Performed:
- squash commits
- reword commit messages
- reorder commits
- drop unnecessary commits

---

### Created Merge Conflicts Intentionally

Modified same lines in different branches.

Resolved conflicts manually.

Commands used:
    git add .
    git rebase --continue

and:
    git merge --continue

---

## 🧠 Skills Gained

- Professional Git history management
- Interactive rebase workflow
- Conflict resolution
- Clean repository maintenance

---

# 📁 Project 4 – Conventional Commits & Repository Hygiene

## 📌 Objective

Standardize repository structure and commit conventions.

---

## ✅ Tasks Performed

### Practiced Conventional Commits

Examples used:
    feat(ec2): add instance monitoring
    fix(terraform): resolve provider issue
    docs: update deployment guide
    ci: add GitHub Actions workflow

---

### Built Professional `.gitignore`

Ignored:
    __pycache__/
    *.pyc
    .env
    .terraform/
    *.tfstate
    *.pem
    node_modules/

---

### Repository Cleanup

Improved:
- README structure
- Folder organization
- Documentation quality

Added:
- Project descriptions
- Setup instructions
- Usage examples

---

## 🧠 Skills Gained

- Professional repository management
- Documentation improvement
- Secure repository practices
- Standardized commit formatting

---

# 📁 Project 5 – GitHub Pull Request Workflow Simulation

## 📌 Objective

Simulate real-world collaboration using Pull Requests and code review workflows.

---

## ✅ Tasks Performed

### Created Feature Branch

Workflow:
    git switch -c feature-monitoring

---

### Opened Pull Request

Included:
- Change summary
- Testing information
- Why changes were needed

---

### Practiced Code Review

Added:
- Inline review comments
- Suggested improvements
- Feedback using professional review etiquette

Examples:
    nit: spacing can be improved here

---

### Merged Pull Request

Used:
- Squash merge

Deleted:
- Feature branch after merge

---

## 🧠 Skills Gained

- Pull Request workflow understanding
- Code review communication
- Collaboration best practices
- Clean merge management

---

# 📁 Project 6 – GitHub Actions CI/CD Workflow

## 📌 Objective

Build automated CI/CD workflows using GitHub Actions.

---

## ✅ Tasks Performed

### Created GitHub Actions Workflow

Path:
    .github/workflows/lint.yml

Workflow triggered:
- on push
- on pull_request

---

### Added Python Linting

Tool used:
    flake8

Learned:
- Automated code quality checking

---

### Added Automated Testing

Integrated:
    pytest

Workflow:
- lint first
- tests second

---

### Added CI Badge to README

Added:
    ![CI](https://github.com/username/repo/workflows/CI/badge.svg)

Understood:
- CI badges improve project professionalism

---

## 🧠 Skills Gained

- CI/CD fundamentals
- GitHub Actions workflow syntax
- YAML workflow structure
- Automated testing pipelines

---

# 📁 Project 7 – Git Mastery & Repository Audit

## 📌 Objective

Audit repositories and configure Git for professional daily use.

---

## ✅ Tasks Performed

### Configured Git Aliases

Commands used:
    git config --global alias.st status
    git config --global alias.cm "commit -m"
    git config --global alias.br branch
    git config --global alias.lg "log --oneline --graph --all"

---

### Configured Global Settings

Commands used:
    git config --global core.editor "code --wait"
    git config --global init.defaultBranch main

---

### Audited Existing Repositories

Verified:
- README presence
- `.gitignore`
- GitHub Actions workflows
- Commit quality
- Repository cleanliness

---

### Rewrote Commit History

Command used:
    git rebase -i

Then:
    git push --force-with-lease

Learned:
- Professional history cleanup workflow
- Safer force-pushing practices

---

## 🧠 Skills Gained

- Git productivity optimization
- Repository auditing
- Commit history cleanup
- Professional repository maintenance

---

# 🚀 Week 10 Final Outcome

By the end of Week 10, I successfully:

✅ Understood Git internals deeply  
✅ Mastered branching and rebasing workflows  
✅ Learned professional merge conflict resolution  
✅ Practiced real Pull Request workflows  
✅ Built GitHub Actions CI/CD pipelines  
✅ Improved repository structure and documentation  
✅ Configured Git for professional development workflows  
✅ Developed cleaner and more maintainable commit history practices  

---

# 💭 Week 10 Reflection

Week 10 transformed Git from a simple version control tool into a complete engineering workflow system.

This week significantly improved:
- Collaboration skills
- Repository organization
- Automation understanding
- Professional development workflows
- Engineering discipline

I now better understand how modern engineering teams manage large-scale software and infrastructure repositories.

---

**Week 10 Projects:** Complete ✅  
**Hands-On Labs Built:** 7  
**Days Covered:** 64–70 🚀