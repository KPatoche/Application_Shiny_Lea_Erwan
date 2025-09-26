library(tidyverse)
library(maps)
library(readr)
library(RColorBrewer)
library(sf)

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

url <- "https://france-geojson.gregoiredavid.fr/repo/regions.geojson"
regions <- st_read(url)

colnames(regions)[2]<- "nom_region"

regions$nom_region[regions$nom_region == 'Auvergne-Rhône-Alpes'] <- 'AUVERGNE-RHÔNE-ALPES'
regions$nom_region[regions$nom_region == 'Bourgogne-Franche-Comté'] <- 'BOURGOGNE-FRANCHE-COMTÉ'
regions$nom_region[regions$nom_region == 'Bretagne'] <- 'BRETAGNE'
regions$nom_region[regions$nom_region == 'Centre-Val de Loire'] <- 'CENTRE-VAL DE LOIRE'
regions$nom_region[regions$nom_region == 'Corse'] <- 'CORSE'
regions$nom_region[regions$nom_region == 'Grand Est'] <- 'GRAND EST'
regions$nom_region[regions$nom_region == 'Guadeloupe'] <- 'GUADELOUPE'
regions$nom_region[regions$nom_region == 'Guyane'] <- 'GUYANE'
regions$nom_region[regions$nom_region == 'Hauts-de-France'] <- 'HAUTS-DE-FRANCE'
regions$nom_region[regions$nom_region == 'Île-de-France'] <- 'ÎLE-DE-FRANCE'
regions$nom_region[regions$nom_region == 'La réunion'] <- 'LA RÉUNION'
regions$nom_region[regions$nom_region == 'Martinique'] <- 'MARTINIQUE'
regions$nom_region[regions$nom_region == 'Normandie'] <- 'NORMANDIE'
regions$nom_region[regions$nom_region == 'Nouvelle-Aquitaine'] <- 'NOUVELLE-AQUITAINE'
regions$nom_region[regions$nom_region == 'Occitanie'] <- 'OCCITANIE'
regions$nom_region[regions$nom_region == 'Pays de la Loire'] <- 'PAYS DE LA LOIRE'
regions$nom_region[regions$nom_region == "Provence-Alpes-Côte d'Azur"] <- "PROVENCE-ALPES-CÔTE D'AZUR"

france_dep_data <- left_join(regions,france_dep_data,by=join_by(nom_region))

View(france_dep_data)

france_dep_data %>% 
  filter(année_publication==2023) %>% 
  ggplot(aes(x=long,y=lat,group=group,fill=nom_region))+ 
  geom_polygon(col="white")

france_dep_data$code <- NULL
france_dep_data$subregion <- NULL