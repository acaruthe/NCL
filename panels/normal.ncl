
;Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "./WRFUserARW.ncl"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BEFORE INCLUDING DUST OR 1920S, COPY AND PASTE EVERYTHING AND MAKE TWO FIGURES FROM THIS SCRIPT
; YOU DONT NEED THREE SCRIPTS TO MAKE THIS FIGURE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.
;  a = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/BL_data/wrfout_d02_all.nc","r")

 a1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/1920s.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

  adust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/dustbowl.nc","r")

  amodern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc","r")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(amodern,"times", -1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        


  temp_1920s_k = wrf_user_getvar(a1920s, "T2", -1) ;
        temp_1920s_raw = temp_1920s_k - 273.16
        wrf_smooth_2d(temp_1920s_raw, 5)

   temp_pre_k = wrf_user_getvar(apre, "T2", -1) ;
        temp_pre_raw = temp_pre_k - 273.16
        wrf_smooth_2d(temp_pre_raw, 5)


   temp_dust_k = wrf_user_getvar(adust, "T2", -1) ;
        temp_dust_raw = temp_dust_k - 273.16
        wrf_smooth_2d(temp_dust_raw, 5)

   temp_modern_k = wrf_user_getvar(amodern, "T2", -1) ;
        temp_modern_raw = temp_modern_k - 273.16
        wrf_smooth_2d(temp_modern_raw, 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;averages!


mon = 0

 temp_modern = dim_avg_n(temp_modern_raw(mon::4,:,:), 0)
 
 temp_pre = dim_avg_n(temp_pre_raw(mon::4,:,:), 0)

diffr = temp_modern - temp_pre

;print(dimsizes(temp_modern))

normal = new(172800, float)

do j = 1,384
	do k = 1,450
		normal((j-1)*(k-1)) = diffr(j-1,k-1) 
	end do 
end do 
	
print(dimsizes(normal))

y = ispan(0,172799,1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; create the difference between modern and presettle 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/normal")

 res                   = True                     ; plot mods desired
  res@gsnMaximize       = True                     ; maximize plot
  res@tiMainString      = "Scatter Plot"           ; add title
  res@xyMarkLineMode    = "Markers"                ; choose to use markers
  res@xyMarkers         =  16                      ; choose type of marker  
  res@xyMarkerColor     = "NavyBlue"               ; Marker color
  res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01)

  plot  = gsn_csm_xy (wks,normal,y,res)                    ; create plot

end
