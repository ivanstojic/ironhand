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



defcode "WORD",4,,WORD
    bl actual_word
    push {r3}
    push {r2}
    NEXT

.global actual_word
actual_word:
	/* Search for first non-blank character.  Also skip \ comments. */
    push {lr}
1:
    bl actual_key		/* get next key, returned in %eax */
    cmp r0, #'\\'		/* start of a comment? */
    beq 3f			/* if so, skip the comment */
    cmp r0, #' '            /* space? */
    beq 1b			/* if so, keep looking for word start */
    
    /* Search for the end of the word, storing chars as we go. */
    ldr r1, =word_buffer
2:
    strb r0, [r1], #1
    bl actual_key
    cmp r0, #' '
    bne 2b
    
    ldr r3, =word_buffer
    sub r2, r3
    
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


