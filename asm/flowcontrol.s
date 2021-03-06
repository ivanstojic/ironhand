/* ( -- )
   reads next word from forth instruction pointer, adds that many cells (w*4) to
   forth instruction pointer */
defcode "BRANCH",6,,BRANCH
    ldr r0, [r12]
    add r12, r12, r0, LSL #2
    NEXT

/* ( w -- ) if w is 0, performs a branch as above, otherwise moves FIP over the branch
   address */
defcode "0BRANCH",7,,ZBRANCH
    pop {r0}
    cmp r0, #0
    beq code_BRANCH
    add r12, #4
    NEXT

