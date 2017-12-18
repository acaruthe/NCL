#!/bin/bash

source /glade/u/apps/opt/lmod/4.2.1/init/bash
module load  nco/4.5.5

#############################################
#
# concatonate/average the daily files into monthly files
ncra wrfout_d02_1996-05* 1996_05.nc


ncra wrfout_d02_1996-06* 1996_06.nc


ncra wrfout_d02_1996-07* 1996_07.nc


ncra wrfout_d02_1996-08* 1996_08.nc


###############################################
#
# concatonate the montly files into 1 seasonal file 
ncrcat 1996_* 1996.nc

##################################################
#
# remove the extra daily files 

rm wrfout_d01_1996*
rm wrfout_d02_1996* 



