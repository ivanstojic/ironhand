.include "asm/macros.S"
.global _entrypoint

_entrypoint:
    ldr sp, =stack_top
    ldr r11, =return_stack_top;

    mov r0, #42
    push {r0}

    ldr r12, =dummy

    NEXT

dummy:
    .int WIGGLE

    bl LocalEcho
    bl PrintUART
    b .

