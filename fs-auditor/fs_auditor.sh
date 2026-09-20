#!/usr/bin/env bash
# ==============================================================================
# fs_auditor.sh
# Linux Filesystem & Permission Security Auditor
#
# Day 7/30 - Linux Mastery | Day 203/1000 - AI Cloud Infrastructure Journey
# Date: September 20, 2026
#
# Description:
# Audits the Linux filesystem for potential security misconfigurations:
# 1. World-writable files in /home
# 2. SUID/SGID binaries (highlighting non-standard locations)
# 3. Broken symbolic links in /opt, /home, /var
# 4. Files with extended POSIX ACLs
# ==============================================================================

set -euo pipefail

REPORT_DIR="${HOME}/reports"
TIMESTAMP="$(date +%F_%H-%M-%S)"
REPORT_FILE="${REPORT_DIR}/fs_audit_${TIMESTAMP}.txt"

mkdir -p "${REPORT_DIR}"

{
    echo "========================================"
    echo " Linux Filesystem Security Audit Report"
    echo "========================================"
    echo "Date:      $(date)"
    echo "Host:      $(hostname)"
    echo "Kernel:    $(uname -r)"
    echo "Report:    ${REPORT_FILE}"
    echo "========================================"
    echo

    # --------------------------------------------------
    # 1. World-Writable Files
    # --------------------------------------------------
    echo "========================================"
    echo " 1. WORLD-WRITABLE FILES (under /home)"
    echo "========================================"
    echo "Searching for files writable by 'others' (perm -0002)..."
    echo

    WW_COUNT=0
    while IFS= read -r file; do
        if [[ -n "${file}" ]]; then
            echo "[RISK] ${file}"
            WW_COUNT=$((WW_COUNT + 1))
        fi
    done < <(find /home -type f -perm -0002 2>/dev/null || true)

    if [[ "${WW_COUNT}" -eq 0 ]]; then
        echo "[OK] No world-writable files found in /home."
    else
        echo
        echo "Total world-writable files found: ${WW_COUNT}"
    fi
    echo

    # --------------------------------------------------
    # 2. SUID / SGID Files
    # --------------------------------------------------
    echo "========================================"
    echo " 2. SUID & SGID BINARIES"
    echo "========================================"
    echo "Scanning system for SUID (4000) and SGID (2000) binaries..."
    echo

    SUID_COUNT=0
    REVIEW_COUNT=0

    while IFS= read -r file; do
        if [[ -n "${file}" ]]; then
            SUID_COUNT=$((SUID_COUNT + 1))
            case "${file}" in
                /bin/*|/sbin/*|/usr/bin/*|/usr/sbin/*|/usr/lib/*|/usr/libexec/*)
                    echo "[STANDARD] ${file}"
                    ;;
                *)
                    echo "[REVIEW REQUIRED] ${file}"
                    REVIEW_COUNT=$((REVIEW_COUNT + 1))
                    ;;
            esac
        fi
    done < <(find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null || true)

    echo
    echo "Total SUID/SGID binaries found: ${SUID_COUNT}"
    echo "Non-standard binaries flagged for review: ${REVIEW_COUNT}"
    echo

    # --------------------------------------------------
    # 3. Broken Symlinks
    # --------------------------------------------------
    echo "========================================"
    echo " 3. BROKEN SYMBOLIC LINKS"
    echo "========================================"
    echo "Scanning /opt, /home, and /var for orphaned symlinks..."
    echo

    BROKEN_COUNT=0
    while IFS= read -r link; do
        if [[ -n "${link}" ]]; then
            echo "[BROKEN] ${link}"
            BROKEN_COUNT=$((BROKEN_COUNT + 1))
        fi
    done < <(find /opt /home /var -xtype l 2>/dev/null || true)

    if [[ "${BROKEN_COUNT}" -eq 0 ]]; then
        echo "[OK] No broken symbolic links found."
    else
        echo
        echo "Total broken symlinks found: ${BROKEN_COUNT}"
    fi
    echo

    # --------------------------------------------------
    # 4. Files with Extended ACLs
    # --------------------------------------------------
    echo "========================================"
    echo " 4. FILES WITH EXTENDED ACLs (+)"
    echo "========================================"
    echo "Scanning /home, /opt, /var for files with POSIX ACLs..."
    echo

    ACL_COUNT=0
    while IFS= read -r file; do
        if [[ -n "${file}" ]]; then
            echo "[ACL DETECTED] ${file}"
            ACL_COUNT=$((ACL_COUNT + 1))
        fi
    done < <(find /home /opt /var -type f -exec ls -ld {} + 2>/dev/null | grep '^[a-z-][rwxstST-]*+ ' | awk '{print $NF}' || true)

    if [[ "${ACL_COUNT}" -eq 0 ]]; then
        echo "[OK] No extended ACLs detected in target directories."
    else
        echo
        echo "Total files with extended ACLs: ${ACL_COUNT}"
    fi
    echo

    # --------------------------------------------------
    # 5. Audit Summary
    # --------------------------------------------------
    echo "========================================"
    echo " AUDIT SUMMARY & STATS"
    echo "========================================"
    echo "World-Writable Files:     ${WW_COUNT}"
    echo "Total SUID/SGID Files:    ${SUID_COUNT}"
    echo "Non-Standard SUID/SGID:   ${REVIEW_COUNT}"
    echo "Broken Symlinks:          ${BROKEN_COUNT}"
    echo "Extended ACL Files:       ${ACL_COUNT}"
    echo "========================================"
    echo "Audit completed at: $(date)"
    echo "========================================"

} | tee "${REPORT_FILE}"

echo
echo "Audit complete! Full log saved to: ${REPORT_FILE}"
