.include "src/macros.S"

.set UART_BASE_ADDR, 0x10010000
.set UART_TXDATA, 0x0
.set UART_TXCRTL, 0x8
.set UART_IE, 0x10

.global uart_setup
.global uart_write
.global uart_println

uart_write:
	push ra
	li t0, UART_BASE_ADDR
_uart_write_try:
	amoor.w t1, a0, UART_TXDATA(t0)
	bnez t1, _uart_write_try
	fence
	popret

uart_println:
	push ra
_uart_println_loop:
	lbu t1, 0(a0)
	beqz t1, _uart_println_end
	push a0
	mv a0, t1
	call uart_write
	pop a0
	addi a0, a0, 1
	j _uart_println_loop
_uart_println_end:
#	addi a0, zero, '\n'
#	call uart_write
	li a0, 0
	popret

uart_setup:
	push ra
	# Enable Tx in UART and disable interrupts
	li t0, UART_BASE_ADDR
	li t1, 0x1
	sw t1, UART_TXCRTL(t0)
	sw zero, UART_IE(t0)
	# TODO: Configure baudrate.
	# Not needed for Qemu.
	popret
