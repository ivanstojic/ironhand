.global _entrypoint

_entrypoint:
    /* Init stacks - broken on purpose for now, because I don't have a better way
    to set them other than manual addr values. Halp. */
    ldr sp, =stack_top
    ldr r11, =return_stack_top;


    /* After everything's said and done... this will start the system */
    ldr r12, =hello_and_echo_forever
    NEXT

hello_and_echo_forever:
    .int LITSTRING
    .int 7
    .ascii "Forth!\n"
    .balign 4
    .int TELL

    .int WORD, TELL
    .int LIT, 10, EMIT
    .int BRANCH, -6

test_find:
    .int LITSTRING
    .int 4
    .ascii "EMIT"
    .int FIND
    .int BRANCH, -1

bootstrap:
    .int QUIT
