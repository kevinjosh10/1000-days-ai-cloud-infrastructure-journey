#!/usr/bin/env bash
# ==============================================================================
# User Onboarding & Security Hardening Automation Engine
# ==============================================================================

set -euo pipefail

LOG_FILE="/var/log/onboard_user.log"
DRY_RUN=false

log() {
    local msg="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] $msg"
    if [ "$DRY_RUN" = false ]; then
        echo "[$timestamp] $msg" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

usage() {
    echo "Usage: $0 <username> <group> <public-key-path> [--dry-run]"
    exit 1
}

# Parse arguments
if [[ $# -lt 3 || $# -gt 4 ]]; then
    usage
fi

USERNAME="$1"
GROUP="$2"
PUBLIC_KEY="$3"

if [[ $# -eq 4 ]]; then
    if [[ "$4" == "--dry-run" ]]; then
        DRY_RUN=true
        log "[DRY RUN MODE ENABLED]"
    else
        usage
    fi
fi

# 1. Privilege Check
if [[ $EUID -ne 0 && "$DRY_RUN" = false ]]; then
    echo "ERROR: Run this script as root (or use --dry-run)."
    exit 1
fi

# 2. Input Validation
if ! [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "ERROR: Invalid username format '$USERNAME'."
    exit 1
fi

if [ ! -f "$PUBLIC_KEY" ]; then
    echo "ERROR: SSH public key file '$PUBLIC_KEY' does not exist."
    exit 1
fi

# 3. Group Provisioning
if ! getent group "$GROUP" > /dev/null 2>&1; then
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would create group: $GROUP"
    else
        log "Creating group: $GROUP"
        groupadd "$GROUP"
    fi
else
    log "Group '$GROUP' already exists."
fi

# 4. User Provisioning
if id "$USERNAME" >/dev/null 2>&1; then
    log "User '$USERNAME' already exists."
else
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would create user: $USERNAME with home directory /home/$USERNAME"
    else
        log "Creating user: $USERNAME"
        useradd -m -s /bin/bash "$USERNAME"
    fi
fi

# 5. Group Membership
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Would add user $USERNAME to supplementary group $GROUP"
else
    log "Adding user $USERNAME to group $GROUP"
    usermod -aG "$GROUP" "$USERNAME"
fi

# 6. SSH Hardening Setup
SSH_DIR="/home/$USERNAME/.ssh"
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Would configure SSH keys in $SSH_DIR/authorized_keys (700/600 permissions)"
else
    log "Configuring SSH key authentication for $USERNAME"
    mkdir -p "$SSH_DIR"
    cp "$PUBLIC_KEY" "$SSH_DIR/authorized_keys"
    chown -R "$USERNAME:$USERNAME" "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

# 7. Password Expiry Policy
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Would enforce 90-day password max age (-M 90) and 14-day warning (-W 14) for $USERNAME"
else
    log "Enforcing password aging policies for $USERNAME"
    chage -M 90 -W 14 "$USERNAME"
fi

# 8. Auditd Rule Configuration
AUDIT_RULE="-w /home/$USERNAME -p wa -k user_home_$USERNAME"
AUDIT_RULES_FILE="/etc/audit/rules.d/onboard_user.rules"
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Would register auditd watch rule: '$AUDIT_RULE'"
else
    log "Configuring auditd rule for /home/$USERNAME"
    mkdir -p "$(dirname "$AUDIT_RULES_FILE")"
    if ! grep -q "user_home_$USERNAME" "$AUDIT_RULES_FILE" 2>/dev/null; then
        echo "$AUDIT_RULE" >> "$AUDIT_RULES_FILE"
    fi
    if command -v augenrules >/dev/null 2>&1; then
        augenrules --load || true
    fi
fi

# 9. Sudoers Rule Configuration
SUDO_FILE="/etc/sudoers.d/$GROUP"
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Would provision sudoers rule in $SUDO_FILE with visudo syntax verification"
else
    log "Configuring least-privilege sudo rule for group $GROUP"
    TEMP_SUDO=$(mktemp)
    echo "%$GROUP ALL=(root) /usr/bin/systemctl restart nginx" > "$TEMP_SUDO"
    if visudo -cf "$TEMP_SUDO" >/dev/null 2>&1; then
        cp "$TEMP_SUDO" "$SUDO_FILE"
        chmod 0440 "$SUDO_FILE"
        rm -f "$TEMP_SUDO"
        log "Sudo rule successfully applied and verified."
    else
        rm -f "$TEMP_SUDO"
        log "ERROR: Invalid sudo syntax generated! Aborting sudo configuration."
        exit 1
    fi
fi

# 10. Summary Generation
SUMMARY_FILE="/tmp/${USERNAME}_onboarding_summary.txt"
if [ "$DRY_RUN" = true ]; then
    log "[DRY RUN] Onboarding dry-run complete. No changes made."
else
    cat > "$SUMMARY_FILE" <<EOF
============================================================
              USER ONBOARDING SUMMARY REPORT
============================================================
Timestamp:       $(date '+%Y-%m-%d %H:%M:%S')
Username:        $USERNAME
Primary/Group:   $GROUP
Home Directory:  /home/$USERNAME
Shell:           /bin/bash
SSH Auth:        Configured (/home/$USERNAME/.ssh/authorized_keys)
Password Policy: Max Age 90 days, Warning 14 days
Auditd Watch:    -w /home/$USERNAME -p wa -k user_home_$USERNAME
Sudo Privilege:  %$GROUP ALL=(root) /usr/bin/systemctl restart nginx
============================================================
EOF
    log "User onboarding completed successfully. Summary: $SUMMARY_FILE"
    cat "$SUMMARY_FILE"
fi
