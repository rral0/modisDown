# rm(list = ls(all.names = T))
# changing the working directory (need rstudioapi package)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# rstudioapi: only under RStudio IDE
cat("Working directory: ", getwd())

# loading all dependency packages
pkgs <- c("terra", "raster", "stringr", "lubridate")
lapply(pkgs, require, character.only = TRUE)

source("functions.R")

data_path <- "data/TIF_crop/"

indice <- "EVI"

stat_path_all  <- "data/Stat/All/"

crop_data_name <- list.files(data_path)
cuantos <- length(crop_data_name) * 6

to_read <- paste0(data_path, crop_data_name)

if (indice == "NDVI") {
  aaa <- 1
}else{
  aaa <- 2
}

indice_posi <- seq(aaa, cuantos, 6)

indice_stack <- stack(to_read)[[indice_posi]]

minii  <- mini(indice_stack) / 100000000
meanii <- meani(indice_stack) / 100000000
maxii  <- maxi(indice_stack) / 100000000
sdii   <- sdi(indice_stack) / 100000000

plot(minii)
plot(meanii)
plot(maxii)
plot(sdii)

min_name <- paste0(stat_path_all, indice, "_2010_to_2021_min.tif")
mean_name <- paste0(stat_path_all, indice, "_2010_to_2021_mean.tif")
max_name <- paste0(stat_path_all, indice, "_2010_to_2021_max.tif")
sd_name <- paste0(stat_path_all, indice, "_2010_to_2021_sd.tif")

writeRaster(minii, filename = min_name, format = "GTiff", 
            overwrite = TRUE)
writeRaster(meanii, filename = mean_name, format = "GTiff", 
            overwrite = TRUE)
writeRaster(maxii, filename = max_name, format = "GTiff", 
            overwrite = TRUE)
writeRaster(sdii, filename = sd_name, format = "GTiff", 
            overwrite = TRUE)
