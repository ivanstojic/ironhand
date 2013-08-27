defcode "+",1,,ADD
    pop {r0, r1}
    add r0, r1
    push {r0}
    NEXT

defcode "*",1,,MUL
    pop {r1, r2}
    mul r0, r1, r2
    push {r0}
    NEXT

defcode "4+",2,,INCR4
    pop {r0}
    add r0, #4
    push {r0}
    NEXT

defcode "-",1,,SUB
    pop {r0, r1}
    sub r1, r0
    push {r1}
    NEXT

