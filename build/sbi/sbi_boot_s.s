# 0 "sbi/sbi_boot.S"
# 1 "/home/hxc/yonex//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "sbi/sbi_boot.S"
.section ".text.boot"

.globl _start
_start:

 la sp, stacks_start
 li t0, 4096
 add sp, sp, t0
    li t1, 0x3fffffffffffff
    li t2, 0xf
    csrw pmpaddr0, t1
    csrw pmpcfg0, t2


 tail sbi_main

.section .data
.align 12
.global stacks_start
stacks_start:
 .skip 4096
