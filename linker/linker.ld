OUTPUT_ARCH(riscv)
ENTRY(_start)

PHDRS
{
  text PT_LOAD FLAGS(5);    /* RX */
  data PT_LOAD FLAGS(6);    /* RW */
}

SECTIONS
{
	. = 0x80000000;

	.text.boot : { *(.text.boot) } :text
	.text      : { *(.text) }      :text
	.rodata    : { *(.rodata*) }   :text

	.data      : { *(.data) *(.sdata) } :data
	.bss       : { *(.bss) *(.sbss) }   :data
}

__stack_top = 0x80020000;
