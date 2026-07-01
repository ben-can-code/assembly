# BIT 4220: Assembly Programming — Group Work

> **Course:** BIT 4220 Assembly Programming
> **Task:** Group Work (50 marks)
> **Platform:** Linux x86-64
> **Assembler:** NASM (Netwide Assembler)

---

## Repository Structure

```
assembly/
├── task1/
│   ├── hello.asm                # Program 1 — Hello World, syscall demo
│   ├── data_representation.asm  # Program 2 — Bytes, words, dwords, ASCII
│   ├── endian.asm               # Program 3 — Little-endian, two's complement, binary/hex
│   └── Makefile                 # Build all task1 programs
├── task3/
│   ├── alu.asm                  # ALU simulator — 10 operations, overflow detection
│   └── screenshots/             # GDB and objdump evidence screenshots
└── README.md
```

---

## Prerequisites

```bash
sudo apt update
sudo apt install nasm binutils gdb -y
```

---

## Task 1 — Data Representation Toolkit

```bash
cd task1
make          # build all three programs
make run      # build and run all
make clean    # remove binaries and .o files
```

## Task 3 — Mini ALU Simulator

```bash
cd task3
make          # build alu
./alu         # run interactively
make clean
```
