# WEEK 10 – GIT & VERSION CONTROL — PROFESSIONAL WORKFLOW

**Focus:** Master Git branching, merging, rebasing, pull requests, GitHub Actions intro, and professional Git workflows used at companies like NVIDIA, Google, and AWS.  

---

# 🎯 Week 10 Objectives

By the end of Week 10, I aimed to:

- Understand Git internals and repository structure
- Learn professional branching workflows
- Master merging and rebasing strategies
- Understand interactive rebasing and history cleanup
- Learn proper commit conventions
- Configure professional Git environments
- Understand GitHub Pull Request workflows
- Learn code review etiquette
- Build GitHub Actions CI/CD workflows
- Improve repository hygiene and automation practices

---

# 📚 Resources Used

### Pro Git Book
- Completely free online Git book
- Used for understanding internals and workflows

### Learn Git Branching
- Interactive Git visualization platform
- Practiced branching, rebasing, merging, and moving commits

### GitHub Skills
- Guided GitHub workflow practice
- PRs, Actions, repository management

### Conventional Commits
- Learned professional commit message formatting standards

---

# 📅 Day 64 – Git Internals: Understanding the Fundamentals

## ✅ Topics Learned

### Git Data Model
Understood:
- Everything in Git is stored as SHA1 hashes
- Git tracks snapshots instead of file differences

Learned the 3 core Git areas:

#### Working Directory
- Actual files being edited

#### Staging Area (Index)
- Temporary preparation area before commit

#### Repository (.git)
- Stores Git history and objects

---

### Git Inspection Commands

Practiced:
    git status
    git diff
    git diff --staged

Learned:
- Difference between staged and unstaged changes
- How Git tracks modifications internally

---

### Interactive Staging

Command used:
    git add -p

Learned:
- Stage only selected portions of a file
- Useful for clean commits
- Commonly used in professional workflows

---

### Git History Visualization

Command used:
    git log --oneline --graph --all

Configured alias:
    git config --global alias.lg "log --oneline --graph --all"

Learned:
- Visual branch history
- Commit relationships
- Easier debugging and navigation

---

### Understanding HEAD

Learned:
- HEAD points to current checked-out commit
- Detached HEAD state
- Difference between:
    git checkout
and:
    git switch

---

### Hands-On Practice

Created:
- Test repository
- 5 separate commits

Practiced:
    git show COMMIT_HASH

Learned:
- Inspect commit contents
- Understand commit objects and snapshots

---

# 📅 Day 65 – Branching Strategies

## ✅ Topics Learned

### Branch Operations

Commands practiced:
    git branch feature-name
    git switch feature-name
    git switch -c new-branch

Learned:
- Create branches safely
- Switch between branches
- Isolate features independently

---

### Git Flow

Studied professional Git Flow structure:

#### main
- Production-ready code

#### develop
- Integration branch

#### feature branches
- New features

#### release branches
- Release preparation

#### hotfix branches
- Production bug fixes

---

### GitHub Flow

Learned simpler GitHub Flow:

- Main branch always deployable
- Feature branches for work
- Pull Requests for collaboration

Understood:
- Popular for startups and fast-moving teams

---

### Trunk-Based Development

Learned:
- Used by Google and NVIDIA
- Short-lived branches
- Frequent merges into main

Benefits:
- Faster integration
- Reduced merge conflicts
- Better CI/CD flow

---

### Interactive Practice

Completed:
- Introduction Sequence
- Ramping Up section

on Learn Git Branching.

---

# 📅 Day 66 – Merging & Rebasing

## ✅ Topics Learned

### Git Merge

Learned:
- Fast-forward merge
- Recursive merge

Command used:
    git merge feature-branch

Understood:
- When Git creates merge commits
- Linear vs non-linear history

---

### Git Rebase

Command used:
    git rebase main

Learned:
- Rebasing replays commits
- Produces cleaner linear history

Compared:
- merge vs rebase workflows

---

### Interactive Rebase

Command used:
    git rebase -i HEAD~3

Learned actions:
- pick
- reword
- squash
- fixup
- drop

Used to:
- Clean commit history
- Rename commits
- Combine commits

---

### Merge Conflicts

Practiced:
- Creating conflicting changes
- Resolving conflicts manually

Commands used:
    git add .
    git rebase --continue

and:
    git merge --continue

Learned:
- Conflict markers
- Manual conflict resolution workflow

---

### Practical Exercises

Completed:
- “Moving Work Around” section on Learn Git Branching

Also:
- Created real conflicting branches
- Resolved merge conflicts manually

---

# 📅 Day 67 – Conventional Commits & .gitignore

## ✅ Topics Learned

### Conventional Commits

Learned format:
    type(scope): description

Types studied:
- feat
- fix
- docs
- style
- refactor
- test
- chore
- ci

Examples practiced:
    feat(ec2): add multi-region instance listing
    fix(s3): handle bucket not found error
    docs: update README with usage examples

---

### .gitignore Files

Created professional `.gitignore` configurations.

Ignored:
    __pycache__/
    *.pyc
    .env
    .terraform/
    *.tfstate
    *.pem

Learned:
- Protect credentials
- Avoid unnecessary tracked files

---

### .gitignore Patterns

Studied:
    *
    !
    **/

Understood:
- Wildcards
- Negation rules
- Recursive matching
- Directory vs file matching

---

### GitHub Templates

Explored official GitHub gitignore templates.

Used:
- Python.gitignore
- Terraform.gitignore

Learned:
- Standardized repository hygiene practices

---

# 📅 Day 68 – GitHub Pull Requests & Code Review

## ✅ Topics Learned

### Pull Request Workflow

Understood:
    fork → branch → commit → push → PR → review → merge

Learned:
- Collaboration workflow
- Professional review process

---

### Writing Good PR Descriptions

Included:
- What changed
- Why it changed
- Testing information
- Linked issues

Understood:
- PR descriptions improve collaboration

---

### GitHub PR Features

Learned:
- reviewers
- assignees
- labels
- milestones
- draft PRs
- required reviews

---

### Code Review Etiquette

Practiced:
- Writing constructive feedback
- Suggesting improvements politely
- Using:
    nit:
for small suggestions

Learned:
- Good reviews improve code quality
- Communication matters in engineering teams

---

### Hands-On PR Practice

Completed:
- Opened Pull Request on personal repository
- Added review comments
- Merged using squash merge
- Deleted branch after merge

---

# 📅 Day 69 – GitHub Actions: CI/CD Introduction

## ✅ Topics Learned

### GitHub Actions Fundamentals

Learned:
- workflows
- jobs
- steps
- runners
- triggers

Workflow location:
    .github/workflows/

---

### First Workflow

Created:
    lint.yml

Workflow:
- Triggered on push
- Ran flake8 automatically

---

### Workflow Syntax

Studied:
    on:
    jobs:
    runs-on:
    steps:
    uses:
    run:

Learned:
- YAML workflow structure
- Reusable GitHub Actions

---

### Automated Testing

Added:
    pytest

after linting step.

Learned:
- CI/CD automates quality checks
- Prevents broken code from entering repositories

---

### README Status Badges

Added:
    ![CI](https://github.com/username/repo/workflows/CI/badge.svg)

Understood:
- Professional repositories show CI status publicly

---

# 📅 Day 70 – Week 10 Review & Git Mastery

## ✅ Topics Learned

### Completed Learn Git Branching Main Section

Finished:
- Main branching exercises
- Rebasing exercises
- Commit movement practice

Improved:
- Visual understanding of Git workflows

---

### Configured Git Aliases

Commands used:
    git config --global alias.st status
    git config --global alias.cm "commit -m"
    git config --global alias.br branch

Learned:
- Faster command execution
- Improved terminal productivity

---

### Repository Auditing

Reviewed all repositories for:
- Proper README
- `.gitignore`
- GitHub Actions workflows
- Clean structure

Learned:
- Repository quality matters professionally

---

### Global Git Configuration

Configured:
    git config --global core.editor "code --wait"
    git config --global init.defaultBranch main

Learned:
- Standardized development environment

---

### Commit History Cleanup

Used:
    git rebase -i

to rewrite messy histories.

Then:
    git push --force-with-lease

Learned:
- Clean commit history improves maintainability
- Interactive rebase is powerful for professional workflows

---

# 🧠 Key Concepts Learned During Week 10

- Git internals and SHA1 object storage  
- Working Directory vs Staging Area vs Repository  
- Branching workflows and strategies  
- Git Flow, GitHub Flow, trunk-based development  
- Merge vs rebase workflows  
- Interactive rebasing and history rewriting  
- Merge conflict resolution  
- Conventional Commit standards  
- `.gitignore` best practices  
- Pull Request workflow and code review etiquette  
- GitHub Actions and CI/CD basics  
- Repository hygiene and automation practices  

---

# 🔄 Major Mindset Shift

Moved from:

> Using Git only to save code  

To:

> Understanding Git as a professional collaboration, automation, deployment, and engineering workflow system  

---

# 💭 Week 10 Reflection

Week 10 was one of the most important milestones in my engineering journey so far.

This week built:
- Professional Git confidence
- Real-world collaboration workflow understanding
- Stronger repository management habits
- Cleaner commit history practices
- CI/CD automation foundations
- Better engineering discipline

I now understand why companies like Google, AWS, and NVIDIA treat Git workflows as a critical engineering skill.

---

# 🚀 Week 10 Outcome

After completing Week 10, I can now:

✅ Work confidently with branches  
✅ Rebase and clean commit history  
✅ Resolve merge conflicts manually  
✅ Create professional pull requests  
✅ Use GitHub Actions for automation  
✅ Maintain production-quality repositories  
✅ Follow professional engineering workflows  

---

**Week 10 Status:** Complete ✅  
**Days Completed:** 64–70 / 1000 🚀