NPROC=$(shell nproc --all)

.PHONY: all run

all: 
	cmake -B build/ -DCMAKE_EXPORT_COMPILE_COMMANDS=On
	cmake --build build/ --parallel $(NPROC)

run: all
	./build/software

clean: 
	cmake --build build/ -- clean
