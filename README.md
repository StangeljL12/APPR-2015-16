# Analiza sklenjenih zakonskih zvez v Sloveniji

Avtor: Štangelj Laura

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2015/16.

## Tematika

V projektu bom analizirala sklenitve zakonskih zvez v Sloveniji. Podatke sem dobila na spetni strani Statističnega urada RS. Osredotočila sem bom na sklenitve zakonske zveze glede na regijo prebivališča ženina in neveste, starost ženina in neveste ob prvi sklenitvi zakonske zveze, zakonski stan ženina in neveste pred poroko in na sklenitev zakonske zveze po mesecih.

Povezave do tabel:

    http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=05M2010S&ti=&path=../Database/Dem_soc/05_prebivalstvo/34_Poroke/10_05M20_poroke-RE-OBC/&lang=2 
    http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=05M1016S&ti=&path=../Database/Dem_soc/05_prebivalstvo/34_Poroke/05_05M10_poroke-SL/&lang=2
    http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=05M1008S&ti=&path=../Database/Dem_soc/05_prebivalstvo/34_Poroke/05_05M10_poroke-SL/&lang=2
    http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=05M1012S&ti=&path=../Database/Dem_soc/05_prebivalstvo/34_Poroke/05_05M10_poroke-SL/&lang=2
    
Moj cilj je analizirati različne dejavnike zakonskih zvez v Sloveniji. Kakšne so najpogostejše starosti sklenitve prve zakonske zveze, kateri meseci so najbolj proljubljeni za sklenitev zakonske zveze, ali so bolj pogoste sklenitve zakonskih zvez parov iz istih regij ali iz različnih in pa koliko je takšnih, ki stopajo v zakonsko zvezo morda že drugič ali pa koliko vdovelih ljudi se odloči še enkrat združiti v zakonski stan.
    

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
