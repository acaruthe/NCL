;   Example script to produce plots for Land Use WRF data 
;   remember to 
; export NCARG_COLORMAPS=/work/rowe/chays/NSF_WRF_CLM/scripts:$NCARG_ROOT/lib/ncarg/colormap
; to use new colormap
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;
; The input file.(monthly or daily)  
; This needs to have a ".nc" appended, so just do it.
  present=addfile("/glade/scratch/acaruth/NSF_CLM/modernday/modern.nc", "r")
  
  a1920s = addfile("/glade/scratch/acaruth/NSF_CLM/1920s/1920s.nc","r")

  apre = addfile("/glade/scratch/acaruth/NSF_CLM/presettle/presettle.nc","r")

  adust = addfile("/glade/scratch/acaruth/NSF_CLM/dust1930s/dustbowl.nc","r")

  

  lu_present_raw = wrf_user_getvar(present, "LU_INDEX", -1)
 

  lu_present = lu_present_raw

do j = 0,dimsizes(lu_present_raw(0,:,0))-1
	do k = 0,dimsizes(lu_present_raw(0,0,:))-1
		if (lu_present_raw(0,j,k) .eq. 1) then
				lu_present(0,j,k) = 1
		else if (lu_present_raw(0,j,k) .le. 4) then 
				lu_present(0,j,k) = 2
		else 
				lu_present(0,j,k) = lu_present_raw(0,j,k)-2
		end if
		end if
	end do 
end do  
  	
  lu_1920s_raw = wrf_user_getvar(a1920s, "LU_INDEX", -1)
  
  lu_1920s = lu_1920s_raw
  
  do j = 0,dimsizes(lu_1920s_raw(0,:,0))-1
        do k = 0,dimsizes(lu_1920s_raw(0,0,:))-1
                if (lu_1920s_raw(0,j,k) .eq. 1) then
                                lu_1920s(0,j,k) = 1
                else if (lu_1920s_raw(0,j,k) .le. 4) then
                                lu_1920s(0,j,k) = 2
                else
                                lu_1920s(0,j,k) = lu_1920s_raw(0,j,k)-2
                end if
                end if
        end do
end do
 

  lu_pre_raw = wrf_user_getvar(apre, "LU_INDEX", -1)

  lu_pre = lu_pre_raw 
do j = 0,dimsizes(lu_pre_raw(0,:,0))-1
        do k = 0,dimsizes(lu_pre_raw(0,0,:))-1
                if (lu_pre_raw(0,j,k) .eq. 1) then
                                lu_pre(0,j,k) = 1
                else if (lu_pre_raw(0,j,k) .le. 4) then
                                lu_pre(0,j,k) = 2
                else
                                lu_pre(0,j,k) = lu_pre_raw(0,j,k)-2
                end if
                end if
        end do
end do

  lu_dust_raw = wrf_user_getvar(adust, "LU_INDEX", -1)
  
  lu_dust = lu_dust_raw

do j = 0,dimsizes(lu_dust_raw(0,:,0))-1
        do k = 0,dimsizes(lu_dust_raw(0,0,:))-1
                if (lu_dust_raw(0,j,k) .eq. 1) then
                                lu_dust(0,j,k) = 1
                else if (lu_dust_raw(0,j,k) .le. 4) then
                                lu_dust(0,j,k) = 2
                else
                                lu_dust(0,j,k) = lu_dust_raw(0,j,k)-2
                end if
                end if
        end do
end do



  landuse = (/lu_pre(0,:,:), lu_1920s(0,:,:), lu_dust(0,:,:), lu_present(0,:,:)/)

; We generate plots, but what kind do we prefer? 
;type = "x11"
 type    = "png"
;  type = "pdf"
;  type = "ps"
; type = "ncgm"
; change this for graphic label of year and output filenames
  iyear=2007
  wks = gsn_open_wks(type,"../../plots/landuse")
; Set some basic resources

basic_colors = (/"Black", "White","Red", "Orange", \
                  "Yellow","Green","Blue","Violet"/)
		  
  res = True
  pltres = True
  mpres = True
  res@gsnFrame        = False                    ; don't advance frame yet
  res@gsnDraw         = False                    
  res@mpGeophysicalLineColor = "Black"
  res@mpNationalLineColor    = "Black"
  res@mpUSStateLineColor     = "Black"
  res@mpGridLineColor        = "Black"
  res@mpLimbLineColor        = "Black"
  res@mpPerimLineColor       = "Black"
  res@cnFillOn =True
  res@cnFillMode ="CellFill"
  
  res@mpOutlineBoundarySets="AllBoundaries"
  res@gsnSpreadColors       = True            ; Use full range of colormap.
  res@gsnSpreadColorStart    = 2            ; default, skip BG & FG colors
  res@gsnSpreadColorEnd      = -8           ; skip merged basic colors
  res@cnLinesOn             = False            ; turn off contour lines
  res@cnLineLabelsOn        = False            ; turn off contour labels 
  res@pmTickMarkDisplayMode  = "Always"         ; turn on tickmarks

 ; res@tiMainString = "Present Day Vegetation"
 ; res@tmYLLabelFontHeightF = 0.014
 ; res@tmXBLabelFontHeightF = 0.014
 ; res@tmYLLabelFontHeightF = 0.014
 ; res@gsnLeftString = ""
 ; res@gsnRightString = ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; general map resources
  res@tfDoNDCOverlay         = True             ; native mapping    
  
  res@mpLimitMode            = "Corners"        ; use model grid corners
 

; get domain-specific mapping parameters from input file
  if (isatt(present,"MAP_PROJ")) then
    proj_names = (/ "", "LambertConformal", "Stereographic", "Mercator" /)
    proj_num = present@MAP_PROJ
    res@mpProjection = proj_names(proj_num)
    print ("proj_num = "+proj_num)
  else
    print ("no MAP_PROJ attribute")
  end if
  
m = (/0,1,2,3/)

letters  = (/"Pre-settlement", "1920s", "Dust Bowl", "Modern Day"/)

month_string = stringtochar(letters)

plots = new (4, graphic)

do ii = 0,0
   istart = 0 + ii*3
    iend = istart+3
    iplot = 0
do i = istart, iend
year = m(i)

scen = month_string(i,:)

  lat2d = present->XLAT(0,:,:)         ; read 2-d array of grid point latitude
  lon2d = present->XLONG(0,:,:)        ; read 2-d array of grid point longitude

  griddim = dimsizes(lat2d)
  ng = griddim(0)
  mg = griddim(1)
; get new color map  
  coltbl ="landuse"
  raw = asciiread(""+coltbl(0)+".rgb",-1,"string")
   lines = raw(2:18)
   print(lines)
   dims = dimsizes(lines)
   nc = dims(0)
   ;print(nc)
   nclass = ispan(1,nc,1)
   ;print(nclass)
   catname  = nclass+" "+str_right_strip(str_get_cols(lines,15,60))
   ;print(catname)
   catname(0:8) = " "+catname(0:8)
 ;print("before")
   gsn_merge_colormaps(wks,coltbl(0),basic_colors)
 ;print("after")  
   ;gsn_draw_colormap(wks)

  res@mpLeftCornerLatF       = lat2d(0,0)
  res@mpLeftCornerLonF       = lon2d(0,0)
  res@mpRightCornerLatF      = lat2d(ng-1,mg-1)
  res@mpRightCornerLonF      = lon2d(ng-1,mg-1)
   if (proj_num .eq. 1) then
  res@mpCenterLonF           = present@CEN_LON
  res@mpCenterLatF           = present@CEN_LAT
  res@mpLambertParallel1F    = present@TRUELAT1
  res@mpLambertParallel2F    = present@TRUELAT2
  res@mpLambertMeridianF     = present@STAND_LON
 end if
 if (proj_num .eq. 3) then
  res@mpLimitMode            = "Corners"
 end if

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    print(dimsizes(landuse))
    T2=landuse(year,:,:)
     print ("Minimum="+min(T2) + "   Maximum="+max(T2))
     
 ;set after finding max and min for variable 
   res@cnFillOn             = True               ; color Fill 
   res@cnFillMode           = "RasterFill"       ; Raster Mode
   res@cnLinesOn            =  False             ; Turn off contour lines
   res@cnLevelSelectionMode = "ExplicitLevels" ; set explict contour levels
   res@cnLevels             = ispan(2,18,1)
   res@lbLabelBarOn         = False
   res@tmXTLabelsOn = False               ; Turn on labels for top and right
   res@tmYRLabelsOn = False              ; axes. They are off by default.	
   
   res@tiMainString = ""+scen
   res@tmXBLabelFontHeightF = 0.015
   res@tmYLLabelFontHeightF = 0.015

   
	 ; MAKE PLOTS     
         
  plots(iplot) = gsn_csm_contour_map(wks,T2,res)
     iplot = iplot +1
   
; draw(plot)
;  frame(wks)                                     ; now advance frame
 
  delete (T2)
  end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;panel time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    pnlres                            = True
   ; pnlres@txString                   = "Vegetation "
   ; pnlres@txFontHeightF               = 0.025
    pnlres@gsnPanelYWhiteSpacePercent = 5       ; Add white space b/w plots.
    pnlres@gsnPanelLabelBar           = True    ; Turn on common labelbar
    pnlres@lbLabelAutoStride          = True    ; Spacing of lbar labels.
    pnlres@lbLabelPosition            = "Center"
    pnlres@lbLabelAlignment           = "BoxCenters"
    pnlres@lbLabelStrings             = ispan(1,18,1)
    pnlres@lbLabelFontHeightF         = 0.010
    pnlres@lbBoxMinorExtentF          = 0.5
    pnlres@gsnPanelFigureStrings= (/"a)","b)","c)","d)"/) ; add strings to panel
  pnlres@amJust   = "TopLeft"
    gsn_panel(wks,(/plots/),(/2,2/),pnlres)

end do


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



end
 
