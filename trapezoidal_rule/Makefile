all: main polynomial math trapezoidal
	@gcc -no-pie -m64 build/main.o build/polynomial.o build/math.o build/trapezoidal.o -o bin/trapezoidal

main:
	@nasm -Iinc -f elf64 src/main.asm -o build/main.o

polynomial:
	@nasm -Iinc -f elf64 src/polynomial.asm -o build/polynomial.o

trapezoidal:
	@nasm -Iinc -f elf64 src/trapezoidal.asm -o build/trapezoidal.o

math:
	@nasm -Iinc -f elf64 src/math.asm -o build/math.o

clean:
	@rm bin/* build/*