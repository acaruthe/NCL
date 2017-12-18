
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        


  dew_1920s_raw = wrf_user_getvar(a1920s, "td2", -1) ;
      wrf_smooth_2d(dew_1920s_raw, 5)

   dew_pre_raw = wrf_user_getvar(apre, "td2", -1) ;
        wrf_smooth_2d(dew_pre_raw, 5)

   dew_dust_raw = wrf_user_getvar(adust, "td2", -1) ;
        wrf_smooth_2d(dew_dust_raw, 5)

   dew_modern_raw = wrf_user_getvar(amodern, "td2", -1) ;
        wrf_smooth_2d(dew_modern_raw, 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;averages


m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)
do i = 0,3

mon = m(i)
month = month_string(i,:)

dew_pre = dim_avg_n(dew_pre_raw(mon::4,:,:), 0)

dew_modern = dim_avg_n(dew_modern_raw(mon::4,:,:), 0)

dew_dust = dim_avg_n(dew_dust_raw(mon::4,:,:), 0)

dew_1920s = dim_avg_n(dew_1920s_raw(mon::5,:,:), 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; differences modern - presettlement
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_dew_"+month)

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

mpres@tiMainString = "Mean " +month+" Dewpoint Difference (C) ~C~~Z75~Modern-Pre-settlement"

  mpres@tiMainFontHeightF = 0.015

  mpres@tmXBLabelFontHeightF = 0.014

  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; differences 
diffr = dew_modern - dew_pre

   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Dew Point (C)"
        ;opts@SubFieldTitle = "Modern - Pre-settlement"
	opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-3.,3., 0.5/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)



    ; MAKE PLOTS                                       
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)


diffr = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;differences modern - dust bowl
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_dew_"+month)

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

mpres@tiMainString = "Mean " +month+" Dewpoint Difference (C) ~C~~Z75~Modern-Dust Bowl"

  mpres@tiMainFontHeightF = 0.015

  mpres@tmXBLabelFontHeightF = 0.014

  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; differences
diffr = dew_modern - dew_dust

   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Dew Point (C)"
	;opts@SubFieldTitle = "Modern - Dust Bowl"
	opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-3.,3., 0.5/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)



    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

diffr = 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; differences modern - 1920s
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_dew_"+month)

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

mpres@tiMainString = "Mean " +month+" Dewpoint Difference (C) ~C~~Z75~Modern-1920s"
  mpres@tiMainFontHeightF = 0.015

  mpres@tmXBLabelFontHeightF = 0.014

  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; differences
diffr = dew_modern - dew_1920s

   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Dew Point (C)"
        ;opts@SubFieldTitle = "Modern - 1920s"
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-3.,3., 0.5/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)



    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

diffr = 0


end do
end
