
;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
 ; The WRF ARW input file.
; This needs to have a ".nc" appended, so just do it.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - pre
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_precip")
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues

 mpGridAndLimbOn= True

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

;loop thru each month (May-Aug)

m = (/0,1,2,3/)

aletters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(aletters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)

letters  = (/"may", "june", "july", "august"/)

letters2 = (/"june", "july", "august", "sept"/)

monthss = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

month2_string = stringtochar(letters2)

months_string = stringtochar(monthss)
do i = 0,3

month1 = month_string(i,:)

month2 = month2_string(i,:)

months = months_string(i,:)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; the first month!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;may june july august
  mon1_pre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/"+month1+".nc","r")

  mon1_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month1+".nc","r")


;;;;;;;;;;;;;;;;;;;;;;;;;;; the second month! ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; june july august sept
 mon2_pre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/"+month2+".nc","r")

 mon2_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month2+".nc","r")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; What times and how many time steps are in the data set?
  FirstTime = True
  times = wrf_user_getvar(mon1_modern,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need
; modern

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_modern = wrf_user_getvar(mon1_modern,"RAINNC",-1)
    rain_con_mon1_modern = wrf_user_getvar(mon1_modern,"RAINC",-1)
	wrf_smooth_2d(rain_con_mon1_modern, 7)
        wrf_smooth_2d(rain_exp_mon1_modern, 7) 
    rain_tot_mon1_modern = rain_exp_mon1_modern + rain_con_mon1_modern
    rain_tot_mon1_modern@description = "Total Precipitation"


    rain_exp_mon2_modern = wrf_user_getvar(mon2_modern,"RAINNC",-1)
    rain_con_mon2_modern = wrf_user_getvar(mon2_modern,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon2_modern, 7)
        wrf_smooth_2d(rain_exp_mon2_modern, 7)
     rain_tot_mon2_modern = rain_exp_mon2_modern + rain_con_mon2_modern
    rain_tot_mon2_modern@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; First get the variables we will need
; pre

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_pre = wrf_user_getvar(mon1_pre,"RAINNC",-1)
    rain_con_mon1_pre = wrf_user_getvar(mon1_pre,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon1_pre, 7)
        wrf_smooth_2d(rain_exp_mon1_pre, 7)
    rain_tot_mon1_pre = rain_exp_mon1_pre + rain_con_mon1_pre
    rain_tot_mon1_pre@description = "Total Precipitation"

    rain_exp_mon2_pre = wrf_user_getvar(mon2_pre,"RAINNC",-1)
    rain_con_mon2_pre = wrf_user_getvar(mon2_pre,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon2_pre, 7)
        wrf_smooth_2d(rain_exp_mon2_pre, 7)
    rain_tot_mon2_pre = rain_exp_mon2_pre + rain_con_mon2_pre
    rain_tot_mon2_pre@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subtract precip to get monthly totals

rain_tot_modern = rain_tot_mon2_modern - rain_tot_mon1_modern

rain_tot_pre = rain_tot_mon2_pre - rain_tot_mon1_pre
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;average this stuff

rain_modern = dim_avg_n(rain_tot_modern(0::1,:,:), 0)

rain_pre = dim_avg_n(rain_tot_pre(0::1,:,:), 0)

diffr = rain_modern - rain_pre

varx = variance(rain_pre)

vary = variance(rain_modern)

n = 8

std = sqrt((varx/n)+(vary/n))

      ; Plotting options for Precipitation
        opts_r = res                        
        opts_r@cnInfoLabelOn        = False
        opts_r@cnConstFLabelOn      = False
	opts_r@lbLabelBarOn = False 
       opts_r@ContourParameters = (/-120.,120., 20.0/)
       opts_r@cnFillOn             = True 
       contour_tot = wrf_contour(mon1_modern,wks,diffr, opts_r)
       delete(opts_r)


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
      contour_std = wrf_contour(mon1_modern,wks,diffr,opts)
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
     plots(iplot) = wrf_map_overlays(mon1_modern,wks,(/contour_tot, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_tot)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Total Precipitation Difference (mm) ~C~~Z75~Modern-Pre-settlement ~C~~Z25~ "
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

end do 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - dust bowl
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_precip")
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues

 mpGridAndLimbOn= True

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;loop thru each month (May-Aug)

m = (/0,1,2,3/)

aletters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(aletters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)

letters  = (/"may", "june", "july", "august"/)

letters2 = (/"june", "july", "august", "sept"/)

monthss = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

month2_string = stringtochar(letters2)

months_string = stringtochar(monthss)
do i = 0,3

month1 = month_string(i,:)

month2 = month2_string(i,:)

months = months_string(i,:)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; the first month!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;may june july august

  mon1_dust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/"+month1+".nc","r")

  mon1_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month1+".nc","r")


;;;;;;;;;;;;;;;;;;;;;;;;;;; the second month! ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; june july august sept

 mon2_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month2+".nc","r")

 mon2_dust= addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/"+month2+".nc","r")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; What times and how many time steps are in the data set?
  FirstTime = True
  times = wrf_user_getvar(mon1_modern,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need
; modern

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_modern = wrf_user_getvar(mon1_modern,"RAINNC",-1)
    rain_con_mon1_modern = wrf_user_getvar(mon1_modern,"RAINC",-1)
         wrf_smooth_2d(rain_con_mon1_modern, 7)
         wrf_smooth_2d(rain_exp_mon1_modern, 7)
    rain_tot_mon1_modern = rain_exp_mon1_modern + rain_con_mon1_modern
    rain_tot_mon1_modern@description = "Total Precipitation"


  rain_exp_mon2_modern = wrf_user_getvar(mon2_modern,"RAINNC",-1)
    rain_con_mon2_modern = wrf_user_getvar(mon2_modern,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon2_modern, 7)
        wrf_smooth_2d(rain_exp_mon2_modern, 7)
    rain_tot_mon2_modern = rain_exp_mon2_modern + rain_con_mon2_modern
    rain_tot_mon2_modern@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need
; dust

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_dust = wrf_user_getvar(mon1_dust,"RAINNC",-1)
    rain_con_mon1_dust = wrf_user_getvar(mon1_dust,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon1_dust, 7)
        wrf_smooth_2d(rain_exp_mon1_dust, 7)
    rain_tot_mon1_dust = rain_exp_mon1_dust + rain_con_mon1_dust
    rain_tot_mon1_dust@description = "Total Precipitation"

    rain_exp_mon2_dust = wrf_user_getvar(mon2_dust,"RAINNC",-1)
    rain_con_mon2_dust = wrf_user_getvar(mon2_dust,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon2_dust, 7)
        wrf_smooth_2d(rain_exp_mon2_dust, 7)
    rain_tot_mon2_dust = rain_exp_mon2_dust + rain_con_mon2_dust
    rain_tot_mon2_dust@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;subtract precip to get monthly totals

rain_tot_modern = rain_tot_mon2_modern - rain_tot_mon1_modern

rain_tot_dust = rain_tot_mon2_dust - rain_tot_mon1_dust
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;average this stuff

rain_modern = dim_avg_n(rain_tot_modern(0::1,:,:), 0)

rain_dust = dim_avg_n(rain_tot_dust(0::1,:,:), 0)

diffr = rain_modern - rain_dust

varx = variance(rain_pre)

vary = variance(rain_modern)

n = 8

std = sqrt((varx/n)+(vary/n))

  ; Plotting options for Precipitation
        opts_r = res
        opts_r@cnInfoLabelOn        = False
        opts_r@cnConstFLabelOn      = False
        opts_r@lbLabelBarOn = False
       opts_r@ContourParameters = (/-120.,120., 20.0/)
       opts_r@cnFillOn             = True
       contour_tot = wrf_contour(mon1_modern,wks,diffr, opts_r)
       delete(opts_r)



; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnConstFLabelOn = False
      opts@cnConstFLabelPerimOn = False
      opts@cnLineLabelsOn = False
      opts@cnLevels    = (/ -3*std, -2*std, 2*std, 3*std/)   ; set levels
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      opts@cnSmoothingOn = True
      opts@cnSmoothingDistanceF = 0.08
      ;opts@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
      contour_std = wrf_contour(mon1_modern,wks,diffr,opts)
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
     plots(iplot) = wrf_map_overlays(mon1_modern,wks,(/contour_tot, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_tot)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Total Precipitation Difference (mm) ~C~~Z75~Modern-Dust Bowl ~C~~Z25~ "
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

end do 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; modern - 1920s
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind o we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_precip")
 gsn_define_colormap(wks,"BlueWhiteOrangeRed")

 setvalues NhlGetWorkspaceObjectId()
    "wsMaximumSize" : 300000000
  end setvalues

 mpGridAndLimbOn= True

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;loop thru each month (May-Aug)

m = (/0,1,2,3/)

aletters  = (/"May", "June", "July", "August"/)

month_string = stringtochar(aletters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend

mon = m(i)
month = month_string(i,:)

letters  = (/"may", "june", "july", "august"/)

letters2 = (/"june", "july", "august", "sept"/)

monthss = (/"May", "June", "July", "August"/)

month_string = stringtochar(letters)

month2_string = stringtochar(letters2)

months_string = stringtochar(monthss)
do i = 0,3

month1 = month_string(i,:)

month2 = month2_string(i,:)

months = months_string(i,:)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; the first month!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;may june july august

  mon1_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month1+".nc","r")

  mon1_1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/"+month1+".nc","r")

;;;;;;;;;;;;;;;;;;;;;;;;;;; the second month! ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; june july august sept

 mon2_modern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/"+month2+".nc","r")
 
mon2_1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/"+month2+".nc", "r")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; What times and how many time steps are in the data set?
  FirstTime = True
  times = wrf_user_getvar(mon1_modern,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need
; modern

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_modern = wrf_user_getvar(mon1_modern,"RAINNC",-1)
    rain_con_mon1_modern = wrf_user_getvar(mon1_modern,"RAINC",-1)
	wrf_smooth_2d(rain_con_mon1_modern, 7)
        wrf_smooth_2d(rain_exp_mon1_modern, 7)
    rain_tot_mon1_modern = rain_exp_mon1_modern + rain_con_mon1_modern
    rain_tot_mon1_modern@description = "Total Precipitation"


  rain_exp_mon2_modern = wrf_user_getvar(mon2_modern,"RAINNC",-1)
    rain_con_mon2_modern = wrf_user_getvar(mon2_modern,"RAINC",-1)
	wrf_smooth_2d(rain_con_mon2_modern, 7)
        wrf_smooth_2d(rain_exp_mon2_modern, 7)
    rain_tot_mon2_modern = rain_exp_mon2_modern + rain_con_mon2_modern
    rain_tot_mon2_modern@description = "Total Precipitation"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; First get the variables we will need
; 1920s

  ; Get non-convective, convective and total precipitation
  ; Calculate tendency values
    rain_exp_mon1_1920s = wrf_user_getvar(mon1_1920s,"RAINNC",-1)
    rain_con_mon1_1920s = wrf_user_getvar(mon1_1920s,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon1_1920s, 11)
        wrf_smooth_2d(rain_exp_mon1_1920s, 11)
    rain_tot_mon1_1920s = rain_exp_mon1_1920s + rain_con_mon1_1920s
    rain_tot_mon1_1920s@description = "Total Precipitation"

    rain_exp_mon2_1920s = wrf_user_getvar(mon2_1920s,"RAINNC",-1)
    rain_con_mon2_1920s = wrf_user_getvar(mon2_1920s,"RAINC",-1)
        wrf_smooth_2d(rain_con_mon2_1920s, 11)
        wrf_smooth_2d(rain_exp_mon2_1920s, 11)
    rain_tot_mon2_1920s = rain_exp_mon2_1920s + rain_con_mon2_1920s
    rain_tot_mon2_1920s@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;subtract precip to get monthly totals

rain_tot_modern = rain_tot_mon2_modern - rain_tot_mon1_modern

rain_tot_1920s = rain_tot_mon2_1920s - rain_tot_mon1_1920s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;average this stuff

rain_modern = dim_avg_n(rain_tot_modern(0::1,:,:), 0)

rain_1920s = dim_avg_n(rain_tot_1920s(0::1,:,:), 0)

diffr = rain_modern - rain_1920s

varx = variance(rain_pre)

vary = variance(rain_modern)

n = 8

std = sqrt((varx/n)+(vary/n))

 ; Plotting options for Precipitation
        opts_r = res
        opts_r@cnInfoLabelOn        = False
        opts_r@cnConstFLabelOn      = False
        opts_r@lbLabelBarOn = False
       opts_r@ContourParameters = (/-120.,120., 20.0/)
       opts_r@cnFillOn             = True
       contour_tot = wrf_contour(mon1_modern,wks,diffr, opts_r)
       delete(opts_r)


; Plotting options for std dev
      opts = res
      opts@cnLineColor = "Black"
      opts@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      opts@cnInfoLabelOn = False
      opts@cnConstFLabelOn = False
      opts@cnLineLabelsOn = False
      opts@cnConstFLabelPerimOn = False
      opts@cnLevels    = (/ -3*std, -2*std, 2*std, 3*std/)   ; set levels
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      opts@cnSmoothingOn = True
      opts@cnSmoothingDistanceF = 0.08
      ;opts@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
      contour_std = wrf_contour(mon1_modern,wks,diffr,opts)
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
     plots(iplot) = wrf_map_overlays(mon1_modern,wks,(/contour_tot, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)


         delete(contour_tot)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Total Precipitation Difference (mm) ~C~~Z75~Modern-1920s ~C~~Z25~ "
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

end do 

end 
