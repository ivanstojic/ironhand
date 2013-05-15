.include "asm/macros.S"
.text

defcode "LITSTRING",9,,LITSTRING
    ldr r0, [r12], #4
    push {r12}
    push {r0}
    add r12, r0
    add r12, #3
    and r12, #~3
    NEXT

