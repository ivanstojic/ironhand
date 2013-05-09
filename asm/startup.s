.include "asm/macros.S"
.global _entrypoint

_entrypoint:
    /* Init stacks - broken on purpose for now, because I don't have a better way
    to set them other than manual addr values. Halp. */
    ldr sp, =stack_top
    ldr r11, =return_stack_top;

    ldr r12, =dummy

    NEXT

dummy:
    .int LIT, 'x'
    .int EMIT
    .int KEY, EMIT
    .int KEY, EMIT
    .int EXIT

