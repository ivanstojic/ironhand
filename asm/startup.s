.include "asm/macros.S"
.global _entrypoint

_entrypoint:
    /* Init stacks - broken on purpose for now, because I don't have a better way
    to set them other than manual addr values. Halp. */
    ldr sp, =stack_top
    ldr r11, =return_stack_top;

    ldr r12, =dummy
    NEXT

    /* After everything's said and done... this will start the system */
    ldr r12, =start_over_here
    NEXT


dummy:
    .int FAVCHAR
    .int EMIT

    .int LIT, 3
    .int BASE
    .int ADDSTORE /* BASE=BASE+3 */

    .int LIT, 2
    .int BASE
    .int SUBSTORE

    .int BASE, FETCH /* get addr of BASE, fetch to stack */
    .int EMIT /* and print */


    .int KEY, EMIT
    .int KEY, EMIT
    .int EXIT

start_over_here:
    # .int QUIT

