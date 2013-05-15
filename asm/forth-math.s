.include "asm/macros.S"
.text

defcode "4+",2,,INCR4
    pop {r0}
    add r0, #4
    push {r0}
    NEXT

