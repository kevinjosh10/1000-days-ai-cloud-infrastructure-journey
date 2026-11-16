#!/usr/bin/env bash

# ==============================================================================
# Script   : 04_path_url_parser.sh
# Track    : Mastering Shell Scripting & Automation — Day 4/30
# Journey  : Day 260/1000
# Purpose  : High-Performance Pure Bash URI and Path Dissection Utility
# ==============================================================================

set -Eeuo pipefail

parse_uri() {
    local uri="${1:-}"

    local protocol=""
    local authority=""
    local domain=""
    local port=""
    local path=""
    local filename=""
    local extension=""
    local object_key=""

    # 1. Input Validation
    if [[ -z "$uri" ]]; then
        echo "Error: URI string must not be empty." >&2
        return 1
    fi

    # 2. Scheme / Protocol Extraction
    if [[ "$uri" != *"://"* ]]; then
        echo "Error: Invalid URI format. Missing '://' scheme delimiter." >&2
        return 1
    fi

    protocol="${uri%%://*}"
    local rest="${uri#*://}"

    case "$protocol" in
        http|https|s3)
            # Supported cloud schemes
            ;;
        *)
            echo "Error: Unsupported scheme '${protocol}'. Supported: http, https, s3." >&2
            return 1
            ;;
    esac

    # 3. Authority Extraction (Host / Bucket)
    # Extracts everything up to the first slash, question mark, or hash
    authority="${rest%%[/?#]*}"

    if [[ -z "$authority" ]]; then
        echo "Error: Missing host authority or S3 bucket name in URI." >&2
        return 1
    fi

    # 4. Path Extraction & Normalization
    local remaining="${rest#"$authority"}"

    # Strip query string (?) and fragment (#)
    path="${remaining%%[\?#]*}"

    # Strip leading slash for processing
    path="${path#/}"

    # 5. Domain and Port Parsing
    if [[ "$protocol" == "s3" ]]; then
        domain="$authority"
        object_key="$path"
    else
        if [[ "$authority" == *:* ]]; then
            domain="${authority%:*}"
            port="${authority##*:}"

            # Strict numeric port validation
            if [[ ! "$port" =~ ^[0-9]+$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
                echo "Error: Invalid port number '${port}' in authority." >&2
                return 1
            fi
        else
            domain="$authority"
        fi
    fi

    # 6. Filename and Extension Parsing
    filename="${path##*/}"

    # Extract extension if file has a dot and is not a hidden dotfile
    if [[ "$filename" == *.* && "$filename" != .* ]]; then
        extension="${filename##*.}"
    fi

    # 7. Formatted Diagnostic Output
    echo "=================================================================="
    echo "                     CLOUD URI PARSER REPORT                      "
    echo "=================================================================="
    echo "  Original URI  : ${uri}"
    echo "  Protocol      : ${protocol}"
    echo "  Domain/Bucket : ${domain}"
    echo "  Port          : ${port:-<None>}"
    echo "  Path          : /${path}"
    echo "  Filename      : ${filename:-<None>}"
    echo "  Extension     : ${extension:-<None>}"

    if [[ "$protocol" == "s3" ]]; then
        echo "  S3 Object Key : ${object_key}"
    fi
    echo "=================================================================="
    echo
}

# Entrypoint argument guard
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <URI>" >&2
    echo "Examples:" >&2
    echo "  $0 https://storage.example.com:8443/backups/db.sql.gz" >&2
    echo "  $0 s3://prod-company-backups/aurora/db.tar.gz" >&2
    exit 1
fi

parse_uri "$1"
