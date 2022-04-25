CFLAGS+=-Wall -Werror -I./libaio-libaio-0.3.113/src -g -O2
LIBAIO?=./libaio-libaio-0.3.113/src/libaio.a
all: $(SRCS)
	$(CC) $(CFLAGS) main.c -o libaio-read-write-xfuzz $(LIBAIO) -lpthread -lrt
clean:
	rm -f libaio-read-write-xfuzz 
