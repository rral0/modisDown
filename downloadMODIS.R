# loading all dependency packages
pkgs <- c("terra", "luna", "raster")
lapply(pkgs, require, character.only = TRUE)

# product MODIS to download
# product <- "MOD09A1"
product <- "MOD13Q1"

# loading shapefile of area of interest (aoi)
area <- shapefile("data/shape/Cultivos_Mango.shp")
# plot(area)
ext  <- extent(area)

data_path <- "data/"

source("credentials.R")

# Setting start and end of download time
start <- "2021-01-01"
end   <- "2021-01-31"

# downloading MODIS data using the above parameters
f <- getModis(product = product, start_date = start,
              end_date = end, aoi = ext, download = TRUE,
              path = data_path, username = user,
              password = passwd, overwrite = TRUE)
