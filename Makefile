# makefile python3-libspot
VERSION = 1.0
DESTDIR = /usr/lib/python3/dist-packages

CURDIR = $(realpath .)
PREFIX = /usr
HEADERS_DIR = $(PREFIX)/include/libspot
LIBRARY_DIR = $(PREFIX)/lib

CC = @g++
CXXFLAGS = -std=c++14 -fPIC -shared -Wall -pedantic -I/usr/include/python3.6m/ -I$(HEADERS_DIR)


all: _pyspot.so

# doc
docs.i:
	@echo "Checking the docs directory (./doc)"
	mkdir -p ./docs
	@doxygen doxygen.conf
	@python3 doxy2swig.py ./docs/xml/index.xml ./docs.i

# wrapper
pyspot_wrap.cxx: docs.i pyspot.i
	@echo
	@echo "==== python3-libspot ===="
	@echo
	@echo "Creating the python wrapper" $@
	@swig -c++ -python -I$(HEADERS_DIR) pyspot.i


# shared libraries
_pyspot.so: pyspot_wrap.cxx
	@echo "Building the shared library" $@
	$(CC) $(CXXFLAGS) -o $@ $^ -lspot 


install:
	@echo "Checking the installation directory ("$(DESTDIR)")"
	@mkdir -p $(DESTDIR)
	@echo "Installing pyspot.py"
	@install pyspot.py $(DESTDIR)
	@echo "Installing _pyspot.so"
	@install _pyspot.so $(DESTDIR)


clean:
	rm -f *.so *wrap.cxx pyspot.py docs.i
	rm -Rf ./docs
