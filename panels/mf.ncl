; 

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

; Calculate meridional flux moisture (q*v) vertically integrated 

; read in files and variables from 4 models

;nac_dust = addfile("./nac_dust_00.nc","r")
  a1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/1920s.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

  adust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/dustbowl.nc","r")

  amodern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc","r")
;---------------------------------------------------------------

  
q_modern_raw  = wrf_user_getvar(amodern,"QVAPOR",-1)      ;
q_pre_raw  = wrf_user_getvar(apre,"QVAPOR",-1)       ;
q_1920s_raw  = wrf_user_getvar(a1920s,"QVAPOR",-1)      ;
q_dust_raw = wrf_user_getvar(adust, "QVAPOR", -1)

v_modern_raw  = wrf_user_getvar(amodern,"va",-1)      ;
v_pre_raw  = wrf_user_getvar(apre,"va",-1)       ;
v_1920s_raw  = wrf_user_getvar(a1920s,"va",-1)      ;
v_dust_raw = wrf_user_getvar(adust, "va", -1)

pres_modern_raw  = wrf_user_getvar(amodern,"pressure",-1)      ;
pres_pre_raw  = wrf_user_getvar(apre,"pressure",-1)       ;
pres_1920s_raw  = wrf_user_getvar(a1920s,"pressure",-1)      ;
pres_dust_raw = wrf_user_getvar(adust, "pressure", -1)

slp_modern_raw  = wrf_user_getvar(amodern,"PSFC",-1)      ;
slp_pre_raw  = wrf_user_getvar(apre,"PSFC",-1)       ;
slp_1920s_raw  = wrf_user_getvar(a1920s,"PSFC",-1)      ;
slp_dust_raw = wrf_user_getvar(adust, "PSFC", -1)


  pressure = 850.   ; 850 hPa
;water vapor at 1000mb
q_modern_plane_1000  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",1000.,0.,False)
q_pre_plane_1000 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",1000.,0.,False)
q_1920s_plane_1000  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",1000.,0.,False)
q_dust_plane_1000 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",1000.,0.,False)

;water vapor at 950
q_modern_plane_950  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",950.,0.,False)
q_pre_plane_950 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",950.,0.,False)
q_1920s_plane_950 = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",950.,0.,False)
q_dust_plane_950 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",950.,0.,False)

;water vapor at 900
q_modern_plane_900  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",900.,0.,False)
q_pre_plane_900 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",900.,0.,False)
q_1920s_plane_900  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",900.,0.,False)
q_dust_plane_900 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",900.,0.,False)

;water vapor at 850
q_modern_plane_850  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",850.,0.,False)
q_pre_plane_850 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",850.,0.,False)
q_1920s_plane_850  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",850.,0.,False)
q_dust_plane_850 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",850.,0.,False)

;water vapor at 800
q_modern_plane_800  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",800.,0.,False)
q_pre_plane_800 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",800.,0.,False)
q_1920s_plane_800  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",800.,0.,False)
q_dust_plane_800 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",800.,0.,False)

;water vapor at 750
q_modern_plane_750  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",750.,0.,False)
q_pre_plane_750 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",750.,0.,False)
q_1920s_plane_750  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",750.,0.,False)
q_dust_plane_750 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",750.,0.,False)

;water vapor at 700
q_modern_plane_700  = wrf_user_intrp3d(q_modern_raw,pres_modern_raw,"h",700.,0.,False)
q_pre_plane_700 = wrf_user_intrp3d(q_pre_raw,pres_pre_raw,"h",700.,0.,False)
q_1920s_plane_700  = wrf_user_intrp3d(q_1920s_raw,pres_1920s_raw,"h",700.,0.,False)
q_dust_plane_700 = wrf_user_intrp3d(q_dust_raw,pres_dust_raw,"h",700.,0.,False)

;*************************************************************************************

;v at 1000
v_modern_plane_1000  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",1000.,0.,False)
v_pre_plane_1000 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",1000.,0.,False)
v_1920s_plane_1000  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",1000.,0.,False)
v_dust_plane_1000 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",1000.,0.,False)

;v at 950
v_modern_plane_950  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",950.,0.,False)
v_pre_plane_950 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",950.,0.,False)
v_1920s_plane_950 = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",950.,0.,False)
v_dust_plane_950 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",950.,0.,False)

;v at 900
v_modern_plane_900  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",900.,0.,False)
v_pre_plane_900 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",900.,0.,False)
v_1920s_plane_900  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",900.,0.,False)
v_dust_plane_900 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",900.,0.,False)

;v at 850
v_modern_plane_850  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",850.,0.,False)
v_pre_plane_850 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",850.,0.,False)
v_1920s_plane_850  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",850.,0.,False)
v_dust_plane_850 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",850.,0.,False)

;v at 80
v_modern_plane_800  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",800.,0.,False)
v_pre_plane_800 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",800.,0.,False)
v_1920s_plane_800  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",800.,0.,False)
v_dust_plane_800 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",800.,0.,False)

;v at 750
v_modern_plane_750  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",750.,0.,False)
v_pre_plane_750 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",750.,0.,False)
v_1920s_plane_750  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",750.,0.,False)
v_dust_plane_750 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",750.,0.,False)

;v at 700
v_modern_plane_700  = wrf_user_intrp3d(v_modern_raw,pres_modern_raw,"h",700.,0.,False)
v_pre_plane_700 = wrf_user_intrp3d(v_pre_raw,pres_pre_raw,"h",700.,0.,False)
v_1920s_plane_700  = wrf_user_intrp3d(v_1920s_raw,pres_1920s_raw,"h",700.,0.,False)
v_dust_plane_700 = wrf_user_intrp3d(v_dust_raw,pres_dust_raw,"h",700.,0.,False)


;****************************************************************************************

flux_modern_raw_plane_700 = v_modern_plane_700 * q_modern_plane_700 
flux_modern_raw_plane_750 = v_modern_plane_750 * q_modern_plane_750
flux_modern_raw_plane_800 = v_modern_plane_800 * q_modern_plane_800
flux_modern_raw_plane_850 = v_modern_plane_850 * q_modern_plane_850
flux_modern_raw_plane_900 = v_modern_plane_900 * q_modern_plane_900
flux_modern_raw_plane_950 = v_modern_plane_950 * q_modern_plane_950
flux_modern_raw_plane_1000 = v_modern_plane_1000 * q_modern_plane_1000


flux_pre_raw_plane_700 = v_pre_plane_700 * q_pre_plane_700
flux_pre_raw_plane_750 = v_pre_plane_750 * q_pre_plane_750
flux_pre_raw_plane_800 = v_pre_plane_800 * q_pre_plane_800
flux_pre_raw_plane_850 = v_pre_plane_850 * q_pre_plane_850
flux_pre_raw_plane_900 = v_pre_plane_900 * q_pre_plane_900
flux_pre_raw_plane_950 = v_pre_plane_950 * q_pre_plane_950
flux_pre_raw_plane_1000 = v_pre_plane_1000 * q_pre_plane_1000

flux_1920s_raw_plane_700 = v_1920s_plane_700 * q_1920s_plane_700
flux_1920s_raw_plane_750 = v_1920s_plane_750 * q_1920s_plane_750
flux_1920s_raw_plane_800 = v_1920s_plane_800 * q_1920s_plane_800
flux_1920s_raw_plane_850 = v_1920s_plane_850 * q_1920s_plane_850
flux_1920s_raw_plane_900 = v_1920s_plane_900 * q_1920s_plane_900
flux_1920s_raw_plane_950 = v_1920s_plane_950 * q_1920s_plane_950
flux_1920s_raw_plane_1000 = v_1920s_plane_1000 * q_1920s_plane_1000

flux_dust_raw_plane_700 = v_dust_plane_700 * q_dust_plane_700
flux_dust_raw_plane_750 = v_dust_plane_750 * q_dust_plane_750
flux_dust_raw_plane_800 = v_dust_plane_800 * q_dust_plane_800
flux_dust_raw_plane_850 = v_dust_plane_850 * q_dust_plane_850
flux_dust_raw_plane_900 = v_dust_plane_900 * q_dust_plane_900
flux_dust_raw_plane_950 = v_dust_plane_950 * q_dust_plane_950
flux_dust_raw_plane_1000 = v_dust_plane_1000 * q_dust_plane_1000


;*****************************************************************************************

; pre-allocate space
flux_modern_raw_all  = new ( (/32,7,384,450/), float)
flux_pre_raw_all  = new ( (/32,7,384,450/), float)
flux_1920s_raw_all   = new ( (/40,7,384,450/), float)
flux_dust_raw_all  = new ( (/32,7,384,450/), float)

flux_modern_raw_all(:,0,:,:) = flux_modern_raw_plane_1000
flux_modern_raw_all(:,1,:,:) = flux_modern_raw_plane_950
flux_modern_raw_all(:,2,:,:) = flux_modern_raw_plane_900
flux_modern_raw_all(:,3,:,:) = flux_modern_raw_plane_850
flux_modern_raw_all(:,4,:,:) = flux_modern_raw_plane_800
flux_modern_raw_all(:,5,:,:) = flux_modern_raw_plane_750
flux_modern_raw_all(:,6,:,:) = flux_modern_raw_plane_700

flux_pre_raw_all(:,0,:,:) = flux_pre_raw_plane_1000
flux_pre_raw_all(:,1,:,:) = flux_pre_raw_plane_950
flux_pre_raw_all(:,2,:,:) = flux_pre_raw_plane_900
flux_pre_raw_all(:,3,:,:) = flux_pre_raw_plane_850
flux_pre_raw_all(:,4,:,:) = flux_pre_raw_plane_800
flux_pre_raw_all(:,5,:,:) = flux_pre_raw_plane_750
flux_pre_raw_all(:,6,:,:) = flux_pre_raw_plane_700


flux_1920s_raw_all(:,0,:,:) = flux_1920s_raw_plane_1000
flux_1920s_raw_all(:,1,:,:) = flux_1920s_raw_plane_950
flux_1920s_raw_all(:,2,:,:) = flux_1920s_raw_plane_900
flux_1920s_raw_all(:,3,:,:) = flux_1920s_raw_plane_850
flux_1920s_raw_all(:,4,:,:) = flux_1920s_raw_plane_800
flux_1920s_raw_all(:,5,:,:) = flux_1920s_raw_plane_750
flux_1920s_raw_all(:,6,:,:) = flux_1920s_raw_plane_700

flux_dust_raw_all(:,0,:,:) = flux_dust_raw_plane_1000
flux_dust_raw_all(:,1,:,:) = flux_dust_raw_plane_950
flux_dust_raw_all(:,2,:,:) = flux_dust_raw_plane_900
flux_dust_raw_all(:,3,:,:) = flux_dust_raw_plane_850
flux_dust_raw_all(:,4,:,:) = flux_dust_raw_plane_800
flux_dust_raw_all(:,5,:,:) = flux_dust_raw_plane_750
flux_dust_raw_all(:,6,:,:) = flux_dust_raw_plane_700


;********************************************************************************
;;;;;;;;;;;;;;;;YO YOURE HERE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lev = (/100000.,95000.,90000.,85000.,80000.,75000.,70000./)
lev@units = "Pa"

;mse_naw_dust = -(flux_naw_dust(:,2,:,:) - flux_naw_dust(:,0,:,:))/900.-1000.

;************************************************
; Calculate MF vertically integrated
;************************************************

  CP = 1004.               ; J/(K kg)     [ m2/(K s2) ]
  GR = 9.81                ; gravity      [ m/s2 ]
  R  = 287.                ; gas constant for dry air [J/K kg]

  ptop= 70000            ; integrate 0==>psfc at each grid point
  ;print(lev)
  ;print(psfc)
  ;print(ptop)
                        ; dp(ntim,klev,nlat,mlon)
  dp_modern   = dpres_plevel(lev, slp_modern_raw, ptop, 0)
  dp_pre   = dpres_plevel(lev, slp_pre_raw, ptop, 0)
  dp_1920s  = dpres_plevel(lev, slp_1920s_raw, ptop, 0)
  dp_dust  = dpres_plevel(lev, slp_dust_raw, ptop, 0)

  mf_modern_raw = flux_modern_raw_all * dp_modern          ; temporary variable

  mf_pre_raw = flux_pre_raw_all*dp_pre          ; temporary variable

  mf_1920s_raw = flux_1920s_raw_all*dp_1920s          ; temporary variable

  mf_dust_raw = flux_dust_raw_all *dp_dust          ; temporary variable

             ; integrate vertically [level dimension = 1]
;start looping here   

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
  wks = gsn_open_wks(type,"../plots/case1_pre/avg_imf")

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

  mf_modern   = dim_sum_n_Wrap( mf_modern_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_modern_raw  = (1/GR)*mf_modern     ; (time,lat,lon)

  mf_pre   = dim_sum_n_Wrap( mf_pre_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_pre_raw  = (1/GR)*mf_pre     ; (time,lat,lon)

imf_modern = dim_avg_n(imf_modern_raw(mon::4,:,:), 0) ;average over month

imf_pre = dim_avg_n(imf_pre_raw(mon::4,:,:), 0) ;average over month

diffr = imf_modern - imf_pre ;calc the difference

n = 8

varx = variance(imf_pre)

vary = variance(imf_modern)

std = sqrt((varx/n)+(vary/n))

print(std)
; Plotting options for imf
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-20.,20., 1./)
        contour_temp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

;print(std_case1)
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_temp, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)

         delete(contour_temp)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Vert. Int. Meridional Moisture Flux Difference (kg m~S~-1~N~ s~S~-1~N~) ~C~~Z75~Modern-Pre-settlement ~C~~Z25~ "
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;modern - 1920s
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case3_1920s/avg_imf")

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

  mf_modern   = dim_sum_n_Wrap( mf_modern_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_modern_raw  = (1/GR)*mf_modern     ; (time,lat,lon)

  mf_1920s   = dim_sum_n_Wrap( mf_1920s_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_1920s_raw  = (1/GR)*mf_1920s     ; (time,lat,lon)


imf_modern = dim_avg_n(imf_modern_raw(mon::4,:,:), 0) ;average over month

imf_1920s = dim_avg_n(imf_1920s_raw(mon::5,:,:), 0) ;average over month

diffr = imf_modern - imf_1920s ;calc the difference

n = 8

varx = variance(imf_1920s)

vary = variance(imf_modern)

std = sqrt((varx/n)+(vary/n))

print(std)
; Plotting options for imf
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-20.,20., 1./)
        contour_temp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

;print(std_case1)
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_temp, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)

         delete(contour_temp)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Vert. Int. Meridional Moisture Flux Difference (kg m~S~-1~N~ s~S~-1~N~) ~C~~Z75~Modern-1920s ~C~~Z25~ "
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;modern - dust
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We generate plots, but what kind do we prefer?
;  type = "x11"
;  type = "pdf"
  type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"../plots/case2_dust/avg_imf")

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

  mf_modern   = dim_sum_n_Wrap( mf_modern_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_modern_raw  = (1/GR)*mf_modern     ; (time,lat,lon)

  mf_dust  = dim_sum_n_Wrap( mf_dust_raw,1 )   ; LE(ntim,nlat,mlon)
  imf_dust_raw  = (1/GR)*mf_dust     ; (time,lat,lon)

imf_modern = dim_avg_n(imf_modern_raw(mon::4,:,:), 0) ;average over month

imf_dust = dim_avg_n(imf_dust_raw(mon::4,:,:), 0) ;average over month

diffr = imf_modern - imf_dust ;calc the difference

n = 8

varx = variance(imf_dust)

vary = variance(imf_modern)

std = sqrt((varx/n)+(vary/n))

print(std)
; Plotting options for imf
        opts = res
        opts@cnFillOn = True
        opts@lbLabelBarOn = False
        opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
        opts@ContourParameters = (/-20.,20., 1./)
        contour_temp = wrf_contour(amodern,wks,diffr,opts)
        delete(opts)

;print(std_case1)
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
     plots(iplot) = wrf_map_overlays(amodern,wks,(/contour_temp, contour_std/),pltres,mpres)

     txid_tr(i) = gsn_create_text(wks, tr_label, txres)
     amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)

         delete(contour_temp)
        delete(diffr)
        delete(std)
      iplot = iplot + 1

    end do
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
    pnlres@txString                   = "Mean Vert. Int. Meridional Moisture Flux Difference (kg m~S~-1~N~ s~S~-1~N~) ~C~~Z75~Modern-Dust Bowl ~C~~Z25~ "
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
