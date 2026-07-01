# BIT 4220: Assembly Programming — Group Work

> **Course:** BIT 4220 Assembly Programming
> **Task:** Group Work (50 marks)
> **Platform:** Linux x86-64
> **Assembler:** NASM (Netwide Assembler)
> **Repository:** https://github.com/ben-can-code/assembly

---

## Repository Structure

```
assembly/
├── task1/
│   ├── hello.asm                 # Program 1 — Hello World, syscall demo
│   ├── data_representation.asm  # Program 2 — Bytes, words, dwords, ASCII
│   ├── endian.asm               # Program 3 — Little-endian, two's complement, binary/hex
│   ├── Makefile                 # Build script for all task1 programs
│   ├── README.md                # Task 1 setup guide and tutorial
│   └── screenshots/             # GDB and objdump evidence screenshots
│
├── task3/
│   ├── alu.asm                  # ALU simulator (menu-driven, 10 operations)
│   ├── Makefile                 # Build script for ALU
│   └── README.md                # Task 3 setup, flag table, overflow discussion
│
├── Makefile                     # Root build — builds task1 and task3 together
└── README.md                    # This file
```

---

## Quick Start

### Build everything
```bash
make
```

### Build task1 only
```bash
make task1
```

### Build task3 only
```bash
make task3
```

### Clean all
```bash
make clean
```

---

## Task 1 — Data Representation Toolkit

Three programs demonstrating how the CPU stores and interprets data.

| Program | What it shows |
|---|---|
| `hello.asm` | NASM structure, sections, sys_write, sys_exit |
| `data_representation.asm` | db / dw / dd directives, ASCII interpretation |
| `endian.asm` | Little-endian byte order, two's complement, binary, hex |

See [task1/README.md](task1/README.md) for full build steps, expected output, and GDB inspection commands.

---

## Task 3 — Mini ALU Simulator

Menu-driven ALU with 10 operations, overflow detection, and division-by-zero guard.

Operations: Add, Subtract, Multiply, Divide, AND, OR, XOR, NOT, SHL, SHR.

See [task3/README.md](task3/README.md) for build steps, flag analysis table, and overflow discussion.

---

## Prerequisites

```bash
sudo apt update
sudo apt install nasm binutils gdb -y
```
