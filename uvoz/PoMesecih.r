uvozi.PoMesecih <- function() {
  return(read.csv2("podatki/PoMesecih.csv", sep = ";", as.is = TRUE,
                   row.names = 1, skip = 2,
                   fileEncoding = "Windows-1250"))
}


PoMesecih <- uvozi.PoMesecih()