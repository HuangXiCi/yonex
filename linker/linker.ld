OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{

	. = 0x80000000,

	.text.boot : { *(.text.boot) }
	.text : { *(.text) }
	.data : { *(.data) }
}

