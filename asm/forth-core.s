.include "asm/macros.S"

.global DOCOL
DOCOL:
    PUSHRSP r12
    add r0, #4
    mov r12, r0
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

