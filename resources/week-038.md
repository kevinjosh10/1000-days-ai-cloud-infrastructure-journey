# Week 38 Resources: Mastering Shell Scripting: Data Structures, Control Flow, Pattern Matching & Defensive Automation

## 📅 Timeline: Days 260 - 266 (November 16, 2026 – November 22, 2026)

---

## Day 260 / 1000 — Day 4 / 30: Advanced String Slicing & Pattern Substitution
- **Date:** November 16, 2026 (Calendar: November 16, 2026 (Monday))

```text
                     Zero-Based Offset & Length Indexing
                     
  String:   "I n f r a s t r u c t u r e"
  Index:     0 1 2 3 4 5 6 7 8 9 ...
             ├───────┤ ├───────┤ ├──────┤
             ${s:0:5}  ${s:5:5}  ${s:10:4}
             "Infra"   "struc"   "ture"
```

```bash
${VARIABLE:OFFSET:LENGTH}
```

```bash
#!/usr/bin/env bash

TARGET="CloudInfrastructure"

echo "${TARGET:0:5}"  # Output: Cloud
echo "${TARGET:5:8}"  # Output: Infrastr
echo "${TARGET:5}"    # Output: Infrastructure (length omitted)
```

```text
                     Negative Indexing Offset Mechanics
                     
  String:   "b a c k u p . t a r . g z"
  Index:    ... -7 -6 -5 -4 -3 -2 -1
                         ├─────────┤
                         ${filename: -5}  ──► "ar.gz" (or "tar.gz" if -6)
```

```bash
filename="backup_2026.tar.gz"

echo "${filename: -2}"     # Output: gz (last 2 characters)
echo "${filename: -6}"     # Output: tar.gz (last 6 characters)
echo "${filename: -6:3}"   # Output: tar (starts 6 from end, extracts 3 chars)
```

```text
                  Prefix Removal: Shortest (#) vs. Longest (##)
                  
  Path:  "/home/kevin/projects/cloud/app.sh"
          ├────┤
          ${path#*/}  (Shortest: matches up to first '/')
          Result: "home/kevin/projects/cloud/app.sh"
          
          ├─────────────────────────┤
          ${path##*/} (Longest: matches up to LAST '/')
          Result: "app.sh" (Native basename!)
```

```bash
FILEPATH="/var/log/nginx/access.log"

# Shortest prefix up to the first slash
echo "${FILEPATH#*/}"   # Output: var/log/nginx/access.log

# Longest prefix up to the last slash (Equivalent to 'basename')
echo "${FILEPATH##*/}"  # Output: access.log

# Strip protocol scheme from URL
URL="https://api.cloud.internal/v1"
echo "${URL#*://}"      # Output: api.cloud.internal/v1
```

```text
                  Suffix Removal: Shortest (%) vs. Longest (%%)
                  
  Filename:  "database_backup.tar.gz"
                             ├───┤
                             ${f%.*}  (Shortest: strips '.gz')
                             Result: "database_backup.tar"
                             
                             ├────────┤
                             ${f%%.*} (Longest: strips '.tar.gz')
                             Result: "database_backup"
```

```bash
ARCHIVE="database_backup.tar.gz"

# Shortest suffix: strips final extension
echo "${ARCHIVE%.*}"    # Output: database_backup.tar

# Longest suffix: strips all extensions from first dot
echo "${ARCHIVE%%.*}"   # Output: database_backup

# Extract file directory (Equivalent to 'dirname')
FILEPATH="/var/log/nginx/access.log"
echo "${FILEPATH%/*}"   # Output: /var/log/nginx

# Extract final file extension
echo "${ARCHIVE##*.}"   # Output: gz
```

```text
                     Search and Replace Operators
                     
  String: "prod-api-prod-db-prod-cache"
  
  ${s/prod/dev}   (Single slash):  "dev-api-prod-db-prod-cache"  (First match only)
  ${s//prod/dev}  (Double slash):  "dev-api-dev-db-dev-cache"    (All matches globally)
  ${s/#prod/edge} (Leading match): "edge-api-prod-db-prod-cache" (Anchored to start)
  ${s/%cache/mq}  (Trailing match):"prod-api-prod-db-prod-mq"    (Anchored to end)
```

```bash
RAW_KEY="Production Database Backup 2026-11-16.sql"

# Replace all spaces with underscores in-memory
SANITIZED_KEY="${RAW_KEY// /_}"
echo "S3 Key: ${SANITIZED_KEY}"
# Output: S3 Key: Production_Database_Backup_2026-11-16.sql
```

```text
                  Glob Patterns vs. Regular Expressions
                  
  FEATURE            BASH GLOB PATTERN           REGULAR EXPRESSION (regex)
  Any characters     *                           .*
  Single character   ?                           .
  Literal dot        .                           \.
  Character class    [0-9], [a-z], [A-Z]         [0-9], [a-z], [A-Z]
  Inversion          [!abc] or [^abc]            [^abc]
```

```bash
IDENTIFIER="cloud-compute-worker-042"

# Strip up to first hyphen
echo "${IDENTIFIER#*-}"    # Output: compute-worker-042

# Strip up to last hyphen
echo "${IDENTIFIER##*-}"   # Output: 042

# Strip from first hyphen to end
echo "${IDENTIFIER%%-*}"   # Output: cloud
```

```text
             External Binaries vs. Pure Parameter Expansion
             
  [ EXTERNAL COMMAND ]: basename "$path"
  Kernel ──► fork() ──► execve("/usr/bin/basename") ──► load ELF ──► exit()  (~2.5 ms)
  
  [ PURE BASH ]: ${path##*/}
  Bash evaluates internal string pointer directly in memory                 (<0.001 ms)
```

```bash
#!/usr/bin/env bash
set -euo pipefail

decompose_path() {
    local file_path="${1:-}"

    # 1. Directory path (dirname replacement)
    local directory="${file_path%/*}"
    # Handle root or relative edge cases
    [[ "$directory" == "$file_path" ]] && directory="."
    [[ -z "$directory" ]] && directory="/"

    # 2. Complete filename (basename replacement)
    local filename="${file_path##*/}"

    # 3. Filename stem and extension
    local extension=""
    local filename_without_extension="$filename"

    # Handle hidden files (e.g., .env, .gitignore) and normal extensions
    if [[ "$filename" == *.* && "$filename" != .* ]]; then
        extension="${filename##*.}"
        filename_without_extension="${filename%.*}"
    fi

    echo "Input Path : $file_path"
    echo "Directory  : $directory"
    echo "Filename   : $filename"
    echo "Stem Name  : $filename_without_extension"
    echo "Extension  : ${extension:-<None>}"
}

decompose_path "/var/log/kubernetes/kube-apiserver.audit.log"
```

```text
Input Path : /var/log/kubernetes/kube-apiserver.audit.log
Directory  : /var/log/kubernetes
Filename   : kube-apiserver.audit.log
Stem Name  : kube-apiserver.audit
Extension  : log
```

```text
                     Cloud URI Anatomy & Extraction
                     
  [ HTTPS URL ]
  https://storage.example.com:8443/backups/db.sql.gz?token=secret#dl
  │▲───┘  │◄─────────────────►│▲─┘│◄────────────────►│▲────────────┘
  │       Domain              │   Path               Query / Fragment
  Protocol                    Port
  
  [ S3 URI ]
  s3://prod-company-backups/aurora/db.sql.gz
  │▲─┘ │◄─────────────────►│◄──────────────►│
  │    Bucket               Object Key (Path)
  Protocol
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# Script   : 04_path_url_parser.sh
# Track    : Mastering Shell Scripting & Automation — Day 4/30
# Journey  : Day 260/1000
# Purpose  : High-Performance Pure Bash URI and Path Dissection Utility
# ==============================================================================

set -Eeuo pipefail

parse_uri() {
    local uri="${1:-}"

    local protocol=""
    local authority=""
    local domain=""
    local port=""
    local path=""
    local filename=""
    local extension=""
    local object_key=""

    # 1. Input Validation
    if [[ -z "$uri" ]]; then
        echo "Error: URI string must not be empty." >&2
        return 1
    fi

    # 2. Scheme / Protocol Extraction
    if [[ "$uri" != *"://"* ]]; then
        echo "Error: Invalid URI format. Missing '://' scheme delimiter." >&2
        return 1
    fi

    protocol="${uri%%://*}"
    local rest="${uri#*://}"

    case "$protocol" in
        http|https|s3)
            # Supported cloud schemes
            ;;
        *)
            echo "Error: Unsupported scheme '${protocol}'. Supported: http, https, s3." >&2
            return 1
            ;;
    esac

    # 3. Authority Extraction (Host / Bucket)
    # Extracts everything up to the first slash, question mark, or hash
    authority="${rest%%[/?#]*}"

    if [[ -z "$authority" ]]; then
        echo "Error: Missing host authority or S3 bucket name in URI." >&2
        return 1
    fi

    # 4. Path Extraction & Normalization
    local remaining="${rest#"$authority"}"

    # Strip query string (?) and fragment (#)
    path="${remaining%%[\?#]*}"

    # Strip leading slash for processing
    path="${path#/}"

    # 5. Domain and Port Parsing
    if [[ "$protocol" == "s3" ]]; then
        domain="$authority"
        object_key="$path"
    else
        if [[ "$authority" == *:* ]]; then
            domain="${authority%:*}"
            port="${authority##*:}"

            # Strict numeric port validation
            if [[ ! "$port" =~ ^[0-9]+$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
                echo "Error: Invalid port number '${port}' in authority." >&2
                return 1
            fi
        else
            domain="$authority"
        fi
    fi

    # 6. Filename and Extension Parsing
    filename="${path##*/}"

    # Extract extension if file has a dot and is not a hidden dotfile
    if [[ "$filename" == *.* && "$filename" != .* ]]; then
        extension="${filename##*.}"
    fi

    # 7. Formatted Diagnostic Output
    echo "=================================================================="
    echo "                     CLOUD URI PARSER REPORT                      "
    echo "=================================================================="
    echo "  Original URI  : ${uri}"
    echo "  Protocol      : ${protocol}"
    echo "  Domain/Bucket : ${domain}"
    echo "  Port          : ${port:-<None>}"
    echo "  Path          : /${path}"
    echo "  Filename      : ${filename:-<None>}"
    echo "  Extension     : ${extension:-<None>}"

    if [[ "$protocol" == "s3" ]]; then
        echo "  S3 Object Key : ${object_key}"
    fi
    echo "=================================================================="
    echo
}

# Entrypoint argument guard
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <URI>" >&2
    echo "Examples:" >&2
    echo "  $0 https://storage.example.com:8443/backups/db.sql.gz" >&2
    echo "  $0 s3://prod-company-backups/aurora/db.tar.gz" >&2
    exit 1
fi

parse_uri "$1"
```

```bash
./linux-mastery/scripts/04_path_url_parser.sh "https://storage.example.com:8443/backups/database.sql.gz"
```

```text
==================================================================
                     CLOUD URI PARSER REPORT                      
==================================================================
  Original URI  : https://storage.example.com:8443/backups/database.sql.gz
  Protocol      : https
  Domain/Bucket : storage.example.com
  Port          : 8443
  Path          : /backups/database.sql.gz
  Filename      : database.sql.gz
  Extension     : gz
==================================================================
```

```bash
./linux-mastery/scripts/04_path_url_parser.sh "s3://my-company-backups/production/database.sql.gz"
```

```text
==================================================================
                     CLOUD URI PARSER REPORT                      
==================================================================
  Original URI  : s3://my-company-backups/production/database.sql.gz
  Protocol      : s3
  Domain/Bucket : my-company-backups
  Port          : <None>
  Path          : /production/database.sql.gz
  Filename      : database.sql.gz
  Extension     : gz
  S3 Object Key : production/database.sql.gz
==================================================================
```

```bash
./linux-mastery/scripts/04_path_url_parser.sh "https://example.com/reports/annual.pdf?download=true#section1"
```

```text
==================================================================
                     CLOUD URI PARSER REPORT                      
==================================================================
  Original URI  : https://example.com/reports/annual.pdf?download=true#section1
  Protocol      : https
  Domain/Bucket : example.com
  Port          : <None>
  Path          : /reports/annual.pdf
  Filename      : annual.pdf
  Extension     : pdf
==================================================================
```

```bash
# METHOD A: External Binary (basename)
for i in {1..10000}; do
    name=$(basename "/var/log/nginx/access.log")
done
# Execution Time: ~14.8 seconds (10,000 forks/execs)

# METHOD B: Pure Bash Parameter Expansion
for i in {1..10000}; do
    name="${path##*/}"
done
# Execution Time: ~0.08 seconds (Pure in-kernel memory lookups)
```

```bash
file="backup.tar.gz"
echo "${file: -4}"
# Output: r.gz
```

```bash
path="/var/log/nginx/app.log"
echo "${path##*/}"
# Output: app.log
```

```bash
file="archive.tar.gz"
echo "${file%.*}"
# Output: archive.tar
```

```bash
environment="prod-api-prod-db-prod-cache"
echo "${environment//prod/dev}"
# Output: dev-api-dev-db-dev-cache
```

```bash
path="/home/kevin/projects/cloud"
echo "${path#*/}"
# Output: home/kevin/projects/cloud
```

---

## Day 261 / 1000 — Day 5 / 30: Indexed Arrays in Bash
- **Date:** November 17, 2026 (Calendar: November 17, 2026 (Tuesday))

```text
                     Bash Indexed Array Memory Model
                     
  Array Name: servers
  ┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
  │ Index: 0        │ Index: 1        │ Index: 2        │ Index: 3        │
  │ "web-server-01" │ "app-server-01" │ "db-server-01"  │ "cache-redis"   │
  └─────────────────┴─────────────────┴─────────────────┴─────────────────┘
   ▲                                                                     ▲
   │ First element: ${servers[0]}               Last element: ${servers[-1]}
```

```bash
#!/usr/bin/env bash

servers=("web-server-01" "app-server-01" "db-server-01")

echo "Index 0: ${servers[0]}"
echo "Index 1: ${servers[1]}"
echo "Index 2: ${servers[2]}"
```

```text
Index 0: web-server-01
Index 1: app-server-01
Index 2: db-server-01
```

```text
                     Array Declaration & Initialization
                     
  [ 1. COMPOUND INITIALIZATION ]
  regions=("ap-south-1" "us-east-1" "eu-west-1")
  
  [ 2. EXPLICIT DECLARATION (-a) ]
  declare -a regions=("ap-south-1" "us-east-1")
  
  [ 3. SUBSCRIPT ASSIGNMENT ]
  regions[0]="ap-south-1"
  regions[1]="us-east-1"
```

```bash
cloud_regions=("ap-south-1" "us-east-1" "eu-central-1")
```

```bash
declare -a clusters=("k8s-prod-mumbai" "k8s-staging-ohio")
```

```bash
declare -a microservices
microservices[0]="auth-service"
microservices[1]="payment-service"
microservices[5]="notification-service" # Leaves indices 2, 3, 4 empty (Sparse array!)
```

```bash
# Correct: Array has 3 distinct elements
cloud_services=("Amazon EC2" "AWS Lambda" "Elastic Kubernetes Service")

# Wrong: Array has 5 elements ("Amazon", "EC2", "AWS", "Lambda", "Elastic...")
cloud_services=(Amazon EC2 AWS Lambda Elastic Kubernetes Service)
```

```bash
regions=("ap-south-1" "us-east-1" "eu-west-1")

echo "Primary: ${regions[0]}"
echo "Secondary: ${regions[1]}"
```

```bash
echo "Last Region        : ${regions[-1]}"
echo "Second-to-Last Reg : ${regions[-2]}"
```

```text
                 Array Count vs. Element Character Length
                 
  ips=("192.168.1.10" "10.0.0.5" "172.16.0.1")
  
  ${#ips[@]} ──► Number of elements in array      ──► 3
  ${#ips[0]} ──► Character count of element at [0] ──► 12 ("192.168.1.10")
```

```bash
ips=("192.168.1.10" "10.0.0.5" "172.16.0.1")

echo "Total Elements in Array : ${#ips[@]}"  # Output: 3
echo "Characters in First IP  : ${#ips[0]}"   # Output: 12
echo "Characters in Second IP : ${#ips[1]}"   # Output: 8
```

```text
                         Array Slicing Mechanics
                         
  Array:  ("web" "app" "db" "cache" "monitor")
  Index:     0     1     2     3       4
             ├─────────────┤
             ${servers[@]:0:3}  ──► ("web" "app" "db")
             
                   ├───────────────┤
                   ${servers[@]:1:3}  ──► ("app" "db" "cache")
```

```bash
"${array[@]:offset:length}"
```

```bash
cidrs=(
    "10.0.0.0/16"
    "10.1.0.0/16"
    "10.2.0.0/16"
    "172.16.0.0/16"
    "192.168.0.0/16"
)

# Extract a batch of 2 elements starting at index 1
selected_batch=("${cidrs[@]:1:2}")
printf 'Batch Item: %s\n' "${selected_batch[@]}"
```

```text
Batch Item: 10.1.0.0/16
Batch Item: 10.2.0.0/16
```

```bash
declare -a cluster_nodes=("node-01" "node-02")

# Append single element
cluster_nodes+=("node-03")

# Append multiple elements simultaneously
cluster_nodes+=("node-04" "node-05")

echo "Node Count: ${#cluster_nodes[@]}" # Output: 5
printf '  %s\n' "${cluster_nodes[@]}"
```

```text
                  Safe vs. Unsafe Array Iteration
                  
  services=("Amazon EC2" "AWS Lambda" "Amazon S3")
  
  [ UNSAFE ]: for s in ${services[@]}
  Evaluates to: for s in Amazon EC2 AWS Lambda Amazon S3
  Iterates 5 times! Splits on spaces!
  
  [ SAFE ]: for s in "${services[@]}"
  Evaluates to: for s in "Amazon EC2" "AWS Lambda" "Amazon S3"
  Iterates exactly 3 times! Preserves element boundaries!
```

```bash
services=("Amazon EC2" "AWS Lambda" "Amazon S3")

# SAFE ITERATION PATTERN
for service in "${services[@]}"; do
    echo "Processing service: ${service}"
done
```

```bash
servers=("web" "app" "database" "cache")

# Remove element at index 1 ("app")
unset 'servers[1]'

printf 'Element: %s\n' "${servers[@]}"
```

```text
Element: web
Element: database
Element: cache
```

```bash
# Clear all elements while keeping the variable declared:
servers=()

# Destroy the array variable completely:
unset servers
```

```bash
cidrs=("10.0.0.0/16" "172.16.0.0/16" "192.168.1.0/24")

# Delete the middle element to make it sparse
unset 'cidrs[1]'

# Iterate over existing indices only (0 and 2)
for idx in "${!cidrs[@]}"; do
    echo "Rule #$((idx + 1)) [Index $idx]: Allow traffic from ${cidrs[$idx]}"
done
```

```text
Rule #1 [Index 0]: Allow traffic from 10.0.0.0/16
Rule #3 [Index 2]: Allow traffic from 192.168.1.0/24
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# Script   : 05_ip_whitelist_manager.sh
# Track    : Mastering Shell Scripting & Automation — Day 5/30
# Journey  : Day 261/1000
# Purpose  : IPv4 CIDR Whitelist Manager using Native Bash Indexed Arrays
# ==============================================================================

set -euo pipefail

WHITELIST_FILE="./approved_cidrs.txt"

# Default baseline CIDR array
declare -a cidrs=(
    "10.0.0.0/16"
    "10.1.0.0/16"
    "172.16.0.0/16"
    "192.168.1.0/24"
)

# ------------------------------------------------------------------------------
# 1. LOAD PERSISTED CIDRS VIA MAPFILE
# ------------------------------------------------------------------------------
load_cidrs() {
    if [[ -f "$WHITELIST_FILE" ]]; then
        # mapfile (-t strips trailing newlines)
        mapfile -t cidrs < "$WHITELIST_FILE"
    else
        printf '%s\n' "${cidrs[@]}" > "$WHITELIST_FILE"
    fi
}

# ------------------------------------------------------------------------------
# 2. VALIDATE IPV4 CIDR FORMAT & OCTET BOUNDS
# ------------------------------------------------------------------------------
validate_cidr() {
    local cidr="$1"
    local ip prefix octet
    local -a octets

    # Must contain a slash
    if [[ "$cidr" != */* ]]; then
        return 1
    fi

    ip="${cidr%/*}"
    prefix="${cidr##*/}"

    # Validate prefix (0-32)
    if [[ ! "$prefix" =~ ^[0-9]{1,2}$ ]] || (( 10#$prefix > 32 )); then
        return 1
    fi

    # Validate 4 dot-separated numeric octets
    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 1
    fi

    # Split IP into array using IFS
    IFS='.' read -r -a octets <<< "$ip"

    if (( ${#octets[@]} != 4 )); then
        return 1
    fi

    # Validate each octet is 0-255
    for octet in "${octets[@]}"; do
        if [[ ! "$octet" =~ ^[0-9]{1,3}$ ]] || (( 10#$octet > 255 )); then
            return 1
        fi
    done

    return 0
}

# ------------------------------------------------------------------------------
# 3. SAVE CIDRS TO PERSISTENT STORAGE
# ------------------------------------------------------------------------------
save_cidrs() {
    printf '%s\n' "${cidrs[@]}" > "$WHITELIST_FILE"
}

# ------------------------------------------------------------------------------
# 4. ADD NEW CIDR (DUPLICATE PREVENTION & VALIDATION)
# ------------------------------------------------------------------------------
add_cidr() {
    local new_cidr="$1"

    if ! validate_cidr "$new_cidr"; then
        echo "[ERROR] Invalid IPv4 CIDR format: '$new_cidr'" >&2
        return 1
    fi

    # Check for duplicates using safe array iteration
    for existing in "${cidrs[@]}"; do
        if [[ "$existing" == "$new_cidr" ]]; then
            echo "[INFO] CIDR '$new_cidr' is already present in whitelist."
            return 0
        fi
    done

    # Dynamic Array Append
    cidrs+=("$new_cidr")
    save_cidrs
    echo "[SUCCESS] Added CIDR '$new_cidr' to whitelist (Total: ${#cidrs[@]})."
}

# ------------------------------------------------------------------------------
# 5. CHECK EXACT CIDR STATUS
# ------------------------------------------------------------------------------
check_cidr() {
    local search="$1"

    for item in "${cidrs[@]}"; do
        if [[ "$item" == "$search" ]]; then
            echo "[APPROVED] '$search' is authorized in whitelist."
            return 0
        fi
    done

    echo "[DENIED] '$search' is NOT in whitelist."
    return 1
}

# ------------------------------------------------------------------------------
# 6. LIST ALL APPROVED CIDRS WITH INDICES
# ------------------------------------------------------------------------------
list_cidrs() {
    echo "=================================================================="
    echo "                    APPROVED CIDR WHITELIST                       "
    echo "=================================================================="
    for i in "${!cidrs[@]}"; do
        printf "  [%02d] %s\n" "$i" "${cidrs[$i]}"
    done
    echo "------------------------------------------------------------------"
    echo "  Total Active Records: ${#cidrs[@]}"
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 7. SLICE ARRAY FOR BATCH PROCESSING
# ------------------------------------------------------------------------------
slice_cidrs() {
    local offset="$1"
    local length="$2"
    local -a selected

    if [[ ! "$offset" =~ ^[0-9]+$ ]] || [[ ! "$length" =~ ^[0-9]+$ ]]; then
        echo "[ERROR] Offset and length must be non-negative integers." >&2
        return 1
    fi

    # Array Slicing
    selected=("${cidrs[@]:offset:length}")

    echo "=================================================================="
    echo "                   SELECTED CIDR ARRAY SLICE                      "
    echo "=================================================================="
    printf "  -> %s\n" "${selected[@]}"
    echo "------------------------------------------------------------------"
    echo "  Slice Window: Offset $offset | Length $length | Extracted: ${#selected[@]}"
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 8. GENERATE FIREWALL RULES
# ------------------------------------------------------------------------------
generate_rules() {
    echo "=================================================================="
    echo "              SUGGESTED FIREWALL (UFW) INGRESS RULES              "
    echo "=================================================================="
    for cidr in "${cidrs[@]}"; do
        echo "  ufw allow from ${cidr} to any port 443 proto tcp comment 'Whitelisted Ingress'"
    done
    echo "------------------------------------------------------------------"
    echo "  [INFO] Generated ${#cidrs[@]} firewall rules for review."
    echo "  [INFO] No changes were applied to active kernel packet filters."
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 9. CLI ENTRYPOINT & ROUTING
# ------------------------------------------------------------------------------
load_cidrs

case "${1:-help}" in
    add)
        [[ $# -ne 2 ]] && { echo "Usage: $0 add <IPv4-CIDR>" >&2; exit 1; }
        add_cidr "$2"
        ;;
    check)
        [[ $# -ne 2 ]] && { echo "Usage: $0 check <IPv4-CIDR>" >&2; exit 1; }
        check_cidr "$2"
        ;;
    list)
        list_cidrs
        ;;
    slice)
        [[ $# -ne 3 ]] && { echo "Usage: $0 slice <offset> <length>" >&2; exit 1; }
        slice_cidrs "$2" "$3"
        ;;
    generate)
        generate_rules
        ;;
    help|--help|-h)
        echo "IP WHITELIST MANAGER CLI"
        echo "Usage: $0 <command> [arguments]"
        echo
        echo "Available Commands:"
        echo "  add <CIDR>          Add an IPv4 CIDR block with duplicate detection"
        echo "  check <CIDR>        Verify if a CIDR block exists in whitelist"
        echo "  list                Display all approved CIDR blocks with indices"
        echo "  slice <N> <L>       Extract an array slice (Offset N, Length L)"
        echo "  generate            Generate suggested UFW ingress firewall rules"
        echo "  help                Display this documentation runbook"
        ;;
    *)
        echo "[ERROR] Unknown command: '$1'. Run '$0 help' for usage." >&2
        exit 1
        ;;
esac
```

```bash
chmod +x linux-mastery/scripts/05_ip_whitelist_manager.sh
```

```bash
./linux-mastery/scripts/05_ip_whitelist_manager.sh list
```

```text
==================================================================
                    APPROVED CIDR WHITELIST                       
==================================================================
  [00] 10.0.0.0/16
  [01] 10.1.0.0/16
  [02] 172.16.0.0/16
  [03] 192.168.1.0/24
------------------------------------------------------------------
  Total Active Records: 4
==================================================================
```

```bash
# Add a valid new subnet
./linux-mastery/scripts/05_ip_whitelist_manager.sh add 10.2.0.0/16
# Output: [SUCCESS] Added CIDR '10.2.0.0/16' to whitelist (Total: 5).

# Attempt duplicate addition
./linux-mastery/scripts/05_ip_whitelist_manager.sh add 10.2.0.0/16
# Output: [INFO] CIDR '10.2.0.0/16' is already present in whitelist.
```

```bash
./linux-mastery/scripts/05_ip_whitelist_manager.sh add 999.1.1.1/24
# Output: [ERROR] Invalid IPv4 CIDR format: '999.1.1.1/24'
```

```bash
./linux-mastery/scripts/05_ip_whitelist_manager.sh slice 1 2
```

```text
==================================================================
                   SELECTED CIDR ARRAY SLICE                      
==================================================================
  -> 10.1.0.0/16
  -> 172.16.0.0/16
------------------------------------------------------------------
  Slice Window: Offset 1 | Length 2 | Extracted: 2
==================================================================
```

```bash
./linux-mastery/scripts/05_ip_whitelist_manager.sh generate
```

```text
==================================================================
              SUGGESTED FIREWALL (UFW) INGRESS RULES              
==================================================================
  ufw allow from 10.0.0.0/16 to any port 443 proto tcp comment 'Whitelisted Ingress'
  ufw allow from 10.1.0.0/16 to any port 443 proto tcp comment 'Whitelisted Ingress'
  ufw allow from 172.16.0.0/16 to any port 443 proto tcp comment 'Whitelisted Ingress'
  ufw allow from 192.168.1.0/24 to any port 443 proto tcp comment 'Whitelisted Ingress'
  ufw allow from 10.2.0.0/16 to any port 443 proto tcp comment 'Whitelisted Ingress'
------------------------------------------------------------------
  [INFO] Generated 5 firewall rules for review.
  [INFO] No changes were applied to active kernel packet filters.
==================================================================
```

```bash
# Practical Example: Multi-Region Latency Prober
declare -a aws_regions=("ap-south-1" "us-east-1" "eu-west-1" "ap-southeast-1")

for region in "${aws_regions[@]}"; do
    echo "[PROBING] Testing network latency to AWS region: ${region}..."
done
```

```bash
#!/usr/bin/env bash
# 1. Create array of 5 regions
regions=("ap-south-1" "us-east-1" "eu-central-1" "sa-east-1" "ap-northeast-1")

# 2. Print first and last
echo "First: ${regions[0]} | Last: ${regions[-1]}"

# 3. Find total count
echo "Total Regions: ${#regions[@]}"

# 4. Append new region
regions+=("ap-southeast-1")

# 5. Print second and third using slicing
echo "Slice 1:2 -> ${regions[@]:1:2}"

# 6. Safe iteration
for r in "${regions[@]}"; do
    echo "Region: $r"
done
```

---

## Day 262 / 1000 — Day 6 / 30: Associative Arrays (Hashmaps / Dictionaries)
- **Date:** November 18, 2026 (Calendar: November 18, 2026 (Wednesday))

```text
                  Indexed Array vs. Associative Array
                  
  [ INDEXED ARRAY: Numerical Subscripts ]
  declare -a servers=("web-01" "db-01" "app-01")
  
  Index:       0         1         2
  Value:   "web-01"   "db-01"   "app-01"
  Access:  ${servers[0]}
  
  [ ASSOCIATIVE ARRAY: Named Key-Value Pairs (Hashmap) ]
  declare -A server_roles
  
  Key:     "web-01"    "db-01"     "app-01"
  Value:  "Frontend"  "Database"  "Backend"
  Access:  ${server_roles["web-01"]}
```

```bash
# MANDATORY EXPLICIT DECLARATION
declare -A server_roles
```

```bash
declare -A server_roles=(
    ["web-01"]="Frontend"
    ["db-01"]="Database"
    ["app-01"]="Backend"
    ["cache-01"]="Redis Cache"
)
```

```bash
declare -A server_ips

server_ips["web-01"]="10.0.1.10"
server_ips["db-01"]="10.0.2.10"
server_ips["app-01"]="10.0.3.10"
```

```bash
echo "Web Server IP  : ${server_ips["web-01"]}"
echo "Database IP    : ${server_ips["db-01"]}"
```

```bash
declare -A ec2_instances

# Insert
ec2_instances["i-01"]="t3.micro"
# Update
ec2_instances["i-01"]="t3.large"
```

```bash
unset 'ec2_instances[i-01]'
```

```bash
declare -p ec2_instances
# Output: declare -A ec2_instances=(["i-01"]="t3.large" )
```

```text
                  Safe vs. Unsafe Key Existence Checks
                  
  declare -A config=( ["DEBUG"]="" )
  
  [ FLAWED CHECK ]: if [[ -n "${config["DEBUG"]}" ]]
  Evaluates to FALSE because the value is empty, even though the key exists!
  
  [ MODERN BASH 4.2+ ]: if [[ -v 'config[$key]' ]]
  Evaluates to TRUE because the key exists in the hash table!
  
  [ PORTABLE PARAMETER ]: if [[ ${config[$key]+_} ]]
  Evaluates to TRUE using parameter expansion test!
```

```bash
key="web-01"

if [[ -v 'server_ips[$key]' ]]; then
    echo "Found server: ${server_ips[$key]}"
else
    echo "Error: Server '$key' is not registered in inventory." >&2
fi
```

```bash
if [[ ${server_ips[$key]+_} ]]; then
    echo "Server exists in registry."
fi
```

```text
                 Associative Array Iteration Syntax
                 
  declare -A role_map=( ["web"]="Frontend" ["db"]="Database" )
  
  ${!role_map[@]}  ──► Expands to KEYS:   "web" "db" (Unordered)
  ${role_map[@]}   ──► Expands to VALUES: "Frontend" "Database"
  ${#role_map[@]}  ──► Total count:       2
```

```bash
declare -A server_roles=(
    ["web-01"]="Frontend"
    ["db-01"]="Database"
    ["app-01"]="Backend"
)

for host in "${!server_roles[@]}"; do
    echo "Host: ${host} | Role: ${server_roles[$host]}"
done
```

```bash
while IFS= read -r host; do
    printf 'Server: %-10s -> Role: %s\n' "$host" "${server_roles[$host]}"
done < <(printf '%s\n' "${!server_roles[@]}" | sort)
```

```text
                  Simulating Multi-Attribute Cloud Records
                  
  Primary Key (Hostname): "web-01"
            │
            ├────► server_ips["web-01"]     = "10.0.1.10"
            ├────► server_regions["web-01"] = "ap-south-1"
            ├────► server_types["web-01"]   = "t3.micro"
            └────► server_roles["web-01"]   = "Frontend"
```

```bash
declare -A server_ips server_regions server_types server_roles

# Record 1: web-01
server_ips["web-01"]="10.0.1.10"
server_regions["web-01"]="ap-south-1"
server_types["web-01"]="t3.micro"
server_roles["web-01"]="Frontend"

# Accessing composite record
host="web-01"
echo "Host: $host | IP: ${server_ips[$host]} | Region: ${server_regions[$host]} | Type: ${server_types[$host]}"
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# Script   : 06_inventory_mapper.sh
# Track    : Mastering Shell Scripting & Automation — Day 6/30
# Journey  : Day 262/1000
# Purpose  : Cloud Server Inventory Management CLI using Bash Associative Arrays
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# 1. DECLARE PARALLEL ASSOCIATIVE ARRAYS
# ------------------------------------------------------------------------------
declare -A server_ips
declare -A server_regions
declare -A server_types
declare -A server_roles

# ------------------------------------------------------------------------------
# 2. POPULATE INITIAL CLOUD INVENTORY
# ------------------------------------------------------------------------------
# Host 1: Web Frontend
server_ips["web-01"]="10.0.1.10"
server_regions["web-01"]="ap-south-1"
server_types["web-01"]="t3.micro"
server_roles["web-01"]="Frontend"

# Host 2: Database Cluster
server_ips["db-01"]="10.0.2.10"
server_regions["db-01"]="ap-south-1"
server_types["db-01"]="t3.medium"
server_roles["db-01"]="Database"

# Host 3: Application Backend
server_ips["app-01"]="10.0.3.10"
server_regions["app-01"]="ap-south-1"
server_types["app-01"]="t3.small"
server_roles["app-01"]="Backend"

# Host 4: Distributed Cache
server_ips["cache-01"]="10.0.4.10"
server_regions["cache-01"]="ap-southeast-1"
server_types["cache-01"]="t3.micro"
server_roles["cache-01"]="Cache"

# ------------------------------------------------------------------------------
# 3. SINGLE SERVER LOOKUP MODULE
# ------------------------------------------------------------------------------
lookup_server() {
    local host="$1"

    # Defensive existence check using [[ -v ]]
    if [[ ! -v 'server_ips[$host]' ]]; then
        echo "Error: Server '$host' not found in inventory registry." >&2
        return 1
    fi

    echo "=================================================================="
    echo "                      SERVER DETAIL REPORT                        "
    echo "=================================================================="
    echo "  Hostname      : ${host}"
    echo "  Private IP    : ${server_ips[$host]}"
    echo "  AWS Region    : ${server_regions[$host]}"
    echo "  Instance Type : ${server_types[$host]}"
    echo "  Cluster Role  : ${server_roles[$host]}"
    echo "=================================================================="
    echo
}

# ------------------------------------------------------------------------------
# 4. LIST ALL SERVERS (DETERMINISTIC SORTED OUTPUT)
# ------------------------------------------------------------------------------
list_servers() {
    echo "=================================================================="
    echo "                 ACTIVE CLOUD SERVER INVENTORY                    "
    echo "=================================================================="
    printf "%-12s | %-15s | %-15s | %-10s | %-12s\n" \
        "HOSTNAME" "PRIVATE IP" "AWS REGION" "TYPE" "ROLE"
    echo "-------------+-----------------+-----------------+------------+-------------"

    # Sort keys deterministically via process substitution
    while IFS= read -r host; do
        printf "%-12s | %-15s | %-15s | %-10s | %-12s\n" \
            "$host" \
            "${server_ips[$host]}" \
            "${server_regions[$host]}" \
            "${server_types[$host]}" \
            "${server_roles[$host]}"
    done < <(printf '%s\n' "${!server_ips[@]}" | sort)

    echo "------------------------------------------------------------------"
    echo "  Total Registered Compute Nodes: ${#server_ips[@]}"
    echo "=================================================================="
    echo
}

# ------------------------------------------------------------------------------
# 5. PURE BASH JSON ESCAPING HELPER (RFC 8259)
# ------------------------------------------------------------------------------
json_escape() {
    local val="$1"
    # Escape backslashes first, then quotes, then control characters
    val="${val//\\/\\\\}"
    val="${val//\"/\\\"}"
    val="${val//$'\n'/\\n}"
    val="${val//$'\r'/\\r}"
    val="${val//$'\t'/\\t}"
    printf '%s' "$val"
}

# ------------------------------------------------------------------------------
# 6. JSON EXPORT ENGINE
# ------------------------------------------------------------------------------
export_json() {
    local host
    local first=true

    echo "{"
    echo '  "cloud_inventory": ['

    while IFS= read -r host; do
        if [[ "$first" == false ]]; then
            echo ","
        fi
        first=false

        printf '    {\n'
        printf '      "hostname": "%s",\n'      "$(json_escape "$host")"
        printf '      "private_ip": "%s",\n'    "$(json_escape "${server_ips[$host]}")"
        printf '      "aws_region": "%s",\n'    "$(json_escape "${server_regions[$host]}")"
        printf '      "instance_type": "%s",\n' "$(json_escape "${server_types[$host]}")"
        printf '      "role": "%s"\n'           "$(json_escape "${server_roles[$host]}")"
        printf '    }'
    done < <(printf '%s\n' "${!server_ips[@]}" | sort)

    echo
    echo "  ],"
    echo "  \"total_count\": ${#server_ips[@]}"
    echo "}"
}

# ------------------------------------------------------------------------------
# 7. CLI ROUTER & ENTRYPOINT
# ------------------------------------------------------------------------------
case "${1:-help}" in
    lookup)
        [[ $# -ne 2 ]] && { echo "Usage: $0 lookup <HOSTNAME>" >&2; exit 1; }
        lookup_server "$2"
        ;;
    list)
        list_servers
        ;;
    export)
        export_json
        ;;
    count)
        echo "Total Registered Compute Nodes: ${#server_ips[@]}"
        ;;
    help|--help|-h)
        echo "CLOUD SERVER INVENTORY MAPPER CLI"
        echo "Usage: $0 <command> [arguments]"
        echo
        echo "Available Commands:"
        echo "  lookup <HOST>       Display detailed metadata for a single host"
        echo "  list                Display tabular inventory sorted by hostname"
        echo "  export              Serialize entire inventory to valid JSON"
        echo "  count               Print total count of registered servers"
        echo "  help                Display this documentation"
        ;;
    *)
        echo "Error: Unknown command '$1'. Run '$0 help' for usage." >&2
        exit 1
        ;;
esac
```

```bash
chmod +x linux-mastery/scripts/06_inventory_mapper.sh
```

```bash
./linux-mastery/scripts/06_inventory_mapper.sh lookup web-01
```

```text
==================================================================
                      SERVER DETAIL REPORT                        
==================================================================
  Hostname      : web-01
  Private IP    : 10.0.1.10
  AWS Region    : ap-south-1
  Instance Type : t3.micro
  Cluster Role  : Frontend
==================================================================
```

```bash
./linux-mastery/scripts/06_inventory_mapper.sh list
```

```text
==================================================================
                 ACTIVE CLOUD SERVER INVENTORY                    
==================================================================
HOSTNAME     | PRIVATE IP      | AWS REGION      | TYPE       | ROLE        
-------------+-----------------+-----------------+------------+-------------
app-01       | 10.0.3.10       | ap-south-1      | t3.small   | Backend     
cache-01     | 10.0.4.10       | ap-southeast-1  | t3.micro   | Cache       
db-01        | 10.0.2.10       | ap-south-1      | t3.medium  | Database    
web-01       | 10.0.1.10       | ap-south-1      | t3.micro   | Frontend    
------------------------------------------------------------------
  Total Registered Compute Nodes: 4
==================================================================
```

```bash
./linux-mastery/scripts/06_inventory_mapper.sh export | python3 -m json.tool
```

```json
{
    "cloud_inventory": [
        {
            "hostname": "app-01",
            "private_ip": "10.0.3.10",
            "aws_region": "ap-south-1",
            "instance_type": "t3.small",
            "role": "Backend"
        },
        {
            "hostname": "cache-01",
            "private_ip": "10.0.4.10",
            "aws_region": "ap-southeast-1",
            "instance_type": "t3.micro",
            "role": "Cache"
        },
        {
            "hostname": "db-01",
            "private_ip": "10.0.2.10",
            "aws_region": "ap-south-1",
            "instance_type": "t3.medium",
            "role": "Database"
        },
        {
            "hostname": "web-01",
            "private_ip": "10.0.1.10",
            "aws_region": "ap-south-1",
            "instance_type": "t3.micro",
            "role": "Frontend"
        }
    ],
    "total_count": 4
}
```

```bash
done < <(printf '%s\n' "${!server_ips[@]}" | sort)
```

```bash
find_by_region() {
    local target_region="$1"
    echo "Servers in region '$target_region':"
    for host in "${!server_regions[@]}"; do
        if [[ "${server_regions[$host]}" == "$target_region" ]]; then
            echo "  - $host (${server_ips[$host]}) [${server_roles[$host]}]"
        fi
    done
}
```

---

## Day 263 / 1000 — Day 7 / 30: Week 9 Consolidation & Review Project
- **Date:** November 19, 2026 (Calendar: November 19, 2026 (Thursday))

```text
                        Week 9 Bash Architecture Matrix
                        
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 1. PARAMETER EXPANSION: Pure In-Memory String Operations                │
  │    - Defaults: ${v:-def}, ${v:=def}, ${v:+alt}, ${v:?err}              │
  │    - Slicing:  ${v:offset:len}, ${v: -offset} (space required!)        │
  │    - Stripping: Prefix (${v#*}, ${v##*}) | Suffix (${v%*}, ${v%%*})    │
  │    - Mutation:  Case (${v^^}, ${v,,}) | Replacement (${v//pat/repl})   │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 2. QUOTING HIERARCHY: Preventing Unintended Expansion                  │
  │    - Single ('...'): 100% literal preservation                         │
  │    - Double ("..."): Expands $VAR, $(cmd); prevents word-split & glob   │
  │    - ANSI-C ($'...'): Interprets escapes (\n, \t, \xHH)                │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 3. COLLECTIONS & DATA STRUCTURES: Structured In-Memory Storage          │
  │    - Indexed Arrays (declare -a): Numeric subscripts, slicing, mapfile │
  │    - Associative Arrays (declare -A): String keys, [[ -v ]] lookup     │
  └────────────────────────────────────────────────────────────────────────┘
```

```bash
# 1. Default fallback without mutating variable
TARGET_DIR="${OUTPUT_DIR:-/var/log/reports}"

# 2. Mandatory assertion (terminates script if unset or empty)
: "${DATABASE_URL:?Fatal: DATABASE_URL must be provided.}"

# 3. String character length
echo "Hostname length: ${#HOSTNAME}"

# 4. In-memory case normalization
FORMAT="${1:-markdown}"
FORMAT="${FORMAT,,}" # lowercase

# 5. Greedy prefix strip (Native basename)
FILENAME="${FULLPATH##*/}"

# 6. Suffix strip (Native dirname)
DIRECTORY="${FULLPATH%/*}"

# 7. Global search and replace
SAFE_IP="${IP_ADDR//./-}"
```

```text
                 The Catastrophic Word-Splitting Trap
                 
  FILE_LIST="system report 2026.log backup archive.tar.gz"
  
  [ UNQUOTED ]: for f in $FILE_LIST
  Bash splits on spaces ($IFS):
  Iterates 5 times: "system", "report", "2026.log", "backup", "archive.tar.gz"
  
  [ PROPER ARRAY ]: FILE_ARRAY=("system report 2026.log" "backup archive.tar.gz")
  Iterate quoted: for f in "${FILE_ARRAY[@]}"
  Iterates exactly 2 times, preserving embedded whitespace!
```

```bash
# Indexed Array: Ordered by integer index (0, 1, 2...)
declare -a services=("nginx" "docker" "postgresql")
services+=("redis") # Append
echo "First: ${services[0]} | Last: ${services[-1]} | Count: ${#services[@]}"

# Associative Array: Key-value hashmap (Bash 4.0+)
declare -A system_map
system_map[hostname]="prod-node-01"
system_map[region]="ap-south-1"
system_map[role]="inference-worker"

# Key existence check
if [[ -v system_map[hostname] ]]; then
    echo "Host configured: ${system_map[hostname]}"
fi

# Iterate over keys
for key in "${!system_map[@]}"; do
    echo "$key -> ${system_map[$key]}"
done
```

```text
                         ShellCheck in CI/CD Pipelines
                         
  Developer Git Push ──► GitHub Actions / GitLab CI
                                 │
                                 ▼
                     Run: shellcheck *.sh
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
          Warnings Found (SC2086)          Clean (Exit Code 0)
          Pipeline Fails! ❌                Deploy Infrastructure! ✅
```

```bash
sudo apt update && sudo apt install -y shellcheck
shellcheck --version
```

```text
                  07_sysinfo_generator.sh Data Pipeline
                  
  ┌────────────────────────────────────────────────────────────────────────┐
  │ Linux Kernel Pseudo-Filesystems & Host Telemetry                       │
  │ /proc/cpuinfo    /proc/meminfo    /proc/uptime    /sys/class/net    ip │
  └───────────────────────────────────┬────────────────────────────────────┘
                                      │
                                      ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ In-Memory Data Collection (Modular Functions)                          │
  │ - collect_cpu_info()       - collect_memory_info()                     │
  │ - collect_uptime_info()    - collect_network_info()                    │
  │ - collect_os_info()        - collect_general_info()                    │
  └───────────────────────────────────┬────────────────────────────────────┘
                                      │ Stored in Associative Array:
                                      ▼ declare -A SYSTEM_INFO
  ┌────────────────────────────────────────────────────────────────────────┐
  │ Output Formatting Engine                                               │
  │                                                                        │
  │  [ --format markdown ]                       [ --format keyvalue ]     │
  │  Structured Markdown Table                   UNIX Key-Value Pairs      │
  │  (For Documentation & Dashboards)            (For Parsers & Telemetry) │
  └────────────────────────────────────────────────────────────────────────┘
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# Script   : 07_sysinfo_generator.sh
# Track    : Mastering Shell Scripting & Automation — Day 7/30 (Week 9 Capstone)
# Journey  : Day 263/1000
# Purpose  : Linux System Telemetry & Hardware Report Generator
# ==============================================================================

# Defensive strict mode
set -o nounset
set -o pipefail

# ------------------------------------------------------------------------------
# 1. CONFIGURATION & STATE
# ------------------------------------------------------------------------------
SCRIPT_NAME="${0##*/}"
OUTPUT_FORMAT="markdown"

# Global associative array for collected metrics
declare -A SYSTEM_INFO

# ------------------------------------------------------------------------------
# 2. HELPER FUNCTIONS
# ------------------------------------------------------------------------------
show_help() {
    cat <<EOF
Usage: ${SCRIPT_NAME} [OPTIONS]

Linux System Information & Telemetry Report Generator

Options:
  --format FORMAT    Output format: 'markdown' (default) or 'keyvalue'
  --help, -h         Display this help message and exit

Examples:
  ./${SCRIPT_NAME}
  ./${SCRIPT_NAME} --format markdown
  ./${SCRIPT_NAME} --format keyvalue > system_metrics.env
EOF
}

log_error() {
    printf '[ERROR] %s\n' "$1" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------------------------
# 3. CLI ARGUMENT PARSER
# ------------------------------------------------------------------------------
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --format)
                if [[ $# -lt 2 ]]; then
                    log_error "Missing value for --format parameter."
                    return 1
                fi
                OUTPUT_FORMAT="${2,,}" # Normalize to lowercase
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unrecognized argument: '$1'"
                show_help >&2
                return 1
                ;;
        esac
    done

    case "$OUTPUT_FORMAT" in
        markdown|keyvalue)
            # Valid format
            ;;
        *)
            log_error "Invalid format '${OUTPUT_FORMAT}'. Must be 'markdown' or 'keyvalue'."
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------------------
# 4. TELEMETRY COLLECTORS
# ------------------------------------------------------------------------------

# CPU Information Collector
collect_cpu_info() {
    local cpu_model="Unknown"
    local cpu_cores="Unknown"

    if [[ -r /proc/cpuinfo ]]; then
        cpu_model=$(awk -F ': ' '/^model name/ { print $2; exit }' /proc/cpuinfo)
    fi

    if command_exists nproc; then
        cpu_cores="$(nproc)"
    fi

    SYSTEM_INFO[cpu_model]="${cpu_model:-Unknown}"
    SYSTEM_INFO[cpu_cores]="${cpu_cores:-Unknown}"
}

# Memory Information Collector
collect_memory_info() {
    local memory_total="Unknown"
    local memory_available="Unknown"

    if [[ -r /proc/meminfo ]]; then
        memory_total=$(awk '/^MemTotal:/ { printf "%.0f MB", $2 / 1024 }' /proc/meminfo)
        memory_available=$(awk '/^MemAvailable:/ { printf "%.0f MB", $2 / 1024 }' /proc/meminfo)
    fi

    SYSTEM_INFO[memory_total]="${memory_total:-Unknown}"
    SYSTEM_INFO[memory_available]="${memory_available:-Unknown}"
}

# Uptime Information Collector
collect_uptime_info() {
    local uptime_seconds="Unknown"
    local uptime_days="Unknown"

    if [[ -r /proc/uptime ]]; then
        read -r uptime_seconds _ < /proc/uptime
    fi

    if [[ "$uptime_seconds" != "Unknown" ]]; then
        uptime_days=$(awk -v s="$uptime_seconds" 'BEGIN { printf "%.2f days", s / 86400 }')
    fi

    SYSTEM_INFO[uptime]="${uptime_days:-Unknown}"
}

# Network Interfaces & IP Addresses Collector
collect_network_info() {
    local interfaces="Unavailable"
    local ip_addresses="Unavailable"

    if [[ -d /sys/class/net ]]; then
        # Use nullglob expansion to gather interfaces
        local ifaces=()
        for iface_path in /sys/class/net/*; do
            [[ -e "$iface_path" ]] || continue
            ifaces+=("${iface_path##*/}")
        done
        interfaces="${ifaces[*]:-None}"
    fi

    if command_exists ip; then
        ip_addresses=$(ip -o addr show | awk '{ printf "%s: %s/%s; ", $2, $4, $3 }')
        ip_addresses="${ip_addresses%; }" # Strip trailing semicolon
        [[ -n "$ip_addresses" ]] || ip_addresses="None"
    fi

    SYSTEM_INFO[interfaces]="${interfaces:-None}"
    SYSTEM_INFO[ip_addresses]="${ip_addresses:-None}"
}

# Operating System Collector
collect_os_info() {
    local os_name="Unknown"

    if [[ -r /etc/os-release ]]; then
        os_name=$(
            # Source in a subshell to avoid polluting global namespace
            . /etc/os-release
            printf '%s' "${PRETTY_NAME:-Linux}"
        )
    fi

    SYSTEM_INFO[os]="${os_name:-Unknown}"
}

# General Host Information Collector
collect_general_info() {
    SYSTEM_INFO[hostname]="$(hostname 2>/dev/null || printf 'Unknown')"
    SYSTEM_INFO[kernel]="$(uname -r 2>/dev/null || printf 'Unknown')"
    SYSTEM_INFO[architecture]="$(uname -m 2>/dev/null || printf 'Unknown')"
    SYSTEM_INFO[collection_time]="$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || printf 'Unknown')"
}

# Master Collector Wrapper
collect_all_information() {
    collect_general_info
    collect_os_info
    collect_cpu_info
    collect_memory_info
    collect_uptime_info
    collect_network_info
}

# ------------------------------------------------------------------------------
# 5. FORMATTING & REPORT GENERATION ENGINES
# ------------------------------------------------------------------------------

# Markdown Table Output
generate_markdown() {
    printf '# Linux System Information Report\n\n'
    printf '**Hostname:** %s  \n' "${SYSTEM_INFO[hostname]}"
    printf '**Timestamp:** %s\n\n' "${SYSTEM_INFO[collection_time]}"

    printf '| System Metric | Reported Value |\n'
    printf '|---|---|\n'

    # Ordered list of keys for deterministic output
    local -a ordered_keys=(
        os
        kernel
        architecture
        cpu_model
        cpu_cores
        memory_total
        memory_available
        uptime
        interfaces
        ip_addresses
    )

    local key
    for key in "${ordered_keys[@]}"; do
        local label="${key//_/ }"
        label="${label^}" # Capitalize first character
        printf '| %s | %s |\n' "$label" "${SYSTEM_INFO[$key]}"
    done

    printf '\n---\n'
    printf '*Report generated via %s (Mastering Shell Scripting)*\n' "$SCRIPT_NAME"
}

# Key-Value Output
generate_keyvalue() {
    local -a ordered_keys=(
        hostname
        collection_time
        os
        kernel
        architecture
        cpu_model
        cpu_cores
        memory_total
        memory_available
        uptime
        interfaces
        ip_addresses
    )

    local key
    for key in "${ordered_keys[@]}"; do
        printf '%s=%s\n' "$key" "${SYSTEM_INFO[$key]}"
    done
}

# ------------------------------------------------------------------------------
# 6. MAIN CONTROLLER
# ------------------------------------------------------------------------------
main() {
    parse_arguments "$@" || return 1
    collect_all_information

    case "$OUTPUT_FORMAT" in
        markdown)
            generate_markdown
            ;;
        keyvalue)
            generate_keyvalue
            ;;
    esac
}

main "$@"
```

```bash
chmod +x linux-mastery/scripts/07_sysinfo_generator.sh
```

```bash
./linux-mastery/scripts/07_sysinfo_generator.sh
```

```text
# Linux System Information Report

**Hostname:** ip-10-0-1-25  
**Timestamp:** 2026-11-19 18:45:10

| System Metric | Reported Value |
|---|---|
| Os | Ubuntu 24.04.1 LTS |
| Kernel | 6.8.0-1017-aws |
| Architecture | x86_64 |
| Cpu model | AMD EPYC 7R13 Processor |
| Cpu cores | 4 |
| Memory total | 16024 MB |
| Memory available | 14210 MB |
| Uptime | 42.15 days |
| Interfaces | eth0 lo |
| Ip addresses | lo: 127.0.0.1/8/inet; eth0: 10.0.1.25/24/inet |

---
*Report generated via 07_sysinfo_generator.sh (Mastering Shell Scripting)*
```

```bash
./linux-mastery/scripts/07_sysinfo_generator.sh --format keyvalue
```

```text
hostname=ip-10-0-1-25
collection_time=2026-11-19 18:45:10
os=Ubuntu 24.04.1 LTS
kernel=6.8.0-1017-aws
architecture=x86_64
cpu_model=AMD EPYC 7R13 Processor
cpu_cores=4
memory_total=16024 MB
memory_available=14210 MB
uptime=42.15 days
interfaces=eth0 lo
ip_addresses=lo: 127.0.0.1/8/inet; eth0: 10.0.1.25/24/inet
```

```bash
./linux-mastery/scripts/07_sysinfo_generator.sh --format yaml
echo "Exit code: $?"
```

```text
[ERROR] Invalid format 'yaml'. Must be 'markdown' or 'keyvalue'.
Exit code: 1
```

```bash
# 1. Syntax check without execution
bash -n linux-mastery/scripts/07_sysinfo_generator.sh

# 2. Comprehensive ShellCheck static analysis
shellcheck linux-mastery/scripts/07_sysinfo_generator.sh
```

```text
$ shellcheck linux-mastery/scripts/07_sysinfo_generator.sh
$ echo $?
0
```

```bash
calculate_cpu_usage() {
    # Read two snapshots 1 second apart
    read -r cpu u1 n1 s1 i1 w1 irq1 s_irq1 steal1 _ < /proc/stat
    sleep 1
    read -r cpu u2 n2 s2 i2 w2 irq2 s_irq2 steal2 _ < /proc/stat

    local prev_idle=$((i1 + w1))
    local idle=$((i2 + w2))

    local prev_total=$((u1 + n1 + s1 + i1 + w1 + irq1 + s_irq1 + steal1))
    local total=$((u2 + n2 + s2 + i2 + w2 + irq2 + s_irq2 + steal2))

    local total_diff=$((total - prev_total))
    local idle_diff=$((idle - prev_idle))

    local usage_pct=$(( (1000 * (total_diff - idle_diff)) / total_diff ))
    printf "CPU Usage: %d.%d%%\n" "$((usage_pct / 10))" "$((usage_pct % 10))"
}
```

```bash
calculate_memory_pct() {
    local mem_total mem_available
    mem_total=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)
    mem_available=$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo)

    awk -v tot="$mem_total" -v avail="$mem_available" '
        BEGIN { printf "Memory Utilization: %.1f%%\n", ((tot - avail) / tot) * 100 }
    '
}
```

```bash
check_interface_state() {
    local iface="${1:-eth0}"
    local state_file="/sys/class/net/${iface}/operstate"

    if [[ -r "$state_file" ]]; then
        local state
        read -r state < "$state_file"
        echo "Interface ${iface} is: ${state^^}"
    else
        echo "Interface ${iface} not found." >&2
    fi
}
```

```bash
# Add --output flag support
OUTPUT_FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        # ... other arguments ...
    esac
done

if [[ -n "$OUTPUT_FILE" ]]; then
    exec > "$OUTPUT_FILE" # Redirect standard output cleanly to file
fi
```

---

## Day 264 / 1000 — Day 8 / 30: Modern Bash Conditionals & Test Operators
- **Date:** November 20, 2026 (Calendar: November 20, 2026 (Friday))

```text
                     Bash Conditional Evaluation Taxonomy
                     
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 1. test & [ ... ]  (POSIX Standard / Legacy)                           │
  │    • External binary (/usr/bin/[) & shell builtin                      │
  │    • Subject to word splitting and pathname expansion (globbing)       │
  │    • Uses -a (AND), -o (OR), requiring strict variable quoting         │
  └───────────────────────────────────┬────────────────────────────────────┘
                                      │
                                      ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 2. [[ ... ]]  (Modern Bash Compound Keyword / Recommended)             │
  │    • Built directly into Bash parser (compound command)                │
  │    • Suppresses word splitting & globbing on left-hand expressions     │
  │    • Native short-circuit logic (&&, ||) and parentheses ( )           │
  │    • Pattern matching (== *.log) and PCRE-like Regex (=~)              │
  └───────────────────────────────────┬────────────────────────────────────┘
                                      │
                                      ▼
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 3. (( ... ))  (C-Style Arithmetic Evaluation Context)                  │
  │    • Dedicated numeric and arithmetic comparison engine                │
  │    • Variables do not require '$' prefix                               │
  │    • Standard mathematical operators: >, <, >=, <=, ==, !=, %, &&, ||  │
  │    • Truthiness: Evaluates to exit code 0 if non-zero, 1 if zero       │
  └────────────────────────────────────────────────────────────────────────┘
```

```bash
test 10 -gt 5
echo $?
# Output: 0 (True / Success)
```

```bash
[ 10 -gt 5 ]
echo $?  # 0
```

```bash
[ "$age" -gt 18 ]     # Correct
["$age" -gt 18]       # Syntax Error: command '["$age"' not found
```

```bash
filename="production database backup.tar.gz"

# Safe in [[ ]] even without quotes around $filename:
if [[ $filename == *.tar.gz ]]; then
    echo "Archive detected"
fi
```

```bash
cpu_util=88
threshold=80

if (( cpu_util > threshold )); then
    echo "ALERT: CPU usage (${cpu_util}%) exceeds threshold (${threshold}%)"
fi
```

```bash
ln -s /nonexistent/target.txt /tmp/dangling_link.txt

# What happens with standard tests?
[[ -e /tmp/dangling_link.txt ]]  # FALSE! -e follows the link to the missing target.
[[ -f /tmp/dangling_link.txt ]]  # FALSE! Cannot resolve target.
[[ -L /tmp/dangling_link.txt ]]  # TRUE! The link itself exists!
```

```bash
if [[ -L "$path" && ! -e "$path" ]]; then
    echo "CRITICAL: Broken symbolic link detected: $path"
fi
```

```bash
# Validating write and traversal on a deployment directory
deploy_dir="/var/www/production-app"

if [[ -d "$deploy_dir" && -w "$deploy_dir" && -x "$deploy_dir" ]]; then
    echo "Deployment directory is fully accessible for release deployment"
else
    echo "ERROR: Insufficient permissions on $deploy_dir" >&2
    exit 1
fi
```

```bash
# Reject unset or empty deployment target
if [[ -z "${TARGET_ENV:-}" ]]; then
    echo "FATAL: TARGET_ENV must be specified." >&2
    exit 1
fi
```

```bash
archive="service-mesh-backup-20261120.tar.gz"

if [[ "$archive" == *.tar.gz ]]; then
    echo "Valid gzip compressed tarball"
fi

if [[ "$archive" == service-mesh-* ]]; then
    echo "Belongs to service mesh subsystem"
fi
```

```bash
version="v2.14.0"

if [[ "$version" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "SemVer valid: ${BASH_REMATCH[0]}"
    echo "Major: ${BASH_REMATCH[1]}"
    echo "Minor: ${BASH_REMATCH[2]}"
    echo "Patch: ${BASH_REMATCH[3]}"
else
    echo "Invalid Semantic Version" >&2
fi
```

```bash
(( a > b ))    # Greater than
(( a < b ))    # Less than
(( a >= b ))   # Greater than or equal
(( a <= b ))   # Less than or equal
(( a == b ))   # Equal
(( a != b ))   # Not equal
(( a % 2 == 0 )) # Modulo (Even check)
```

```bash
check_cluster_health() {
    local active_nodes="$1"
    local min_nodes=3
    local max_nodes=20

    if (( active_nodes < min_nodes )); then
        echo "CRITICAL: Node pool degraded below quorum (${active_nodes}/${min_nodes})"
        return 2
    elif (( active_nodes > max_nodes )); then
        echo "WARNING: Node pool scaled beyond budget cap (${active_nodes}/${max_nodes})"
        return 1
    else
        echo "HEALTHY: Active nodes within boundaries (${active_nodes})"
        return 0
    fi
}
```

```bash
config_file="/etc/app/config.json"

# Compound condition with [[ ]]
if [[ -f "$config_file" && -s "$config_file" && -r "$config_file" ]]; then
    echo "Configuration verified: exists, non-empty, and readable"
else
    echo "Configuration integrity failure" >&2
    exit 1
fi
```

```bash
# Guard clause pattern
[[ -d "/var/log/app" ]] || mkdir -p "/var/log/app"
[[ -w "/var/log/app" ]] || { echo "Cannot write to log dir" >&2; exit 1; }
```

```text
                                 The Lexicographic Trap
                                 
           [[ "10" > "2" ]]                          (( 10 > 2 ))
                  │                                        │
                  ▼                                        ▼
      Lexicographic Comparison                     Numeric Comparison
  '1' comes BEFORE '2' in ASCII                 10 is mathematically greater than 2
          EVALUATES TO: FALSE                      EVALUATES TO: TRUE
```

```text
  [ START: 08_file_sentinel.sh ]
                 │
                 ▼
     Has arguments provided? ($# == 0)
        ├── YES ──► Output usage, return exit 2
        │
        └── NO  ──► Iterate through targets: for target in "$@"
                          │
                          ▼
            [ Path existence check: [[ ! -e && ! -L ]] ]
                 ├── YES (Missing) ──► Log FAIL, increment issues
                 │
                 └── NO (Found) ────► [ Broken symlink check: [[ -L && ! -e ]] ]
                                          ├── YES ──► Log Broken Link FAIL, increment issues
                                          │
                                          └── NO ──► Identify Type (-f, -d, -b, -c, -p, -S)
                                                          │
                                                          ├── Regular File (-f) ──► Check size (-s)
                                                          │                           ├── Non-zero: PASS
                                                          │                           └── Zero: FAIL (Empty)
                                                          │
                                                          ├── Check Read (-r)
                                                          ├── Check Write (-w)
                                                          └── Check Execute/Traversal (-x)
                                                                  │
                                                                  ▼
                                                      Increment passed counter
                                                                  │
                                                                  ▼
                                                      Print Audit Summary Report
                                                                  │
                                      Issues == 0 ? ──────┬───────┘
                                                          ├── YES: exit 0 (Clean)
                                                          └── NO : exit 1 (Findings)
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 08_file_sentinel.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 8/30 (Week 10)
# JOURNEY  : Day 264 / 1000
# PURPOSE  : Enterprise File, Directory, and Symlink Auditing Sentinel
# USAGE    : ./08_file_sentinel.sh <path1> [path2] [path3] ...
# ==============================================================================

# Defensive strict mode: nounset and pipefail
set -uo pipefail

# ------------------------------------------------------------------------------
# 1. COLOR & FORMATTING CONSTANTS
# ------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ------------------------------------------------------------------------------
# 2. STATE & COUNTERS
# ------------------------------------------------------------------------------
total=0
passed=0
issues=0

# ------------------------------------------------------------------------------
# 3. HELPER FUNCTIONS
# ------------------------------------------------------------------------------
print_header() {
    echo -e "${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}           FILE SENTINEL AUDITOR v1.0               ${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
}

print_usage() {
    echo -e "${YELLOW}Usage: $0 <path1> [path2] [path3] ...${RESET}"
    echo
    echo "Options / Help:"
    echo "  $0 --help, -h       Display this help message and exit"
    echo
    echo "Examples:"
    echo "  $0 /etc/passwd /var/log /tmp/missing.txt"
    echo "  $0 \"/opt/app/config.json\" \"/var/run/docker.sock\""
    echo
    echo "Exit Codes:"
    echo "  0 : All target paths passed inspection without issues"
    echo "  1 : Audit findings detected (missing paths, broken links, empty files, unreadable)"
    echo "  2 : Invalid usage or missing arguments"
}

audit_path() {
    local path="$1"

    ((total += 1))

    echo
    echo -e "${BLUE}${BOLD}TARGET [${total}]: ${path}${RESET}"
    echo "----------------------------------------------------"

    # Step A: Existence verification (accounting for broken symlinks)
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        echo -e "${RED}[FAIL] Path does not exist on filesystem${RESET}"
        ((issues += 1))
        return
    fi

    # Step B: Broken symlink detection
    if [[ -L "$path" && ! -e "$path" ]]; then
        echo -e "${YELLOW}[TYPE] Symbolic link (Broken / Dangling)${RESET}"
        echo -e "${RED}[FAIL] Broken symbolic link target does not exist${RESET}"
        ((issues += 1))
        return
    fi

    echo -e "${GREEN}[PASS] Path exists and resolves correctly${RESET}"

    # Step C: Type identification
    if [[ -L "$path" ]]; then
        echo -e "${CYAN}[TYPE] Symbolic link (Points to: $(readlink "$path" 2>/dev/null || echo 'unknown'))${RESET}"
    fi

    if [[ -f "$path" ]]; then
        echo -e "[TYPE] Regular file"

        # Check file data payload
        if [[ -s "$path" ]]; then
            echo -e "${GREEN}[PASS] File contains data (non-zero size)${RESET}"
        else
            echo -e "${RED}[FAIL] File is completely empty (zero bytes)${RESET}"
            ((issues += 1))
        fi
    elif [[ -d "$path" ]]; then
        echo -e "[TYPE] Directory"
    elif [[ -b "$path" ]]; then
        echo -e "[TYPE] Block device"
    elif [[ -c "$path" ]]; then
        echo -e "[TYPE] Character device"
    elif [[ -p "$path" ]]; then
        echo -e "[TYPE] Named pipe (FIFO)"
    elif [[ -S "$path" ]]; then
        echo -e "[TYPE] Socket"
    else
        echo -e "[TYPE] Special file or unknown filesystem entry"
    fi

    # Step D: Read permission check
    if [[ -r "$path" ]]; then
        echo -e "${GREEN}[PASS] Read permission available${RESET}"
    else
        echo -e "${RED}[FAIL] Read permission denied${RESET}"
        ((issues += 1))
    fi

    # Step E: Write permission check
    if [[ -w "$path" ]]; then
        echo -e "${GREEN}[PASS] Write permission available${RESET}"
    else
        echo -e "${YELLOW}[INFO] Write permission unavailable (Read-only)${RESET}"
    fi

    # Step F: Execute / traversal permission check
    if [[ -x "$path" ]]; then
        if [[ -d "$path" ]]; then
            echo -e "${GREEN}[PASS] Directory traversal permission available (+x)${RESET}"
        else
            echo -e "${GREEN}[PASS] Binary/script execute permission available (+x)${RESET}"
        fi
    else
        if [[ -d "$path" ]]; then
            echo -e "${RED}[FAIL] Directory traversal denied (-x)${RESET}"
            ((issues += 1))
        else
            echo -e "${YELLOW}[INFO] Execute permission not granted (Non-executable)${RESET}"
        fi
    fi

    ((passed += 1))
}

# ------------------------------------------------------------------------------
# 4. MAIN ENTRYPOINT
# ------------------------------------------------------------------------------
# Handle help flag early
if [[ $# -ge 1 && ( "$1" == "--help" || "$1" == "-h" ) ]]; then
    print_header
    print_usage
    exit 0
fi

print_header

# Validate command-line arguments
if (( $# == 0 )); then
    echo -e "${RED}ERROR: No file or directory targets specified.${RESET}\n"
    print_usage
    exit 2
fi

# Audit every target provided on the command line
for target in "$@"; do
    audit_path "$target"
done

# ------------------------------------------------------------------------------
# 5. AUDIT SUMMARY REPORT
# ------------------------------------------------------------------------------
echo
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}                  AUDIT SUMMARY                     ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-22s : %d\n" "Total targets" "$total"
printf "%-22s : %d\n" "Inspected successfully" "$passed"
printf "%-22s : %d\n" "Issues / Failures found" "$issues"
echo -e "${CYAN}====================================================${RESET}"

if (( issues == 0 )); then
    echo -e "${GREEN}${BOLD}RESULT: ALL CHECKS PASSED — SYSTEM INTEGRITY VERIFIED${RESET}"
    exit 0
else
    echo -e "${RED}${BOLD}RESULT: AUDIT FINDINGS DETECTED — REMEDIATION REQUIRED${RESET}"
    exit 1
fi
```

```bash
# Prepare isolated test environment
mkdir -p ~/sentinel-lab/config ~/sentinel-lab/logs
echo "DB_PORT=5432" > ~/sentinel-lab/config/app.conf
touch ~/sentinel-lab/logs/empty.log
echo "INFO: Started worker" > ~/sentinel-lab/logs/worker.log
ln -s ~/sentinel-lab/config/app.conf ~/sentinel-lab/app-symlink.conf
ln -s /nonexistent/target.txt ~/sentinel-lab/broken-symlink.txt

chmod 644 ~/sentinel-lab/config/app.conf
chmod 444 ~/sentinel-lab/logs/worker.log
```

```bash
./08_file_sentinel.sh \
    ~/sentinel-lab/config/app.conf \
    ~/sentinel-lab/logs \
    ~/sentinel-lab/logs/empty.log \
    ~/sentinel-lab/logs/worker.log \
    ~/sentinel-lab/app-symlink.conf \
    ~/sentinel-lab/broken-symlink.txt \
    ~/sentinel-lab/ghost-file.txt
```

```bash
# Static syntax inspection
bash -n linux-mastery/scripts/08_file_sentinel.sh

# Deep static analysis
shellcheck linux-mastery/scripts/08_file_sentinel.sh
```

```bash
check_file_payload() {
    local file="$1"
    if [[ -f "$file" && -s "$file" ]]; then
        echo "Valid: '$file' exists as a regular file with payload ($(wc -c < "$file") bytes)."
    else
        echo "Invalid: '$file' is either missing, not a regular file, or empty." >&2
        return 1
    fi
}
```

```bash
validate_backup_directory() {
    local target_dir="$1"
    if [[ -d "$target_dir" && -w "$target_dir" ]]; then
        echo "SUCCESS: Destination '$target_dir' exists and has write permission."
    else
        echo "FAILURE: Destination '$target_dir' is not a writable directory." >&2
        return 1
    fi
}
```

```bash
validate_username() {
    local username="${1:-}"
    if [[ -z "$username" ]]; then
        echo "ERROR: Username parameter cannot be null or empty string." >&2
        return 1
    fi
    echo "Username accepted: $username"
}
```

```bash
check_fizzbuzz_divisibility() {
    local num="$1"
    if (( num % 3 == 0 && num % 5 == 0 )); then
        echo "$num is divisible by both 3 and 5 (FizzBuzz)."
    else
        echo "$num does not satisfy 3 and 5 mutual divisibility."
    fi
}
```

```bash
is_log_file() {
    local filename="$1"
    if [[ "$filename" == *.log ]]; then
        echo "MATCH: '$filename' is an application log file."
    else
        echo "NO MATCH: '$filename' does not carry the .log extension."
    fi
}
```

```bash
validate_executable_script() {
    local script_path="$1"
    if [[ -f "$script_path" && -x "$script_path" ]]; then
        echo "READY: Script '$script_path' is a regular executable binary/script."
    else
        echo "NOT READY: '$script_path' is missing or lacks execute (+x) permission." >&2
        return 1
    fi
}
```

```bash
audit_missing_targets() {
    local missing_count=0
    for target in "$@"; do
        if [[ ! -e "$target" && ! -L "$target" ]]; then
            echo "MISSING: $target" >&2
            ((missing_count += 1))
        else
            echo "PRESENT: $target"
        fi
    done
    return "$missing_count"
}
```

```bash
alert_cpu_threshold() {
    local current_cpu="$1"
    local threshold=80

    if (( current_cpu > threshold )); then
        echo "ALERT: CPU utilization at ${current_cpu}% exceeds safety ceiling of ${threshold}%!"
        return 1
    else
        echo "OK: CPU utilization (${current_cpu}%) is within operational limits."
        return 0
    fi
}
```

```bash
if [[ -L "$path" && ! -e "$path" ]]; then
    echo "Broken symbolic link"
fi
```

```bash
# ------------------------------------------------------------------------------
# FILE TESTS
# ------------------------------------------------------------------------------
[[ -e "$file" ]]       # Path exists on filesystem
[[ -f "$file" ]]       # Regular file
[[ -d "$dir" ]]        # Directory
[[ -s "$file" ]]       # Non-empty file (size > 0 bytes)
[[ -L "$link" ]]       # Symbolic link
[[ -S "$sock" ]]       # UNIX socket
[[ -L "$p" && ! -e "$p" ]] # Broken / dangling symbolic link

# ------------------------------------------------------------------------------
# PERMISSION TESTS
# ------------------------------------------------------------------------------
[[ -r "$path" ]]       # Read permission
[[ -w "$path" ]]       # Write permission
[[ -x "$path" ]]       # Execute (file) / Traversal (dir)

# ------------------------------------------------------------------------------
# STRING TESTS
# ------------------------------------------------------------------------------
[[ -z "$str" ]]        # String is empty / length is 0
[[ -n "$str" ]]        # String is non-empty / length > 0
[[ "$a" == "$b" ]]     # String equality
[[ "$a" != "$b" ]]     # String inequality
[[ "$a" == *.log ]]    # Glob pattern matching (unquoted RHS)
[[ "$a" =~ ^[0-9]+$ ]] # Extended regular expression matching

# ------------------------------------------------------------------------------
# ARITHMETIC TESTS
# ------------------------------------------------------------------------------
(( a > b ))            # Greater than
(( a < b ))            # Less than
(( a >= b ))           # Greater than or equal
(( a <= b ))           # Less than or equal
(( a == b ))           # Arithmetic equality
(( a != b ))           # Arithmetic inequality
(( a % 2 == 0 ))       # Modulo check (Even number)

# ------------------------------------------------------------------------------
# EXIT CODES & LOGIC
# ------------------------------------------------------------------------------
[[ condition ]] && action_on_true || action_on_false
exit 0                 # Success
exit 1                 # Failure / Audit findings
exit 2                 # CLI usage / Syntax error
```

```text
                  Cloud Infrastructure Conditional Pipeline
                  
      GitHub Actions / CI Runner
                  │
                  ▼
         [ Pre-flight Gate ]
                  │
                  ├── Validate /etc/ssl/certs/ca.crt exists & non-empty  --> [[ -s $CERT ]]
                  ├── Verify Docker socket is active UNIX socket          --> [[ -S /var/run/docker.sock ]]
                  ├── Verify persistent volume mount is writable         --> [[ -d $PV && -w $PV ]]
                  └── Ensure GPU allocation count is >= requested        --> (( GPU_COUNT >= 8 ))
                  │
                  ├─── ANY FAILURE ──► Halt deployment, alert on-call (Exit 1)
                  │
                  └─── ALL PASS    ──► Launch Distributed Training Pods (Exit 0)
```

---

## Day 265 / 1000 — Day 9 / 30: Advanced Branching: `if/elif/else` & `case`
- **Date:** November 21, 2026 (Calendar: November 21, 2026 (Saturday))

```text
               Bash Conditional Evaluation Philosophy
               
  [ command executes ] ──► Returns Exit Status ($?)
                                  │
                  ┌───────────────┴───────────────┐
                  ▼                               ▼
             Exit Code 0                     Exit Code 1–255
            [ SUCCESS ]                        [ FAILURE ]
                  │                               │
                  ▼                               ▼
          then branch runs                else/elif branch runs
```

```bash
# ANTI-PATTERN: Redundant and fragile
mkdir -p /tmp/cloud-lab
if [[ $? -eq 0 ]]; then
    echo "Directory created successfully"
else
    echo "Directory creation failed"
fi
```

```bash
# IDIOMATIC: Clean, atomic, and safe
if mkdir -p /tmp/cloud-lab; then
    echo "Directory created successfully"
else
    echo "Directory creation failed" >&2
fi
```

```bash
curl -fsSL https://api.internal.cloud/status | grep "HEALTHY"
if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
    echo "CRITICAL: curl failed to connect to API"
elif [[ "${PIPESTATUS[1]}" -ne 0 ]]; then
    echo "WARNING: API returned non-healthy payload"
else
    echo "OK: Service is operational"
fi
```

```bash
if primary_command; then
    # Executes when primary_command exits with status 0
elif secondary_command; then
    # Executes when primary_command exits non-zero AND secondary_command exits 0
elif tertiary_command; then
    # Evaluated only if all preceding branches failed
else
    # Fallback default executed if all previous tests exited non-zero
fi
```

```bash
#!/usr/bin/env bash
set -euo pipefail

disk_usage=85

if (( disk_usage >= 90 )); then
    echo "PAGERDUTY ALERT: Disk usage critical (${disk_usage}%)"
elif (( disk_usage >= 75 )); then
    echo "SLACK WARNING: Disk usage elevated (${disk_usage}%)"
else
    echo "INFO: Disk usage normal (${disk_usage}%)"
fi
```

```bash
#!/usr/bin/env bash
set -uo pipefail

server="10.0.0.1"

# 1. Direct command evaluation with ping
# 2. -c 1: Single packet probe
# 3. -W 2: 2-second timeout window
# 4. &>/dev/null: Redirect both stdout (fd 1) and stderr (fd 2) to bit bucket
if ping -c 1 -W 2 "$server" &>/dev/null; then
    echo "Node ${server} is REACHABLE"
elif [[ -n "$server" ]]; then
    echo "Node ${server} is CONFIGURED but UNREACHABLE (Packet timeout / drop)" >&2
else
    echo "ERROR: Target server IP or hostname is unset" >&2
fi
```

```bash
#!/usr/bin/env bash

# Developer intent:
# If backup directory exists, compress it; otherwise report that it is missing.
[[ -d "/var/data" ]] && tar -czf /backup/data.tar.gz /var/data || echo "Directory does not exist"
```

```bash
true && false || echo "Failure branch reached!"
# Output: Failure branch reached!
```

```text
  Simple one-liner guard clause:   [[ -f "$file" ]] || exit 1          (SAFE)
  Simple dependent chain:          mkdir -p /tmp/d && cd /tmp/d        (SAFE)
  Ternary replacement simulation:  cmd1 && cmd2 || cmd3                (UNSAFE / BANNED)
```

```bash
if [[ -d "/var/data" ]]; then
    if ! tar -czf /backup/data.tar.gz /var/data; then
        echo "ERROR: Backup compression failed" >&2
        exit 1
    fi
else
    echo "ERROR: Source directory /var/data does not exist" >&2
    exit 1
fi
```

```bash
case "$variable" in
    pattern1)
        commands
        ;;
    pattern2 | pattern3)
        commands_for_pattern2_or_pattern3
        ;;
    *)
        fallback_default_commands
        ;;
esac
```

```bash
#!/usr/bin/env bash
set -euo pipefail

classify_artifact() {
    local artifact="${1##*/}" # Extract basename

    case "$artifact" in
        *.tar.gz|*.tgz)
            echo "Format: Gzip Compressed Tarball (Deploy via tar -xzf)"
            ;;
        *.zip)
            echo "Format: Standard ZIP Archive (Deploy via unzip)"
            ;;
        *.whl)
            echo "Format: Python Built Wheel (Deploy via pip install)"
            ;;
        *.deb)
            echo "Format: Debian Package (Deploy via dpkg -i)"
            ;;
        *.rpm)
            echo "Format: RedHat Package (Deploy via rpm -Uvh)"
            ;;
        *.dockerfile|Dockerfile*)
            echo "Format: Container Specification (Deploy via docker build)"
            ;;
        *)
            echo "Format: Unrecognized Artifact '${artifact}'" >&2
            return 1
            ;;
    esac
}
```

```text
                            Case Terminator Comparison
                            
           ;;                            ;&                           ;;&
           ▼                             ▼                             ▼
   [ Match Pattern ]             [ Match Pattern ]             [ Match Pattern ]
           │                             │                             │
   [ Run Commands ]              [ Run Commands ]              [ Run Commands ]
           │                             │                             │
           ▼                             ▼                             ▼
   [ EXIT CASE BLOCK ]           [ Fall Directly into         [ Continue checking ]
                                   Next Branch Commands        [ Subsequent Patterns ]
                                   WITHOUT pattern test ]
```

```bash
#!/usr/bin/env bash

log_level="ERROR"

case "$log_level" in
    CRITICAL)
        echo "[PAGER] Trigger PagerDuty on-call alert"
        ;& # Fall through to ERROR notification
    ERROR)
        echo "[SLACK] Post alert to #cloud-ops channel"
        ;& # Fall through to WARNING telemetry
    WARNING)
        echo "[DATADOG] Emit metric increment to monitor"
        ;;
    INFO)
        echo "[LOG] Standard stdout capture"
        ;;
esac
```

```text
[SLACK] Post alert to #cloud-ops channel
[DATADOG] Emit metric increment to monitor
```

```bash
#!/usr/bin/env bash

user_role="admin_devops_engineer"

case "$user_role" in
    *admin*)
        echo "PERMISSION: Granted Root / ClusterAdmin access"
        ;;& # Continue testing remaining patterns
    *devops*)
        echo "PERMISSION: Granted CI/CD pipeline and registry write access"
        ;;& # Continue testing remaining patterns
    *engineer*)
        echo "PERMISSION: Granted read-only staging telemetry access"
        ;;
    *)
        echo "PERMISSION: Default unprivileged guest"
        ;;
esac
```

```text
PERMISSION: Granted Root / ClusterAdmin access
PERMISSION: Granted CI/CD pipeline and registry write access
PERMISSION: Granted read-only staging telemetry access
```

```text
NAME="Ubuntu"
VERSION="24.04 LTS (Noble Numbat)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 24.04 LTS"
VERSION_ID="24.04"
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 09_os_detector.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 9/30 (Week 10)
# JOURNEY  : Day 265 / 1000
# PURPOSE  : Enterprise Linux OS, Distribution Family & Package Manager Detector
# USAGE    : ./09_os_detector.sh [--install] [--file <os-release-path>]
# ==============================================================================

# Defensive strict mode
set -uo pipefail

# ------------------------------------------------------------------------------
# 1. COLOR & FORMATTING CONSTANTS
# ------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ------------------------------------------------------------------------------
# 2. CONFIGURATION & STATE
# ------------------------------------------------------------------------------
SCRIPT_NAME="${0##*/}"
OS_RELEASE="${OS_RELEASE_FILE:-/etc/os-release}"
DO_INSTALL=false

# ------------------------------------------------------------------------------
# 3. HELPER FUNCTIONS
# ------------------------------------------------------------------------------
show_help() {
    cat <<EOF
Usage: ${SCRIPT_NAME} [OPTIONS]

Linux OS Distribution and Package Manager Detection Utility.

Options:
  --install              Execute the recommended package installation command
  --file <path>          Specify custom os-release file (useful for mocking/testing)
  --help, -h             Display this documentation and exit

Examples:
  ./${SCRIPT_NAME}
  ./${SCRIPT_NAME} --file /tmp/mock-rhel-release
  sudo ./${SCRIPT_NAME} --install

Exit Codes:
  0 : Detection completed successfully (or installation completed)
  1 : Missing / unreadable os-release file, or unsupported distribution
  2 : Invalid CLI arguments
EOF
}

# ------------------------------------------------------------------------------
# 4. ARGUMENT PARSING
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --install)
            DO_INSTALL=true
            shift
            ;;
        --file)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo -e "${RED}ERROR: --file requires a valid file path argument.${RESET}" >&2
                exit 2
            fi
            OS_RELEASE="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}ERROR: Unknown option: $1${RESET}" >&2
            echo "Use '${SCRIPT_NAME} --help' for usage information." >&2
            exit 2
            ;;
    esac
done

# ------------------------------------------------------------------------------
# 5. OS IDENTIFICATION EXTRACTION
# ------------------------------------------------------------------------------
# Verify that the os-release file exists and is readable
if [[ ! -r "$OS_RELEASE" ]]; then
    echo -e "${RED}ERROR: Cannot read OS identification file at: ${OS_RELEASE}${RESET}" >&2
    echo "This script requires a standard Linux /etc/os-release file or --file override." >&2
    exit 1
fi

# Load variables safely from os-release
# shellcheck source=/dev/null
source "$OS_RELEASE"

# Defensive defaults under set -u
ID="${ID:-unknown}"
ID_LIKE="${ID_LIKE:-}"
PRETTY_NAME="${PRETTY_NAME:-Unknown Linux Distribution}"
VERSION_ID="${VERSION_ID:-Unknown}"

# Normalize distribution identifiers (Bash parameter expansion to lowercase)
OS_ID="${ID,,}"
OS_LIKE="${ID_LIKE:-}"
OS_PRETTY="${PRETTY_NAME}"
OS_VERSION="${VERSION_ID}"

echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}            LINUX OS & RUNTIME DETECTOR             ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-20s : %b\n" "Distribution" "${GREEN}${BOLD}${OS_PRETTY}${RESET}"
printf "%-20s : %s\n" "OS ID" "${OS_ID}"
printf "%-20s : %s\n" "OS Family (LIKE)" "${OS_LIKE:-None specified}"
printf "%-20s : %s\n" "Version ID" "${OS_VERSION}"
echo -e "${CYAN}----------------------------------------------------${RESET}"

# ------------------------------------------------------------------------------
# 6. DISTRIBUTION FAMILY & PACKAGE MANAGER MAPPING (pattern matching)
# ------------------------------------------------------------------------------
case "${OS_ID} ${OS_LIKE}" in

    ubuntu*|debian*|*debian*)
        FAMILY="Debian"
        PACKAGE_MANAGER="apt"
        INSTALL_COMMAND="sudo apt update && sudo apt install -y nginx"
        ;;

    amzn*|rhel*|centos*|rocky*|almalinux*|fedora*|*rhel*|*fedora*)
        FAMILY="RHEL"
        if command -v dnf &>/dev/null; then
            PACKAGE_MANAGER="dnf"
            INSTALL_COMMAND="sudo dnf install -y nginx"
        elif command -v yum &>/dev/null; then
            PACKAGE_MANAGER="yum"
            INSTALL_COMMAND="sudo yum install -y nginx"
        else
            PACKAGE_MANAGER="dnf/yum (not found in PATH)"
            INSTALL_COMMAND="sudo dnf install -y nginx"
        fi
        ;;

    alpine*|*alpine*)
        FAMILY="Alpine"
        PACKAGE_MANAGER="apk"
        INSTALL_COMMAND="sudo apk add --no-cache nginx"
        ;;

    arch*|*arch*|manjaro*|*manjaro*)
        FAMILY="Arch"
        PACKAGE_MANAGER="pacman"
        INSTALL_COMMAND="sudo pacman -S --noconfirm nginx"
        ;;

    sles*|opensuse*|*suse*)
        FAMILY="SUSE"
        PACKAGE_MANAGER="zypper"
        INSTALL_COMMAND="sudo zypper install -y nginx"
        ;;

    *)
        FAMILY="Unknown"
        PACKAGE_MANAGER="Unknown"
        INSTALL_COMMAND="Unsupported distribution"
        ;;

esac

printf "%-20s : %b\n" "Detected Family" "${BOLD}${YELLOW}${FAMILY}${RESET}"
printf "%-20s : %b\n" "Package Manager" "${BOLD}${CYAN}${PACKAGE_MANAGER}${RESET}"
echo
echo -e "${BOLD}Recommended Nginx Installation Command:${RESET}"
echo -e "  ${BLUE}${INSTALL_COMMAND}${RESET}"
echo -e "${CYAN}====================================================${RESET}"

# ------------------------------------------------------------------------------
# 7. OPTIONAL INSTALLATION EXECUTION (--install)
# ------------------------------------------------------------------------------
if [[ "$DO_INSTALL" == true ]]; then
    echo
    echo -e "${YELLOW}[!] Installation flag detected (--install). Initiating package deployment...${RESET}"

    case "$FAMILY" in
        Debian)
            echo -e "${BLUE}Executing:${RESET} sudo apt update && sudo apt install -y nginx"
            sudo apt update && sudo apt install -y nginx
            ;;

        RHEL)
            if command -v dnf &>/dev/null; then
                echo -e "${BLUE}Executing:${RESET} sudo dnf install -y nginx"
                sudo dnf install -y nginx
            elif command -v yum &>/dev/null; then
                echo -e "${BLUE}Executing:${RESET} sudo yum install -y nginx"
                sudo yum install -y nginx
            else
                echo -e "${RED}ERROR: Neither dnf nor yum package manager was located in PATH.${RESET}" >&2
                exit 1
            fi
            ;;

        Alpine)
            echo -e "${BLUE}Executing:${RESET} sudo apk add --no-cache nginx"
            sudo apk add --no-cache nginx
            ;;

        Arch)
            echo -e "${BLUE}Executing:${RESET} sudo pacman -S --noconfirm nginx"
            sudo pacman -S --noconfirm nginx
            ;;

        SUSE)
            echo -e "${BLUE}Executing:${RESET} sudo zypper install -y nginx"
            sudo zypper install -y nginx
            ;;

        *)
            echo -e "${RED}ERROR: Cannot install packages on unsupported Linux family: ${FAMILY}${RESET}" >&2
            exit 1
            ;;
    esac

    echo -e "${GREEN}${BOLD}[SUCCESS] Package installation sequence executed successfully.${RESET}"
else
    echo -e "${YELLOW}Note: Dry-run detection complete. To execute software installation, supply '--install'.${RESET}"
fi

exit 0
```

```text
               Heterogeneous Cloud Provisioning Pipeline
               
                        [ Central Ansible / Packer / CI ]
                                        │
             ┌──────────────────────────┼──────────────────────────┐
             ▼                          ▼                          ▼
      AWS EC2 Instance           GCP Compute Engine         Docker Container
      (Amazon Linux 2023)        (Debian 12 Bookworm)       (Alpine Linux 3.20)
             │                          │                          │
             ▼                          ▼                          ▼
     [ 09_os_detector.sh ]      [ 09_os_detector.sh ]      [ 09_os_detector.sh ]
             │                          │                          │
             ├── ID=amzn                ├── ID=debian              ├── ID=alpine
             ├── Family=RHEL            ├── Family=Debian          ├── Family=Alpine
             └── PKG=dnf                └── PKG=apt                └── PKG=apk
             │                          │                          │
             ▼                          ▼                          ▼
     dnf install -y nginx       apt install -y nginx       apk add --no-cache nginx
```

```bash
#!/usr/bin/env bash
# exercise_01_server_health.sh

set -euo pipefail

usage() {
    echo "Usage: $0 <cpu_percentage (0-100)>" >&2
    exit 2
}

[[ $# -eq 1 ]] || usage

cpu_input="$1"

# 1. Regex validation for positive integer
if [[ ! "$cpu_input" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Input '$cpu_input' is not a valid non-negative integer." >&2
    exit 2
fi

# 2. Boundary validation (0 - 100)
if (( cpu_input < 0 || cpu_input > 100 )); then
    echo "ERROR: CPU usage must be between 0 and 100. Received: $cpu_input" >&2
    exit 2
fi

# 3. Multi-tier evaluation
if (( cpu_input >= 90 )); then
    echo "STATUS: CRITICAL (CPU utilization: ${cpu_input}%)"
    exit 1
elif (( cpu_input >= 70 )); then
    echo "STATUS: WARNING (CPU utilization: ${cpu_input}%)"
    exit 0
else
    echo "STATUS: NORMAL (CPU utilization: ${cpu_input}%)"
    exit 0
fi
```

```bash
#!/usr/bin/env bash
# exercise_02_file_validator.sh

set -uo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <filename>" >&2
    exit 2
fi

target="$1"

echo "Auditing File: $target"
echo "------------------------------------"

if [[ ! -e "$target" ]]; then
    echo "[!] Existence   : MISSING (Path does not exist)"
    exit 1
fi

echo "[✓] Existence   : PRESENT"
[[ -r "$target" ]] && echo "[✓] Read (r)    : GRANTED" || echo "[-] Read (r)    : DENIED"
[[ -w "$target" ]] && echo "[✓] Write (w)   : GRANTED" || echo "[-] Write (w)   : DENIED"
[[ -x "$target" ]] && echo "[✓] Execute (x) : GRANTED" || echo "[-] Execute (x) : DENIED"
```

```bash
#!/usr/bin/env bash
# exercise_03_log_classifier.sh

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <filepath>" >&2
    exit 2
fi

filename="${1##*/}"

case "$filename" in
    *.log)
        echo "CLASSIFICATION: Application Log File"
        ;;
    *.conf|*.cfg|*.ini)
        echo "CLASSIFICATION: Service Configuration File"
        ;;
    *.tar.gz|*.tgz)
        echo "CLASSIFICATION: Gzip Compressed Archive"
        ;;
    *.sh|*.bash)
        echo "CLASSIFICATION: Shell Automation Script"
        ;;
    *)
        echo "CLASSIFICATION: Unknown / Uncategorized File Type"
        ;;
esac
```

```bash
#!/usr/bin/env bash
# exercise_04_access_classifier.sh

set -euo pipefail

echo "================================================="
echo "DEMO 1: Unconditional Fallthrough (;&)"
echo "Scenario: Escalating Incident Remediation"
echo "================================================="

severity="SEV-1"

case "$severity" in
    SEV-1)
        echo "[ACTION 1] Page VP of Engineering & Incident Commander"
        ;& # Fall through to SEV-2 actions unconditionally!
    SEV-2)
        echo "[ACTION 2] Post status update to public statuspage.io"
        ;& # Fall through to SEV-3 actions unconditionally!
    SEV-3)
        echo "[ACTION 3] Open Jira ticket and notify engineering on-call"
        ;;
esac

echo
echo "================================================="
echo "DEMO 2: Continued Pattern Matching (;;&)"
echo "Scenario: Multi-Attribute Cloud Asset Tagging"
echo "================================================="

resource_tag="prod-gpu-k8s-worker"

case "$resource_tag" in
    prod*)
        echo "[TAG MATCH] Production tier: Requires 99.99% SLA and high-priority alerts"
        ;;& # Continue testing remaining patterns!
    *gpu*)
        echo "[TAG MATCH] Hardware accelerator: Requires NVIDIA driver daemonset"
        ;;& # Continue testing remaining patterns!
    *k8s*)
        echo "[TAG MATCH] Kubernetes cluster: Registered in control-plane node pool"
        ;;& # Continue testing remaining patterns!
    *)
        echo "[TAG MATCH] General compute resource"
        ;;
esac
```

---

## Day 266 / 1000 — Day 10 / 30: Loops, Safe Iteration & Service Polling
- **Date:** November 22, 2026 (Calendar: November 22, 2026 (Sunday))

```bash
for (( initialization; condition; step ))
do
    # Executed while condition evaluates to true (non-zero arithmetic)
done
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# Scenario 1: Bounded Retry Loop with Index Counter
max_retries=5
for (( attempt=1; attempt<=max_retries; attempt++ )); do
    echo "Initiating database ping attempt [${attempt}/${max_retries}]..."
    if pg_isready -h localhost -p 5432 -q; then
        echo "Database is ready!"
        break
    fi
    sleep 2
done

# Scenario 2: Phased Canary Traffic Shifting (Step Increment)
# Shift traffic from 10% to 100% in 15% increments
for (( weight=10; weight<=100; weight+=15 )); do
    echo "Adjusting Envoy Canary Route Weight to: ${weight}%"
    # aws elbv2 modify-target-group ...
    sleep 1
done

# Scenario 3: Countdown Timer
for (( remaining=5; remaining>=1; remaining-- )); do
    printf "\rGraceful termination in %d seconds..." "$remaining"
    sleep 1
done
echo -e "\nExecuting process termination."
```

```bash
#!/usr/bin/env bash
servers=("us-east-1-web-01" "eu-central-1-db-01" "ap-south-1-cache-01")

# CORRECT: Fully quoted expansion with [@]
for server in "${servers[@]}"; do
    echo "Probing telemetry on host: $server"
done
```

```text
               Unquoted Expansion Hazard (${items[@]})
               
  items=("AWS Cloud" "Linux Cluster" "Production Database")
  
  [ for item in ${items[@]} ]
         │
         ▼ (Subjected to Word Splitting by $IFS)
  Generates 6 distinct tokens:
    1: "AWS"
    2: "Cloud"
    3: "Linux"
    4: "Cluster"
    5: "Production"
    6: "Database"
  
  [ for item in "${items[@]}" ]
         │
         ▼ (Quoted Expansion: Preserves Element Boundaries)
  Generates exactly 3 distinct elements intact.
```

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A INSTANCE_STATE=(
    ["i-0a1b2c3d4e"]="running"
    ["i-0f9e8d7c6b"]="stopped"
    ["i-1122334455"]="shutting-down"
)

echo "--- AWS EC2 FLEET AUDIT ---"
for instance_id in "${!INSTANCE_STATE[@]}"; do
    state="${INSTANCE_STATE[$instance_id]}"
    printf "Instance: %-15s | State: %s\n" "$instance_id" "$state"
done
```

```bash
# STRICTLY BANNED ANTI-PATTERN
for file in $(ls *.log); do
    process_log "$file"
done
```

```bash
#!/usr/bin/env bash
# SAFE: Pure shell pathname expansion
for log_file in /var/log/containers/*.log; do
    echo "Processing container log: $log_file"
done
```

```bash
# If no .tar.gz files exist in /tmp:
for archive in /tmp/*.tar.gz; do
    echo "$archive"  # PRINTS: "/tmp/*.tar.gz" !
done
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# Enable nullglob so empty matches vanish completely
shopt -s nullglob
log_files=( /var/log/audit/*.log )
shopt -u nullglob # Restore default state

if (( ${#log_files[@]} == 0 )); then
    echo "INFO: No audit log files pending processing. Clean state."
    exit 0
fi

echo "Discovered ${#log_files[@]} log files for processing."
for log in "${log_files[@]}"; do
    echo "Archiving: $log"
done
```

```bash
while condition_or_command; do
    # Commands executed while condition is true (status 0)
done
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# Infinite monitoring loop with interrupt trap
trap 'echo -e "\nTerminating monitor."; exit 0' SIGINT SIGTERM

echo "Beginning system resource telemetry stream (Ctrl+C to stop)..."
while true; do
    load=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)
    printf "[%s] Current 1-min load average: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$load"
    sleep 5
done
```

```bash
#!/usr/bin/env bash
# Processing multi-region cloud cluster nodes
for region in "us-east-1" "eu-west-1"; do
    for node in {1..5}; do
        if [[ "$region" == "eu-west-1" && "$node" -eq 3 ]]; then
            echo "Skipping maintenance on $region-node-$node"
            continue # Skips to next node in eu-west-1
        fi
        
        if [[ "$node" -gt 4 ]]; then
            break # Breaks out of inner node loop
        fi
        echo "Auditing $region-node-$node"
    done
done
```

```text
       while condition                          until condition
              │                                        │
     Condition evaluates                      Condition evaluates
              │                                        │
   ┌──────────┴──────────┐                  ┌──────────┴──────────┐
   ▼                     ▼                  ▼                     ▼
Exit 0 (True)      Non-zero (False)      Exit 0 (True)      Non-zero (False)
   │                     │                  │                     │
   ▼                     ▼                  ▼                     ▼
RUN BLOCK            EXIT LOOP          EXIT LOOP             RUN BLOCK
```

```bash
#!/usr/bin/env bash
set -uo pipefail

DB_HOST="postgres.production.internal"
DB_PORT="5432"

echo "Waiting for PostgreSQL ($DB_HOST:$DB_PORT) to accept TCP handshakes..."

# until nc -z (netcat zero-I/O) succeeds
until nc -z -w 2 "$DB_HOST" "$DB_PORT" 2>/dev/null; do
    echo "[WAIT] Database listener not yet reachable. Retrying in 2s..."
    sleep 2
done

echo "[READY] PostgreSQL connection established successfully. Starting application server."
```

```text
                    The Thundering Herd Phenomenon
                    
  1,000 Workers polling on fixed 1-second cadence:
  
  Time (s):  1.0          2.0          3.0          4.0
  Load:     ████████     ████████     ████████     ████████   (Peak spikes crash database)
  
  Workers polling with Exponential Backoff + Jitter:
  
  Time (s):  1.0   1.8   2.4   3.7   4.2   5.9   7.1   8.8
  Load:     █   █   █   █   █   █   █   █   █   █   █        (Evenly distributed load)
```

```text
  Attempt 1: 1s
  Attempt 2: 1s * 2^1 = 2s
  Attempt 3: 1s * 2^2 = 4s
  Attempt 4: 1s * 2^3 = 8s
  Attempt 5: 1s * 2^4 = 16s (Ceiling reached)
  Attempt 6: 16s (Capped at Max Delay)
```

```text
  [ START: 10_service_poller.sh <URL> ]
                  │
                  ▼
         Validate dependencies (curl) & parse flags (-t, -d, -m, -r)
                  │
                  ▼
    Initialize SECONDS=0, delay=INITIAL_DELAY, attempt=0
                  │
                  ▼
    ┌───► [ Loop Condition: while (( SECONDS < TIMEOUT )) ]
    │             │
    │             ├── Window expired? ──► Terminate loop
    │             │
    │             ▼
    │     Compute remaining = (TIMEOUT - SECONDS)
    │     Adjust request_time = min(MAX_REQUEST_TIME, remaining)
    │             │
    │             ▼
    │     Execute Probe: curl -fsS --max-time $request_time "$URL"
    │             │
    │             ├── HTTP 2xx/3xx (SUCCESS) ──► Mark healthy=true, BREAK LOOP
    │             │
    │             └── Error / Timeout (FAILURE)
    │                     │
    │                     ▼
    │             Adjust sleep_delay = min(delay, remaining)
    │             Sleep for $sleep_delay seconds
    │             Compute delay = min(delay * 2, MAX_DELAY)
    │             │
    └─────────────┘
                  │
                  ▼
         Generate Audit Summary
                  │
        healthy == true ? ───┬───► YES: Output OK, Exit 0
                             └───► NO : Output TIMEOUT, Exit 2
```

```bash
#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 10_service_poller.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 10/30 (Week 10)
# JOURNEY  : Day 266 / 1000
# PURPOSE  : Resilient Network Service Poller with Exponential Backoff & Timeout
# USAGE    : ./10_service_poller.sh <URL> [OPTIONS]
# ==============================================================================

# Defensive strict mode
set -uo pipefail

# ------------------------------------------------------------------------------
# 1. COLOR & FORMATTING CONSTANTS
# ------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ------------------------------------------------------------------------------
# 2. DEFAULT CONFIGURATION
# ------------------------------------------------------------------------------
SCRIPT_NAME="${0##*/}"
URL=""
TIMEOUT=60
INITIAL_DELAY=1
MAX_DELAY=16
MAX_REQUEST_TIME=5

# ------------------------------------------------------------------------------
# 3. HELPER FUNCTIONS
# ------------------------------------------------------------------------------
show_help() {
    cat <<EOF
Usage: ${SCRIPT_NAME} <URL> [OPTIONS]

Resilient Network Endpoint Poller with Exponential Backoff.

Arguments:
  <URL>                  Target HTTP/HTTPS or network endpoint to probe

Options:
  -t, --timeout SECONDS      Overall timeout threshold in seconds (default: 60)
  -d, --initial-delay SECS   Initial retry backoff delay in seconds (default: 1)
  -m, --max-delay SECONDS    Maximum ceiling backoff delay in seconds (default: 16)
  -r, --request-time SECS    Max connection/probe time per attempt (default: 5)
  -h, --help                 Display this documentation and exit

Examples:
  ./${SCRIPT_NAME} https://example.com
  ./${SCRIPT_NAME} https://api.internal.net:8080/health --timeout 30 --max-delay 8
  ./${SCRIPT_NAME} https://192.0.2.1 --timeout 15

Exit Codes:
  0 : Service became healthy and responsive within timeout
  1 : Invocation error, missing arguments, or missing dependencies
  2 : Service unreachable / timeout threshold elapsed
EOF
}

# ------------------------------------------------------------------------------
# 4. CLI ARGUMENT PARSING
# ------------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo -e "${RED}ERROR: Target URL is required.${RESET}\n" >&2
    show_help >&2
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --timeout|-t)
            if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}ERROR: --timeout requires a positive integer argument.${RESET}" >&2
                exit 1
            fi
            TIMEOUT="$2"
            shift 2
            ;;
        --initial-delay|-d)
            if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}ERROR: --initial-delay requires a positive integer argument.${RESET}" >&2
                exit 1
            fi
            INITIAL_DELAY="$2"
            shift 2
            ;;
        --max-delay|-m)
            if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}ERROR: --max-delay requires a positive integer argument.${RESET}" >&2
                exit 1
            fi
            MAX_DELAY="$2"
            shift 2
            ;;
        --request-time|-r)
            if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}ERROR: --request-time requires a positive integer argument.${RESET}" >&2
                exit 1
            fi
            MAX_REQUEST_TIME="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}ERROR: Unrecognized option '$1'.${RESET}" >&2
            show_help >&2
            exit 1
            ;;
        *)
            if [[ -z "$URL" ]]; then
                URL="$1"
                shift
            else
                echo -e "${RED}ERROR: Multiple URLs specified ('$URL' and '$1'). Only one target URL is supported.${RESET}" >&2
                exit 1
            fi
            ;;
    esac
done

if [[ -z "$URL" ]]; then
    echo -e "${RED}ERROR: Target URL was not specified.${RESET}" >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 5. DEPENDENCY VALIDATION
# ------------------------------------------------------------------------------
if ! command -v curl &>/dev/null; then
    echo -e "${RED}FATAL: 'curl' binary is required but not found in PATH.${RESET}" >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 6. POLLING ORCHESTRATION WITH EXPONENTIAL BACKOFF
# ------------------------------------------------------------------------------
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}            RESILIENT SERVICE POLLER v1.0           ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-22s : %b\n" "Target Endpoint" "${BLUE}${BOLD}${URL}${RESET}"
printf "%-22s : %d seconds\n" "Overall Timeout" "$TIMEOUT"
printf "%-22s : %d seconds\n" "Initial Backoff Delay" "$INITIAL_DELAY"
printf "%-22s : %d seconds\n" "Maximum Backoff Delay" "$MAX_DELAY"
printf "%-22s : %d seconds\n" "Max Request Window" "$MAX_REQUEST_TIME"
echo -e "${CYAN}====================================================${RESET}"

# Initialize loop metrics and state
SECONDS=0
attempt=0
delay=$INITIAL_DELAY
healthy=false

while (( SECONDS < TIMEOUT )); do
    ((attempt += 1))

    # Calculate remaining time window before timeout threshold
    remaining=$((TIMEOUT - SECONDS))
    if (( remaining <= 0 )); then
        break
    fi

    # Adjust individual request probe timeout so it never exceeds remaining overall deadline
    request_time=$MAX_REQUEST_TIME
    if (( request_time > remaining )); then
        request_time=$remaining
    fi

    echo
    echo -e "${BOLD}[Attempt ${attempt}]${RESET} Probing endpoint (Elapsed: ${SECONDS}s, Window: ${request_time}s)..."

    # Execute health check probe
    # -f: Fail silently on HTTP 4xx/5xx errors
    # -s: Silent mode (no progress bar)
    # -S: Show error message if it fails
    # --connect-timeout 3: Cap TCP handshake to 3 seconds
    # --max-time: Hard cap on total probe execution time
    # -o /dev/null: Discard response body payload
    if curl -fsS \
        --connect-timeout 3 \
        --max-time "$request_time" \
        -o /dev/null \
        "$URL" 2>/dev/null; then
        echo -e "${GREEN}${BOLD}[SUCCESS] Service is UP and responding with HTTP 2xx/3xx!${RESET}"
        healthy=true
        break
    fi

    echo -e "${YELLOW}[WARNING] Service unavailable / probe timed out.${RESET}"

    # Re-evaluate remaining timeout after probe completes
    if (( SECONDS >= TIMEOUT )); then
        break
    fi

    remaining=$((TIMEOUT - SECONDS))
    if (( remaining <= 0 )); then
        break
    fi

    # Cap sleep delay so it never exceeds remaining overall budget
    sleep_delay=$delay
    if (( sleep_delay > remaining )); then
        sleep_delay=$remaining
    fi

    echo -e "${CYAN}[INFO] Backoff: Retrying in ${sleep_delay}s (Next delay cap: ${delay}s)...${RESET}"
    sleep "$sleep_delay"

    # Compute exponential backoff for next cycle: delay = min(delay * 2, MAX_DELAY)
    delay=$((delay * 2))
    if (( delay > MAX_DELAY )); then
        delay=$MAX_DELAY
    fi
done

# ------------------------------------------------------------------------------
# 7. FINAL STATUS REPORT & EXIT
# ------------------------------------------------------------------------------
echo
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}                  POLLER SUMMARY                    ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-22s : %s\n" "Target Endpoint" "$URL"
printf "%-22s : %d\n" "Total Attempts" "$attempt"
printf "%-22s : %d seconds\n" "Total Elapsed Time" "$SECONDS"
printf "%-22s : %d seconds\n" "Configured Timeout" "$TIMEOUT"
echo -e "${CYAN}----------------------------------------------------${RESET}"

if [[ "$healthy" == true ]]; then
    echo -e "${GREEN}${BOLD}FINAL RESULT : SERVICE AVAILABLE (HTTP OK)${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
    exit 0
else
    echo -e "${RED}${BOLD}FINAL RESULT : SERVICE TIMEOUT (Endpoint unresponsive)${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
    exit 2
fi
```

```bash
#!/usr/bin/env bash
# exercise_01_even_numbers.sh
set -euo pipefail

echo "Even numbers between 1 and 50:"
for (( i=2; i<=50; i+=2 )); do
    printf "%d " "$i"
done
echo
```

```bash
#!/usr/bin/env bash
# exercise_02_server_inventory.sh
set -euo pipefail

servers=("aws-us-east-1" "aws-eu-west-1" "gcp-europe-north1" "azure-eastus2" "onprem-core-dc")

echo "=== SERVER INVENTORY AUDIT ==="
for (( i=0; i<${#servers[@]}; i++ )); do
    printf "Node Index [%d] -> Hostname: %s\n" "$i" "${servers[$i]}"
done
```

```bash
#!/usr/bin/env bash
# exercise_03_nullglob_processor.sh
set -euo pipefail

shopt -s nullglob
logs=( /var/log/*.log )
shopt -u nullglob

if (( ${#logs[@]} == 0 )); then
    echo "No log files found in directory."
    exit 0
fi

echo "Discovered ${#logs[@]} logs:"
for log in "${logs[@]}"; do
    echo " -> [FOUND] $log (Size: $(wc -c < "$log") bytes)"
done
```

```bash
#!/usr/bin/env bash
# exercise_04_while_counter.sh
set -euo pipefail

attempt=1
max_attempts=10

while (( attempt <= max_attempts )); do
    echo "[Check ${attempt}/${max_attempts}] Querying local daemon health..."
    # Simulated check: replace with actual probe
    if (( attempt == 6 )); then
        echo "Service responded successfully at attempt $attempt!"
        exit 0
    fi
    ((attempt += 1))
    sleep 1
done

echo "FAILED: Service did not respond within $max_attempts checks." >&2
exit 1
```

```bash
#!/usr/bin/env bash
# exercise_05_until_ready.sh
set -euo pipefail

READY_FILE="/tmp/database.ready"
TIMEOUT=30
SECONDS=0

echo "Waiting for initialization lockfile: $READY_FILE"

until [[ -f "$READY_FILE" ]]; do
    if (( SECONDS >= TIMEOUT )); then
        echo "ERROR: Timeout reached waiting for $READY_FILE." >&2
        exit 2
    fi
    printf "."
    sleep 2
done

echo -e "\nSUCCESS: $READY_FILE detected after ${SECONDS}s! Proceeding with migration."
```

```bash
#!/usr/bin/env bash
# exercise_06_retry_engine.sh
set -euo pipefail

delays=(1 2 4 8 16)

echo "Initiating multi-tier retry engine..."
for attempt in "${!delays[@]}"; do
    delay="${delays[$attempt]}"
    echo "[Attempt $((attempt + 1))/5] Executing action..."
    
    # Simulate action failure
    success=false
    
    if [[ "$success" == true ]]; then
        echo "Action completed successfully!"
        exit 0
    fi
    
    echo "Action failed. Backing off for ${delay}s..."
    sleep "$delay"
done

echo "FATAL: All retry attempts exhausted." >&2
exit 1
```

```bash
# ------------------------------------------------------------------------------
# LOOP SYNTAX REFERENCE
# ------------------------------------------------------------------------------
# C-Style Arithmetic Loop
for (( i=0; i<10; i++ )); do echo "$i"; done

# Array Item Iteration
for item in "${array[@]}"; do echo "$item"; done

# Associative Array Key Iteration
for key in "${!map[@]}"; do echo "$key -> ${map[$key]}"; done

# Safe Globbing with Nullglob
shopt -s nullglob; files=( *.log ); shopt -u nullglob

# Condition-driven While Loop
while (( count < 5 )); do ((count++)); done
while curl -fsS "$URL" >/dev/null; do sleep 5; done

# Condition-driven Until Loop (Runs until command succeeds)
until pg_isready -h "$HOST"; do sleep 2; done

# Flow Control Primitives
break       # Exit current loop
break 2     # Exit two nested loops
continue    # Jump to next iteration

# Exponential Backoff Formula
delay=$((delay * 2))
(( delay > MAX_DELAY )) && delay=$MAX_DELAY

# Elapsed Time Accounting
SECONDS=0
while (( SECONDS < TIMEOUT )); do ... done
```

---

