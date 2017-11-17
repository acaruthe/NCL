; Plots bias/difference between PRISM and LSM for Temperature over inner domain

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

; read in files and variables from 4 models

  ;nac_dust = addfile("./nac_dust_95.nc","r")
  ;nac_hoy  = addfile("./nac_pre_95.nc","r")
  naw_hoy1  = addfile("../daily_naw_pre95_jja.nc","r")
  ;naw_dust = addfile("./naw_dust_95.nc","r")

  naw_dust = addfile("../hour_naw_dust95_mjj.nc","r")
  nac_dust = addfile("../hour_nac_dust95_mjj.nc","r")
  naw_hoy  = addfile("../hour_naw_old95_mjj.nc","r")
  nac_hoy  = addfile("../hour_nac_old95_mjj.nc.nc","r")

;---------------------------------------------------------------

;pull lat and lon for ploting
lat2d = naw_hoy1->XLAT
lon2d = naw_hoy1->XLONG
lat2d2= rm_single_dims(lat2d)
lon2d2= rm_single_dims(lon2d)
dimlc = dimsizes(lat2d2)
nlat = dimlc(0)
nlon = dimlc(1)

    it = -1             ; TIME LOOP

Qnac_hoy   = wrf_user_getvar(nac_hoy,"QVAPOR",it)       ;
Qnac_dust  = wrf_user_getvar(nac_dust,"QVAPOR",it)      ;
Qnaw_hoy   = wrf_user_getvar(naw_hoy,"QVAPOR",it)       ;
Qnaw_dust  = wrf_user_getvar(naw_dust,"QVAPOR",it)      ;

printVarSummary(Qnac_hoy)
;exit()

Vnac_hoy   = wrf_user_getvar(nac_hoy,"va",it)       ;
Vnac_dust  = wrf_user_getvar(nac_dust,"va",it)      ;
Vnaw_hoy   = wrf_user_getvar(naw_hoy,"va",it)       ;
Vnaw_dust  = wrf_user_getvar(naw_dust,"va",it)      ;

Pnac_hoy   = wrf_user_getvar(nac_hoy,"pressure",it)
Pnac_dust  = wrf_user_getvar(nac_dust,"pressure",it)      ;
Pnaw_hoy   = wrf_user_getvar(naw_hoy,"pressure",it)       ;
Pnaw_dust  = wrf_user_getvar(naw_dust,"pressure",it)      ;

Tnac_hoy   = wrf_user_getvar(nac_hoy,"tk",it)
Tnac_dust  = wrf_user_getvar(nac_dust,"tk",it)      ;
Tnaw_hoy   = wrf_user_getvar(naw_hoy,"tk",it)       ;
Tnaw_dust  = wrf_user_getvar(naw_dust,"tk",it)      ;

; Horizontally interpolate to pressure coordinates ("p")


Qnac_hoy_plane_1000  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",1000.,0.,False)
Qnac_dust_plane_1000 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",1000.,0.,False)
Qnaw_hoy_plane_1000  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",1000.,0.,False)
Qnaw_dust_plane_1000 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",1000.,0.,False)

Qnac_hoy_plane_950  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",950.,0.,False)
Qnac_dust_plane_950 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",950.,0.,False)
Qnaw_hoy_plane_950  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",950.,0.,False)
Qnaw_dust_plane_950 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",950.,0.,False)

Qnac_hoy_plane_900  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",900.,0.,False)
Qnac_dust_plane_900 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",900.,0.,False)
Qnaw_hoy_plane_900  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",900.,0.,False)
Qnaw_dust_plane_900 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",900.,0.,False)

Qnac_hoy_plane_850  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",850.,0.,False)
Qnac_dust_plane_850 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",850.,0.,False)
Qnaw_hoy_plane_850  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",850.,0.,False)
Qnaw_dust_plane_850 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",850.,0.,False)

Qnac_hoy_plane_800  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",800.,0.,False)
Qnac_dust_plane_800 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",800.,0.,False)
Qnaw_hoy_plane_800  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",800.,0.,False)
Qnaw_dust_plane_800 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",800.,0.,False)

Qnac_hoy_plane_750  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",750.,0.,False)
Qnac_dust_plane_750 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",750.,0.,False)
Qnaw_hoy_plane_750  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",750.,0.,False)
Qnaw_dust_plane_750 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",750.,0.,False)

Qnac_hoy_plane_700  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",925.,0.,False)
Qnac_dust_plane_700 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",925.,0.,False)
Qnaw_hoy_plane_700  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",925.,0.,False)
Qnaw_dust_plane_700 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",925.,0.,False)

printVarSummary(Qnac_hoy_plane_1000)
;*************************************************************************************

Vnac_hoy_plane_1000  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",1000.,0.,False)
Vnac_dust_plane_1000 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",1000.,0.,False)
Vnaw_hoy_plane_1000  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",1000.,0.,False)
Vnaw_dust_plane_1000 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",1000.,0.,False)

Vnac_hoy_plane_950  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",950.,0.,False)
Vnac_dust_plane_950 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",950.,0.,False)
Vnaw_hoy_plane_950  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",950.,0.,False)
Vnaw_dust_plane_950 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",950.,0.,False)

Vnac_hoy_plane_900  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",900.,0.,False)
Vnac_dust_plane_900 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",900.,0.,False)
Vnaw_hoy_plane_900  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",900.,0.,False)
Vnaw_dust_plane_900 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",900.,0.,False)

Vnac_hoy_plane_850  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",850.,0.,False)
Vnac_dust_plane_850 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",850.,0.,False)
Vnaw_hoy_plane_850  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",850.,0.,False)
Vnaw_dust_plane_850 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",850.,0.,False)

Vnac_hoy_plane_800  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",800.,0.,False)
Vnac_dust_plane_800 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",800.,0.,False)
Vnaw_hoy_plane_800  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",800.,0.,False)
Vnaw_dust_plane_800 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",800.,0.,False)

Vnac_hoy_plane_750  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",750.,0.,False)
Vnac_dust_plane_750 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",750.,0.,False)
Vnaw_hoy_plane_750  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",750.,0.,False)
Vnaw_dust_plane_750 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",750.,0.,False)

Vnac_hoy_plane_700  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",925.,0.,False)
Vnac_dust_plane_700 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",925.,0.,False)
Vnaw_hoy_plane_700  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",925.,0.,False)
Vnaw_dust_plane_700 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",925.,0.,False) 
                                   
;**************************************************************************************

Tnac_hoy_plane_1000  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",1000.,0.,False)
Tnac_dust_plane_1000 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",1000.,0.,False)
Tnaw_hoy_plane_1000  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",1000.,0.,False)
Tnaw_dust_plane_1000 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",1000.,0.,False)

Tnac_hoy_plane_950  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",950.,0.,False)
Tnac_dust_plane_950 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",950.,0.,False)
Tnaw_hoy_plane_950  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",950.,0.,False)
Tnaw_dust_plane_950 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",950.,0.,False)

Tnac_hoy_plane_900  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",900.,0.,False)
Tnac_dust_plane_900 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",900.,0.,False)
Tnaw_hoy_plane_900  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",900.,0.,False)
Tnaw_dust_plane_900 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",900.,0.,False)

Tnac_hoy_plane_850  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",850.,0.,False)
Tnac_dust_plane_850 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",850.,0.,False)
Tnaw_hoy_plane_850  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",850.,0.,False)
Tnaw_dust_plane_850 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",850.,0.,False)

Tnac_hoy_plane_800  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",800.,0.,False)
Tnac_dust_plane_800 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",800.,0.,False)
Tnaw_hoy_plane_800  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",800.,0.,False)
Tnaw_dust_plane_800 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",800.,0.,False)

Tnac_hoy_plane_750  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",750.,0.,False)
Tnac_dust_plane_750 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",750.,0.,False)
Tnaw_hoy_plane_750  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",750.,0.,False)
Tnaw_dust_plane_750 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",750.,0.,False)

Tnac_hoy_plane_700  = wrf_user_intrp3d(Tnac_hoy,Pnac_hoy,"h",925.,0.,False)
Tnac_dust_plane_700 = wrf_user_intrp3d(Tnac_dust,Pnac_dust,"h",925.,0.,False)
Tnaw_hoy_plane_700  = wrf_user_intrp3d(Tnaw_hoy,Pnaw_hoy,"h",925.,0.,False)
Tnaw_dust_plane_700 = wrf_user_intrp3d(Tnaw_dust,Pnaw_dust,"h",925.,0.,False)

;**************************************************************************************

pressure = 850.

        rho_nac_hoy850  = pressure*100./(287.*Tnac_hoy_plane_850)
        rho_nac_dust850 = pressure*100./(287.*Tnac_dust_plane_850)
        rho_naw_hoy850  = pressure*100./(287.*Tnaw_hoy_plane_850)
        rho_naw_dust850 = pressure*100./(287.*Tnaw_dust_plane_850)

        mf_nac_hoy850   = Vnac_hoy_plane_850 * Qnac_hoy_plane_850 * rho_nac_hoy850
        mf_nac_dust850  = Vnac_dust_plane_850* Qnac_dust_plane_850* rho_nac_dust850
        mf_naw_hoy850   = Vnaw_hoy_plane_850 * Qnaw_hoy_plane_850 * rho_naw_hoy850
        mf_naw_dust850  = Vnaw_dust_plane_850* Qnaw_dust_plane_850* rho_naw_dust850

; units kgm-2s-1
;***********************************************************

difnaw  = mf_naw_dust850 - mf_naw_hoy850
difnac  = mf_nac_dust850 - mf_nac_hoy850

;difpre   = Qnaw_hoy_plane_700 - Qnac_hoy_plane_700
;difdust  = Qnaw_dust_plane_700 - Qnac_dust_plane_700

;printMinMax(difpre,True)
;printMinMax(difdust,True)
printMinMax(difnac,True)
printMinMax(difnaw,True)

;pull lat and lon for ploting
lat2d = naw_hoy1->XLAT
lon2d = naw_hoy1->XLONG
lat2d2= rm_single_dims(lat2d)
lon2d2= rm_single_dims(lon2d)
dimlc = dimsizes(lat2d2)
nlat = dimlc(0)
nlon = dimlc(1)

;******* plotting*******************

; Output plot location

wks = gsn_open_wks("x11","wind900_00LT")
;gsn_define_colormap (wks, "temp1")

; resources for Prism plot
plot = new(8,graphic)

res= True
res@gsnDraw = False
res@gsnFrame= False

res@cnFillPalette   = "precip_11lev"
;res@cnFillPalette   = "MPL_RdBu"
res@cnFillOn = True    ;color fill
;res@cnFillColors = True
res@cnFillMode       = "RasterFill"       ; Raster Mode
res@cnRasterSmoothingOn = True
res@cnLinesOn = False   ; contour lines
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;res@gsnSpreadColors = True     ;use total colormap
res@lbLabelBarOn = True ;individual label bar
res@cnLevelSelectionMode = "ManualLevels"       ; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = .01                ; set the minimum contour level for Prism
res@cnMaxLevelValF  = .1              ; set the maximum contour level for Prism
res@cnLevelSpacingF = .01 

res@gsnAddCyclic        = False
res@mpGridAndLimbOn        = False
res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
res@mpGridAndLimbOn      = True          ; default is every 15 deg
res@mpGridSpacingF       = 4            ; change to match labels
res@mpGridLineColor      = "LightGrey"
res@tmXTOn                 = False
res@tmYROn               = False              ; no right tickmarks
res@gsnRightString  = ""
;res@gsnLeftString = "Temperature at 2m"

res@gsnStringFontHeightF = 0.025
res@lbLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02


res@mpLimitMode = "Corners"  ;choose range of map
res@mpLeftCornerLatF       = lat2d2(0,0)
res@mpLeftCornerLonF       = lon2d2(0,0)
res@mpRightCornerLatF      = lat2d2(nlat-1,nlon-1)
res@mpRightCornerLonF      = lon2d2(nlat-1,nlon-1)
res@tfDoNDCOverlay         = True
res@mpCenterLonF           = nac_hoy@CEN_LON
res@mpCenterLatF           = nac_hoy@CEN_LAT
res@mpProjection           = "LambertConformal"
res@mpLambertParallel1F    = nac_hoy@TRUELAT1
res@mpLambertParallel2F    = nac_hoy@TRUELAT2
res@mpLambertMeridianF     = nac_hoy@STAND_LON
res@mpOutlineBoundarySets     = "geophysicalandusstates"

res@gsnLeftString = "a) Positive AMO + 2011 LU"
plot(0)= gsn_csm_contour_map(wks,mf_naw_hoy900(2,:,:),res)

res@gsnLeftString = "b) Negative AMO + 2011 LU"
plot(1) = gsn_csm_contour_map(wks,mf_nac_hoy900(2,:,:),res)

res@gsnLeftString = "c) Positive AMO + 1930s LU"
plot(2)= gsn_csm_contour_map(wks,mf_naw_dust900(2,:,:),res)

res@gsnLeftString = "d) Negative AMO + 1930s LU"
plot(3) = gsn_csm_contour_map(wks,mf_nac_dust900(2,:,:),res)


res@cnFillPalette   = "CBR_drywet"

res@cnLevelSelectionMode = "ExplicitLevels"       ; manually set the contour levels with the following 3 resources

res@cnLevels              = (/ -.02,-.01,-.005,-.001,.001,.005,.01,.02 /)
;res@cnMinLevelValF  = -3.                       ; set the minimum contour level
;res@cnMaxLevelValF  = 3.                        ; set the maximum contour level
;res@cnLevelSpacingF = .5                        ; set the interval between contours

; Resources for diference plots
;plot each individual model with its own title

;res@gsnLeftString = "c) Negative AMO - Positive AMO 2011"
;plot(2) = gsn_csm_contour_map(wks,difpre(2,:,:),res)

;res@gsnLeftString = "f) Negative AMO - Positive AMO 1930s"
;plot(5)= gsn_csm_contour_map(wks,difdust(2,:,:),res)

res@gsnLeftString = "g) 1930s - 2011 Positive AMO"
plot(4) = gsn_csm_contour_map(wks,difnaw(2,:,:),res)

res@gsnLeftString = "h) 1930s - 2011 Negative AMO"
plot(5)= gsn_csm_contour_map(wks,difnac(2,:,:),res)

; make the panel plot
pres = True
pres@gsnPanelRowSpec = True                   ; tell panel what order to plt
pres@gsnPanelCenter = False
;pres@txString   = "April 2012"

gsn_panel(wks,plot,(/2,2,2/),pres)

end
