library(tidyverse)
library(maps)
library(readr)
library(RColorBrewer)

france_dep <- map_data(map = "france")
colnames(france_dep)[5]<- "nom_departement"
france_dep$nom_departement <- tolower(france_dep$nom_departement)

france_dep$nom_departement[france_dep$nom_departement == 'corse du sud'] <- 'corse-du-sud'


dta <- read_delim("logements-et-logements-sociaux-dans-les-departements.csv", 
                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
dta <- dta[,-31]
colnames(dta)[6:30] <- c("habitants","densite_km2","variation_10ans","sold_naturel","solde_migra","pop_inf20","pop_sup60",
                         "tx_chomage_T4","tx_pauvrete","nb_logements","nb_res_princ","tx_log_sociaux","tx_log_vac",
                         "tx_log_ind","moy_nvl_constru_10ans","nb_construction","social_nb_logements","social_location","social_demoli",
                         "social_ventes_physiques","social_vacants","social_individuel","social_loyer_m2","social_age_moyen","social_tx_energivores") 


dta$nom_departement <- iconv(dta$nom_departement,to="ASCII//TRANSLIT")
dta$nom_departement <- str_remove(dta$nom_departement,"'")
dta$nom_departement <- tolower(dta$nom_departement)

france_dep_data <- left_join(france_dep,dta,by=join_by(nom_departement))

france_dep_data %>% 
  filter(année_publication==2023) %>% 
  ggplot(aes(x=long,y=lat,group=group,fill=nom_departement))+ 
  geom_polygon(col="white")

