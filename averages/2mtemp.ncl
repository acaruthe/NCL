
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


m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)
do i = 0,3

mon = m(i)
month = month_string(i,:)


 temp_modern = dim_avg_n(temp_modern_raw(mon::4,:,:), 0)
 
 temp_pre = dim_avg_n(temp_pre_raw(mon::4,:,:), 0)

 temp_dust = dim_avg_n(temp_dust_raw(mon::4,:,:), 0)

 temp_1920s = dim_avg_n(temp_1920s_raw(mon::5,:,:), 0)

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
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_2temp_"+month)

 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True

  pltres@noTitles = True
  
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
mpres@tiMainString = "Mean " +month+" Temperature Difference (C) ~C~~Z75~Modern-Pre-settlement"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = temp_modern - temp_pre


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Temperature (C) "
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
; difference for modern - dust 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_2temp_"+month)

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
mpres@tiMainString = "Mean " +month+" Temperature Difference (C) ~C~~Z75~Modern-Dust Bowl"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = temp_modern - temp_dust


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Temperature (C) "
        ;opts@SubFieldTitle = "Modern - Dust Bowl"
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-3.,3., 0.5/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)



    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

diffr = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; difference for modern - 1920s
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_2temp_"+month)

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
mpres@tiMainString = "Mean " +month+" Temperature Difference (C) ~C~~Z75~Modern-1920s"

  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = temp_modern - temp_1920s


   ; Plotting options for boundary height
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean Temperature (C) "
        ;opts@SubFieldTitle = "Modern - 1920s"
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-3.,3., 0.5/)
        contour_skintemp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)



    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_skintemp/), pltres, mpres)

end do 

end
