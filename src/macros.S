# Push to stack pseudo-instruction
.macro push reg
	addi sp, sp, -8
	sd \reg, 0(sp)
.endm

# Pop from stack pseudo-instruction
.macro pop reg
	ld \reg, 0(sp)
	addi sp, sp, 8
.endm

# Pop from stack and return pseudo-instruction
.macro popret
	pop ra
	ret
.endm
