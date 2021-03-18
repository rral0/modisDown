rm(list = ls(all.names = T))

library(raster)
list_data <- list.files("D:/Ci_data/TIF/", full.names = T, pattern = "*.tif")
datos <- stack(list_data)
# proj4string(datos)
nlayers(datos)
dim(datos)
plot(datos[[1]])
e <- drawExtent()
load("data/area_mas_peque.RData")

# save(e, file = "e_test.RData")
rasterOptions(progress = 'text', timer = TRUE)

data_crop <- crop(datos, e)
dim(data_crop)
names(data_crop)

nombre <- paste0("D:/Ci_data/TIF_Crop/", names(data_crop), "_crop.tif")
writeRaster(data_crop, filename = nombre, bylayer = TRUE, 
            format = "GTiff", overwrite = TRUE)
