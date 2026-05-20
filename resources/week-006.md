# Week 06 – Networking Fundamentals II Resources

**Focus:** HTTP/HTTPS, SSL/TLS, Ports, Firewalls, Load Balancers, VPNs & Troubleshooting  

---

## 🎯 Objective

Use high-quality resources to deeply understand real-world networking concepts and strengthen practical cloud knowledge.  

---

## 📚 Core Learning Resources

### 🌐 1️⃣ Cloudflare Learning Center
- Website: https://www.cloudflare.com/learning/  

#### Topics to Focus:
- What is HTTP / HTTPS  
- What is DNS  
- What is SSL/TLS  
- How the Internet works  
- Load balancing basics  
- Zero Trust & security concepts  

#### Why This Resource:
- Simple explanations of complex topics  
- Industry-level concepts explained visually  
- Best for building strong fundamentals  

---

### 📖 2️⃣ MDN Web Docs (HTTP)
- Website: https://developer.mozilla.org/en-US/docs/Web/HTTP  

#### Topics to Focus:
- HTTP request & response structure  
- Status codes  
- Headers  
- Cookies & sessions  
- Authentication methods  

#### Why This Resource:
- Official and highly detailed documentation  
- Used by developers worldwide  
- Deep dive into web communication  

---

### 📘 3️⃣ Julia Evans Networking Zines
- Website: https://wizardzines.com  

#### Recommended Zines:
- Networking basics  
- How DNS works  
- How HTTP works  
- Debugging networks  

#### Why This Resource:
- Visual + simple explanations  
- Easy to understand complex networking  
- Great for quick revision  

---

## 🛠️ Practice & Hands-On Tools

### 🔹 httpbin (HTTP Testing)
- Website: https://httpbin.org  

#### Use Cases:
- Test HTTP requests  
- View headers and responses  
- Experiment with APIs  

---

### 🔹 curl (Command Line Tool)
#### Practice:
    curl https://httpbin.org/get  
    curl https://httpbin.org/headers  

#### Why:
- Test APIs and endpoints  
- Understand request/response behavior  

---

### 🔹 OpenSSL (TLS Inspection)
#### Practice:
    openssl s_client -connect google.com:443  

#### Why:
- View TLS handshake  
- Inspect certificates  

---

### 🔹 nmap (Port Scanning)
#### Practice:
    sudo nmap -sV -p 1-1000 localhost  

#### Why:
- Discover open ports  
- Identify running services  

---

### 🔹 ss (Socket Statistics)
#### Practice:
    ss -tulpn  

#### Why:
- Check listening ports  
- Understand service bindings  

---

### 🔹 tcpdump (Packet Analysis)
#### Practice:
    sudo tcpdump -i eth0 port 80  

#### Why:
- Capture real-time traffic  
- Debug network issues  

---

### 🔹 mtr (Network Diagnostics)
#### Practice:
    mtr google.com  

#### Why:
- Analyze network path  
- Combine ping + traceroute  

---

### 🔹 dig (DNS Lookup)
#### Practice:
    dig +short example.com  

#### Why:
- Verify DNS resolution  
- Debug domain issues  

---

### 🔹 telnet (Port Testing)
#### Practice:
    telnet host port  

#### Why:
- Check connectivity to specific ports  

---

## ☁️ Cloud Practice

### 🔹 AWS EC2
- Launch instances  
- Configure Security Groups  
- Deploy NGINX  
- Test HTTP access  

---

## 🧠 Key Learning Strategy

- Learn concept → Visualize → Practice → Debug  
- Use CLI tools daily  
- Break things intentionally and fix them  
- Always ask: “Why is this happening?”  

---

## 🔄 Mindset Shift

Moved from:

> Just reading networking concepts  

To:

> Using real tools to test, analyze, and debug network behavior  

---

## 💭 Reflection

Week 6 resources provided a strong mix of:
- Theory (Cloudflare, MDN)  
- Visual learning (Zines)  
- Hands-on practice (CLI tools)  

This combination helped build:
- Deep understanding  
- Practical debugging skills  
- Real-world cloud readiness  

---

**Status:** Resources Compiled  
**Outcome:** Ready for Practical Networking Mastery 🚀  
