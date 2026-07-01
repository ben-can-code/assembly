# =============================================================================
# Makefile - Task 1: Assembly Environment & Data Representation Toolkit
# BIT 4220 Assembly Programming
#
# Programs:
#   hello               - hello world, syscall demo
#   data_representation - byte/word/dword, ASCII interpretation
#   endian              - little-endian, two's complement, binary/hex
#
# Usage:
#   make                build all three programs
#   make hello          build hello only
#   make data_rep       build data_representation only
#   make endian         build endian only
#   make run            build and run all
#   make inspect        run objdump on all object files
#   make clean          remove binaries and object files
# =============================================================================

NASM   = nasm
LD     = ld
FLAGS  = -f elf64

.PHONY: all hello data_rep endian run inspect clean

all: hello data_rep endian

# ---- hello world ----
hello: hello.o
	$(LD) hello.o -o hello

hello.o: hello.asm
	$(NASM) $(FLAGS) hello.asm -o hello.o

# ---- data representation ----
data_rep: data_representation.o
	$(LD) data_representation.o -o data_representation

data_representation.o: data_representation.asm
	$(NASM) $(FLAGS) data_representation.asm -o data_representation.o

# ---- endian / two's complement / binary ----
endian: endian.o
	$(LD) endian.o -o endian

endian.o: endian.asm
	$(NASM) $(FLAGS) endian.asm -o endian.o

# ---- run all ----
run: all
	@echo ""
	@echo "========== hello =========="
	./hello
	@echo ""
	@echo "========== data_representation =========="
	./data_representation
	@echo ""
	@echo "========== endian =========="
	./endian

# ---- inspect .data sections with objdump ----
inspect: all
	@echo ""
	@echo "=== objdump .data: data_representation.o ==="
	objdump -s -j .data data_representation.o
	@echo ""
	@echo "=== objdump .data: endian.o ==="
	objdump -s -j .data endian.o

# ---- clean ----
clean:
	rm -f *.o hello data_representation endian
