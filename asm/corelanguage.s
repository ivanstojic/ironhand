/* DOCOL: the interpreter function for direct threaded forth code
    Called from NEXT for words written in forth, thus on entry
    r1 == pc, r0 == CFA, 4 bytes less than the first forth opcode
*/

.global DOCOL
DOCOL:
    PUSHRSP r12
    add r12, r0, #4
    NEXT


defcode "LIT",3,,LIT
    ldr r0, [r12], #4
    push {r0}
    NEXT


defcode "EXIT",4,,EXIT
    POPRSP r12
    NEXT


defword "QUIT",4,,QUIT
    .int RZ, RSPSTORE
    .int INTE0
    .int BRANCH, -2


/* warning - broken */
defvar "S0",2,,SZ

defconst "FAVCHAR",7,,FAVCHAR,'?'
defconst "VERSION",7,,VERSION,0xDEAD
defconst "R0",2,,RZ,return_stack_top
defconst "DOCOL",5,,__DOCOL,DOCOL
defconst "F_IMMED",7,,__F_IMMED,F_IMMED
defconst "F_HIDDEN",8,,__F_HIDDEN,F_HIDDEN
defconst "F_LENMASK",9,,__F_LENMASK,F_LENMASK

