defcode "AND",3,,LAND
    pop {r0, r1}
    and r0, r1
    push {r0}
    NEXT

defcode "0=",2,,ZEQU
    pop {r0}
    mov r1, #0
    cmp r0, r1
    moveq r1, #1
    push {r1}
    NEXT
