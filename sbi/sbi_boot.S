.section ".text.boot"

.globl _start
_start:
	/* setup stack with 4KB size */
	la sp, stacks_start
	li t0, 4096
	add sp, sp, t0
    li      t1, 0x3fffffffffffff
    li      t2, 0xf
    csrw    pmpaddr0, t1
    csrw    pmpcfg0, t2

	/* goto C */
	tail sbi_main

.section .data
.align  12
.global stacks_start
stacks_start:
	.skip 4096

