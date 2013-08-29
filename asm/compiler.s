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

/* ( w -- ) execution is transfered to forth direct threading code pointed to by value at w */
defcode "EXECUTE",7,,EXECUTE
    pop {r0}
    ldr r1, [r0]
    bx r1

defword "INTE0",9,,INTE0
    .int WORD, TWODUP           /* ( addr w addr w ) */
    .int FIND, DUP              /* ( addr w d-addr d-addr ) */
    .int ZBRANCH, (1f-.)/4       
    .int INTE0_WORD, EXIT                  /* word found in dictionary */
1:  .int DROP, INTE0_NUM, EXIT             /* word not found, drop the other d-addr, try to parse num */
    
/* ( s-addr w d-addr ) handles REPL for cases when we actually have a word */
defword "INTE0-WORD",9,,INTE0_WORD
    .int NROT, TWODROP
    .int STATE, FETCH
    .int ZBRANCH, (1f-.)/4
        .int DUP, INCR4, FETCHBYTE, LIT, F_IMMED, LAND, ZEQU        /* compile state, check if word is immed */
        .int ZBRANCH, (1f-.)/4
            .int TCFA, COMMA, EXIT /* compile and not immediate */
1:  .int TCFA, EXECUTE, EXIT /* interpret state */

/* ( s-addr w ) handles REPL for cases when we couldn't parse word, so try to parse a number now */
defword "INTE0-NUM",8,,INTE0_NUM
    .int TWODUP, NUMBER
    .int ZBRANCH, (1f-.)/4
    .int INTE0_NUM_ERR
    .int EXIT
1:  .int NROT, TWODROP                      /* pull the (s-addr w) over the parsed number, and drop them */
    .int STATE, FETCH
    .int ZBRANCH, (2f-.)/4
    .int TICK, LIT, COMMA, COMMA, EXIT
2:  .int EXIT


defword "INTE0-NUM-ERR",12,,INTE0_NUM_ERR
    .int DROP

    .int LITSTRING, 16
    .ascii "\nError parsing: "
    .balign 4

    .int TYPE, TYPE

    .int LITSTRING, 14
    .ascii ". Continuing.\n"
    .balign 4

    .int TYPE

    .int EXIT

