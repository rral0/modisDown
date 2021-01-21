# checking the path where the file is located and
# changing the working directory (need rstudioapi package)
current_wd <- dirname(rstudioapi::getActiveDocumentContext()$path)
# rstudioapi: only under RStudio IDE
setwd(current_wd)

# loading all dependency packages
pkgs <- c("terra", "luna", "geodata", "raster", "stringr")
lapply(pkgs, require, character.only = TRUE)

# product MODIS to download
# product <- "MOD09A1"
product <- "MOD13Q1"

# Setting start and end of download time
start <- "2000-01-01"
end   <- "2020-12-31"

# loading shapefile of area of interest (aoi)
area <- shapefile("shape/Cultivos_Mango.shp")
# plot(area)
ext  <- extent(area)

data_path <- "data/"

source("credentials.R")

# downloading MODIS data using the above parameters
f <- getModis(product = product,
              start_date = start, end_date = end,
              aoi = ext, download = TRUE,
              path = data_path, username = user,
              password = passwd, overwrite = TRUE)

# Reading the downloaded data (HDF format)
# All *.hdf files are in data/MOD13Q1/ directory

all_files <- list.files("data/MOD13Q1", pattern = "*.hdf",
                        full.names = T)

source("functions.R")

years <- 2000:2020
list_years <- year_extraction(all_files, 'A20')

# extract and write only the NDVI layers
for (i in years) {
  idx_tmp <- which(i == list_years)
  data_tmp <- rast(all_files[idx_tmp])
  only_ndvi <- ndvi_posi(names(data_tmp))
  data_tmp <- data_tmp[[only_ndvi]]
  names(data_tmp)
  name_file <- paste0("data/MOD13Q1_Only_NDVI_", i, ".tif")
  writeRaster(data_tmp, filename = name_file, format = "GTiff",
                overwrite = TRUE)
}

# time series extraction from NDVI data
lista_only_NDVI <- list.files("data/", pattern = "MOD13Q1_Only_NDVI_*",
                              full.names = T)
apilado <- stack(lista_only_NDVI)
ts_NDVI <- extract(apilado, area)

# check
# View(test)
plot(ts_NDVI[1,], type = "b")

# saving time series table
save(ts_NDVI, file = "data/ts_NDVI.RData")