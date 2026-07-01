# Task 3 — Mini ALU Simulator for Embedded Billing Device
## BIT 4220: Assembly Programming

---

## Overview

A prepaid utility meter requires a small low-level computation module to add units, subtract usage, multiply rates, divide balances, and apply bit masks for device status. This program is a menu-driven ALU simulator written in 64-bit NASM assembly.

**Modern relevance:** Bitwise operations are used in device-status registers, cryptography, compression, networking headers, and hardware control.

---

## Files

| File | Description |
|---|---|
| `alu.asm` | Full ALU simulator source code |
| `Makefile` | Build script |
| `README.md` | This file |

---

## Build and Run

```bash
make          # assemble and link
./alu         # run interactively
```

Or:
```bash
make run
```

### Manual build steps
```bash
nasm -f elf64 alu.asm -o alu.o
ld alu.o -o alu
./alu
```

---

## Program Menu

```
============================================
  BIT 4220 - Mini ALU Simulator
  Embedded Billing Device Demo
============================================

Enter first number  A (0-99): 15
Enter second number B (0-99): 4

--- Select Operation ---
  1.  Add          (A + B)
  2.  Subtract     (A - B)
  3.  Multiply     (A * B)
  4.  Divide       (A / B)
  5.  Bitwise AND  (A & B)
  6.  Bitwise OR   (A | B)
  7.  Bitwise XOR  (A ^ B)
  8.  Bitwise NOT  (~A)
  9.  Shift Left   (A << 1)
 10.  Shift Right  (A >> 1)
  0.  Exit
Choice:
```

---

## Operations and Assembly Instructions

| Choice | Operation | Assembly Instruction | Notes |
|---|---|---|---|
| 1 | Add | `add rax, r13` | CF/OF set on overflow |
| 2 | Subtract | `sub rax, r13` | CF set on borrow, SF on negative |
| 3 | Multiply | `imul rax, r13` | Signed; OF+CF set if product > 8-bit |
| 4 | Divide | `div r13` | Quotient in rax; error on divisor=0 |
| 5 | AND | `and rax, r13` | ZF set if result = 0 |
| 6 | OR | `or rax, r13` | |
| 7 | XOR | `xor rax, r13` | ZF set if A=B |
| 8 | NOT | `not rax` then `and rax, 0xFF` | Masked to 8-bit |
| 9 | Shift Left | `shl rax, 1` | Equivalent to multiply by 2 |
| 10 | Shift Right | `shr rax, 1` | Equivalent to divide by 2 |

---

## Error Handling

| Condition | Detection | Response |
|---|---|---|
| Invalid menu choice | `cmp rax, 10` / `jg` | Prints error, returns to menu |
| Division by zero | `cmp r13, 0` / `je` | Prints error, skips division |
| Overflow (>255) | `cmp rax, 255` / `jg` | Prints warning, shows actual result |

---

## Flag Analysis Table

Tested with GDB using `info registers rflags` after each operation:

| # | Operation | A | B | Result | CF | ZF | SF | OF | Notes |
|---|---|---|---|---|---|---|---|---|---|
| 1 | ADD 100 + 200 | 100 | 200 | 300 | 0 | 0 | 0 | 1 | Signed overflow |
| 2 | ADD 255 + 1 | 255 | 1 | 256 | 1 | 0 | 0 | 0 | Unsigned carry |
| 3 | SUB 5 - 10 | 5 | 10 | -5 | 1 | 0 | 1 | 0 | Borrow + negative |
| 4 | SUB 7 - 7 | 7 | 7 | 0 | 0 | 1 | 0 | 0 | Zero result |
| 5 | MUL 50 × 6 | 50 | 6 | 300 | 1 | 0 | 0 | 1 | Product > 8-bit |
| 6 | AND 0xF0 & 0x0F | 240 | 15 | 0 | 0 | 1 | 0 | 0 | No common bits |
| 7 | XOR 7 ^ 7 | 7 | 7 | 0 | 0 | 1 | 0 | 0 | XOR self = 0 |
| 8 | SHL 64 << 1 | 64 | — | 128 | 0 | 0 | 1 | 1 | MSB = 1 |

**GDB commands:**
```bash
gdb ./alu
(gdb) break _start
(gdb) run
(gdb) stepi
(gdb) info registers rax rbx rflags
```

---

## Why Overflow Matters in Real Systems

In embedded billing devices, registers have fixed bit widths. An 8-bit register holds 0–255. If a meter reads 200 units and 100 more are consumed:

```
200 + 100 = 300
300 mod 256 = 44  ← wrong value silently stored
```

The device records 44 units — far less than the real usage. Without the overflow check (`cmp rax, 255` / `jo`), this corrupted value flows into all subsequent billing calculations.

Real-world cases:
- **Boeing 787 (2015):** 32-bit power counter overflow after 248 days — FAA airworthiness advisory issued
- **TCP sequence numbers:** Wrap-around exploited in older session-hijacking attacks
- **Cryptography:** RSA implementations with integer overflow → weak keys

The x86-64 CPU sets CF (unsigned overflow) and OF (signed overflow) after every arithmetic instruction. Code must explicitly check these flags to handle errors.
