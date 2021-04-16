maxi  <- function(x) calc(x, fun = max, na.rm = T) 
mini  <- function(x) calc(x, fun = min, na.rm = T)
meani <- function(x) calc(x, fun = mean, na.rm = T)
sdi   <- function(x) calc(x, fun = sd, na.rm = T)

subsi <- function(x, n=1,m=0){
  substr(x, nchar(x)-n-m+1, nchar(x)-m)
}

year_extraction <- function(x, i) {
  posi <- stringr::str_detect(x, paste0("MOD13Q1.A", i))
  anio <- which(posi == TRUE)
  return(anio)
}

band_interest <- function(x, patron) {
  posi <- stringr::str_locate_all(pattern = patron, x)
  posi_find <- unlist(lapply(posi, length))
  posi_tmp <- which(posi_find == 2)
  return(posi_tmp)
}

idx_month <- function(monty, i){
  mm <- switch(monty,
               ene = c(1, 2),
               feb = c(3, 4),
               mar = c(5, 6),
               abr = c(7, 8),
               may = c(9, 10),
               jun = c(11, 12),
               jul = c(13, 14),
               ago = c(15, 16),
               set = c(17, 18),
               # ---------------------------------
               # TODO: improve this syntax
               oct = if (lubridate::leap_year(i)){
                 oct <- c(19, 20)
               }else{
                 oct <- 19
               },
               nov = if (lubridate::leap_year(i)){
                 oct <- 21
               }else{
                 oct <- c(20, 21)
               },
               # ---------------------------------
               dic <- c(22, 23)
  )
  return(mm)
}

to_mat <- function(x, name_pts){
  x %>% unlist() %>% matrix(nrow = 134) %>% 
    ts(start = c(2010, 01), frequency = 12) %>% 
    `colnames<-`(name_pts)
}

to_mat1 <- function(x, name_pts){
  x %>% unlist() %>% matrix(nrow = 132) %>% 
    ts(start = c(2010, 01), frequency = 12) %>% 
    `colnames<-`(name_pts)
}

to_prom <- function(x){
  prome <- x %>% apply(1, mean) %>% ts(start = c(2010, 01), 
                                       frequency = 12)
  return(prome)
}

# idx_seasonal <- function(seaso, i){
#   seas <- switch(seaso,
#                  winter = c(1:5) ,
#                  spring = c(6:11) ,
#                  summer = c(12:17) ,
#                  autumn = c(18:23) 
#                  )
#   return(seas)
# }
