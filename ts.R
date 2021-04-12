rm(list = ls(all.names = T))
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat("Working directory: ", getwd())
# setwd("D:/Desktop/modisDown")
# rm(list = ls(all.names = T))
library(tidyverse)
library(raster)
library(sf)

# indice <- "NDVI"
indice <- "EVI"

# sta    <- "mean"
# sta    <- "max"
sta    <- "min"

# time series extraction from NDVI data
lista_data <- list.files(paste0("data/anom_stand/", indice, "/", sta, "/"),
                          pattern =  ".tif", full.names = T)

apilado   <- stack(lista_data)
dim(apilado)

# loading shapefile of area of interest (aoi)
mango <- shapefile("data/SHP/mango/Tile_Mango.shp")
palta <- shapefile("data/SHP/palta/Tile_Palta.shp")

# plot(apilado[[1]])
#
# plot(mango, add = T, border = "red", lwd = 2)
# plot(palta, add = T, border = "purple", lwd = 2)

ts_mango <- extract(apilado, mango)
ts_palta <- extract(apilado, palta)

# saving time series table
save(ts_mango, file = paste0("data/ts/ts_mango_",indice, "_", sta,
    "_anom_stan.RData"))
save(ts_palta, file = paste0("data/ts/ts_palta_",indice, "_", sta,
    "_anom_stan.RData"))
