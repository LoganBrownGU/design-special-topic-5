
PDF_EXPORT_OPTS=paper-size=a3 show-grid=false show-scale=false
PDF_ARGS=$(foreach I,$(PDF_EXPORT_OPTS),-O export-pdf/$I)

OUT_DIR=pdfs/
SCAD=$(shell find ./ -maxdepth 2 -type f -name "*2d.scad" -not -path "./$(OUT_DIR)/*")
PDF=$(SCAD:%.scad=$(OUT_DIR)/%.pdf)

.PHONY: all prep cleanup clean show

all: prep $(PDF) 
	@echo $(SCAD) 
	@echo $(PDF)

$(OUT_DIR)/%.pdf: %.scad
	mkdir -p $(dir $@) 
	openscad $(PDF_ARGS) -o $@ $<
	pdfcrop $@ $@ 
	

prep: 
	mkdir -p $(OUT_DIR)

show: 
	evince $(PDF)

cleanup: 

clean:
	rm -rf $(OUT_DIR)
