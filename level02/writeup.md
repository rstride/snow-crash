# 🔐 Level 02

> **Category:** Network Forensics  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** PCAP analysis, TCP stream reconstruction

---

## 📋 Overview

This level involves analyzing a packet capture file to extract credentials transmitted over an unencrypted connection.

---

## 🔍 Reconnaissance

### Discovering the PCAP File

```bash
level02@SnowCrash:~$ ls -la
-rwxrwx--- 1 flag02 level02 8302 Aug 30  2015 level02.pcap
```

### Transferring for Analysis

```bash
scp -P 4242 level02@<machine_ip>:/home/user/level02/level02.pcap .
```

---

## 💡 Vulnerability Analysis

The PCAP file contains a captured network session where credentials were transmitted in plaintext. This is a common vulnerability when using unencrypted protocols like Telnet or FTP.

---

## 🎯 Exploitation

### Analyzing with Wireshark

1. Open `level02.pcap` in Wireshark
2. Right-click → **Follow TCP Stream**
3. Switch to **C Arrays** or **Hex Dump** view to see raw bytes

### Decoding the Password

The stream shows: `ft_wandr...NDRel.L0L`

> [!NOTE]
> The dots (`.`) represent **DEL** (0x7f) characters — backspaces! The user typed characters and deleted them.

**Reconstructed password:** `ft_waNDReL0L`

### Obtaining the Flag

```bash
level02@SnowCrash:~$ su flag02
Password: ft_waNDReL0L

flag02@SnowCrash:~$ getflag
Check flag.Here is your token : kooda2puivaav1idi4f57q8iq
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag02 Password | `ft_waNDReL0L` |
| Token | `kooda2puivaav1idi4f57q8iq` |

---

## 📚 References

- [Wireshark User Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- [TCP Stream Reassembly](https://wiki.wireshark.org/TCP_Reassembly)
- [ASCII Control Characters](https://en.wikipedia.org/wiki/Control_character)