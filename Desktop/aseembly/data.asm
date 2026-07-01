; =============================================================================
; data.asm - Task 1: Data Representation Toolkit
; BIT 4220: Assembly Programming - Group Work
; Description: Stores and displays bytes, words, doublewords.
;              Demonstrates ASCII interpretation, hex values, and little-endian
;              storage. Shows two's complement concept via negative storage.
; Build:  nasm -f elf64 data.asm -o data.o
;         ld data.o -o data
; Run:    ./data
; =============================================================================

section .data
    ; -----------------------------------------------------------------------
    ; Raw data values (stored in little-endian order on x86-64)
    ; -----------------------------------------------------------------------
    byteVal     db  65              ; 1 byte  = 0x41 = ASCII 'A'
    wordVal     dw  0x1234         ; 2 bytes = stored as 34 12 in memory
    dwordVal    dd  0x12345678     ; 4 bytes = stored as 78 56 34 12 in memory
    negByte     db  -1             ; two's complement: 0xFF (255 unsigned)

    ; -----------------------------------------------------------------------
    ; Display messages
    ; -----------------------------------------------------------------------
    header      db  "=== Data Representation Demo ===", 10
    hlen        equ $ - header

    asciiMsg    db  "ASCII of byte 65  : A", 10
    alen        equ $ - asciiMsg

    hexMsg      db  "Word  value (hex) : 0x1234", 10
    hexlen      equ $ - hexMsg

    dwordMsg    db  "Dword value (hex) : 0x12345678", 10
    dlen        equ $ - dwordMsg

    leMsg       db  "Little-endian: 0x1234 stored as bytes [34][12] in RAM", 10
    lelen       equ $ - leMsg

    twosMsg     db  "Two's complement : -1 stored as 0xFF (byte)", 10
    twoslen     equ $ - twosMsg

    doneMsg     db  "Inspect with: objdump -d data.o  OR  gdb ./data", 10
    donelen     equ $ - doneMsg

; -----------------------------------------------------------------------
; Helper macro-style section: print via sys_write (rax=1, rdi=1)
; -----------------------------------------------------------------------
section .text
    global _start

; ---- Macro-free print helper using inline calls ----
_start:

    ; print header
    mov rax, 1
    mov rdi, 1
    mov rsi, header
    mov rdx, hlen
    syscall

    ; print ASCII line
    mov rax, 1
    mov rdi, 1
    mov rsi, asciiMsg
    mov rdx, alen
    syscall

    ; print hex word line
    mov rax, 1
    mov rdi, 1
    mov rsi, hexMsg
    mov rdx, hexlen
    syscall

    ; print dword line
    mov rax, 1
    mov rdi, 1
    mov rsi, dwordMsg
    mov rdx, dlen
    syscall

    ; print little-endian explanation
    mov rax, 1
    mov rdi, 1
    mov rsi, leMsg
    mov rdx, lelen
    syscall

    ; print two's complement explanation
    mov rax, 1
    mov rdi, 1
    mov rsi, twosMsg
    mov rdx, twoslen
    syscall

    ; print GDB hint
    mov rax, 1
    mov rdi, 1
    mov rsi, doneMsg
    mov rdx, donelen
    syscall

    ; clean exit
    mov rax, 60
    xor rdi, rdi
    syscall
