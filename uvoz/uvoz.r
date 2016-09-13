# Uvozimo knižnjice
source("lib/libraries.r", encoding = "UTF-8")

###########################################CSV#############################################


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
                              skip = 3, nrows = (3461-3), fileEncoding = "cp1250")


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


##Uvozim tabelo ločitve:
stolpci3 <- c("Regija", "Leto", "Razveze")
razveze <- read.csv2("podatki/razveze.csv", sep = ";", as.is = TRUE,
                              header = FALSE, col.names = stolpci3,
                              skip = 4, nrows = (244-4), fileEncoding = "cp1250")


#Urejanje - NA:

for (i in stolpci3[c(-3)]){
  razveze[[i]][razveze[i] == " "] <- NA
  razveze[[i]] <- na.locf(razveze[[i]], na.rm = FALSE)
}


#izbrišemo vrstice, ki so NA v zadnjem stolpcu:

razveze <- razveze[!is.na(razveze$Razveze),]

razveze$Leto <- razveze$Leto %>% as.character() %>% as.factor()



###########################################HTML#############################################
link <- "http://www.cdc.gov/nchs/nvss/marriage_divorce_tables.htm" 
stran <- html_session(link) %>% read_html(encoding = "UTF-8") 

tabele <- stran %>% html_nodes(xpath ="//table") 
poroke.USA <- tabele %>% .[[1]] %>% html_table()  
locitve.USA <- tabele %>% .[[2]] %>% html_table()  

#Potrebujem le prve dva stolpca
poroke.USA <- poroke.USA[,c(1,2)]
locitve.USA <- locitve.USA[,c(1,2)]

names(poroke.USA) <- c("Leto", "Poroke")
names(locitve.USA) <- c("Leto", "Ločitve")

#V drugem stolpcu moram izbrisati vejice
poroke.USA$Poroke <- poroke.USA$Poroke %>% gsub("\\,", "", .) %>% as.numeric()
locitve.USA$Ločitve <- locitve.USA$Ločitve %>% gsub("\\,", "", .) %>% as.numeric()

#V prvem stolpcu moram poporaviti letnice, saj so se zraven uvozile še opombe kot številke
poroke.USA$Leto <- poroke.USA$Leto %>% substr(1,4) %>% as.factor()
locitve.USA$Leto <- locitve.USA$Leto %>% substr(1,4) %>% as.factor()




################################GRAFI######################################################

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

GRAF2 <- ggplot(data = Po_Regijah_Letih %>% 
                  filter(Leto == "2004" | Leto == "2014") %>%
                  group_by(Starost, Leto) %>%
                  summarise(Število = sum(Število)/2),
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
  geom_bar(width = 1, stat = "identity") + 
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




