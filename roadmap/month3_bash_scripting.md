# Month 3: Bash & Automation Scripting for Cloud Infrastructure Engineers — Mastery Roadmap

> **Goal:** Transition from writing fragile, one-line shell hacks to engineering robust, idempotent, production-grade Bash automation scripts for cloud, infrastructure, and CI/CD pipelines.

---

## 📅 Roadmap Overview

**Schedule:** 13-11-2026 to 12-12-2026 (30 Days Intensive)  
**Time Commitment:** 25–27 hours/week (~3.5–4 hours/day)  
**Deliverable:** 15–20 tested, production-grade scripts assembled into a GitHub repository (`production-bash-toolkit`).

| Phase | Duration & Dates | Focus Area | Key Concepts & Output |
|---|---|---|---|
| **Week 9** | Days 1–7 (13-11-2026 to 19-11-2026) | Variables, Strings & Arrays | Execution modes, quoting, parameter expansion, indexed & associative arrays |
| **Week 10** | Days 8–14 (20-11-2026 to 26-11-2026) | Control Flow, Functions & CLI Parsing | Modern conditionals (`[[ ]]`), loops, stream reading, modular functions, `getopts` |
| **Week 11** | Days 15–21 (27-11-2026 to 03-12-2026) | Industrial Text Processing | Extended `grep`, pattern space in `sed`, relational processing & math in `awk` |
| **Week 12** | Days 22–28 (04-12-2026 to 10-12-2026) | Defensiveness, Signals & Production Projects | `set -euo pipefail`, signal traps (`trap`), atomic file ops, backups, server health daemon |
| **Capstones** | Days 29–30 (11-12-2026 to 12-12-2026) | Enterprise Deployment & CI/CD Hardening | Automated zero-downtime deployer, ShellCheck linting, `bats-core` tests, GitHub release |

---

## 📚 Core Resources & Tooling

- **Primary Reference:** *Advanced Bash-Scripting Guide* (Mendel Cooper) — Sections 1–20
- **Official Specification:** GNU Bash Reference Manual (`man bash`)
- **Inspection & Validation:** [explainshell.com](https://explainshell.com/)
- **Linter & Test Frameworks:** `shellcheck` (static analysis) and `bats-core` (automated Bash testing)
- **Editor Setup:** VS Code / Neovim with `shellcheck` extension and `shfmt` formatter enabled

---

## Week 9: Variables, Parameter Expansion & Arrays (13-11-2026 to 19-11-2026)

### Day 1 (13-11-2026): Shell Architecture, Shebangs & Quoting Precision
- Subshells vs current shell execution (`bash script.sh` vs `./script.sh` vs `source script.sh`)
- Shebang portability: `#!/usr/bin/env bash` vs `#!/bin/bash`
- Strict quoting hierarchy:
  - Single quotes (`'...'`): literal preservation without interpolation
  - Double quotes (`"..."`): variable expansion, command substitution, arithmetic expansion
  - ANSI-C Quoting (`$'...'`): escape sequences (`\n`, `\t`, `\xHH`)
- Command substitution: modern `$(command)` vs legacy backticks `` `command` ``
- **Script 1:** `01_quote_inspector.sh` — Demonstrates whitespace preservation, escape sequences, and expansion differences across execution environments.

### Day 2 (14-11-2026): Shell Variables & Special Parameters
- Environment variables vs shell-local variables (`export` mechanics and scope inheritance)
- Read-only variables (`readonly` and `declare -r`)
- Automatic and special parameters:
  - `$0` (script path), `$#` (argument count), `$$` (PID), `$!` (last background PID), `$?` (exit code)
  - Crucial distinction: `"$@"` (preserves argument boundaries) vs `"$*"` (concatenates with first character of `$IFS`)
- **Script 2:** `02_param_sandbox.sh` — Inspects runtime process metrics, script invocation context, and parses arbitrary incoming argument streams.

### Day 3 (15-11-2026): Parameter Expansion Mastery
- Default value assignment:
  - `${var:-default}` (fallback if unset or null)
  - `${var:=default}` (assign default if unset or null)
  - `${var:+alternate}` (use alternate only if set and not null)
  - `${var:?errorMessage}` (fail script immediately with error if unset or null)
- String length measurement: `${#var}`
- Case modification (Bash 4+): `${var^^}` (uppercase), `${var,,}` (lowercase), `${var^}` (capitalize first character)
- **Script 3:** `03_env_validator.sh` — Production-grade environment configuration loader that validates cloud secrets and database credentials before app startup.

### Day 4 (16-11-2026): Advanced String Slicing & Pattern Substitution
- Substring extraction: `${var:offset:length}` and negative indexing `${var: -offset}`
- Prefix removal: `${var#pattern}` (shortest match) and `${var##pattern}` (greedy match)
- Suffix removal: `${var%pattern}` (shortest match) and `${var%%pattern}` (greedy match)
- Search and replace: `${var/pattern/replacement}` (first) and `${var//pattern/replacement}` (global)
- Path parsing without external binaries (replacing `dirname` and `basename` with pure parameter expansion for 100x speed)
- **Script 4:** `04_path_url_parser.sh` — High-speed string parser extracting protocol, domain, port, path, filename, and extension from raw S3/HTTP URIs.

### Day 5 (17-11-2026): Indexed Arrays
- Array declarations (`declare -a my_array`) and compound initialization (`arr=("item1" "item 2" "item3")`)
- Array operations:
  - Accessing elements: `"${arr[0]}"`, `"${arr[-1]}"`
  - Array length: `${#arr[@]}`
  - Slicing: `"${arr[@]:offset:length}"`
  - Appending elements: `arr+=("new_item")`
  - Safe array iteration pattern: `for item in "${arr[@]}"; do ... done`
- **Script 5:** `05_ip_whitelist_manager.sh` — Maintains, appends, slices, and checks a list of CIDR blocks for firewall rule generation.

### Day 6 (18-11-2026): Associative Arrays (Hashmaps / Dictionaries)
- Bash 4+ associative arrays (`declare -A server_roles`)
- Key-value mapping, key lookup, and checking key existence (`[[ -v map["$key"] ]]`)
- Iterating over keys: `for key in "${!map[@]}"; do ... done`
- Iterating over values: `for val in "${map[@]}"; do ... done`
- Simulating nested data structures and configuration mapping in pure Bash
- **Script 6:** `06_inventory_mapper.sh` — Maps hostnames to IP addresses, regions, and instance types, with lookup and JSON-like export capabilities.

### Day 7 (19-11-2026): Week 9 Consolidation & Review Project
- Complete review of parameter expansion, quoting edge-cases, and array manipulation
- Running `shellcheck` on all Week 9 scripts and eliminating all warnings
- **Project 1 (Core Deliverable):** `07_sysinfo_generator.sh`
  - Gathers CPU, memory, uptime, network interfaces, IP addresses, and kernel information
  - Formats metrics cleanly using associative arrays and parameter expansions
  - Supports Markdown and key-value stdout formatting

---

## Week 10: Control Flow, Functions & CLI Engineering (20-11-2026 to 26-11-2026)

### Day 8 (20-11-2026): Modern Conditionals & Test Operators
- The evolution of test: `test` vs `[ ... ]` vs `[[ ... ]]` vs `(( ... ))`
- Why `[[ ... ]]` is mandatory in modern Bash: no word splitting, regex support (`=~`), logical operators (`&&`, `||`)
- Essential file test flags: `-e` (exists), `-f` (regular file), `-d` (directory), `-s` (non-empty), `-r`/`-w`/`-x` (permissions)
- String tests: `-z` (empty string), `-n` (non-empty string), `==` (pattern matching)
- Arithmetic conditionals: `(( a > b ))`, `(( a % 2 == 0 ))`
- **Script 7:** `08_file_sentinel.sh` — Audits target paths, verifies file types, checks read/write permissions, and alerts on empty or missing assets.

### Day 9 (21-11-2026): Advanced Branching: `if/elif/else` & `case`
- Idiomatic `if/elif/else` syntax and exit code evaluation
- The hazard of shorthand `cmd1 && cmd2 || cmd3` (why it's not a true ternary and can cause silent bugs)
- Multi-branch pattern matching with `case ... in ... esac`
- Wildcard globbing inside `case` statements (`*.tar.gz | *.tgz)`)
- Bash 4+ fallthrough operators in `case`: `;&` and `;;&`
- **Script 8:** `09_os_detector.sh` — Inspects `/etc/os-release`, identifies Linux distribution families (Debian, RHEL, Alpine, Arch), and triggers tailored installation commands.

### Day 10 (22-11-2026): Loops & Safe Iteration
- C-style arithmetic loops: `for (( i=0; i<max; i++ ))`
- Item iteration: `for item in "${items[@]}"`
- Safe iteration over files: Why `for f in *.log` is safe, but `for f in $(ls *.log)` is dangerously broken
- Handling zero-match globs: `shopt -s nullglob`
- `while` and `until` loops: condition polling and timeout backoffs
- **Script 9:** `10_service_poller.sh` — Periodically polls a network endpoint or service status with exponential backoff and timeout thresholds.

### Day 11 (23-11-2026): Stream Processing with `read` & File Descriptors
- The definitive line-by-line reading idiom: `while IFS= read -r line || [[ -n "$line" ]]; do ... done < file`
- Why `IFS=` and `-r` are strictly required (disabling whitespace stripping and backslash escaping)
- The pipeline subshell trap: Why `cat file | while read line; do counter=$((counter+1)); done; echo $counter` outputs `0`
- Process substitution to avoid subshells: `while read -r line; do ... done < <(command)`
- Custom File Descriptors: redirecting, opening, and closing (`exec 3>&1`, `exec 3>&-`)
- **Script 10:** `11_csv_database_reader.sh` — Reads a multi-column CSV file, cleans whitespace, validates schema fields, and outputs structured config payloads.

### Day 12 (24-11-2026): Functions, Local Scoping & Return Protocols
- Defining functions: `func_name() { ... }`
- Local variables: The absolute rule of `local my_var` (preventing catastrophic global namespace pollution)
- Return codes: `return 0` to `255` (conveying status, not data)
- Returning strings/arrays from functions:
  - Approach A: `echo "$result"` captured via `$(func)` (subshell overhead)
  - Approach B: Name references via `declare -n ref=$1` (zero-overhead in-place mutation)
- **Script 11:** `12_network_math_lib.sh` — Reusable function library containing IP validation, integer-to-IP conversion, and ping latency calculation.

### Day 13 (25-11-2026): CLI Argument Parsing with `getopts`
- Single-letter options: `getopts "hvf:p:" opt`
- Handling options with and without arguments (the colon `:` mechanic)
- Tracking argument pointers with `$OPTIND` and `$OPTARG`
- Shifting parsed flags to consume positional arguments (`shift $((OPTIND - 1))`)
- Writing professional usage/help menus (`-h | --help`)
- **Script 12:** `13_cli_arg_framework.sh` — Robust CLI argument parser supporting verbosity levels, config file paths, port numbers, and help documentation.

### Day 14 (26-11-2026): Week 10 Consolidation & Control Script
- Combining functions, `getopts`, `case`, and process verification
- **Project 2 (Core Deliverable):** `14_service_ctl.sh`
  - A unified CLI controller for microservices or local containers
  - Commands: `start`, `stop`, `restart`, `status`, `health`
  - Options: `-e <env>`, `-p <port>`, `-t <timeout>`, `-v` (verbose)

---

## Week 11: Text Processing Engine — `grep`, `sed` & `awk` (27-11-2026 to 03-12-2026)

### Day 15 (27-11-2026): Advanced `grep` & Regular Expressions
- Regex flavors: Basic Regular Expressions (BRE) vs Extended (ERE: `grep -E`) vs PCRE (`grep -P`)
- Critical flags: `-v` (invert), `-c` (count), `-n` (line numbers), `-o` (only matching), `-q` (quiet check), `-H` (filename)
- Contextual inspection: `-A NUM` (after), `-B NUM` (before), `-C NUM` (both)
- Word boundaries (`\b`), line anchors (`^`, `$`), and character classes (`[[:digit:]]`, `[[:space:]]`)
- **Script 13:** `15_security_audit_grep.sh` — Scans `/var/log/auth.log` or systemd journals for failed SSH attempts, brute force attacks, and invalid user patterns.

### Day 16 (28-11-2026): Stream Editor (`sed`) Fundamentals
- How `sed` works: line cycle, pattern space, and hold space
- Addressing schemes: line numbers (`1,10`), regex addresses (`/pattern/`), step addressing (`1~2`)
- The substitution command: `s/pattern/replacement/flags` (`g`, `i`, `p`, `w`)
- Choosing custom delimiters (`s#http://#https://#g`) to avoid "leaning toothpick syndrome"
- In-place file modification: `sed -i` (and handling macOS/BSD differences with `sed -i.bak`)
- **Script 14:** `16_config_sanitizer.sh` — Automates configuration file updates: strips comments, updates key-value pairs, and normalizes delimiters across files.

### Day 17 (29-11-2026): Advanced `sed` Scripts & Multiline Editing
- Deleting lines (`d`), printing matches (`-n` with `p`), inserting/appending (`i`, `a`, `c`)
- Backreferences: capturing groups with `\1`, `\2` to reorganize text
- Pattern space and hold space manipulation: `h` (copy), `H` (append), `g` (get), `G` (append get), `x` (exchange)
- Branching and loops in `sed`: `b` (branch) and `t` (test on successful substitution)
- **Script 15:** `17_nginx_conf_updater.sh` — Dynamically injects proxy headers, SSL parameters, and server names into Nginx/Apache configuration blocks.

### Day 18 (30-11-2026): `awk` Core Architecture & Record Processing
- The fundamental `awk` structure: `awk 'BEGIN { ... } pattern { ... } END { ... }'`
- Built-in record and field variables:
  - `$0` (entire record), `$1`..`$NF` (fields), `NF` (number of fields)
  - `NR` (total record count), `FNR` (current file record count)
  - `FS` (input field separator), `OFS` (output field separator), `RS` (record separator)
- Printing and formatting output: `print` vs `printf` (precision formatting)
- **Script 16:** `18_ps_resource_monitor.sh` — Parses `ps aux` output with `awk`, computes memory and CPU percentage sums, and filters anomalous top processes.

### Day 19 (01-12-2026): `awk` Advanced Programming & Hash Arrays
- Arithmetic and relational operators in `awk`
- Dynamic conditional statements (`if/else`) and loops (`for`, `while`) inside `awk`
- Associative arrays in `awk` (computing frequencies, grouping sums, deduplicating)
- Essential built-in functions: `split()`, `substr()`, `length()`, `index()`, `match()`, `gsub()`, `systime()`
- Passing external Bash variables into `awk` cleanly using `-v var="$bash_var"`
- **Script 17:** `19_ip_traffic_aggregator.sh` — Reads access logs, uses associative arrays to group requests by client IP, and outputs total traffic per IP in MB.

### Day 20 (02-12-2026): The Stream Pipeline Triad (`sort`, `uniq`, `xargs`, `cut`, `tr`)
- High-performance stream filtering without loading whole files into memory
- `sort`: numeric (`-n`), reverse (`-r`), human-readable numbers (`-h`), key selection (`-k2,2`)
- `uniq`: counting occurrences (`-c`), only duplicates (`-d`), unique lines (`-u`)
- `xargs`: command batching, parallel execution (`-P 4`), and null-terminated handling (`-0`)
- Benchmark comparison: when to use pure Bash vs `awk` vs Python
- **Script 18:** `20_disk_space_hog_hunter.sh` — Finds the top 20 largest directories/files, sorts by size, and outputs actionable cleanup targets.

### Day 21 (03-12-2026): Week 11 Consolidation & Log Analysis Engine
- Unifying `grep`, `sed`, and `awk` into an end-to-end analytical pipeline
- **Project 3 (Core Deliverable):** `21_log_analyzer.sh`
  - Parses Nginx/Apache or cloud access logs (100MB+)
  - Extracts HTTP status codes (2xx, 3xx, 4xx, 5xx distribution)
  - Identifies top 10 requesting IP addresses and geographical origins
  - Identifies top 10 requested URLs and 404 endpoints
  - Computes average request response times and peak traffic windows
  - Generates an executive summary report to stdout and HTML

---

## Week 12: Production-Grade Engineering, Signals & System Daemons (04-12-2026 to 10-12-2026)

### Day 22 (04-12-2026): The Unofficial Strict Mode & Defensive Coding
- Deconstructing strict mode: `set -euo pipefail`
  - `set -e`: exit immediately on unhandled command failure
  - `set -u`: treat unset variables as an error
  - `set -o pipefail`: pipeline fails if any command in the chain fails
- Safe variable defaults when strict mode is active (`${var:-}`)
- Working around legitimate non-zero exits: `command || true` and `if ! command; then ... fi`
- Debugging flags: `set -x` (print commands before execution) and `export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'`
- **Script 19:** `22_strict_template.sh` — A hardened boilerplate template used as the foundation for all future production scripts.

### Day 23 (05-12-2026): Signal Traps, Mutex Locks & Atomic Cleanup
- Linux process signals: `SIGINT` (2), `SIGTERM` (15), `SIGKILL` (9), `EXIT` (pseudo-signal)
- Managing exit traps: `trap cleanup_function EXIT INT TERM`
- Temporary files done right: `mktemp` and `mktemp -d`
- Concurrency control and mutex locking:
  - Preventing overlapping cron executions
  - Atomic file locks with `flock`
  - Lockfile directory technique (`mkdir /var/lock/myscript.lock`)
- **Script 20:** `23_atomic_lock_runner.sh` — Ensures only a single instance of a long-running batch job can run concurrently, safely releasing locks and cleaning temp files on kill.

### Day 24 (06-12-2026): Structured Logging & Syslog Integration
- Formatting standard log levels: `DEBUG`, `INFO`, `NOTICE`, `WARN`, `ERROR`, `FATAL`
- ISO 8601 timestamps: `date -u +"%Y-%m-%dT%H:%M:%SZ"`
- Directing error logs to `stderr` (`>&2`) and data to `stdout` (`>&1`)
- ANSI color formatting for interactive terminals (auto-disabled if output is piped or non-TTY)
- System logging integration: sending events to `/dev/log` and systemd journal via `logger`
- **Script 21:** `24_structured_logger.sh` — A standalone logging library ready to be sourced by other automation scripts.

### Day 25 (07-12-2026): File System Operations, Archival & Checksums
- Safe file traversal: `find . -type f -name "*.log" -print0 | xargs -0 ...`
- Atomic file replacements: writing to `.tmp` file and `mv` replacing to prevent reading corrupted partial writes
- Generating and verifying cryptographic integrity: `sha256sum -c`
- Compression and archive streaming: `tar -czf`, `pigz` (multithreaded gzip)
- **Script 22:** `25_file_integrity_checker.sh` — Hashes critical system configuration files, stores baselines, and generates diff alerts on tampering or unauthorized changes.

### Day 26 (08-12-2026): Background Jobs, Process Pools & Concurrency
- Backgrounding tasks (`&`) and job tracking (`jobs -l`)
- Collecting child process exit codes with `wait $PID`
- Implementing a parallel worker pool in pure Bash (controlling concurrency limit `MAX_JOBS=4`)
- Execution timeouts using the `timeout` command
- **Script 23:** `26_parallel_ping_sweep.sh` — Sweeps an entire `/24` subnet using a pool of parallel background worker processes, reporting alive hosts in seconds.

### Day 27 (09-12-2026): Automated Backup & Rotation Engine
- Designing idempotent backup procedures
- Snapshot creation, file exclusions, and dynamic timestamp naming
- Backup rotation policies: Grandfather-Father-Son (GFS) or keeping last $N$ daily, $W$ weekly backups
- Remote transfer integration (`rsync` over SSH / AWS CLI S3 sync)
- **Project 4 (Core Deliverable):** `27_backup_engine.sh`
  - Backs up targeted application and database directories
  - Compresses archives with SHA256 checksums
  - Implements retention policy (deletes archives older than $X$ days)
  - Dispatches Slack/Webhook notification upon success or failure

### Day 28 (10-12-2026): Server Health & Resource Metric Collector
- Sampling real-time system metrics:
  - CPU usage (`top` / `/proc/stat`)
  - RAM & Swap usage (`free -m` / `/proc/meminfo`)
  - Disk utilization (`df -h`) and inode exhaustion (`df -i`)
  - Zombie and defunct process detection (`ps -eo stat,pid,cmd`)
  - Network connection states (`ss -s` / `ss -tulpn`)
- Threshold alerting (triggering warning when disk > 85% or RAM > 90%)
- **Project 5 (Core Deliverable):** `28_healthcheck.sh`
  - Automated diagnostic daemon
  - Generates JSON health payloads for monitoring systems
  - Emits colorized console dashboards and sends alert emails on threshold violations

---

## 🚀 Capstone Revision & Portfolio Hardening (11-12-2026 to 12-12-2026)

### Day 29 (11-12-2026): Enterprise Configuration & Zero-Downtime Deployment
- Designing deployment pipelines with atomic rollbacks
- Git integration: shallow clones (`--depth 1`), commit hash verification
- Environment variable injection and template rendering
- Pre-flight checks (dependency verification, port availability, disk space)
- Service restart protocols (`systemctl restart`, `systemctl is-active`)
- Automated health check verification and instant rollback on failure
- **Capstone Project (Core Deliverable):** `29_deploy_service.sh`
  - Clones or updates application code from Git
  - Creates symlink-based deployment releases (`/releases/v1`, `/releases/v2`, `/current`)
  - Runs pre-flight and database migration scripts
  - Switches symlink atomically to zero-downtime traffic
  - Automatically reverts `/current` to previous release if health probes fail within 30 seconds

### Day 30 (12-12-2026): Linting, Testing, CI/CD Integration & GitHub Polish
- **Static Analysis at Scale:**
  - Running `shellcheck -x -S style` across all 20+ repository scripts
  - Resolving every warning and documenting necessary overrides (`# shellcheck disable=SCxxxx`)
- **Automated Testing with `bats-core`:**
  - Writing unit tests for Bash functions (testing exit codes, stdout matching, error handling)
- **GitHub Actions CI Pipeline:**
  - Creating `.github/workflows/lint-and-test.yml`
  - Automatically running `shellcheck` and `bats` on every `git push`
- **Repository Assembly (`production-bash-toolkit`):**
  - Polishing directory structure (`bin/`, `lib/`, `tests/`, `docs/`)
  - Writing an elite `README.md` with usage examples, architecture diagrams, and test badges
  - Tagging release `v1.0.0`

---

## 🎯 Month-End Mastery Checklist

You have successfully mastered Month 3 when you can answer **YES** to all of the following:

- [ ] Can you write a 200-line script using `set -euo pipefail` that never crashes unexpectedly?
- [ ] Do you instinctively quote all variable references (`"${var}"`) and explain why unquoted variables break in production?
- [ ] Can you extract file extensions, base paths, and query parameters using pure parameter expansion without calling `awk` or `sed`?
- [ ] Can you parse complex command-line flags (`-a`, `-b <val>`, `--long`) using `getopts` and provide a clean `--help` menu?
- [ ] Can you write a one-line `awk` script to parse an access log and output the top 10 requesting IP addresses?
- [ ] Can you set up a signal trap (`trap`) that guarantees temporary files are deleted even if someone hits `Ctrl+C` or sends `SIGTERM`?
- [ ] Can you build an atomic mutex lock (`flock`) to prevent multiple cron jobs from running simultaneously?
- [ ] Do all your scripts pass `shellcheck` with zero errors or warnings?
- [ ] Is your `production-bash-toolkit` repository live on GitHub with complete documentation and passing CI tests?
