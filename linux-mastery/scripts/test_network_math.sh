#!/usr/bin/env bash

# ==============================================================================
# TEST HARNESS : test_network_math.sh
# TRACK        : Mastering Shell Scripting & Automation — Day 12/30 (Week 10)
# JOURNEY      : Day 268 / 1000
# PURPOSE      : Test Harness for 12_network_math_lib.sh Functions & Name References
# USAGE        : ./test_network_math.sh
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
# 2. LOAD MODULAR LIBRARY
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_PATH="${SCRIPT_DIR}/12_network_math_lib.sh"

if [[ ! -r "$LIB_PATH" ]]; then
    echo -e "${RED}ERROR: Cannot locate library at: ${LIB_PATH}${RESET}" >&2
    exit 1
fi

# shellcheck source=12_network_math_lib.sh
source "$LIB_PATH"

echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}         NETWORK MATHEMATICS TEST HARNESS           ${RESET}"
echo -e "${CYAN}====================================================${RESET}"

# ------------------------------------------------------------------------------
# 3. TEST 1: IP VALIDATION (Exit Status Return Protocol)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${BLUE}[TEST 1] IPv4 Validation (Status Code Return Protocol)${RESET}"
echo "----------------------------------------------------"

test_ips=("192.168.1.10" "10.0.0.1" "255.255.255.255" "192.168.1.300" "10.0.0" "invalid.ip.string")

for candidate in "${test_ips[@]}"; do
    if validate_ip "$candidate"; then
        printf "  %-20s -> ${GREEN}[VALID]${RESET} (exit: 0)\n" "$candidate"
    else
        printf "  %-20s -> ${RED}[INVALID]${RESET} (exit: 1)\n" "$candidate"
    fi
done

# ------------------------------------------------------------------------------
# 4. TEST 2: INTEGER <-> IP CONVERSIONS (Command Substitution Approach)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${BLUE}[TEST 2] Integer <-> IPv4 Dotted-Decimal Conversions${RESET}"
echo "----------------------------------------------------"

sample_int=3232235777
converted_ip=$(int_to_ip "$sample_int")
echo -e "  Integer: ${sample_int} -> Converted IP: ${GREEN}${converted_ip}${RESET}"

sample_ip="192.168.1.1"
converted_int=$(ip_to_int "$sample_ip")
echo -e "  IP: ${sample_ip}       -> Converted Int: ${GREEN}${converted_int}${RESET}"

if [[ "$sample_int" -eq "$converted_int" && "$sample_ip" == "$converted_ip" ]]; then
    echo -e "  ${GREEN}[PASS] Bidirectional conversion symmetry verified.${RESET}"
else
    echo -e "  ${RED}[FAIL] Conversion asymmetry detected.${RESET}"
fi

# ------------------------------------------------------------------------------
# 5. TEST 3: CIDR SUBNET CALCULATION (Name References Approach B)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${BLUE}[TEST 3] CIDR Calculations via Name References (declare -n)${RESET}"
echo "----------------------------------------------------"

cidr_ip="192.168.1.50"
cidr_prefix=24

# Declare destination variables in caller scope
net_addr=""
bcast_addr=""
usable_hosts=0

# Invocation passes variable names directly (no $ prefix)
calculate_subnet "$cidr_ip" "$cidr_prefix" net_addr bcast_addr usable_hosts

echo -e "  CIDR Block       : ${BOLD}${cidr_ip}/${cidr_prefix}${RESET}"
echo -e "  Network Address  : ${GREEN}${net_addr}${RESET}"
echo -e "  Broadcast Address: ${GREEN}${bcast_addr}${RESET}"
echo -e "  Usable Host Cap  : ${GREEN}${usable_hosts}${RESET}"

# Test second CIDR block (/16)
cidr_ip2="10.240.75.120"
cidr_prefix2=16
calculate_subnet "$cidr_ip2" "$cidr_prefix2" net_addr bcast_addr usable_hosts
echo
echo -e "  CIDR Block       : ${BOLD}${cidr_ip2}/${cidr_prefix2}${RESET}"
echo -e "  Network Address  : ${GREEN}${net_addr}${RESET}"
echo -e "  Broadcast Address: ${GREEN}${bcast_addr}${RESET}"
echo -e "  Usable Host Cap  : ${GREEN}${usable_hosts}${RESET}"

# ------------------------------------------------------------------------------
# 6. TEST 4: PING LATENCY TELEMETRY
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${BLUE}[TEST 4] ICMP Round-Trip Latency Measurement${RESET}"
echo "----------------------------------------------------"

target_hosts=("127.0.0.1" "8.8.8.8" "1.1.1.1")

for target in "${target_hosts[@]}"; do
    echo -n "  Probing ${target}... "
    if latency=$(ping_latency "$target"); then
        echo -e "${GREEN}Latency: ${latency}${RESET}"
    else
        echo -e "${YELLOW}Probe unreachable / timed out${RESET}"
    fi
done

echo -e "\n${CYAN}====================================================${RESET}"
echo -e "${GREEN}${BOLD}ALL LIBRARY INTEGRATION TESTS EXECUTED SUCCESSFULLY${RESET}"
echo -e "${CYAN}====================================================${RESET}"
