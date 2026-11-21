#!/usr/bin/env bash

# ==============================================================================
# PROJECT  : 09_os_detector.sh
# TRACK    : Mastering Shell Scripting & Automation — Day 9/30 (Week 10)
# JOURNEY  : Day 265 / 1000
# PURPOSE  : Enterprise Linux OS, Distribution Family & Package Manager Detector
# USAGE    : ./09_os_detector.sh [--install] [--file <os-release-path>]
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
# 2. CONFIGURATION & STATE
# ------------------------------------------------------------------------------
SCRIPT_NAME="${0##*/}"
OS_RELEASE="${OS_RELEASE_FILE:-/etc/os-release}"
DO_INSTALL=false

# ------------------------------------------------------------------------------
# 3. HELPER FUNCTIONS
# ------------------------------------------------------------------------------
show_help() {
    cat <<EOF
Usage: ${SCRIPT_NAME} [OPTIONS]

Linux OS Distribution and Package Manager Detection Utility.

Options:
  --install              Execute the recommended package installation command
  --file <path>          Specify custom os-release file (useful for mocking/testing)
  --help, -h             Display this documentation and exit

Examples:
  ./${SCRIPT_NAME}
  ./${SCRIPT_NAME} --file /tmp/mock-rhel-release
  sudo ./${SCRIPT_NAME} --install

Exit Codes:
  0 : Detection completed successfully (or installation completed)
  1 : Missing / unreadable os-release file, or unsupported distribution
  2 : Invalid CLI arguments
EOF
}

# ------------------------------------------------------------------------------
# 4. ARGUMENT PARSING
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --install)
            DO_INSTALL=true
            shift
            ;;
        --file)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo -e "${RED}ERROR: --file requires a valid file path argument.${RESET}" >&2
                exit 2
            fi
            OS_RELEASE="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}ERROR: Unknown option: $1${RESET}" >&2
            echo "Use '${SCRIPT_NAME} --help' for usage information." >&2
            exit 2
            ;;
    esac
done

# ------------------------------------------------------------------------------
# 5. OS IDENTIFICATION EXTRACTION
# ------------------------------------------------------------------------------
# Verify that the os-release file exists and is readable
if [[ ! -r "$OS_RELEASE" ]]; then
    echo -e "${RED}ERROR: Cannot read OS identification file at: ${OS_RELEASE}${RESET}" >&2
    echo "This script requires a standard Linux /etc/os-release file or --file override." >&2
    exit 1
fi

# Load variables safely from os-release
# shellcheck source=/dev/null
source "$OS_RELEASE"

# Defensive defaults under set -u
ID="${ID:-unknown}"
ID_LIKE="${ID_LIKE:-}"
PRETTY_NAME="${PRETTY_NAME:-Unknown Linux Distribution}"
VERSION_ID="${VERSION_ID:-Unknown}"

# Normalize distribution identifiers (Bash parameter expansion to lowercase)
OS_ID="${ID,,}"
OS_LIKE="${ID_LIKE:-}"
OS_PRETTY="${PRETTY_NAME}"
OS_VERSION="${VERSION_ID}"

echo -e "${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}            LINUX OS & RUNTIME DETECTOR             ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
printf "%-20s : %b\n" "Distribution" "${GREEN}${BOLD}${OS_PRETTY}${RESET}"
printf "%-20s : %s\n" "OS ID" "${OS_ID}"
printf "%-20s : %s\n" "OS Family (LIKE)" "${OS_LIKE:-None specified}"
printf "%-20s : %s\n" "Version ID" "${OS_VERSION}"
echo -e "${CYAN}----------------------------------------------------${RESET}"

# ------------------------------------------------------------------------------
# 6. DISTRIBUTION FAMILY & PACKAGE MANAGER MAPPING (pattern matching)
# ------------------------------------------------------------------------------
case "${OS_ID} ${OS_LIKE}" in

    ubuntu*|debian*|*debian*)
        FAMILY="Debian"
        PACKAGE_MANAGER="apt"
        INSTALL_COMMAND="sudo apt update && sudo apt install -y nginx"
        ;;

    amzn*|rhel*|centos*|rocky*|almalinux*|fedora*|*rhel*|*fedora*)
        FAMILY="RHEL"
        if command -v dnf &>/dev/null; then
            PACKAGE_MANAGER="dnf"
            INSTALL_COMMAND="sudo dnf install -y nginx"
        elif command -v yum &>/dev/null; then
            PACKAGE_MANAGER="yum"
            INSTALL_COMMAND="sudo yum install -y nginx"
        else
            PACKAGE_MANAGER="dnf/yum (not found in PATH)"
            INSTALL_COMMAND="sudo dnf install -y nginx"
        fi
        ;;

    alpine*|*alpine*)
        FAMILY="Alpine"
        PACKAGE_MANAGER="apk"
        INSTALL_COMMAND="sudo apk add --no-cache nginx"
        ;;

    arch*|*arch*|manjaro*|*manjaro*)
        FAMILY="Arch"
        PACKAGE_MANAGER="pacman"
        INSTALL_COMMAND="sudo pacman -S --noconfirm nginx"
        ;;

    sles*|opensuse*|*suse*)
        FAMILY="SUSE"
        PACKAGE_MANAGER="zypper"
        INSTALL_COMMAND="sudo zypper install -y nginx"
        ;;

    *)
        FAMILY="Unknown"
        PACKAGE_MANAGER="Unknown"
        INSTALL_COMMAND="Unsupported distribution"
        ;;

esac

printf "%-20s : %b\n" "Detected Family" "${BOLD}${YELLOW}${FAMILY}${RESET}"
printf "%-20s : %b\n" "Package Manager" "${BOLD}${CYAN}${PACKAGE_MANAGER}${RESET}"
echo
echo -e "${BOLD}Recommended Nginx Installation Command:${RESET}"
echo -e "  ${BLUE}${INSTALL_COMMAND}${RESET}"
echo -e "${CYAN}====================================================${RESET}"

# ------------------------------------------------------------------------------
# 7. OPTIONAL INSTALLATION EXECUTION (--install)
# ------------------------------------------------------------------------------
if [[ "$DO_INSTALL" == true ]]; then
    echo
    echo -e "${YELLOW}[!] Installation flag detected (--install). Initiating package deployment...${RESET}"

    case "$FAMILY" in
        Debian)
            echo -e "${BLUE}Executing:${RESET} sudo apt update && sudo apt install -y nginx"
            sudo apt update && sudo apt install -y nginx
            ;;

        RHEL)
            if command -v dnf &>/dev/null; then
                echo -e "${BLUE}Executing:${RESET} sudo dnf install -y nginx"
                sudo dnf install -y nginx
            elif command -v yum &>/dev/null; then
                echo -e "${BLUE}Executing:${RESET} sudo yum install -y nginx"
                sudo yum install -y nginx
            else
                echo -e "${RED}ERROR: Neither dnf nor yum package manager was located in PATH.${RESET}" >&2
                exit 1
            fi
            ;;

        Alpine)
            echo -e "${BLUE}Executing:${RESET} sudo apk add --no-cache nginx"
            sudo apk add --no-cache nginx
            ;;

        Arch)
            echo -e "${BLUE}Executing:${RESET} sudo pacman -S --noconfirm nginx"
            sudo pacman -S --noconfirm nginx
            ;;

        SUSE)
            echo -e "${BLUE}Executing:${RESET} sudo zypper install -y nginx"
            sudo zypper install -y nginx
            ;;

        *)
            echo -e "${RED}ERROR: Cannot install packages on unsupported Linux family: ${FAMILY}${RESET}" >&2
            exit 1
            ;;
    esac

    echo -e "${GREEN}${BOLD}[SUCCESS] Package installation sequence executed successfully.${RESET}"
else
    echo -e "${YELLOW}Note: Dry-run detection complete. To execute software installation, supply '--install'.${RESET}"
fi

exit 0
