build:
	nasm -f elf src/lampCounter.asm -o obj/lampCounter.o
	gcc -m32 obj/lampCounter.o -o bin/lampCounter

clean:
	rm obj/lampCounter.o bin/lampCounter
