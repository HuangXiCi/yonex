GNU ?= riscv64-unknown-elf

COPS += -save-temps=obj -g -O0 -Wall -nostdlib -nostdinc -Iinclude -Ikernel/device/include -mcmodel=medany -mabi=lp64 -march=rv64imafd -fno-PIE -fomit-frame-pointer
COPS += -DCONFIG_BOARD_QEMU

##############
#  build yonex
##############
BUILD_DIR = build/kernel
SRC_DIR = kernel
LINKER_DIR = linker

all : yonex.bin sbi.bin

# Check if verbosity is ON for build process
CMD_PREFIX_DEFAULT := @
ifeq ($(V), 1)
	CMD_PREFIX :=
else
	CMD_PREFIX := $(CMD_PREFIX_DEFAULT)
endif

clean :
	rm -rf $(BUILD_DIR) $(SBI_BUILD_DIR) *.bin  *.map *.elf

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	$(CMD_PREFIX)mkdir -p $(dir $@); echo " CC   $@" ; $(GNU)-gcc $(COPS) -c $< -o $@

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.S
	$(CMD_PREFIX)mkdir -p $(dir $@); echo " AS   $@"; $(GNU)-gcc $(COPS) -c $< -o $@

C_FILES = $(shell find $(SRC_DIR) -name "*.c")
ASM_FILES = $(shell find $(SRC_DIR) -name "*.S")
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%_s.o)

DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)

yonex.bin: $(LINKER_DIR)/kernel_linker.ld $(OBJ_FILES)
	$(CMD_PREFIX)$(GNU)-ld -T $(LINKER_DIR)/kernel_linker.ld -o $(BUILD_DIR)/yonex.elf  $(OBJ_FILES) -Map $(BUILD_DIR)/yonex.map; echo " LD $(BUILD_DIR)/yonex.elf"
	$(CMD_PREFIX)$(GNU)-objcopy $(BUILD_DIR)/yonex.elf -O binary $(BUILD_DIR)/yonex.bin; echo " OBJCOPY yonex.bin"

##############
#  build SBI
##############
SBI_BUILD_DIR = build/sbi
SBI_SRC_DIR = sbi
$(SBI_BUILD_DIR)/%_c.o: $(SBI_SRC_DIR)/%.c
	$(CMD_PREFIX)mkdir -p $(dir $@); echo " CC   $@" ; $(GNU)-gcc $(COPS) -c $< -o $@

$(SBI_BUILD_DIR)/%_s.o: $(SBI_SRC_DIR)/%.S
	$(CMD_PREFIX)mkdir -p $(dir $@); echo " AS   $@"; $(GNU)-gcc $(COPS) -c $< -o $@

SBI_C_FILES = $(shell find $(SBI_SRC_DIR) -name "*.c")
SBI_ASM_FILES = $(shell find $(SBI_SRC_DIR) -name "*.S")
SBI_OBJ_FILES = $(SBI_C_FILES:$(SBI_SRC_DIR)/%.c=$(SBI_BUILD_DIR)/%_c.o)
SBI_OBJ_FILES += $(SBI_ASM_FILES:$(SBI_SRC_DIR)/%.S=$(SBI_BUILD_DIR)/%_s.o) 

# DEP_FILES = $(SBI_OBJ_FILES:%.o=%.d)
# -include $(DEP_FILES)

sbi.bin: $(LINKER_DIR)/sbi_linker.ld $(SBI_OBJ_FILES)
	$(CMD_PREFIX)$(GNU)-ld -T $(LINKER_DIR)/sbi_linker.ld -o $(SBI_BUILD_DIR)/sbi.elf  $(SBI_OBJ_FILES) -Map $(SBI_BUILD_DIR)/sbi.map; echo " LD $(SBI_BUILD_DIR)/sbi.elf"
	$(CMD_PREFIX)$(GNU)-objcopy $(SBI_BUILD_DIR)/sbi.elf -O binary $(SBI_BUILD_DIR)/sbi.bin; echo " OBJCOPY sbi.bin"

##############
#  run qemu
##############
QEMU_FLAGS  += -nographic -machine virt -m 128M 
QEMU_BIOS = -bios $(SBI_BUILD_DIR)/sbi.bin  -device loader,file=$(BUILD_DIR)/yonex.bin,addr=0x80200000 
run: all
	qemu-system-riscv64 $(QEMU_FLAGS) $(QEMU_BIOS) -kernel $(BUILD_DIR)/yonex.elf
gdb: all
	qemu-system-riscv64 $(QEMU_FLAGS) $(QEMU_BIOS) -kernel $(BUILD_DIR)/yonex.elf -S -s
