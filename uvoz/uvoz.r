# Uvozimo knižnjice
source("lib/libraries.r", encoding = "UTF-8")



#tabela po mesecih


stolpci1 <- c("Leto", "Mesec", "Št.sklenitev")
PoMesecih <-read.csv2("podatki/pomesecih.csv", sep = ";", as.is = TRUE, header = FALSE,
                      col.names = stolpci1, skip = 2, nrows = (372-3), fileEncoding = "cp1250")

#zapolnimo prazne prostore z NA in potem nadomestimo z vrednostmi, ki ji pripradajo:

for (i in stolpci1[-3]){
  PoMesecih[i][PoMesecih[i] == " "] <- NA
  PoMesecih[i] <- na.locf(PoMesecih[i], na.rm = FALSE)
}

#izbrišemo vrstice, ki so NA v zadnjem stolpcu:

PoMesecih <- PoMesecih[!is.na(PoMesecih$Št.sklenitev),]


#Spremenim vrstni red mesecev, da bo pravilen
PoMesecih$Mesec <- factor(PoMesecih$Mesec, levels = 
                  c("Januar", "Februar", "Marec", "April", "Maj", "Junij",
                    "Julij", "Avgust", "September", "Oktober", "November", "December"))


#Leto spremenim v številsko spremenljivko
PoMesecih$Leto <- as.numeric(PoMesecih$Leto)




#tabela po regiji

stolpci2 <- c("Spol", "Regija", "Starost", "Leto", "Število")
Po_Regijah_Letih <- read.csv2("podatki/poregijahinletih.csv", sep = ";", as.is = TRUE,
                              header = FALSE, col.names = stolpci2,
                              skip = 3, nrows = (821-3), fileEncoding = "cp1250")


#Urejanje - NA:

for (i in stolpci2[c(-5)]){
  Po_Regijah_Letih[[i]][Po_Regijah_Letih[i] == " "] <- NA
  Po_Regijah_Letih[[i]] <- na.locf(Po_Regijah_Letih[[i]], na.rm = FALSE)
}


#izbrišemo vrstice, ki so NA v zadnjem stolpcu:

Po_Regijah_Letih <- Po_Regijah_Letih[!is.na(Po_Regijah_Letih$Število),]

Starost <- factor(Po_Regijah_Letih$Starost, levels = 
                  c("Pod 15 let","15-19 let","20-24 let","25-29 let",
                    "30-34 let","35-39 let","40-44 let","45-49 let",
                    "50-54 let","55-59 let","60 ali več let"))
Po_Regijah_Letih$Starost <- Starost

Po_Regijah_Letih$Regija <- as.factor(Po_Regijah_Letih$Regija)






##Naredim novo tabelo iz tabele Po_Regijah_Letih tako da vzamem samo Regije in starostno skupino
Starost_Regije <- Po_Regijah_Letih %>% group_by(Regija, Starost) %>% summarise(Število = sum(Število))

#Tvorim novo tabelo, kjer bo prikazana najbolj pogosta starost za posamezno regijo
Tabela <- data.frame(Regija = levels(Po_Regijah_Letih$Regija), Starost = rep("starost"))

Starost_stopnje <- rep('srednje', length(Tabela$Regija))
Starost <- factor(Starost_stopnje,levels = c('mladi', 'srednje', 'stari'),ordered = TRUE)

Mladi <- c("Pod 15 let", "15-19 let", "20-24 let", "25-29 let")
Srednje <- c("35-39 let", "40-44 let", "45-49 let")
Stari <- c("50-54 let", "55-59 let", "60 ali več let")

for (i in levels(Tabela$Regija)){
  a <- Po_Regijah_Letih %>% group_by(Regija, Starost) %>% summarise(Število = sum(Število)) %>%
    filter(Regija == i, Število == max(Število))
  a <- a$Starost
  Tabela[[i]][Tabela[i] == "starost"] <- a
}

Visina.stopnje <- rep('normalna', length(Umrli_stopnje$Groba.stopnja.umrljivosti))
Stopnja <- factor(Visina.stopnje,levels = c('nizka', 'normalna', 'visoka'),ordered = TRUE)
Stopnja[Umrli_stopnje$Groba.stopnja.umrljivosti <= 1000] <- 'nizka'
Stopnja[Umrli_stopnje$Groba.stopnja.umrljivosti >= 1600] <- 'visoka'
Umrli_stopnje$Stopnja <- Stopnja

#Tabela iz HTML

#link <- "http://www.stat.si/StatWeb/prikazi-novico?id=5241&idp=17&headerbar=15" 


#stran <- html_session(link) %>% read_html(encoding = "UTF-8") 
#tabele <- stran %>% html_nodes(xpath ="//table[@rules='all']") 
#tabela1 <- tabele %>% .[[1]] %>% html_table()  

#names(tabela1)<- tabela1[1,] 
#tabela1 = tabela1[-1,] 
#tabela1 = tabela1[-3,] 
#tabela1 = tabela1[-5,]
#tabela1 = tabela1[-7,]
#tabela1 = tabela1[-10,]
#Encoding(tabela1[[1]]) <- "UTF-8" 
#tabela1[2,1] <- 'Sklenitve zakonskih zvez na 1000 prebivalcev' 
#tabela1[3,1] <- 'Povprečna starost ženina' 
#tabela1[4,1] <- 'Povprečna starost neveste'
#tabela1[5,1] <- 'Povprečna starost ob sklenitvi prve zakonske zveze ženina'
#tabela1[6,1] <- 'Povprečna starost ob sklenitvi prve zakonske zveze neveste'
#tabela1[7,1] <- 'Registrirane istospolne partnerske skupnosti'
#tabela1[8,1] <- 'Registrirane istospolne partnerske skupnosti med miškima'
#tabela1[9,1] <- 'Registrirane istospolne partnerske skupnosti med ženskama'
#tabela1 = tabela1[-10,]
#tabela1 = tabela1[-10,]
#tabela1 = tabela1[-10,]

#tabela1[,2:3] <- apply(tabela1[,2:3], 2, . %>% gsub("\\.", "", .) %>% 
 #                        gsub(",", ".", .) %>% 
  #                       as.numeric()) 




## GRAFI:

#Prvi graf bo prikazoval število sklenitev glede na mesec ter primerjal leti 1990 in 2014
#Najprej leto spremenimo v FAKTOR, da bomo lahko primerjali leto 1990 in leto 2014

PoMesecih$Leto <- as.factor(PoMesecih$Leto)

GRAF1 <- ggplot(filter(PoMesecih, Leto == 1990 | Leto == 2014), aes(x=Mesec, y=Št.sklenitev, fill=Leto)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  labs(title ="Sklenitve zakonskih zvez po mesecih")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))


##Drugi graf narišem glede na starost in spet primerjam leto, ponovno spremenim leto v faktor
Po_Regijah_Letih$Leto <- as.factor(Po_Regijah_Letih$Leto)

GRAF2 <- ggplot(data = group_by(Po_Regijah_Letih,Starost, Leto)
                %>% summarise(Število = sum(Število)),
                aes(x=Starost, y=Število, color=Leto)) + 
  geom_line(aes(color = Leto, group=Leto))+
  labs(title ="Sklenitve zakonskih zvez po starostnih skupinah")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))


##Tortni graf glede na leto, da vidim koliko procentov vseh porok je bilo glede na leto
##Izberem 3 leta: 1990, 2000, 2014
GRAF3 <- ggplot(data = PoMesecih %>% filter(Leto == 1990 |Leto == 2000 |Leto == 2014) %>%
                  group_by(Leto) %>% summarise(Št.sklenitev = sum(Št.sklenitev)),
                aes(x="", y=Št.sklenitev, fill=Leto)) + 
  geom_bar(width = 1,, stat = "identity") + 
  geom_text(aes(y = Št.sklenitev/3 + 
                  c(0, cumsum(Št.sklenitev)[-length(Št.sklenitev)]), 
                label = percent(Št.sklenitev/sum(Št.sklenitev))), size=5)+
  coord_polar(theta = "y")+
  scale_y_continuous(breaks=NULL)+
  theme_minimal()+
  guides(fill=guide_legend(ncol=2, title=NULL))+
  labs(title ="Število sklenitev glede na leto", x="", y="")

##Četrti graf prikazuje poroko glede na starostno skupino - Ženin/Nevesta

GRAF4 <- ggplot(data = group_by(Po_Regijah_Letih, Starost, Spol)
                %>% summarise(Število = sum(Število)),
                aes(x=Starost, y=Število, color=Spol)) + 
  geom_line(aes(color = Spol, group=Spol))+
  labs(title ="Sklenitve zakonskih zvez po starostnih skupinah glede na spol")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))




