defvar "STATE",5,,STATE,0       /* 0 - immediate, 1 - compile */


defword "[",1,F_IMMED,LBRAC
    .int LIT, 0
    .int STATE, STORE
    .int EXIT

defword "]",1,,RBRAC
    .int LIT, 1
    .int STATE, STORE
    .int EXIT

defword ":",1,,COLON
    .int WORD
    .int CREATE
    .int LIT, DOCOL, COMMA
    .int LATEST, FETCH, HIDDEN
    .int RBRAC
    .int EXIT


defword ";",1,F_IMMED,SEMICOLON
    .int LIT, EXIT, COMMA
    .int LATEST, FETCH, HIDDEN
    .int LBRAC
    .int EXIT


defcode "'",1,,TICK
    ldr r0, [r12], #4
    push {r0}
    NEXT

defword "RECURSE",7,F_IMMED,RECURSE
    .int LATEST, FETCH, COMMA
    .int EXIT

/* ( w -- ) execution is transfered to forth direct threading code at w */
defcode "EXECUTE",7,,EXECUTE
    pop {r0}
    ldr r1, [r0]
    bx r1

defword "INTE0",9,,INTE0
    .int WORD, TWODUP           /* ( addr w addr w ) */
    .int FIND, DUP              /* ( addr w d-addr d-addr ) */
    .int ZBRANCH, (1f-.)/4       
    .int INTE0_WORD, EXIT                  /* word found in dictionary */
1:  .int INTE0_NUM, EXIT
    
/* ( s-addr w d-addr ) handles REPL for cases when we actually have a word */
defword "INTE0-WORD",9,,INTE0_WORD
    .int NROT, TWODROP
    .int STATE, FETCH
    .int ZBRANCH, (1f-.)/4
        .int DUP, INCR4, FETCHBYTE, LIT, F_IMMED, LAND, ZEQU        /* compile state, check if word is immed */
        .int ZBRANCH, (1f-.)/4
            .int TCFA, COMMA, EXIT /* compile and not immediate */
1:  .int TCFA, EXECUTE, EXIT /* interpret state */

defword "INTE0-NUM",8,,INTE0_NUM
    .int DROP, NUMBER, DROP
    .int STATE, FETCH
    .int ZBRANCH, (1f-.)/4
    .int TICK, LIT, COMMA, COMMA, EXIT
1:  .int EXIT



