BOOTLOADER = src/bootloader.elf
OBJS = src/boot.o

$(BOOTLOADER): $(OBJS)

bootloader-clean:
	rm -f $(BOOTLOADER) $(OBJS)
