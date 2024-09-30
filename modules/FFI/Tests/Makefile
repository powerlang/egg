
CFLAGS = -Wall -fPIC
LDFLAGS = -shared

SRC = test.c
LIBRARY = libtest.so


all: $(LIBRARY)

$(LIBRARY): $(SRC)
	$(CC) $(CFLAGS) -o $@ $(SRC) $(LDFLAGS)

clean:
	rm -f $(LIBRARY)

