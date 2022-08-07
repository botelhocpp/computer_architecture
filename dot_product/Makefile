all: mainASM dotproductASM sysvaultASM
	@gcc -fno-pie -no-pie -m64 build/mainASM.o build/dotproductASM.o build/sysvaultASM.o -o bin/dotproduct
mainASM:
	@nasm -Iinc -f elf64 src/main.asm -o build/mainASM.o
dotproductASM:
	@nasm -Iinc -f elf64 src/dotproduct.asm -o build/dotproductASM.o
sysvaultASM:
	@nasm -Iinc -f elf64 src/sysvault.asm -o build/sysvaultASM.o
clean:
	@rm bin/* build/*