#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 13_cli_arg_framework.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 13/30 (Week 10)
# JOURNEY  : Day 269 / 1000
# PURPOSE  : Enterprise CLI Argument Parsing Framework with getopts & Validation
# USAGE    : ./13_cli_arg_framework.sh [OPTIONS] ENVIRONMENT
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
# 2. DEFAULT STATE & CONFIGURATION
# ------------------------------------------------------------------------------
SCRIPT_NAME="${0##*/}"
VERBOSE=false
QUIET=false
CONFIG_FILE=""
PORT=8080
ENVIRONMENT=""

# ------------------------------------------------------------------------------
# 3. HELP & DOCUMENTATION MENU
# ------------------------------------------------------------------------------
usage() {
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}          ENTERPRISE CLOUD DEPLOYMENT CLI           ${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo
    echo -e "${BOLD}Usage:${RESET}"
    echo "  ${SCRIPT_NAME} [OPTIONS] ENVIRONMENT"
    echo
    echo -e "${BOLD}Options:${RESET}"
    echo "  -h            Display this comprehensive help documentation and exit"
    echo "  -v            Enable verbose diagnostic telemetry (mutually exclusive with -q)"
    echo "  -q            Quiet mode: suppress normal output (mutually exclusive with -v)"
    echo "  -f FILE       Path to application configuration file (must exist and be readable)"
    echo "  -p PORT       Network listen port number (valid range: 1 - 65535, default: 8080)"
    echo "  --help        Long option alternative for help documentation"
    echo
    echo -e "${BOLD}Positional Arguments:${RESET}"
    echo "  ENVIRONMENT   Deployment tier: dev | development | staging | production"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  ${SCRIPT_NAME} -h"
    echo "  ${SCRIPT_NAME} -v production"
    echo "  ${SCRIPT_NAME} -q -p 9000 staging"
    echo "  ${SCRIPT_NAME} -f app.conf -p 8443 dev"
    echo "  ${SCRIPT_NAME} -v -f prod.conf -p 443 production"
    echo
    echo -e "${BOLD}Exit Codes:${RESET}"
    echo "  0 : Success / Clean execution (or help displayed)"
    echo "  1 : CLI option parsing failure, invalid argument, or validation error"
    echo
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
}

# ------------------------------------------------------------------------------
# 4. LOGGING HELPERS
# ------------------------------------------------------------------------------
log_info() {
    if [[ "$VERBOSE" == true && "$QUIET" == false ]]; then
        echo -e "${CYAN}[INFO]${RESET} $*"
    fi
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $*" >&2
}

# ------------------------------------------------------------------------------
# 5. PRE-PARSING SCAN (Long Option Support for --help)
# ------------------------------------------------------------------------------
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    fi
done

# ------------------------------------------------------------------------------
# 6. CLI OPTION PARSING VIA GETOPTS
# ------------------------------------------------------------------------------
# Leading colon enables silent error handling mode
while getopts ":hvf:p:q" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        q)
            QUIET=true
            ;;
        f)
            CONFIG_FILE="$OPTARG"
            ;;
        p)
            PORT="$OPTARG"
            ;;
        :)
            log_error "Option -${OPTARG} requires a non-empty argument."
            usage >&2
            exit 1
            ;;
        \?)
            log_error "Unrecognized option: -${OPTARG}"
            usage >&2
            exit 1
            ;;
    esac
done

# ------------------------------------------------------------------------------
# 7. REMOVE PARSED OPTIONS FROM POSITIONAL PARAMETERS
# ------------------------------------------------------------------------------
shift $((OPTIND - 1))

# ------------------------------------------------------------------------------
# 8. POSITIONAL ARGUMENT INGESTION
# ------------------------------------------------------------------------------
if [[ $# -ne 1 ]]; then
    log_error "Exactly one target ENVIRONMENT argument is required (received: $#)."
    usage >&2
    exit 1
fi

ENVIRONMENT="$1"

# ------------------------------------------------------------------------------
# 9. DEFENSIVE INPUT VALIDATION & MUTEX GUARDS
# ------------------------------------------------------------------------------
# Mutex Guard: Verbose (-v) and Quiet (-q) cannot be simultaneously enabled
if [[ "$VERBOSE" == true && "$QUIET" == true ]]; then
    log_error "Conflicting options: -v (verbose) and -q (quiet) are mutually exclusive."
    exit 1
fi

# Port Numeric Validation
if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
    log_error "Port must be a positive integer. Received: '$PORT'"
    exit 1
fi

# Port Range Validation (1 - 65535)
if (( PORT < 1 || PORT > 65535 )); then
    log_error "Port '$PORT' is outside the allowable TCP/UDP boundary (1 - 65535)."
    exit 1
fi

# Environment Whitelist Validation
case "$ENVIRONMENT" in
    dev|development|staging|production)
        ;;
    *)
        log_error "Invalid target environment '$ENVIRONMENT'. Allowed: dev | development | staging | production."
        exit 1
        ;;
esac

# Configuration File Existence & Readability Validation
if [[ -n "$CONFIG_FILE" ]]; then
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "Specified configuration file does not exist: '$CONFIG_FILE'"
        exit 1
    fi
    if [[ ! -r "$CONFIG_FILE" ]]; then
        log_error "Specified configuration file is not readable (check permissions): '$CONFIG_FILE'"
        exit 1
    fi
fi

# ------------------------------------------------------------------------------
# 10. EXECUTION ORCHESTRATION & SUMMARY
# ------------------------------------------------------------------------------
log_info "Initiating cloud deployment orchestrator"
log_info "Input validation checks passed successfully"

if [[ "$QUIET" == false ]]; then
    echo
    echo -e "${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}            DEPLOYMENT PLAN CONFIRMED               ${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
    printf "%-22s : %b\n" "Target Environment" "${GREEN}${BOLD}${ENVIRONMENT}${RESET}"
    printf "%-22s : %d\n" "Application Port" "$PORT"
    printf "%-22s : %s\n" "Configuration Path" "${CONFIG_FILE:-Default (Internal Builtin)}"
    printf "%-22s : %s\n" "Verbose Telemetry" "$VERBOSE"
    printf "%-22s : %s\n" "Quiet Suppression" "$QUIET"
    echo -e "${CYAN}====================================================${RESET}"
    echo
    echo -e "${GREEN}${BOLD}CLI argument framework executed and validated successfully.${RESET}"
fi

log_info "Deployment pipeline ready to dispatch payloads to ${ENVIRONMENT}"

exit 0
