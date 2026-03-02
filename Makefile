GNU ?= riscv64-unknown-elf
COPS += -save-temps=obj -g -O0 -Wall -nostdlib -nostdinc -mcmodel=medany -mabi=lp64 -march=rv64imafd -fno-PIE -fomit-frame-pointer

BUILD_DIR = build
SRC_DIR = src
LINKER_DIR = linker

all : yonex.bin

clean :
	rm -rf $(BUILD_DIR)

##############
#  compile sources
##############

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@); echo " CC   $@"; $(GNU)-gcc $(COPS) -c $< -o $@

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.S
	mkdir -p $(dir $@); echo " AS   $@"; $(GNU)-gcc $(COPS) -c $< -o $@

# C_FILES = $(shell find $(SRC_DIR) -name "*.c")
ASM_FILES = $(shell find $(SRC_DIR) -name "*.S")
# OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%_s.o)

##############
#  link objects
##############

yonex.bin: $(LINKER_DIR)/linker.ld $(OBJ_FILES)
	$(GNU)-ld -T $(LINKER_DIR)/linker.ld -o $(BUILD_DIR)/yonex.elf  $(OBJ_FILES) -Map $(BUILD_DIR)/yonex.map; echo " LD $(BUILD_DIR)/yonex.elf"
	$(GNU)-objcopy $(BUILD_DIR)/yonex.elf -O binary $(BUILD_DIR)/yonex.bin; echo " OBJCOPY yonex.bin"
	$(GNU)-objdump -d -S $(BUILD_DIR)/yonex.elf > $(BUILD_DIR)/yonex.txt

##############
#  run qemu
##############
QEMU_FLAGS  += -nographic -machine virt -m 128M 
QEMU_BIOS = -bios $(BUILD_DIR)/yonex.bin
run: all
	qemu-system-riscv64 $(QEMU_FLAGS) $(QEMU_BIOS)
gdb: all
	qemu-system-riscv64 $(QEMU_FLAGS) $(QEMU_BIOS) -S -s
