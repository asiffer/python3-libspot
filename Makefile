# makefile python3-libspot
VERSION = 1.0
DESTDIR = /usr/lib/python3/dist-packages

CURDIR = $(realpath .)
PREFIX = /usr
LIBSPOT_HEADERS_DIR = $(PREFIX)/include/libspot
LIBSPOT_LIBRARY_DIR = $(PREFIX)/lib


# python3 header dir (Python.h file)
PYTHON_HEADER_DIR = $(shell find /usr/include/python3* -name Python.h | xargs dirname | tail -1)

CC = @g++
CXXFLAGS = -std=c++14 -fPIC -shared -Wall -pedantic -I$(PYTHON_HEADER_DIR) -I$(LIBSPOT_HEADERS_DIR)



all: _pyspot.so

# doc
#docs.i:
#	@echo "Checking the docs directory (./doc)"
#	mkdir -p ./docs
#	@doxygen doxygen.conf
#	@python3 doxy2swig.py ./docs/xml/index.xml ./docs.i

# wrapper
pyspot_wrap.cxx: pyspot.i
	@echo
	@echo "==== python3-libspot ===="
	@echo
	@echo "Creating the python wrapper" $@
	@swig -c++ -python -I$(LIBSPOT_HEADERS_DIR) pyspot.i


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
