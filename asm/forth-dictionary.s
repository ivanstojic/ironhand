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
    cmp r2, #0                  /* if we are at the end, well, go home... */
    bxeq lr

    add r3, r2, #4              /* r3 is the length+flags field of the dict entry */

    ldrb r4, [r3], #1           /* load lenflags into r4, r3 is now looking at start of name */
    mov r5, #F_NOIMM_MASK       /* strip possible immediate flag */
    and r4, r5

    cmp r4, r0                  /* length doesn't match, so get next word and iterate */
    ldrne r2, [r2]
    bne 1b

    mov r5, r0                  /* set up the loop */
    mov r6, r1
2:
    ldrb r7, [r3], #1           /* one from the dict */
    ldrb r8, [r6], #1           /* one from the param */
    cmp r7, r8
    ldrne r2, [r2]              /* not the same, abort */
    bne 1b

    sub r5, #1
    cmp r5, #0
    bne 2b

3:
    bx lr                       /* if i got here, there's a result in r2, either 0x0 or a real ptr */


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

