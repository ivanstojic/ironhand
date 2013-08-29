defword "CHAR",4,,CHAR
    .int WORD, DROP, FETCHBYTE
    .int EXIT 


defcode "EMIT",4,,EMIT
    pop {r0}
    bl actual_emit
    NEXT

.global actual_emit
actual_emit:
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

1:  
    ldrb r1, [r3]
    and r1, r1, #0x10
    cmp r1, #0
    bne 1b

    ldrb r0, [r2]
    /*strb r0, [r2] no local echo*/
    pop {r1-r3}

    bx lr


/* ( -- a-addr w ) w bytes at a-addr are a string read from the input device */
defcode "WORD",4,,WORD
    bl actual_word
    push {r0, r1}
    NEXT

.global actual_word
actual_word:
    push {lr}

1:
    bl actual_key
    cmp r0, #'\\'
    beq 4f

    cmp r0, #' '
    beq 1b
    cmp r0, #10
    beq 1b
    cmp r0, #13
    beq 1b
    
    ldr r1, =word_buffer

2:
    strb r0, [r1], #1
    bl actual_key
    cmp r0, #' '
    beq 3f
    cmp r0, #10
    beq 3f
    cmp r0, #13
    beq 3f

    b 2b
    
3:
    mov r0, r1
    ldr r1, =word_buffer
    sub r0, r1
    
    pop {lr}
    bx lr

4:
    bl actual_key
    cmp r0, #10
    beq 1b
    cmp r0, #13
    beq 1b

    b 4b
        

word_buffer:
	.space 32


defcode ".S",2,,PSTACK
    ldr r4, var_S0
    mov r5, sp

    cmp r5, r4
    bge 2f

1:
    bl one_off
    mov r0, #'\n'
    bl actual_emit
    cmp r5, r4
    blt 1b


2:
    mov r0, #'<'
    bl actual_emit
    mov r0, #'\n'
    bl actual_emit

    NEXT


one_off:
    ldr r6, [r5], #4

    cmp r6, #0
    movge r0, #'.'
    bge 1f

    mov r0, #'-'
    push {lr}
    bl actual_emit
    pop {lr}

    mov r7, #-1
    mul r6, r7

    mov r0, #'.'

1:  cmp r6, #0
    bxeq lr
    push {lr}
    bl actual_emit
    pop {lr}
    sub r6, #1
    b 1b
    


/* What number base are we using? */
defvar "BASE",4,,BASE,10

/* ( a-addr w1 -- w2 w3 )
   w2 is the num value of str at a-addr of len w1, w3 is the error offset
   uses the number base in var_BASE
*/
defcode "NUMBER",6,,NUMBER
    pop {r0, r1}
    bl actual_number
    push {r4}
    push {r5}
    NEXT

.global actual_number
actual_number:
    mov r4, #0                   /* result is 0 */
    mov r5, #0                   /* error offset is 0 */
    mov r6, #1                   /* negative flag */
    ldr r7, var_BASE

    cmp r0, #0 
    bxeq lr                      /* if the length is zero, early abort */

    mov r2, r1                   /* r2 is reading ptr */

    ldrb r3, [r2], #1            /* pick up first char into r3 */
    sub r0, #1
    cmp r3, #'-'                 /* is it a minus sign? */
    bne 3f
    mov r6, #-1                  /* yes, so toggle the flag, fall through to read */

2:
    cmp r0, #0
    beq 5f
    ldrb r3, [r2], #1
    sub r0, #1
    
3:
    cmp r3, #'0'                 /* check for out of range digits */
    blo 4f
    cmp r3, #'9'
    bhi 4f

    sub r3, #'0'
    mul r4, r7
    add r4, r3

    b 2b

4:
    add r5, r0, #1
    mul r4, r6
    bx lr

5:
    mov r5, r0
    mul r4, r6                   /* multiply result with negative flag */
    bx lr                        /* out we go, r4-res, r5-err offs */



/* ( a-addr w -- ) outputs w chars of string at a-addr */
defcode "TYPE",4,,TYPE
    pop {r0, r1}

    ldr r2, UART0DR

1:
    cmp r0, #0
    beq 2f
    sub r0, #1

    ldrb r3, [r1], #1
    strb r3, [r2]
    
    b 1b

2:
    NEXT



.equ UART0, 0x101f1000

UART0DR:
    .int UART0 + 0x0

UART0FR:
    .int UART0 + 0x18


