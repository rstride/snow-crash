# ❄️ Snow-Crash

<div align="center">

![Snow-Crash Banner](https://img.shields.io/badge/42-Snow--Crash-blue?style=for-the-badge)
![Cybersecurity](https://img.shields.io/badge/Type-Cybersecurity%20Challenges-red?style=for-the-badge)
![Levels](https://img.shields.io/badge/Levels-15-green?style=for-the-badge)

*A 42 School ISO-based cybersecurity challenge project*

</div>

---

## 📋 Overview

**Snow-Crash** is a bootable ISO designed to introduce you to the fundamentals of cybersecurity and penetration testing. Each level presents a unique security vulnerability that you must exploit to obtain a password (or "flag") that grants access to the next level.

You start as `level00` and work your way up, progressively tackling more complex security concepts.

---

## 🎯 Objective

For each level:
1. **Login** as the current level user (e.g., `level00:level00`)
2. **Discover** the vulnerability in the system
3. **Exploit** the vulnerability to obtain the flag
4. **Use the flag** to access the next level's user account

---

## 📚 Challenge Levels

### Mandatory Levels (0-9)

| Level | Category | Description |
|-------|----------|-------------|
| [Level 00](level00/writeup.md) | File Discovery | Find hidden files and decode a Caesar cipher |
| [Level 01](level01/writeup.md) | Password Cracking | Crack an exposed password hash in /etc/passwd |
| [Level 02](level02/writeup.md) | Network Forensics | Analyze a PCAP file to extract credentials |
| [Level 03](level03/writeup.md) | PATH Hijacking | Exploit SUID binary with relative path |
| [Level 04](level04/writeup.md) | Command Injection | Inject commands through a CGI script |
| [Level 05](level05/writeup.md) | Cron Exploitation | Exploit a cron job with writable scripts |
| [Level 06](level06/writeup.md) | PHP Code Injection | Exploit preg_replace /e modifier |
| [Level 07](level07/writeup.md) | Environment Variables | Inject commands via environment variables |
| [Level 08](level08/writeup.md) | Symlink Bypass | Bypass filename checks with symbolic links |
| [Level 09](level09/writeup.md) | Custom Encoding | Reverse a position-based encoding algorithm |

### Bonus Levels (10-14)

| Level | Category | Description |
|-------|----------|-------------|
| [Level 10](level10/writeup.md) | Race Condition | Exploit TOCTOU vulnerability with access() |
| [Level 11](level11/writeup.md) | Lua Injection | Command injection in Lua io.popen() |
| [Level 12](level12/writeup.md) | Filter Bypass | Bypass uppercase filter with wildcards |
| [Level 13](level13/writeup.md) | GDB Manipulation | Skip UID checks using debugger |
| [Level 14](level14/writeup.md) | Reverse Engineering | Extract flag directly from getflag binary |

---

## 🚀 Getting Started

### Prerequisites

- VirtualBox or VMware
- Snow-Crash ISO image
- Basic Linux command-line knowledge

### Setup

1. Create a new VM with the Snow-Crash ISO
2. Boot the VM and note the IP address displayed
3. Connect via SSH:
   ```bash
   ssh level00@<VM_IP> -p 4242
   # Password: level00
   ```

---

## 🔧 Useful Tools

Throughout the challenges, you may find these tools helpful:

- **John the Ripper** — Password cracking
- **Wireshark** — Network packet analysis
- **GDB** — Debugging and binary analysis
- **Ghidra / RetDec** — Binary decompilation
- **netcat (nc)** — Network connections
- **curl** — HTTP requests

---

## 📁 Repository Structure

```
snow-crash/
├── README.md
├── level00/
│   ├── flag
│   └── writeup.md
├── level01/
│   ├── flag
│   └── writeup.md
...
└── level14/
    ├── flag
    └── writeup.md
```

---

## ⚠️ Disclaimer

This project is for **educational purposes only**. The techniques demonstrated should only be practiced in controlled environments like this VM. Never attempt these techniques on systems without explicit authorization.

---

## 📖 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GTFOBins](https://gtfobins.github.io/) — Unix binary exploitation
- [CyberChef](https://gchq.github.io/CyberChef/) — Data encoding/decoding
- [Exploit Database](https://www.exploit-db.com/)

---

<div align="center">

*Made with ☕ at 42*

</div>
