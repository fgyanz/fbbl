.include "src/macros.S"

.set STACK_SIZE, 512
.set NEWLINE, '\n'

.section .data
init_msg: .ascii "#### FizzBuzz Bootloader ####\n\0"
hart_msg: .ascii "Current hart ID: \0"
misa_msg: .ascii "Supported ISA: \0"

_stack:
	.skip STACK_SIZE, 0

.section .text
.global _start

_start:
	# Flush instruction cache
	fence.i
	call _reset_regs
	csrr s0, mhartid
	bnez s0, _wait # Use only hart 0 during boot-up

	la sp, _stack
	addi sp, sp, STACK_SIZE
	# save arguments from previous boot stage
	push a0
	push a1

	call uart_setup
	la a0, init_msg
	call uart_println

	# Print current hart
	la a0, hart_msg
	call uart_println
	addi a0, s0, 0x30
	call uart_write
	li a0, NEWLINE
	call uart_write

	# Some checks
	call _isa_print
	
	# TODO: Setup trap vector
	
	# TODO: Jump to kernel in supervisor mode
	j _wait

_reset_regs:
	# Clean state
	li sp, 0
	li gp, 0
	li tp, 0
	li t0, 0
	li t1, 0
	li t2, 0
	li s0, 0
	li s1, 0
#	li a0, 0
#	li a1, 0
	li a2, 0
	li a3, 0
	li a4, 0
	li a5, 0
	li a6, 0
	li a7, 0
	li s2, 0
	li s3, 0
	li s4, 0
	li s5, 0
	li s6, 0
	li s7, 0
	li s8, 0
	li s9, 0
	li s10, 0
	li s11, 0
	li t3, 0
	li t4, 0
	li t5, 0
	li t6, 0
	csrw mscratch, zero
	ret

_isa_print:
	push ra
	la a0, misa_msg
	call uart_println
	csrr t0, misa
	li t1, 0 # counter
	li t3, 27 # MISA max extensions
_isa_print_loop:
	andi t2, t0, 1
	srli t0, t0, 1
	addi t1, t1, 1
	bge t1, t3, _isa_print_end
	beqz t2, _isa_print_loop

	# Print ISA extension letter
	li a0, 0x40
	add a0, a0, t1
	push t1
	push t0
	call uart_write
	pop t0
	pop t1
	j _isa_print_loop
_isa_print_end:
	li a0, NEWLINE
	call uart_write
	popret

# Wait for an IPI
_wait:
	# Allow IPIs to current hart
	li a2, 0x8
	csrw mie, a2
_wait_try:
	wfi
	j _wait_try
