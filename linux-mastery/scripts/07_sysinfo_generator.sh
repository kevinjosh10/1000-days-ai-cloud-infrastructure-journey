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
