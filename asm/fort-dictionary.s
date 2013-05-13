.include "asm/macros.S"
.text

defvar "LATEST",6,,LATEST,0x50000

defword "FIND",4,,FIND
    pop {r0, r1}
    bl actual_find
    push {r2}
    NEXT

.global actual_find
actual_find:
    ldr r2, var_LATEST

    /* NOP */

    bx lr



