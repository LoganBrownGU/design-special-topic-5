
BUILD=build/
SCAD=$(shell find ./ -name "*.scad")
STL=$(SCAD:%.scad=$(BUILD)/%.stl)

.PHONY: all clean

all: $(BUILD) $(STL)

$(BUILD): 
	mkdir -p $(BUILD)

$(BUILD)/%.stl: %.scad
	- openscad -o $@ $<  

clean:
	rm -rf $(BUILD)
