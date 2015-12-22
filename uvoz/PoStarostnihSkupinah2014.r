uvozi.PoStarostnihSkupinah2014 <- function() {
  return(read.csv2("podatki/PoStarostnihSkupinah2014.csv", sep = ";", as.is = TRUE,
                   row.names = 1, skip = 4,
                   fileEncoding = "Windows-1250"))
}


PoStarostnihSkupinah2014 <- uvozi.PoStarostnihSkupinah2014()