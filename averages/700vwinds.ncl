;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.
;   Interpolating to specified pressure levels

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.
;  a = addfile("../wrfout_d01_2000-01-24_12:00:00.nc","r")


  a1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/1920s.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

  adust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/dustbowl.nc","r")

  amodern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc","r")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(amodern,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;modern
    u_modern  = wrf_user_getvar(amodern,"ua",-1)        ; u averaged to mass points
    v_modern  = wrf_user_getvar(amodern,"va",-1)        ; v averaged to mass points
    p_modern  = wrf_user_getvar(amodern, "pressure",-1) ; pressure is our vertical coordinate
    z_modern  = wrf_user_getvar(amodern, "z",-1)        ; grid point height

;pressettle

    u_pre  = wrf_user_getvar(apre,"ua",-1)        ; u averaged to mass points
    v_pre  = wrf_user_getvar(apre,"va",-1)        ; v averaged to mass points
    p_pre  = wrf_user_getvar(apre, "pressure",-1) ; pressure is our vertical coordinate
    z_pre  = wrf_user_getvar(apre, "z",-1)        ; grid point height

;1920s

    u_1920s  = wrf_user_getvar(a1920s,"ua",-1)        ; u averaged to mass points
    v_1920s  = wrf_user_getvar(a1920s,"va",-1)        ; v averaged to mass points
    p_1920s  = wrf_user_getvar(a1920s, "pressure",-1) ; pressure is our vertical coordinate
    z_1920s  = wrf_user_getvar(a1920s, "z",-1)        ; grid point height

;dust 

    u_dust  = wrf_user_getvar(adust,"ua",-1)        ; u averaged to mass points
    v_dust  = wrf_user_getvar(adust,"va",-1)        ; v averaged to mass points
    p_dust  = wrf_user_getvar(adust, "pressure",-1) ; pressure is our vertical coordinate
    z_dust  = wrf_user_getvar(adust, "z",-1)        ; grid point height

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; interpolate data to pressure level 

pres= 700.00

     ; z_plane  = wrf_user_intrp3d( z,p,"h",pressure,0.,False)
     ; u_plane  = wrf_user_intrp3d( u_modern,p_modern,"h",pressure,0.,False)

      u_plane_modern  = wrf_user_intrp3d(v_modern,p_modern,"h",pres,0.,False)

      u_plane_pre = wrf_user_intrp3d(v_pre,p_pre,"h",pres,0.,False)

      u_plane_1920s = wrf_user_intrp3d(v_1920s,p_1920s,"h",pres,0.,False)

      u_plane_dust = wrf_user_intrp3d(v_dust,p_dust,"h",pres,0.,False)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)
do i = 0,3

mon = m(i)
month = month_string(i,:)

wind_modern = dim_avg_n(u_plane_modern(mon::4,:,:), 0)

wind_pre = dim_avg_n(u_plane_pre(mon::4,:,:), 0)

wind_1920s = dim_avg_n(u_plane_1920s(mon::5,:,:), 0)

wind_dust = dim_avg_n(u_plane_dust(mon::4,:,:), 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - presettle  
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_700Vwind_"+month)

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

 mpres@tiMainString = "Mean" +month+" 700hPa V-Component Wind Difference (m/s) ~C~~Z75~Modern-Pre-Settlement"
  mpres@tiMainFontHeightF = 0.015
  mpres@tmXBLabelFontHeightF = 0.014
  mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = wind_modern - wind_pre

      ; Plotting options for Wind Speed                
        opts = res                          
        opts@cnFillOn = True
	;opts@FieldTitle = "Mean 850mb U-component Winds (m/s)"	
	;opts@SubFieldTitle = "Modern - Pre-settlement"
	opts@gsnSpreadColorEnd = -3
        opts@ContourParameters = (/-2.0, 2.0, 0.2/)
	contour_spd = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_spd/), pltres, mpres)
    ; plot = wrf_map_overlays(a,wks,(/contour_td,vector/),pltres,mpres)

diffr = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern -  1920s
;       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_700Vwind_"+month)

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

 mpres@tiMainString = "Mean " +month+" 700hPa V-Component Wind Difference (m/s) ~C~~Z75~Modern-1920s"
 mpres@tiMainFontHeightF = 0.015
 mpres@tmXBLabelFontHeightF = 0.014
 mpres@tmYLLabelFontHeightF = 0.014


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diffr = wind_modern - wind_1920s  
 ; Plotting options for Wind Speed
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean 850mb U-component Winds (m/s)"
        ;opts@SubFieldTitle = "Modern - 1920s"
        opts@gsnSpreadColorEnd = -3
        opts@ContourParameters = (/-2.0, 2.0, 0.2/)
        contour_spd = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_spd/), pltres, mpres)
    ; plot = wrf_map_overlays(a,wks,(/contour_td,vector/),pltres,mpres)


diffr = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;modern -  dust
;       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_700Vwind_"+month)

 gsn_define_colormap(wks,"BlueWhiteOrangeRed")
      
; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True
  pltres@NoTitles = True 
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

 mpres@tiMainString = "Mean " +month+" 700hPa V-Component Wind Difference (m/s) ~C~~Z75~Modern-Dust Bowl"
 mpres@tiMainFontHeightF = 0.015
 mpres@tmXBLabelFontHeightF = 0.014
 mpres@tmYLLabelFontHeightF = 0.014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diffr = wind_modern - wind_dust  
; Plotting options for Wind Speed
        opts = res
        opts@cnFillOn = True
        ;opts@FieldTitle = "Mean 850mb V-component Winds (m/s)"
        ;opts@SubFieldTitle = "Modern - Dust Bowl"
        opts@gsnSpreadColorEnd = -3
        opts@ContourParameters = (/-2.0, 2.0, 0.2/)
        contour_spd = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


    ; MAKE PLOTS
      plot = wrf_map_overlays(amodern,wks,(/contour_spd/), pltres, mpres)
    ; plot = wrf_map_overlays(a,wks,(/contour_td,vector/),pltres,mpres)


end do 
end  
