# 🔐 Level 00

> **Category:** File Discovery & Caesar Cipher  
> **Difficulty:** ⭐☆☆☆☆  
> **Key Technique:** Finding files by owner, ROT cipher decryption

---

## 📋 Overview

The first level introduces basic Linux file enumeration and simple cipher decryption. We need to find files owned by `flag00` and decode an obfuscated password.

---

## 🔍 Reconnaissance

### Finding Files Owned by flag00

```bash
level00@SnowCrash:/$ find / -user flag00 2>/dev/null
/usr/sbin/john
/rofs/usr/sbin/john
```

### Reading the Discovered File

```bash
level00@SnowCrash:/$ cat /usr/sbin/john
cdiiddwpgswtgt
```

---

## 💡 Vulnerability Analysis

The string `cdiiddwpgswtgt` is encrypted using a **Caesar cipher** with a shift of **+11** (equivalent to ROT15 in reverse).

> [!TIP]
> Caesar ciphers are simple substitution ciphers where each letter is shifted by a fixed number of positions in the alphabet.

---

## 🎯 Exploitation

Decrypting `cdiiddwpgswtgt` with a -11 shift reveals: **`nottoohardhere`**

```bash
level00@SnowCrash:/$ su flag00
Password: nottoohardhere
Don't forget to launch getflag !

flag00@SnowCrash:~$ getflag
Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag00 Password | `nottoohardhere` |
| Token | `x24ti5gi3x0ol2eh4esiuxias` |

---

## 📚 References

- [Caesar Cipher - Wikipedia](https://en.wikipedia.org/wiki/Caesar_cipher)
- [find command - man page](https://linux.die.net/man/1/find)