#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 16_config_sanitizer.sh
# TRACK    : Linux & Shell Scripting — Day 16/30 (Week 11)
# JOURNEY  : Day 272 / 1000
# PURPOSE  : Stream Editor (sed) Automated Configuration File Sanitizer
# USAGE    : ./16_config_sanitizer.sh <config-file>
# ==============================================================================

# Defensive strict mode
set -Eeuo pipefail

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
# 2. USAGE & HELP DOCUMENTATION
# ------------------------------------------------------------------------------
usage() {
    cat << EOF
Usage: ${0##*/} [OPTIONS] <config-file>

Automated Configuration Sanitizer using Linux Stream Editor (sed).

Options:
  -h, --help       Display this help message and exit

Transformations Performed:
  1. Creates automatic backup copy (<config-file>.bak)
  2. Removes all full-line and indented comments (/^[[:space:]]*#/d)
  3. Strips blank and whitespace-only lines (/^[[:space:]]*$/d)
  4. Updates APP_PORT from 3000 to 8080 (s/^APP_PORT=.*/APP_PORT=8080/)
  5. Updates APP_ENV from development to production (s/^APP_ENV=.*/APP_ENV=production/)
  6. Normalizes HTTP endpoint URLs to HTTPS using custom delimiters (s#http://#https://#g)
  7. Trims any trailing whitespace from configuration keys

Exit Codes:
  0 : Sanitization completed successfully
  1 : Invalid arguments, missing file, or processing failure
EOF
}

# ------------------------------------------------------------------------------
# 3. ARGUMENT VALIDATION & FILE CHECKS
# ------------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

if [[ $# -ne 1 ]]; then
    echo -e "${RED}[ERROR] Expected exactly 1 argument, but received $#${RESET}" >&2
    usage
    exit 1
fi

CONFIG_FILE="$1"

if [[ ! -e "$CONFIG_FILE" ]]; then
    echo -e "${RED}[ERROR] Target configuration file does not exist: ${CONFIG_FILE}${RESET}" >&2
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}[ERROR] Target path is not a regular file: ${CONFIG_FILE}${RESET}" >&2
    exit 1
fi

if [[ ! -r "$CONFIG_FILE" || ! -w "$CONFIG_FILE" ]]; then
    echo -e "${RED}[ERROR] Insufficient read/write permissions for file: ${CONFIG_FILE}${RESET}" >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 4. BACKUP CREATION
# ------------------------------------------------------------------------------
BACKUP_FILE="${CONFIG_FILE}.bak"

if ! cp -- "$CONFIG_FILE" "$BACKUP_FILE"; then
    echo -e "${RED}[ERROR] Failed to create backup file at ${BACKUP_FILE}${RESET}" >&2
    exit 1
fi

echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}      CONFIG FILE SANITIZER (SED AUTOMATION)        ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
echo -e "${BLUE}[INFO]${RESET} Target file    : ${BOLD}${CONFIG_FILE}${RESET}"
echo -e "${BLUE}[INFO]${RESET} Backup created : ${GREEN}${BACKUP_FILE}${RESET}"

# Count initial lines
ORIGINAL_LINES=$(wc -l < "$CONFIG_FILE" | tr -d ' ')

# ------------------------------------------------------------------------------
# 5. STREAM TRANSFORMATION VIA SED
# ------------------------------------------------------------------------------
# Detect GNU sed vs BSD / macOS sed for portable in-place modification
SED_OPTS=(-i)
if ! sed --version >/dev/null 2>&1; then
    # BSD / macOS sed requires an argument to -i (empty string for no backup extension)
    SED_OPTS=(-i '')
fi

sed "${SED_OPTS[@]}" \
    -e '/^[[:space:]]*#/d' \
    -e '/^[[:space:]]*$/d' \
    -e 's/[[:space:]]\+$//' \
    -e 's/^APP_PORT=.*/APP_PORT=8080/' \
    -e 's/^APP_ENV=.*/APP_ENV=production/' \
    -e 's#http://#https://#g' \
    "$CONFIG_FILE"

# Count final lines
FINAL_LINES=$(wc -l < "$CONFIG_FILE" | tr -d ' ')
REMOVED_LINES=$(( ORIGINAL_LINES - FINAL_LINES ))

# ------------------------------------------------------------------------------
# 6. SANITIZATION AUDIT REPORT
# ------------------------------------------------------------------------------
echo
echo -e "${BOLD}${CYAN}========== SANITIZATION REPORT ==========${RESET}"
printf "%-18s : %s\n" "File" "$CONFIG_FILE"
printf "%-18s : %s\n" "Backup" "$BACKUP_FILE"
printf "%-18s : %d\n" "Original Lines" "$ORIGINAL_LINES"
printf "%-18s : %d\n" "Final Lines" "$FINAL_LINES"
printf "%-18s : %d\n" "Removed Lines" "$REMOVED_LINES"
printf "%-18s : %b\n" "Status" "${GREEN}${BOLD}SUCCESS${RESET}"
echo -e "${BOLD}${CYAN}=========================================${RESET}"

echo
echo -e "${BOLD}${BLUE}Sanitized Configuration Preview:${RESET}"
echo -e "${CYAN}-----------------------------------------${RESET}"
cat "$CONFIG_FILE"
echo -e "${CYAN}-----------------------------------------${RESET}"
