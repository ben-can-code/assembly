# BIT 4220: Assembly Programming — Group Work

> **Course:** BIT 4220 Assembly Programming  
> **Task:** Group Work (50 marks)  
> **Target Platform:** Linux x86-64 (64-bit)  
> **Assembler:** NASM (Netwide Assembler)

---

## Repository Structure

```
assembly/
├── hello.asm       # Task 1 – Hello World & syscall demo
├── data.asm        # Task 1 – Data representation (byte/word/dword, ASCII, little-endian, two's complement)
├── alu.asm         # Task 3 – Mini ALU Simulator (menu-driven arithmetic + bitwise ops)
├── Makefile        # Build script for all programs
└── README.md       # This file
```

---

## Prerequisites

Install the required tools on Ubuntu/Debian Linux:

```bash
sudo apt update
sudo apt install nasm binutils gdb -y
```

- **nasm** — assembler
- **binutils** — provides `ld` (linker) and `objdump`
- **gdb** — GNU Debugger for register/flag inspection

---

## Building the Programs

### Build all at once

```bash
make
```

### Build individually

```bash
make hello
make data
make alu
```

### Clean build artifacts

```bash
make clean
```

---

## Running the Programs

### Task 1 — Hello World

```bash
./hello
```

**Expected output:**
```
=== BIT 4220 Assembly Demo ===
Hello, Assembly World!
Program exiting cleanly.
```

### Task 1 — Data Representation

```bash
./data
```

**Expected output:**
```
=== Data Representation Demo ===
ASCII of byte 65  : A
Word  value (hex) : 0x1234
Dword value (hex) : 0x12345678
Little-endian: 0x1234 stored as bytes [34][12] in RAM
Two's complement : -1 stored as 0xFF (byte)
Inspect with: objdump -d data.o  OR  gdb ./data
```

### Task 3 — ALU Simulator

```bash
./alu
```

Follow the on-screen menu to select operations.

---

## Inspecting Memory Layout

### Using objdump

```bash
objdump -d data.o
objdump -s -j .data data.o
```

The `-s -j .data` flags dump the raw bytes of the `.data` section, showing little-endian storage.

### Using GDB

```bash
gdb ./data
(gdb) break _start
(gdb) run
(gdb) info registers
(gdb) x/8xb &byteVal
```

For the ALU:

```bash
gdb ./alu
(gdb) break .do_add
(gdb) run
(gdb) info registers rax rbx rflags
```

---

## Flag Analysis Table (Task 3 — ALU)

| # | Operation       | A   | B   | Result | CF | ZF | SF | OF |
|---|-----------------|-----|-----|--------|----|----|----|-----|
| 1 | ADD 100 + 200   | 100 | 200 | 300    | 0  | 0  | 0  | 1  |
| 2 | ADD 255 + 1     | 255 | 1   | 256    | 1  | 0  | 0  | 0  |
| 3 | SUB 5 - 10      | 5   | 10  | -5     | 1  | 0  | 1  | 0  |
| 4 | SUB 7 - 7       | 7   | 7   | 0      | 0  | 1  | 0  | 0  |
| 5 | MUL 50 * 6      | 50  | 6   | 300    | 0  | 0  | 0  | 1  |
| 6 | AND 0xF0 & 0x0F | 240 | 15  | 0      | 0  | 1  | 0  | 0  |
| 7 | XOR A ^ A       | 7   | 7   | 0      | 0  | 1  | 0  | 0  |
| 8 | SHL 64 << 1     | 64  | —   | 128    | 0  | 0  | 1  | 1  |

*CF = Carry Flag, ZF = Zero Flag, SF = Sign Flag, OF = Overflow Flag*

---

## Overflow Discussion

Overflow occurs when an arithmetic result exceeds the range representable by the destination register or data type. In an embedded billing device:

- **8-bit counters** roll over at 255 → a meter reading of 200 units + 100 units = 44 (wrong) without overflow detection.
- **Unsigned overflow (carry):** adds more units than the register can hold.
- **Signed overflow:** subtracting a larger debt from a smaller balance flips the sign bit, showing a positive balance that is actually negative.

The OF (overflow) and CF (carry) flags in x86-64 allow software to detect and handle these conditions explicitly.

---

## Build Process Summary (Tutorial)

1. Write source in `.asm` file using NASM syntax.
2. Assemble: `nasm -f elf64 <file>.asm -o <file>.o`
3. Link: `ld <file>.o -o <file>`
4. Run: `./<file>`

The `-f elf64` flag targets 64-bit Linux ELF format. System calls use the `syscall` instruction with call numbers in `rax`.

---

## Authors

BIT 4220 Group — 2026
