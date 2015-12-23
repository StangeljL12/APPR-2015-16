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

#Tabela iz HTML

link <- "http://www.stat.si/StatWeb/prikazi-novico?id=5241&idp=17&headerbar=15" 


stran <- html_session(link) %>% read_html(encoding = "UTF-8") 
tabele <- stran %>% html_nodes(xpath ="//table[@rules='all']") 
tabela1 <- tabele %>% .[[1]] %>% html_table()  

names(tabela1)<- tabela1[1,] 
tabela1 = tabela1[-1,] 
tabela1 = tabela1[-3,] 
tabela1 = tabela1[-5,]
tabela1 = tabela1[-7,]
tabela1 = tabela1[-10,]
Encoding(tabela1[[1]]) <- "UTF-8" 
tabela1[2,1] <- 'Sklenitve zakonskih zvez na 1000 prebivalcev' 
tabela1[3,1] <- 'Povprečna starost ženina' 
tabela1[4,1] <- 'Povprečna starost neveste'
tabela1[5,1] <- 'Povprečna starost ob sklenitvi prve zakonske zveze ženina'
tabela1[6,1] <- 'Povprečna starost ob sklenitvi prve zakonske zveze neveste'
tabela1[7,1] <- 'Registrirane istospolne partnerske skupnosti'
tabela1[8,1] <- 'Registrirane istospolne partnerske skupnosti med miškima'
tabela1[9,1] <- 'Registrirane istospolne partnerske skupnosti med ženskama'
tabela1 = tabela1[-10,]
tabela1 = tabela1[-10,]
tabela1 = tabela1[-10,]

tabela1[,2:3] <- apply(tabela1[,2:3], 2, . %>% gsub("\\.", "", .) %>% 
                         gsub(",", ".", .) %>% 
                         as.numeric()) 
