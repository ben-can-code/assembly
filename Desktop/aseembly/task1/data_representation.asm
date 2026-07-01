; ============================================================
; data_representation.asm  –  Task 1, Program 2
; BIT 4220: Assembly Programming
; Stores bytes (db), words (dw) and doublewords (dd) in .data
; and prints their ASCII interpretation to the terminal.
; Shows how the same bit pattern is a number AND a character.
; ============================================================

section .data                       ; .data section – holds all initialised variables

    ; ---- raw data values ----
    byteVal  db 'A'                 ; db = Define Byte (1 byte). Stores ASCII character 'A' = 0x41 = decimal 65
    wordVal  dw 0x1234              ; dw = Define Word (2 bytes). Stores 0x1234; in memory: [34][12] (little-endian)
    dwordVal dd 0x12345678          ; dd = Define Doubleword (4 bytes). Stored as [78][56][34][12] in memory (little-endian)

    ; ---- display strings ----
    msg1 db "Byte ASCII: A",10      ; string describing the byte value; 10 = newline character
    len1 equ $ - msg1               ; len1 = length of msg1 in bytes (calculated at compile time)

    msg2 db "Word Value Stored",10  ; string describing the word value
    len2 equ $ - msg2               ; len2 = length of msg2

    msg3 db "Doubleword Value Stored",10  ; string describing the doubleword value
    len3 equ $ - msg3               ; len3 = length of msg3

section .text                       ; .text section – holds executable instructions

    global _start                   ; tell the linker that _start is the program entry point

_start:                             ; execution begins here

    ; ---- print msg1: "Byte ASCII: A" ----
    mov eax, 4                      ; syscall 4 = sys_write
    mov ebx, 1                      ; file descriptor 1 = stdout
    mov ecx, msg1                   ; pointer to the message string
    mov edx, len1                   ; number of bytes to write
    int 0x80                        ; call the kernel to execute sys_write

    ; ---- print msg2: "Word Value Stored" ----
    mov eax, 4                      ; syscall 4 = sys_write again
    mov ebx, 1                      ; stdout
    mov ecx, msg2                   ; pointer to second message
    mov edx, len2                   ; length of second message
    int 0x80                        ; kernel call

    ; ---- print msg3: "Doubleword Value Stored" ----
    mov eax, 4                      ; syscall 4 = sys_write
    mov ebx, 1                      ; stdout
    mov ecx, msg3                   ; pointer to third message
    mov edx, len3                   ; length of third message
    int 0x80                        ; kernel call

    ; ---- exit cleanly ----
    mov eax, 1                      ; syscall 1 = sys_exit
    xor ebx, ebx                    ; exit code 0 = success (xor clears the register to 0)
    int 0x80                        ; kernel call to terminate the program
