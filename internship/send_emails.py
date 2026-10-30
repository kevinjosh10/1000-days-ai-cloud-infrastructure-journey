#!/usr/bin/env python3
"""
Cold Email Dispatch Engine for Cloud Engineering Internships
Author: Kevin Joshua L
"""

import os
import sys
import json
import time
import smtplib
import argparse
from datetime import datetime
from email.message import EmailMessage

# Force UTF-8 on Windows consoles
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(BASE_DIR)
CAMPAIGN_FILE = os.path.join(BASE_DIR, "campaign.json")
RESUME_FILE = os.path.join(REPO_ROOT, "certs", "Kevin_Joshua_Resume.pdf")

# Credentials
DEFAULT_SENDER = "lkevinjosh10@gmail.com"
DEFAULT_APP_PASS = "uhvbiywekehklrbh"


def load_campaign():
    if not os.path.exists(CAMPAIGN_FILE):
        print(f"[-] Campaign file not found at {CAMPAIGN_FILE}")
        sys.exit(1)
    with open(CAMPAIGN_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def save_campaign(campaign_data):
    with open(CAMPAIGN_FILE, "w", encoding="utf-8") as f:
        json.dump(campaign_data, f, indent=2)


def create_email_message(sender_email, to_email, subject, body, attachment_path):
    msg = EmailMessage()
    msg["From"] = f"Kevin Joshua L <{sender_email}>"
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.set_content(body)

    if attachment_path and os.path.exists(attachment_path):
        with open(attachment_path, "rb") as f:
            file_data = f.read()
            file_name = os.path.basename(attachment_path)
            msg.add_attachment(
                file_data,
                maintype="application",
                subtype="pdf",
                filename="Kevin_Joshua_Resume.pdf",
            )
    else:
        print(f"[!] Warning: Attachment not found at {attachment_path}")

    return msg


def send_email_smtp(server, msg):
    server.send_message(msg)


def run_campaign(test_mode=False, target_id=None, delay_seconds=45):
    campaign = load_campaign()
    sender_email = os.environ.get("GMAIL_USER", DEFAULT_SENDER)
    app_password = os.environ.get("GMAIL_APP_PASS", DEFAULT_APP_PASS).replace(" ", "")

    print("=" * 65)
    print("🚀 CLOUD INTERNSHIP OUTREACH ENGINE")
    print(f"👤 Sender: {sender_email}")
    print(f"📎 Resume: {RESUME_FILE}")
    print(f"🧪 Mode: {'TEST (Sending only to ' + sender_email + ')' if test_mode else 'LIVE'}")
    print("=" * 65)

    try:
        print("[*] Connecting to smtp.gmail.com:465 (SSL)...")
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(sender_email, app_password)
            print("[+] Authenticated successfully with Gmail SMTP.\n")

            leads_to_process = []
            if test_mode:
                first_lead = campaign[0]
                leads_to_process = [{
                    "id": "test_lead",
                    "company_name": f"TEST PREVIEW ({first_lead['company_name']})",
                    "recipient_email": sender_email,
                    "subject": f"[TEST PREVIEW] {first_lead['subject']}",
                    "body": first_lead["body"],
                    "status": "pending"
                }]
            elif target_id:
                leads_to_process = [l for l in campaign if l["id"] == target_id]
                if not leads_to_process:
                    print(f"[-] No lead found matching ID: {target_id}")
                    return
            else:
                leads_to_process = [l for l in campaign if l.get("status") != "sent"]

            print(f"[*] Total emails to dispatch: {len(leads_to_process)}\n")

            for idx, lead in enumerate(leads_to_process):
                company = lead["company_name"]
                recipient = lead["recipient_email"]
                subject = lead["subject"]
                body = lead["body"]

                print(f"[{idx + 1}/{len(leads_to_process)}] Sending to {company} ({recipient})...")
                msg = create_email_message(sender_email, recipient, subject, body, RESUME_FILE)

                try:
                    send_email_smtp(server, msg)
                    print(f"  [✓] Delivered successfully to {recipient}!")
                    
                    if not test_mode:
                        for original_lead in campaign:
                            if original_lead["id"] == lead["id"]:
                                original_lead["status"] = "sent"
                                original_lead["sent_at"] = datetime.now().isoformat()
                        save_campaign(campaign)
                except Exception as ex:
                    print(f"  [✗] Failed to deliver: {ex}")
                    if not test_mode:
                        for original_lead in campaign:
                            if original_lead["id"] == lead["id"]:
                                original_lead["status"] = f"failed: {str(ex)}"
                        save_campaign(campaign)

                # Wait between emails to maintain sender reputation
                if idx < len(leads_to_process) - 1 and not test_mode:
                    print(f"  [⏳] Cooling down for {delay_seconds} seconds to ensure safe deliverability...")
                    time.sleep(delay_seconds)

            print("\n[+] Campaign process finished.")

    except Exception as e:
        print(f"[-] Critical SMTP error: {e}")


def main():
    parser = argparse.ArgumentParser(description="Cold Outreach Engine for Cloud Internships")
    parser.add_argument("--test", action="store_true", help="Send a preview test email to yourself")
    parser.add_argument("--send-all", action="store_true", help="Send to all pending companies in campaign.json")
    parser.add_argument("--send-one", type=str, help="Send to a specific company ID (e.g. 1cloudhub, vembu)")
    parser.add_argument("--status", action="store_true", help="View current campaign status")
    parser.add_argument("--delay", type=int, default=45, help="Delay in seconds between emails (default: 45)")

    args = parser.parse_args()

    if args.status:
        campaign = load_campaign()
        print("\n📊 CURRENT CAMPAIGN STATUS:\n")
        print(f"{'Company':<25} {'Recipient':<30} {'Status':<15}")
        print("-" * 70)
        for lead in campaign:
            print(f"{lead['company_name']:<25} {lead['recipient_email']:<30} {lead.get('status', 'pending'):<15}")
        print("-" * 70)
        return

    if args.test:
        run_campaign(test_mode=True)
    elif args.send_one:
        run_campaign(target_id=args.send_one, delay_seconds=args.delay)
    elif args.send_all:
        run_campaign(delay_seconds=args.delay)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
