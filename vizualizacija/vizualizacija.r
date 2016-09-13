# 3. faza: Izdelava zemljevida

source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
library(ggplot2)
library(dplyr)


# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", encoding = "UTF-8")


# Preuredimo podatke, da jih bomo lahko izrisali na zemljevid.

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}


ZEM <- pretvori.zemljevid(zemljevid)


##Spremenim imena regij v tabeli Po_Regijah_Letih, da se bodo skladali z imeni zemljevida

#Naredim zemljevid, ki prikazuje število sklenjenih zakonskih zvez glede na regijo
ZEM_1 <- ggplot() + geom_polygon(data = group_by(Po_Regijah_Letih, Regija) 
                                           %>% summarise(Število = sum(Število)/2) %>%
                                             right_join(ZEM, by = c("Regija" = "NAME_1")),
                                           aes(x = long, y = lat, group = group, fill = Število),
                                           color = "darkgrey") +
  scale_fill_gradient(low =  "white", high ="red")+
  guides(fill = guide_colorbar(title = "Število sklenitev")) +
  ggtitle("Število sklenitev po regijah")

#IMENA REGIJ
ZEM_1 <- ZEM_1 +
  geom_text(data = ZEM %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
            aes(x = x, y = y, label = NAME_1), size = 2.5)
#OZADJE
ZEM_1 <- ZEM_1 +
  labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()


