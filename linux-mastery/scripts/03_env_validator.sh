#!/usr/bin/env bash

# ==============================================================================
# Script   : 03_env_validator.sh
# Track    : Mastering Shell Scripting & Automation — Day 3/30
# Journey  : Day 259/1000
# Purpose  : Production Pre-Flight Environment Configuration Validator
# ==============================================================================

# Strict mode: Inherit error traps, fail on error, fail on unset variable, fail on pipe error
set -Eeuo pipefail

# ------------------------------------------------------------------------------
# 1. APPLICATION & INFRASTRUCTURE FALLBACKS
# ------------------------------------------------------------------------------
APP_NAME="${APP_NAME:-cloud-monitor}"

# Normalize environment casing to lowercase
ENVIRONMENT="${ENVIRONMENT:-development}"
ENVIRONMENT="${ENVIRONMENT,,}"

AWS_REGION="${AWS_REGION:-ap-south-1}"
DB_PORT="${DB_PORT:-5432}"

# ------------------------------------------------------------------------------
# 2. MANDATORY ENVIRONMENT ASSERTIONS (:?)
# ------------------------------------------------------------------------------
: "${S3_BUCKET:?Pre-Flight Failure: S3_BUCKET is required.}"
: "${DB_HOST:?Pre-Flight Failure: DB_HOST is required.}"
: "${DB_NAME:?Pre-Flight Failure: DB_NAME is required.}"
: "${DB_USER:?Pre-Flight Failure: DB_USER is required.}"
: "${DB_PASSWORD:?Pre-Flight Failure: DB_PASSWORD is required.}"

# ------------------------------------------------------------------------------
# 3. ENVIRONMENT TARGET VALIDATION
# ------------------------------------------------------------------------------
case "$ENVIRONMENT" in
    development|staging|production)
        # Valid environment target
        ;;
    *)
        echo "========================================================" >&2
        echo "[FAIL] Pre-Flight Error: Invalid environment '$ENVIRONMENT'" >&2
        echo "       Allowed targets: development, staging, production" >&2
        echo "========================================================" >&2
        exit 1
        ;;
esac

# ------------------------------------------------------------------------------
# 4. DATABASE PORT NUMERIC & RANGE VALIDATION
# ------------------------------------------------------------------------------
if [[ ! "$DB_PORT" =~ ^[0-9]{1,5}$ ]]; then
    echo "[FAIL] Pre-Flight Error: DB_PORT must be numeric (Received: '$DB_PORT')" >&2
    exit 1
fi

# Force base-10 arithmetic evaluation to prevent octal traps with leading zeros
if (( 10#$DB_PORT < 1 || 10#$DB_PORT > 65535 )); then
    echo "[FAIL] Pre-Flight Error: DB_PORT must be between 1 and 65535 (Received: '$DB_PORT')" >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 5. STRING LENGTH RESTRICTIONS (${#var})
# ------------------------------------------------------------------------------
if (( ${#APP_NAME} < 3 )); then
    echo "[FAIL] Pre-Flight Error: APP_NAME '${APP_NAME}' is too short (Minimum 3 characters)." >&2
    exit 1
fi

if (( ${#DB_PASSWORD} < 8 )); then
    echo "[FAIL] Pre-Flight Error: DB_PASSWORD must be at least 8 characters in length." >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 6. SANITIZED CONFIGURATION REPORT
# ------------------------------------------------------------------------------
echo
echo "=================================================================="
echo "              ENVIRONMENT VALIDATION REPORT                      "
echo "=================================================================="
echo "  [PASS] Application Name  : ${APP_NAME}"
echo "  [PASS] Target Environment: ${ENVIRONMENT}"
echo "  [PASS] AWS Region        : ${AWS_REGION}"
echo "  [PASS] Backup S3 Bucket  : ${S3_BUCKET}"
echo "  [PASS] Database Host     : ${DB_HOST}"
echo "  [PASS] Database Name     : ${DB_NAME}"
echo "  [PASS] Database User     : ${DB_USER}"
echo "  [PASS] Database Port     : ${DB_PORT}"
echo "  [PASS] Database Password : [PRESENT & REDACTED - ${#DB_PASSWORD} CHARACTERS]"
echo "------------------------------------------------------------------"
echo "  STATUS: ALL MANDATORY PRE-FLIGHT CHECKS PASSED SUCCESSFULLY    "
echo "=================================================================="
echo

exit 0
