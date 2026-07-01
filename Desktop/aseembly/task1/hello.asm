; =============================================================================
; hello.asm - Task 1, Program 1: Hello World
; BIT 4220: Assembly Programming - Group Work
;
; Purpose: Demonstrate the minimal structure of a 64-bit NASM program.
;          Shows sections, labels, sys_write and sys_exit system calls.
;
; Build:
;   nasm -f elf64 hello.asm -o hello.o
;   ld hello.o -o hello
;
; Run:
;   ./hello
;
; Expected output:
;   === BIT 4220 Assembly Demo ===
;   Hello, Assembly World!
;   Program exiting cleanly.
; =============================================================================

section .data
    intro   db  "=== BIT 4220 Assembly Demo ===", 10   ; banner + newline
    ilen    equ $ - intro

    msg     db  "Hello, Assembly World!", 10            ; hello message + newline
    len     equ $ - msg

    bye     db  "Program exiting cleanly.", 10          ; exit message + newline
    blen    equ $ - bye

section .text
    global _start

_start:
    ; ---- print intro banner ----
    ; Linux sys_write: rax=1, rdi=fd(1=stdout), rsi=buffer, rdx=length
    mov rax, 1
    mov rdi, 1
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

    ; ---- clean exit ----
    ; Linux sys_exit: rax=60, rdi=exit_code (0 = success)
    mov rax, 60
    xor rdi, rdi
    syscall
