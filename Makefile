CC_ROOT=/Users/ivans/Documents/Programming/IronHand/arm-cs-tools/
CROSS_COMPILE=arm-none-eabi-
CPU_TYPE=arm926ej-s
CFLAGS=-g

#
# No touchy touchy
#

CFLAGS=$(CFLAGS) -mcpu=$(CPU_TYPE)

ASMDIR=asm

# All *.s files, except startup.s which is assembled separately, and dictionary.s which is
# manually appended to the end so that its value of link can be pushed into var_LAST
ASMS:=$(filter-out $(ASMDIR)/dictionary.s,$(filter-out $(ASMDIR)/startup.s,$(wildcard $(ASMDIR)/*.s))) $(ASMDIR)/dictionary.s
INCLUDES:=$(wildcard $(ASMDIR)/*.S)

ASMOBJ:=asm/startup.o asm/forth.o


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
	arm-none-eabi-objdump -d $< | less

.PHONY: gdb
gdb: ironhand.elf
	arm-none-eabi-gdb -x gdb.params $<


# Actual workers

ironhand.img: ironhand.elf
	$(CROSS_COMPILE)objcopy -O binary ironhand.elf ironhand.img

ironhand.elf: asm/ironhand.ld $(ASMOBJ)
	$(CROSS_COMPILE)ld -T asm/ironhand.ld $(ASMOBJ) -o ironhand.elf

asm/startup.o: asm/startup.s $(INCLUDES)
	$(CROSS_COMPILE)as -mcpu=$(CPU_TYPE) -g $(INCLUDES) asm/startup.s -o $@

asm/forth.o: $(ASMS) $(INCLUDES)
	$(CROSS_COMPILE)as -mcpu=$(CPU_TYPE) -g $(INCLUDES) $(ASMS) -o $@

