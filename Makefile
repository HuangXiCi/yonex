GNU ?= riscv64-unknown-elf
COPS += -save-temps=obj -g -O2 -Wall -fno-builtin -nostdlib -nostdinc -mcmodel=medany -mabi=ilp32 -march=rv32i -fno-PIE -fomit-frame-pointer -Isrc/include

BUILD_DIR = build
LINKER_DIR = linker

# Common support files linked into every program
COMMON_SRCS = src/uart.c src/utils/divsi3.c src/utils/mulsi3.c
COMMON_ASM = src/boot.S

all: main

# Pattern rules: compile src/%.c → build/%_c.o
$(BUILD_DIR)/%_c.o: src/%.c
	mkdir -p $(dir $@)
	echo " CC   $@"
	$(GNU)-gcc $(COPS) -c $< -o $@

$(BUILD_DIR)/%_s.o: src/%.S
	mkdir -p $(dir $@)
	echo " CC   $@"
	$(GNU)-gcc $(COPS) -c $< -o $@

# --- build_program macro: $(1)=name, $(2)=program-specific .c file ---
define build_program

$$(BUILD_DIR)/$(1).bin: $$(LINKER_DIR)/linker.ld $$(patsubst src/%.S,$$(BUILD_DIR)/%_s.o,$$(COMMON_ASM)) $$(patsubst src/%.c,$$(BUILD_DIR)/%_c.o,$(2) $$(COMMON_SRCS))
	$$(GNU)-ld -m elf32lriscv -T $$(LINKER_DIR)/linker.ld -o $$(BUILD_DIR)/$(1).elf $$(patsubst src/%.S,$$(BUILD_DIR)/%_s.o,$$(COMMON_ASM)) $$(patsubst src/%.c,$$(BUILD_DIR)/%_c.o,$(2) $$(COMMON_SRCS)) -Map $$(BUILD_DIR)/$(1).map
	echo " LD $$(BUILD_DIR)/$(1).elf"
	$$(GNU)-objcopy $$(BUILD_DIR)/$(1).elf -O binary $$(BUILD_DIR)/$(1).bin
	echo " OBJCOPY $(1).bin"
	$$(GNU)-objdump -d -S $$(BUILD_DIR)/$(1).elf > $$(BUILD_DIR)/$(1).txt

$$(BUILD_DIR)/$(1).hex: $$(BUILD_DIR)/$(1).bin
	od -t x4 -An -w4 -v $$(BUILD_DIR)/$(1).bin > $$(BUILD_DIR)/$(1).hex

$(1): $$(BUILD_DIR)/$(1).hex

endef

$(eval $(call build_program,main,src/main.c))
$(eval $(call build_program,2048,src/demo/2048.c))
$(eval $(call build_program,donut,src/demo/donut.c))
$(eval $(call build_program,hachimi,src/demo/hachimi.c))

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all main 2048 donut hachimi clean
