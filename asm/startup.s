.global _entrypoint

_entrypoint:
    ldr sp, =stack_top
    bl LocalEcho
    bl PrintUART
    b .

PrintUART:
    /* What are we writing */
    ldr r3, =_msg

    /* Where will we write it? */
    ldr r2, UART0DR

1:  /* let's loop */
    ldrb r1, [r3], #1
    cmp r1, #0
    beq 2f
    strb r1, [r2]
    b 1b

2:
    mov pc, r14


LocalEcho:
    ldr r2, UART0DR
    ldr r3, UART0FR

1:  ldrb r1, [r3]
    and r1, r1, #0x10
    cmp r1, #0
    bne 1b

    mov pc, r14

.equ UART0, 0x101f1000

UART0DR:
    .int UART0 + 0x0

UART0FR:
    .int UART0 + 0x18

_msg:
    .string "Hello, world from IronHand!"
    .byte 0

