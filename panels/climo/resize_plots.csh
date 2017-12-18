#!/bin/csh

######
#
# This script will resize some images!
#
#############################

module load ImageMagick/6.9.2

cd ../../plots/


set var = ("vwind")

#set case = ("case1_pre" "case2_dust" "case3_1920s")


	
		convert modern_avg_{$var}.png -trim a.png
		convert a.png -bordercolor White -border 10 modern_avg_{$var}.png

		rm a.png

		




#!/bin/csh
