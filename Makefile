CC_ROOT=/Users/ivans/Documents/Programming/IronHand/arm-cs-tools/
CROSS_COMPILE=arm-none-eabi-
CPU_TYPE=arm926ej-s
CFLAGS=-g

#
# No touchy touchy
#

CFLAGS=$(CFLAGS) -mcpu=$(CPU_TYPE)

ASMDIR=asm

ASMS:=$(wildcard $(ASMDIR)/*.s)
INCLUDES:=$(wildcard $(ASMDIR)/*.S)

ASMOBJ:=$(ASMS:$(ASMDIR)/%.s=$(ASMDIR)/%.o)


# Housekeeping and running/debugging

.PHONY: run
run: ironhand.img
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel $<

.PHONY: debug
debug: ironhand.img
	qemu-system-arm -s -S -M versatilepb -m 128M -nographic -kernel $<

.PHONY: clean
clean:
	find . -iname '*.o' | xargs rm
	rm -f ironhand.img ironhand.elf

.PHONY: map
map: ironhand.elf
	arm-none-eabi-objdump -d ironhand.elf | less


# Actual workers

ironhand.img: ironhand.elf
	$(CROSS_COMPILE)objcopy -O binary ironhand.elf ironhand.img

ironhand.elf: asm/ironhand.ld $(ASMOBJ)
	$(CROSS_COMPILE)ld -T asm/ironhand.ld $(ASMOBJ) -o ironhand.elf

asm/%.o: asm/%.s $(INCLUDES)
	$(CROSS_COMPILE)as -mcpu=$(CPU_TYPE) -g $< -o $@


