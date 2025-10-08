library(tidyverse)
library(maps)
library(readr)
library(RColorBrewer)
library(sf)
library(Factoshiny)
library(ggrepel)
library(readxl)
library(corrplot)


#### Importation de la carte ####
france_dep <- map_data(map = "france")
colnames(france_dep)[5]<- "nom_departement"

#Mise en forme des nom de départements
france_dep$nom_departement <- tolower(france_dep$nom_departement)
france_dep$nom_departement[france_dep$nom_departement == 'corse du sud'] <- 'corse-du-sud'

#### Importation des données ####

dta <- read_delim("logements-et-logements-sociaux-dans-les-departements.csv", 
                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
dta <- dta[,-31]
#Rename des colonnes pour plus de clarté
colnames(dta)[6:30] <- c("habitants","densite_km2","variation_10ans","sold_naturel","solde_migra","pop_inf20","pop_sup60",
                         "tx_chomage","tx_pauvrete","nb_logements","nb_res_princ","tx_log_sociaux","tx_log_vac",
                         "tx_log_ind","moy_nvl_constru_10ans","nb_construction","social_nb_logements","social_location","social_demoli",
                         "social_ventes_physiques","social_vacants","social_individuel","social_loyer_m2","social_age_moyen","social_tx_energivores") 
#Modification des données en accord avec les informations sur les données (données sur l'année N-2)
dta$année_publication <- dta$année_publication - 2
#Mise en forme des noms de départements
dta$nom_departement <- iconv(dta$nom_departement,to="ASCII//TRANSLIT")
dta$nom_departement <- str_remove(dta$nom_departement,"'")
dta$nom_departement <- tolower(dta$nom_departement)

#Decalage des taux de pauvrete (N-3)
dta <- dta %>% 
  arrange(code_departement,desc(année_publication)) %>% 
  mutate(tx_pauvrete = lag(tx_pauvrete))

#Decalage du nombre de logement total (N-3)
dta <- dta %>% 
  arrange(code_departement,desc(année_publication)) %>% 
  mutate(nb_logements = lag(nb_logements))

#### Importation des taux de pauvrete en 2021 ####
Taux_pauvrete_2021 <- read_excel("Taux_pauvrete_2021.xlsx")

Taux_pauvrete_2021$Departement <- iconv(Taux_pauvrete_2021$Departement,to="ASCII//TRANSLIT")
Taux_pauvrete_2021$Departement <- str_remove(Taux_pauvrete_2021$Departement,"'")
Taux_pauvrete_2021$Departement <- tolower(Taux_pauvrete_2021$Departement)
colnames(Taux_pauvrete_2021)[2:3] <- c("nom_departement","pauvrete_2021")

#### Importation nombre de logements total en 2021 ####
Logement_2021 <- read_excel("departement_2021_nb_logements.xlsx")
colnames(Logement_2021) <- c("code_departement","logement_2021")


#Ajout des tx de pauvrete 2021 au jeu de données global
dta <- dta %>% 
  left_join(Taux_pauvrete_2021) %>% 
  mutate(tx_pauvrete = ifelse(année_publication==2021,pauvrete_2021,tx_pauvrete)) %>% 
  select(-pauvrete_2021)
  
dta <- dta %>% 
  filter(!(code_departement %in% c("971","972","973","974")))

#Ajout des logements 2021 

dta <- dta %>% 
  left_join(Logement_2021) %>% 
  mutate(nb_logements = ifelse(année_publication==2021,logement_2021,nb_logements)) %>% 
  select(-logement_2021)
  
dta$année_publication <- as.factor(dta$année_publication)

dta <- dta %>% 
  group_by(nom_departement) %>% 
  mutate(variation_loyer = 100*(social_loyer_m2[année_publication==2021]-social_loyer_m2[année_publication==2016])/social_loyer_m2[année_publication==2016])

#### Fusion données sociales et carte ####
france_dep_data <- left_join(france_dep,dta,by=join_by(nom_departement))

#Création de la carte
# france_dep_data %>% 
#   filter(année_publication==2017) %>% 
#   ggplot(aes(x=long,y=lat,group=group,fill=nom_departement))+ 
#   geom_polygon(col="white")

#Exemple sur année 2017
# dta %>% 
#   filter(année_publication==2017) %>% 
#   ggplot(aes(x=tx_pauvrete,y=tx_log_sociaux,label=code_departement)) +
#   geom_point() + geom_text_repel()


#Imporation carte des régions
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

# france_dep_data %>% 
#   filter(année_publication==2023) %>% 
#   ggplot(aes(x=long,y=lat,group=group,fill=nom_region))+ 
#   geom_polygon(col="white")

france_dep_data$code <- NULL
france_dep_data$subregion <- NULL

dta_moy <- dta %>%
  group_by(nom_departement) %>% 
  summarise(across(5:31, mean, na.rm = TRUE))


labels <- c("Nombre d'habitants","Densité (km2)","Variation population sur 10 ans","Solde naturel","Solde migratoire",
            "Pourcentage population < 20ans","Pourcentage population > 60 ans","Taux de chômage","Taux de pauvreté","Nombre de logements",
            "Nombre résidences principales","Taux de logements sociaux","Taux de logements vacants","Taux de logements individuels",
            "Nombre construction moyenne sur 10 ans","Nombre de construction","Nombre de logements sociaux","Location en logements sociaux",
            "Logements sociaux démolis","Nombre de logements sociaux vendus","Nombre logements sociaux vacants","Nombre logements sociaux individuels",
            "Loyer logement sociaux (m2)","Age moyen logements sociaux","Taux de logements sociaux énergivores")


cor_matrix <- cor(dta_moy[ , -c(1,27,28)], use = "pairwise.complete.obs", method = "pearson")
cor_matrix
corrplot(cor_matrix)

truc <- dta[5:31]
cor_matrix <- cor(truc[ , -c(1,26,27)], use = "pairwise.complete.obs", method = "pearson")

corrplot(cor_matrix)

# Transform to leaflet projection if needed

conversion_leaflet <- function(df){
  france_leaf <- df %>% 
    group_by(nom_departement,group) %>% 
    summarise(
      geometry = list(st_polygon(list(cbind(long,lat)))),.groups = "drop"
      )
  return(france_leaf)
}

france_dep_leaf<- france_dep %>% 
  filter(is.na(subregion))

test <- conversion_leaflet(france_dep_leaf)
test <- st_as_sf(test)


test <- left_join(test,dta,by=join_by(nom_departement))

pal <- leaflet::colorNumeric(c("red","darkgreen"),domain=test$tx_pauvrete)

leaflet(test) %>%  # ton objet sf
  addTiles() %>%
  addPolygons(
    layerId = ~nom_departement,    # id pour le clic
    label = ~nom_departement,      # label affiché au survol
    color = "blue",
    fillColor = ~pal(tx_pauvrete),
    weight = 1,
    fillOpacity = 0.7
  )

test <- st_set_crs(test, 4326)


test_2 <- test %>%
  filter(année_publication==2018)

# test %>%
#   ggplot() +
#   geom_point(aes(x=tx_log_sociaux,y=tx_pauvrete,colour = année_publication))+
#   geom_smooth(aes(x=tx_pauvrete,y=tx_chomage,colour = année_publication))
# 
# 
# test %>% 
#   ggplot()+
#   geom_boxplot(aes(x=année_publication,y=tx_pauvrete))

test %>%
  filter(nom_departement=="paris") %>% 
  ggplot(aes(x = année_publication, 
             y = sold_naturel, 
             col = nom_departement,
             group = nom_departement)) +
  geom_line()

moy <- mean(france_dep_data$variation_loyer)
france_dep_data %>%
  ggplot(aes(x=long,y=lat,group=group,fill=variation_loyer))+ 
  geom_polygon(col="black") + 
  theme_minimal() +
  scale_fill_gradient2(low="darkgreen",
                       mid="white",
                       high="deeppink4",
                       midpoint = 0)+
  ylab("Latitude")+
  xlab("Longitude")+
  ggtitle("Variation du loyer moyen des logements sociaux par département entre 2016 et 2021")+
  theme(legend.title = element_text("Variation loyer (%)"))
