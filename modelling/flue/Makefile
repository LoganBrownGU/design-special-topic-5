SHELL=bash
	
BUILD=build/
SCAD=$(shell ls ./*.scad)
STL=$(SCAD:%.scad=$(BUILD)/%.stl)
PDF=$(SCAD:%.scad=$(BUILD)/%.pdf)
PDF_EXPORT_OPTS=paper-size=a6 show-grid=false show-scale=message=false show-scale=false
PDF_ARGS=$(foreach I,$(PDF_EXPORT_OPTS),-O pdf-export/$I)

.PHONY: all clean pdf

all: $(BUILD) $(STL)

pdf: $(BUILD) $(PDF)
	

$(BUILD): 
	mkdir -p $(BUILD)

$(BUILD)/flue-middle.stl: flue-middle.scad  
	openscad -o $@ $<  

 $(BUILD)/%.stl: %.scad
	- openscad --backend Manifold -o $@ $<  

	if [[ $< == "flue-middle.scad" ]] ; then \
    	cp flue-lower.scad $(BUILD) ; \
    	for i in $$(seq 3 3 9) ; do \
    		f="$(BUILD)/flue-middle-$${i}.scad" ; \
    		fo="$(BUILD)/flue-middle-$${i}.stl" ; \
    		sed 's/INCLUDE_NOTCHES = false/INCLUDE_NOTCHES = true/g' flue-middle.scad > $${f} ; \
    		sed "s/NOTCH_COUNT = 0/NOTCH_COUNT = $${i}/g" config.scad > $(BUILD)/config.scad ; \
    		openscad -o $${fo} $${f} ; \
    	done ; \
    fi
		

$(BUILD)/%.pdf: %.scad
	- openscad --backend Manifold $(PDF_ARGS) -o $@ $< 
	- pdfcrop $@ $@
	

clean:
	rm -rf $(BUILD)
