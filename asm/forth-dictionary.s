.include "asm/macros.S"
.text


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


defvar "HERE",4,,HERE,end_of_precompiled_code

/* making sure this stays at the bottom of this file means we don't have to
   manually track the last dictionary pointer.
   
   the linker script pins this file to the end of the binary. and since this
   defvar is at the end, gas variable "link" will always point to
   the last def<whatever> for us
*/
defvar "LATEST",6,,LATEST,link

