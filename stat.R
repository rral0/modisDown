# rm(list = ls(all.names = T))
# changing the working directory (need rstudioapi package)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# rstudioapi: only under RStudio IDE
cat("Working directory: ", getwd())

# loading all dependency packages
pkgs <- c("terra", "luna", "raster", "stringr", "lubridate")
lapply(pkgs, require, character.only = TRUE)

source("functions.R")

# product MODIS to download
product <- "MOD13Q1"

data_path <- "D:/Ci_data/TIF_Crop/"
crop_data_name <- list.files(data_path)
to_read <- paste0(data_path, crop_data_name)
month <- c(paste0("0",1:9),10:12)
momo <- 1:12
for (i in 2010:2021) {
  # i <- 2010
  index_year_posi <- year_extraction(crop_data_name, i)
  
  cat("Datos para:", i,"\n")
  if (i == 2021) {
    momo <- momo[1:2] # TODO: improve this syntax
  }
  
  for (j in momo) {
    # j <- 10
    cat("Mes:", month[j],"\n")
    
      name_min  <- paste0("D:/Ci_data/Stat/monthly/min/NDVI_", i, "_",
                          month[j], "_min.tif")
      name_mean <- paste0("D:/Ci_data/Stat/monthly/mean/NDVI_", i, "_",
                          month[j], "_mean.tif")
      name_max  <- paste0("D:/Ci_data/Stat/monthly/max/NDVI_", i, "_",
                          month[j], "_max.tif")
      
    # stack
    if (length(idx_month(j, i)) != 1) {
      tmp_month <- stack(to_read[index_year_posi[idx_month(j, i)]])
      # calc
      minii  <- mini(tmp_month)
      meanii <- meani(tmp_month)
      maxii  <- maxi(tmp_month)
      # names
      
      # save raster
      writeRaster(minii, filename = name_min, format = "GTiff", overwrite = TRUE)
      writeRaster(meanii, filename = name_mean, format = "GTiff", overwrite = TRUE)
      writeRaster(maxii, filename = name_max, format = "GTiff", overwrite = TRUE)
    }else{
      tmp_month <- raster(to_read[index_year_posi[idx_month(j, i)]])
      
      writeRaster(tmp_month, filename = name_min, format = "GTiff", overwrite = TRUE)
      writeRaster(tmp_month, filename = name_mean, format = "GTiff", overwrite = TRUE)
      writeRaster(tmp_month, filename = name_max, format = "GTiff", overwrite = TRUE)
    }
  }
}