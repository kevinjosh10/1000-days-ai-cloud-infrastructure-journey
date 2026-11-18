#!/usr/bin/env bash

# ==============================================================================
# Script   : 06_inventory_mapper.sh
# Track    : Mastering Shell Scripting & Automation — Day 6/30
# Journey  : Day 262/1000
# Purpose  : Cloud Server Inventory Management CLI using Bash Associative Arrays
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# 1. DECLARE PARALLEL ASSOCIATIVE ARRAYS
# ------------------------------------------------------------------------------
declare -A server_ips
declare -A server_regions
declare -A server_types
declare -A server_roles

# ------------------------------------------------------------------------------
# 2. POPULATE INITIAL CLOUD INVENTORY
# ------------------------------------------------------------------------------
# Host 1: Web Frontend
server_ips["web-01"]="10.0.1.10"
server_regions["web-01"]="ap-south-1"
server_types["web-01"]="t3.micro"
server_roles["web-01"]="Frontend"

# Host 2: Database Cluster
server_ips["db-01"]="10.0.2.10"
server_regions["db-01"]="ap-south-1"
server_types["db-01"]="t3.medium"
server_roles["db-01"]="Database"

# Host 3: Application Backend
server_ips["app-01"]="10.0.3.10"
server_regions["app-01"]="ap-south-1"
server_types["app-01"]="t3.small"
server_roles["app-01"]="Backend"

# Host 4: Distributed Cache
server_ips["cache-01"]="10.0.4.10"
server_regions["cache-01"]="ap-southeast-1"
server_types["cache-01"]="t3.micro"
server_roles["cache-01"]="Cache"

# ------------------------------------------------------------------------------
# 3. SINGLE SERVER LOOKUP MODULE
# ------------------------------------------------------------------------------
lookup_server() {
    local host="$1"

    # Defensive existence check using [[ -v ]]
    if [[ ! -v 'server_ips[$host]' ]]; then
        echo "Error: Server '$host' not found in inventory registry." >&2
        return 1
    fi

    echo "=================================================================="
    echo "                      SERVER DETAIL REPORT                        "
    echo "=================================================================="
    echo "  Hostname      : ${host}"
    echo "  Private IP    : ${server_ips[$host]}"
    echo "  AWS Region    : ${server_regions[$host]}"
    echo "  Instance Type : ${server_types[$host]}"
    echo "  Cluster Role  : ${server_roles[$host]}"
    echo "=================================================================="
    echo
}

# ------------------------------------------------------------------------------
# 4. LIST ALL SERVERS (DETERMINISTIC SORTED OUTPUT)
# ------------------------------------------------------------------------------
list_servers() {
    echo "=================================================================="
    echo "                 ACTIVE CLOUD SERVER INVENTORY                    "
    echo "=================================================================="
    printf "%-12s | %-15s | %-15s | %-10s | %-12s\n" \
        "HOSTNAME" "PRIVATE IP" "AWS REGION" "TYPE" "ROLE"
    echo "-------------+-----------------+-----------------+------------+-------------"

    # Sort keys deterministically via process substitution
    while IFS= read -r host; do
        printf "%-12s | %-15s | %-15s | %-10s | %-12s\n" \
            "$host" \
            "${server_ips[$host]}" \
            "${server_regions[$host]}" \
            "${server_types[$host]}" \
            "${server_roles[$host]}"
    done < <(printf '%s\n' "${!server_ips[@]}" | sort)

    echo "------------------------------------------------------------------"
    echo "  Total Registered Compute Nodes: ${#server_ips[@]}"
    echo "=================================================================="
    echo
}

# ------------------------------------------------------------------------------
# 5. PURE BASH JSON ESCAPING HELPER (RFC 8259)
# ------------------------------------------------------------------------------
json_escape() {
    local val="$1"
    # Escape backslashes first, then quotes, then control characters
    val="${val//\\/\\\\}"
    val="${val//\"/\\\"}"
    val="${val//$'\n'/\\n}"
    val="${val//$'\r'/\\r}"
    val="${val//$'\t'/\\t}"
    printf '%s' "$val"
}

# ------------------------------------------------------------------------------
# 6. JSON EXPORT ENGINE
# ------------------------------------------------------------------------------
export_json() {
    local host
    local first=true

    echo "{"
    echo '  "cloud_inventory": ['

    while IFS= read -r host; do
        if [[ "$first" == false ]]; then
            echo ","
        fi
        first=false

        printf '    {\n'
        printf '      "hostname": "%s",\n'      "$(json_escape "$host")"
        printf '      "private_ip": "%s",\n'    "$(json_escape "${server_ips[$host]}")"
        printf '      "aws_region": "%s",\n'    "$(json_escape "${server_regions[$host]}")"
        printf '      "instance_type": "%s",\n' "$(json_escape "${server_types[$host]}")"
        printf '      "role": "%s"\n'           "$(json_escape "${server_roles[$host]}")"
        printf '    }'
    done < <(printf '%s\n' "${!server_ips[@]}" | sort)

    echo
    echo "  ],"
    echo "  \"total_count\": ${#server_ips[@]}"
    echo "}"
}

# ------------------------------------------------------------------------------
# 7. CLI ROUTER & ENTRYPOINT
# ------------------------------------------------------------------------------
case "${1:-help}" in
    lookup)
        [[ $# -ne 2 ]] && { echo "Usage: $0 lookup <HOSTNAME>" >&2; exit 1; }
        lookup_server "$2"
        ;;
    list)
        list_servers
        ;;
    export)
        export_json
        ;;
    count)
        echo "Total Registered Compute Nodes: ${#server_ips[@]}"
        ;;
    help|--help|-h)
        echo "CLOUD SERVER INVENTORY MAPPER CLI"
        echo "Usage: $0 <command> [arguments]"
        echo
        echo "Available Commands:"
        echo "  lookup <HOST>       Display detailed metadata for a single host"
        echo "  list                Display tabular inventory sorted by hostname"
        echo "  export              Serialize entire inventory to valid JSON"
        echo "  count               Print total count of registered servers"
        echo "  help                Display this documentation"
        ;;
    *)
        echo "Error: Unknown command '$1'. Run '$0 help' for usage." >&2
        exit 1
        ;;
esac
