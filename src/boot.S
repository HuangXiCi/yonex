.section ".text.boot"

.globl main
.globl _start


_start:
	/* set the stack of SP, size 4KB */
	la sp, __stack_top

	/* goto C */
	call main

_spin:
	j _spin
