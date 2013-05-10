.include "asm/macros.S"
.text

defcode "EMIT",4,,EMIT
    bl actual_emit
    NEXT

actual_emit:
    pop {r0}

    ldr r2, UART0DR

    strb r0, [r2]

    mov pc, r14


defcode "KEY",3,,KEY
    bl actual_key
    NEXT

actual_key:
    ldr r2, UART0DR
    ldr r3, UART0FR

1:  ldrb r1, [r3]
    and r1, r1, #0x10
    cmp r1, #0
    bne 1b

    ldrb r1, [r2]
    push {r1}

    mov pc, r14


.equ UART0, 0x101f1000

UART0DR:
    .int UART0 + 0x0

UART0FR:
    .int UART0 + 0x18


