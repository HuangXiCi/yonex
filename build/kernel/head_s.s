# 0 "kernel/head.S"
# 1 "/home/hxc/yonex//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "kernel/head.S"
.section ".text.boot"

.globl _start
_start:

 la sp, stacks_start
 li t0, 4096
 add sp, sp, t0


 tail _func

.section .data
.align 12
.global stacks_start
stacks_start:
 .skip 4096
