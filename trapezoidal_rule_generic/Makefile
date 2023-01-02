sin: mainSin math polynomial trapezoidal taylorseries
	@gcc -no-pie -m64 build/mainSin.o build/polynomial.o build/math.o build/trapezoidal.o build/taylorseries.o -o bin/trapezoidal

poly: mainPolynomial polynomial math trapezoidal
	@gcc -no-pie -m64 build/mainPolynomial.o build/polynomial.o build/math.o build/trapezoidal.o -o bin/trapezoidal

mainPolynomial:
	@nasm -Iinc -f elf64 src/mainPolynomial.asm -o build/mainPolynomial.o

mainSin:
	@nasm -Iinc -f elf64 src/mainSin.asm -o build/mainSin.o

polynomial:
	@nasm -Iinc -f elf64 src/polynomial.asm -o build/polynomial.o

trapezoidal:
	@nasm -Iinc -f elf64 src/trapezoidal.asm -o build/trapezoidal.o

taylorseries:
	@nasm -Iinc -f elf64 src/taylorseries.asm -o build/taylorseries.o

math:
	@nasm -Iinc -f elf64 src/math.asm -o build/math.o

clean:
	@rm bin/* build/*