#!/bin/csh

######
#
# This script will resize some images!
#
#############################

module load ImageMagick/6.9.2

cd ../plots/


set var = ("sens")

set case = ("case1_pre" "case2_dust" "case3_1920s")

set i = 1

set month = ("May" "June" "July" "August")

foreach month_string ($month)

	foreach case_string ($case)
		echo $case_string
		cd {$case_string}
		convert avg_{$var}_{$month_string}.png -trim a.png
		convert a.png -bordercolor White -border 10 avg_{$var}_{$month_string}.png
	
		echo $month_string

		rm a.png

		cd ..

	end 
end


#!/bin/csh
