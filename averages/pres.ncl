
;Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "./WRFUserARW.ncl"

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


  pres_1920s_raw = wrf_user_getvar(a1920s, "slp", -1) ;
        wrf_smooth_2d(pres_1920s_raw, 9)

   pres_pre_raw = wrf_user_getvar(apre, "slp", -1) ;
   wrf_smooth_2d(pres_pre_raw, 9)

  pres_dust_raw = wrf_user_getvar(adust, "slp", -1) ;
        wrf_smooth_2d(pres_dust_raw, 9)

   pres_modern_raw = wrf_user_getvar(amodern, "slp", -1) ;
   wrf_smooth_2d(pres_modern_raw, 9)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;averages

m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)
do i = 0,3

mon = m(i)
month = month_string(i,:)



pres_modern = dim_avg_n(pres_modern_raw(mon::4,:,:), 0)

pres_pre = dim_avg_n(pres_pre_raw(mon::4,:,:), 0)

pres_dust = dim_avg_n(pres_dust_raw(mon::4,:,:), 0)

pres_1920s = dim_avg_n(pres_1920s_raw(mon::5,:,:), 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - presettlement
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_pres_"+month)
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True

mpGridAndLimbOn= True


mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
   mpres@mpGridLineColor        = "transparent"
   mpres@mpLimbLineColor        = "transparent"
   mpres@mpPerimLineColor       = "transparent"
  mpres@mpGeophysicalLineThicknessF = 2
  mpres@mpUSStateLineThicknessF = 2
  mpres@mpNationalLineThicknessF    = 2

 res@NoHeaderFooter = True

pltres@NoTitles = True
mpres@tiMainString = "Mean " +month+" Surface Pressure Difference (hPa) ~C~~Z75~Modern-Pre-settlement"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = pres_modern - pres_pre


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
	opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-1.8,1.8, 0.2/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS                                       
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)


diffr = 0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - dust
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_pres_"+month)
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True

mpGridAndLimbOn= True


mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
   mpres@mpGridLineColor        = "transparent"
   mpres@mpLimbLineColor        = "transparent"
   mpres@mpPerimLineColor       = "transparent"
  mpres@mpGeophysicalLineThicknessF = 2
  mpres@mpUSStateLineThicknessF = 2
  mpres@mpNationalLineThicknessF    = 2

 res@NoHeaderFooter = True

pltres@NoTitles = True
mpres@tiMainString = "Mean " +month+" Surface Pressure Difference (hPa) ~C~~Z75~Modern-Dust Bowl"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = pres_modern - pres_dust


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-1.8,1.8, 0.2/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

diffr = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - presettlement
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_pres_"+month)
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True

mpGridAndLimbOn= True


mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
   mpres@mpGridLineColor        = "transparent"
   mpres@mpLimbLineColor        = "transparent"
   mpres@mpPerimLineColor       = "transparent"
  mpres@mpGeophysicalLineThicknessF = 2
  mpres@mpUSStateLineThicknessF = 2
  mpres@mpNationalLineThicknessF    = 2

 res@NoHeaderFooter = True

pltres@NoTitles = True
mpres@tiMainString = "Mean " +month+" Surface Pressure Difference (hPa) ~C~~Z75~Modern-1920s"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = pres_modern - pres_1920s


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-1.8,1.8, 0.2/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end do 
end
