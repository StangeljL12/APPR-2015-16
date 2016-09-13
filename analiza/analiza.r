# 4. faza: Analiza podatkov

#################### POVEZAVA MED RAZVEZAMI IN POROKAMI ##########################################################

#Naredim novo tabelo porok po letih iz tabele PoMesecih, tako da seštejem število sklenitev
poroke <- PoMesecih
poroke$Leto <- poroke$Leto %>% as.character() %>% as.numeric()
poroke <- poroke %>% filter(Leto > 1994 & Leto < 2014 ) %>% group_by(Leto) %>% summarise(Poroke = sum(Št.sklenitev))
poroke$Leto <- poroke$Leto %>% as.factor

#Sedaj lahko združim tabeli z inner_join

Skupna_tabela <- inner_join(razveze %>% 
                              group_by(Leto) %>%
                              summarise(Ločitve = sum(Razveze)), poroke, by="Leto")


#Narišem graf, ki mi prikazuje število porok in razvez:
GRAF5 <- ggplot(Skupna_tabela, aes(x = Poroke, y = Ločitve)) + 
  geom_point() + geom_smooth() + theme_bw()+
  labs(title = "Ločitve in poroke v Sloveniji")



#Pogledam le za nekaj let
GRAF6 <- ggplot(Skupna_tabela %>% filter(Leto == 1995 | Leto == 2000 | Leto == 2013), 
       aes(x = Poroke, y = Ločitve, col = Leto)) + geom_point(size = 6) + theme_bw()+
  labs(title = "Ločitve in poroke v Sloveniji za 3 leta")

###Naredimo enako še za ZDA, da vidimo če je tam kaj drugače
Skupna_zda <- inner_join(poroke.USA, locitve.USA, by = "Leto") 

GRAF7 <- ggplot(Skupna_zda, aes(x = Poroke, y = Ločitve)) + 
  geom_point() + geom_smooth()+ theme_bw() +
  labs(title = "Ločitve in poroke v ZDA")
  

GRAF8 <- ggplot(Skupna_zda %>% filter(Leto == 2000 | Leto == 2007 | Leto == 2014), 
       aes(x = Poroke, y = Ločitve, col = Leto)) + geom_point(size = 6)+ theme_bw()+
  labs(title = "Ločitve in poroke v ZDA za 3 leta")




################################## GRUPIRANJE ##########################################################

#Naredila bom tabelo, ki bo prikazovala število porok in razvez glede na regijo
data1 <- Po_Regijah_Letih
data1$Leto <- data1$Leto %>% as.character() %>% as.numeric()
data1 <- data1 %>% filter(Leto > 2002 & Leto < 2014 ) %>% group_by(Regija) %>% summarise(Poroke = sum(Število)/2)


data2 <- razveze
data2$Leto <- data2$Leto %>% as.character() %>% as.numeric()
data2 <- data2 %>% filter(Leto > 2002 & Leto < 2014) %>% group_by(Regija) %>% summarise(Razveze = sum(Razveze))


Skupna_regije <- data.frame(inner_join(data1, data2, by = "Regija"))

rownames(Skupna_regije) <- Skupna_regije$Regija
Skupna_regije <- Skupna_regije[,-1]

n <- 4 #REGIJE BOM ZDRUŽILA V 4 SKUPINE

REG.norm <- scale(Skupna_regije,scale=FALSE) #povprečje porok in razvez ter tabela po regijah z odstopanji od povprečja..
k <- kmeans(REG.norm, n, nstart = 1000) #regije razdelim v 4 skupine glede na povprečja
regije <- row.names(Skupna_regije)
m <- match(zemljevid$NAME_1, regije)
zemljevid$skupina <- factor(k$cluster[regije[m]])

##Narišem zemljevid in pobarvam glede na to v kateri skupini je regija

ZEM2 <- ggplot() + 
  geom_polygon(data = pretvori.zemljevid(zemljevid), 
                                aes(x=long, y=lat, group=group, fill=skupina),
                                color = "grey") +
  ggtitle("Regije po skupinah in centeroidi")
  
#Odtranim ozadje
ZEM2 <- ZEM2 + labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()

##Poiščem še centeroide, da jih napišem na zemljevid
razdalje <- apply(k$centers, 1, function(y) apply(REG.norm, 1, function(x) sum((x-y)^2)))
min.razdalje <- apply(razdalje, 2, min)
manj.razdalje <- apply(razdalje, 1, function(x) x == min.razdalje)
najblizje <- apply(manj.razdalje[,apply(manj.razdalje, 2, any)], 2, which)
centeroidi <- names(najblizje)[order(najblizje)]



ZEM2 <- ZEM2+
  geom_text(data = pretvori.zemljevid(zemljevid) %>% 
              filter(NAME_1 %in% centeroidi) %>% 
              group_by(id, NAME_1) %>% 
              summarise(x = mean(long), y = mean(lat)),
            aes(x = x, y = y, label = NAME_1), size = 3)

ZEM2 <- ZEM2+
  geom_point(data = pretvori.zemljevid(zemljevid) %>%
               filter(NAME_1 %in% centeroidi) %>% 
               group_by(id, NAME_1) %>% 
               summarise(x = mean(long), y = mean(lat)+0.05),
             aes(x = x, y = y))

################################## NAPOVEDOVANJE ##########################################################

#Napoved za število porok
poroke$Leto <- poroke$Leto %>% as.character() %>% as.numeric()
LMP <- lm(data = poroke, Poroke ~ Leto)
P <- predict(LMP, data.frame(Leto = (seq(2015, 2025, 1))))

#Napoved za število razvez
razveze$Leto <- razveze$Leto %>% as.character() %>% as.numeric()
LMR <- lm(data = razveze %>% 
            group_by(Leto) %>% 
            summarise(Razveze = sum(Razveze)), Razveze ~ Leto)
R <- predict(LMR, data.frame(Leto = seq(2015, 2025, 1)))

#SKUPAJ NAPOVED TABELA
NAPOVED  <- data.frame("Poroke" = P, "Ločitve" = R, row.names = (2015:2025))