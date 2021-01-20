install.packages(c("remotes", "rstudioapi"), dep = T)

remotes::install_github("rspatial/terra")
remotes::install_github("rspatial/luna")
remotes::install_github("datasketch/geodata")

current_wd <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_wd)

# load package
pkgs <- c("terra", "luna", "geodata", "raster")
lapply(pkgs, require, character.only = TRUE)

# product to download
product <- "MOD09A1"
# product <- "MOD13Q1"

start <- "2010-01-01"
end <- "2020-12-31"

area <- shapefile("shape/Cultivos_Mango.shp")
ext <- extent(area)

data_path <- "data/"

source("credentials.R")

f <- getModis(product = product,
              start_date = start, end_date = end,
              aoi = ext, download = TRUE, 
              path = data_path, username = user, 
              password = passwd, overwrite = TRUE)
f