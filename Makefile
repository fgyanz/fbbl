.POSIX:

all: bins

include src/bootloader.mk
include test/kernel.mk

TOOLCHAIN=riscv64-suse-linux-
CC=$(TOOLCHAIN)gcc
AS=$(TOOLCHAIN)as
LD=$(TOOLCHAIN)ld

ISA=rv64imafdc_zaamo_zicntr_zicsr_zifencei_zihpm_zca_zcmp_zba_zbb
ASFLAGS=-march=$(ISA) -mabi=lp64d

.SUFFIXES: .S .o
.S.o:
	@$(AS) $(ASFLAGS) $< -o $@

bins: $(BOOTLOADER) $(TEST_KRNL)

run:
	@qemu-system-riscv64 $(QEMUFLAGS) -M sifive_u -smp 5 -m 2G\
		             -display none -serial stdio -bios $(BOOTLOADER)\
			     -kernel $(TEST_KRNL)

clean: bootloader-clean test-clean
