; 

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

; Calculate meridional flux moisture (q*v) vertically integrated 

; read in files and variables from 4 models

;nac_dust = addfile("./nac_dust_00.nc","r")
;nac_hoy  = addfile("./nac_pre_95.nc","r")
;naw_hoy  = addfile("./naw_pre_95.nc","r")
;naw_dust = addfile("./naw_dust_95.nc","r")

nac_dust = addfile("../hour_nac_dust95_mjj.nc","r")
nac_hoy  = addfile("../hour_nac_old95_mjj.nc","r")
naw_hoy  = addfile("../hour_naw_old95_mjj.nc","r")
naw_dust = addfile("../hour_naw_dust95_mjj.nc","r")

;nac_dust0 = addfile("../hour_nac_dust00_jja.nc","r")
;nac_hoy0  = addfile("../hour_nac_pre00_jja.nc","r")
;naw_hoy0  = addfile("../hour_naw_pre00_jja.nc","r")
;naw_dust0 = addfile("../hour_naw_dust00_jja.nc","r")

naw_hoy1  = addfile("../hour_naw_pre95_jja.nc","r")

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

PSFCnac_hoy   = wrf_user_getvar(nac_hoy,"PSFC",it)
PSFCnac_dust  = wrf_user_getvar(nac_dust,"PSFC",it)      ;
PSFCnaw_hoy   = wrf_user_getvar(naw_hoy,"PSFC",it)       ;
PSFCnaw_dust  = wrf_user_getvar(naw_dust,"PSFC",it)      ;

; Horizontally interpolate to pressure coordinates ("p")
  pressure = 850.   ; 850 hPa

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

Qnac_hoy_plane_700  = wrf_user_intrp3d(Qnac_hoy,Pnac_hoy,"h",700.,0.,False)
Qnac_dust_plane_700 = wrf_user_intrp3d(Qnac_dust,Pnac_dust,"h",700.,0.,False)
Qnaw_hoy_plane_700  = wrf_user_intrp3d(Qnaw_hoy,Pnaw_hoy,"h",700.,0.,False)
Qnaw_dust_plane_700 = wrf_user_intrp3d(Qnaw_dust,Pnaw_dust,"h",700.,0.,False)

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

Vnac_hoy_plane_700  = wrf_user_intrp3d(Vnac_hoy,Pnac_hoy,"h",700.,0.,False)
Vnac_dust_plane_700 = wrf_user_intrp3d(Vnac_dust,Pnac_dust,"h",700.,0.,False)
Vnaw_hoy_plane_700  = wrf_user_intrp3d(Vnaw_hoy,Pnaw_hoy,"h",700.,0.,False)
Vnaw_dust_plane_700 = wrf_user_intrp3d(Vnaw_dust,Pnaw_dust,"h",700.,0.,False)                                    

;****************************************************************************************

flux_nac_hoy_plane_700 = Vnac_hoy_plane_700 * Qnac_hoy_plane_700 
flux_nac_hoy_plane_750 = Vnac_hoy_plane_750 * Qnac_hoy_plane_750
flux_nac_hoy_plane_800 = Vnac_hoy_plane_800 * Qnac_hoy_plane_800
flux_nac_hoy_plane_850 = Vnac_hoy_plane_850 * Qnac_hoy_plane_850
flux_nac_hoy_plane_900 = Vnac_hoy_plane_900 * Qnac_hoy_plane_900
flux_nac_hoy_plane_950 = Vnac_hoy_plane_950 * Qnac_hoy_plane_950
flux_nac_hoy_plane_1000 = Vnac_hoy_plane_1000 * Qnac_hoy_plane_1000

flux_naw_hoy_plane_700 = Vnaw_hoy_plane_700 * Qnaw_hoy_plane_700
flux_naw_hoy_plane_750 = Vnaw_hoy_plane_750 * Qnaw_hoy_plane_750
flux_naw_hoy_plane_800 = Vnaw_hoy_plane_800 * Qnaw_hoy_plane_800
flux_naw_hoy_plane_850 = Vnaw_hoy_plane_850 * Qnaw_hoy_plane_850
flux_naw_hoy_plane_900 = Vnaw_hoy_plane_900 * Qnaw_hoy_plane_900
flux_naw_hoy_plane_950 = Vnaw_hoy_plane_950 * Qnaw_hoy_plane_950
flux_naw_hoy_plane_1000 = Vnaw_hoy_plane_1000 * Qnaw_hoy_plane_1000

flux_nac_dust_plane_700 = Vnac_dust_plane_700 * Qnac_dust_plane_700
flux_nac_dust_plane_750 = Vnac_dust_plane_750 * Qnac_dust_plane_750
flux_nac_dust_plane_800 = Vnac_dust_plane_800 * Qnac_dust_plane_800
flux_nac_dust_plane_850 = Vnac_dust_plane_850 * Qnac_dust_plane_850
flux_nac_dust_plane_900 = Vnac_dust_plane_900 * Qnac_dust_plane_900
flux_nac_dust_plane_950 = Vnac_dust_plane_950 * Qnac_dust_plane_950
flux_nac_dust_plane_1000 = Vnac_dust_plane_1000 * Qnac_dust_plane_1000

flux_naw_dust_plane_700 = Vnaw_dust_plane_700 * Qnaw_dust_plane_700
flux_naw_dust_plane_750 = Vnaw_dust_plane_750 * Qnaw_dust_plane_750
flux_naw_dust_plane_800 = Vnaw_dust_plane_800 * Qnaw_dust_plane_800
flux_naw_dust_plane_850 = Vnaw_dust_plane_850 * Qnaw_dust_plane_850
flux_naw_dust_plane_900 = Vnaw_dust_plane_900 * Qnaw_dust_plane_900
flux_naw_dust_plane_950 = Vnaw_dust_plane_950 * Qnaw_dust_plane_950
flux_naw_dust_plane_1000 = Vnaw_dust_plane_1000 * Qnaw_dust_plane_1000

;*****************************************************************************************

; pre-allocate space
flux_naw_dust  = new ( (/8,7,384,450/), float)
flux_nac_dust  = new ( (/8,7,384,450/), float)
flux_naw_hoy   = new ( (/8,7,384,450/), float)
flux_nac_hoy   = new ( (/8,7,384,450/), float)

flux_naw_dust(:,0,:,:) = flux_naw_dust_plane_1000
flux_naw_dust(:,1,:,:) = flux_naw_dust_plane_950 
flux_naw_dust(:,2,:,:) = flux_naw_dust_plane_900
flux_naw_dust(:,3,:,:) = flux_naw_dust_plane_850 
flux_naw_dust(:,4,:,:) = flux_naw_dust_plane_800
flux_naw_dust(:,5,:,:) = flux_naw_dust_plane_750 
flux_naw_dust(:,6,:,:) = flux_naw_dust_plane_700

flux_nac_dust(:,0,:,:) = flux_nac_dust_plane_1000
flux_nac_dust(:,1,:,:) = flux_nac_dust_plane_950 
flux_nac_dust(:,2,:,:) = flux_nac_dust_plane_900
flux_nac_dust(:,3,:,:) = flux_nac_dust_plane_850
flux_nac_dust(:,4,:,:) = flux_nac_dust_plane_800
flux_nac_dust(:,5,:,:) = flux_nac_dust_plane_750
flux_nac_dust(:,6,:,:) = flux_nac_dust_plane_700 

flux_nac_hoy(:,0,:,:) = flux_nac_hoy_plane_1000
flux_nac_hoy(:,1,:,:) = flux_nac_hoy_plane_950
flux_nac_hoy(:,2,:,:) = flux_nac_hoy_plane_900
flux_nac_hoy(:,3,:,:) = flux_nac_hoy_plane_850
flux_nac_hoy(:,4,:,:) = flux_nac_hoy_plane_800
flux_nac_hoy(:,5,:,:) = flux_nac_hoy_plane_750
flux_nac_hoy(:,6,:,:) = flux_nac_hoy_plane_700

flux_naw_hoy(:,0,:,:) = flux_naw_hoy_plane_1000
flux_naw_hoy(:,1,:,:) = flux_naw_hoy_plane_950
flux_naw_hoy(:,2,:,:) = flux_naw_hoy_plane_900
flux_naw_hoy(:,3,:,:) = flux_naw_hoy_plane_850
flux_naw_hoy(:,4,:,:) = flux_naw_hoy_plane_800
flux_naw_hoy(:,5,:,:) = flux_naw_hoy_plane_750
flux_naw_hoy(:,6,:,:) = flux_naw_hoy_plane_700


flux_naw_hoy!0 = "time"
flux_naw_hoy!2 = "lat"
flux_naw_hoy!3 = "lon"
flux_naw_hoy!1 = "lev"

flux_nac_hoy!0 = "time"
flux_nac_hoy!2 = "lat"
flux_nac_hoy!3 = "lon"
flux_nac_hoy!1 = "lev"

flux_naw_dust!0 = "time"
flux_naw_dust!2 = "lat"
flux_naw_dust!3 = "lon"
flux_naw_dust!1 = "lev"

flux_nac_dust!0 = "time"
flux_nac_dust!2 = "lat"
flux_nac_dust!3 = "lon"
flux_nac_dust!1 = "lev"

;********************************************************************************

lev = (/100000.,95000.,90000.,85000.,80000.,75000.,70000./)
lev@units = "Pa"

mse_naw_dust = -(flux_naw_dust(:,2,:,:) - flux_naw_dust(:,0,:,:))/900.-1000.

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
  dpnac_hoy   = dpres_plevel(lev, PSFCnac_hoy, ptop, 0)
  dpnaw_hoy   = dpres_plevel(lev, PSFCnaw_hoy, ptop, 0)
  dpnac_dust  = dpres_plevel(lev, PSFCnac_dust, ptop, 0)
  dpnaw_dust  = dpres_plevel(lev, PSFCnaw_dust, ptop, 0)

  mfnac_hoy = flux_nac_hoy*dpnac_hoy          ; temporary variable
  copy_VarCoords(Qnac_hoy, mfnac_hoy)

  mfnaw_hoy = flux_naw_hoy*dpnaw_hoy          ; temporary variable
  copy_VarCoords(Qnaw_hoy, mfnaw_hoy)

  mfnac_dust = flux_nac_dust*dpnac_dust          ; temporary variable
  copy_VarCoords(Qnac_dust, mfnac_dust)

  mfnaw_dust = flux_naw_dust*dpnaw_dust          ; temporary variable
  copy_VarCoords(Qnaw_dust, mfnaw_dust) 

                        ; integrate vertically [level dimension = 1]
  MFnac_hoy   = dim_sum_n_Wrap( mfnac_hoy,1 )   ; LE(ntim,nlat,mlon)
  IMFnac_hoy  = (1/GR)*MFnac_hoy     ; (time,lat,lon)
  copy_VarCoords(PSFCnac_hoy, IMFnac_hoy)
  IMFnac_hoy@long_name = "MOISTURE FLUX:  SUM[Q*V*dp]/g"
  IMFnac_hoy@units     = "kg/ms"

  MFnaw_hoy   = dim_sum_n_Wrap( mfnaw_hoy,1 )   ; LE(ntim,nlat,mlon)
  IMFnaw_hoy  = (1/GR)*MFnaw_hoy     ; (time,lat,lon)
  copy_VarCoords(PSFCnaw_hoy, IMFnaw_hoy)
  IMFnaw_hoy@long_name = "MOISTURE FLUX:  SUM[Q*V*dp]/g"
  IMFnaw_hoy@units     = "kg/ms"

  MFnac_dust   = dim_sum_n_Wrap( mfnac_dust,1 )   ; LE(ntim,nlat,mlon)
  IMFnac_dust  = (1/GR)*MFnac_dust     ; (time,lat,lon)
  copy_VarCoords(PSFCnac_dust, IMFnac_dust)
  IMFnac_dust@long_name = "MOISTURE FLUX:  SUM[Q*V*dp]/g"
  IMFnac_dust@units     = "kg/ms"

  MFnaw_dust   = dim_sum_n_Wrap( mfnaw_dust,1 )   ; LE(ntim,nlat,mlon)
  IMFnaw_dust  = (1/GR)*MFnaw_dust     ; (time,lat,lon)
  copy_VarCoords(PSFCnaw_dust, IMFnaw_dust)
  IMFnaw_dust@long_name = "MOISTURE FLUX:  SUM[Q*V*dp]/g"
  IMFnaw_dust@units     = "kg/ms"

;print(MFnaw_dust)
;exit()

;----------------------------------------------------------------------
; Zoom in 35 N by using getind_latlon2d to
; retrieve closest index values to the given lat/lon box that encloses
; these two states.
;
; You cannot use "{" and "}" for coordinate subscripting, because
; lat2d and lon2d are not 1D coordinate arrays.
;----------------------------------------------------------------------
  lat_min =   34.9
  lat_max =   35.1
  lon_min = -105.
  lon_max = -92.
  ij      = getind_latlon2d(lat2d,lon2d,(/lat_min,lat_max/),(/lon_min,lon_max/))

;---Store to local variables for better code readability
  ilat1 = ij(0,0)
  ilat2 = ij(1,0)
  ilon1 = ij(0,1)
  ilon2 = ij(1,1)

;---Subscript variables using these index values
  MFnaw_dust_sub  = MFnaw_dust(:,ilat1:ilat2,ilon1:ilon2)     ; 6 x 30 x 21
  MFnac_dust_sub  = MFnac_dust(:,ilat1:ilat2,ilon1:ilon2)
  MFnaw_hoy_sub  = MFnaw_hoy(:,ilat1:ilat2,ilon1:ilon2)     ; 6 x 30 x 21
  MFnac_hoy_sub  = MFnac_hoy(:,ilat1:ilat2,ilon1:ilon2)

  lat2d_sub = lat2d(ilat1:ilat2,ilon1:ilon2)      ; 30 x 21
  lon2d_sub = lon2d(ilat1:ilat2,ilon1:ilon2)      ; 30 x 21

;---Print information about the new variables
  printVarSummary(MFnac_hoy_sub)
  printVarSummary(lat2d_sub)
  printVarSummary(lon2d_sub)
  printMinMax(lat2d_sub,0)
  printMinMax(lon2d_sub,0)

;***************************************************

MFnaw_dust_sub1 = dim_avg_n_Wrap(MFnaw_dust_sub, (/1,2/))
MFnac_dust_sub1 = dim_avg_n_Wrap(MFnac_dust_sub, (/1,2/))
MFnaw_hoy_sub1  = dim_avg_n_Wrap(MFnaw_hoy_sub, (/1,2/))
MFnac_hoy_sub1  = dim_avg_n_Wrap(MFnac_hoy_sub, (/1,2/))

print(MFnaw_dust_sub1)
print(MFnac_dust_sub1)
print(MFnaw_hoy_sub1)
print(MFnac_hoy_sub1)

 alist = [/MFnaw_hoy_sub1, MFnaw_dust_sub1, MFnac_hoy_sub1, MFnac_dust_sub1/]

 header = (/"--------------------------------", \
            "MFnaw_hoy_sub1, MFnaw_dust_sub1, MFnac_hoy_sub1, MFnac_dust_sub1", \
            "--------------------------------"/)
 footer = (/"--------------------------------", \
            "MJJ 1995 1000-top", \
            "--------------------------------"/)

 hlist = [/header/]
 flist = [/footer/]

 write_table("cuadro_00_top_pre_v3.txt", "w", hlist, "%s")
 write_table("cuadro_00_top_pre_v3.txt", "a", alist, "%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f")
 write_table("cuadro_00_top_pre_v3.txt", "a", flist, "%s")

 
exit()

;*****************************************************

; plotting

; Output plot location
diro= "/work/hu/jtorres/project/climatechange2016/"
filo= "fig_expo_c"

wks = gsn_open_wks("x11",diro+filo)
;gsn_define_colormap (wks, "temp1")

;setvalues NhlGetWorkspaceObjectId() 
;    "wsMaximumSize": 1500000000 
;end setvalues 

; resources for Prism plot
plot = new(4,graphic)

resa              = True
;res@gsnMaximize  = True     ; Maximize plot in frame.
resa@gsnDraw   = False
resa@gsnFrame  = False

resa@vpWidthF  = 0.75            ; Set width and height of plot.
resa@vpHeightF = 0.5

resa@tmXTOn                = False
resa@tmYROn                = False
resa@tmXBMinorOn           = False
resa@tmYLMinorOn           = False
resa@tmYRMinorOn           = False

;---Further customize the legend
resa@trYMinF                = -1.      ; Leave space at bottom for legend
resa@trYMaxF                = 11
resa@trXMinF                = -1
resa@trXMaxF                = 8

resa@cnSmoothingOn = True 

resa@tmXBMode   = "Explicit"
resa@tmXBValues = (/0,1,2,3,4,5,6,7/)     ; choose first 13 timesteps
resa@tmXBLabels = (/" 00 LT"," 03 LT"," 06 LT"," 09 LT", \
                    " 12 LT"," 15 LT"," 18 LT"," 21 LT"/)
resa@tmXBLabelFontHeightF = 0.013

resa@tmYLMode   = "Explicit"
resa@tmYLValues = (/0,2,4,6,8,10/)     ; choose first 13 timesteps
resa@tmYLLabels = (/" 30N"," 32N"," 34N"," 36N", \
                    " 38N"," 40N"/)
resa@tmYLLabelFontHeightF = 0.013

resa@gsnContourZeroLineThicknessF = 2.5 	  ; doubles thickness of zero contour
resa@gsnContourNegLineDashPattern = 1     ; sets negative contours to dash pattern 1
resa@cnInfoLabelOn     = False 
resa@cnLineLabelFormat = "#^se"    ; Only one value after decimal point
;resa@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
;resa@cnLevels    = (/ -8E-5, -6E-5, -4E-5, -2E-5, 0, 2E-5, 4E-5, 6E-5, 8E-5/)   ; set levels
resa@cnLineLabelPlacementMode = "constant";"computed"
resa@gsnContourZeroLineThicknessF = 0 	    ; eliminates zero contour
resa@cnLineLabelFontHeightF   = 0.012
;resa@cnLineLabelDensityF      = 2.0  
resa@gsnRightString   = "ms~S~-2~N~"
resa@gsnLeftString    = "a) 1930s - 2011 Positive AMO "
plot(0) = gsn_csm_contour(wks, naw, resa)

resa@gsnLeftString    = "b) 1930s - 2011 Negative AMO"
resa@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
resa@cnLevels    = (/ -8E-5, -6E-5, -4E-5, -2E-5, 0, 2E-5, 4E-5, 6E-5, 8E-5/)   ; set levels
plot(1) = gsn_csm_contour(wks, nac, resa)


;resa@cnLevels    = (/  -7E-5, -5E-5, -2E-5, 0, 2E-5, 5E-5, 7E-5/)   ; set levels
resa@gsnLeftString    = "c) Negative AMO - Positive AMO 2011"
plot(2) = gsn_csm_contour(wks, present, resa)

resa@gsnLeftString   = "d) Negative AMO - Positive AMO 1930s"
plot(3) = gsn_csm_contour(wks, dust, resa)

; make the panel plot
pres = True
pres@gsnPanelRowSpec = True                   ; tell panel what order to plt
pres@gsnPanelCenter = True
pres@gsnMaximize         = True
;pres@txString   = "JJA (1991-1998)"

gsn_panel(wks,plot,(/2,2/),pres)



end
