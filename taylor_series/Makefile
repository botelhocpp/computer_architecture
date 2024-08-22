PROG := bin/taylorseries
AS := nasm
AFLAGS := -f elf64 -g -Iinc
LD := gcc
LFLAGS := -m64 -no-pie

.PHONY: clean

all: ${PROG}

${PROG}: build/main.o build/math.o build/taylorseries.o
	@${LD} ${LFLAGS} $^ -o $@

build/%.o: src/%.asm
	@${AS} ${AFLAGS} $< -o $@

clean: 
	@rm -rf bin/* build/*
