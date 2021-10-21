########## Written by Nelson Buainain 
#### https://github.com/nnbuainain

"Script to plot ancestral coefficient from programs such as sNMF and STRUCTURE 
in maps"


##make sure you have all these packages installed

## load packages
library(maps)
library(plotrix)
library(mapdata)
library(sp)
library('raster')
library('rgdal')

## read geographic coordinates and ancestry coefficient files

### First round of SNMf, all samples together, k=6

gps <- read.csv("coords/coords.csv", header = TRUE,sep=";",dec=",")
k6 <- read.csv("anc_coef/snmf_1round.csv", header = TRUE,sep=";",dec=",")

### This is a second round of SNMf performed only with samples from Central 
### America to find substructure

gps.amc <- read.csv("coords/coords_amc.csv", header = TRUE,sep=";",dec=",")
amc <- read.csv("anc_coef/snmf_amc.csv", header = TRUE,sep=";",dec=",")  

### This is a second round of SNMf performed only with samples from Eastern 
### Amazonia to find substructure

gps.eas <- read.csv("coords/coords_eas_amz.csv", header = TRUE,sep=";",dec=",")
eas <- read.csv("anc_coef/snmf_eas_amz.csv", header = TRUE,sep=";",dec=",")  


### Load Shape files to construct map and define projection
countries <- shapefile("shapes/countries.shp")
projection(countries) <- CRS("+proj=longlat +datum=WGS84")

### Load the species distribution shape which is split in 2 files
distribution <- shapefile("shapes/tunchiornis_shape_1.shp/")
projection(distribution) <- CRS("+proj=longlat +datum=WGS84")
distribution2 <- shapefile("shapes/tunchiornis_shape_2.shphp")
projection(distribution2) <- CRS("+proj=longlat +datum=WGS84")

### Load a river shapefile if you would like to

rivers <- shapefile("shapes/SouthAmericaRivers.shp")
projection(rivers) <- CRS("+proj=longlat +datum=WGS84")

##### GRAPHIC SECTION 

### plot the map, you might have to adjust the axis to the geographic region
### you are in

plot(countries,axes=TRUE, cex.axis= 0.9, col = "white", xlim=c(-95,-45),ylim=c(-15,18), lwd = 0.7)
cinza<-adjustcolor("lightgray",alpha=0.6)
plot(distribution, add=T, lwd=0.03,col=cinza)
plot(distribution2, add=T, lwd=0.03,col=cinza)
plot(rivers, add=T, lwd=0.03,alpha=0.06,col="gray")
map.scale(x=-55,y=-18,ratio=FALSE,relwidth=0.10,cex=0.5)
library("GISTools")
north.arrow(xb=-40,yb=3,len=0.4,lab="N")
detach(package:GISTools)

### Define a colorblind friendly pallete with nice aesthetics to color the pie charts
cbbPalette_tunch <- c("#000000", "#D55E00", "#009E73", "#CC79A7", "#999999", "#0072B2")
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
amc.palette<-c("#000000","#F0E442")
eas.palette<-c("white","#0072B2")

# Plot the ancestral coeffient pie charts

### First Round
## K6
for (x in 1:nrow(gps))  {
  floating.pie(gps$Lon[x], gps$Lat[x], c(k6$K1[x], k6$K2[x],k6$K3[x],k6$K4[x],k6$K5[x],k6$K6[x]), radius = k6$Num[x]/13, col = c(cbbPalette_tunch))
}

### To see substructure observed in the second round of snmf
### plot the other round over the first one, otherwise, skip this part

###amc
for (x in 1:nrow(gps.amc))  {
  floating.pie(gps.amc$Lon[x], gps.amc$Lat[x], c(amc$K1[x], amc$K2[x]), radius = amc$Num[x]/13, col = c(amc.palette))
}

###eas
for (x in 1:nrow(gps.eas))  {
  floating.pie(gps.eas$Lon[x], gps.eas$Lat[x], c(eas$K1[x], eas$K2[x]), radius = eas$Num[x]/13, col = c(eas.palette))
}


### To save maps in eps format start with the following line:

cairo_ps("figures/k6_color_tunch.eps",width=7,height=7)

### Type all the graphic section from the script again and finish with dev.off()

dev.off()
