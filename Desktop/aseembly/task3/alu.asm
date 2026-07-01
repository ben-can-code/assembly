; ============================================================
; alu.asm  –  Task 3: Mini ALU Simulator
; BIT 4220: Assembly Programming
; Models the computation module of a prepaid billing device.
; Reads two single-digit numbers from keyboard input.
; Presents a menu of arithmetic and bitwise operations.
; Displays the result after each operation.
; Validates input and handles divide-by-zero.
; ============================================================

section .data                           ; .data section – all initialised strings and constants

    ; ---- menu string ----
    menu db 10,"1. Add",10              ; menu option 1: addition. Leading 10 = blank line before menu
         db "2. Subtract",10            ; menu option 2: subtraction
         db "3. Multiply",10            ; menu option 3: multiplication
         db "4. Divide",10              ; menu option 4: integer division
         db "5. AND",10                 ; menu option 5: bitwise AND
         db "6. OR",10                  ; menu option 6: bitwise OR
         db "7. XOR",10                 ; menu option 7: bitwise XOR
         db "8. Exit",10                ; menu option 8: exit the program
         db "Choice: "                  ; prompt asking the user to type their choice
    menulen equ $ - menu                ; total byte length of the entire menu string

    msg1 db "Enter first digit: "       ; prompt for first number input
    len1 equ $ - msg1                   ; length of msg1

    msg2 db "Enter second digit: "      ; prompt for second number input
    len2 equ $ - msg2                   ; length of msg2

    resultMsg db "Result: "             ; label printed before displaying the answer
    resultLen equ $ - resultMsg         ; length of resultMsg

    invalid db "Invalid choice!",10     ; error message for unrecognised menu input; 10 = newline
    invalidLen equ $ - invalid          ; length of invalid message

section .bss                            ; .bss section – uninitialised buffers (reserved at runtime, zero-filled)

    choice resb 2                       ; reserve 2 bytes for the menu choice character + newline from keyboard
    num1   resb 2                       ; reserve 2 bytes for the first number character + newline
    num2   resb 2                       ; reserve 2 bytes for the second number character + newline
    result resb 2                       ; reserve 2 bytes to hold the result character for printing

section .text                           ; .text section – all executable instructions

    global _start                       ; expose _start to the linker as the program entry point

_start:                                 ; execution begins here

menu_loop:                              ; loop label – we jump back here after each operation to show the menu again

    ; ---- display the menu ----
    mov eax, 4                          ; syscall 4 = sys_write
    mov ebx, 1                          ; file descriptor 1 = stdout
    mov ecx, menu                       ; pointer to the menu string
    mov edx, menulen                    ; number of bytes to write
    int 0x80                            ; kernel call – prints the menu

    ; ---- read the user's menu choice ----
    mov eax, 3                          ; syscall 3 = sys_read (read bytes from a file descriptor)
    mov ebx, 0                          ; file descriptor 0 = stdin (keyboard)
    mov ecx, choice                     ; pointer to the buffer where input will be stored
    mov edx, 2                          ; read at most 2 bytes (1 digit + newline)
    int 0x80                            ; kernel call – waits for user to press a key and Enter

    ; ---- check if user chose Exit (option 8) ----
    cmp byte [choice], '8'              ; compare the first byte of choice buffer with ASCII '8' (0x38)
    je exit                             ; if equal, jump to exit label and terminate

    ; ---- prompt for first number ----
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, msg1                       ; pointer to "Enter first digit: "
    mov edx, len1                       ; length of prompt
    int 0x80                            ; print the prompt

    ; ---- read first number from keyboard ----
    mov eax, 3                          ; sys_read
    mov ebx, 0                          ; stdin
    mov ecx, num1                       ; store input in num1 buffer
    mov edx, 2                          ; read 2 bytes (digit + newline)
    int 0x80                            ; kernel call – get the digit

    ; ---- prompt for second number ----
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, msg2                       ; pointer to "Enter second digit: "
    mov edx, len2                       ; length of prompt
    int 0x80                            ; print the prompt

    ; ---- read second number from keyboard ----
    mov eax, 3                          ; sys_read
    mov ebx, 0                          ; stdin
    mov ecx, num2                       ; store input in num2 buffer
    mov edx, 2                          ; read 2 bytes (digit + newline)
    int 0x80                            ; kernel call – get the digit

    ; ---- convert ASCII digits to integers ----
    mov al, [num1]                      ; load the first byte of num1 into al (8-bit low part of eax)
                                        ; e.g. if user typed '5', al = 0x35 (ASCII for '5')
    sub al, '0'                         ; subtract ASCII '0' (0x30) to get the numeric value: 0x35 - 0x30 = 5

    mov bl, [num2]                      ; load the first byte of num2 into bl (8-bit low part of ebx)
    sub bl, '0'                         ; convert from ASCII digit to integer the same way

    ; ---- dispatch to the correct operation ----
    cmp byte [choice], '1'              ; is the choice '1' (Add)?
    je addition                         ; yes – jump to addition

    cmp byte [choice], '2'              ; is the choice '2' (Subtract)?
    je subtraction                      ; yes – jump to subtraction

    cmp byte [choice], '3'              ; is the choice '3' (Multiply)?
    je multiplication                   ; yes – jump to multiplication

    cmp byte [choice], '4'              ; is the choice '4' (Divide)?
    je division                         ; yes – jump to division

    cmp byte [choice], '5'              ; is the choice '5' (AND)?
    je and_op                           ; yes – jump to bitwise AND

    cmp byte [choice], '6'              ; is the choice '6' (OR)?
    je or_op                            ; yes – jump to bitwise OR

    cmp byte [choice], '7'              ; is the choice '7' (XOR)?
    je xor_op                           ; yes – jump to bitwise XOR

    jmp invalid_choice                  ; none matched – jump to error handler

; ---- ADDITION ----
addition:
    add al, bl                          ; al = al + bl  (adds both numbers; result stays in al)
    jmp display                         ; jump to display section to print the result

; ---- SUBTRACTION ----
subtraction:
    sub al, bl                          ; al = al - bl  (subtracts second number from first)
    jmp display                         ; jump to display

; ---- MULTIPLICATION ----
multiplication:
    mul bl                              ; ax = al * bl  (unsigned multiply; result goes into ax)
    jmp display                         ; jump to display

; ---- DIVISION ----
division:
    cmp bl, 0                           ; check if divisor (bl) is zero before dividing
    je invalid_choice                   ; division by zero is undefined – show error instead
    div bl                              ; al = ax / bl  (unsigned divide; quotient in al, remainder in ah)
    jmp display                         ; jump to display

; ---- BITWISE AND ----
and_op:
    and al, bl                          ; al = al AND bl  (1 only where BOTH bits are 1)
                                        ; use case: isolate specific bits, e.g. check device status flags
    jmp display

; ---- BITWISE OR ----
or_op:
    or al, bl                           ; al = al OR bl   (1 where EITHER bit is 1)
                                        ; use case: set specific bits without changing others
    jmp display

; ---- BITWISE XOR ----
xor_op:
    xor al, bl                          ; al = al XOR bl  (1 only where bits DIFFER)
                                        ; use case: toggle bits; XOR a value with itself always gives 0
    jmp display

; ---- DISPLAY RESULT ----
display:
    add al, '0'                         ; convert integer result back to ASCII digit by adding '0' (0x30)
                                        ; e.g. result 7 -> 7 + 0x30 = 0x37 = ASCII '7'
    mov [result], al                    ; store the ASCII character into the result buffer

    ; print "Result: " label
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, resultMsg                  ; pointer to "Result: "
    mov edx, resultLen                  ; length of label
    int 0x80                            ; print the label

    ; print the actual result character
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, result                     ; pointer to result buffer (contains the ASCII digit)
    mov edx, 1                          ; print exactly 1 byte (the digit)
    int 0x80                            ; kernel call – prints the digit on screen

    jmp menu_loop                       ; go back to the top and show the menu again

; ---- INVALID CHOICE HANDLER ----
invalid_choice:
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, invalid                    ; pointer to "Invalid choice!" message
    mov edx, invalidLen                 ; length of error message
    int 0x80                            ; print the error

    jmp menu_loop                       ; return to menu so user can try again

; ---- EXIT ----
exit:
    mov eax, 1                          ; syscall 1 = sys_exit
    xor ebx, ebx                        ; exit code 0 = success
    int 0x80                            ; kernel call – terminates the program
