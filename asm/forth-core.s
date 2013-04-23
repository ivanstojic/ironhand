.include "asm/macros.S"

.text
.global DOCOL
DOCOL:
    PUSHRSP r12
    ADD r0, #4
    MOV r12, r0
    NEXT

