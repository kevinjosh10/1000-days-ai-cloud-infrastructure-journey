#!/usr/bin/env bash

# ==============================================================================
# Script   : 05_ip_whitelist_manager.sh
# Track    : Mastering Shell Scripting & Automation — Day 5/30
# Journey  : Day 261/1000
# Purpose  : IPv4 CIDR Whitelist Manager using Native Bash Indexed Arrays
# ==============================================================================

set -euo pipefail

WHITELIST_FILE="./approved_cidrs.txt"

# Default baseline CIDR array
declare -a cidrs=(
    "10.0.0.0/16"
    "10.1.0.0/16"
    "172.16.0.0/16"
    "192.168.1.0/24"
)

# ------------------------------------------------------------------------------
# 1. LOAD PERSISTED CIDRS VIA MAPFILE
# ------------------------------------------------------------------------------
load_cidrs() {
    if [[ -f "$WHITELIST_FILE" ]]; then
        # mapfile (-t strips trailing newlines)
        mapfile -t cidrs < "$WHITELIST_FILE"
    else
        printf '%s\n' "${cidrs[@]}" > "$WHITELIST_FILE"
    fi
}

# ------------------------------------------------------------------------------
# 2. VALIDATE IPV4 CIDR FORMAT & OCTET BOUNDS
# ------------------------------------------------------------------------------
validate_cidr() {
    local cidr="$1"
    local ip prefix octet
    local -a octets

    # Must contain a slash
    if [[ "$cidr" != */* ]]; then
        return 1
    fi

    ip="${cidr%/*}"
    prefix="${cidr##*/}"

    # Validate prefix (0-32)
    if [[ ! "$prefix" =~ ^[0-9]{1,2}$ ]] || (( 10#$prefix > 32 )); then
        return 1
    fi

    # Validate 4 dot-separated numeric octets
    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 1
    fi

    # Split IP into array using IFS
    IFS='.' read -r -a octets <<< "$ip"

    if (( ${#octets[@]} != 4 )); then
        return 1
    fi

    # Validate each octet is 0-255
    for octet in "${octets[@]}"; do
        if [[ ! "$octet" =~ ^[0-9]{1,3}$ ]] || (( 10#$octet > 255 )); then
            return 1
        fi
    done

    return 0
}

# ------------------------------------------------------------------------------
# 3. SAVE CIDRS TO PERSISTENT STORAGE
# ------------------------------------------------------------------------------
save_cidrs() {
    printf '%s\n' "${cidrs[@]}" > "$WHITELIST_FILE"
}

# ------------------------------------------------------------------------------
# 4. ADD NEW CIDR (DUPLICATE PREVENTION & VALIDATION)
# ------------------------------------------------------------------------------
add_cidr() {
    local new_cidr="$1"

    if ! validate_cidr "$new_cidr"; then
        echo "[ERROR] Invalid IPv4 CIDR format: '$new_cidr'" >&2
        return 1
    fi

    # Check for duplicates using safe array iteration
    for existing in "${cidrs[@]}"; do
        if [[ "$existing" == "$new_cidr" ]]; then
            echo "[INFO] CIDR '$new_cidr' is already present in whitelist."
            return 0
        fi
    done

    # Dynamic Array Append
    cidrs+=("$new_cidr")
    save_cidrs
    echo "[SUCCESS] Added CIDR '$new_cidr' to whitelist (Total: ${#cidrs[@]})."
}

# ------------------------------------------------------------------------------
# 5. CHECK EXACT CIDR STATUS
# ------------------------------------------------------------------------------
check_cidr() {
    local search="$1"

    for item in "${cidrs[@]}"; do
        if [[ "$item" == "$search" ]]; then
            echo "[APPROVED] '$search' is authorized in whitelist."
            return 0
        fi
    done

    echo "[DENIED] '$search' is NOT in whitelist."
    return 1
}

# ------------------------------------------------------------------------------
# 6. LIST ALL APPROVED CIDRS WITH INDICES
# ------------------------------------------------------------------------------
list_cidrs() {
    echo "=================================================================="
    echo "                    APPROVED CIDR WHITELIST                       "
    echo "=================================================================="
    for i in "${!cidrs[@]}"; do
        printf "  [%02d] %s\n" "$i" "${cidrs[$i]}"
    done
    echo "------------------------------------------------------------------"
    echo "  Total Active Records: ${#cidrs[@]}"
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 7. SLICE ARRAY FOR BATCH PROCESSING
# ------------------------------------------------------------------------------
slice_cidrs() {
    local offset="$1"
    local length="$2"
    local -a selected

    if [[ ! "$offset" =~ ^[0-9]+$ ]] || [[ ! "$length" =~ ^[0-9]+$ ]]; then
        echo "[ERROR] Offset and length must be non-negative integers." >&2
        return 1
    fi

    # Array Slicing
    selected=("${cidrs[@]:offset:length}")

    echo "=================================================================="
    echo "                   SELECTED CIDR ARRAY SLICE                      "
    echo "=================================================================="
    printf "  -> %s\n" "${selected[@]}"
    echo "------------------------------------------------------------------"
    echo "  Slice Window: Offset $offset | Length $length | Extracted: ${#selected[@]}"
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 8. GENERATE FIREWALL RULES
# ------------------------------------------------------------------------------
generate_rules() {
    echo "=================================================================="
    echo "              SUGGESTED FIREWALL (UFW) INGRESS RULES              "
    echo "=================================================================="
    for cidr in "${cidrs[@]}"; do
        echo "  ufw allow from ${cidr} to any port 443 proto tcp comment 'Whitelisted Ingress'"
    done
    echo "------------------------------------------------------------------"
    echo "  [INFO] Generated ${#cidrs[@]} firewall rules for review."
    echo "  [INFO] No changes were applied to active kernel packet filters."
    echo "=================================================================="
}

# ------------------------------------------------------------------------------
# 9. CLI ENTRYPOINT & ROUTING
# ------------------------------------------------------------------------------
load_cidrs

case "${1:-help}" in
    add)
        [[ $# -ne 2 ]] && { echo "Usage: $0 add <IPv4-CIDR>" >&2; exit 1; }
        add_cidr "$2"
        ;;
    check)
        [[ $# -ne 2 ]] && { echo "Usage: $0 check <IPv4-CIDR>" >&2; exit 1; }
        check_cidr "$2"
        ;;
    list)
        list_cidrs
        ;;
    slice)
        [[ $# -ne 3 ]] && { echo "Usage: $0 slice <offset> <length>" >&2; exit 1; }
        slice_cidrs "$2" "$3"
        ;;
    generate)
        generate_rules
        ;;
    help|--help|-h)
        echo "IP WHITELIST MANAGER CLI"
        echo "Usage: $0 <command> [arguments]"
        echo
        echo "Available Commands:"
        echo "  add <CIDR>          Add an IPv4 CIDR block with duplicate detection"
        echo "  check <CIDR>        Verify if a CIDR block exists in whitelist"
        echo "  list                Display all approved CIDR blocks with indices"
        echo "  slice <N> <L>       Extract an array slice (Offset N, Length L)"
        echo "  generate            Generate suggested UFW ingress firewall rules"
        echo "  help                Display this documentation runbook"
        ;;
    *)
        echo "[ERROR] Unknown command: '$1'. Run '$0 help' for usage." >&2
        exit 1
        ;;
esac
