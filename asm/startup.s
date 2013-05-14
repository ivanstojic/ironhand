.include "asm/macros.S"
.global _entrypoint

_entrypoint:
    /* Init stacks - broken on purpose for now, because I don't have a better way
    to set them other than manual addr values. Halp. */
    ldr sp, =stack_top
    ldr r11, =return_stack_top;

    mov r0, #6
    ldr r1, msg
    bl actual_find

    ldr r12, =dummy
    NEXT

    /* After everything's said and done... this will start the system */
    ldr r12, =start_over_here
    NEXT

msg:
    .string "LATEST"

dummy:
    .int LIT, 'a', EMIT
    .int WORD, NUMBER, DROP
    .int EMIT
    .int EXIT

start_over_here:
    # .int QUIT

