.include "asm/macros.S"
.text

/* word-width ops */

/*
    ( addr value -- : store value at addr )
*/
defcode "!",1,,STORE
    pop {r0, r1}
    str r1, [r0]
    NEXT

/*
    ( addr -- value : fetch word from addr, push to stack )
*/
defcode "@",1,,FETCH
    pop {r0}
    ldr r1, [r0]
    push {r1}
    NEXT

/*
    ( addr value -- : add value to value stored at addr )
*/
defcode "+!",2,,ADDSTORE
    pop {r0, r1}
    ldr r2, [r0]
    add r2, r1
    str r2, [r0]
    NEXT

/*
    ( addr value -- : subtract value from value stored at addr )
*/
defcode "-!",2,,SUBSTORE
    pop {r0, r1}
    ldr r2, [r0]
    sub r2, r1
    str r2, [r0]
    NEXT

/*
    ( addr value -- : store byte at addr )
*/
defcode "C!",2,,STOREBYTE
    pop {r0, r1}
    strb r1, [r0]
    NEXT

/* ( addr -- value : fetch byte from addr, push to stack ) */
defcode "C@",2,,FETCHBYTE
    pop {r0}
    ldrb r1, [r0]
    push {r1}
    NEXT



