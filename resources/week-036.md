# Week 36 Resources: Cloud Networking: Transport Protocols, HTTP Evolution, TLS & Edge Load Balancing

## 📅 Timeline: Days 246 - 252 (November 2, 2026 – November 8, 2026)

---

## Day 246 / 1000 – TCP Performance and MTU
- **Date:** November 2, 2026 (Calendar: November 2, 2026 (Monday))

```text
                  Normal vs. Retransmission Scenarios

      [ NORMAL TRANSMISSION ]                  [ RETRANSMISSION TIMEOUT (RTO) ]
  Sender                  Receiver         Sender                  Receiver
    │                        │               │                        │
    │── Segment 1 (SEQ=1000)►│               │── Segment 1 (SEQ=1000)►│
    │                        │               │                        │ (Packet Dropped!)
    │◄── ACK 1500 ───────────│               │   X (Lost in transit)  │
    │                        │               │                        │
    ▼                        ▼               │ [ RTO Timer Expires! ] │
                                             │── Segment 1 (SEQ=1000)►│ (Retransmit!)
                                             │                        │
                                             │◄── ACK 1500 ───────────│
```

```text
                        Fast Retransmit in Action
  Sender                                                 Receiver
    │                                                       │
    │── Segment 1 (Bytes 1-1000) ──────────────────────────►│
    │── Segment 2 (Bytes 1001-2000) ──X (Dropped!)          │
    │── Segment 3 (Bytes 2001-3000) ───────────────────────►│ (Out of order!)
    │◄── Duplicate ACK 1001 (1st Dup ACK) ──────────────────│
    │── Segment 4 (Bytes 3001-4000) ───────────────────────►│ (Out of order!)
    │◄── Duplicate ACK 1001 (2nd Dup ACK) ──────────────────│
    │── Segment 5 (Bytes 4001-5000) ───────────────────────►│ (Out of order!)
    │◄── Duplicate ACK 1001 (3rd Dup ACK) ──────────────────│
    │                                                       │
    ▼ [ 3 Duplicate ACKs Received! ]                        │
    │── FAST RETRANSMIT: Segment 2 (Bytes 1001-2000) ──────►│
    │                                                       │
    │◄── Cumulative ACK 5001 (All bytes received!) ─────────│
```

```text
ACK = 1001
SACK Block 1: [2001 - 3000]
SACK Block 2: [4001 - 5000]
```

```text
                           TCP Sliding Window Buffer
 ┌───────────────────────┬───────────────────────┬───────────────────────┐
 │   Sent and ACKed      │  Sent, Not Yet ACKed  │   Usable / Can Send   │
 │   (Can be purged)     │  (Window in flight)   │   (Within Window)     │
 └───────────────────────┴───────────────────────┴───────────────────────┘
                         ▲                       ▲                       ▲
                         │                       │                       │
                    Window Left             Current SEQ             Window Right
                   (Last ACKed)                                    (Limit of Send Window)
```

```text
┌───────────────────────────────────────┬───────────────────────────────────────┐
│        Flow Control (`rwnd`)          │      Congestion Control (`cwnd`)      │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ Protects the **Receiver Host**.       │ Protects the **Intermediate Network** │
│ Prevents receiver buffer overflow.    │ Prevents router queue drops & latency.│
│ Advertised explicitly in TCP headers. │ Maintained locally inside sender OS.  │
│ Dictated by application read speed.   │ Dictated by packet loss and RTT delay.│
└───────────────────────────────────────┴───────────────────────────────────────┘
```

```text
                    TCP Congestion Window Lifecycle (AIMD)
      cwnd (MSS)
          ▲
       32 │                     /\                      /\
          │                    /  \                    /  \
       16 │      Slow Start   /    \ Congestion       /    \
          │        (Exp)     /      \ Avoidance      /      \
        8 │                 / ssthresh\ (Linear)    / ssthresh
          │       /\       /           \           /
        4 │      /  \     /             \         /
        2 │     /    \   /               \       /
        1 │    /      \ /                 \     /
          └───┴────────┴───────────────────┴───┴────────────────► Time
```

```text
┌─────────────────┬─────────────────┬───────────────────────────────────────────┐
│ Algorithm       │ Loss Model      │ Key Characteristics                       │
├─────────────────┼─────────────────┼───────────────────────────────────────────┤
│ **Reno**        │ Packet Loss     │ Classic AIMD algorithm; reactive loss.    │
│ **CUBIC**       │ Packet Loss     │ Default Linux algorithm since 2.6.19.     │
│                 │                 │ Uses cubic function for high-BDP links.   │
│ **BBR**         │ Delay / Latency │ Developed by Google. Models bottleneck    │
│ (v1 / v2 / v3)  │ & Bandwidth     │ bandwidth and min RTT; ignores random loss│
└─────────────────┴─────────────────┴───────────────────────────────────────────┘
```

```text
                  MTU vs. MSS Encapsulation Breakdown
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ Ethernet Frame (1518 Bytes)                                                 │
 ├─────────────────┬───────────────────────────────────────────────────────────┤
 │ Ethernet Header │ IP Packet / MTU (1500 Bytes)                              │
 │ (14 Bytes)      ├─────────────────┬─────────────────────────────────────────┤
 │                 │ IPv4 Header     │ TCP Segment (1480 Bytes)                │
 │                 │ (20 Bytes)      ├─────────────────┬───────────────────────┤
 │                 │                 │ TCP Header      │ TCP Payload / MSS     │
 │                 │                 │ (20 Bytes)      │ (1460 Bytes)          │
 └─────────────────┴─────────────────┴─────────────────┴───────────────────────┘
```

```text
                        Path MTU Discovery (PMTUD) Flow
  EC2 Instance A (MTU 1500)            Router X (MTU 1400)            EC2 Instance B
        │                                      │                            │
        │── 1500B Packet (DF=1) ──────────────►│                            │
        │                                      │ (Cannot forward 1500B      │
        │                                      │  over 1400B link; DF=1)    │
        │                                      │ [ Drops Packet! ]          │
        │◄── ICMP Type 3 Code 4 ───────────────┤                            │
        │    "Fragmentation Needed,            │                            │
        │     Next-Hop MTU = 1400"             │                            │
        │                                      │                            │
        ▼ [ Sender learns PMTU = 1400B ]       │                            │
        │── 1400B Packet (DF=1) ──────────────►│── 1400B Packet (DF=1) ─────►│
```

```text
Original Packet (1500 Bytes):
┌─────────────────────────┬─────────────────────────┬─────────────────────────┐
│ IPv4 Header (20 Bytes)  │ TCP Header (20 Bytes)   │ TCP Payload (1460 Bytes)│
└─────────────────────────┴─────────────────────────┴─────────────────────────┘
                                       │
                Encapsulated by IPsec / VXLAN Tunnel
                                       ▼
Encapsulated Tunnel Packet:
┌─────────────────┬─────────────────┬─────────────────────────────────────────┐
│ Outer IP Header │ Tunnel Overhead │ Original 1500-Byte Packet               │
│ (20 Bytes)      │ (30 to 50 Bytes)│ (20B IP + 20B TCP + 1460B Payload)      │
└─────────────────┴─────────────────┴─────────────────────────────────────────┘
│◄─────────────────────── TOTAL: 1550 to 1570 Bytes! ────────────────────────►│
```

```text
                               The MTU Black Hole
  Client Workstation                    Transit / Firewall                 Web Server
        │                                      │                                │
        │── 1. TCP 3-Way Handshake (SYN/ACK) ─►│───────────────────────────────►│ (Works! 60B)
        │◄── Handshake Complete ───────────────│◄───────────────────────────────│
        │── 2. Small HTTP GET /api/v1/user ───►│───────────────────────────────►│ (Works! 300B)
        │◄── HTTP 200 OK (Small JSON) ─────────│◄───────────────────────────────│
        │                                      │                                │
        │── 3. File Upload / Large POST ──────►│                                │
        │      (1500B Packet with DF=1)        │ [ Intermediate MTU: 1420B ]    │
        │                                      │ [ Drops Packet! ]              │
        │                                      │ [ Attempts ICMP Type 3 Code 4 ]│
        │                                      │   X (Blocked by Firewall!)     │
        │                                      │                                │
        ▼                                      ▼                                ▼
   SENDER WAITS FOR ACK... NEVER ARRIVES! (Connection HANGS indefinitely!)
```

```bash
   # Linux iptables MSS Clamping Rule
   iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
   ```

```bash
# Display MTU for all network interfaces (e.g., eth0, ens5, cni0)
ip link show

# Detailed interface view with IP addresses
ip addr show
```

```bash
# 1. Test 1472-byte payload:
# 1472 (ICMP data) + 8 (ICMP header) + 20 (IPv4 header) = Exactly 1500 Bytes!
ping -M do -s 1472 -c 2 8.8.8.8

# 2. Test 1473-byte payload:
# 1473 + 8 + 20 = 1501 Bytes (Exceeds 1500 MTU!)
ping -M do -s 1473 -c 2 8.8.8.8
```

```text
ping: local error: message too long, mtu=1500
```

```bash
# Install tracepath utility
sudo apt update && sudo apt install iputils-tracepath -y

# Trace path MTU to an external destination
tracepath 8.8.8.8
```

```bash
# View live TCP socket internals (RTT, cwnd, ssthresh, retransmissions)
ss -ti
```

```bash
# Capture TCP packets showing flags and sequence numbers
sudo tcpdump -i any -nn "tcp[tcpflags] & (tcp-syn|tcp-fin|tcp-rst) != 0"

# Filter specifically for retransmissions or duplicate packets
sudo tcpdump -i any -nn "tcp and (tcp[13] & 0x10 != 0)" -c 20
```

```bash
#!/bin/bash
# ==============================================================================
# Script: linux-network-diagnostics.sh
# Purpose: Comprehensive auditing of network interfaces, MTU configuration,
#          TCP socket parameters, and congestion control algorithms.
# ==============================================================================

set -euo pipefail

echo "=========================================================="
echo "          LINUX NETWORK & MTU PERFORMANCE AUDITOR        "
echo "                      Day 246 / 1000                      "
echo "=========================================================="
echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "Kernel:    $(uname -r)"
echo ""

echo "--- [1] NETWORK INTERFACE MTU CONFIGURATION ---"
printf "%-12s %-8s %-12s %-15s\n" "INTERFACE" "MTU" "STATE" "MAC ADDRESS"
printf "%-12s %-8s %-12s %-15s\n" "------------" "------" "------------" "---------------"
ip -o link show | awk -F': ' '{print $2}' | while read -r iface; do
    MTU=$(cat /sys/class/net/"$iface"/mtu 2>/dev/null || echo "N/A")
    OPERSTATE=$(cat /sys/class/net/"$iface"/operstate 2>/dev/null || echo "N/A")
    MAC=$(cat /sys/class/net/"$iface"/address 2>/dev/null || echo "N/A")
    printf "%-12s %-8s %-12s %-15s\n" "$iface" "$MTU" "$OPERSTATE" "$MAC"
done
echo ""

echo "--- [2] TCP CONGESTION CONTROL ALGORITHMS ---"
echo "Current Algorithm:   $(sysctl -n net.ipv4.tcp_congestion_control)"
echo "Available In Kernel: $(sysctl -n net.ipv4.tcp_available_congestion_control)"
echo ""

echo "--- [3] TCP MEMORY & BUFFER TUNING (min / default / max) ---"
echo "TCP Read Buffers (tcp_rmem):   $(sysctl -n net.ipv4.tcp_rmem)"
echo "TCP Write Buffers (tcp_wmem):  $(sysctl -n net.ipv4.tcp_wmem)"
echo ""

echo "--- [4] LIVE TCP SOCKET PERFORMANCE SAMPLE ---"
# Displays RTT and cwnd for top 5 active established TCP sockets
ss -tin state established | head -n 12
echo ""

echo "--- [5] INTERFACE DROP AND ERROR STATISTICS ---"
ip -s link | grep -E "^[0-9]+:|RX:|TX:|errors|dropped"
echo ""

echo "--- [6] PATH MTU REACHABILITY TEST (8.8.8.8) ---"
if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo "Pinging 8.8.8.8 with 1472-byte payload (DF=1)..."
    if ping -M do -s 1472 -c 2 8.8.8.8 >/dev/null 2>&1; then
        echo ">> [SUCCESS]: Standard 1500-byte Path MTU verified (1472 + 28 = 1500B)."
    else
        echo ">> [WARNING]: 1472-byte payload dropped. Path MTU is less than 1500 bytes!"
    fi
else
    echo ">> [SKIPPED]: Outbound ping unreachable or ICMP blocked."
fi

echo ""
echo "=========================================================="
echo "                Diagnostics Completed                     "
echo "=========================================================="
```

---

## Day 247 / 1000 – UDP and Stateless Protocols
- **Date:** November 3, 2026 (Calendar: November 3, 2026 (Tuesday))

```text
                  TCP vs. UDP Transmission Model

      [ TCP: Connection-Oriented ]                 [ UDP: Connectionless ]
  Client                     Server            Client                     Server
    │                           │                │                           │
    │── 3-Way Handshake ───────►│                │── Datagram 1 (Port 5000)─►│
    │◄── SYN-ACK ───────────────│                │── Datagram 2 (Port 5000)─►│
    │── ACK ───────────────────►│                │── Datagram 3 (Port 5000)─►│
    │                           │                │                           │
    │── Data Segment 1 ────────►│                * No handshake latency
    │◄── ACK 1 ─────────────────│                * Zero state maintained
    │                           │                * Packets processed on arrival
```

```text
                     UDP Datagram Structure (RFC 768)
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|            Length             |           Checksum            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
|                       Application Data                        |
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

```text
                           UDP Ecosystem Map
                                  [ UDP ]
                                     │
      ┌──────────────┬───────────────┼───────────────┬──────────────┐
      ▼              ▼               ▼               ▼              ▼
   [ DNS ]        [ DHCP ]        [ NTP ]         [ VoIP ]       [ QUIC ]
   Port 53        Port 67/68      Port 123        RTP/SRTP       Port 443
  Name Lookup   IP Provisioning Clock Sync      Voice/Video       HTTP/3
```

```text
                   The DHCP DORA Process (Over UDP)
  Booting Client (0.0.0.0)                         DHCP Server (10.0.0.1)
        │                                                    │
        │── 1. DHCPDISCOVER (Broadcast UDP 67) ─────────────►│
        │◄── 2. DHCPOFFER (Unicast/Broadcast UDP 68) ────────│
        │── 3. DHCPREQUEST (Broadcast UDP 67) ──────────────►│
        │◄── 4. DHCPACK (Allocation Confirmed UDP 68) ───────│
```

```text
UDP Transmission: Zero Retransmission
  Sender Transmits 100 Datagrams
   [1] [2] [3] ... [95] ... [100]
            │
            ▼ (Transit through lossy link)
   Dropped: [12] [44] [67] [89] [91]
            │
            ▼
  Receiver Collects: 95 Datagrams
  * UDP kernel does NOT notify sender.
  * UDP kernel does NOT request retransmission.
```

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│ Application-Layer Protocol (e.g., QUIC, Game Engine, TFTP)                  │
│ [ Sequence Numbers ] [ ACKs / NACKs ] [ Loss Recovery ] [ Jitter Buffering ]│
├─────────────────────────────────────────────────────────────────────────────┤
│ User Datagram Protocol (UDP): Raw, fast, 8-byte datagram transport          │
├─────────────────────────────────────────────────────────────────────────────┤
│ Internet Protocol (IP): Best-effort packet routing                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

```text
                    AWS UDP Load Balancing Architecture
                          Global Gaming Clients
                                    │
                                    ▼ (UDP Traffic on Port 5000)
                     [ AWS Network Load Balancer ]
                        (Ultra-low latency Layer 4)
                                    │
                 ┌──────────────────┼──────────────────┐
                 ▼                  ▼                  ▼
          ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
          │ Game Node 1 │    │ Game Node 2 │    │ Game Node 3 │
          │ 10.0.1.10   │    │ 10.0.2.10   │    │ 10.0.3.10   │
          └─────────────┘    └─────────────┘    └─────────────┘
```

```text
               Security Group (Stateful) vs. NACL (Stateless)

       [ STATEFUL SECURITY GROUP ]                 [ STATELESS NETWORK ACL ]
  Inbound UDP 5000: ALLOW                     Inbound UDP 5000: ALLOW
         │                                           │
         ▼                                           ▼
  ┌─────────────┐                             ┌─────────────┐
  │ EC2 Server  │                             │ EC2 Server  │
  └──────┬──────┘                             └──────┬──────┘
         │                                           │
  Outbound: AUTOMATICALLY PERMITTED!          Outbound Ephemeral (1024-65535):
  (State table tracks returning flow)         MUST EXPLICITLY ALLOW IN RULES!
                                              (Otherwise return packet is DROPPED)
```

```text
           TCP Head-of-Line Blocking vs. QUIC Independent Streams

  [ HTTP/2 over TCP: 1 Dropped Packet Freezes Everything! ]
  Stream A: [P1] [P2 (LOST!)]  ──► Entire Connection BLOCKED!
  Stream B: [P1] [P2] ──────────► (Waiting in queue...)
  Stream C: [P1] [P2] ──────────► (Waiting in queue...)

  [ HTTP/3 over QUIC: Independent Streams over UDP ]
  Stream A: [P1] [P2 (LOST!)]  ──► Only Stream A waits for recovery!
  Stream B: [P1] [P2] ──────────► Delivered immediately to App!
  Stream C: [P1] [P2] ──────────► Delivered immediately to App!
```

```bash
# 1. Display all UDP sockets (both active and listening)
ss -u -a

# 2. Display UDP listening sockets with numerical port resolution
ss -uln

# 3. Display process names, PIDs, and users bound to UDP sockets
sudo ss -ulpn
```

```bash
# Inspect whether systemd-resolved, dnsmasq, or named is listening on UDP 53
sudo ss -ulnp | grep ':53'
```

```bash
sudo tcpdump -i any -nn udp port 53
```

```bash
nslookup google.com
```

```text
IP 192.168.1.50.53421 > 8.8.8.8.53: 12345+ A? google.com. (28)
IP 8.8.8.8.53 > 192.168.1.50.53421: 12345 1/0/0 A 142.250.190.46 (44)
```

```bash
# Monitor background NTP/Chrony synchronization datagrams
sudo tcpdump -i any -nn udp port 123
```

```bash
nc -u -l 5000
```

```bash
nc -u 127.0.0.1 5000
```

```text
                       Production Gaming Cloud Architecture
                             Route 53 Latency Routing
                                        │
                                        ▼
                         [ AWS Global Accelerator ]
                    (Static Anycast IPs -> AWS Backbone)
                                        │
                                        ▼
                         [ Network Load Balancer ]
                           (UDP Listener: 5000)
                                        │
                 ┌──────────────────────┼──────────────────────┐
                 ▼                      ▼                      ▼
        ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
        │ Game Server 1   │    │ Game Server 2   │    │ Game Server 3   │
        │ EC2 (ap-south-1)│    │ EC2 (ap-south-1)│    │ EC2 (ap-south-1)│
        └─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## Day 248 — Day 22: HTTP Semantics for Infrastructure
- **Date:** November 4, 2026 (Calendar: November 4, 2026 (Wednesday))

```text
                           HTTP Request-Response Lifecycle
 ┌──────────────┐         1. HTTP Request (GET /users/101)        ┌────────────────────────┐
 │ Web Browser  │ ───────────────────────────────────────────────►│ Application Load       │
 │ / Client     │ ◄───────────────────────────────────────────────│ Balancer (ALB)         │
 └──────────────┘         7. HTTP Response (200 OK + JSON)        └───────────┬────────────┘
                                                                              │
                                                                   2. Route   │ 3. Forward
                                                                              ▼
                                                                  ┌────────────────────────┐
                                                                  │ EC2 / EKS Backend Pod  │
                                                                  │ (Processes Request)    │
                                                                  └────────────────────────┘
```

```http
POST /api/v1/orders HTTP/1.1
Host: api.example.com
User-Agent: curl/8.4.0
Content-Type: application/json
Content-Length: 48
Authorization: Bearer eyJhbGciOi...
Accept: application/json

{"item_id": "laptop-101", "quantity": 1}
```

```http
HTTP/1.1 201 Created
Date: Wed, 04 Nov 2026 10:00:00 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 62
Connection: keep-alive
Location: /api/v1/orders/ord-98765

{"order_id": "ord-98765", "status": "confirmed"}
```

```text
┌───────────────────────────────────────┬───────────────────────────────────────┐
│              Safe Method              │           Idempotent Method           │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ Does not alter server state.          │ Repeating the request $N$ times has   │
│ Read-only operations.                 │ the same intended effect as 1 time.   │
│ Examples: `GET`, `HEAD`, `OPTIONS`    │ Examples: `GET`, `PUT`, `DELETE`      │
└───────────────────────────────────────┴───────────────────────────────────────┘
```

```text
               The Blind Network Retry Problem
 Client Application                           Payment Gateway
        │                                            │
        │── 1. POST /payments ($500) ───────────────►│
        │                                            │ (Charge processed!)
        │                                            │ (Transmits 200 OK)
        │       X (Wi-Fi Drops! Response Lost!)      │
        ▼                                            │
 [ Client Timeout! ]                                 │
        │                                            │
        │── 2. Automatic Retry: POST /payments ─────►│
        │                                            │ (Processed AGAIN!)
        ▼                                            ▼
 RESULT: Customer charged $1,000 instead of $500!
```

```http
POST /api/v1/payments HTTP/1.1
Host: api.stripe.com
Idempotency-Key: 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d
Content-Type: application/json

{"amount": 5000, "currency": "usd"}
```

```text
                   Idempotency Key Resolution Flow
                  Client sends POST + Idempotency-Key
                                   │
                                   ▼
                   ┌───────────────────────────────┐
                   │ Check Distributed Key-Value   │
                   │ Store (Redis / DynamoDB)      │
                   └───────────────┬───────────────┘
                                   │
                 ┌─────────────────┴─────────────────┐
                 ▼ (Key Not Found)                   ▼ (Key Already Exists!)
       Process payment transaction.            Bypass business logic.
       Store response in Redis.                Return stored original response
       Return 200 OK.                          (200 OK) immediately!
```

```text
  1xx: Informational (Request received, continuing)
  2xx: Success (Request processed successfully)
  3xx: Redirection (Further action required by client)
  4xx: Client Error (Invalid request, unauthorized, not found)
  5xx: Server Error (Server or upstream proxy failed)
```

```text
                  Load Balancer Error Origin Isolation
                            Client Request
                                  │
                                  ▼
                     [ Application Load Balancer ]
                                  │
         ┌────────────────────────┼────────────────────────┐
         ▼                        ▼                        ▼
    [ 502 Bad Gateway ]      [ 503 Unavailable ]      [ 504 Timeout ]
  Target connected, but    Zero healthy targets     Connected to target,
  returned malformed data  in target group. Pool    but target took too
  or reset TCP connection  exhausted or draining.   long to respond (>30s)
```

```text
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ Host: shop.example.com ─────────────► Used for ALB Host-Based Routing       │
 │ X-Forwarded-For: 203.0.113.25 ──────► Preserves Client IP through Proxies   │
 │ X-Forwarded-Proto: https ───────────► Prevents Insecure Redirect Loops      │
 │ Cache-Control: public, max-age=3600 ► Instructs CloudFront CDN Caching      │
 │ Connection: keep-alive ─────────────► Recycles TCP Sockets across Requests  │
 └─────────────────────────────────────────────────────────────────────────────┘
```

```http
  X-Forwarded-For: <client_ip>, <proxy1_ip>, <proxy2_ip>
  ```

```text
Without Keep-Alive (Severe Latency Tax):
Req 1: [SYN] ──► [SYN-ACK] ──► [ACK] ──► [TLS Handshake] ──► [GET /index.html] ──► [FIN/ACK]
Req 2: [SYN] ──► [SYN-ACK] ──► [ACK] ──► [TLS Handshake] ──► [GET /style.css]   ──► [FIN/ACK]
Req 3: [SYN] ──► [SYN-ACK] ──► [ACK] ──► [TLS Handshake] ──► [GET /app.js]      ──► [FIN/ACK]

With HTTP Keep-Alive (Connection Reuse):
Setup: [SYN] ──► [SYN-ACK] ──► [ACK] ──► [TLS Handshake]
Req 1: ──► [GET /index.html] ──► (200 OK)
Req 2: ──► [GET /style.css]   ──► (200 OK)  [ Reuses Same TCP Socket! ]
Req 3: ──► [GET /app.js]      ──► (200 OK)
```

```text
┌─────────────────┬─────────────────┬───────────────────────────────────────────┐
│ Protocol        │ Transport       │ Multiplexing & Connection Architecture    │
├─────────────────┼─────────────────┼───────────────────────────────────────────┤
│ **HTTP/1.1**    │ TCP             │ Sequential request-response over pooled   │
│                 │                 │ connections. Suffers from HTTP HoL block. │
│ **HTTP/2**      │ TCP             │ Concurrent binary streams multiplexed over│
│                 │                 │ single TCP socket. Suffers from TCP HoL.  │
│ **HTTP/3**      │ QUIC (over UDP) │ Concurrent streams over independent QUIC  │
│                 │                 │ frames. Zero Head-of-Line blocking!       │
└─────────────────┴─────────────────┴───────────────────────────────────────────┘
```

```text
                       Production E-Commerce Flow
                       User Browser in New York
                                  │
                                  ▼ 1. DNS: shop.example.com
                      [ Amazon Route 53 (DNS) ]
                                  │
                                  ▼ 2. Anycast Edge IP
                    [ Amazon CloudFront (CDN) ]
                  (Edge Cache: Images & CSS Served)
                                  │ 3. Cache Miss (Forward to Origin)
                                  ▼
                 [ Application Load Balancer (ALB) ]
                  (Terminates TLS, evaluates Host)
                                  │
                                  ▼ 4. Injects XFF, X-Forwarded-Proto
                 ┌────────────────┴────────────────┐
                 ▼                                 ▼
       ┌───────────────────┐             ┌───────────────────┐
       │ EC2 / EKS Pod 1   │             │ EC2 / EKS Pod 2   │
       │ (Spring Boot/Go)  │             │ (Spring Boot/Go)  │
       └─────────┬─────────┘             └─────────┬─────────┘
                 │                                 │
                 └────────────────┬────────────────┘
                                  ▼ 5. Query
                     [ Amazon Aurora PostgreSQL ]
```

```powershell
# Fetch only the response headers (-I)
curl.exe -I https://www.google.com
```

```powershell
# Verbose mode (-v) reveals TCP setup, TLS negotiation, and header exchange
curl.exe -v https://httpbin.org/get
```

```powershell
# 1. Test POST with JSON body
curl.exe -X POST https://httpbin.org/post -H "Content-Type: application/json" -d '{"user": "kevin", "role": "engineer"}'

# 2. Test 404 Not Found response code
curl.exe -I https://httpbin.org/status/404

# 3. Test 503 Service Unavailable response code
curl.exe -I https://httpbin.org/status/503

# 4. Discover allowed methods via OPTIONS
curl.exe -i -X OPTIONS https://httpbin.org/
```

---

## Day 249 — Day 23: HTTP/1.1, HTTP/2, and HTTP/3
- **Date:** 5 November 2026 (Calendar: November 5, 2026 (Thursday))

```text
                           HTTP Request-Response Paradigm
  Client (Browser / API Client)                              Server / Reverse Proxy
        │                                                              │
        │── 1. HTTP Request (GET /index.html HTTP/1.1) ───────────────►│
        │      Host: example.com                                       │ (Processes request)
        │                                                              │
        │◄── 2. HTTP Response (HTTP/1.1 200 OK) ───────────────────────┤
        │      Content-Type: text/html                                 │
        ▼                                                              ▼
```

```http
Connection: keep-alive
```

```text
             HTTP/1.1 Sequential Head-of-Line (HOL) Blocking
  Client                                                      Server
    │                                                           │
    │── 1. GET /large-video.mp4 ───────────────────────────────►│
    │   (Takes 5 seconds to process and transfer)               │
    │                                                           │
    │── 2. GET /critical-styles.css ───────────────────────────►│ (Enqueued!)
    │── 3. GET /app-logic.js ──────────────────────────────────►│ (Enqueued!)
    │                                                           │
    │   [ CSS and JS are completely blocked behind the video! ] │
    │                                                           │
    │◄── Large Video Response Data (5000ms delay) ──────────────┤
    │◄── Critical Styles Response (Finally delivered!) ─────────┤
    │◄── App Logic Response ────────────────────────────────────┤
```

```text
                     HTTP/2 Multiplexing over a Single TCP Socket
                        Single Underlying TCP Connection
                                       │
     ┌─────────────────────────────────┼─────────────────────────────────┐
     ▼                                 ▼                                 ▼
[ Stream 1: HTML ]             [ Stream 3: CSS ]             [ Stream 5: JS ]
  Frame: HEADERS (1)             Frame: HEADERS (3)            Frame: HEADERS (5)
  Frame: DATA (1)                Frame: DATA (3)               Frame: DATA (5)
  Frame: DATA (1) [EOS]          Frame: DATA (3) [EOS]         Frame: DATA (5) [EOS]
```

```text
                  TCP-Level HOL Blocking in HTTP/2
  HTTP/2 Streams:  [ Stream 1: HTML ] [ Stream 3: CSS ] [ Stream 5: JS ]
                            │                 │                 │
                            └─────────────────┼─────────────────┘
                                              ▼
  TCP Byte Stream:   [ Packet 1 (HTML) ] [ Packet 2 (CSS) ] [ Packet 3 (JS) ]
                                                │
                                                ▼ (Packet 2 DROPPED in transit!)
  Receiver's Kernel: [ Packet 1: OK ]        [ MISSING ]       [ Packet 3: Buffered ]
                            │                                           │
  Delivery to App:   HTML Consumed                               JavaScript HELD!
                                                             (Cannot deliver to app!)
```

```text
                     Protocol Architecture Comparison

      HTTP/1.1                  HTTP/2                    HTTP/3
 ┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
 │    HTTP/1.1     │       │     HTTP/2      │       │     HTTP/3      │
 ├─────────────────┤       ├─────────────────┤       ├─────────────────┤
 │ TLS (Optional)  │       │  TLS 1.2 / 1.3  │       │      QUIC       │
 ├─────────────────┤       ├─────────────────┤       │ (Reliability,   │
 │       TCP       │       │       TCP       │       │  TLS 1.3, Flow) │
 ├─────────────────┤       ├─────────────────┤       ├─────────────────┤
 │       IP        │       │       IP        │       │       UDP       │
 └─────────────────┘       └─────────────────┘       ├─────────────────┤
                                                     │       IP        │
                                                     └─────────────────┘
```

```text
             HTTP/3: Stream-Level Independence under Packet Loss
  QUIC Streams:    [ Stream 1: HTML ] [ Stream 3: CSS ] [ Stream 5: JS ]
                            │                 │                 │
                            └─────────────────┼─────────────────┘
                                              ▼
  UDP Datagrams:    [ UDP Pkt 1 (HTML) ] [ UDP Pkt 2 (CSS) ] [ UDP Pkt 3 (JS) ]
                                                │
                                                ▼ (Pkt 2 DROPPED in transit!)
  QUIC Engine:      [ HTML Delivered! ]      [ WAITING ]     [ JS Delivered! ]
                                                                     │
  Application:      HTML processes...                            JavaScript executes!
```

```text
                   Connection Establishment Latency Comparison
  Traditional HTTPS (TCP + TLS 1.3): 2-RTT
  Client                                            Server
    │── 1. TCP SYN ────────────────────────────────►│ (1 RTT for TCP)
    │◄── 2. TCP SYN-ACK ────────────────────────────┤
    │── 3. TCP ACK + TLS 1.3 ClientHello ──────────►│ (1 RTT for TLS)
    │◄── 4. TLS ServerHello + Finished ─────────────┤
    │── 5. HTTP GET / ─────────────────────────────►│ (Data can now flow)

  HTTP/3 (QUIC + Integrated TLS 1.3): 1-RTT (or 0-RTT)
  Client                                            Server
    │── 1. QUIC Initial (Crypto Handshake + Keys) ──►│ (Combined Handshake!)
    │◄── 2. QUIC Handshake Done + Server Finished ──┤
    │── 3. HTTP/3 GET / ───────────────────────────►│ (Secure Data Exchange!)
```

```text
                        ALPN Negotiation Sequence
  Client                                                      Server
    │                                                           │
    │── TLS ClientHello ───────────────────────────────────────►│
    │   Extension: ALPN                                         │
    │   Protocols Offered: ["h2", "http/1.1"]                   │
    │                                                           │
    │◄── TLS ServerHello ───────────────────────────────────────┤
    │    Extension: ALPN                                        │
    │    Protocol Selected: "h2"                                │
    │                                                           │
    ▼ [ Both peers communicate using HTTP/2 binary framing! ]   ▼
```

```http
   Alt-Svc: h3=":443"; ma=86400; persist=1
   ```

```dns
   example.com. 300 IN HTTPS 1 . alpn="h3,h2"
   ```

```text
                      Cloud Ingress Protocol Architecture
   Mobile & Web Clients
    (Public Internet)
           │
           │ HTTP/3 (QUIC / UDP 443)  ──► Fast mobile performance, 0-RTT, no HOL
           │ HTTP/2 (TCP 443)         ──► Multiplexed desktop browser traffic
           ▼
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ Amazon CloudFront (CDN Edge) / Cloudflare Edge                              │
 │ • Terminates QUIC/UDP and TLS 1.3 at global Anycast edge POPs               │
 │ • Advertises `Alt-Svc: h3=":443"` to clients                                │
 └──────────────────────────────────────┬──────────────────────────────────────┘
                                        │
                                        │ HTTP/2 over TLS (Dedicated AWS private fiber)
                                        │ (Zero packet loss; TCP HOL is negligible)
                                        ▼
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ AWS Application Load Balancer (ALB)                                         │
 │ • Terminates HTTP/2 from CDN                                                │
 │ • Distributes traffic across target groups via HTTP/1.1 or gRPC (HTTP/2)     │
 └──────────────────────────────────────┬──────────────────────────────────────┘
                                        │
                 ┌──────────────────────┴──────────────────────┐
                 ▼                                             ▼
       ┌───────────────────┐                         ┌───────────────────┐
       │ EC2 / EKS Pod 1   │                         │ EC2 / EKS Pod 2   │
       │ (HTTP/1.1 Worker) │                         │ (HTTP/1.1 Worker) │
       └───────────────────┘                         └───────────────────┘
```

```powershell
curl.exe -I --http1.1 https://cloudflare.com
```

```text
HTTP/1.1 200 OK
Date: Thu, 05 Nov 2026 11:30:00 GMT
Content-Type: text/html
Connection: keep-alive
```

```powershell
curl.exe -I --http2 https://cloudflare.com
```

```text
HTTP/2 200
date: Thu, 05 Nov 2026 11:30:05 GMT
content-type: text/html
```

```powershell
curl.exe -I --http3 https://cloudflare.com
```

```powershell
curl.exe -V
```

```powershell
curl.exe -sS -o NUL -w "Negotiated Protocol: HTTP/%{http_version}\nRemote IP: %{remote_ip}\nSSL Verification: %{ssl_verify_result}\n" https://cloudflare.com
```

```text
Negotiated Protocol: HTTP/2
Remote IP: 104.16.132.229
SSL Verification: 0
```

---

## Day 250/1000 – TLS and Certificate Management
- **Date:** 6 November 2026 (Calendar: November 6, 2026 (Friday))

```text
                           The Core Pillars of TLS
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ 1. Confidentiality (Encryption):                                            │
 │    Symmetric ciphers (AES-GCM, ChaCha20-Poly1305) encrypt application       │
 │    payloads, preventing eavesdroppers from reading transmitted packets.     │
 ├─────────────────────────────────────────────────────────────────────────────┤
 │ 2. Authentication (Identity Verification):                                  │
 │    Asymmetric cryptography (RSA, ECDSA) and X.509 digital certificates      │
 │    verify that the server is genuinely the claimed domain entity.           │
 ├─────────────────────────────────────────────────────────────────────────────┤
 │ 3. Integrity (Tamper Detection):                                            │
 │    AEAD (Authenticated Encryption with Associated Data) and HMAC algorithms │
 │    detect if an in-transit packet was modified, injected, or replayed.      │
 └─────────────────────────────────────────────────────────────────────────────┘
```

```text
                   TLS 1.3 Handshake Workflow (1-RTT)
  Client (Browser / API Client)                              Server / Reverse Proxy
        │                                                              │
        │── 1. ClientHello ───────────────────────────────────────────►│
        │      • TLS 1.3 Supported                                     │
        │      • Cipher Suites (e.g., TLS_AES_256_GCM_SHA384)          │
        │      • Client Random                                         │
        │      • Key Share (Client Public Diffie-Hellman Share)        │
        │      • SNI: api.example.com                                  │
        │      • ALPN: ["h2", "http/1.1"]                              │
        │                                                              │
        │◄── 2. ServerHello ───────────────────────────────────────────┤
        │      • Selected Cipher Suite                                 │
        │      • Server Random                                         │
        │      • Server Key Share (Server Diffie-Hellman Share)        │
        │                                                              │
        │   [ Shared Master Secret Derived by Both Sides Independently ]│
        │                                                              │
        │◄── 3. EncryptedExtensions (ALPN = h2) ───────────────────────┤
        │◄── 4. Certificate (X.509 Server Certificate Chain) ──────────┤
        │◄── 5. CertificateVerify (Digital Signature using PrivKey) ───┤
        │◄── 6. Finished (HMAC over entire handshake transcript) ──────┤
        │                                                              │
        │── 7. Finished (Client confirms transcript HMAC) ────────────►│
        │                                                              │
        ▼                                                              ▼
        ═══════════════ ENCRYPTED APPLICATION DATA (HTTPS) ═════════════
```

```text
┌─────────────────┬───────────────────────────────────┬───────────────────────────────────┐
│ Feature         │ TLS 1.2 (RFC 5246)                │ TLS 1.3 (RFC 8446)                │
├─────────────────┼───────────────────────────────────┼───────────────────────────────────┤
│ **Handshake**   │ 2 Round Trips (2-RTT)             │ **1 Round Trip (1-RTT)**          │
│ **Session Resume│ Session Tickets / IDs             │ **0-RTT Early Data**              │
│ **Ciphers**     │ 37+ (Includes insecure CBC/RC4)   │ **5 Modern AEAD Ciphers Only**    │
│ **Key Exchange**│ Static RSA, DHE, ECDHE            │ **Mandatory Ephemeral (ECDHE/DHE)│
│ **Forward Sec.**│ Optional (Vulnerable if static)   │ **Mandatory by default**          │
│ **Handshake Enc│ Cleartext certificates & headers  │ **Certificates are Encrypted**    │
└─────────────────┴───────────────────────────────────┴───────────────────────────────────┘
```

```text
                         Hierarchical Chain of Trust
                      ┌───────────────────────────────┐
                      │            Root CA            │
                      │ (Pre-installed in Trust Store)│
                      │ e.g., ISRG Root X1            │
                      └───────────────┬───────────────┘
                                      │ Signs Intermediate
                                      ▼
                      ┌───────────────────────────────┐
                      │        Intermediate CA        │
                      │ e.g., R3 / Let's Encrypt      │
                      └───────────────┬───────────────┘
                                      │ Signs Leaf Certificate
                                      ▼
                      ┌───────────────────────────────┐
                      │    Server/Leaf Certificate    │
                      │ Domain: api.example.com       │
                      │ Public Key: 2048-bit RSA/ECC  │
                      └───────────────────────────────┘
```

```text
                  Multi-Tenant Load Balancer with SNI
                         User requests: shop.company.com
                                       │
                                       ▼ (ClientHello + SNI: shop.company.com)
                     ┌───────────────────────────────────┐
                     │ Application Load Balancer         │
                     │ Single Public IP: 203.0.113.10    │
                     └─────────────────┬─────────────────┘
                                       │
                 ┌─────────────────────┼─────────────────────┐
                 │ SNI Matches         │ SNI Matches         │ SNI Matches
                 ▼                     ▼                     ▼
        ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
        │ Certificate A   │   │ Certificate B   │   │ Certificate C   │
        │ api.company.com │   │ shop.company.com│   │ admin.company...│
        └─────────────────┘   └────────┬────────┘   └─────────────────┘
                                       │
                                       ▼ (Presents Certificate B!)
```

```text
                       Certificate Lifecycle Stages
 ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
 │ 1. Issuance  │ ──► │ 2. Deploy    │ ──► │ 3. Monitor   │ ──► │ 4. Renewal & │
 │ CSR & Domain │     │ Bind to ALB  │     │ Track Expiry │     │ Rotation     │
 │ Validation   │     │ or Ingress   │     │ & CRL/OCSP   │     │ (At 30 Days) │
 └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
```

```text
                     Standard TLS vs. Mutual TLS (mTLS)

      [ Standard One-Way TLS ]                      [ Mutual TLS (mTLS) ]
  Client                     Server             Client                     Server
    │                           │                 │                           │
    │── ClientHello ───────────►│                 │── ClientHello ───────────►│
    │◄── Server Certificate ────│                 │◄── Server Certificate ────│
    │    (Client verifies ID)   │                 │◄── CertificateRequest ────│
    │── Encrypted Data ────────►│                 │── Client Certificate ────►│
                                                  │    (Server verifies ID)   │
                                                  │── Encrypted Data ────────►│
```

```text
                  AWS Certificate Manager (ACM) Workflow
                              Admin / Terraform
                                     │
                                     ▼ (1) Requests Certificate for api.example.com
                      ┌──────────────────────────────┐
                      │ AWS Certificate Manager (ACM)│
                      └──────────────┬───────────────┘
                                     │ (2) Generates CNAME DNS validation record
                                     ▼
                      ┌──────────────────────────────┐
                      │      Amazon Route 53         │
                      │ (Auto-proves domain control) │
                      └──────────────┬───────────────┘
                                     │ (3) ACM issues cert & manages private keys
                                     ▼
                      ┌──────────────────────────────┐
                      │ Application Load Balancer    │
                      │ CloudFront / API Gateway     │
                      └──────────────────────────────┘
                                     │
                   (4) Automated Renewal Every 60 Days!
                   (Zero Downtime, Zero Manual Work)
```

```text
                 Option A: Edge TLS Termination (Load Balancer Offloading)
    Internet                                      Private VPC Subnet
  ┌──────────┐         HTTPS (Port 443)         ┌───────────────────┐    Plain HTTP (Port 80)   ┌─────────────┐
  │ Browser  │ ────────────────────────────────►│ Application Load  │ ─────────────────────────►│ EC2 / EKS   │
  │ Client   │                                  │ Balancer (ALB)    │                           │ Backend Pod │
  └──────────┘                                  └───────────────────┘                           └─────────────┘
                                                [ Decrypts Traffic ]

                 Option B: End-to-End TLS (Zero-Trust / Compliance)
    Internet                                      Private VPC Subnet
  ┌──────────┐         HTTPS (Port 443)         ┌───────────────────┐     HTTPS (Port 8443)     ┌─────────────┐
  │ Browser  │ ────────────────────────────────►│ Application Load  │ ─────────────────────────►│ EC2 / EKS   │
  │ Client   │                                  │ Balancer (ALB)    │                           │ Backend Pod │
  └──────────┘                                  └───────────────────┘                           └─────────────┘
                                                [ Re-encrypts to Backend ]                     [ Decrypts at App ]
```

```bash
# Connect to Google and inspect full certificate ladder
openssl s_client -connect google.com:443 -servername google.com
```

```bash
# Pull certificate dates, issuer, and subject directly without interactive prompt
echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | \
openssl x509 -noout -subject -issuer -dates
```

```text
subject=CN = *.google.com
issuer=C = US, O = Google Trust Services, CN = WR2
notBefore=Oct 13 08:24:12 2026 GMT
notAfter=Jan  5 08:24:11 2027 GMT
```

```bash
# Requesting with mismatched servername verifies SNI routing
openssl s_client -connect cloudflare.com:443 -servername incorrect-domain.example
```

```bash
echo | openssl s_client -connect google.com:443 -servername google.com 2>/dev/null | \
grep -E "Protocol|Cipher"
```

```text
    New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
    Protocol  : TLSv1.3
    Cipher    : TLS_AES_256_GCM_SHA384
```

```bash
#!/bin/bash
# ==============================================================================
# Script: cert_expiry.sh
# Purpose: Audits TLS certificate expiration, calculates remaining days,
#          and outputs structured status alerts for cloud monitoring agents.
# Usage:   ./cert_expiry.sh <domain.com> [port]
# ==============================================================================

set -euo pipefail

DOMAIN="${1:-}"
PORT="${2:-443}"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain.com> [port]"
    exit 1
fi

echo "=========================================================="
echo "          TLS CERTIFICATE EXPIRY AUDITOR                  "
echo "=========================================================="
echo "Target Endpoint: $DOMAIN:$PORT"

# 1. Fetch certificate end-date via OpenSSL
END_DATE=$(echo | openssl s_client -connect "$DOMAIN:$PORT" \
    -servername "$DOMAIN" 2>/dev/null | \
    openssl x509 -noout -enddate 2>/dev/null | \
    cut -d= -f2 || true)

if [ -z "$END_DATE" ]; then
    echo ">> [ERROR]: Failed to retrieve TLS certificate from $DOMAIN:$PORT."
    echo ">> Check DNS reachability, port accessibility, or firewall restrictions."
    exit 2
fi

echo "Expiry Timestamp: $END_DATE"

# 2. Calculate remaining days using epoch timestamps
EXPIRY_EPOCH=$(date -d "$END_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
SECONDS_REMAINING=$((EXPIRY_EPOCH - CURRENT_EPOCH))
DAYS_REMAINING=$((SECONDS_REMAINING / 86400))

echo "Days Remaining:   $DAYS_REMAINING days"
echo ""

# 3. Evaluate operational thresholds
if [ "$DAYS_REMAINING" -le 0 ]; then
    echo ">> [CRITICAL ALERT]: Certificate for $DOMAIN is EXPIRED!"
    exit 2
elif [ "$DAYS_REMAINING" -le 15 ]; then
    echo ">> [CRITICAL WARNING]: Certificate expires in less than 15 days ($DAYS_REMAINING days left)!"
    exit 2
elif [ "$DAYS_REMAINING" -le 30 ]; then
    echo ">> [WARNING]: Certificate expires soon ($DAYS_REMAINING days left). Trigger renewal."
    exit 1
else
    echo ">> [STATUS OK]: Certificate is healthy. Valid for $DAYS_REMAINING more days."
    exit 0
fi
```

```bash
chmod +x cert_expiry.sh
./cert_expiry.sh google.com
```

---

## Day 251 / 1000 – Cloud Security Controls
- **Date:** 7 November 2026 (Calendar: November 7, 2026 (Saturday))

```text
               Stateful vs. Stateless Filtering Mechanics

       [ STATEFUL FILTERING ]                      [ STATELESS FILTERING ]
  1. Inbound SYN (Dst Port 443)              1. Inbound SYN (Dst Port 443)
     Allowed by Rule ──► [ ACCEPT ]             Allowed by Rule ──► [ ACCEPT ]
             │                                          │
             ▼                                          ▼
  Connection Table Recorded:                 No State Maintained!
  [ TCP 198.51.100.5:51234 <-> :443 ]                   │
             │                                          │
  2. Outbound ACK (Src Port 443)             2. Outbound ACK (Src Port 443)
     Matches Connection Table!                  Evaluates Outbound Rules:
     Automatically Allowed ──► [ ACCEPT ]       • Is Ephemeral Port 51234 open?
                                                • If YES ──► [ ACCEPT ]
                                                • If NO  ──► [ DROPPED! ]
```

```text
                           AWS VPC Dual-Layer Firewall Architecture
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ AWS Virtual Private Cloud (VPC: 10.0.0.0/16)                                │
 │                                                                             │
 │   ┌─────────────────────────────────────────────────────────────────────┐   │
 │   │ Public Subnet (10.0.1.0/24)                                         │   │
 │   │                                                                     │   │
 │   │   ┌─────────────────────────────────────────────────────────────┐   │   │
 │   │   │ Network ACL (Stateless Subnet Boundary: Numbered Rules)     │   │   │
 │   │   └──────────────────────────────┬──────────────────────────────┘   │   │
 │   │                                  │                                  │   │
 │   │                 ┌────────────────┴────────────────┐                 │   │
 │   │                 ▼                                 ▼                 │   │
 │   │   ┌───────────────────────────┐     ┌───────────────────────────┐   │   │
 │   │   │ Security Group: sg-web    │     │ Security Group: sg-api    │   │   │
 │   │   │ (Stateful ENI Boundary)   │     │ (Stateful ENI Boundary)   │   │   │
 │   │   ├───────────────────────────┤     ├───────────────────────────┤   │   │
 │   │   │ [ EC2 Web Server A ]      │     │ [ EC2 Web Server B ]      │   │   │
 │   │   │ IP: 10.0.1.10             │     │ IP: 10.0.1.20             │   │   │
 │   │   └───────────────────────────┘     └───────────────────────────┘   │   │
 │   └─────────────────────────────────────────────────────────────────────┘   │
 └─────────────────────────────────────────────────────────────────────────────┘
```

```text
                         NACL Rule Processing Pipeline
                             Incoming Packet: TCP 443
                                        │
                                        ▼
                  ┌───────────────────────────────────────────┐
                  │ Rule 100: TCP 22 from 0.0.0.0/0 ──► DENY  │ (No match, continue)
                  └─────────────────────┬─────────────────────┘
                                        ▼
                  ┌───────────────────────────────────────────┐
                  │ Rule 110: TCP 443 from 0.0.0.0/0 ──► ALLOW│ (MATCH FOUND!)
                  └─────────────────────┬─────────────────────┘
                                        │
                                        ▼
                            PACKET PERMITTED IMMEDIATELY!
                            (Rules 120 and * are NEVER evaluated)
```

```text
                     The Principle of Default-Deny
      [ Insecure: Permissive ]                    [ Secure: Default-Deny ]
         Allow Everything                           Block Everything (Default)
                │                                               │
       Filter known threats                       Carve specific, audited holes
                ▼                                               ▼
   High risk of zero-day breach              Zero unnecessary exposure surface
```

```text
Bad Practice (Unrestricted):
  sg-app Inbound:  TCP 8080 from 0.0.0.0/0  (Exposed directly to public internet!)
  sg-app Outbound: ALL from 0.0.0.0/0       (Unmonitored data exfiltration risk!)

Best Practice (Least Privilege):
  sg-app Inbound:  TCP 8080 from sg-alb     (Accessible strictly via Load Balancer)
  sg-app Outbound: TCP 3306 to sg-db        (Permitted ONLY to talk to database)
```

```text
                  The Anti-Pattern: Hard-Coded IP Management
  App Instance 1 (10.0.2.10) ──┐
  App Instance 2 (10.0.2.11) ──┼──► Database Security Group (sg-db):
  Autoscaled Node (10.0.2.45) ─┘    Inbound: TCP 3306 from 10.0.2.10/32
                                    Inbound: TCP 3306 from 10.0.2.11/32
                                    * New autoscaled node fails to connect!

                  The Cloud-Native Pattern: Security Group Referencing
  ┌─────────────────────────────────────────────────────────────┐
  │ Application Security Group: sg-app                          │
  │ • App Instance 1 (10.0.2.10)                                │
  │ • App Instance 2 (10.0.2.11)                                │
  │ • Autoscaled Node (10.0.2.45)                               │
  └──────────────────────────────┬──────────────────────────────┘
                                 │ Inbound Rule: Protocol: TCP, Port: 3306
                                 │ Source: sg-app
                                 ▼
  ┌─────────────────────────────────────────────────────────────┐
  │ Database Security Group: sg-db                              │
  │ Inbound: TCP 3306 from sg-app                               │
  │ * Automatically permits ANY current or future member!        │
  └─────────────────────────────────────────────────────────────┘
```

```text
                            The OSI Security Spectrum
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │ Layer 7: AWS WAF (Web Application Firewall)                                 │
  │ • Inspects HTTP/HTTPS payloads (SQLi, XSS, CSRF, Log4j, Bot Control)        │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │ Layer 3–7: AWS Network Firewall / Suricata IPS                              │
  │ • Stateful packet inspection, domain filtering, TLS SNI filtering           │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │ Layer 4: AWS Security Groups (Stateful virtual firewall per ENI)            │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │ Layer 3/4: AWS Network ACLs (Stateless subnet packet filter)                │
  └─────────────────────────────────────────────────────────────────────────────┘
```

```text
                       AWS WAF Request Inspection Engine
                 Inbound HTTPS Request: /login?user=admin' OR '1'='1
                                        │
                                        ▼
                         [ AWS WAF Rule Evaluation ]
                                        │
       ┌────────────────────────────────┼────────────────────────────────┐
       ▼                                ▼                                ▼
[ AWS Managed Rules ]         [ Custom Rate Limit ]            [ IP Reputation ]
Matches SQLi signature!       Tracks requests/min              Checks Tor/Bot list
       │
       ▼
   DROP PACKET IMMEDIATELY! (Returns HTTP 403 Forbidden to Attacker)
```

```text
                  PRODUCTION THREE-TIER DEFENSE-IN-DEPTH ARCHITECTURE
══════════════════════════════════════════════════════════════════════════════════════
                                  PUBLIC INTERNET
══════════════════════════════════════════════════════════════════════════════════════
                                         │
                                         ▼ (Port 443)
                          [ AWS WAF (Layer 7 Inspection) ]
                           (Blocks SQLi, XSS, Rate Limits)
                                         │
                                         ▼
 ┌──────────────────────────────────────────────────────────────────────────────────┐
 │ Public Subnet (10.0.1.0/24)                                                      │
 │ NACL: Allows Inbound 443 + Outbound Ephemeral (1024-65535)                       │
 │                                                                                  │
 │               [ Internet-Facing Application Load Balancer ]                      │
 │               Security Group: sg-alb                                             │
 │               • Inbound:  TCP 443 from 0.0.0.0/0                                 │
 │               • Outbound: TCP 8080 to sg-app                                     │
 └───────────────────────────────────────┬──────────────────────────────────────────┘
                                         │
                                         ▼ (TCP 8080 via Internal Fabric)
 ┌──────────────────────────────────────────────────────────────────────────────────┐
 │ Private Application Subnet (10.0.2.0/24)                                         │
 │ NACL: Allows Inbound 8080 from Public Subnet + Outbound to Database Subnet       │
 │                                                                                  │
 │               [ Auto Scaling Fleet of Application Pods ]                         │
 │               Security Group: sg-app                                             │
 │               • Inbound:  TCP 8080 from sg-alb (SG Reference)                   │
 │               • Outbound: TCP 3306 to sg-db (SG Reference)                       │
 └───────────────────────────────────────┬──────────────────────────────────────────┘
                                         │
                                         ▼ (TCP 3306 via Internal Fabric)
 ┌──────────────────────────────────────────────────────────────────────────────────┐
 │ Isolated Database Subnet (10.0.3.0/24)                                           │
 │ NACL: Allows Inbound 3306 from App Subnet; Outbound Ephemeral to App Subnet      │
 │                                                                                  │
 │               [ Multi-AZ Amazon Aurora MySQL Cluster ]                           │
 │               Security Group: sg-db                                              │
 │               • Inbound:  TCP 3306 from sg-app (SG Reference)                   │
 │               • Outbound: NONE (Explicitly Empty / Deny All)                     │
 └──────────────────────────────────────────────────────────────────────────────────┘
```

```text
secure-three-tier-vpc/
├── main.tf
├── security_groups.tf
└── network_acls.tf
```

```hcl
# 1. Load Balancer Security Group
resource "aws_security_group" "alb" {
  name        = "sg-alb"
  description = "Public ingress for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow traffic to App tier only"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id] # SG Reference!
  }

  tags = { Name = "sg-alb" }
}

# 2. Application Server Security Group
resource "aws_security_group" "app" {
  name        = "sg-app"
  description = "Application tier security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP 8080 strictly from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # SG Reference!
  }

  egress {
    description     = "Allow MySQL strictly to DB tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.db.id] # SG Reference!
  }

  tags = { Name = "sg-app" }
}

# 3. Database Security Group
resource "aws_security_group" "db" {
  name        = "sg-db"
  description = "Isolated database security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow MySQL strictly from Application Tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id] # SG Reference!
  }

  # Zero egress rules defined -> Default-Deny Outbound!
  tags = { Name = "sg-db" }
}
```

---

## Day 252/1000 – Load Balancing
- **Date:** 8 November 2026 (Calendar: November 8, 2026 (Sunday))

```text
                  Single Server Bottleneck vs. Load Balanced Fleet

      [ WITHOUT LOAD BALANCER ]                       [ WITH LOAD BALANCER ]
    Users (300 req/sec)                             Users (300 req/sec)
            │                                                │
            ▼                                                ▼
  ┌───────────────────┐                            ┌───────────────────┐
  │ Single Server     │                            │   Load Balancer   │
  │ Load: 300 req/sec │                            └─────────┬─────────┘
  └───────────────────┘                                      │
  * CPU at 100% (Overload)                 ┌─────────────────┼─────────────────┐
  * High response latency                  ▼ 100 req/s       ▼ 100 req/s       ▼ 100 req/s
  * Single Point of Failure (SPOF)   ┌───────────┐     ┌───────────┐     ┌───────────┐
  * If server crashes, 100% outage   │ Server A  │     │ Server B  │     │ Server C  │
                                     └───────────┘     └───────────┘     └───────────┘
                                     * Workload evenly distributed (1/3 each)
                                     * High availability & automated failover
```

```text
                     Layer 4 vs. Layer 7 Decision Engine

    [ LAYER 4: TRANSPORT LEVEL (NLB) ]             [ LAYER 7: APPLICATION LEVEL (ALB) ]
       Operates on TCP / UDP 5-Tuple                    Inspects Full HTTP/HTTPS Payload
                │                                                │
   {SrcIP, SrcPort, DstIP, DstPort}                 Host: shop.example.com
                │                                   Path: /api/v1/checkout
                ▼                                   Cookie: session_id=abc123
   Fast TCP Packet Forwarding                                    │
   (Opaque to application payload)                               ▼
                │                                   Content-Based Intelligent Routing
                ▼                                   (Directs /checkout to Payment Pods)
   Backend Server Pool                                           │
                                                                 ▼
                                                    Microservice Target Groups
```

```text
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ AWS Application Load Balancer (ALB) ──► Layer 7 HTTP/HTTPS/gRPC Microservices│
 ├─────────────────────────────────────────────────────────────────────────────┤
 │ AWS Network Load Balancer (NLB)     ──► Layer 4 TCP/UDP Ultra-High Performance│
 ├─────────────────────────────────────────────────────────────────────────────┤
 │ AWS Gateway Load Balancer (GWLB)    ──► Layer 3/4 Virtual Security Appliances│
 └─────────────────────────────────────────────────────────────────────────────┘
```

```text
                  ELB Request Evaluation Pipeline
 ┌─────────────────────────────────────────────────────────────┐
 │ Listener (e.g., HTTPS Port 443)                             │
 │ • Receives incoming connections                             │
 │ • Evaluates TLS Certificates via SNI                        │
 └──────────────────────────────┬──────────────────────────────┘
                                │ Evaluates Routing Rules (Priority 1..N)
                                ▼
 ┌─────────────────────────────────────────────────────────────┐
 │ Routing Rules                                               │
 │ • Rule 1: IF Path = /api/*    ──► Target Group: tg-api      │
 │ • Rule 2: IF Host = admin.*   ──► Target Group: tg-admin    │
 │ • Default: Forward to         ──► Target Group: tg-default  │
 └──────────────────────────────┬──────────────────────────────┘
                                │ Dispatches to Healthy Targets
                                ▼
 ┌─────────────────────────────────────────────────────────────┐
 │ Target Group: tg-api                                        │
 │ • Backend Targets: [ Pod A: 10.0.2.10, Pod B: 10.0.2.11 ]    │
 │ • Health Check Configuration: GET /healthz (Expect 200 OK)  │
 └─────────────────────────────────────────────────────────────┘
```

```text
                           Algorithm Comparison
      [ ROUND ROBIN ]             [ LEAST CONNECTIONS ]         [ CONSISTENT HASH ]
   Req 1 ──► Server A              Server A (50 conns)           User 101 ──► Server A
   Req 2 ──► Server B              Server B (12 conns) ◄── Next! User 102 ──► Server B
   Req 3 ──► Server C              Server C (38 conns)           User 103 ──► Server C
```

```text
                     ELB Health Checking State Engine
                  Periodic Probe: GET /health (Port 8080)
                                    │
           ┌────────────────────────┴────────────────────────┐
           ▼ (200 OK Received)                               ▼ (Timeout / 500 Error)
 ┌───────────────────────┐                         ┌───────────────────────┐
 │ Healthy Check Counter │                         │ Unhealthy Counter     │
 │ Increments (+1)       │                         │ Increments (+1)       │
 └─────────┬─────────────┘                         └─────────┬─────────────┘
           │ Reaches HealthyThreshold (e.g., 2)              │ Reaches UnhealthyThreshold (e.g., 3)
           ▼                                                 ▼
 ┌───────────────────────┐                         ┌───────────────────────┐
 │ Status: HEALTHY       │                         │ Status: UNHEALTHY     │
 │ Actively Receives     │                         │ REMOVED FROM POOL!    │
 │ Application Traffic   │                         │ Zero new traffic sent │
 └───────────────────────┘                         └───────────────────────┘
```

```javascript
const express = require("express");
const app = express();

// Deep readiness health check endpoint
app.get("/health", async (req, res) => {
    try {
        // 1. Verify downstream database connection
        const dbHealthy = await checkDatabaseConnectivity();
        // 2. Verify Redis cache reachability
        const redisHealthy = await checkRedisPing();

        if (dbHealthy && redisHealthy) {
            return res.status(200).json({ status: "healthy", timestamp: Date.now() });
        } else {
            return res.status(503).json({ status: "unhealthy", reason: "dependency_failure" });
        }
    } catch (err) {
        return res.status(500).json({ status: "critical", error: err.message });
    }
});

app.listen(8080, () => console.log("Application online on port 8080"));
```

```text
                 Connection Draining (Deregistration Delay)
  T = 0s: Administrator deregisters Server A (or Auto Scaling scales in)
          │
          ├─► Load balancer immediately STOPS sending new requests to Server A.
          ├─► Load balancer diverts all new traffic to Server B and Server C.
          │
  T = 1..29s: Server A finishes processing 50 active in-flight checkout requests.
          │
  T = 30s: All in-flight requests complete. Server A active connection count = 0.
          │
  T = 31s: Server A safely terminates without a single dropped user request!
```

```text
               Cross-Zone Load Balancing Disabled vs. Enabled
       Traffic Split: 50% AZ-A, 50% AZ-B (Total 100 Incoming Requests)

       [ DISABLED (Uneven Node Load) ]                 [ ENABLED (Even Server Load) ]
        ALB Node A          ALB Node B                  ALB Node A          ALB Node B
       (50 Requests)       (50 Requests)               (50 Requests)       (50 Requests)
             │                   │                           │                   │
             ▼                   ▼                           └─────────┬─────────┘
        AZ-A (1 Node)       AZ-B (4 Nodes)                             │
       ┌─────────────┐     ┌─────────────┐                   Cross-Zone Distribution
       │  Server 1   │     │  Server 2   │                             │
       │ (50 reqs!)  │     │ (12.5 reqs) │              ┌──────────────┼──────────────┐
       └─────────────┘     └─────────────┘              ▼              ▼              ▼
       * Server 1 is       * Servers 2-5          ┌──────────┐   ┌──────────┐   ┌──────────┐
         heavily             sit idle             │ Server 1 │   │ Server 2 │   │ Server 3 │
         overloaded!                              │(20 reqs) │   │(20 reqs) │   │(20 reqs) │
                                                  └──────────┘   └──────────┘   └──────────┘
```

```text
               Sticky Sessions vs. Shared Session State

       [ STICKY SESSIONS (Fragile) ]              [ SHARED REDIS STATE (Cloud-Native) ]
                Client A                                   Client A
                   │                                          │
                   ▼ (AWSALB Cookie)                          ▼ (Any Server)
             Load Balancer                              Load Balancer
                   │                                          │
                   ▼                               ┌──────────┼──────────┐
             ┌───────────┐                         ▼          ▼          ▼
             │ Server A  │                    ┌────────┐ ┌────────┐ ┌────────┐
             │ (RAM Mem) │                    │Server A│ │Server B│ │Server C│
             └───────────┘                    └────┬───┘ └───┬────┘ └───┬────┘
             * If Server A terminates,             │         │          │
               User A session is LOST!             └─────────┼──────────┘
             * Blocks horizontal scaling                     ▼
                                                   [ Redis / DynamoDB ]
                                                   (Shared Session Store)
```

```text
                  High-Availability E-Commerce Production Architecture
══════════════════════════════════════════════════════════════════════════════════════
                                  INTERNET CLIENTS
══════════════════════════════════════════════════════════════════════════════════════
                                         │
                                         ▼
                             [ Amazon Route 53 (DNS) ]
                              Alias ──► CNAME of ALB
                                         │
                                         ▼ (Port 443 / HTTPS)
                    [ Multi-AZ Application Load Balancer ]
                     • Managed TLS Termination (ACM Cert)
                     • Native AWS WAF Inspection
                     • Cross-Zone Balancing: ENABLED
                                         │
                     ┌───────────────────┴───────────────────┐
                     │ Path: /api/v1/catalog                 │ Path: /api/v1/orders
                     ▼                                       ▼
        ┌─────────────────────────┐             ┌─────────────────────────┐
        │ Target Group: Catalog   │             │ Target Group: Orders    │
        │ • Dereg. Delay: 15s     │             │ • Dereg. Delay: 60s     │
        │ • Health: GET /health   │             │ • Health: GET /health   │
        └────────────┬────────────┘             └────────────┬────────────┘
                     │                                       │
     ┌───────────────┴───────────────┐       ┌───────────────┴───────────────┐
     ▼ (Subnet AZ-1a) ▼ (Subnet AZ-1b)       ▼ (Subnet AZ-1a) ▼ (Subnet AZ-1b)
 ┌──────────────┐ ┌──────────────┐       ┌──────────────┐ ┌──────────────┐
 │ Catalog EC2  │ │ Catalog EC2  │       │ Orders EC2   │ │ Orders EC2   │
 └──────────────┘ └──────────────┘       └──────────────┘ └──────────────┘
         │               │                       │               │
         └───────┬───────┘                       └───────┬───────┘
                 │                                       │
                 ▼                                       ▼
       [ ElastiCache Redis ]                   [ Aurora PostgreSQL ]
       (Shared Session Store)                  (Persistent Relational DB)
```

```text
                          Incident Triage Runbook
 1. Health Check Failure ──► ALB isolates Node 2 ──► Auto Scaling launches replacement
 2. 10x Traffic Spike    ──► ALB absorbs connections ──► Cross-Zone balances traffic
 3. Deployment 502 Errors──► Increase Deregistration Delay (15s -> 60s) for clean drain
```

---

