#!/usr/bin/env bash
# ==============================================================================
# sysmon.sh - Production System Monitor & Performance Profiler
# ------------------------------------------------------------------------------
# 1000-Days AI Cloud Infrastructure Journey | Day 226 / 1000
# Track: Linux Mastery | Day 30 / 30 Capstone Project
#
# Description:
#   Collects, measures, evaluates, and classifies Linux system health metrics
#   including CPU, memory, disk I/O, network sockets, process states, and
#   systemd journal errors. Supports interactive terminal output with
#   color-coded thresholds and structured JSON export for cloud automation.
#
# Usage:
#   ./sysmon.sh [OPTIONS]
#   ./sysmon.sh --json
#   ./sysmon.sh --config /path/to/sysmon.conf
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Default Configuration & Thresholds
# ------------------------------------------------------------------------------
CPU_WARN=70
CPU_CRIT=90

MEM_WARN=80
MEM_CRIT=95

DISK_WARN=80
DISK_CRIT=90

TOP_PROCESS_COUNT=3
JOURNAL_LOG_LINES=5
OUTPUT_FORMAT="text"
ENABLE_COLORS=true
CONFIG_FILE=""

# ------------------------------------------------------------------------------
# Color Definitions (ANSI)
# ------------------------------------------------------------------------------
setup_colors() {
    if [[ "$ENABLE_COLORS" == "true" ]] && [[ -t 1 || "${FORCE_COLORS:-false}" == "true" ]]; then
        C_RESET="\033[0m"
        C_BOLD="\033[1m"
        C_DIM="\033[2m"
        C_GREEN="\033[1;32m"
        C_YELLOW="\033[1;33m"
        C_RED="\033[1;31m"
        C_BLUE="\033[1;34m"
        C_CYAN="\033[1;36m"
        C_WHITE="\033[1;37m"
        C_BG_BLUE="\033[44;37m"
    else
        C_RESET=""
        C_BOLD=""
        C_DIM=""
        C_GREEN=""
        C_YELLOW=""
        C_RED=""
        C_BLUE=""
        C_CYAN=""
        C_WHITE=""
        C_BG_BLUE=""
    fi
}

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Production Linux System Monitoring Suite (sysmon.sh)

Options:
  -c, --config PATH     Path to custom configuration file (default: ./sysmon.conf)
  -j, --json            Output system metrics as structured JSON
  -t, --text            Output human-readable terminal dashboard (default)
      --no-color        Disable ANSI color output
  -h, --help            Display this help message and exit

Thresholds (Configurable via sysmon.conf):
  CPU Warning/Critical:   ${CPU_WARN}% / ${CPU_CRIT}%
  Memory Warning/Critical:${MEM_WARN}% / ${MEM_CRIT}%
  Disk Warning/Critical:  ${DISK_WARN}% / ${DISK_CRIT}%
EOF
    exit 0
}

load_config() {
    local candidate_configs=(
        "$CONFIG_FILE"
        "./sysmon.conf"
        "/etc/sysmon/sysmon.conf"
        "/etc/sysmon.conf"
    )

    for cfg in "${candidate_configs[@]}"; do
        if [[ -n "$cfg" && -f "$cfg" && -r "$cfg" ]]; then
            # Source safe configuration variables
            # shellcheck disable=SC1090
            source "$cfg"
            break
        fi
    done
}

format_duration() {
    local seconds="$1"
    local days=$(( seconds / 86400 ))
    local hours=$(( (seconds % 86400) / 3600 ))
    local minutes=$(( (seconds % 3600) / 60 ))
    local secs=$(( seconds % 60 ))

    if (( days > 0 )); then
        printf "%dd %02dh %02dm" "$days" "$hours" "$minutes"
    elif (( hours > 0 )); then
        printf "%02dh %02dm %02ds" "$hours" "$minutes" "$secs"
    else
        printf "%02dm %02ds" "$minutes" "$secs"
    fi
}

classify_metric() {
    local val="$1"
    local warn="$2"
    local crit="$3"

    # Compare numeric floats or integers
    local is_crit
    local is_warn
    is_crit=$(awk -v v="$val" -v c="$crit" 'BEGIN {print (v >= c) ? 1 : 0}')
    is_warn=$(awk -v v="$val" -v w="$warn" 'BEGIN {print (v >= w) ? 1 : 0}')

    if [[ "$is_crit" -eq 1 ]]; then
        echo "CRITICAL"
    elif [[ "$is_warn" -eq 1 ]]; then
        echo "WARNING"
    else
        echo "NORMAL"
    fi
}

get_status_badge() {
    local status="$1"
    case "$status" in
        "NORMAL")   echo -e "${C_GREEN}[ NORMAL ]${C_RESET}" ;;
        "WARNING")  echo -e "${C_YELLOW}[ WARNING ]${C_RESET}" ;;
        "CRITICAL") echo -e "${C_RED}[ CRITICAL ]${C_RESET}" ;;
        *)          echo -e "${C_DIM}[ UNKNOWN ]${C_RESET}" ;;
    esac
}

# ------------------------------------------------------------------------------
# Parse Command Line Options
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        -j|--json)
            OUTPUT_FORMAT="json"
            shift
            ;;
        -t|--text)
            OUTPUT_FORMAT="text"
            shift
            ;;
        --no-color)
            ENABLE_COLORS=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown argument: $1" >&2
            usage
            ;;
    esac
done

load_config
setup_colors

# ------------------------------------------------------------------------------
# Metric Collection Engine
# ------------------------------------------------------------------------------
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')
HOSTNAME=$(hostname 2>/dev/null || uname -n)
KERNEL=$(uname -r)
UPTIME_STR=$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {h=$6;m=$7}} {print "up "h" hours, "m" min"}')

# --- CPU Collection ---
NUM_CPUS=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo || echo 1)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
LOAD_1M=$(echo "$LOAD_AVG" | awk -F',' '{print $1}' | tr -d ' ')
LOAD_5M=$(echo "$LOAD_AVG" | awk -F',' '{print $2}' | tr -d ' ')
LOAD_15M=$(echo "$LOAD_AVG" | awk -F',' '{print $3}' | tr -d ' ')

# Measure CPU Utilization (%)
TOTAL_CPU_UTIL=0
PER_CORE_METRICS=()
if command -v mpstat &>/dev/null; then
    MPSTAT_OUT=$(mpstat -P ALL 1 1 2>/dev/null || true)
    # Parse overall idle CPU from "all" line
    TOTAL_IDLE=$(echo "$MPSTAT_OUT" | awk '$3 ~ /all/ || $2 ~ /all/ {print $NF}' | tail -n 1)
    if [[ -n "$TOTAL_IDLE" ]]; then
        TOTAL_CPU_UTIL=$(awk -v idle="$TOTAL_IDLE" 'BEGIN {printf "%.1f", 100 - idle}')
    fi

    # Parse per-core usage
    while IFS= read -r line; do
        core_id=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+$/ && $(i+1) ~ /^[0-9]/) {print $i; break}}')
        core_idle=$(echo "$line" | awk '{print $NF}')
        if [[ -n "$core_id" && -n "$core_idle" ]]; then
            core_util=$(awk -v idle="$core_idle" 'BEGIN {printf "%.1f", 100 - idle}')
            PER_CORE_METRICS+=("Core ${core_id}: ${core_util}%")
        fi
    done < <(echo "$MPSTAT_OUT" | awk '($2 ~ /^[0-9]+$/ || $3 ~ /^[0-9]+$/) && $NF ~ /^[0-9.]+/ {print}')
else
    # Fallback using top
    TOTAL_CPU_UTIL=$(top -bn1 | grep -i "Cpu(s)" | awk -F',' '{print $4}' | awk '{printf "%.1f", 100 - $1}' 2>/dev/null || echo "0.0")
    PER_CORE_METRICS+=("mpstat not installed (sysstat package recommended)")
fi

CPU_STATUS=$(classify_metric "$TOTAL_CPU_UTIL" "$CPU_WARN" "$CPU_CRIT")

# Top CPU Processes
TOP_CPU_PROCS=$(ps -eo pid,user,comm,%cpu --sort=-%cpu --no-headers | head -n "$TOP_PROCESS_COUNT")

# --- Memory Collection ---
MEM_TOTAL_MB=0
MEM_AVAIL_MB=0
MEM_USED_MB=0
MEM_UTIL_PCT=0
SWAP_TOTAL_MB=0
SWAP_USED_MB=0
SWAP_UTIL_PCT=0

if [[ -f /proc/meminfo ]]; then
    MEM_TOTAL_KB=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    MEM_AVAIL_KB=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
    SWAP_TOTAL_KB=$(awk '/SwapTotal:/ {print $2}' /proc/meminfo)
    SWAP_FREE_KB=$(awk '/SwapFree:/ {print $2}' /proc/meminfo)

    MEM_TOTAL_MB=$(( MEM_TOTAL_KB / 1024 ))
    MEM_AVAIL_MB=$(( MEM_AVAIL_KB / 1024 ))
    MEM_USED_MB=$(( MEM_TOTAL_MB - MEM_AVAIL_MB ))
    if (( MEM_TOTAL_MB > 0 )); then
        MEM_UTIL_PCT=$(awk -v used="$MEM_USED_MB" -v tot="$MEM_TOTAL_MB" 'BEGIN {printf "%.1f", (used / tot) * 100}')
    fi

    SWAP_TOTAL_MB=$(( SWAP_TOTAL_KB / 1024 ))
    SWAP_USED_MB=$(( (SWAP_TOTAL_KB - SWAP_FREE_KB) / 1024 ))
    if (( SWAP_TOTAL_MB > 0 )); then
        SWAP_UTIL_PCT=$(awk -v used="$SWAP_USED_MB" -v tot="$SWAP_TOTAL_MB" 'BEGIN {printf "%.1f", (used / tot) * 100}')
    fi
else
    # Fallback using free
    MEM_TOTAL_MB=$(free -m | awk '/Mem:/ {print $2}')
    MEM_AVAIL_MB=$(free -m | awk '/Mem:/ {print $7}')
    MEM_USED_MB=$(( MEM_TOTAL_MB - MEM_AVAIL_MB ))
    MEM_UTIL_PCT=$(awk -v used="$MEM_USED_MB" -v tot="$MEM_TOTAL_MB" 'BEGIN {printf "%.1f", (used / tot) * 100}')
fi

MEM_STATUS=$(classify_metric "$MEM_UTIL_PCT" "$MEM_WARN" "$MEM_CRIT")

# Top Memory Processes
TOP_MEM_PROCS=$(ps -eo pid,user,comm,%mem,rss --sort=-%mem --no-headers | head -n "$TOP_PROCESS_COUNT")

# --- Disk Capacity & I/O Collection ---
MAX_DISK_PCT=0
DISK_DETAILS=()
while IFS= read -r fs_line; do
    fs_dev=$(echo "$fs_line" | awk '{print $1}')
    fs_total=$(echo "$fs_line" | awk '{print $2}')
    fs_used=$(echo "$fs_line" | awk '{print $3}')
    fs_avail=$(echo "$fs_line" | awk '{print $4}')
    fs_pct_str=$(echo "$fs_line" | awk '{print $5}' | tr -d '%')
    fs_mount=$(echo "$fs_line" | awk '{print $6}')

    if [[ "$fs_pct_str" =~ ^[0-9]+$ ]]; then
        if (( fs_pct_str > MAX_DISK_PCT )); then
            MAX_DISK_PCT=$fs_pct_str
        fi
        fs_stat=$(classify_metric "$fs_pct_str" "$DISK_WARN" "$DISK_CRIT")
        DISK_DETAILS+=("${fs_mount}|${fs_dev}|${fs_total}|${fs_used}|${fs_avail}|${fs_pct_str}%|${fs_stat}")
    fi
done < <(df -Ph -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null | tail -n +2 || df -Ph 2>/dev/null | tail -n +2)

DISK_STATUS=$(classify_metric "$MAX_DISK_PCT" "$DISK_WARN" "$DISK_CRIT")

# Disk I/O Statistics
DISK_READ_KB="0.0"
DISK_WRITE_KB="0.0"
DISK_IO_TPS="0.0"
DISK_IO_UTIL="0.0"
DISK_IO_AVAILABLE=false

if command -v iostat &>/dev/null; then
    # Sample 2 iterations of 1s to obtain real-time activity rates
    IOSTAT_RAW=$(iostat -dx 1 2 2>/dev/null | awk '/Device/ {i++} i==2' || true)
    if [[ -n "$IOSTAT_RAW" ]]; then
        DISK_IO_AVAILABLE=true
        # Aggregate across active block devices (ignore loop devices)
        IO_STATS=$(echo "$IOSTAT_RAW" | grep -v '^loop' | awk 'NR>1 {r+=$4; w+=$5; rkb+=$6; wkb+=$7; if($NF>u) u=$NF} END {printf "%.1f %.1f %.1f %.1f", (r+w), rkb, wkb, u}')
        read -r DISK_IO_TPS DISK_READ_KB DISK_WRITE_KB DISK_IO_UTIL <<< "$IO_STATS"
    fi
fi

# --- Network Sockets Collection ---
LISTENING_TCP=0
ESTABLISHED_TCP=0
if command -v ss &>/dev/null; then
    LISTENING_TCP=$(ss -H -ltn 2>/dev/null | wc -l || echo 0)
    ESTABLISHED_TCP=$(ss -H -tn state established 2>/dev/null | wc -l || echo 0)
elif command -v netstat &>/dev/null; then
    LISTENING_TCP=$(netstat -ltn 2>/dev/null | grep -c LISTEN || echo 0)
    ESTABLISHED_TCP=$(netstat -tn 2>/dev/null | grep -c ESTABLISHED || echo 0)
fi

# --- Process Health Collection ---
TOTAL_PROCS=$(ps -e --no-headers 2>/dev/null | wc -l || echo 0)
ZOMBIE_PROCS=$(ps -eo stat= 2>/dev/null | awk '$1 ~ /^Z/ {n++} END {print n+0}')
ZOMBIE_STATUS="NORMAL"
if (( ZOMBIE_PROCS > 0 )); then
    ZOMBIE_STATUS="WARNING"
fi

# Top 3 Longest Running Processes by Elapsed Time
TOP_RUNTIME_PROCS=()
while IFS= read -r p_line; do
    if [[ -n "$p_line" ]]; then
        p_pid=$(echo "$p_line" | awk '{print $1}')
        p_user=$(echo "$p_line" | awk '{print $2}')
        p_etime=$(echo "$p_line" | awk '{print $3}')
        p_comm=$(echo "$p_line" | awk '{print $4}')
        p_dur=$(format_duration "$p_etime")
        TOP_RUNTIME_PROCS+=("${p_pid}|${p_user}|${p_dur}|${p_comm}")
    fi
done < <(ps -eo pid,user,etimes,comm --sort=-etimes --no-headers 2>/dev/null | head -n "$TOP_PROCESS_COUNT")

# --- Journalctl Error Log Inspection ---
JOURNAL_ACCESSIBLE=true
JOURNAL_ERROR_COUNT=0
JOURNAL_ERRORS=()

if command -v journalctl &>/dev/null; then
    JOURNAL_TEST=$(journalctl -p err -n 1 --no-pager 2>&1 || true)
    if echo "$JOURNAL_TEST" | grep -qi "No journal files were found\|Permission denied\|Access denied"; then
        JOURNAL_ACCESSIBLE=false
    else
        while IFS= read -r j_line; do
            if [[ -n "$j_line" && ! "$j_line" =~ ^--\ No\ entries\ -- ]]; then
                JOURNAL_ERRORS+=("$j_line")
                ((JOURNAL_ERROR_COUNT++))
            fi
        done < <(journalctl -p err -n "$JOURNAL_LOG_LINES" --no-pager -o short-iso 2>/dev/null || true)
    fi
else
    JOURNAL_ACCESSIBLE=false
fi

# --- Overall Health Assessment ---
OVERALL_HEALTH="NORMAL"
if [[ "$CPU_STATUS" == "CRITICAL" || "$MEM_STATUS" == "CRITICAL" || "$DISK_STATUS" == "CRITICAL" ]]; then
    OVERALL_HEALTH="CRITICAL"
elif [[ "$CPU_STATUS" == "WARNING" || "$MEM_STATUS" == "WARNING" || "$DISK_STATUS" == "WARNING" || "$ZOMBIE_STATUS" == "WARNING" ]]; then
    OVERALL_HEALTH="WARNING"
fi

# ------------------------------------------------------------------------------
# Render: JSON Output Mode
# ------------------------------------------------------------------------------
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    cat <<EOF
{
  "timestamp": "${TIMESTAMP}",
  "hostname": "${HOSTNAME}",
  "kernel": "${KERNEL}",
  "uptime": "${UPTIME_STR}",
  "overall_health": "${OVERALL_HEALTH}",
  "cpu": {
    "status": "${CPU_STATUS}",
    "utilization_percent": ${TOTAL_CPU_UTIL},
    "load_average": {
      "1m": ${LOAD_1M},
      "5m": ${LOAD_5M},
      "15m": ${LOAD_15M}
    },
    "cores_count": ${NUM_CPUS}
  },
  "memory": {
    "status": "${MEM_STATUS}",
    "total_mb": ${MEM_TOTAL_MB},
    "available_mb": ${MEM_AVAIL_MB},
    "used_mb": ${MEM_USED_MB},
    "usage_percent": ${MEM_UTIL_PCT},
    "swap_total_mb": ${SWAP_TOTAL_MB},
    "swap_used_mb": ${SWAP_USED_MB},
    "swap_usage_percent": ${SWAP_UTIL_PCT}
  },
  "disk": {
    "status": "${DISK_STATUS}",
    "max_filesystem_usage_percent": ${MAX_DISK_PCT},
    "io": {
      "available": ${DISK_IO_AVAILABLE},
      "tps": ${DISK_IO_TPS},
      "read_kb_per_sec": ${DISK_READ_KB},
      "write_kb_per_sec": ${DISK_WRITE_KB},
      "utilization_percent": ${DISK_IO_UTIL}
    }
  },
  "network": {
    "listening_tcp_sockets": ${LISTENING_TCP},
    "established_tcp_connections": ${ESTABLISHED_TCP}
  },
  "processes": {
    "total_count": ${TOTAL_PROCS},
    "zombie_count": ${ZOMBIE_PROCS},
    "zombie_status": "${ZOMBIE_STATUS}"
  },
  "journal": {
    "accessible": ${JOURNAL_ACCESSIBLE},
    "error_entries_found": ${JOURNAL_ERROR_COUNT}
  }
}
EOF
    exit 0
fi

# ------------------------------------------------------------------------------
# Render: Terminal Dashboard Mode
# ------------------------------------------------------------------------------
echo -e "${C_BOLD}${C_BLUE}==============================================================================${C_RESET}"
echo -e "${C_BOLD}${C_WHITE}             🚀 PRODUCTION LINUX SYSTEM MONITOR (sysmon.sh)                   ${C_RESET}"
echo -e "${C_BOLD}${C_BLUE}==============================================================================${C_RESET}"
printf " %-15s %-30s %-15s %s\n" "Host:" "${C_BOLD}${HOSTNAME}${C_RESET}" "Kernel:" "${KERNEL}"
printf " %-15s %-30s %-15s %s\n" "Timestamp:" "${TIMESTAMP}" "Uptime:" "${UPTIME_STR}"
echo -e " System Health:  $(get_status_badge "$OVERALL_HEALTH")"
echo -e "${C_BLUE}------------------------------------------------------------------------------${C_RESET}"

# 1. CPU Section
echo -e "${C_BOLD}${C_CYAN}[1] CPU PERFORMANCE & LOAD${C_RESET} $(get_status_badge "$CPU_STATUS")"
printf "  Utilization:   %-12s Load Average:  %s, %s, %s (1m, 5m, 15m)\n" \
    "${TOTAL_CPU_UTIL}%" "${LOAD_1M}" "${LOAD_5M}" "${LOAD_15M}"
printf "  Logical Cores: %-12s Thresholds:    Warn: %s%% | Crit: %s%%\n" \
    "${NUM_CPUS}" "${CPU_WARN}" "${CPU_CRIT}"

if (( ${#PER_CORE_METRICS[@]} > 0 )); then
    echo -e "  Per-Core Usage:"
    for core_stat in "${PER_CORE_METRICS[@]}"; do
        echo -e "    • ${core_stat}"
    done
fi

echo -e "  Top CPU Processes:"
printf "    ${C_DIM}%-8s %-12s %-20s %-8s${C_RESET}\n" "PID" "USER" "COMMAND" "%CPU"
while IFS= read -r proc; do
    if [[ -n "$proc" ]]; then
        pid=$(echo "$proc" | awk '{print $1}')
        usr=$(echo "$proc" | awk '{print $2}')
        cmd=$(echo "$proc" | awk '{print $3}')
        cpu=$(echo "$proc" | awk '{print $4}')
        printf "    %-8s %-12s %-20s %-8s\n" "$pid" "$usr" "$cmd" "${cpu}%"
    fi
done <<< "$TOP_CPU_PROCS"
echo ""

# 2. Memory Section
echo -e "${C_BOLD}${C_CYAN}[2] MEMORY & SWAP HEALTH${C_RESET} $(get_status_badge "$MEM_STATUS")"
printf "  RAM Usage:     %-12s (%d MB used / %d MB total | %d MB avail)\n" \
    "${MEM_UTIL_PCT}%" "$MEM_USED_MB" "$MEM_TOTAL_MB" "$MEM_AVAIL_MB"
printf "  Swap Usage:    %-12s (%d MB used / %d MB total)\n" \
    "${SWAP_UTIL_PCT}%" "$SWAP_USED_MB" "$SWAP_TOTAL_MB"
printf "  Thresholds:    Warn: %s%% | Crit: %s%%\n" "${MEM_WARN}" "${MEM_CRIT}"

echo -e "  Top Memory Processes:"
printf "    ${C_DIM}%-8s %-12s %-20s %-8s %-10s${C_RESET}\n" "PID" "USER" "COMMAND" "%MEM" "RSS (KB)"
while IFS= read -r proc; do
    if [[ -n "$proc" ]]; then
        pid=$(echo "$proc" | awk '{print $1}')
        usr=$(echo "$proc" | awk '{print $2}')
        cmd=$(echo "$proc" | awk '{print $3}')
        mem=$(echo "$proc" | awk '{print $4}')
        rss=$(echo "$proc" | awk '{print $5}')
        printf "    %-8s %-12s %-20s %-8s %-10s\n" "$pid" "$usr" "$cmd" "${mem}%" "${rss}"
    fi
done <<< "$TOP_MEM_PROCS"
echo ""

# 3. Disk Storage & I/O Section
echo -e "${C_BOLD}${C_CYAN}[3] DISK CAPACITY & I/O PERFORMANCE${C_RESET} $(get_status_badge "$DISK_STATUS")"
echo -e "  Filesystem Mounts:"
printf "    ${C_DIM}%-18s %-15s %-8s %-8s %-8s %-8s %-10s${C_RESET}\n" "MOUNT" "DEVICE" "TOTAL" "USED" "AVAIL" "USE%" "STATUS"
for fs_entry in "${DISK_DETAILS[@]}"; do
    IFS='|' read -r mnt dev tot used avail pct stat <<< "$fs_entry"
    printf "    %-18s %-15s %-8s %-8s %-8s %-8s %s\n" "$mnt" "$dev" "$tot" "$used" "$avail" "$pct" "$(get_status_badge "$stat")"
done

echo -e "  Disk I/O Throughput:"
if [[ "$DISK_IO_AVAILABLE" == "true" ]]; then
    printf "    Read Throughput:   %-15s Write Throughput: %s\n" "${DISK_READ_KB} kB/s" "${DISK_WRITE_KB} kB/s"
    printf "    I/O Transactions:  %-15s Max Device Util:  %s%%\n" "${DISK_IO_TPS} tps" "${DISK_IO_UTIL}"
else
    echo -e "    ${C_DIM}iostat not available (install sysstat for disk read/write throughput metrics)${C_RESET}"
fi
echo ""

# 4. Network Sockets Section
echo -e "${C_BOLD}${C_CYAN}[4] NETWORK SICKNESS & SOCKETS${C_RESET}"
printf "  Listening TCP Sockets:      %-10s (Active listeners waiting for incoming traffic)\n" "${LISTENING_TCP}"
printf "  Established TCP Sessions:   %-10s (Active connected sessions)\n" "${ESTABLISHED_TCP}"
echo ""

# 5. Process Health Section
echo -e "${C_BOLD}${C_CYAN}[5] PROCESS INVENTORY & RUNTIME${C_RESET} $(get_status_badge "$ZOMBIE_STATUS")"
printf "  Total Active Processes:     %-10s Zombie Processes: %s\n" "${TOTAL_PROCS}" "${ZOMBIE_PROCS}"
echo -e "  Longest Elapsed Running Processes:"
printf "    ${C_DIM}%-8s %-12s %-18s %-20s${C_RESET}\n" "PID" "USER" "RUNTIME" "COMMAND"
for r_entry in "${TOP_RUNTIME_PROCS[@]}"; do
    IFS='|' read -r r_pid r_user r_dur r_comm <<< "$r_entry"
    printf "    %-8s %-12s %-18s %-20s\n" "$r_pid" "$r_user" "$r_dur" "$r_comm"
done
echo ""

# 6. Journal Logs Section
echo -e "${C_BOLD}${C_CYAN}[6] SYSTEMD JOURNAL ERROR LOGS (Last ${JOURNAL_LOG_LINES})${C_RESET}"
if [[ "$JOURNAL_ACCESSIBLE" == "false" ]]; then
    echo -e "  ${C_YELLOW}⚠ Access restricted: Current user lacks permission to read systemd journal or journalctl is unavailable.${C_RESET}"
elif (( JOURNAL_ERROR_COUNT == 0 )); then
    echo -e "  ${C_GREEN}✔ No error-level (priority err) log events found in recent journal logs.${C_RESET}"
else
    for j_entry in "${JOURNAL_ERRORS[@]}"; do
        echo -e "  ${C_RED}✖${C_RESET} ${j_entry}"
    done
fi

echo -e "${C_BLUE}==============================================================================${C_RESET}"
echo -e "${C_DIM}Run './sysmon.sh --help' for options or './sysmon.sh --json' for cloud exporter integration.${C_RESET}"
