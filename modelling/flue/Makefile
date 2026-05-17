
BUILD=build/
SCAD=$(shell find ./ -name "*.scad")
STL=$(SCAD:%.scad=$(BUILD)/%.stl)

.PHONY: all clean

all: $(BUILD) $(STL)

$(BUILD): 
	mkdir -p $(BUILD)

$(BUILD)/flue-middle.stl: flue-middle.scad  
	openscad -o $@ $<  
	cp flue-lower.scad $(BUILD)
	for i in $$(seq 5 5 15) ; do \
		sed 's/INCLUDE_NOTCHES = false/INCLUDE_NOTCHES = true' flue-middle.scad > $(BUILD)/flue-middle-$${i}.scad ; \
		sed 's/NOTCH_COUNT = 0/NOTCH_COUNT = \$${i}' config.scad > $(BUILD)/config.scad ; \
	done
	
$(BUILD)/%.stl: %.scad
	- openscad -o $@ $<  

clean:
	rm -rf $(BUILD)
