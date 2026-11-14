#!/usr/bin/env bash

# ==============================================================================
# Script: 01_quote_inspector.sh
# Track: Mastering Shell Scripting — Day 1/30
# Journey: Day 257/1000
# Topic: Shell Architecture, Process Introspection & Quoting Precision
# ==============================================================================

# Enable strict mode: treat unset variables as an error
set -u

echo "================================================================="
echo "                BASH QUOTING & PROCESS INSPECTOR                 "
echo "================================================================="

# ------------------------------------------------------------------------------
# 1. SHELL PROCESS INFORMATION
# ------------------------------------------------------------------------------
echo
echo "[1] SHELL PROCESS INTROSPECTION"
echo "-----------------------------------------------------------------"
echo "Bash Version           : $BASH_VERSION"
echo "Current Process PID    : $$"
echo "Parent Process PID     : $PPID"
echo "Script Path (\$0)       : $0"
echo "Configured Login Shell : ${SHELL:-Not Set}"

# ------------------------------------------------------------------------------
# 2. VARIABLE EXPANSION & QUOTING HIERARCHY
# ------------------------------------------------------------------------------
echo
echo "[2] VARIABLE EXPANSION & QUOTING HIERARCHY"
echo "-----------------------------------------------------------------"
USER_NAME="Kevin Joshua"

echo "Double Quotes (Interpolated) : Hello, $USER_NAME"
echo 'Single Quotes (Literal)      : Hello, $USER_NAME'

# ------------------------------------------------------------------------------
# 3. WHITESPACE PRESERVATION (WORD SPLITTING ANALYSIS)
# ------------------------------------------------------------------------------
echo
echo "[3] WHITESPACE PRESERVATION & WORD SPLITTING"
echo "-----------------------------------------------------------------"
CLOUDFILE="production kubernetes cluster backup.tar.gz"

echo "Unquoted Variable (Shell splits into 4 distinct arguments):"
printf '  Arg -> <%s>\n' $CLOUDFILE

echo
echo "Quoted Variable (Preserved as 1 distinct argument):"
printf '  Arg -> <%s>\n' "$CLOUDFILE"

# ------------------------------------------------------------------------------
# 4. ANSI-C QUOTING DEMONSTRATION
# ------------------------------------------------------------------------------
echo
echo "[4] ANSI-C QUOTING (\$'...')"
echo "-----------------------------------------------------------------"
printf '  Newline Demo  : %s\n' $'Row1\nRow2'
printf '  Tabular Demo  : %s\n' $'Field1\tField2\tField3'
printf '  Hex Byte Demo : %s\n' $'Cloud: \x41\x57\x53'

# ------------------------------------------------------------------------------
# 5. COMMAND SUBSTITUTION & NESTING
# ------------------------------------------------------------------------------
echo
echo "[5] COMMAND SUBSTITUTION"
echo "-----------------------------------------------------------------"
CURRENT_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
HOSTNAME_RESOLVED=$(hostname)
CURRENT_EPOCH=$(date +%s)

echo "Current Timestamp : $CURRENT_TIMESTAMP"
echo "Resolved Hostname : $HOSTNAME_RESOLVED"
echo "Current Unix Epoch: $CURRENT_EPOCH"

# Nested modern command substitution
NESTED_EXAMPLE=$(echo "Kernel Release: $(uname -r)")
echo "Nested Evaluation : $NESTED_EXAMPLE"

# ------------------------------------------------------------------------------
# 6. ARITHMETIC EXPANSION
# ------------------------------------------------------------------------------
echo
echo "[6] ARITHMETIC EXPANSION (\$(( ... )))"
echo "-----------------------------------------------------------------"
CPU_TOTAL=$(nproc)
BUFFER_POOL=$(( CPU_TOTAL * 4 ))

echo "CPU Total Detected : $CPU_TOTAL"
echo "Calculated Threads : $BUFFER_POOL"

# ------------------------------------------------------------------------------
# 7. SUBSHELL VS. CURRENT SHELL VARIABLE ISOLATION
# ------------------------------------------------------------------------------
echo
echo "[7] SUBSHELL PROCESS ISOLATION"
echo "-----------------------------------------------------------------"
ISOLATION_VAR="Original-Parent-State"

echo "Parent State Before Subshell : $ISOLATION_VAR"

# Execute in subshell via parentheses (...)
(
    ISOLATION_VAR="Mutated-Inside-Subshell"
    echo "State Inside Subshell (PID: $$) : $ISOLATION_VAR"
)

echo "Parent State After Subshell  : $ISOLATION_VAR (Unchanged!)"

# ------------------------------------------------------------------------------
# 8. COMMAND SUBSTITUTION SUBSHELL ISOLATION
# ------------------------------------------------------------------------------
echo
echo "[8] COMMAND SUBSTITUTION ISOLATION"
echo "-----------------------------------------------------------------"
RESULT_PAYLOAD=$(
    ISOLATION_VAR="Mutated-Inside-Command-Sub"
    echo "Subshell Generated Output"
)

echo "Captured Output : $RESULT_PAYLOAD"
echo "Parent Variable : $ISOLATION_VAR (Still Unchanged!)"

echo
echo "================================================================="
echo "                  INSPECTION SCRIPT COMPLETED                    "
echo "================================================================="
