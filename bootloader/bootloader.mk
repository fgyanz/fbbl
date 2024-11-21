BOOTDIR = bootloader
BOOTLOADER = $(BOOTDIR)/boot.o \
	     $(BOOTDIR)/uart.o \
	     $(BOOTDIR)/utils.o

$(BOOTLOADER):
	$(LD) -T kernel/kernel.lds $@ -o $<

bootloader-clean:
	rm -f $(BOOTLOADER)
