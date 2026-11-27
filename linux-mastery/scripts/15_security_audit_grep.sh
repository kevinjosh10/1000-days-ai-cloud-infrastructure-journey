#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 15_security_audit_grep.sh
# TRACK    : Linux & Shell Scripting — Day 15/30 (Week 11 Kickoff)
# JOURNEY  : Day 271 / 1000
# PURPOSE  : Advanced grep, Regex & SSH Authentication Security Log Auditor
# USAGE    : ./15_security_audit_grep.sh [custom_auth_log]
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
# 2. RESOLVE LOG SOURCE & TEMPORARY STAGING
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="${0##*/}"

show_help() {
    cat << EOF
Usage: ${SCRIPT_NAME} [LOG_FILE]

Security Log Auditing Utility using Advanced grep and Regular Expressions.

Arguments:
  LOG_FILE               Path to authentication log file (optional)

If no LOG_FILE is specified, the script automatically searches for:
  1. Local sample_auth.log in script directory
  2. /var/log/auth.log (Debian/Ubuntu)
  3. /var/log/secure (RHEL/CentOS/Rocky/Alma)
  4. Systemd journal via journalctl

Exit Codes:
  0 : Audit completed with low or normal findings
  1 : Security warning: High volume of failed authentication events detected
  2 : Missing or unreadable authentication logs
EOF
}

if [[ $# -ge 1 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
    show_help
    exit 0
fi

# Create a secure temporary file for normalized log analysis
TEMP_LOG=$(mktemp)
cleanup() {
    rm -f "$TEMP_LOG"
}
trap cleanup EXIT

# Determine log source
INPUT_ARG="${1:-}"

if [[ -n "$INPUT_ARG" ]]; then
    if [[ -r "$INPUT_ARG" ]]; then
        cp "$INPUT_ARG" "$TEMP_LOG"
        LOG_SOURCE="$INPUT_ARG"
    else
        echo -e "${RED}[ERROR] Specified log file not readable: ${INPUT_ARG}${RESET}" >&2
        exit 2
    fi
elif [[ -r "${SCRIPT_DIR}/sample_auth.log" ]]; then
    cp "${SCRIPT_DIR}/sample_auth.log" "$TEMP_LOG"
    LOG_SOURCE="${SCRIPT_DIR}/sample_auth.log (Local Sample)"
elif [[ -r "sample_auth.log" ]]; then
    cp "sample_auth.log" "$TEMP_LOG"
    LOG_SOURCE="sample_auth.log (Current Directory)"
elif [[ -r "/var/log/auth.log" ]]; then
    cp "/var/log/auth.log" "$TEMP_LOG"
    LOG_SOURCE="/var/log/auth.log (System Log)"
elif [[ -r "/var/log/secure" ]]; then
    cp "/var/log/secure" "$TEMP_LOG"
    LOG_SOURCE="/var/log/secure (System Log)"
elif command -v journalctl &>/dev/null; then
    if journalctl -u ssh -u sshd --no-pager -o cat > "$TEMP_LOG" 2>/dev/null; then
        LOG_SOURCE="systemd journal (ssh/sshd)"
    else
        echo -e "${RED}[ERROR] journalctl present but cannot read ssh logs (check permissions).${RESET}" >&2
        exit 2
    fi
else
    echo -e "${RED}[ERROR] No readable authentication logs found on system.${RESET}" >&2
    echo "Provide a target log path: ./${SCRIPT_NAME} <path_to_auth.log>" >&2
    exit 2
fi

# ------------------------------------------------------------------------------
# 3. HEADER & AUDIT INITIATION
# ------------------------------------------------------------------------------
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}         SSH SECURITY LOG AUDITOR v1.0              ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
echo -e "Log Source : ${GREEN}${LOG_SOURCE}${RESET}"
echo -e "Analyzed At: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${CYAN}----------------------------------------------------${RESET}"

# ------------------------------------------------------------------------------
# 4. FAILED AUTHENTICATION DETECTION
# ------------------------------------------------------------------------------
echo
echo -e "${BOLD}${BLUE}========== FAILED AUTHENTICATION EVENTS ============${RESET}"

# Display matching lines with line numbers
grep -nE "Failed password|authentication failure" "$TEMP_LOG" || true

FAILED_COUNT=$(grep -cE "Failed password|authentication failure" "$TEMP_LOG" || true)

echo -e "----------------------------------------------------"
echo -e "Total Failed Authentication Events: ${BOLD}${RED}${FAILED_COUNT}${RESET}"

# ------------------------------------------------------------------------------
# 5. INVALID USER DETECTION
# ------------------------------------------------------------------------------
echo
echo -e "${BOLD}${BLUE}============== INVALID USER EVENTS =================${RESET}"

grep -nE "Invalid user" "$TEMP_LOG" || true

INVALID_COUNT=$(grep -cE "Invalid user" "$TEMP_LOG" || true)

echo -e "----------------------------------------------------"
echo -e "Total Invalid User Account Events : ${BOLD}${YELLOW}${INVALID_COUNT}${RESET}"

# ------------------------------------------------------------------------------
# 6. SOURCE IP EXTRACTION & FREQUENCY DISTRIBUTION
# ------------------------------------------------------------------------------
echo
echo -e "${BOLD}${BLUE}=========== ATTACKING SOURCE IP RANKING ============${RESET}"
printf "%-10s %-20s\n" "ATTEMPTS" "IP ADDRESS"
echo "----------------------------------------------------"

# Pipeline:
# 1. Filter lines with failed or invalid user events
# 2. Extract only IPv4 address strings using -oE
# 3. Sort identical IP addresses together
# 4. Count repetitions via uniq -c
# 5. Sort numerically in descending order
grep -E "Failed password|Invalid user|authentication failure" "$TEMP_LOG" | \
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
sort | \
uniq -c | \
sort -nr || true

# Count distinct unique attacking IPs
UNIQUE_IPS=$(grep -E "Failed password|Invalid user|authentication failure" "$TEMP_LOG" | \
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u | wc -l | tr -d ' ')

# ------------------------------------------------------------------------------
# 7. SUCCESSFUL AUTHENTICATIONS (BASELINE COMPARISON)
# ------------------------------------------------------------------------------
echo
echo -e "${BOLD}${BLUE}========== SUCCESSFUL AUTHENTICATIONS ==============${RESET}"

grep -nE "Accepted password|Accepted publickey" "$TEMP_LOG" || true

ACCEPTED_COUNT=$(grep -cE "Accepted password|Accepted publickey" "$TEMP_LOG" || true)

echo -e "----------------------------------------------------"
echo -e "Total Authorized Logins           : ${BOLD}${GREEN}${ACCEPTED_COUNT}${RESET}"

# ------------------------------------------------------------------------------
# 8. FINAL SECURITY AUDIT SUMMARY & THRESHOLD EVALUATION
# ------------------------------------------------------------------------------
echo
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}               SECURITY AUDIT SUMMARY               ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-32s : %d\n" "Total Failed Auth Events" "$FAILED_COUNT"
printf "%-32s : %d\n" "Total Invalid User Attempts" "$INVALID_COUNT"
printf "%-32s : %d\n" "Distinct Suspicious Source IPs" "$UNIQUE_IPS"
printf "%-32s : %d\n" "Total Authorized Logins" "$ACCEPTED_COUNT"
echo -e "${CYAN}----------------------------------------------------${RESET}"

# Alert threshold: >= 5 failed attempts warrants security alert
if (( FAILED_COUNT >= 5 )); then
    echo -e "${RED}${BOLD}[ALERT] HIGH THREAT DETECTED: ${FAILED_COUNT} failed attempts exceed threshold (>= 5).${RESET}"
    echo -e "${YELLOW}Recommendation: Review top offending IPs and update firewall / fail2ban rules.${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
    exit 1
else
    echo -e "${GREEN}${BOLD}[STATUS] NORMAL: Failed authentication count is within acceptable threshold (< 5).${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
    exit 0
fi
