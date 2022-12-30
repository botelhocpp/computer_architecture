all: main taylorseries
	@gcc -no-pie -m64 build/main.o build/taylorseries.o -o bin/taylorseries
main:
	@nasm -Iinc -f elf64 src/main.asm -o build/main.o
taylorseries:
	@nasm -f elf64 src/taylorseries.asm -o build/taylorseries.o
clean:
	@rm bin/* build/*