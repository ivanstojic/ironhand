ENTRY(_entrypoint)
SECTIONS
{
    . = 0x10000; /* Origin is at 64k -- for qemu -kernel loading */
    .startup : { asm/startup.o(.text) }

    .text : { *(EXCLUDE_FILE (*asm/startup.o) .text) }

    end_of_precompiled_code = ABSOLUTE(.);

    . = . + 0x10000; /* 64kB of stack memory */
    stack_top = .;

    . = . + 0x10000; /* 64kB of return stack memory */
    return_stack_top = .;
}

