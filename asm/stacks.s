/* RETURN STACK */

defcode ">R",2,,TOR
    pop {r0}
    PUSHRSP r0
    NEXT

defcode "R>",2,,FROMR
    POPRSP r0
    push {r0}
    NEXT

defcode "RSP@",4,,RSPFETCH
    push {r11}
    NEXT

defcode "RSP!",4,,RSPSTORE
    pop {r11}
    NEXT

defcode "RDROP",5,,RDROP
    add r11, #4
    NEXT


/* DATA STACK */

defcode "DSP@",4,,DSPFETCH
    mov r0, sp
    push {r0}
    NEXT

defcode "DSP!",4,,DSPSTORE
    ldr sp, [sp]
    NEXT


/* STACK OPERATIONS */

defcode "DROP",4,,DROP
    pop {r0}
    NEXT

defcode "DUP",3,,DUP
    pop {r0}
    push {r0}
    push {r0}
    NEXT

defcode "SWAP",4,,SWAP
    pop {r0, r1}
    push {r0}
    push {r1}
    NEXT

defcode "OVER",4,,OVER
    ldr r0, [sp, #4]
    push {r0}
    NEXT

defcode "ROT",3,,ROT
    pop {r0-r2}
    push {r1}
    push {r0}
    push {r2}
    NEXT

defcode "-ROT",4,,NROT
    pop {r0-r2}
    push {r1}
    push {r2}
    push {r0}
    NEXT


