# 🔐 Level 01

> **Category:** Password Cracking  
> **Difficulty:** ⭐☆☆☆☆  
> **Key Technique:** /etc/passwd analysis, John the Ripper

---

## 📋 Overview

This level demonstrates the classic vulnerability of storing password hashes in `/etc/passwd` instead of the more secure `/etc/shadow`. We find a DES-encrypted password hash that can be cracked.

---

## 🔍 Reconnaissance

### Examining /etc/passwd

```bash
level00@SnowCrash:~$ cat /etc/passwd | grep flag01
flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
```

> [!WARNING]
> The password hash `42hDRfypTqqnw` is stored directly in `/etc/passwd` instead of being shadowed. This is a severe security misconfiguration.

---

## 💡 Vulnerability Analysis

In modern Linux systems, password hashes should be stored in `/etc/shadow` (readable only by root). Here, the hash is exposed in the world-readable `/etc/passwd` file.

The hash format indicates **DES crypt** — a weak, legacy hashing algorithm easily cracked with dictionary attacks.

---

## 🎯 Exploitation

### Cracking with John the Ripper

```bash
# Save the hash to a file
echo "42hDRfypTqqnw" > mdp.txt

# Crack with John the Ripper
john mdp.txt --show
```

**Cracked password:** `abcdefg`

### Obtaining the Flag

```bash
level01@SnowCrash:~$ su flag01
Password: abcdefg

flag01@SnowCrash:~$ getflag
Check flag.Here is your token : f2av5il02puano7naaf6adaaf
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag01 Password | `abcdefg` |
| Token | `f2av5il02puano7naaf6adaaf` |

---

## 📚 References

- [John the Ripper](https://www.openwall.com/john/)
- [Understanding /etc/passwd](https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/)
- [DES Crypt Weakness](https://en.wikipedia.org/wiki/Crypt_(C)#Traditional_DES-based_scheme)