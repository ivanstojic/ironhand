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
    bx lr                       /* there's a result in r2, either 0x0 or a real ptr */


/* ( a-addr -- a-addr2 ) a-addr2 is the pointer to CFA of dict word at a-addr */
defcode ">CFA",4,,TCFA
    pop {r0}
    bl actual_tcfa
    push {r0}
    NEXT

actual_tcfa:
    add r0, #4          /* skip link to previous entry */
    ldrb r1, [r0], #1   /* pick up flag+len, move over that */
    mov r2, #F_LENMASK
    and r1, r2          /* strip flags off the length */

    add r0, r2          /* move by length bytes forward */
    add r0, #3          /* and balign 4 the address */
    and r0, #~3

    bx lr


/* ( a-addr -- a-addr2 ) a-addr2 is the pointer to first DFA of dict word at a-addr */
defword ">DFA",4,,TDFA
    .int TCFA, INCR4, EXIT



/* ( a-addr w -- ) create dict entry header of name at a-addr with len w, update HERE/LATEST */
defcode "CREATE",6,,CREATE
    pop {r0, r1} 
    ldr r2, =var_HERE
    push {r2}
    ldr r3, =var_LATEST

    str r3, [r2], #4        /* link to previous entry through var_LATEST */
    strb r0, [r2], #1       /* word length + flags */
    
    mov r4, r0
    mov r5, r1

1:
    ldrb r6, [r5], #1       /* copy name from the given buffer, to HERE */
    strb r6, [r2], #1
    sub r4, #1
    cmp r4, #0
    bne 1b                  /* repeat until we reach length */

    add r2, #3
    and r2, #~3
    ldr r7, var_HERE
    str r2, [r7]            /* set var_HERE from the r2 which was tracking data */

    ldr r7, var_LATEST
    pop {r2}
    str r2, [r7]            /* set var_LATEST to wherever var_HERE pointed at the start */

    NEXT


/* ( w -- ) w is the word to store at HERE, then increments HERE */
defcode ",",1,,COMMA
    pop {r0}
    bl actual_comma
    NEXT

actual_comma:
    ldr r1, var_HERE
    ldr r2, [r1]
    str r0, [r2], #4
    str r2, [r1] 

    bx lr


/* ( -- ) the last defined word gets its IMMEDIATE flag toggled */
defcode "IMMEDIATE",9,F_IMMED,IMMEDIATE
    ldr r0, =var_LATEST
    ldr r0, [r0]

    ldrb r1, [r0, #4]!

    mov r2, #F_IMMED
    eor r1, r2

    strb r1, [r0]

    NEXT


/* ( a-addr -- ) the dict entry defined at a-addr gets its HIDDEN flag toggled */
defcode "HIDDEN",6,,HIDDEN
    pop {r0}
    ldrb r1, [r0, #4]!

    mov r2, #F_HIDDEN
    eor r1, r2

    strb r1, [r0]

    NEXT

/* ( -- ) read next word, find it in dictionary, toggle its HIDDEN flag */
defword "HIDE",4,,HIDE
    .int WORD, FIND
    .int HIDDEN
    .int EXIT




/* making sure this stays at the bottom of this file means we don't have to
   manually track the last dictionary pointer.
   
   the linker script pins this file to the end of the binary. and since this
   defvar is at the end, gas variable "link" will always point to
   the last def<whatever> for us
*/
defvar "HERE",4,,HERE,end_of_precompiled_code
defvar "LATEST",6,,LATEST,link

/* Just a helpful label so objdump constants look prettier */
ironhand_end:

