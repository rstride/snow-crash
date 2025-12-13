# 🔐 Level 09

> **Category:** Custom Encoding Reversal  
> **Difficulty:** ⭐⭐⭐☆☆  
> **Key Technique:** Position-based character encoding reversal

---

## 📋 Overview

A binary encodes input by adding each character's position to its ASCII value. We reverse the algorithm to decode a token file.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level09@SnowCrash:~$ ls -l
total 12
-rwsr-sr-x 1 flag09 level09 7640 Mar  5  2016 level09
----r--r-- 1 flag09 level09   26 Mar  5  2016 token

level09@SnowCrash:~$ cat token 
f4kmm6p|=�p�n��DB�Du{��
```

### Understanding the Encoding

```bash
level09@SnowCrash:~$ ./level09 "123456789"
13579;=?A

level09@SnowCrash:~$ ./level09 "abcdefgh"
acegikmo
```

---

## 💡 Vulnerability Analysis

The binary encodes each character by adding its **position index**:

| Position | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|----------|---|---|---|---|---|---|---|---|
| Input    | a | b | c | d | e | f | g | h |
| Output   | a | c | e | g | i | k | m | o |

The formula: `output[i] = input[i] + i`

> [!TIP]
> To decode: `original[i] = encoded[i] - i`

---

## 🎯 Exploitation

### Creating a Decoder

```c
// decode.c
#include <stdio.h>

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "[-] Only one argument is accepted\n");
        return 1;
    }
    
    char *arg = argv[1];
    int i = 0;
    
    while (*arg) {
        printf("%c", *arg - i);
        i++;
        arg++;
    }
    printf("\n");
    return 0;
}
```

### Compiling and Running

```bash
# Compile in /tmp (avoids permission issues)
level09@SnowCrash:~$ cd /tmp
level09@SnowCrash:/tmp$ gcc decode.c -o decode

# Decode the token
level09@SnowCrash:/tmp$ cat ~/token | xargs ./decode
f3iji1ju5yuevaus41q1afiuq
```

### Obtaining the Password

```bash
level09@SnowCrash:~$ su flag09
Password: f3iji1ju5yuevaus41q1afiuq

flag09@SnowCrash:~$ getflag
Check flag.Here is your token : s5cAJpM8ev6XHw998pRWG728z
```

---

## ✅ Flag

| Item | Value |
|------|-------|
| flag09 Password | `f3iji1ju5yuevaus41q1afiuq` |
| Token | `s5cAJpM8ev6XHw998pRWG728z` |

---

## 📚 References

- [Character Encoding](https://en.wikipedia.org/wiki/Character_encoding)
- [ASCII Table](https://www.asciitable.com/)