all: app

app: main.o copycat.o
	@g++ -g -O0 -Wall build/main.o build/copycat.o -o bin/copycat

main.o: src/main.s
	@g++ -g -O0 -Wall -c src/main.s -Iinc -o build/main.o

copycat.o: src/copycat.s
	@g++ -g -O0 -Wall -c src/copycat.s -Iinc -o build/copycat.o

clean:
	@rm build/*.o bin/copycat

