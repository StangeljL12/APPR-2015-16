# 4. faza: Analiza podatkov

podatki1 <- data.frame(PoMesecih %>% group_by(Leto) 
                       %>% summarise(Sklenitve = sum(Št.sklenitev)))

#apoved
LMZ <- lm(data = podatki1, Sklenitve ~ Leto)
Z <- predict(LMZ, data.frame(Leto = seq(2024, 2044, 10)))
