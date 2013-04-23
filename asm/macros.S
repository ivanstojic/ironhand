/*

R0 = instruction being "decoded" / execd
R12 = forth codeword to execute next (forth quasi PC)
R11 = forth return stack pointer

*/

.macro NEXT
    ldr r0, [r12], #4
    bx r0
.endm

.macro PUSHRSP reg
    str \reg, [r11, #-4]!
.endm

.macro POPRSP reg
    ldr \reg, [r11], #4
.endm
