.include "asm/macros.S"
.text

defvar "STATE",5,,STATE,0

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



