file=test.s
outputFile: a.out
	./a.out $(file)

a.out: assembler.cpp
	g++ assembler.cpp

clean:
	rm -f a.out