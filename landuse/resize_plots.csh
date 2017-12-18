#!/bin/csh

######
#
# This script will resize some images!
#
#############################

module load ImageMagick/6.9.2

cd ../plots/

#set month = ("presettle" "dustbowl" "modern")

#foreach month_string ($month)

	convert landuse.png -trim a.png
	convert a.png -bordercolor White -border 10 landuse.png
	



rm a.png

#!/bin/csh
