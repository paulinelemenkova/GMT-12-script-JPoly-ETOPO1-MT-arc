#!/bin/sh
# Purpose: study area square + geometric arcs on the grid raster map ETOPO1 (here: Mariana Trench)
# GMT modules: grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, pstext, psxy, gmtlogo
# Step-1. Generate a file
ps=BathymetryMT.ps
# Step-2. Extract a subset of ETOPO1m for the Mariana Trench area
grdcut earth_relief_01m.grd -R120/160/0/35 -Gmt_relief.nc
# Step-3. Make color palette
gmt makecpt -Cglobe.cpt -V -T-10000/1000 > myocean.cpt
# Step-4. Make raster image
#gmt grdimage mt_relief.nc -Cmyocean.cpt -R120/160/0/30 -JM6i -P -I+a15+ne0.75 -Xc -K > BathymetryMT.ps
gmt grdimage mt_relief.nc -Cmyocean.cpt -R120/160/0/35 -JPoly/6.5i -P -I+a15 -K > $ps
# Step-5. Add legend
gmt psscale -Dg120/0+w6.0i/0.15i+v+o-2.0/0.0i+ml -Rmt_relief.nc -J -Cmyocean.cpt \
	--FONT_LABEL=8p,Helvetica,dimgray \
	--FONT_ANNOT_PRIMARY=5p,Helvetica,dimgray \
	-Baf+l"Topographic color scale" \
	-I0.2 -By+lm -O -K >> $ps
# Step-6. Add shorelines
gmt grdcontour mt_relief.nc -R -J -C1000 -O -K >> $ps
# Step-7. Add grid
gmt psbasemap -R120/160/0/35 -JPoly/6.5i \
    --FORMAT_GEO_MAP=dddF \
    --MAP_FRAME_PEN=dimgray \
    --MAP_FRAME_WIDTH=0.1c \
    --MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    --FONT_TITLE=12p,Palatino-Roman,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=3p \
    --MAP_TITLE_OFFSET=25p \
    --FONT_LABEL=7p,Helvetica,dimgray \
    -Tdx5.7i/0.5i+w0.3i+f2+l+o0.15i \
    -Lx5.5i/-0.5i+c50+w1000k+l"Polyconic projection. Scale (km)"+f \
    -Bxg4f2a4 -Byg4f2a4 \
    -D136/6/154/26r+pthicker,white \
    -B+t"Geometric shape and location of the Mariana Trench. Bathymetry: 1 arc min ETOPO1 Global Relief Model" -U -O -K >> $ps
# Step-8. Add text labels
echo "126 15 Philippine Trench" | gmt pstext -R -J -F+jTL+f10p,Times-Roman,white+a-70 -O -K >> $ps
echo "132 20 Philippine Sea" | gmt pstext -R -J -F+f10p,Times-Roman,white -O -K >> $ps
echo "153 30 Pacific Ocean" | gmt pstext -R -J -F+f10p,Times-Roman,white -O -K >> $ps
echo "140 17.5 Mariana Trench" | gmt pstext -R -J -F+f10p,Times-Roman,white -O -K >> $ps
echo "140 16.5 crescent (red)" | gmt pstext -R -J -F+f10p,Times-Roman,white -O -K >> $ps
# Step-9. Add vector line arrow
gmt psxy -R -J -Sv0.15i+bc+ea -Gyellow -W0.5p,yellow -O -K << EOF >> $ps
140 18 20 3c
EOF
# Step-10. label annotation
gmt psxy -R -J -Wthick -O -K \
    -Sqn1:+f12p,Times-Roman,white+l"Study Area"+v+c5p+pthick,white+o << EOF >> $ps
137 7
152 7
EOF
# # Step-11. круг большой белый
gmt psxy -R -J -Sc -W0.5p,white -O -K << EOF >> $ps
140 18 6c
EOF
# круг внутренний средний желтый
#gmt psxy -R -J -Sc -W0.5p,yellow -O -K << EOF >> $ps
#140 18 4.5c
#EOF
# круг внутренний маленький зеленый
#gmt psxy -R -J -Sc -W0.5p,green -O -K << EOF >> $ps
#140 18 3c
#EOF
# Step-12. math angle arc of the Mariana Trench
gmt psxy -R -J -Sm0.7 -W1.5p,red -O -K -P << EOF >> $ps
140 18 3 -98 65
EOF
# Step-13. Add GMT logo
gmt logo -Dx6.2/-2.2+o0.1i/0.1i+w2c -O >> $ps
