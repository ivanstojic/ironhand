/*
   R0 = instruction being "decoded" / execd
   R11 = forth return stack pointer
   R12 = forth codeword to execute next (forth quasi PC)
*/

.set link, 0

/* Fetch next FORTH instruction in direct threading mode and jump to its
   execution handler */
.macro NEXT
    ldr r0, [r12], #4
    ldr r1, [r0]
    bx r1
.endm


.macro PUSHRSP reg
    str \reg, [r11, #-4]!
.endm


.macro POPRSP reg
    ldr \reg, [r11], #4
.endm


.set F_IMMED,0x80
.set F_HIDDEN,0x20
.set F_LENMASK,0x1f
.set F_NOIMM_MASK, F_HIDDEN | F_LENMASK


/* Initializing the chain of forth word links. */
/*
.ifndef link
.global link
.set link,0
.endif
*/


/* DEFWORD: define a forth word written in forth
    This macro is used to define a forth word usable in our system
    and written in forth itself. The word declaration begins with this
    macro and extends until a call to the EXIT macro
*/
.macro defword name, namelen, flags=0, label
.balign 4
.globl name_\label
name_\label :
	.int link		/* link */
	.set link,name_\label
	.byte \flags+\namelen	/* flags + length byte */
	.ascii "\name"		/* the name */
	.balign 4		/* padding to next 4 byte boundary */
	.globl \label
\label :
	.int DOCOL		/* codeword - the interpreter */
.endm


/* DEFCODE: define a forth word written in assembler
    This macro is used to define a forth word usable in our system
    and written in assembler. The word declaration begins with this
    macro and extends until a call to forth word NEXT in the body
*/
.macro defcode name, namelen, flags=0, label
.balign 4
.globl name_\label
name_\label :
	.int link
	.set link,name_\label
	.byte \flags+\namelen
	.ascii "\name"	
        .balign 4
.global \label
\label :
	.int code_\label
	.globl code_\label
code_\label :	
.endm
        


.macro defvar name, namelen, flags=0, label, initial=0
	defcode \name,\namelen,\flags,\label
        ldr r0, =var_\name
        push {r0}
	NEXT
.balign 4
.global var_\name
var_\name :
	.int \initial
.endm



.macro defconst name, namelen, flags=0, label, value
    defcode \name,\namelen,\flags,\label
    ldr r0, const_\label
    push {r0}
    NEXT
const_\label:
    .int \value
.endm

