uvozi.PoRegijiPrebivalisca2014 <- function() {
  return(read.csv2("podatki/PoRegijiPrebivalisca2014.csv", sep = ";", as.is = TRUE,
                   row.names = 1, skip = 4,
                   fileEncoding = "Windows-1250"))
}


PoRegijiPrebivalisca2014 <- uvozi.PoRegijiPrebivalisca2014()