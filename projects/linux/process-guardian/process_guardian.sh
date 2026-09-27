#!/bin/bash
# ==============================================================================
# Process Guardian - Automated Process Supervision & Recovery
# ==============================================================================

CONFIG_FILE="${1:-/etc/process-guardian/processes_to_guard.cfg}"
[ ! -f "$CONFIG_FILE" ] && CONFIG_FILE="$(dirname "$0")/processes_to_guard.cfg"

CHECK_INTERVAL=5
ALERT_THRESHOLD=3
ALERT_WINDOW=300 # 5 minutes (in seconds)

declare -A RESTART_HISTORY

log_msg() {
    local level="$1"
    local msg="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg"
    logger -t process-guardian "[$level] $msg"
}

shutdown_handler() {
    log_msg "INFO" "Received SIGTERM/SIGINT. Process Guardian shutting down gracefully..."
    exit 0
}

trap shutdown_handler SIGTERM SIGINT

log_msg "INFO" "Starting Process Guardian with configuration: $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
    log_msg "ERROR" "Configuration file '$CONFIG_FILE' not found!"
    exit 1
fi

check_and_recover() {
    local process_name="$1"
    local restart_method="$2"
    local restart_target="$3"

    if ! pgrep -x "$process_name" > /dev/null 2>&1; then
        local now
        now=$(date +%s)
        log_msg "WARNING" "Process '$process_name' is DOWN! Initiating recovery via $restart_method..."

        # Execute recovery action
        if [ "$restart_method" = "systemd" ]; then
            systemctl restart "$restart_target"
        elif [ "$restart_method" = "command" ]; then
            eval "$restart_target" &
        else
            log_msg "ERROR" "Unknown restart method '$restart_method' for '$process_name'"
            return
        fi

        log_msg "INFO" "Process '$process_name' recovery command triggered ($restart_target)."

        # Update sliding window restart history
        local history="${RESTART_HISTORY[$process_name]}"
        local updated_history="$now"
        local count=1

        for ts in $history; do
            if [ $((now - ts)) -le $ALERT_WINDOW ]; then
                updated_history="$updated_history $ts"
                count=$((count + 1))
            fi
        done

        RESTART_HISTORY["$process_name"]="$updated_history"

        # Check threshold
        if [ "$count" -ge "$ALERT_THRESHOLD" ]; then
            log_msg "CRITICAL" "ALERT: '$process_name' restarted $count times within 5 minutes ($ALERT_WINDOW seconds)!"
        fi
    fi
}

while true; do
    while IFS='|' read -r process_name restart_method restart_target || [ -n "$process_name" ]; do
        # Ignore comments and empty lines
        [[ "$process_name" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${process_name// }" ]] && continue

        # Trim spaces
        process_name="$(echo "$process_name" | xargs)"
        restart_method="$(echo "$restart_method" | xargs)"
        restart_target="$(echo "$restart_target" | xargs)"

        check_and_recover "$process_name" "$restart_method" "$restart_target"
    done < "$CONFIG_FILE"

    sleep "$CHECK_INTERVAL"
done
