#!/bin/bash

source /glade/u/apps/opt/lmod/4.2.1/init/bash
module load  nco/4.5.5

######################################################################
set iyear = '1997' #set the year 

############################################################################
# download the data from hsi and unzip the file
#
#
htar -xv -m -f /home/acaruth/presettle/${iyear}/presettle_${iyear}_05.tar 

htar -xv -m -f /home/acaruth/presettle/${iyear}/presettle_${iyear}_06.tar

htar -xv -m -f /home/acaruth/presettle/${iyear}/presettle_${iyear}_07.tar

htar -xv -m -f /home/acaruth/presettle/${iyear}/presettle_${iyear}_08.tar

############################################################################
#
# concatonate/average the daily files into monthly files 
ncra wrfout_d02_${iyear}-05* ${iyear}_05.nc


ncra wrfout_d02_${iyear}-06* ${iyear}_06.nc


ncra wrfout_d02_${iyear}-07* ${iyear}_07.nc


ncra wrfout_d02_${iyear}-08* ${iyear}_08.nc


###########################################################################
#
# concatonate into the seasonal file 
ncrcat ${iyear}_* ${iyear}.nc

#############################################################################
#
# remove all excess files 

rm wrfout_d01_${iyear}*
rm wrfout_d02_${iyear}* 



