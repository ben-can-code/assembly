; ============================================================
; hello.asm  –  Task 1, Program 1: Hello World
; BIT 4220: Assembly Programming
; Demonstrates the minimal structure of a NASM program:
;   sections, labels, Linux system calls, and clean exit.
; ============================================================

section .data                       ; .data section holds all initialised (read-only) variables

    msg db "Hello, World!", 10      ; define byte string "Hello, World!" followed by ASCII 10 (newline \n)
    len equ $ - msg                 ; compile-time constant: $ = current address, so len = address_now - address_of_msg = string length in bytes

section .text                       ; .text section holds all executable machine instructions

    global _start                   ; expose _start label to the linker so it knows where execution begins

_start:                             ; entry point – the OS jumps here first when the program runs

    ; ---- write "Hello, World!" to stdout ----
    mov eax, 4                      ; syscall number 4 = sys_write (write bytes to a file descriptor)
    mov ebx, 1                      ; file descriptor 1 = stdout (the terminal screen)
    mov ecx, msg                    ; ecx = pointer (address) to the string we want to print
    mov edx, len                    ; edx = number of bytes to write (the length we calculated above)
    int 0x80                        ; software interrupt 0x80 – transfers control to the Linux kernel to execute the syscall

    ; ---- exit the program cleanly ----
    mov eax, 1                      ; syscall number 1 = sys_exit (terminate the process)
    xor ebx, ebx                    ; xor register with itself sets it to 0 – exit code 0 means success
    int 0x80                        ; trigger the kernel again to perform the exit
