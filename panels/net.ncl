
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

   lh_modern_raw = wrf_user_getvar(amodern,"LH", -1) ;latent heat flux at the surface
	wrf_smooth_2d(lh_modern_raw,7)

   lh_pre_raw = wrf_user_getvar(apre, "LH", -1)
	wrf_smooth_2d(lh_pre_raw, 7) 
   
   lh_dust_raw = wrf_user_getvar(adust, "LH", -1)
	wrf_smooth_2d(lh_dust_raw, 7)

  lh_1920s_raw = wrf_user_getvar(a1920s, "LH", -1)
        wrf_smooth_2d(lh_1920s_raw, 7)


   sens_modern_raw = wrf_user_getvar(amodern,"HFX", -1) ;latent heat flux at the surface
        wrf_smooth_2d(sens_modern_raw,7)

   sens_pre_raw = wrf_user_getvar(apre, "HFX", -1)
        wrf_smooth_2d(sens_pre_raw, 7)      

   sens_dust_raw = wrf_user_getvar(adust, "HFX", -1)
        wrf_smooth_2d(sens_dust_raw, 7)

  sens_1920s_raw = wrf_user_getvar(a1920s, "HFX", -1)
        wrf_smooth_2d(sens_1920s_raw, 7)


 grd_modern_raw = wrf_user_getvar(amodern,"GRDFLX", -1) ;latent heat flux at the surface
        wrf_smooth_2d(grd_modern_raw,7)

   grd_pre_raw = wrf_user_getvar(apre, "GRDFLX", -1)
        wrf_smooth_2d(grd_pre_raw, 7)      

   grd_dust_raw = wrf_user_getvar(adust, "GRDFLX", -1)
        wrf_smooth_2d(grd_dust_raw, 7)

  grd_1920s_raw = wrf_user_getvar(a1920s, "GRDFLX", -1)
        wrf_smooth_2d(grd_1920s_raw, 7)

 ;grd_modern = dim_avg_n(grd_modern_raw(0::4,:,:), 0)

  ;print(min(grd_modern(:,:)))
  ;print(max(grd_modern(:,:)))

   
 net_modern_raw = sens_modern_raw + lh_modern_raw - grd_modern_raw 

 net_pre_raw = sens_pre_raw + lh_pre_raw - grd_pre_raw

 net_1920s_raw = sens_1920s_raw + lh_1920s_raw - grd_1920s_raw

 net_dust_raw = sens_dust_raw + lh_dust_raw - grd_dust_raw



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
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_net")

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

pltres@PanelPlot = True      ; Indicate these plots are to be paneled.
res@NoHeaderFooter = True
pltres@NoTitles = True

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)


 flux_modern = dim_avg_n(net_modern_raw(mon::4,:,:), 0)

 flux_pre = dim_avg_n(net_pre_raw(mon::4,:,:), 0)

diffr = flux_modern - flux_pre

varx = variance(flux_pre)

vary = variance(flux_modern)

n = 8

std = sqrt((varx/n)+(vary/n))

    ; Plotting options for LH                
      opts = res                         
      opts@cnFillOn = True
      opts@lbLabelBarOn = False
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_flux = wrf_contour(amodern,wks,diffr,opts) 
      delete(opts)
; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnSmoothingOn = True
      opts@cnSmoothingDistanceF = 0.21
      opts@cnLineLabelsOn = False
      opts@cnConstFLabelOn = False
      opts@cnConstFLabelPerimOn = False
      opts@cnLevels    = (/  -2*std, 2*std/)   ; set levels
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      ;opts@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
      contour_std = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)

    ;---Arrays to hold text annotation ids
  txid_tr = new(4,graphic)
  amid_tr = new(4,graphic)

  txres                       = True
  txres@txPerimOn             = True
  txres@txFontHeightF         = 0.03

;---Top right string
  amres_tr                  = True
  amres_tr@amParallelPosF   =  0.5    ; This is the right edge of the plot.
  amres_tr@amOrthogonalPosF = -0.5    ; This is the top edge of the plot.
  amres_tr@amJust           = "TopRight"

     txres@txBackgroundFillColor = "White"
     tr_label = "St Dev=" + sprintf("%5.2f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_flux, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_flux)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surfce Net Radiation Difference (Wm^-2) ~C~~Z75~Modern-Pre-settlement ~C~~Z25~ "
    pnlres@txFontHeightF               = 0.025
    pnlres@gsnPanelYWhiteSpacePercent = 5       ; Add white space b/w plots.
    pnlres@gsnPanelLabelBar           = True    ; Turn on common labelbar
    pnlres@lbLabelAutoStride          = True    ; Spacing of lbar labels.
    pnlres@lbBoxMinorExtentF          = 0.5
    pnlres@lbLabelFontHeightF         = 0.015
    pnlres@gsnPanelFigureStrings= (/"a)","b)","c)","d)"/) ; add strings to panel
  pnlres@amJust   = "TopLeft"
    gsn_panel(wks,(/plots/),(/2,2/),pnlres)

end do
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
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_net")

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

pltres@PanelPlot = True      ; Indicate these plots are to be paneled.
res@NoHeaderFooter = True
pltres@NoTitles = True

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)

 flux_modern = dim_avg_n(net_modern_raw(mon::4,:,:), 0)

 flux_dust = dim_avg_n(net_dust_raw(mon::4,:,:), 0)

diffr = flux_modern - flux_dust

varx = variance(flux_dust)

vary = variance(flux_modern)

n = 8

std = sqrt((varx/n)+(vary/n))



  ; Plotting options for LH
      opts = res
      opts@cnFillOn = True
      opts@lbLabelBarOn = False
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_flux = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)

    ; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnSmoothingOn = True
      opts@cnSmoothingDistanceF = 0.21
      opts@cnLineLabelsOn = False
      opts@cnConstFLabelOn = False
      opts@cnConstFLabelPerimOn = False
      opts@cnLevels    = (/  -2*std, 2*std/)   ; set levels
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      ;opts@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
      contour_std = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)

;---Arrays to hold text annotation ids
  txid_tr = new(4,graphic)
  amid_tr = new(4,graphic)

  txres                       = True
  txres@txPerimOn             = True
  txres@txFontHeightF         = 0.03

;---Top right string
  amres_tr                  = True
  amres_tr@amParallelPosF   =  0.5    ; This is the right edge of the plot.
  amres_tr@amOrthogonalPosF = -0.5    ; This is the top edge of the plot.
  amres_tr@amJust           = "TopRight"

     txres@txBackgroundFillColor = "White"
     tr_label = "St Dev=" + sprintf("%5.2f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_flux, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_flux)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surface Net Radiation Difference (Wm^-2) ~C~~Z75~Modern-Dust Bowl ~C~~Z25~ "
    pnlres@txFontHeightF               = 0.025
    pnlres@gsnPanelYWhiteSpacePercent = 5       ; Add white space b/w plots.
    pnlres@gsnPanelLabelBar           = True    ; Turn on common labelbar
    pnlres@lbLabelAutoStride          = True    ; Spacing of lbar labels.
    pnlres@lbBoxMinorExtentF          = 0.5
    pnlres@lbLabelFontHeightF         = 0.015
    pnlres@gsnPanelFigureStrings= (/"a)","b)","c)","d)"/) ; add strings to panel
  pnlres@amJust   = "TopLeft"
    gsn_panel(wks,(/plots/),(/2,2/),pnlres)

end do
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
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_net")

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

pltres@PanelPlot = True      ; Indicate these plots are to be paneled.
res@NoHeaderFooter = True
pltres@NoTitles = True

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

m = (/0,1,2,3/)

letters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)

 flux_modern = dim_avg_n(net_modern_raw(mon::4,:,:), 0)

 flux_1920s = dim_avg_n(net_1920s_raw(mon::5,:,:), 0)

diffr = flux_modern - flux_1920s

varx = variance(flux_1920s)

vary = variance(flux_modern)

n = 8

std = sqrt((varx/n)+(vary/n))


 ; Plotting options for LH
      opts = res
      opts@cnFillOn = True
      opts@lbLabelBarOn = False
      opts@cnLineColor = "Black"
      opts@cnLineLabelBackgroundColor = -1
     opts@ContourParameters = (/ -60., 60., 10./)
     contour_flux = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)

    ; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnSmoothingOn = True
      opts@cnSmoothingDistanceF = 0.21
      opts@cnLineLabelsOn = False
      opts@cnConstFLabelOn = False
      opts@cnConstFLabelPerimOn = False
      opts@cnLevels    = (/  -2*std, 2*std/)   ; set levels
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      ;opts@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
      contour_std = wrf_contour(amodern,wks,diffr,opts)
      delete(opts)

;---Arrays to hold text annotation ids
  txid_tr = new(4,graphic)
  amid_tr = new(4,graphic)

  txres                       = True
  txres@txPerimOn             = True
  txres@txFontHeightF         = 0.03

;---Top right string
  amres_tr                  = True
  amres_tr@amParallelPosF   =  0.5    ; This is the right edge of the plot.
  amres_tr@amOrthogonalPosF = -0.5    ; This is the top edge of the plot.
  amres_tr@amJust           = "TopRight"

     txres@txBackgroundFillColor = "White"
     tr_label = "St Dev=" + sprintf("%5.2f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_flux, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_flux)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surface Net Radiation Difference (Wm^-2) ~C~~Z75~Modern-1920s ~C~~Z25~ "
    pnlres@txFontHeightF               = 0.025
    pnlres@gsnPanelYWhiteSpacePercent = 5       ; Add white space b/w plots.
    pnlres@gsnPanelLabelBar           = True    ; Turn on common labelbar
    pnlres@lbLabelAutoStride          = True    ; Spacing of lbar labels.
    pnlres@lbBoxMinorExtentF          = 0.5
    pnlres@lbLabelFontHeightF         = 0.015
    pnlres@gsnPanelFigureStrings= (/"a)","b)","c)","d)"/) ; add strings to panel
  pnlres@amJust   = "TopLeft"
    gsn_panel(wks,(/plots/),(/2,2/),pnlres)

end do



end
