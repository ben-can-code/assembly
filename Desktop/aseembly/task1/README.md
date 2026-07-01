# Task 1 — Assembly Environment & Data Representation Toolkit
## BIT 4220: Assembly Programming

---

## Programs in this folder

| File | Description |
|---|---|
| `hello.asm` | Hello-world style program — demonstrates NASM structure and syscalls |
| `data_representation.asm` | Stores bytes, words, doublewords — prints ASCII interpretation |
| `endian.asm` | Demonstrates little-endian storage, two's complement, binary/hex |
| `Makefile` | Builds all three programs |
| `screenshots/` | GDB and objdump evidence (add screenshots here) |

---

## Prerequisites

```bash
sudo apt update
sudo apt install nasm binutils gdb -y
```

---

## Build and Run

### Build all programs at once
```bash
make
```

### Build individually
```bash
make hello
make data_rep
make endian
```

### Run all programs
```bash
make run
```

### Clean build artifacts
```bash
make clean
```

---

## Program 1 — hello.asm

Demonstrates the minimal 64-bit NASM program structure.

### Manual build
```bash
nasm -f elf64 hello.asm -o hello.o
ld hello.o -o hello
./hello
```

### Expected output
```
=== BIT 4220 Assembly Demo ===
Hello, Assembly World!
Program exiting cleanly.
```

### How it works
- `section .data` — holds the string constants
- `section .text` — holds the executable instructions
- `global _start` — marks the entry point for the linker
- `mov rax, 1` — system call number 1 = `sys_write`
- `mov rdi, 1` — file descriptor 1 = stdout
- `syscall` — transfers control to the Linux kernel
- `mov rax, 60` + `xor rdi, rdi` + `syscall` — clean exit with code 0

---

## Program 2 — data_representation.asm

Stores bytes (`db`), words (`dw`), and doublewords (`dd`) and prints their ASCII interpretation.

### Manual build
```bash
nasm -f elf64 data_representation.asm -o data_representation.o
ld data_representation.o -o data_representation
./data_representation
```

### Expected output
```
=== Data Types and ASCII Demo ===
Byte  (db 65)  -> ASCII: A
Byte  (db 66)  -> ASCII: B
Byte  (db 67)  -> ASCII: C
Word  (dw 0x4849) -> ASCII: HI
Dword (dd 0x12345678) -> hex stored little-endian in memory
  Memory layout: [78][56][34][12] at increasing addresses
Run: objdump -s -j .data data_representation.o  to verify
Live byte print -> A
Live word  print -> HI
```

### Data directives explained

| Directive | Size | Example | Notes |
|---|---|---|---|
| `db` | 1 byte | `db 65` | 0x41 — prints as 'A' |
| `dw` | 2 bytes | `dw 0x1234` | stored as `34 12` in memory |
| `dd` | 4 bytes | `dd 0x12345678` | stored as `78 56 34 12` in memory |
| `dq` | 8 bytes | `dq 0x...` | 64-bit quadword |

---

## Program 3 — endian.asm

Covers little-endian byte ordering, two's complement, binary/hex representations, and register-sized constants.

### Manual build
```bash
nasm -f elf64 endian.asm -o endian.o
ld endian.o -o endian
./endian
```

### Expected output
```
------------------------------------------------
=== Endianness, Binary, Hex & Two's Complement ===
------------------------------------------------

-- Binary & Hex Representations --
  0xA5  = 1010 0101  (8-bit byte)
  0x1234 = 0001 0010 0011 0100  (16-bit word)
  0x12345678 = 32-bit doubleword
  0x0102030405060708 = 64-bit quadword

-- Little-Endian Storage --
  Word 0x1234 in memory (low addr first): [34] [12]
  Dword 0x12345678 in memory:  [78] [56] [34] [12]
  ...

-- Two's Complement (Negative Numbers) --
  -1   stored as 0xFF  (1111 1111)
  -5   stored as 0xFB  (1111 1011)
  -128 stored as 0x80  (1000 0000)
  ...

-- ASCII: Same Bits, Different Context --
  Byte 0x41 = 65 decimal = character 'A'
  ...
```

---

## Memory Inspection — GDB and objdump

### objdump: inspect .data section bytes

```bash
objdump -s -j .data data_representation.o
objdump -s -j .data endian.o
objdump -d endian.o
```

Or use the Makefile shortcut:
```bash
make inspect
```

The output shows raw hex bytes for each variable in memory order — confirming little-endian storage.

### GDB: inspect live register and memory values

```bash
gdb ./endian
(gdb) break _start
(gdb) run
(gdb) x/2xb &reg_word      # show 2 bytes at reg_word address
(gdb) x/4xb &reg_dword     # show 4 bytes at reg_dword address
(gdb) x/8xb &reg_qword     # show 8 bytes at reg_qword address
(gdb) x/1xb &neg_one       # confirm 0xFF for -1
(gdb) info registers        # all CPU register values
(gdb) info registers rflags # flags register
```

**Add your screenshots to the `screenshots/` folder.**

---

## Compile → Link → Run — Summary for Students

```
Source (.asm)
     │
     │  nasm -f elf64 file.asm -o file.o
     ▼
Object file (.o)   ← machine code, not yet executable
     │
     │  ld file.o -o file
     ▼
Executable (file)  ← ready to run
     │
     │  ./file
     ▼
Output on terminal
```

| Stage | Tool | What it does |
|---|---|---|
| Assemble | `nasm` | Converts NASM source to ELF64 machine code object file |
| Link | `ld` | Resolves symbols, produces final standalone executable |
| Run | `./file` | OS loads the ELF binary, jumps to `_start` |
| Inspect | `objdump` | Shows machine code and raw data bytes without running |
| Debug | `gdb` | Steps through instructions live, shows registers and memory |

---

## Screenshots

Place the following screenshots in the `screenshots/` folder:

1. `objdump_data.png` — objdump output showing .data section bytes for `data_representation.o`
2. `objdump_endian.png` — objdump output for `endian.o` confirming little-endian layout
3. `gdb_registers.png` — GDB `info registers` output after `break _start` + `run`
4. `gdb_memory.png` — GDB `x/4xb &reg_dword` output showing byte order
5. `terminal_hello.png` — terminal showing `./hello` output
6. `terminal_data.png` — terminal showing `./data_representation` output
7. `terminal_endian.png` — terminal showing `./endian` output
