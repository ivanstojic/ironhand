.global _entrypoint

_entrypoint:
    ldr sp, =stack_top
    ldr r11, =return_stack_top;

    bl LocalEcho
    bl PrintUART
    b .

