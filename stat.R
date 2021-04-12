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

stat_path  <- "data/Stat/"

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
class(indice_stack)
dim(indice_stack)
names(indice_stack)

month <- c(paste0("0", 1:9), 10:12)
momo <- 1:12
for (i in 2010:2021) {
  # i <- 2010
  index_year_posi <- year_extraction(crop_data_name, i)
  
  cat("Datos para:", i,"\n")
  if (i == 2021) {
    momo <- momo[1:2] # TODO: improve this syntax
  }
  
  for (j in momo) {
    # j <- 1
    cat("Mes:", month[j],"\n")
    
    # names to save
    name_min  <- paste0(stat_path, indice, "/", indice, "_", i, "_",
                        month[j], "_min.tif")
    name_mean <- paste0(stat_path, indice, "/", indice, "_", i, "_",
                        month[j], "_mean.tif")
    name_max  <- paste0(stat_path, indice, "/", indice, "_", i, "_",
                          month[j], "_max.tif")
    
    idx_mes <- idx_month(j, i)
    
    tmp_month <- indice_stack[[index_year_posi[idx_mes]]]

    if (length(idx_mes) != 1) {
      # calc
      minii  <- mini(tmp_month) / 100000000
      meanii <- meani(tmp_month) / 100000000
      maxii  <- maxi(tmp_month) / 100000000
      # save raster
      writeRaster(minii, filename = name_min, format = "GTiff", 
                  overwrite = TRUE)
      writeRaster(meanii, filename = name_mean, format = "GTiff", 
                  overwrite = TRUE)
      writeRaster(maxii, filename = name_max, format = "GTiff", 
                  overwrite = TRUE)
    }else{
      writeRaster(tmp_month, filename = name_min, format = "GTiff", 
                  overwrite = TRUE)
      writeRaster(tmp_month, filename = name_mean, format = "GTiff", 
                  overwrite = TRUE)
      writeRaster(tmp_month, filename = name_max, format = "GTiff", 
                  overwrite = TRUE)
    }
  }
}