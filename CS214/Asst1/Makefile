memgrind: memgrind.o mymalloc.o
	gcc memgrind.o mymalloc.o -o memgrind

memgrind.o: memgrind.c mymalloc.h
	gcc -c memgrind.c

mymalloc.o: mymalloc.c mymalloc.h
	gcc -c mymalloc.c

clean:
	rm -f memgrind *.o
