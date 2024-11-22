.include "src/macros.S"

.global strlen

strlen:
	push ra
	li t0, 0
	push a0
_strlen_count:
	lbu t1, 0(a0)
	beqz t1, _strlen_end
	addi a0, a0, 1
	j _strlen_count
_strlen_end:
	pop a1
	sub a0, a0, a1
	addi a0, a0, -1
	popret
