
;Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "./WRFUserARW.ncl"

begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.

  amodern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

 a1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/1920s.nc","r")
 
  adust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/dustbowl.nc","r") 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(amodern,"times", -1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        

   modern_flux_lh_raw = wrf_user_getvar(amodern,"HFX", -1) ;latent heat flux at the surface
	wrf_smooth_2d(modern_flux_lh_raw,9)

   pre_flux_lh_raw = wrf_user_getvar(apre, "HFX", -1)
	wrf_smooth_2d(pre_flux_lh_raw, 9) 
   
   dust_flux_lh_raw = wrf_user_getvar(adust, "HFX", -1)
	wrf_smooth_2d(dust_flux_lh_raw, 9)

  i1920s_flux_lh_raw = wrf_user_getvar(a1920s, "HFX", -1)
        wrf_smooth_2d(i1920s_flux_lh_raw, 9)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; averages



m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)
do i = 0,3

mon = m(i)
month = month_string(i,:)

modern_flux_lh = dim_avg_n(modern_flux_lh_raw(mon::4,:,:), 0)

pre_flux_lh = dim_avg_n(pre_flux_lh_raw(mon::4,:,:), 0)

dust_flux_lh = dim_avg_n(dust_flux_lh_raw(mon::4,:,:), 0)

i1920s_flux_lh = dim_avg_n(i1920s_flux_lh_raw(mon::5,:,:), 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - pre
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;   type = "pdf"
;  type = "ps"
; type = "ncgm"
  type = "png"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_sens_"+month)

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
mpres@tiMainString = "Mean " +month+" Sensible Heat Flux Difference (Wm^-2) ~C~~Z75~Modern-Pre-settlement"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = modern_flux_lh - pre_flux_lh

    ; Plotting options for T                
      opts = res                         
      opts@cnFillOn = True
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_lhflux = wrf_contour(amodern,wks,diffr,opts) 
      delete(opts)


    ; MAKE PLOTS                                       
      plot = wrf_map_overlays(amodern,wks,(/contour_lhflux/), pltres, mpres)


diffr = 0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - dust 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;   type = "pdf"
;  type = "ps"
; type = "ncgm"
  type = "png"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_sens_"+month)

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
mpres@tiMainString = "Mean " +month+" Sensible Heat Flux Difference (Wm^-2) ~C~~Z75~Modern-Dust Bowl"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = modern_flux_lh - dust_flux_lh


;plotting tting options for T
      opts = res
      opts@cnFillOn = True
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_lhflux = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_lhflux/), pltres, mpres)


diffr = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - 1920s
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;   type = "pdf"
;  type = "ps"
; type = "ncgm"
  type = "png"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_sens_"+month)

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
mpres@tiMainString = "Mean " +month+" Sensible Heat Flux Difference (Wm^-2) ~C~~Z75~Modern-1920s"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = modern_flux_lh - i1920s_flux_lh


;plotting tting options for T
      opts = res
      opts@cnFillOn = True
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_lhflux = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_lhflux/), pltres, mpres)


diffr = 0
 
end do 

end
