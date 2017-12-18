#!/bin/csh

######
#
# This script will resize some images!
#
#############################

module load ImageMagick/6.9.2

cd ../plots/

set month = ("presettle" "dustbowl" "modern")

foreach month_string ($month)

	convert {$month_string}_landuse_notext.png -trim a.png
	convert a.png -bordercolor White -border 10 {$month_string}_landuse.png
	
	echo $month_string


end

convert 1920s_landuse_notext.png -trim a.png
convert a.png -bordercolor White -border 10 1920s_landuse.png

rm a.png

#!/bin/csh
