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

# loading shapefile of area of interest (aoi)
area <- shapefile("data/shp_pts_mangos/Cultivos_Mango.shp")
ext  <- extent(area)
data_path <- "D:/Ci_data/TIF_Crop/"
crop_data <- list.files(data_path)

source("credentials.R")

month <- c(paste0("0",1:9),10:12)
for (i in 2010:2021) {
  # i <- 2010
  cat("Datos para:", i,"\n")
  if (i == 2021) {
    month <- month[1:2]
  }
  for (j in month) {
    # j <- month[1]
    cat("Mes:", j,"\n")
    # Setting start and end of download time
    start <- paste0(i, "-", j, "-01")
    end   <- paste0(i, "-", j, ifelse(j == "02", "-28", "-30"))
    # downloading MODIS data using the above parameters
    f <- getModis(product = product, start_date = c("2010-01-01"),
                  end_date = c("2010-12-31"), aoi = ext, download = FALSE,
                  path = data_path, username = user,
                  password = passwd, overwrite = TRUE)
    f <- f[which(str_detect(f, ".h10v09.006.") == TRUE)]
    idx <- which(substr(crop_data, 1, 41) %in% substr(f, 1, 41) == TRUE)
    
    dato <- stack(paste0(data_path, crop_data[idx]))
    alli <- stack(mini(dato), meani(dato), maxi(dato))
    
    if (leap_year(i)) {
      
    }else{
      
    }
    save_name <- paste0("D:/Ci_data/Stat/NDVI_Min_Mean_Max_", i, "_",j, ".tif")
    writeRaster(alli, filename = save_name, format = "GTiff", overwrite = TRUE)

  }
}
