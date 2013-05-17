/* ( w a-addr -- ) store w into a-addr */
defcode "!",1,,STORE
    pop {r0, r1}
    str r1, [r0]
    NEXT

/* ( a-addr -- w ) w is the value stored at a-addr */
defcode "@",1,,FETCH
    pop {r0}
    ldr r1, [r0]
    push {r1}
    NEXT

/* ( w a-addr -- ) add w to value stored at a-addr */
defcode "+!",2,,ADDSTORE
    pop {r0, r1}
    ldr r2, [r0]
    add r2, r1
    str r2, [r0]
    NEXT

/* ( w a-addr -- ) subtract w from value stored at a-addr */
defcode "-!",2,,SUBSTORE
    pop {r0, r1}
    ldr r2, [r0]
    sub r2, r1
    str r2, [r0]
    NEXT

/* ( a-addr b -- ) store byte into a-addr */
defcode "C!",2,,STOREBYTE
    pop {r0, r1}
    strb r1, [r0]
    NEXT

/* ( addr -- b ) b is the byte stored at a-addr */
defcode "C@",2,,FETCHBYTE
    pop {r0}
    ldrb r1, [r0]
    push {r1}
    NEXT

/* ( addr1 addr2 -- addr1+1 addr2+2 ) copy byte from addr1 to addr2, push back incremented addresses */
defcode "C@C!",4,,CCOPY
    pop {r0, r1}
    ldrb r2, [r0], #1
    strb r2, [r1]
    add r1, #1
    push {r0, r1}
    NEXT

