#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 11_csv_database_reader.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 11/30 (Week 10)
# JOURNEY  : Day 267 / 1000
# PURPOSE  : Stream Processing with read, Custom File Descriptors & Schema Validation
# USAGE    : ./11_csv_database_reader.sh [csv_file]
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
# 2. CONFIGURATION & SCRIPT DIRECTORY RESOLUTION
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="${0##*/}"

show_help() {
    cat <<EOF
Usage: ${SCRIPT_NAME} [CSV_FILE]

Stream Processing CSV Database Engine with Custom File Descriptors.

Arguments:
  CSV_FILE               Path to CSV database (default: servers.csv in script directory)

Options:
  --help, -h             Display this documentation and exit

Separating Structured Data from Diagnostics:
  ./${SCRIPT_NAME} > structured_payload.txt 2> operational.log

Exit Codes:
  0 : Processing completed successfully (regardless of individual record validation)
  1 : Missing/unreadable CSV file, empty file, or schema mismatch
EOF
}

if [[ $# -ge 1 && ( "$1" == "--help" || "$1" == "-h" ) ]]; then
    show_help
    exit 0
fi

# Locate default CSV in current directory or script directory
DEFAULT_CSV="servers.csv"
if [[ ! -f "$DEFAULT_CSV" && -f "${SCRIPT_DIR}/servers.csv" ]]; then
    DEFAULT_CSV="${SCRIPT_DIR}/servers.csv"
fi

CSV_FILE="${1:-$DEFAULT_CSV}"

# Counters
TOTAL=0
VALID=0
INVALID=0

# ------------------------------------------------------------------------------
# 3. STREAM & FILE DESCRIPTOR SETUP
# ------------------------------------------------------------------------------
# Duplicate stdout (FD 1) onto custom File Descriptor 3 for structured payload delivery
exec 3>&1

# Operational diagnostic loggers route strictly to stderr (FD 2)
log() {
    printf "${CYAN}[INFO]${RESET} %s\n" "$*" >&2
}

warn() {
    printf "${YELLOW}[WARN]${RESET} %s\n" "$*" >&2
}

error() {
    printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2
}

# ------------------------------------------------------------------------------
# 4. DATA SANITIZATION & SCHEMA VALIDATION HELPERS
# ------------------------------------------------------------------------------
# Pure Bash whitespace trimming (eliminates leading & trailing whitespace without subprocess fork)
trim() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

# Validate record schema and enum field constraints
validate_record() {
    local server="$1"
    local region="$2"
    local instance="$3"
    local environment="$4"
    local status="$5"

    # Mandatory field presence checks
    [[ -n "$server" ]] || return 1
    [[ -n "$region" ]] || return 1
    [[ -n "$instance" ]] || return 1

    # Environment enum validation
    case "$environment" in
        production|staging|development) ;;
        *) return 1 ;;
    esac

    # Status enum validation
    case "$status" in
        active|inactive) ;;
        *) return 1 ;;
    esac

    return 0
}

# ------------------------------------------------------------------------------
# 5. CSV FILE VERIFICATION & DESCRIPTOR BINDING
# ------------------------------------------------------------------------------
if [[ ! -f "$CSV_FILE" || ! -r "$CSV_FILE" ]]; then
    error "CSV database missing or unreadable at: ${CSV_FILE}"
    exec 3>&- # Close custom FD 3 before exiting
    exit 1
fi

# Open CSV file for read operations specifically on custom File Descriptor 4
exec 4< "$CSV_FILE"

# Ingest header line from FD 4
if ! IFS= read -r -u 4 header; then
    error "CSV file is completely empty."
    exec 4<&-
    exec 3>&-
    exit 1
fi

# Normalize and validate header against expected schema
header=$(trim "$header")
expected_header="server_name,region,instance_type,environment,status"

if [[ "$header" != "$expected_header" ]]; then
    error "Invalid CSV schema."
    error "Expected: ${expected_header}"
    error "Received: ${header}"
    exec 4<&-
    exec 3>&-
    exit 1
fi

log "CSV processing initiated for target: ${CSV_FILE}"

# ------------------------------------------------------------------------------
# 6. STREAM PROCESSING RECORD LOOP (Custom FD 4)
# ------------------------------------------------------------------------------
while IFS=, read -r -u 4 \
    server_name region instance_type environment status extra || \
    [[ -n "${server_name:-}${region:-}${instance_type:-}${environment:-}${status:-}${extra:-}" ]]
do
    # Skip empty lines
    if [[ -z "${server_name:-}${region:-}${instance_type:-}${environment:-}${status:-}${extra:-}" ]]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))

    # Sanitize whitespace on every column
    server_name=$(trim "${server_name:-}")
    region=$(trim "${region:-}")
    instance_type=$(trim "${instance_type:-}")
    environment=$(trim "${environment:-}")
    status=$(trim "${status:-}")
    extra=$(trim "${extra:-}")

    # Reject records with unexpected extraneous columns
    if [[ -n "$extra" ]]; then
        INVALID=$((INVALID + 1))
        warn "Record ${TOTAL}: Extraneous column detected. Discarding corrupted line."
        continue
    fi

    # Execute schema validation rules
    if ! validate_record \
        "$server_name" \
        "$region" \
        "$instance_type" \
        "$environment" \
        "$status"; then
        INVALID=$((INVALID + 1))
        warn "Record ${TOTAL}: Validation failed for entity '${server_name:-[UNNAMED]}'. Missing fields or illegal enum."
        continue
    fi

    VALID=$((VALID + 1))

    # Stream structured configuration payload directly to FD 3 (Saved stdout)
    printf '%s\n' "----------------------------------------" >&3
    printf 'SERVER_NAME=%s\n' "$server_name" >&3
    printf 'REGION=%s\n' "$region" >&3
    printf 'INSTANCE_TYPE=%s\n' "$instance_type" >&3
    printf 'ENVIRONMENT=%s\n' "$environment" >&3
    printf 'STATUS=%s\n' "$status" >&3

    log "Successfully validated and emitted payload: ${server_name} (${environment})"
done

# ------------------------------------------------------------------------------
# 7. DESCRIPTOR CLEANUP & SUMMARY REPORTING
# ------------------------------------------------------------------------------
# Close input descriptor FD 4
exec 4<&-

# Output operational summary to stderr (FD 2)
log "========================================"
log "        CSV PROCESSING SUMMARY          "
log "========================================"
log "Total Records Ingested : ${TOTAL}"
log "Valid Records Emitted  : ${VALID}"
log "Invalid Records Skipped: ${INVALID}"
log "========================================"

# Close saved stdout descriptor FD 3
exec 3>&-

exit 0
