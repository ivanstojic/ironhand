.include "asm/macros.S"
.text

defcode "EMIT",4,,EMIT
    bl actual_emit
    NEXT

.global actual_emit
actual_emit:
    pop {r0}

    ldr r1, UART0DR
    strb r0, [r1]

    bx lr


/* ( -- c ) c is the char read from the input device */
defcode "KEY",3,,KEY
    bl actual_key
    push {r0}
    NEXT

.global actual_key
actual_key:
    push {r1-r3}
    ldr r2, UART0DR
    ldr r3, UART0FR

1:  ldrb r1, [r3]
    and r1, r1, #0x10
    cmp r1, #0
    bne 1b

    ldrb r0, [r2]
    pop {r1-r3}

    bx lr


/* ( -- a-addr w ) w bytes at a-addr are a string read from the input device */
defcode "WORD",4,,WORD
    bl actual_word
    push {r0}
    push {r1}
    NEXT

.global actual_word
actual_word:
    push {lr}
1:
    bl actual_key
    cmp r0, #'\\'
    beq 3f
    cmp r0, #' '
    beq 1b
    
    ldr r1, =word_buffer
2:
    strb r0, [r1], #1
    bl actual_key
    cmp r0, #' '
    bne 2b
    
    ldr r0, =word_buffer
    sub r1, r0
    
    pop {lr}
    bx lr

3:
    bl actual_key
    cmp r1, #'\n'
    bne 3b
    b 1b
        

word_buffer:
	.space 32





.equ UART0, 0x101f1000

UART0DR:
    .int UART0 + 0x0

UART0FR:
    .int UART0 + 0x18


