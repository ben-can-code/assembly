; =============================================================================
; endian.asm - Task 1, Program 3: Binary, Hex, Two's Complement & Little-Endian
; BIT 4220: Assembly Programming - Group Work
;
; Purpose: Demonstrate how x86-64 stores multi-byte values in little-endian
;          order. Show two's complement for negative numbers. Show binary and
;          hex representations side by side using labeled output strings.
;          Use GDB / objdump to confirm memory layout (see README).
;
; Build:
;   nasm -f elf64 endian.asm -o endian.o
;   ld endian.o -o endian
;
; Run:
;   ./endian
;
; Concepts covered:
;   - Binary (base-2) representation
;   - Hexadecimal (base-16) shorthand
;   - ASCII: same bits, different context
;   - Little-endian byte ordering (LSB at lowest address)
;   - Two's complement: negative numbers in binary
;   - Register-sized constants: byte(8b) word(16b) dword(32b) qword(64b)
; =============================================================================

section .data

    ; -----------------------------------------------------------------------
    ; Register-sized constants -- these sit in .data so objdump can show them
    ; -----------------------------------------------------------------------
    reg_byte    db  0xA5                ; 8-bit  : 1010 0101
    reg_word    dw  0x1234             ; 16-bit : stored as 34 12
    reg_dword   dd  0x12345678         ; 32-bit : stored as 78 56 34 12
    reg_qword   dq  0x0102030405060708 ; 64-bit : stored as 08 07 06 05 04 03 02 01

    ; Two's complement examples
    neg_one     db  -1                 ; 0xFF  (255 unsigned, -1 signed)
    neg_five    db  -5                 ; 0xFB  (251 unsigned, -5 signed)
    neg_128     db  -128               ; 0x80  (128 unsigned, -128 signed)

    ; -----------------------------------------------------------------------
    ; Display strings
    ; -----------------------------------------------------------------------
    sep         db  "------------------------------------------------", 10
    seplen      equ $ - sep

    title       db  "=== Endianness, Binary, Hex & Two's Complement ===", 10
    tlen        equ $ - title

    s_bin       db  10, "-- Binary & Hex Representations --", 10
    s_binlen    equ $ - s_bin

    l1  db  "  0xA5  = 1010 0101  (8-bit byte)", 10
    l1l equ $ - l1
    l2  db  "  0x1234 = 0001 0010 0011 0100  (16-bit word)", 10
    l2l equ $ - l2
    l3  db  "  0x12345678 = 32-bit doubleword", 10
    l3l equ $ - l3
    l4  db  "  0x0102030405060708 = 64-bit quadword", 10
    l4l equ $ - l4

    s_le        db  10, "-- Little-Endian Storage --", 10
    s_lelen     equ $ - s_le

    le1 db  "  Word 0x1234 in memory (low addr first): [34] [12]", 10
    le1l equ $ - le1
    le2 db  "  Dword 0x12345678 in memory:  [78] [56] [34] [12]", 10
    le2l equ $ - le2
    le3 db  "  Qword 0x0102..0708 in memory: [08][07][06][05][04][03][02][01]", 10
    le3l equ $ - le3
    le4 db  "  Rule: Least Significant Byte (LSB) lives at LOWEST address", 10
    le4l equ $ - le4

    s_tc        db  10, "-- Two's Complement (Negative Numbers) --", 10
    s_tclen     equ $ - s_tc

    tc1 db  "  -1   stored as 0xFF  (1111 1111)", 10
    tc1l equ $ - tc1
    tc2 db  "  -5   stored as 0xFB  (1111 1011)", 10
    tc2l equ $ - tc2
    tc3 db  "  -128 stored as 0x80  (1000 0000) <- minimum signed byte", 10
    tc3l equ $ - tc3
    tc4 db  "  How: invert all bits of +N, then add 1", 10
    tc4l equ $ - tc4
    tc5 db  "  Example: +5 = 0000 0101 -> invert -> 1111 1010 -> +1 -> 1111 1011 = -5", 10
    tc5l equ $ - tc5

    s_ascii     db  10, "-- ASCII: Same Bits, Different Context --", 10
    s_asclen    equ $ - s_ascii

    asc1 db  "  Byte 0x41 = 65 decimal = character 'A'", 10
    asc1l equ $ - asc1
    asc2 db  "  Byte 0x48 = 72 decimal = character 'H'", 10
    asc2l equ $ - asc2
    asc3 db  "  The CPU stores the same bits -- context decides the meaning", 10
    asc3l equ $ - asc3

    s_gdb       db  10, "-- Inspect with GDB / objdump --", 10
    s_gdblen    equ $ - s_gdb

    gdb1 db  "  objdump -s -j .data endian.o", 10
    gdb1l equ $ - gdb1
    gdb2 db  "  gdb ./endian  ->  x/8xb &reg_word  to see bytes in memory", 10
    gdb2l equ $ - gdb2

section .text
    global _start

; ---- macro-free print helper: rsi=addr, rdx=len ----
print:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

_start:
    mov rsi, sep        ; separator line
    mov rdx, seplen
    call print

    mov rsi, title
    mov rdx, tlen
    call print

    mov rsi, sep
    mov rdx, seplen
    call print

    ; binary & hex section
    mov rsi, s_bin
    mov rdx, s_binlen
    call print
    mov rsi, l1 ;  mov rdx, l1l
    mov rdx, l1l
    call print
    mov rsi, l2
    mov rdx, l2l
    call print
    mov rsi, l3
    mov rdx, l3l
    call print
    mov rsi, l4
    mov rdx, l4l
    call print

    ; little-endian section
    mov rsi, s_le
    mov rdx, s_lelen
    call print
    mov rsi, le1
    mov rdx, le1l
    call print
    mov rsi, le2
    mov rdx, le2l
    call print
    mov rsi, le3
    mov rdx, le3l
    call print
    mov rsi, le4
    mov rdx, le4l
    call print

    ; two's complement section
    mov rsi, s_tc
    mov rdx, s_tclen
    call print
    mov rsi, tc1
    mov rdx, tc1l
    call print
    mov rsi, tc2
    mov rdx, tc2l
    call print
    mov rsi, tc3
    mov rdx, tc3l
    call print
    mov rsi, tc4
    mov rdx, tc4l
    call print
    mov rsi, tc5
    mov rdx, tc5l
    call print

    ; ASCII section
    mov rsi, s_ascii
    mov rdx, s_asclen
    call print
    mov rsi, asc1
    mov rdx, asc1l
    call print
    mov rsi, asc2
    mov rdx, asc2l
    call print
    mov rsi, asc3
    mov rdx, asc3l
    call print

    ; GDB hints
    mov rsi, s_gdb
    mov rdx, s_gdblen
    call print
    mov rsi, gdb1
    mov rdx, gdb1l
    call print
    mov rsi, gdb2
    mov rdx, gdb2l
    call print

    mov rsi, sep
    mov rdx, seplen
    call print

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
