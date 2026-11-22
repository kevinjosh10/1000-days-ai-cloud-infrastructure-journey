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
