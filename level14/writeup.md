# 🔐 Level 14

> **Category:** Binary Reverse Engineering  
> **Difficulty:** ⭐⭐⭐⭐⭐  
> **Key Technique:** GDB manipulation of getflag binary

---

## 📋 Overview

The final level has no files — we must extract the flag directly from the `/bin/getflag` binary using debugging techniques.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level14@SnowCrash:~$ ls -la
# No files! Just an empty home directory
```

### Analyzing getflag

The `getflag` binary contains hardcoded encrypted tokens for each level. Decompiling reveals:

```c
// Anti-debugging checks
if (ptrace(PTRACE_TRACEME, 0, 1, 0) < 0) {
    puts("You should not reverse this");
    return 1;
}

// Check for LD_PRELOAD injection
if (getenv("LD_PRELOAD") != NULL) {
    fwrite("Injection Linked lib detected exit..\n", ...);
    return 1;
}

// UID-based flag selection
uid = getuid();
if (uid == 0xbc6) {  // 3014 = flag14
    token = ft_des("g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|");
    fputs(token, stdout);
}
// ... similar checks for all levels
```

---

## 💡 Vulnerability Analysis

The binary:
1. Uses `ptrace` to detect debuggers
2. Checks environment for injection attempts
3. Selects which encrypted token to decrypt based on UID

> [!TIP]
> We can use GDB's `jump` command to skip directly to the `ft_des` call for flag14's token.

---

## 🎯 Exploitation

### Locating the Target Address

```bash
level14@SnowCrash:~$ gdb getflag -q
(gdb) disassemble main
```

Find the last `ft_des` call (for flag14):

```asm
   0x08048de5 <+1183>:  mov    0x804b060,%eax
   0x08048dec <+1190>:  movl   $0x8049220,(%esp)    ← flag14's encrypted string
   0x08048df3 <+1197>:  call   0x8048604 <ft_des>
   0x08048df8 <+1202>:  mov    %ebx,0x4(%esp)
   0x08048dfc <+1206>:  mov    %eax,(%esp)
   0x08048dff <+1209>:  call   0x8048530 <fputs@plt>
```

### Executing the Exploit

```bash
(gdb) break main
Breakpoint 1 at 0x804894a

(gdb) run
Starting program: /bin/getflag 
Breakpoint 1, 0x0804894a in main ()

(gdb) jump *0x08048de5
Continuing at 0x8048de5.
7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
```

> [!WARNING]
> The stack smashing detection will trigger after the flag is printed — but we already have it!

### Verifying the Flag

```bash
level14@SnowCrash:~$ su flag14
Password: 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
Congratulation. Type getflag to get the key and send it to me the owner of this livecd :)

flag14@SnowCrash:~$ getflag
Check flag.Here is your token : 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag14 Password | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |
| **🎉 FINAL TOKEN** | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |

---

## 🏆 Congratulations!

You've completed all 15 levels of Snow-Crash!

---

## 📚 References

- [GDB Debugging Guide](https://sourceware.org/gdb/current/onlinedocs/gdb/)
- [Ghidra Reverse Engineering](https://ghidra-sre.org/)
- [ptrace Anti-Debugging](https://www.aldeid.com/wiki/Ptrace-anti-debugging)