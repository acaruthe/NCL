
;Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "./WRFUserARW.ncl"
;;
begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.

  amodern = addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

; We generate plots, but what kind do we prefer?
;  type = "x11"
;   type = "pdf"
;  type = "ps"
; type = "ncgm"
  type = "png"
  wks = gsn_open_wks(type,"modern_landuse")

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are 	in the data set?
  times = wrf_user_getvar(amodern,"times", -1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  do it = 0,ntimes-1, 1             ; TIME LOOP

;    print("Working on time: " + times(it) )
;    res@TimeLabel = times(it)   ; Set Valid time to use on plots


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        

   modern_landuse = wrf_user_getvar(amodern,"LU_INDEX", -1) ;latent heat flux at the surface
	wrf_smooth_2d(modern_landuse,9)


   pre_landuse = wrf_user_getvar(apre, "LU_INDEX", -1)
	wrf_smooth_2d(pre_landuse, 9) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;diffr = modern_flux_lh - pre_flux_lh


    ; Plotting options for T                
 ;     opts = res                         
 ;     opts@cnFillOn = True
 ;     opts@FieldTitle = "Latent Heat Flux (Wm^-2) "
 ;     opts@cnLineColor = "Black"
 ;     opts@cnLineLabelBackgroundColor = -1
     ;opts@gsnContourLineThicknessScale = 2.0  
     ;opts@ContourParameters = (/ -60., 60., 10./)
     ;opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
      

  mpres@mpLimitMode = "Corners" 
  mpres@mpLeftCornerLatF = 34.0 
 mpres@mpLeftCornerLonF = 103.0 
  mpres@mpRightCornerLatF = 37.0 
 mpres@mpRightCornerLonF = 98.0 


nc = 31

res@cnFillOn             = True               ; color Fill
res@cnFillMode           = "RasterFill"       ; Raster Mode
res@cnLinesOn            =  False             ; Turn off contour lines
res@cnLevelSelectionMode = "ExplicitLevels" ; set explict contour levels
res@cnLevels             = ispan(2,nc,1)
res@lbLabelPosition      = "Center"           ; label position
res@lbLabelAlignment     = "BoxCenters"       ; label orientation
res@lbLabelStrings       = ispan(1,nc,1)
res@lbLabelFontHeightF   = 0.009
res@pmLabelBarHeightF    = 0.075
res@mpFillOn             = False
res@pmLabelBarOrthogonalPosF = -.035           ; move whole thing up

;print(modern_landuse(:,12,12))
 
plot = gsn_csm_contour_map(wks, modern_landuse(0,:,:), res) ; create plot
 

      ;contour_lhflux = wrf_contour(amodern,wks,modern_landuse(0,:,:),opts)
     ; delete(opts)


    ; MAKE PLOTS                                       
     ; plot = wrf_map_overlays(amodern,wks,(/contour_lhflux/), pltres, mpres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  end do        ; END OF TIME LOOP

end
