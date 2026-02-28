	.file	"sbi_main.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/hxc/yonex" "sbi/sbi_main.c"
	.align	2
	.globl	sbi_main
	.type	sbi_main, @function
sbi_main:
.LFB0:
	.file 1 "sbi/sbi_main.c"
	.loc 1 10 1
	.cfi_startproc
	addi	sp,sp,-64
	.cfi_def_cfa_offset 64
	sd	s0,56(sp)
	.cfi_offset 8, -8
.LBB2:
	.loc 1 14 39
 #APP
# 14 "sbi/sbi_main.c" 1
	csrr a5, mstatus
# 0 "" 2
 #NO_APP
	mv	s0,a5
	.loc 1 14 111
	mv	a5,s0
.LBE2:
	.loc 1 14 6
	sd	a5,40(sp)
	.loc 1 15 16
	ld	a4,40(sp)
	li	a5,-8192
	addi	a5,a5,2047
	and	a4,a4,a5
	.loc 1 15 6
	li	a5,4096
	addi	a5,a5,-2048
	or	a5,a4,a5
	sd	a5,40(sp)
	.loc 1 16 6
	ld	a5,40(sp)
	andi	a5,a5,-129
	sd	a5,40(sp)
.LBB3:
	.loc 1 17 19
	ld	a5,40(sp)
	sd	a5,32(sp)
	.loc 1 17 47
	ld	a5,32(sp)
 #APP
# 17 "sbi/sbi_main.c" 1
	csrw mstatus, a5
# 0 "" 2
 #NO_APP
.LBE3:
.LBB4:
	.loc 1 20 19
	li	a5,1025
	slli	a5,a5,21
	sd	a5,24(sp)
	.loc 1 20 54
	ld	a5,24(sp)
 #APP
# 20 "sbi/sbi_main.c" 1
	csrw mepc, a5
# 0 "" 2
 #NO_APP
.LBE4:
.LBB5:
	.loc 1 22 19
	li	a5,1025
	slli	a5,a5,21
	sd	a5,16(sp)
	.loc 1 22 54
	ld	a5,16(sp)
 #APP
# 22 "sbi/sbi_main.c" 1
	csrw stvec, a5
# 0 "" 2
 #NO_APP
.LBE5:
.LBB6:
	.loc 1 24 19
	sd	zero,8(sp)
	.loc 1 24 45
	ld	a5,8(sp)
 #APP
# 24 "sbi/sbi_main.c" 1
	csrw sie, a5
# 0 "" 2
 #NO_APP
.LBE6:
.LBB7:
	.loc 1 26 19
	sd	zero,0(sp)
	.loc 1 26 45
	ld	a5,0(sp)
 #APP
# 26 "sbi/sbi_main.c" 1
	csrw satp, a5
# 0 "" 2
 #NO_APP
.LBE7:
	.loc 1 29 2
 #APP
# 29 "sbi/sbi_main.c" 1
	mret
# 0 "" 2
	.loc 1 30 1
 #NO_APP
	nop
	ld	s0,56(sp)
	.cfi_restore 8
	addi	sp,sp,64
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	sbi_main, .-sbi_main
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x137
	.2byte	0x5
	.byte	0x1
	.byte	0x8
	.4byte	.Ldebug_abbrev0
	.uleb128 0x3
	.4byte	.LASF2
	.byte	0x1d
	.byte	0x3
	.4byte	0x31647
	.4byte	.LASF0
	.4byte	.LASF1
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x4
	.4byte	.LASF3
	.byte	0x1
	.byte	0x9
	.byte	0x6
	.8byte	.LFB0
	.8byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x133
	.uleb128 0x1
	.string	"val"
	.byte	0xb
	.byte	0x10
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x2
	.8byte	.LBB2
	.8byte	.LBE2-.LBB2
	.4byte	0x82
	.uleb128 0x1
	.string	"__v"
	.byte	0xe
	.byte	0x22
	.4byte	0x133
	.uleb128 0x1
	.byte	0x58
	.byte	0
	.uleb128 0x2
	.8byte	.LBB3
	.8byte	.LBE3-.LBB3
	.4byte	0xa6
	.uleb128 0x1
	.string	"__v"
	.byte	0x11
	.byte	0x13
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x2
	.8byte	.LBB4
	.8byte	.LBE4-.LBB4
	.4byte	0xca
	.uleb128 0x1
	.string	"__v"
	.byte	0x14
	.byte	0x13
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.uleb128 0x2
	.8byte	.LBB5
	.8byte	.LBE5-.LBB5
	.4byte	0xee
	.uleb128 0x1
	.string	"__v"
	.byte	0x16
	.byte	0x13
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.uleb128 0x2
	.8byte	.LBB6
	.8byte	.LBE6-.LBB6
	.4byte	0x112
	.uleb128 0x1
	.string	"__v"
	.byte	0x18
	.byte	0x13
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.uleb128 0x5
	.8byte	.LBB7
	.8byte	.LBE7-.LBB7
	.uleb128 0x1
	.string	"__v"
	.byte	0x1a
	.byte	0x13
	.4byte	0x133
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.byte	0x7
	.4byte	.LASF4
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x90
	.uleb128 0xb
	.uleb128 0x91
	.uleb128 0x6
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x8
	.byte	0
	.2byte	0
	.2byte	0
	.8byte	.Ltext0
	.8byte	.Letext0-.Ltext0
	.8byte	0
	.8byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF4:
	.string	"long unsigned int"
.LASF3:
	.string	"sbi_main"
.LASF2:
	.string	"GNU C23 15.2.0 -mcmodel=medany -mabi=lp64 -misa-spec=20191213 -march=rv64imafd_zicsr_zmmul_zaamo_zalrsc -g -O0 -fno-PIE -fomit-frame-pointer"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/hxc/yonex"
.LASF0:
	.string	"sbi/sbi_main.c"
	.ident	"GCC: () 15.2.0"
	.section	.note.GNU-stack,"",@progbits
