library(raster)
list_data <- list.files("D:/Ci_data/TIF/", full.names = T, pattern = "*.tif")
datos <- stack(list_data)
# nlayers(datos)
# dim(datos)
plot(datos[[1]])
e <- drawExtent()
save(e, file = "e_test.RData")
all <- crop(datos, e)

# writeRaster(all, filename = "all_data_crop.tif", format = "GTiff", 
#             overwrite = TRUE)
nombre <- paste0("D:/Ci_data/TIF_Crop/", names(all), "_crop.tif")
writeRaster(all, filename = nombre, bylayer = TRUE, format = "GTiff")