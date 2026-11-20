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
