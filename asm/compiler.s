defvar "STATE",5,,STATE,0       /* 0 - immediate, 1 - compile */

defcode "[",1,F_IMMED,LBRAC
    mov r0, #0
    ldr r1, var_STATE
    str r0, [r1]
    NEXT


defcode "]",1,,RBRAC
    mov r0, #1
    ldr r1, var_STATE
    str r0, [r1]
    NEXT


defword ":",1,,COLON
    .int WORD
    .int CREATE
    .int LIT, DOCOL, COMMA
    .int LATEST, FETCH/*, HIDDEN*/
    .int RBRAC
    .int EXIT


defword ";",1,F_IMMED,SEMICOLON
    .int LIT, EXIT, COMMA
    .int LATEST, FETCH/*, HIDDEN*/
    .int LBRAC
    .int EXIT


defcode "'",1,,TICK
    ldr r0, [r12], #4
    push {r0}
    NEXT


/* ( w -- ) execution is transfered to forth direct threading code at w */
defcode "EXECUTE",7,,EXECUTE
    pop {r0}
    ldr r1, [r0]
    bx r1

/*

    rijec = ucitaj rijec
    pronadji u rijecniku

    ako je rijec nadjena
        nadji njezin xt
        izvrsi ga

    inace
        pokusaj parsati broj

        ako je broj parsan
            gurni ga na stack

    next


*/

defword "INTERPRET",9,,INTERPRET
    .int WORD, TWODUP           /* ( addr w addr w ) */
    .int FIND, DUP              /* ( addr w d-addr d-addr ) */
    .int ZBRANCH, +3       
    .int INTR_WORD, EXIT                  /* word found in dictionary */
    .int DROP, NUMBER, DROP, EXIT
    
/* ( s-addr w d-addr ) handles REPL for cases when we actually have a word */
defword "INTR-WORD",9,,INTR_WORD
    .int NROT, TWODROP, TCFA, STATE, FETCH
    .int ZBRANCH, +3
    .int COMMA, EXIT /* compile state */
    .int EXECUTE, EXIT /* interpret state */

