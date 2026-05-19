#!/usr/bin/env bash 


if [[ $1 == "clean" ]] ; then 
	rm -rf pdfs/*
	exit 0 
fi

DEFAULT_ARGS=(show-grid=true show-scale-message=false grid-size=1)

export_pdf() {
	input=$1
	output="pdfs/$2"
	shift ; shift

	format_args=()
	for a in $@ ; do 
		format_args+=(-O) 
		format_args+=("export-pdf/$a")
	done

openscad ${format_args[*]} -o $output $input
	echo "openscad ${format_args[*]} -o $output $input"
	pdfcrop $output $output
}


# export_pdf flue/flue-upper-2d.scad flue-upper.pdf ${DEFAULT_ARGS[*]} paper-size=a5 orientation=landscape 
# export_pdf flue/flue-middle-2d.scad flue-middle.pdf ${DEFAULT_ARGS[*]} paper-size=a6 orientation=portrait
export_pdf flue/flue-lower-2d.scad flue-lower.pdf ${DEFAULT_ARGS[*]} paper-size=a5 orientation=portrait


