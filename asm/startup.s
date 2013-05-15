.include "asm/macros.S"
.global _entrypoint

_entrypoint:
    /* Init stacks - broken on purpose for now, because I don't have a better way
    to set them other than manual addr values. Halp. */
    ldr sp, =stack_top
    ldr r11, =return_stack_top;


    /* After everything's said and done... this will start the system */
    ldr r12, =start_over_here
    NEXT

start_over_here:
    # .int QUIT

