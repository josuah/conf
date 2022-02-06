#!/bin/sh -e
# add an image on the selected position of a document

[ $# != 4 ] && exec echo usage: ${0##*/} signature.jpg xpos ypos document.pdf

signature=$1 x=$2 y=$3 file=$4

read w h <<EOF
$(identify "$signature" | awk '{ split($3, a, "x"); print int(a[1]), int(a[2] * 4) }')
EOF

gs -sDEVICE=pdfwrite -sOutputFile="${file%.pdf}.signed.pdf" -dPDFSETTINGS=/prepress - "$file" <<EOF

<<
/EndPage {
	2 eq { pop false } {
		gsave

		$x $y translate		% set lower left of image at ($x, $y)
		$w $h scale		% size of rendered image
		$w			% number of columns per row
		$h			% number of rows
		8			% bits per color channel (1, 2, 4, or 8)
		[$w 0 0 -$h 0 $h]	% transform array... maps unit square to pixel
		($signature) (r) file /DCTDecode filter
					% opens the file and filters the image data
		false			% pull channels from separate sources
		3			% 3 color channels (RGB)
		colorimage

		grestore
		true
	} ifelse
} bind
>> setpagedevice

EOF

exec mupdf "${file%.pdf}.signed.pdf"
