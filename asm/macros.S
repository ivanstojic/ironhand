/*

R0 = instruction being "decoded" / execd
R12 = forth codeword to execute next (forth quasi PC)
R11 = forth return stack pointer

*/

.macro NEXT
    ldr r0, [r12], #4
    ldr r0, [r0]
    bx r0
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

	/* Store the chain of links. */
	.set link,0

	.macro defword name, namelen, flags=0, label
	.align 4
	.globl name_\label
name_\label :
	.int link		/* link */
	.set link,name_\label
	.byte \flags+\namelen	/* flags + length byte */
	.ascii "\name"		/* the name */
	.align 4		/* padding to next 4 byte boundary */
	.globl \label
\label :
	.int DOCOL		/* codeword - the interpreter */
	.endm


	.macro defcode name, namelen, flags=0, label
	.align 4
	.globl name_\label
name_\label :
	.int link
	.set link,name_\label
	.byte \flags+\namelen
	.ascii "\name"	
	.align 4
	.globl \label
\label :
	.int code_\label
	.globl code_\label
code_\label :	
	.endm
        
