ENTRY(_entrypoint)
SECTIONS
{
    . = 0x10000; /* Origin is at 64k -- for qemu -kernel loading */
    .startup : { asm/startup.o(.text) }

    .text : {
        asm/forth-core.o(.text)
    }

    .text : { asm/compiler.o(.text) }
    .text : { asm/flowcontrol.o(.text) }
    .text : { asm/forth-math.o(.text) }
    .text : { asm/forth-memory.o(.text) }
    .text : { asm/forth-stacks.o(.text) }
    .text : { asm/io.o(.text) }
    .text : { asm/startup.o(.text) }
    .text : { asm/strings.o(.text) }

    .text : {
        asm/forth-dictionary.o
    }

    end_of_precompiled_code = ABSOLUTE(.);

    . = . + 0x10000; /* 64kB of stack memory */
    stack_top = .;

    . = . + 0x10000; /* 64kB of return stack memory */
    return_stack_top = .;
}

