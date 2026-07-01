# =============================================================================
# Makefile - BIT 4220 Assembly Programming Group Work
# Builds all three programs: hello, data, alu
# Usage:
#   make          -> build all
#   make hello    -> build hello only
#   make data     -> build data only
#   make alu      -> build alu only
#   make run      -> build and run all
#   make clean    -> remove object files and binaries
# =============================================================================

NASM    = nasm
LD      = ld
FLAGS   = -f elf64

.PHONY: all clean run hello data alu

all: hello data alu

# ---- hello world ----
hello: hello.o
	$(LD) hello.o -o hello

hello.o: hello.asm
	$(NASM) $(FLAGS) hello.asm -o hello.o

# ---- data representation ----
data: data.o
	$(LD) data.o -o data

data.o: data.asm
	$(NASM) $(FLAGS) data.asm -o data.o

# ---- ALU simulator ----
alu: alu.o
	$(LD) alu.o -o alu

alu.o: alu.asm
	$(NASM) $(FLAGS) alu.asm -o alu.o

# ---- run all ----
run: all
	@echo "--- Running hello ---"
	./hello
	@echo ""
	@echo "--- Running data ---"
	./data
	@echo ""
	@echo "--- Running alu (interactive) ---"
	./alu

# ---- clean ----
clean:
	rm -f *.o hello data alu
