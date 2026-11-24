#!/usr/bin/env bash

# ==============================================================================
# LIBRARY  : 12_network_math_lib.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 12/30 (Week 10)
# JOURNEY  : Day 268 / 1000
# PURPOSE  : Modular IPv4 Validation, Integer Conversion, and CIDR Math Library
# USAGE    : source ./12_network_math_lib.sh
# ==============================================================================

# Guard against double-sourcing
if [[ -n "${_NETWORK_MATH_LIB_LOADED:-}" ]]; then
    return 0
fi
_NETWORK_MATH_LIB_LOADED=1

# ------------------------------------------------------------------------------
# 1. IPV4 FORMAT & BOUNDARY VALIDATION
# ------------------------------------------------------------------------------
# Validates whether a given string is a syntactically valid IPv4 address.
# Returns 0 on valid IPv4, 1 on invalid format or out-of-range octet.
validate_ip() {
    local ip="${1:-}"
    local IFS='.'
    local -a octets

    [[ -n "$ip" ]] || return 1

    read -r -a octets <<< "$ip"

    # IPv4 must have exactly 4 octets
    [[ ${#octets[@]} -eq 4 ]] || return 1

    local octet
    for octet in "${octets[@]}"; do
        # Each octet must be 1 to 3 decimal digits
        [[ "$octet" =~ ^[0-9]{1,3}$ ]] || return 1

        # Must be between 0 and 255. Use base-10 (10#$octet) to prevent octal errors on leading zeroes
        (( 10#$octet <= 255 )) || return 1
    done

    return 0
}

# ------------------------------------------------------------------------------
# 2. INTEGER TO IPV4 CONVERSION (Approach A: Command Substitution)
# ------------------------------------------------------------------------------
# Converts an unsigned 32-bit integer (0 - 4294967295) to dotted-decimal IPv4 string.
# Emits dotted IP string to stdout. Returns 0 on success, 1 on invalid input.
int_to_ip() {
    local number="${1:-}"

    [[ "$number" =~ ^[0-9]+$ ]] || return 1
    (( number <= 4294967295 )) || return 1

    printf '%d.%d.%d.%d\n' \
        "$(( (number >> 24) & 255 ))" \
        "$(( (number >> 16) & 255 ))" \
        "$(( (number >> 8) & 255 ))" \
        "$(( number & 255 ))"
}

# ------------------------------------------------------------------------------
# 3. IPV4 TO INTEGER CONVERSION (Approach A: Command Substitution)
# ------------------------------------------------------------------------------
# Converts a dotted-decimal IPv4 address into its unsigned 32-bit integer representation.
# Emits 32-bit unsigned integer to stdout. Returns 0 on success, 1 on invalid input.
ip_to_int() {
    local ip="${1:-}"
    validate_ip "$ip" || return 1

    local IFS='.'
    local -a octets
    read -r -a octets <<< "$ip"

    printf '%u\n' "$(( (10#${octets[0]} << 24) + (10#${octets[1]} << 16) + (10#${octets[2]} << 8) + 10#${octets[3]} ))"
}

# ------------------------------------------------------------------------------
# 4. CIDR SUBNET CALCULATION (Approach B: Name References declare -n)
# ------------------------------------------------------------------------------
# Calculates network address, broadcast address, and usable host count.
# Modifies caller variables directly in place via name references without subshell overhead.
# Usage: calculate_subnet <ip> <prefix> <network_var> <broadcast_var> <hosts_var>
calculate_subnet() {
    local _cs_ip="$1"
    local _cs_prefix="$2"
    local -n _cs_net_ref=$3
    local -n _cs_bcast_ref=$4
    local -n _cs_hosts_ref=$5

    validate_ip "$_cs_ip" || return 1
    [[ "$_cs_prefix" =~ ^[0-9]{1,2}$ ]] || return 1
    (( _cs_prefix >= 0 && _cs_prefix <= 32 )) || return 1

    local _cs_ip_int
    _cs_ip_int=$(ip_to_int "$_cs_ip") || return 1

    local _cs_mask_int _cs_net_int _cs_bcast_int _cs_calc_hosts

    if (( _cs_prefix == 32 )); then
        _cs_mask_int=4294967295
        _cs_calc_hosts=1
    elif (( _cs_prefix == 0 )); then
        _cs_mask_int=0
        _cs_calc_hosts=4294967294
    else
        _cs_mask_int=$(( (0xFFFFFFFF << (32 - _cs_prefix)) & 0xFFFFFFFF ))
        _cs_calc_hosts=$(( (1 << (32 - _cs_prefix)) - 2 ))
    fi

    _cs_net_int=$(( _cs_ip_int & _cs_mask_int ))
    _cs_bcast_int=$(( _cs_net_int | (~_cs_mask_int & 0xFFFFFFFF) ))

    _cs_net_ref=$(int_to_ip "$_cs_net_int")
    _cs_bcast_ref=$(int_to_ip "$_cs_bcast_int")
    _cs_hosts_ref="$_cs_calc_hosts"

    return 0
}

# ------------------------------------------------------------------------------
# 5. ICMP PING LATENCY MEASUREMENT
# ------------------------------------------------------------------------------
# Sends a single probe and extracts round-trip latency in milliseconds.
# Emits "<latency> ms" to stdout. Returns 0 on success, 1 on unreachable host or error.
ping_latency() {
    local host="${1:-}"
    local output

    [[ -n "$host" ]] || return 1

    # Probe host with single packet (supporting Linux -c and Windows -n fallback)
    output=$(ping -c 1 -W 2 "$host" 2>/dev/null) || \
    output=$(ping -n 1 -w 2000 "$host" 2>/dev/null) || return 1

    # Match timing payload across standard ping implementations (Linux and Windows)
    local regex='time[=<]([0-9.]+)[[:space:]]*ms'
    local fallback_regex='time=([0-9.]+)'

    if [[ "$output" =~ $regex ]]; then
        printf '%s ms\n' "${BASH_REMATCH[1]}"
        return 0
    elif [[ "$output" =~ $fallback_regex ]]; then
        printf '%s ms\n' "${BASH_REMATCH[1]}"
        return 0
    else
        return 1
    fi
}
