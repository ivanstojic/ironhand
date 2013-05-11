.include "asm/macros.S"
.text

defcode ">R",2,,TOR
    pop {r0}
    PUSHRSP r0
    NEXT

defcode "R>",2,,FROMR
    POPRSP r0
    push {r0}
    NEXT

defcode "RSP@",4,,RSPFETCH
    push {r11}
    NEXT

defcode "RSP!",4,,RSPSTORE
    pop {r11}
    NEXT

defcode "RDROP",5,,RDROP
    add r11, #4
    NEXT


defcode "DSP@",4,,DSPFETCH
    mov r0, sp
    push {r0}
    NEXT

defcode "DSP!",4,,DSPSTORE
    ldr sp, [sp]
    NEXT

