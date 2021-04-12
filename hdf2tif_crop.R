# changing the working directory (need rstudioapi package)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# rstudioapi: only under RStudio IDE
cat("Working directory: ", getwd())

# loading all dependency packages
pkgs <- c("terra", "raster")
lapply(pkgs, require, character.only = TRUE)

# All *.hdf files are in D:/Ci_data/HDF/ directory
input_path  <- "D:/Ci_data/HDF/"
output_path <- "D:/Ci_data/TIF/"
files_name  <- list.files(input_path, pattern = "*.hdf")
name_save   <- gsub(".hdf", ".tif", files_name)

full_path  <- paste0(input_path, files_name)

# extract and write only the NDVI and EVI layers
# index <- c(1:2) # NDVI, EVI
index <- 1 # NDVI
for (i in seq_len(length(full_path))) {
  cat("Proceso en: ", i, "\n")
  data_tmp  <- rast(full_path[i])[[index]] / 100000000
  name_file <- paste0(output_path, name_save[i])
  writeRaster(data_tmp, filename = name_file, format = "GTiff", 
              overwrite = TRUE)
}
