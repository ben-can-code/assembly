; ============================================================
; endian.asm  –  Task 1, Program 3
; BIT 4220: Assembly Programming
; Demonstrates:
;   - Little-endian byte ordering (how x86 stores multi-byte values)
;   - Two's complement representation of negative numbers
;   - Use GDB or objdump to inspect the actual bytes in memory
; ============================================================

section .data                       ; .data section – initialised variables live here

    ; ---- two's complement example ----
    negNum db -5                    ; db = Define Byte. Stores -5 using two's complement.
                                    ;   Step 1: +5 in binary = 0000 0101
                                    ;   Step 2: invert bits  = 1111 1010
                                    ;   Step 3: add 1        = 1111 1011 = 0xFB
                                    ;   So -5 is stored as the single byte 0xFB (251 unsigned)

    ; ---- little-endian example ----
    number dd 0x12345678            ; dd = Define Doubleword (4 bytes). Value = 0x12345678
                                    ;   x86 is little-endian: LSB (least significant byte) goes first
                                    ;   Memory layout at address of 'number':
                                    ;     [0x78] [0x56] [0x34] [0x12]   <- low addr to high addr
                                    ;   Use: objdump -s -j .data endian.o  to see this in hex dump

    ; ---- informational message ----
    msg db "Check memory using GDB or objdump",10  ; string to print as a hint to the student; 10 = newline
    len equ $ - msg                 ; len = total byte length of msg (compile-time calculation)

section .text                       ; .text section – executable instructions

    global _start                   ; expose _start to the linker as the program entry point

_start:                             ; program execution starts here

    ; ---- print the hint message ----
    mov eax, 4                      ; syscall number 4 = sys_write (write to file descriptor)
    mov ebx, 1                      ; file descriptor 1 = stdout (terminal)
    mov ecx, msg                    ; ecx = address of the string to print
    mov edx, len                    ; edx = number of bytes to print
    int 0x80                        ; interrupt 0x80 – asks the Linux kernel to execute the syscall

    ; ---- exit cleanly ----
    mov eax, 1                      ; syscall number 1 = sys_exit
    xor ebx, ebx                    ; set exit code to 0 (success) by XORing register with itself
    int 0x80                        ; kernel call to terminate the process

; ============================================================
; HOW TO INSPECT MEMORY AFTER RUNNING:
;
;   objdump -s -j .data endian.o
;     -> shows raw bytes of the .data section in hex
;     -> you will see: 0xFB (negNum) and 78 56 34 12 (number)
;
;   gdb ./endian
;     (gdb) break _start
;     (gdb) run
;     (gdb) x/1xb &negNum     -> print 1 byte at negNum  (expect 0xFB)
;     (gdb) x/4xb &number     -> print 4 bytes at number (expect 78 56 34 12)
;     (gdb) info registers    -> show all CPU register values
; ============================================================
