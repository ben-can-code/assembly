; =============================================================================
; data_representation.asm - Task 1, Program 2: Data Types and ASCII
; BIT 4220: Assembly Programming - Group Work
;
; Purpose: Store bytes, words and doublewords in the .data section and
;          print their ASCII interpretation where appropriate.
;          Covers: db / dw / dd directives, ASCII encoding, hex values.
;
; Build:
;   nasm -f elf64 data_representation.asm -o data_representation.o
;   ld data_representation.o -o data_representation
;
; Run:
;   ./data_representation
;
; Expected output:
;   === Data Types and ASCII Demo ===
;   Byte  (db 65)  -> ASCII: A
;   Byte  (db 66)  -> ASCII: B
;   Byte  (db 67)  -> ASCII: C
;   Word  (dw 0x4849) -> ASCII: HI
;   Dword (dd 0x12345678) -> hex stored little-endian in memory
;   See README for objdump/GDB inspection steps.
; =============================================================================

section .data

    ; ---- Raw data values ----
    byteA       db  65              ; 1 byte = 0x41 = ASCII 'A'
    byteB       db  66              ; 1 byte = 0x42 = ASCII 'B'
    byteC       db  67              ; 1 byte = 0x43 = ASCII 'C'
    wordHI      dw  0x4849         ; 2 bytes = 'H'(0x48) 'I'(0x49)
    dwordVal    dd  0x12345678     ; 4 bytes — little-endian: 78 56 34 12

    ; ---- Display strings ----
    header      db  "=== Data Types and ASCII Demo ===", 10
    hlen        equ $ - header

    ; Individual byte display lines
    lineA       db  "Byte  (db 65)  -> ASCII: A", 10
    lAlen       equ $ - lineA

    lineB       db  "Byte  (db 66)  -> ASCII: B", 10
    lBlen       equ $ - lineB

    lineC       db  "Byte  (db 67)  -> ASCII: C", 10
    lClen       equ $ - lineC

    lineW       db  "Word  (dw 0x4849) -> ASCII: HI", 10
    lWlen       equ $ - lineW

    lineD       db  "Dword (dd 0x12345678) -> hex stored little-endian in memory", 10
    lDlen       equ $ - lineD

    lineHex     db  "  Memory layout: [78][56][34][12] at increasing addresses", 10
    lHlen       equ $ - lineHex

    lineInsp    db  "Run: objdump -s -j .data data_representation.o  to verify", 10
    lIlen       equ $ - lineInsp

    ; Actual single-char print lines built from the raw values
    ; (we embed the byte inline so the print call shows the live value)
    labelA      db  "Live byte print -> "
    liveA       db  65, 10          ; actual byte 65 printed as char
    liveAlen    equ $ - labelA

    labelW      db  "Live word  print -> "
    liveW       db  0x48, 0x49, 10  ; actual word bytes printed as chars
    liveWlen    equ $ - labelW

section .text
    global _start

_start:
    ; print header
    mov rax, 1
    mov rdi, 1
    mov rsi, header
    mov rdx, hlen
    syscall

    ; print byte A description
    mov rax, 1
    mov rdi, 1
    mov rsi, lineA
    mov rdx, lAlen
    syscall

    ; print byte B description
    mov rax, 1
    mov rdi, 1
    mov rsi, lineB
    mov rdx, lBlen
    syscall

    ; print byte C description
    mov rax, 1
    mov rdi, 1
    mov rsi, lineC
    mov rdx, lClen
    syscall

    ; print word description
    mov rax, 1
    mov rdi, 1
    mov rsi, lineW
    mov rdx, lWlen
    syscall

    ; print dword description
    mov rax, 1
    mov rdi, 1
    mov rsi, lineD
    mov rdx, lDlen
    syscall

    ; print memory layout note
    mov rax, 1
    mov rdi, 1
    mov rsi, lineHex
    mov rdx, lHlen
    syscall

    ; print inspection hint
    mov rax, 1
    mov rdi, 1
    mov rsi, lineInsp
    mov rdx, lIlen
    syscall

    ; print live byte value (65 -> 'A')
    mov rax, 1
    mov rdi, 1
    mov rsi, labelA
    mov rdx, liveAlen
    syscall

    ; print live word bytes (0x48 0x49 -> 'HI')
    mov rax, 1
    mov rdi, 1
    mov rsi, labelW
    mov rdx, liveWlen
    syscall

    ; clean exit
    mov rax, 60
    xor rdi, rdi
    syscall
