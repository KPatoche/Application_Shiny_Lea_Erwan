library(tidyverse)
library(maps)
library(readr)

france_dep <- map_data(map = "france")
colnames(france_dep)[5]<- "nom_departement"
france_dep$nom_departement <- tolower(france_dep$nom_departement)

france_dep$nom_departement[france_dep$nom_departement == 'corse du sud'] <- 'corse-du-sud'


dta <- read_delim("logements-et-logements-sociaux-dans-les-departements.csv", 
                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
dta <- dta[,-31]



dta$nom_departement <- iconv(dta$nom_departement,to="ASCII//TRANSLIT")
dta$nom_departement <- str_remove(dta$nom_departement,"'")
dta$nom_departement <- tolower(dta$nom_departement)




france_dep_data <- left_join(france_dep,dta)



france_dep_data %>% 
  filter(année_publication==2023) %>% 
  ggplot(aes(x=long,y=lat,group=group,fill=nom_departement))+ 
  geom_polygon(col="white")

