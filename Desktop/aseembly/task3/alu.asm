; =============================================================================
; alu.asm - Task 3: Mini ALU Simulator for Embedded Billing Device
; BIT 4220: Assembly Programming - Group Work
;
; Purpose: Menu-driven ALU simulator modelling the computation module of a
;          prepaid utility meter. Reads two numbers from stdin via Linux
;          system calls. Implements add, subtract, multiply, divide, AND, OR,
;          XOR, NOT, shift-left, shift-right. Detects overflow and divide-by-zero.
;
; Build:
;   nasm -f elf64 alu.asm -o alu.o
;   ld alu.o -o alu
;
; Run:
;   ./alu
; =============================================================================

section .data

    ; ---- UI Strings ----
    banner      db  "============================================", 10
                db  "  BIT 4220 - Mini ALU Simulator", 10
                db  "  Embedded Billing Device Demo", 10
                db  "============================================", 10
    bannerlen   equ $ - banner

    prompt1     db  10, "Enter first number  A (0-99): "
    p1len       equ $ - prompt1

    prompt2     db  "Enter second number B (0-99): "
    p2len       equ $ - prompt2

    menu        db  10, "--- Select Operation ---", 10
                db  "  1.  Add          (A + B)", 10
                db  "  2.  Subtract     (A - B)", 10
                db  "  3.  Multiply     (A * B)", 10
                db  "  4.  Divide       (A / B)", 10
                db  "  5.  Bitwise AND  (A & B)", 10
                db  "  6.  Bitwise OR   (A | B)", 10
                db  "  7.  Bitwise XOR  (A ^ B)", 10
                db  "  8.  Bitwise NOT  (~A)", 10
                db  "  9.  Shift Left   (A << 1)", 10
                db  " 10.  Shift Right  (A >> 1)", 10
                db  "  0.  Exit", 10
                db  "Choice: "
    menulen     equ $ - menu

    ; ---- Result labels ----
    resAdd      db  "Result (Add)       : "
    rAddlen     equ $ - resAdd
    resSub      db  "Result (Subtract)  : "
    rSublen     equ $ - resSub
    resMul      db  "Result (Multiply)  : "
    rMullen     equ $ - resMul
    resDiv      db  "Result (Divide)    : "
    rDivlen     equ $ - resDiv
    resAnd      db  "Result (AND)       : "
    rAndlen     equ $ - resAnd
    resOr       db  "Result (OR)        : "
    rOrlen      equ $ - resOr
    resXor      db  "Result (XOR)       : "
    rXorlen     equ $ - resXor
    resNot      db  "Result (NOT A)     : "
    rNotlen     equ $ - resNot
    resShl      db  "Result (SHL A<<1)  : "
    rShll       equ $ - resShl
    resShr      db  "Result (SHR A>>1)  : "
    rShrl       equ $ - resShr

    nl          db  10
    nllen       equ 1

    errInvalid  db  "[!] Invalid choice. Please enter 0-10.", 10
    errIlen     equ $ - errInvalid

    errDivZero  db  "[!] Division by zero is undefined!", 10
    errDlen     equ $ - errDivZero

    errOverflow db  "[!] Overflow warning: result exceeds 8-bit range (>255)!", 10
    errOlen     equ $ - errOverflow

    byeMsg      db  10, "Exiting ALU Simulator. Goodbye!", 10
    byelen      equ $ - byeMsg

section .bss
    inbuf1      resb 8      ; input buffer for number A
    inbuf2      resb 8      ; input buffer for number B
    choicebuf   resb 4      ; input buffer for menu choice
    outbuf      resb 20     ; output buffer for number-to-string conversion

section .text
    global _start

; =============================================================================
; print: sys_write wrapper
;   in:  rsi = buffer address
;        rdx = byte count
; =============================================================================
print:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

; =============================================================================
; readline: sys_read wrapper
;   in:  rsi = buffer address
;        rdx = max bytes to read
;   out: rax = bytes actually read
; =============================================================================
readline:
    mov rax, 0
    mov rdi, 0
    syscall
    ret

; =============================================================================
; atoi: ASCII decimal string -> integer
;   in:  rsi = pointer to string (newline or null terminated)
;   out: rax = integer value
; =============================================================================
atoi:
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 10         ; newline?
    je  .done
    cmp rbx, 0
    je  .done
    cmp rbx, '0'
    jl  .done
    cmp rbx, '9'
    jg  .done
    sub rbx, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rcx
    jmp .loop
.done:
    ret

; =============================================================================
; itoa: integer -> ASCII decimal string in outbuf
;   in:  rax = integer (non-negative)
;   out: rsi = start of string in outbuf
;        rdx = length including trailing newline
; =============================================================================
itoa:
    lea rdi, [outbuf + 18]
    mov byte [rdi], 10      ; newline
    dec rdi
    xor rcx, rcx

    cmp rax, 0
    jne .convert
    ; special case: zero
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .done_itoa

.convert:
    test rax, rax
    jz  .done_itoa
    xor rdx, rdx
    mov rbx, 10
    div rbx                 ; rax = quotient, rdx = remainder
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    jmp .convert

.done_itoa:
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    inc rdx                 ; include newline
    ret

; =============================================================================
; _start: program entry point
; =============================================================================
_start:
    ; print banner
    mov rsi, banner
    mov rdx, bannerlen
    call print

.main_loop:
    ; ---- read A ----
    mov rsi, prompt1
    mov rdx, p1len
    call print

    mov rsi, inbuf1
    mov rdx, 7
    call readline

    mov rsi, inbuf1
    call atoi
    mov r12, rax            ; r12 = A

    ; ---- read B ----
    mov rsi, prompt2
    mov rdx, p2len
    call print

    mov rsi, inbuf2
    mov rdx, 7
    call readline

    mov rsi, inbuf2
    call atoi
    mov r13, rax            ; r13 = B

    ; ---- show menu ----
    mov rsi, menu
    mov rdx, menulen
    call print

    ; ---- read choice ----
    mov rsi, choicebuf
    mov rdx, 3
    call readline

    mov rsi, choicebuf
    call atoi               ; rax = choice number

    ; ---- dispatch ----
    cmp rax, 0
    je  .exit_program
    cmp rax, 1
    je  .do_add
    cmp rax, 2
    je  .do_sub
    cmp rax, 3
    je  .do_mul
    cmp rax, 4
    je  .do_div
    cmp rax, 5
    je  .do_and
    cmp rax, 6
    je  .do_or
    cmp rax, 7
    je  .do_xor
    cmp rax, 8
    je  .do_not
    cmp rax, 9
    je  .do_shl
    cmp rax, 10
    je  .do_shr

    ; invalid
    mov rsi, errInvalid
    mov rdx, errIlen
    call print
    jmp .main_loop

; ---- ADD ----
.do_add:
    mov rax, r12
    add rax, r13
    cmp rax, 255
    jg  .overflow_add
    mov rsi, resAdd
    mov rdx, rAddlen
    call print
    call itoa
    call print
    jmp .main_loop

.overflow_add:
    mov rsi, errOverflow
    mov rdx, errOlen
    call print
    mov rsi, resAdd
    mov rdx, rAddlen
    call print
    mov rax, r12
    add rax, r13
    call itoa
    call print
    jmp .main_loop

; ---- SUBTRACT ----
.do_sub:
    mov rax, r12
    sub rax, r13
    mov rsi, resSub
    mov rdx, rSublen
    call print
    call itoa
    call print
    jmp .main_loop

; ---- MULTIPLY ----
.do_mul:
    mov rax, r12
    imul rax, r13
    cmp rax, 255
    jg  .overflow_mul
    mov rsi, resMul
    mov rdx, rMullen
    call print
    call itoa
    call print
    jmp .main_loop

.overflow_mul:
    mov rsi, errOverflow
    mov rdx, errOlen
    call print
    mov rsi, resMul
    mov rdx, rMullen
    call print
    mov rax, r12
    imul rax, r13
    call itoa
    call print
    jmp .main_loop

; ---- DIVIDE ----
.do_div:
    cmp r13, 0
    je  .div_zero
    mov rax, r12
    xor rdx, rdx
    div r13
    mov rsi, resDiv
    mov rdx, rDivlen
    call print
    call itoa
    call print
    jmp .main_loop

.div_zero:
    mov rsi, errDivZero
    mov rdx, errDlen
    call print
    jmp .main_loop

; ---- AND ----
.do_and:
    mov rax, r12
    and rax, r13
    mov rsi, resAnd
    mov rdx, rAndlen
    call print
    call itoa
    call print
    jmp .main_loop

; ---- OR ----
.do_or:
    mov rax, r12
    or  rax, r13
    mov rsi, resOr
    mov rdx, rOrlen
    call print
    call itoa
    call print
    jmp .main_loop

; ---- XOR ----
.do_xor:
    mov rax, r12
    xor rax, r13
    mov rsi, resXor
    mov rdx, rXorlen
    call print
    call itoa
    call print
    jmp .main_loop

; ---- NOT (masked to 8-bit) ----
.do_not:
    mov rax, r12
    not rax
    and rax, 0xFF           ; mask to 8-bit for meaningful display
    mov rsi, resNot
    mov rdx, rNotlen
    call print
    call itoa
    call print
    jmp .main_loop

; ---- SHIFT LEFT ----
.do_shl:
    mov rax, r12
    shl rax, 1
    mov rsi, resShl
    mov rdx, rShll
    call print
    call itoa
    call print
    jmp .main_loop

; ---- SHIFT RIGHT ----
.do_shr:
    mov rax, r12
    shr rax, 1
    mov rsi, resShr
    mov rdx, rShrl
    call print
    call itoa
    call print
    jmp .main_loop

; ---- EXIT ----
.exit_program:
    mov rsi, byeMsg
    mov rdx, byelen
    call print
    mov rax, 60
    xor rdi, rdi
    syscall
