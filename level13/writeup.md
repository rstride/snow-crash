# 🔐 Level 13

> **Category:** Binary Analysis & UID Bypass  
> **Difficulty:** ⭐⭐⭐⭐☆  
> **Key Technique:** GDB jump to bypass UID check, or reverse decryption function

---

## 📋 Overview

A binary checks if the UID equals 4242 before decrypting and displaying the flag. We bypass this with GDB or reverse the decryption algorithm.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level13@SnowCrash:~$ ls -l
total 8
-rwsr-sr-x 1 flag13 level13 7303 Aug 30  2015 level13

level13@SnowCrash:~$ ./level13 
UID 2013 started us but we we expect 4242
```

### Decompiled Source

```c
void main(void) {
    __uid_t uid = getuid();
    
    if (uid != 0x1092) {  // 0x1092 = 4242
        printf("UID %d started us but we we expect %d\n", uid, 0x1092);
        exit(1);
    }
    
    char *token = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
    printf("your token is %s\n", token);
}
```

---

## 💡 Vulnerability Analysis

The binary requires UID 4242 (flag13's UID). Two approaches:

1. **GDB Jump** — Skip the UID check entirely
2. **Reverse `ft_des`** — Extract and run the decryption function

---

## 🎯 Exploitation

### Method 1: GDB Jump (Faster)

```bash
level13@SnowCrash:~$ gdb -q ./level13
(gdb) disassemble main
```

```asm
   0x08048595 <+9>:     call   0x8048380 <getuid@plt>
   0x0804859a <+14>:    cmp    $0x1092,%eax
   0x0804859f <+19>:    je     0x80485cb <main+63>    ← Jump target
   ...
   0x080485cb <+63>:    movl   $0x80486ef,(%esp)     ← After check
   0x080485d2 <+70>:    call   0x8048474 <ft_des>
```

```bash
(gdb) break *0x0804859f
Breakpoint 1 at 0x804859f

(gdb) run
Breakpoint 1, 0x0804859f in main ()

(gdb) jump *0x080485cb
Continuing at 0x80485cb.
your token is 2A31L79asukciNyi8uppkEuSx
```

### Method 2: Reverse the Decryption

<details>
<summary>Click to expand ft_des implementation</summary>

```c
char *ft_des(char *param_1) {
    char *param_copy = strdup(param_1);
    char num_str[] = "0123456";
    uint param_index = 0;
    int num_index = 0;
    uint param_len = strlen(param_copy);
    
    while (param_index < param_len) {
        if (num_index == 6)
            num_index = 0;
        
        if ((param_index & 1) == 0) {
            // Even positions: subtract
            for (int i = 0; i < num_str[num_index]; i++) {
                param_copy[param_index]--;
                if (param_copy[param_index] == 0x1f)
                    param_copy[param_index] = '~';
            }
        } else {
            // Odd positions: add
            for (int j = 0; j < num_str[num_index]; j++) {
                param_copy[param_index]++;
                if (param_copy[param_index] == 0x7f)
                    param_copy[param_index] = ' ';
            }
        }
        param_index++;
        num_index++;
    }
    return param_copy;
}
```

</details>

Compile and run locally to get the same result.

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `2A31L79asukciNyi8uppkEuSx` |

---

## 📚 References

- [GDB Jump Command](https://sourceware.org/gdb/current/onlinedocs/gdb/Jumping.html)
- [Ghidra Decompiler](https://ghidra-sre.org/)