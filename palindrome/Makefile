C: mainC palindromeC
	@gcc -Wall build/mainC.o build/palindromeC.o -o bin/palindromeC
ASM: mainASM palindromeASM
	@gcc -no-pie -m64 build/mainASM.o build/palindromeASM.o -o bin/palindromeASM
mainC:
	@gcc -Wall -c src/main.c -Iinc -o build/mainC.o
mainASM:
	@nasm -Iinc -f elf64 src/main.asm -o build/mainASM.o
palindromeC:
	@gcc -Wall -c src/palindrome.c -Iinc -o build/palindromeC.o
palindromeASM:
	@nasm -f elf64 src/palindrome.asm -o build/palindromeASM.o
clean:
	@rm bin/* build/*