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

defvar "_IL",3,,_IL,0
defword "INTERPRET",9,,INTERPRET
    .int WORD, TWODUP           /* ( addr w addr w ) */
    .int FIND, DUP              /* ( addr w d-addr d-addr ) */
    .int ZBRANCH, +5
    .int NROT, TWODROP, TCFA, EXECUTE
    .int DROP, NUMBER, TWODROP, EXIT
    


defcode "INTERPREf",9,,INTERPREf
    bl actual_word

    ldr r10, =literal_mode
    mov r2, #0
    str r2, [r10]

    /* try to find the word in dictionary */
    bl actual_find
    cmp r2, #0
    beq 1f

    /* found it, is it immediate? */
    ldrb r3, [r2, #4]
    mov r0, r2
    bl actual_tcfa

    mov r1, #F_IMMED
    and r3, r1
    
    cmp r3, #0
    beq 2f          /* not immediate */

    b 4f            /* immediate */


1:
    mov r2, #1
    str r2, [r10]

    bl actual_number
    cmp r5, #0
    bne 6f

2:
    ldr r9, =var_STATE
    ldr r8, [r9]
    cmp r8, #0
    beq 4f                   /* zero, so execute immediately */

    ldr r0, =LIT
    bl actual_comma

    ldr r2, [r10]
    cmp r2, #0
    beq 3f
    mov r0, r4
    bl actual_comma

3:
    NEXT

4:
    ldr r2, [r10]
    cmp r2, #0
    bne 5f

    ldr r1, [r0]
    bx r1

5:
    push {r4}
    NEXT
    
6:
    NEXT
/*
6:	// Parse error (not a known word or a number in the current BASE).
	// Print an error message followed by up to 40 characters of context.
	mov $2,%ebx		// 1st param: stderr
	mov $errmsg,%ecx	// 2nd param: error message
	mov $errmsgend-errmsg,%edx // 3rd param: length of string
	mov $__NR_write,%eax	// write syscall
	int $0x80
*/
6:
    NEXT
/*
	mov (currkey),%ecx	// the error occurred just before currkey position
	mov %ecx,%edx
	sub $buffer,%edx	// %edx = currkey - buffer (length in buffer before currkey)
	cmp $40,%edx		// if > 40, then print only 40 characters
	jle 7f
	mov $40,%edx
7:	sub %edx,%ecx		// %ecx = start of area to print, %edx = length
	mov $__NR_write,%eax	// write syscall
	int $0x80

	mov $errmsgnl,%ecx	// newline
	mov $1,%edx
	mov $__NR_write,%eax	// write syscall
	int $0x80

	NEXT
*/


literal_mode:
    .int 0

