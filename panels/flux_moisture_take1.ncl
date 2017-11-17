
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
;10 meter U winds 

  uwind_1920s= wrf_user_getvar(a1920s, "U10", -1) ;
      wrf_smooth_2d(uwind_1920s, 5)

   uwind_pre = wrf_user_getvar(apre, "U10", -1) ;
        wrf_smooth_2d(uwind_pre, 5)

   uwind_dust= wrf_user_getvar(adust, "U10", -1) ;
       wrf_smooth_2d(uwind_dust, 5)

   uwind_modern = wrf_user_getvar(amodern, "U10", -1) ;
        wrf_smooth_2d(uwind_modern, 5)


   vwind_1920s = wrf_user_getvar(a1920s, "V10", -1) ;
      wrf_smooth_2d(vwind_1920s, 5)

   vwind_pre = wrf_user_getvar(apre, "V10", -1) ;
        wrf_smooth_2d(vwind_pre, 5)

   vwind_dust= wrf_user_getvar(adust, "V10", -1) ;
       wrf_smooth_2d(vwind_dust, 5)

   vwind_modern = wrf_user_getvar(amodern, "V10", -1) ;
        wrf_smooth_2d(vwind_modern, 5)


 temp_1920s = wrf_user_getvar(a1920s, "T2", -1) ;
      wrf_smooth_2d(temp_1920s, 5)

   temp_pre = wrf_user_getvar(apre, "T2", -1) ;
        wrf_smooth_2d(temp_pre, 5)

   temp_dust= wrf_user_getvar(adust, "T2", -1) ;
       wrf_smooth_2d(temp_dust, 5)

   temp_modern = wrf_user_getvar(amodern, "T2", -1) ;
        wrf_smooth_2d(temp_modern, 5)


   pres_1920s = wrf_user_getvar(a1920s, "PSFC", -1) ;
      wrf_smooth_2d(pres_1920s, 9)

   pres_pre = wrf_user_getvar(apre, "PSFC", -1) ;
        wrf_smooth_2d(pres_pre, 9)

   pres_dust= wrf_user_getvar(adust, "PSFC", -1) ;
       wrf_smooth_2d(pres_dust, 9)

   pres_modern = wrf_user_getvar(amodern, "PSFC", -1) ;
        wrf_smooth_2d(pres_modern, 9)


pres_modern = pres_modern * 0.01

pres_pre = pres_pre * 0.01

pres_1920s = pres_1920s *0.01

pres_dust = pres_dust *0.01



 rh_1920s = wrf_user_getvar(a1920s, "rh2", -1) ;
      wrf_smooth_2d(rh_1920s, 5)

   rh_pre = wrf_user_getvar(apre, "rh2", -1) ;
        wrf_smooth_2d(rh_pre, 5)

   rh_dust= wrf_user_getvar(adust, "rh2", -1) ;
       wrf_smooth_2d(rh_dust, 5)

   rh_modern = wrf_user_getvar(amodern, "rh2", -1) ;
        wrf_smooth_2d(rh_modern, 5)


    xlat = wrf_user_getvar(amodern, "XLAT",0)
    xlon = wrf_user_getvar(amodern, "XLONG",0)
     
   lat = xlat(:,1)
   lon = xlon(1,:)
  
  q_modern = mixhum_ptrh (pres_modern, temp_modern, rh_modern, -2) ; 

	wrf_smooth_2d(q_modern, 5)

 q_pre = mixhum_ptrh (pres_pre, temp_pre, rh_pre, -2) ;

	wrf_smooth_2d(q_pre, 5)

 q_1920s = mixhum_ptrh (pres_1920s, temp_1920s, rh_1920s, -2) ;

	wrf_smooth_2d(q_1920s, 5)

 q_dust = mixhum_ptrh (pres_dust, temp_dust, rh_dust, -2) ;
	
	wrf_smooth_2d(q_dust, 5)


 qu_modern = q_modern * uwind_modern
 qv_modern = q_modern * vwind_modern

 qu_pre = q_pre * uwind_pre
 qv_pre = q_pre * vwind_pre

 qu_1920s = q_1920s * uwind_1920s 
 qv_1920s = q_1920s * vwind_1920s

 qu_dust = q_dust * uwind_dust
 qv_dust = q_dust * vwind_dust


 mfc_modern_raw = uv2dv_cfd(qu_modern,qv_modern,lat,lon,2) 

 mfc_pre_raw = uv2dv_cfd(qu_pre,qv_pre,lat,lon,2)  

 mfc_1920s_raw = uv2dv_cfd(qu_1920s,qv_1920s,lat,lon,2)
 
 mfc_dust_raw = uv2dv_cfd(qu_dust,qv_dust,lat,lon,2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - pre
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_mfc")

 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;loop thru each month (May-Aug)

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

mfc_modern = dim_avg_n(mfc_modern_raw(mon::4,:,:), 0)


mfc_pre = dim_avg_n(mfc_pre_raw(mon::4,:,:), 0)


  mfc_modern = mfc_modern * -100000
 
  wrf_smooth_2d(mfc_modern,11)

  mfc_pre = mfc_pre  * -100000

  wrf_smooth_2d(mfc_pre, 11)



;print(max(mfc_pre));
;print(max(mfc_modern))

diffr = mfc_modern - mfc_pre

varx = variance(mfc_pre)

vary = variance(mfc_modern)

n = 8

std = sqrt((varx/n)+(vary/n))


print(max(diffr))

print(min(diffr))

   ; Plotting options for 10m U 
        opts = res
        opts@cnFillOn = True
	opts@lbLabelBarOn = False
	opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-50, 50, 5./)
        contour_wind = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)


 ; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnLevels    = (/ -2*std, 2*std /)   ; set levels
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
     tr_label = "St Dev=" + sprintf("%5.3f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_wind, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_wind)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean 10m U-Wind Difference (m/s) ~C~~Z75~Modern-Pre-settlement ~C~~Z25~ "
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_mfc")

 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues


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

pltres@PanelPlot = True      ; Indicate these plots are to be paneled.
res@NoHeaderFooter = True
pltres@NoTitles = True

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;loop thru each month (May-Aug)

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

mfc_modern = dim_avg_n(mfc_modern_raw(mon::4,:,:), 0)

mfc_dust = dim_avg_n(mfc_dust_raw(mon::4,:,:), 0)

diffr = mfc_modern - mfc_dust

varx = variance(mfc_dust)

vary = variance(mfc_modern)

n = 8

std = sqrt((varx/n)+(vary/n))


   ; Plotting options for 10m U
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        ;opts@ContourParameters = (/-1.2, 1.2, 0.1/)
        contour_wind = wrf_contour(amodern,wks,mfc_modern,opts)

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
     tr_label = "St Dev=" + sprintf("%5.3f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_wind, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_wind)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean 10m U-Wind Difference (m/s) ~C~~Z75~Modern-Dust Bowl ~C~~Z25~ "
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_mfc")

 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;loop thru each month (May-Aug)

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

mfc_modern = dim_avg_n(mfc_modern_raw(mon::4,:,:), 0)

mfc_1920s = dim_avg_n(mfc_1920s_raw(mon::5,:,:), 0)

diffr = mfc_modern - mfc_1920s

varx = variance(mfc_1920s)

vary = variance(mfc_modern)
n = 8

std = sqrt((varx/n)+(vary/n))


   ; Plotting options for 10m U
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        ;opts@ContourParameters = (/-1.2, 1.2, 0.1/)
        contour_wind = wrf_contour(amodern,wks,diffr,opts)
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
     tr_label = "St Dev=" + sprintf("%5.3f",std)

     mpres@tmXBLabelFontHeightF = 0.03
     mpres@tmYLLabelFontHeightF = 0.03
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_wind, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_wind)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean 10m U-Wind Difference (m/s) ~C~~Z75~Modern-1920s ~C~~Z25~ "
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
