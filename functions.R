year_extraction <- function(x) {
  posi <- unlist(str_locate_all(pattern ='A20', x[1])) + 1
  anio <- substr(x, posi[1], (posi[2] + 1))
  return(anio)
}

ndvi_posi <- function(x, patron = "NDVI") {
  posi <- str_locate_all(pattern = patron, x)
  posi_find <- unlist(lapply(posi, length))
  posi_tmp <- which(posi_find == 2)
  return(posi_tmp)
}