ENTRY(_Reset)
SECTIONS
{
    . = 0x10000; // Origin is at 64k -- for qemu -kernel loading
    .startup . : { asm/startup.o(.text) }

    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss COMMON) }

    . = ALIGN(8);
    . = . + 0x10000; /* 64kB of stack memory */
    stack_top = .;
}

