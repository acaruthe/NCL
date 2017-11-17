
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


  snow_1920s_raw = wrf_user_getvar(a1920s, "SNOWC", -1) ;
      wrf_smooth_2d(snow_1920s_raw, 5)

   snow_pre_raw = wrf_user_getvar(apre, "SNOWC", -1) ;
        wrf_smooth_2d(snow_pre_raw, 5)

   snow_dust_raw = wrf_user_getvar(adust, "SNOWC", -1) ;
        wrf_smooth_2d(snow_dust_raw, 5)

   snow_modern_raw = wrf_user_getvar(amodern, "SNOWC", -1) ;
        wrf_smooth_2d(snow_modern_raw, 5)

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
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_snow")

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


 snow_modern = dim_avg_n(snow_modern_raw(mon::4,:,:), 0)

 snow_pre = dim_avg_n(snow_pre_raw(mon::4,:,:), 0)

diffr = snow_modern - snow_pre

varx = variance(snow_pre)

vary = variance(snow_modern)

n = 8

std = sqrt((varx/n)+(vary/n))



   ; Plotting options for snow depth
        opts = res
        opts@cnFillOn = True
	opts@lbLabelBarOn = False
	opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-2.,2., 0.2/)
        contour_dew = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnLevels    = (/ -3*std, -2*std, 2*std, 3*std/)   ; set levels
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_dew, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_dew)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surface Snow Depth Differnce (m) ~C~~Z75~Modern-Pre-settlement ~C~~Z25~ "
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
;differences modern - dust bowl
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_snow")

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


 snow_modern = dim_avg_n(snow_modern_raw(mon::4,:,:), 0)

 snow_dust = dim_avg_n(snow_dust_raw(mon::4,:,:), 0)

diffr = snow_modern - snow_dust

varx = variance(snow_dust)

vary = variance(snow_modern)

n = 8

std = sqrt((varx/n)+(vary/n))



 ; Plotting options for dewpoint
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        ;opts@ContourParameters = (/-3.,3., 0.5/)
        contour_dew = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

 ; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnLevels    = (/ -3*std, -2*std, 2*std, 3*std/)   ; set levels
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_dew, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_dew)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surface Snow Depth Difference (m) ~C~~Z75~Modern-Dust Bowl ~C~~Z25~ "
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
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_snow")

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


 snow_modern = dim_avg_n(snow_modern_raw(mon::4,:,:), 0)

 snow_1920s = dim_avg_n(snow_1920s_raw(mon::5,:,:), 0)

diffr = snow_modern - snow_1920s

varx = variance(snow_1920s)

vary = variance(snow_modern)

n = 8

std = sqrt((varx/n)+(vary/n))



; Plotting options for dewpoint
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        ;opts@ContourParameters = (/-3.,3., 0.5/)
        contour_dew = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

 ; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnLevels    = (/ -3*std, -2*std, 2*std, 3*std/)   ; set levels
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_dew, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_dew)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Surface Snow Depth Difference (m) ~C~~Z75~Modern-1920s ~C~~Z25~ "
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
