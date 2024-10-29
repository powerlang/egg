
CFLAGS = -Wall -fPIC
LDFLAGS = -shared

SRC = filesystem.cpp
LIBRARY = libfilesystem.so


all: $(LIBRARY)

$(LIBRARY): $(SRC)
	$(CC) $(CFLAGS) -o $@ $(SRC) $(LDFLAGS)

clean:
	rm -f $(LIBRARY)

