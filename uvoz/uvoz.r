#tabela po mesecih

uvozi.PoMesecih <- function() {
  return(read.csv2("podatki/PoMesecih.csv", sep = ";", as.is = TRUE,
                   #row.names = 1, 
                   skip = 2,
                   col.names=c("Leto", "SKUPAJ", "Januar", "Februar", "Marec", "April", "Maj", "Junij", "Julij", "Avgust", "September", "Oktober", "November", "December"),
                   fileEncoding = "Windows-1250"))
}


PoMesecih <- uvozi.PoMesecih()

#tabela po regiji

uvozi.PoRegijiPrebivalisca2014 <- function() {
  return(read.csv2("podatki/PoRegijiPrebivalisca2014.csv", sep = ";", as.is = TRUE,
                   row.names = 1, skip = 4,
                   fileEncoding = "Windows-1250"))
}


PoRegijiPrebivalisca2014 <- uvozi.PoRegijiPrebivalisca2014()

#tabela po starosti

uvozi.PoStarostnihSkupinah2014 <- function() {
  return(read.csv2("podatki/PoStarostnihSkupinah2014.csv", sep = ";", as.is = TRUE,
                   row.names = 1, skip = 4,
                   fileEncoding = "Windows-1250"))
}


PoStarostnihSkupinah2014 <- uvozi.PoStarostnihSkupinah2014()