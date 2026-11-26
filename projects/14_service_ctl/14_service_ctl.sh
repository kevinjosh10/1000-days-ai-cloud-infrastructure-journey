#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 14_service_ctl.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 14/30 (Week 10 Capstone)
# JOURNEY  : Day 270 / 1000
# PURPOSE  : Enterprise Microservice Process Lifecycle Controller & Health Auditor
# USAGE    : ./14_service_ctl.sh <COMMAND> [OPTIONS]
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
SERVICE_NAME="auth-service"
ENVIRONMENT="dev"
PORT=8001
TIMEOUT=10
VERBOSE=false

# Resolve state storage directory
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/service-ctl"

# Detect functional Python interpreter
if python3 --version &>/dev/null; then
    PYTHON_BIN="python3"
elif python --version &>/dev/null; then
    PYTHON_BIN="python"
elif command -v python3 &>/dev/null; then
    PYTHON_BIN="python3"
elif command -v python &>/dev/null; then
    PYTHON_BIN="python"
else
    PYTHON_BIN=""
fi

# ------------------------------------------------------------------------------
# 3. LOGGING FUNCTIONS
# ------------------------------------------------------------------------------
log() {
    echo -e "${CYAN}[INFO]${RESET} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[DEBUG]${RESET} $(date '+%Y-%m-%d %H:%M:%S') - $*"
    fi
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

error() {
    echo -e "${RED}[ERROR]${RESET} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# ------------------------------------------------------------------------------
# 4. HELP & USAGE DOCUMENTATION
# ------------------------------------------------------------------------------
usage() {
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}       MICROSERVICE PROCESS CONTROLLER v1.0         ${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo
    echo -e "${BOLD}Usage:${RESET}"
    echo "  ${SCRIPT_NAME} <COMMAND> [OPTIONS]"
    echo
    echo -e "${BOLD}Primary Commands:${RESET}"
    echo "  start       Start the background service daemon"
    echo "  stop        Gracefully terminate the running service (SIGTERM)"
    echo "  restart     Stop and restart the service"
    echo "  status      Verify if the service process is currently active"
    echo "  health      Perform an HTTP endpoint health check (HTTP probe)"
    echo
    echo -e "${BOLD}Options:${RESET}"
    echo "  -e ENV      Deployment environment: dev | staging | prod (default: dev)"
    echo "  -p PORT     Network listening port: 1 - 65535 (default: 8001)"
    echo "  -t SECONDS  Graceful shutdown / probe timeout: >= 1 (default: 10)"
    echo "  -v          Enable verbose debug telemetry"
    echo "  -h, --help  Display this documentation and exit"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  ${SCRIPT_NAME} start -e dev -p 8001 -v"
    echo "  ${SCRIPT_NAME} status -p 8001"
    echo "  ${SCRIPT_NAME} health -p 8001 -t 5"
    echo "  ${SCRIPT_NAME} restart -e staging -p 8001 -t 15"
    echo "  ${SCRIPT_NAME} stop -p 8001"
    echo
    echo -e "${BOLD}Exit Codes:${RESET}"
    echo "  0 : Success / Service operational / Command completed"
    echo "  1 : Operational failure / Unhealthy service / Process not running"
    echo "  2 : Invalid CLI arguments or syntax error"
    echo
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
}

# ------------------------------------------------------------------------------
# 5. PRE-PARSING & COMMAND EXTRACTION
# ------------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    error "Missing required command."
    usage >&2
    exit 2
fi

# Pre-scan for help
for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
        usage
        exit 0
    fi
done

COMMAND="$1"
shift

# Validate primary command
case "$COMMAND" in
    start|stop|restart|status|health)
        ;;
    *)
        error "Unknown command: '$COMMAND'"
        usage >&2
        exit 2
        ;;
esac

# ------------------------------------------------------------------------------
# 6. OPTION PARSING VIA GETOPTS
# ------------------------------------------------------------------------------
while getopts ":e:p:t:vh" opt; do
    case "$opt" in
        e)
            ENVIRONMENT="$OPTARG"
            ;;
        p)
            PORT="$OPTARG"
            ;;
        t)
            TIMEOUT="$OPTARG"
            ;;
        v)
            VERBOSE=true
            ;;
        h)
            usage
            exit 0
            ;;
        :)
            error "Option -${OPTARG} requires a valid argument."
            exit 2
            ;;
        \?)
            error "Unrecognized option: -${OPTARG}"
            exit 2
            ;;
    esac
done

shift $((OPTIND - 1))

# Reject any unexpected leftover positional parameters
if [[ $# -gt 0 ]]; then
    error "Unexpected trailing arguments: $*"
    usage >&2
    exit 2
fi

# ------------------------------------------------------------------------------
# 7. DEFENSIVE INPUT VALIDATION
# ------------------------------------------------------------------------------
# Normalize environment
ENVIRONMENT="${ENVIRONMENT,,}"
case "$ENVIRONMENT" in
    dev|staging|prod)
        ;;
    *)
        error "Invalid environment '$ENVIRONMENT'. Allowed values: dev | staging | prod"
        exit 2
        ;;
esac

# Validate port
if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
    error "Port must be an integer. Received: '$PORT'"
    exit 2
fi

if (( PORT < 1 || PORT > 65535 )); then
    error "Port '$PORT' is out of range (1 - 65535)."
    exit 2
fi

# Validate timeout
if [[ ! "$TIMEOUT" =~ ^[0-9]+$ ]] || (( TIMEOUT < 1 )); then
    error "Timeout must be a positive integer >= 1. Received: '$TIMEOUT'"
    exit 2
fi

# ------------------------------------------------------------------------------
# 8. STATE DIRECTORY & FILE TARGETS
# ------------------------------------------------------------------------------
mkdir -p "$STATE_DIR"
PID_FILE="$STATE_DIR/${SERVICE_NAME}-${ENVIRONMENT}-${PORT}.pid"
LOG_FILE="$STATE_DIR/${SERVICE_NAME}-${ENVIRONMENT}-${PORT}.log"

debug "Configuration established:"
debug "  Command      : $COMMAND"
debug "  Service      : $SERVICE_NAME"
debug "  Environment  : $ENVIRONMENT"
debug "  Port         : $PORT"
debug "  Timeout      : ${TIMEOUT}s"
debug "  State Dir    : $STATE_DIR"
debug "  PID File     : $PID_FILE"
debug "  Log File     : $LOG_FILE"

# ------------------------------------------------------------------------------
# 9. SERVICE LIFECYCLE MANAGEMENT FUNCTIONS
# ------------------------------------------------------------------------------

# Start the background microservice
start_service() {
    # Check if a PID file already exists
    if [[ -f "$PID_FILE" ]]; then
        local existing_pid
        existing_pid=$(<"$PID_FILE")

        if [[ "$existing_pid" =~ ^[0-9]+$ ]] && kill -0 "$existing_pid" 2>/dev/null; then
            error "Service is already running with PID ${existing_pid} on port ${PORT}."
            return 1
        fi

        warn "Removing stale PID file: $PID_FILE (Previous PID: ${existing_pid:-unknown})"
        rm -f "$PID_FILE"
    fi

    # Verify Python runtime availability
    if [[ -z "$PYTHON_BIN" ]]; then
        error "Python runtime (python3 or python) not found in PATH."
        return 1
    fi

    log "Starting ${SERVICE_NAME} on port ${PORT} (${ENVIRONMENT})..."
    debug "Executing command: nohup $PYTHON_BIN -m http.server $PORT --bind 127.0.0.1 > '$LOG_FILE' 2>&1 &"

    # Launch service in background, decoupled from terminal
    nohup "$PYTHON_BIN" -m http.server "$PORT" --bind 127.0.0.1 > "$LOG_FILE" 2>&1 &
    local service_pid=$!

    echo "$service_pid" > "$PID_FILE"
    debug "Saved PID $service_pid to $PID_FILE"

    # Allow 1 second for initialization and probe viability
    sleep 1

    if kill -0 "$service_pid" 2>/dev/null; then
        echo -e "${GREEN}${BOLD}[SUCCESS] ${SERVICE_NAME} started successfully with PID ${service_pid}.${RESET}"
        log "Listening on http://127.0.0.1:${PORT}/ (Log: ${LOG_FILE})"
        return 0
    else
        error "Service process terminated immediately after start."
        if [[ -s "$LOG_FILE" ]]; then
            error "Last log output:"
            tail -n 5 "$LOG_FILE" >&2
        fi
        rm -f "$PID_FILE"
        return 1
    fi
}

# Gracefully terminate the service process
stop_service() {
    if [[ ! -f "$PID_FILE" ]]; then
        warn "PID file not found at: ${PID_FILE}"
        echo -e "${YELLOW}[STOPPED] Service is not running.${RESET}"
        return 0
    fi

    local service_pid
    service_pid=$(<"$PID_FILE")

    if [[ ! "$service_pid" =~ ^[0-9]+$ ]]; then
        error "Invalid or corrupted PID file content: '${service_pid}'"
        rm -f "$PID_FILE"
        return 1
    fi

    # Check if process is actually running
    if ! kill -0 "$service_pid" 2>/dev/null; then
        warn "Stale PID file detected. Process ${service_pid} is no longer running."
        rm -f "$PID_FILE"
        echo -e "${YELLOW}[STOPPED] Service is not running.${RESET}"
        return 0
    fi

    log "Sending SIGTERM to process PID ${service_pid}..."
    kill -15 "$service_pid" 2>/dev/null || true

    # Poll for graceful shutdown up to TIMEOUT seconds
    local elapsed=0
    while (( elapsed < TIMEOUT )); do
        if ! kill -0 "$service_pid" 2>/dev/null; then
            rm -f "$PID_FILE"
            echo -e "${GREEN}${BOLD}[SUCCESS] Service PID ${service_pid} stopped gracefully after ${elapsed}s.${RESET}"
            return 0
        fi
        debug "Waiting for PID ${service_pid} to shut down (${elapsed}/${TIMEOUT}s)..."
        sleep 1
        ((elapsed += 1))
    done

    # Timeout reached: Escalate or report failure
    warn "Graceful shutdown timed out after ${TIMEOUT}s. Service still responsive."
    echo -e "${RED}[ERROR] Process ${service_pid} did not terminate within ${TIMEOUT} seconds.${RESET}" >&2
    return 1
}

# Restart the service (Graceful Stop followed by Start)
restart_service() {
    log "Initiating service restart sequence..."
    stop_service || {
        error "Failed to stop running service cleanly. Aborting restart."
        return 1
    }
    sleep 1
    start_service
}

# Report running state of the service
status_service() {
    if [[ ! -f "$PID_FILE" ]]; then
        echo -e "${YELLOW}[STOPPED] Service is not running (No PID file).${RESET}"
        return 1
    fi

    local service_pid
    service_pid=$(<"$PID_FILE")

    if [[ "$service_pid" =~ ^[0-9]+$ ]] && kill -0 "$service_pid" 2>/dev/null; then
        echo -e "${GREEN}${BOLD}[RUNNING]${RESET} ${SERVICE_NAME} active | PID: ${service_pid} | Port: ${PORT} | Env: ${ENVIRONMENT}"
        return 0
    else
        echo -e "${RED}[STOPPED] Stale PID file detected (${service_pid} not alive).${RESET}"
        rm -f "$PID_FILE"
        return 1
    fi
}

# Perform HTTP application health check probe
health_check() {
    # Check if process is running first
    if [[ ! -f "$PID_FILE" ]]; then
        echo -e "${RED}[UNHEALTHY] Process is not running (PID file missing).${RESET}" >&2
        return 1
    fi

    local service_pid
    service_pid=$(<"$PID_FILE")
    if ! kill -0 "$service_pid" 2>/dev/null; then
        echo -e "${RED}[UNHEALTHY] Process PID ${service_pid} is dead.${RESET}" >&2
        rm -f "$PID_FILE"
        return 1
    fi

    local endpoint="http://127.0.0.1:${PORT}/"
    log "Probing service health endpoint: ${endpoint} (Timeout: ${TIMEOUT}s)..."

    # Probe HTTP endpoint
    if curl -fsS --connect-timeout 2 --max-time "$TIMEOUT" "$endpoint" -o /dev/null 2>/dev/null; then
        echo -e "${GREEN}${BOLD}[HEALTHY] Service on port ${PORT} responded with HTTP 200 OK.${RESET}"
        return 0
    else
        echo -e "${RED}${BOLD}[UNHEALTHY] Service on port ${PORT} failed health check (Connection refused or timed out).${RESET}" >&2
        return 1
    fi
}

# ------------------------------------------------------------------------------
# 10. COMMAND DISPATCHER
# ------------------------------------------------------------------------------
case "$COMMAND" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    restart)
        restart_service
        ;;
    status)
        status_service
        ;;
    health)
        health_check
        ;;
esac
