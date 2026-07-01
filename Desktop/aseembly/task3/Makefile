# =============================================================================
# Makefile - Task 3: Mini ALU Simulator
# BIT 4220 Assembly Programming
#
# Usage:
#   make          build alu
#   make run      build and run alu (interactive)
#   make clean    remove object file and binary
# =============================================================================

NASM   = nasm
LD     = ld
FLAGS  = -f elf64

.PHONY: all run clean

all: alu

alu: alu.o
	$(LD) alu.o -o alu

alu.o: alu.asm
	$(NASM) $(FLAGS) alu.asm -o alu.o

run: all
	./alu

clean:
	rm -f alu.o alu
