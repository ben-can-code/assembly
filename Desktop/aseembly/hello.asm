; =============================================================================
; hello.asm - Task 1: Hello World Assembly Program
; BIT 4220: Assembly Programming - Group Work
; Description: Demonstrates basic NASM structure, syscalls, and program exit
; Build:  nasm -f elf64 hello.asm -o hello.o
;         ld hello.o -o hello
; Run:    ./hello
; =============================================================================

section .data
    msg     db  "Hello, Assembly World!", 10   ; message with newline
    len     equ $ - msg                        ; calculate length at compile time

    intro   db  "=== BIT 4220 Assembly Demo ===", 10
    ilen    equ $ - intro

    bye     db  "Program exiting cleanly.", 10
    blen    equ $ - bye

section .text
    global _start

_start:
    ; ---- print intro banner ----
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout (fd = 1)
    mov rsi, intro
    mov rdx, ilen
    syscall

    ; ---- print hello message ----
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ; ---- print exit message ----
    mov rax, 1
    mov rdi, 1
    mov rsi, bye
    mov rdx, blen
    syscall

    ; ---- exit syscall (clean exit, code 0) ----
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code = 0
    syscall
