library(knitr) 
library(ggplot2) 
require(dplyr) 
library(rvest) 
require(gsubfn) 
library(maptools)
library(sp)
library(digest)
library(MASS)
require(zoo)
library(mgcv)
library(magrittr)
library(httr)
library(scales)

# Uvozimo funkcije za delo z datotekami XML.
source("lib/xml.r", encoding = "UTF-8")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")