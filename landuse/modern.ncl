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
  present=addfile("/glade/scratch/acaruth/NSF_CLM/modernday/wrfinput_d02.nc", "r")
  
; We generate plots, but what kind do we prefer? 
;type = "x11"
 type    = "png"
;  type = "pdf"
;  type = "ps"
; type = "ncgm"
; change this for graphic label of year and output filenames
  iyear=2007
  wks = gsn_open_wks(type,"../plots/modern_landuse_notext")
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
 ; gsn_define_colormap(wks,"gsn_merge_colormaps")
   res@gsnSpreadColors       = True            ; Use full range of colormap.
 res@gsnSpreadColorStart    = 2            ; default, skip BG & FG colors
 res@gsnSpreadColorEnd      = -8           ; skip merged basic colors

  res@cnLinesOn             = False            ; turn off contour lines
  res@cnLineLabelsOn        = False            ; turn off contour labels 
   res@pmTickMarkDisplayMode  = "Always"         ; turn on tickmarks

res@tiMainString = "Present Day Vegetation"
  res@tmYLLabelFontHeightF = 0.014
  res@tmXBLabelFontHeightF = 0.014
 res@tmYLLabelFontHeightF = 0.014
res@gsnLeftString = ""
res@gsnRightString = ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  

  lat2d = present->XLAT(0,:,:)         ; read 2-d array of grid point latitude
  lon2d = present->XLONG(0,:,:)        ; read 2-d array of grid point longitude

  griddim = dimsizes(lat2d)
  ng = griddim(0)
  mg = griddim(1)
; get new color map  
  coltbl ="landuse"
  raw = asciiread(""+coltbl(0)+".rgb",-1,"string")
   lines = raw(2:20)
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

  
  ;var_default=default->LU_INDEX
  var_present=present->LU_INDEX
  
  
   ;printVarSummary (var_default)
   printVarSummary (var_present)
  ;print ("Minimum="+min(var_default) + "   Maximum="+max(var_default))
   print ("Minimum="+min(var_present) + "   Maximum="+max(var_present))
   
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; 
  
    
    T2=var_present(0,:,:)
     print ("Minimum="+min(T2) + "   Maximum="+max(T2))
     
 ;set after finding max and min for variable 
   res@cnFillOn             = True               ; color Fill 
   res@cnFillMode           = "RasterFill"       ; Raster Mode
   res@cnLinesOn            =  False             ; Turn off contour lines
   res@cnLevelSelectionMode = "ExplicitLevels" ; set explict contour levels
   res@cnLevels             = ispan(2,20,1)
   res@lbLabelPosition      = "Center"           ; label position
   res@lbLabelAlignment     = "BoxCenters"       ; label orientation
   res@lbLabelStrings       = ispan(1,20,1)  
   res@lbLabelFontHeightF   = 0.009
   res@pmLabelBarHeightF    = 0.075
   res@mpFillOn             = False
   res@pmLabelBarOrthogonalPosF = -.035           ; move whole thing up
  
        res@cnInfoLabelOn        = False
       res@cnConstFLabelOn      = False
        res@cnFillOn             = True


 res@tmXTLabelsOn = False               ; Turn on labels for top and right
  res@tmYRLabelsOn = False              ; axes. They are off by default.	
	 ; MAKE PLOTS     
         
        
  plot = gsn_csm_contour_map(wks,T2,res)
     
;    rtxt                      = True
;    rtxt@txJust               = "CenterLeft"
;    rtxt@txFontHeightF        = 0.005

;    n  = -1
;    xx = 0.10
;    do ncol=0,5
;     yy = 0.15
;     do nrow=0,toint(nc/6)
;      n = n+1
;      if (n .lt. nc) then
;       gsn_text_ndc (wks,catname(n),xx,yy,rtxt)
;      end if
;      yy = yy - 1.7*rtxt@txFontHeightF
;     end do
;     xx = xx + 0.150
;   end do
   
 draw(plot)
  frame(wks)                                     ; now advance frame
 
  delete (T2)

   
  end 
  
 
