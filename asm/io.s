.include "asm/macros.S"
.text

defcode "EMIT",4,,EMIT
    pop {r0}

    ldr r2, =UART0DR
    ldr r2, [r2]

    strb r0, [r2]

    NEXT


defcode "KEY",3,,KEY
    ldr r2, =UART0DR
    ldr r2, [r2]

    ldr r3, =UART0FR
    ldr r3, [r3]
1:  ldrb r1, [r3]
    and r1, r1, #0x10
    cmp r1, #0
    bne 1b

    ldrb r1, [r2]
    push {r1}

    NEXT



.data
.equ UART0, 0x101f1000

UART0DR:
    .int UART0 + 0x0

UART0FR:
    .int UART0 + 0x18


