all: app

app: main.o thumblator.o
	g++ build/main.o build/thumblator.o -o bin/thumblator

main.o: src/main.cpp
	g++ -c src/main.cpp -Iinc -o build/main.o

thumblator.o: src/thumblator.cpp
	g++ -c src/thumblator.cpp -Iinc -o build/thumblator.o

clean:
	rm build/*.o bin/thumblator

