maxi  <- function(x) calc(x, max, na.rm = T) 
mini  <- function(x) calc(x, min, na.rm = T)
meani <- function(x) calc(x, fun = mean, na.rm = T)

subsi <- function(x, n=1,m=0){
  substr(x, nchar(x)-n-m+1, nchar(x)-m)
}

year_extraction <- function(x) {
  posi <- unlist(str_locate_all(pattern ='A20', x[1])) + 1
  anio <- substr(x, posi[1], (posi[2] + 1))
  return(anio)
}

band_interest <- function(x, patron) {
  posi <- str_locate_all(pattern = patron, x)
  posi_find <- unlist(lapply(posi, length))
  posi_tmp <- which(posi_find == 2)
  return(posi_tmp)
}
