
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
		f="$(BUILD)/flue-middle-$${i}.scad" ; \
		fo="$(BUILD)/flue-middle-$${i}.stl" ; \
		sed 's/INCLUDE_NOTCHES = false/INCLUDE_NOTCHES = true/g' flue-middle.scad > $${f} ; \
		sed "s/NOTCH_COUNT = 0/NOTCH_COUNT = $${i}/g" config.scad > $(BUILD)/config.scad ; \
		openscad -o $${fo} $${f} ; \
	done
	
# $(BUILD)/%.stl: %.scad
	# - openscad -o $@ $<  

clean:
	rm -rf $(BUILD)
