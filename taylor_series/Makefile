all: main taylorseries math
	@gcc -no-pie -m64 build/main.o build/taylorseries.o build/math.o -o bin/taylorseries

main:
	@nasm -Iinc -f elf64 src/main.asm -o build/main.o

taylorseries:
	@nasm -Iinc -f elf64 src/taylorseries.asm -o build/taylorseries.o

math:
	@nasm -Iinc -f elf64 src/math.asm -o build/math.o

clean:
	@rm bin/* build/*