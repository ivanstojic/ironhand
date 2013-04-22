CC_ROOT=/Users/ivans/Documents/Programming/IronHand/arm-cs-tools/
CROSS_COMPILE=arm-none-eabi-
CPU_TYPE=arm926ej-s
CFLAGS=-g

#
# No touchy touchy
#

CFLAGS=$(CFLAGS) -mcpu=$(CPU_TYPE)

SRCDIR=src
ASMDIR=asm

SOURCES:=$(wildcard $(SRCDIR)/*.c)
ASMS:=$(wildcard $(ASMDIR)/*.s)

COBJ:=$(SOURCES:$(SRCDIR)/%.c=$(SRCDIR)/%.o) 
ASMOBJ:=$(ASMS:$(ASMDIR)/%.s=$(ASMDIR)/%.o)


#
# And off we go...
#

.PHONY: run
run: ironhand.img
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel $<

ironhand.img: ironhand.elf
	$(CROSS_COMPILE)objcopy -O binary ironhand.elf ironhand.img

ironhand.elf: asm/ironhand.ld $(ASMOBJ)
	$(CROSS_COMPILE)ld -T asm/ironhand.ld $(ASMOBJ) -o ironhand.elf

src/%.o: src/%.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c $< -o $@

asm/%.o: asm/%.s
	$(CROSS_COMPILE)as -mcpu=$(CPU_TYPE) -g $< -o $@


.PHONY: clean
clean:
	find . -iname '*.o' | xargs rm
	rm -f ironhand.img ironhand.elf

