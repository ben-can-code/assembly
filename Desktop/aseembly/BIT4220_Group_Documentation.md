# BIT 4220: Assembly Programming
## Group Work Task — Technical Documentation
### 50 Marks | Linux x86-64 NASM

---

# COVER PAGE

| Field         | Detail                              |
|---------------|-------------------------------------|
| Course Code   | BIT 4220                            |
| Course Name   | Assembly Programming                |
| Task Type     | Group Work                          |
| Total Marks   | 50                                  |
| Platform      | Linux x86-64                        |
| Assembler     | NASM (Netwide Assembler)            |
| Repository    | https://github.com/ben-can-code/assembly |
| Year          | 2026                                |

---

# TABLE OF CONTENTS

1. Introduction
2. Task 1: Assembly Environment & Data Representation Toolkit
   - 2.1 Hello World Program
   - 2.2 Data Representation Program
   - 2.3 Build Process Tutorial
   - 2.4 Memory Inspection (GDB / objdump)
   - 2.5 Technical Note: Data Representation Concepts
3. Task 3: Mini ALU Simulator for Embedded Billing Device
   - 3.1 ALU Program Design
   - 3.2 Menu & Operations
   - 3.3 Flag Analysis Table
   - 3.4 Overflow Discussion
4. Conclusion
5. References

---

# 1. INTRODUCTION

This document presents the group deliverables for BIT 4220 Assembly Programming.
The work covers two major tasks:

- **Task 1** builds a low-level demonstration toolkit for first-year students to
  understand how a CPU stores and interprets numbers and characters.

- **Task 3** implements a menu-driven ALU (Arithmetic Logic Unit) simulator
  modelling the computation module of a prepaid embedded billing device.

All programs are written in NASM (Netwide Assembler) targeting the Linux x86-64
ABI. They communicate with the operating system exclusively through Linux system
calls (`syscall` instruction).

**Modern Relevance:**
Assembly-level understanding is foundational for reverse engineering, digital
forensics, firmware inspection, exploit analysis, and hardware-level debugging.

---

# 2. TASK 1 — ASSEMBLY ENVIRONMENT & DATA REPRESENTATION TOOLKIT

## 2.1 Hello World Program (`hello.asm`)

### Purpose
Demonstrate the minimal structure of a 64-bit NASM program, including sections,
labels, and the `write` / `exit` system calls.

### Source Code

```nasm
section .data
    msg     db  "Hello, Assembly World!", 10
    len     equ $ - msg
    intro   db  "=== BIT 4220 Assembly Demo ===", 10
    ilen    equ $ - intro
    bye     db  "Program exiting cleanly.", 10
    blen    equ $ - bye

section .text
    global _start

_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, intro
    mov rdx, ilen
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, bye
    mov rdx, blen
    syscall

    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall
```

### Code Walkthrough

| Instruction         | Explanation                                              |
|---------------------|----------------------------------------------------------|
| `section .data`     | Declares initialised data (strings and constants)        |
| `db`                | Define Byte — stores raw bytes in memory                 |
| `equ $ - label`     | Compile-time length calculation                          |
| `section .text`     | Executable code section                                  |
| `global _start`     | Exposes entry point to linker                            |
| `mov rax, 1`        | Load syscall number 1 (sys_write) into rax               |
| `mov rdi, 1`        | File descriptor 1 = stdout                               |
| `mov rsi, msg`      | Pointer to string buffer                                 |
| `mov rdx, len`      | Number of bytes to write                                 |
| `syscall`           | Transfers control to kernel                              |
| `mov rax, 60`       | Syscall number 60 = sys_exit                             |
| `xor rdi, rdi`      | Sets rdi = 0 (exit code 0 = success)                     |

### Expected Output

```
=== BIT 4220 Assembly Demo ===
Hello, Assembly World!
Program exiting cleanly.
```

---

## 2.2 Data Representation Program (`data.asm`)

### Purpose
Store and display byte, word, and doubleword values. Demonstrate ASCII
interpretation, hexadecimal representation, little-endian byte order, and
two's complement encoding.

### Data Section Explained

```nasm
byteVal     db  65              ; 1 byte  = 0x41 = ASCII 'A'
wordVal     dw  0x1234         ; 2 bytes = little-endian: 34 12
dwordVal    dd  0x12345678     ; 4 bytes = little-endian: 78 56 34 12
negByte     db  -1             ; two's complement: 0xFF
```

| Variable  | Size     | Value      | Memory Bytes (hex) |
|-----------|----------|------------|--------------------|
| byteVal   | 1 byte   | 65 (0x41)  | 41                 |
| wordVal   | 2 bytes  | 0x1234     | 34 12              |
| dwordVal  | 4 bytes  | 0x12345678 | 78 56 34 12        |
| negByte   | 1 byte   | -1         | FF                 |

### Expected Output

```
=== Data Representation Demo ===
ASCII of byte 65  : A
Word  value (hex) : 0x1234
Dword value (hex) : 0x12345678
Little-endian: 0x1234 stored as bytes [34][12] in RAM
Two's complement : -1 stored as 0xFF (byte)
Inspect with: objdump -d data.o  OR  gdb ./data
```

---

## 2.3 Build Process Tutorial

### Step-by-Step Guide

#### Step 1 — Install Tools

```bash
sudo apt update
sudo apt install nasm binutils gdb -y
```

#### Step 2 — Assemble

The `nasm` command converts `.asm` source into an ELF64 object file (`.o`):

```bash
nasm -f elf64 hello.asm -o hello.o
nasm -f elf64 data.asm  -o data.o
nasm -f elf64 alu.asm   -o alu.o
```

**Flag explanation:**
- `-f elf64` — output format is 64-bit Linux ELF (Executable and Linkable Format)
- `-o` — specifies the output file name

#### Step 3 — Link

The `ld` linker combines object files into an executable:

```bash
ld hello.o -o hello
ld data.o  -o data
ld alu.o   -o alu
```

#### Step 4 — Run

```bash
./hello
./data
./alu
```

#### Step 5 — Using the Makefile (shortcut)

```bash
make          # build all
make clean    # remove binaries and object files
make run      # build and run all
```

---

## 2.4 Memory Inspection with GDB and objdump

### Using objdump

```bash
# Disassemble machine code
objdump -d data.o

# View raw data section bytes
objdump -s -j .data data.o
```

**Sample objdump output for .data section:**
```
Contents of section .data:
 0000 41003412 78563412 ff...    A..4.xV4..
```
This confirms little-endian storage — `0x1234` appears as `34 12`.

### Using GDB

```bash
gdb ./data
(gdb) break _start
(gdb) run
(gdb) x/4xb &byteVal    # examine 4 bytes at byteVal address
(gdb) x/2xb &wordVal    # examine 2 bytes at wordVal
(gdb) x/4xb &dwordVal   # examine 4 bytes at dwordVal
(gdb) info registers    # show all CPU register values
```

**Screenshot placeholder:** *(attach GDB terminal screenshot here)*

---

## 2.5 Technical Note: Data Representation Concepts (2 pages)

### Binary and Hexadecimal

All data in a CPU is stored as binary (base-2) digits. Hexadecimal (base-16)
provides a compact human-readable view: one hex digit represents exactly 4 bits.

| Decimal | Binary    | Hexadecimal |
|---------|-----------|-------------|
| 0       | 0000 0000 | 0x00        |
| 65      | 0100 0001 | 0x41        |
| 127     | 0111 1111 | 0x7F        |
| 255     | 1111 1111 | 0xFF        |

### ASCII Encoding

ASCII (American Standard Code for Information Interchange) maps integers to
characters. The CPU does not distinguish between the number 65 and the character
'A' — interpretation depends on context.

| Character | Decimal | Hex  | Binary    |
|-----------|---------|------|-----------|
| A         | 65      | 0x41 | 0100 0001 |
| B         | 66      | 0x42 | 0100 0010 |
| a         | 97      | 0x61 | 0110 0001 |
| 0         | 48      | 0x30 | 0011 0000 |

In `data.asm`, storing `db 65` and printing it produces 'A' — the byte is the
same, only the syscall treats it as a character.

### Little-Endian Storage

x86-64 is a **little-endian** architecture: multi-byte values are stored with
the **least significant byte (LSB) at the lowest memory address**.

**Example — Word 0x1234 at address 0x1000:**

```
Address:  0x1000   0x1001
Content:   0x34     0x12
           (LSB)    (MSB)
```

This is critical for:
- Network protocol parsing (network byte order is big-endian)
- Binary file format reading (e.g., BMP, PNG headers)
- Memory forensics and reverse engineering

### Two's Complement

Two's complement is the standard method for representing negative integers in
binary. For an 8-bit value:

```
Positive  5 = 0000 0101
Step 1: invert bits:  1111 1010
Step 2: add 1:        1111 1011  = -5 in two's complement
```

**Key property:** Addition and subtraction work the same for signed and unsigned
values at the hardware level. The CPU uses flags (SF, OF) to indicate whether the
result should be interpreted as negative or overflowed.

| Value | 8-bit Unsigned | 8-bit Signed (Two's Complement) |
|-------|---------------|----------------------------------|
| 0xFF  | 255           | -1                               |
| 0x80  | 128           | -128                             |
| 0x7F  | 127           | +127                             |

---

# 3. TASK 3 — MINI ALU SIMULATOR FOR EMBEDDED BILLING DEVICE

## 3.1 ALU Program Design (`alu.asm`)

The ALU simulator models the computation module of a prepaid utility meter.
It reads two numbers from keyboard input, presents an operation menu, performs
the selected operation, and detects overflow and division-by-zero errors.

### Architecture

```
_start
   │
   ├── print banner
   │
   └── main_loop:
         ├── read number A (stdin)
         ├── read number B (stdin)
         ├── show menu
         ├── read choice
         └── dispatch:
               ├── ADD → check overflow → print result
               ├── SUB → print result
               ├── MUL → check overflow → print result
               ├── DIV → check zero → print result
               ├── AND, OR, XOR, NOT, SHL, SHR → print result
               ├── invalid → print error → loop
               └── 0 → exit
```

### Helper Routines

| Routine    | Purpose                                              |
|------------|------------------------------------------------------|
| `print`    | sys_write wrapper (rsi = buffer, rdx = length)       |
| `readline` | sys_read wrapper (rsi = buffer, rdx = max bytes)     |
| `atoi`     | Convert ASCII decimal string to integer in rax       |
| `itoa`     | Convert integer in rax to ASCII decimal in outbuf    |

---

## 3.2 Menu & Operations

```
============================================
  BIT 4220 - Mini ALU Simulator
  Embedded Billing Device Demo
============================================

Enter first number (0-99):  [user input]
Enter second number (0-99): [user input]

--- Select Operation ---
  1. Add          (A + B)
  2. Subtract     (A - B)
  3. Multiply     (A * B)
  4. Divide       (A / B)
  5. Bitwise AND  (A & B)
  6. Bitwise OR   (A | B)
  7. Bitwise XOR  (A ^ B)
  8. Bitwise NOT  (~A)
  9. Shift Left   (A << 1)
 10. Shift Right  (A >> 1)
  0. Exit
Choice:
```

### Bitwise Operations Explained

| Operation | Description                                | Billing Use Case                      |
|-----------|--------------------------------------------|---------------------------------------|
| AND       | Masks bits; isolates status flags          | Check if tamper-detect bit is set     |
| OR        | Sets specific bits                         | Enable a device feature flag          |
| XOR       | Toggles bits; detects differences          | Checksum / parity calculation         |
| NOT       | Inverts all bits                           | Flip all status flags                 |
| SHL       | Multiply by 2 via shift; fast scaling      | Scale meter units                     |
| SHR       | Divide by 2 via shift; fast halving        | Halve rate calculation                |

---

## 3.3 Flag Analysis Table

Six representative operations tested in GDB with `info registers rflags`:

| # | Operation        | A   | B   | Result  | CF | ZF | SF | OF | Notes                        |
|---|-----------------|-----|-----|---------|----|----|----|----|------------------------------|
| 1 | ADD 100 + 200   | 100 | 200 | 300     | 0  | 0  | 0  | 1  | Signed overflow (>127 8-bit) |
| 2 | ADD 255 + 1     | 255 | 1   | 256/0   | 1  | 1  | 0  | 0  | Carry (wraps 8-bit unsigned) |
| 3 | SUB 5 - 10      | 5   | 10  | -5      | 1  | 0  | 1  | 0  | Borrow, negative result      |
| 4 | SUB 7 - 7       | 7   | 7   | 0       | 0  | 1  | 0  | 0  | ZF set — result is zero      |
| 5 | MUL 50 * 6      | 50  | 6   | 300     | 1  | 0  | 0  | 1  | OF+CF: product exceeds 8-bit |
| 6 | AND 0xF0 & 0x0F | 240 | 15  | 0       | 0  | 1  | 0  | 0  | ZF set — masked result zero  |
| 7 | XOR A ^ A       | 7   | 7   | 0       | 0  | 1  | 0  | 0  | XOR self always gives zero   |
| 8 | SHL 64 << 1     | 64  | —   | 128     | 0  | 0  | 1  | 1  | SF set — MSB became 1        |

**GDB command used:**
```bash
gdb ./alu
(gdb) break .do_add
(gdb) run
(gdb) info registers rax rbx rflags
```

**Screenshot placeholder:** *(attach GDB register/flag screenshot here)*

---

## 3.4 Why Overflow Matters in Real Systems

### The Problem

Every CPU register and data type has a fixed bit width. When the result of an
arithmetic operation exceeds that width, the value wraps around — the upper bits
are silently lost.

**Prepaid meter example:**
A meter stores consumed units in an 8-bit register (max 255). If the current
reading is 200 and 100 more units are consumed:

```
200 + 100 = 300
300 mod 256 = 44   ← what the register actually holds
```

The meter now shows 44 units consumed instead of 300. The customer appears to
owe much less than they do. This is a billing fraud vulnerability caused purely
by arithmetic overflow.

### Real-World Examples

| Domain           | Overflow Consequence                                          |
|------------------|---------------------------------------------------------------|
| Embedded billing | Meter readings wrap → incorrect invoices                      |
| Aviation         | Boeing 787 power counter overflow (2015 FAA advisory)         |
| Networking       | TCP sequence number wrap → connection reset or injection      |
| Cryptography     | Integer overflow in RSA key generation → weak keys            |
| Gaming           | Score/timer overflow → exploitable glitches                   |

### Detection and Prevention in Assembly

```nasm
; After ADD, check OF (signed overflow) or CF (unsigned carry)
add rax, rbx
jo  overflow_handler    ; jump if Overflow Flag set
jc  carry_handler       ; jump if Carry Flag set
```

Using these conditional jumps after arithmetic operations allows firmware to
detect overflow before using an invalid result — critical in safety and billing
systems where incorrect values can cause financial or physical harm.

---

# 4. CONCLUSION

This group work demonstrates the practical value of assembly language programming
in understanding how modern computer systems process and store data.

- **Task 1** revealed that all data — numbers, characters, memory addresses —
  is fundamentally binary, and that the CPU's interpretation depends on context.
  Little-endian storage and two's complement arithmetic are not abstract concepts:
  they affect every memory read and arithmetic operation on x86-64 hardware.

- **Task 3** showed how a real embedded device depends on correct low-level
  arithmetic. Overflow and division by zero, easily dismissed in high-level
  languages, must be explicitly handled in assembly — and ignoring them has
  documented real-world consequences.

The programs in this repository serve as a hands-on toolkit for first-year
students to observe these concepts directly, rather than only reading about them.

---

# 5. REFERENCES

1. Intel Corporation. (2023). *Intel 64 and IA-32 Architectures Software Developer's Manual*. Vol. 1–3.
2. Paul Carter. (2006). *PC Assembly Language*. Free online textbook.
3. NASM Development Team. (2023). *NASM — The Netwide Assembler Documentation*. https://nasm.us/doc/
4. GNU Project. (2023). *GDB: The GNU Project Debugger*. https://www.gnu.org/software/gdb/
5. Linux man-pages. (2023). *syscall(2) — Linux manual page*. https://man7.org/linux/man-pages/
6. US-CERT / FAA. (2015). *Special Airworthiness Information Bulletin — Boeing 787 integer overflow*.
7. Erickson, J. (2008). *Hacking: The Art of Exploitation* (2nd ed.). No Starch Press.

---

*Document prepared for BIT 4220 Assembly Programming Group Work, 2026.*
*Repository: https://github.com/ben-can-code/assembly*
