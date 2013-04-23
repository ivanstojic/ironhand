.global _entrypoint

_entrypoint:
    ldr sp, =stack_top
    bl LocalEcho
    bl PrintUART
    b .

