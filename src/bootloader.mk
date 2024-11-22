BOOTLOADER = src/bootloader.elf
OBJS = src/boot.o \
       src/uart.o \
       src/utils.o

$(BOOTLOADER): $(OBJS)
	$(LD) -T src/bootloader.lds $? -o $@

bootloader-clean:
	rm -f $(BOOTLOADER) $(OBJS)
