# Target MCU
MCU = stm32f401ret6

# Toolchain
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# Base Directory
BASE_DIR = C:/Users/bikas/Desktop/aditya

# Directories
CORE_SRC_DIR = $(BASE_DIR)/Core/Src
CORE_INC_DIR = $(BASE_DIR)/Core/Inc
CMSIS_DIR = $(BASE_DIR)/Drivers/CMSIS
HAL_SRC_DIR = $(BASE_DIR)/Drivers/STM32F4xx_HAL_Driver/Src
HAL_INC_DIR = $(BASE_DIR)/Drivers/STM32F4xx_HAL_Driver/Inc

# Linker script path
LINKER_SCRIPT = $(BASE_DIR)/STM32F401RETX_FLASH.ld

# Source files
SRC = $(wildcard $(CORE_SRC_DIR)/*.c) \
      $(wildcard $(HAL_SRC_DIR)/*.c)

# Object files
OBJS = $(SRC:.c=.o)

# Include directories
INCLUDES = -I$(CORE_INC_DIR) \
           -I$(CMSIS_DIR)/Include \
           -I$(CMSIS_DIR)/Device/ST/STM32F4xx/Include \
           -I$(HAL_INC_DIR)

# Compiler flags
CFLAGS = -mcpu=cortex-m4 -mthumb -O2 -Wall $(INCLUDES) -DUSE_HAL_DRIVER -DSTM32F401xE -MMD -MP
LDFLAGS = -T$(LINKER_SCRIPT) -mthumb -mcpu=cortex-m4 -nostartfiles

# Output file
TARGET = main

# Rules
.PHONY: all clean

all: $(TARGET).bin

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $^ $@
	$(SIZE) $^

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Compile source files into object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	del /f $(subst /,\,$(OBJS)) $(subst /,\,$(TARGET).elf) $(subst /,\,$(TARGET).bin) $(subst /,\,$(OBJS:.o=.d))

# Include dependency files
-include $(OBJS:.o=.d)
