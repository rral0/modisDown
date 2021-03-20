setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat("Working directory: ", getwd())
# rm(list = ls(all.names = T))

library(tidyverse)
library(raster)
library(sf)

# time series extraction from NDVI data
lista_data <- list.files("D:/Ci_data/Stat/", pattern = "*.tif",
                              full.names = T)
apilado <- stack(lista_data)
nlayers(apilado)
dim(apilado)

# loading shapefile of area of interest (aoi)
palta <- shapefile("data/mango_palta/Tile_Palta.shp")
mango <- shapefile("data/mango_palta/Tile_Mango.shp")

plot(apilado[[1]])
e <- drawExtent()
save(e, file = "area_mas_peque.RData")
data <- crop(data, e)
plot(data[[1]])

plot(mango, add = T, border = "red", lwd = 2)
plot(palta, add = T, border = "purple", lwd = 2)

ts_palta <- as.matrix(extract(data, palta))
ts_mango <- as.matrix(extract(data, mango))
ts_mango[1,]

# strsplit(names.reads,'-')

View(ts_palta)
class(test$geometry)

# check
# View(test)
idx_min  <- seq(1, 402, 3)
idx_mean <- seq(2, 402, 3)
idx_max  <- seq(3, 402, 3)

plot(ts_NDVI[1,idx_mean], type = "b")
plot(ts_NDVI[1,idx_max], type = "b")

# saving time series table
save(ts_NDVI, file = "data/ts_NDVI.RData")

load("data/ts_NDVI.RData")
ls()
View(ts_NDVI)
plot(ts(ts_NDVI[1,idx_mean], start = c(2010,01), frequency = 12), type = "b")

length(ts_NDVI[1,idx_mean])

load("data/ts_NDVI.RData")
ls()
View(ts_NDVI)

ts_NDVI <- ts_NDVI / 100000000
ts_NDVI %>% apply(1, summary) 
dim(ts_NDVI)
# ts1 <- ts(ts_NDVI[1, 228:480], start = c(2010,01), frequency = 23)
ts1 <- ts(ts_NDVI[1, 389:480], start = c(2020,01), frequency = 23)
plot(ts1, type = "b", ylab = "NDVI", 
     main = "NDVI de cultivo de mango para un píxel \n Periodo: 01/2010 a 12/2020")

# shape puntos mas mango y diferentes cultivos
ls()

write.csv(ts_NDVI[1,idx_min], file = "min.csv")
write.csv(ts_NDVI[1,idx_mean], file = "mean.csv")
write.csv(ts_NDVI[1,idx_max], file = "max.csv")
   