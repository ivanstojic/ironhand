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

1:
    cmp r2, #0
    bxeq lr

    add r3, r2, #4
    ldrb r4, [r3], #1

    cmp r4, r0
    bne 3f


3:
    

    bx lr


defvar "HERE",4,,HERE,end_of_precompiled_code

/* making sure this stays at the bottom of this file means we don't have to
   manually track the last dictionary pointer.
   
   the linker script pins this file to the end of the binary. and since this
   defvar is at the end, gas variable "link" will always point to
   the last def<whatever> for us
*/
defvar "LATEST",6,,LATEST,link

/* Just a helpful label so objdump constants look prettier */
ironhand_end:

