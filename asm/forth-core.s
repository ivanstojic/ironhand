.include "asm/macros.S"


/* DOCOL: the interpreter function for direct threaded forth code
    Called from NEXT for words written in forth, thus on entry
    r1 == pc, r0 == address of interpreter function address, 4 bytes less than
    the first forth opcode
*/
.global DOCOL
DOCOL:
    PUSHRSP r12
    add r0, #4
    mov r12, r0
    NEXT


defcode "LIT",3,,LIT
    ldr r0, [r12], #4
    push {r0}
    NEXT


defcode "EXIT",4,,EXIT
    POPRSP r12
    NEXT


defcode "DROP",4,,DROP
    pop {r0}
    NEXT


defcode "DUP",3,,DUP
    pop {r0}
    push {r0}
    push {r0}
    NEXT


defword "WIGGLE",6,,WIGGLE
    .int DUP
    .int DROP
    .int EXIT

