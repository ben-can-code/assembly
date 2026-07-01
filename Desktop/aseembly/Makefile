# =============================================================================
# Root Makefile - BIT 4220 Assembly Programming Group Work
# Delegates to task1/ and task3/ sub-makefiles
#
# Usage:
#   make          build all tasks
#   make task1    build task1 programs only
#   make task3    build task3 ALU only
#   make clean    clean all tasks
# =============================================================================

.PHONY: all task1 task3 clean

all: task1 task3

task1:
	$(MAKE) -C task1

task3:
	$(MAKE) -C task3

clean:
	$(MAKE) -C task1 clean
	$(MAKE) -C task3 clean
