defcode "+",1,,ADD
    pop {r0, r1}
    add r0, r1
    push {r0}
    NEXT

defcode "4+",2,,INCR4
    pop {r0}
    add r0, #4
    push {r0}
    NEXT

