library(tidyverse)
library(maps)
library(readr)
library(RColorBrewer)
library(sf)
library(ggrepel)
library(readxl)
library(corrplot)
library(dplyr)


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

france_dep_data$code <- NULL
france_dep_data$subregion <- NULL

dta_moy <- dta %>%
  group_by(nom_departement) %>% 
  summarise(across(5:31, mean, na.rm = TRUE))


labels <- c("Nombre d'habitants","Densité de population au km²","Variation de la population sur 10 ans (en %)	","Dont contribution du solde naturel (en %)","Dont contribution du solde migratoire (en %)",
            "% population de moins de 20 ans","% population de 60 ans et plus","Taux de chômage au T4 (en %)","Taux de pauvreté (en %)","Nombre de logements",
            "Nombre de résidences principales","Taux de logements sociaux (en %)","Taux de logements vacants (en %)","Taux de logements individuels (en %)",
            "Moyenne annuelle de la construction neuve sur 10 ans","Construction","Parc social - Nombre de logements","Parc social - Logements mis en location",
            "Parc social - Logements démolis","Parc social - Ventes à des personnes physiques","Parc social - Taux de logements vacants (en %)","Parc social - Taux de logements individuels (en %)",
            "Parc social - Loyer moyen (en €/m²/mois)","Parc social - Âge moyen du parc (en années)","Parc social - Taux de logements énergivores (E,F,G)* (en %)")

titles <- c(
  habitants             = "Comparaison du nombre d'habitants par département",
  densite_km2           = "Comparaison de la densité de population par département",
  variation_10ans        = "Comparaison de la variation de la population sur 10 ans par département",
  sold_naturel         = "Comparaison du solde naturel par département",
  solde_migra      = "Comparaison du solde migratoire par département",
  pop_inf20        = "Comparaison de la part de la population de moins de 20 ans par département",
  pop_sup60           = "Comparaison de la part de la population âgée de 60 ans et plus par département",
  tx_chomage            = "Comparaison du taux de chômage par département",
  tx_pauvrete          = "Comparaison du taux de pauvreté par département",
  nb_logements          = "Comparaison du nombre total de logements par département",
  nb_res_princ    = "Comparaison du nombre de résidences principales par département",
  tx_log_sociaux        = "Comparaison du taux de logements sociaux par département",
  tx_log_vac        = "Comparaison du taux de logements sociaux vacants par département",
  tx_log_ind    = "Comparaison du taux de logements sociaux individuels par département",
  moy_nvl_constru_10ans = "Comparaison de la moyenne annuelle de construction de logements sociaux sur 10 ans par département",
  nb_construction          = "Comparaison du nombre de nouvelles constructions de logements sociaux  par département",
  social_nb_logements   = "Comparaison du nombre de logements du parc social par département",
  social_location       = "Comparaison du nombre de logements sociaux mis à la location pour la première fois par département",
  social_demoli         = "Comparaison du nombre de logements sociaux démolis par département",
  social_ventes_physiques = "Comparaison du nombre de ventes de logements sociaux à des particuliers par département",
  social_vacants        = "Comparaison du taux de logements sociaux vacants par département",
  social_individuel     = "Comparaison du taux de logements sociaux individuels par département",
  social_loyer_m2       = "Comparaison du loyer moyen du parc social par département",
  social_age_moyen      = "Comparaison de l'âge moyen du parc social par département",
  social_tx_energivores = "Comparaison du taux de logements sociaux énergivores par département"
)



titre_bivaries <- c(
  habitants             = "le nombre d'habitants",
  densite_km2           = "la densité (km2)",
  variation_10ans       = "la variation de population sur 10 ans",
  sold_naturel          = "le solde naturel",
  solde_migra      = "le solde migratoire",
  pop_inf20        = "la part de la population (<20ans)",
  pop_sup60           = "la part de la population (>60ans)",
  tx_chomage            = "le taux de chômage",
  tx_pauvrete          = "le taux pauvreté",
  nb_logements          = "le nombre de logements",
  nb_res_princ    = "le nombre de résidences principales",
  tx_log_sociaux        = "le taux de logements sociaux",
  tx_log_vac        = "le taux de logements vacants",
  tx_log_ind    = "le taux de logements individuels",
  moy_nvl_constru_10ans = "le nombre moyen de construction par an sur 10 ans",
  nb_construction          = "le nombre de constructions",
  social_nb_logements   = "le nombre de logements sociaux",
  social_location       = "le nombre de nouvelles locations pour les logements sociaux",
  social_demoli         = "le nombre de logements sociaux démolis",
  social_ventes_physiques = "le nombre de ventes de logements sociaux",
  social_vacants        = "le taux de logements sociaux vacants",
  social_individuel     = "le taux de logements sociaux individuels",
  social_loyer_m2       = "le loyer moyen des logements sociaux (m2)",
  social_age_moyen      = "l'age moyen du parc social",
  social_tx_energivores = "le taux de logements sociaux énergivores"
)

noms_var <- c(
  habitants             = "Nombre d'habitants",
  densite_km2           = "Densité(km2)",
  variation_10ans       = "Variation population sur 10 ans",
  sold_naturel          = "Solde naturel",
  solde_migra      = "Solde migratoire",
  pop_inf20        = "Part de la population (<20ans)",
  pop_sup60           = "Part de la population (>60ans)",
  tx_chomage            ="Taux de chômage",
  tx_pauvrete          = "Taux de pauvreté",
  nb_logements          = "Nombre de logements",
  tx_log_sociaux = "Taux de logements sociaux (en %)",
  social_nb_logements = "Nombre de logements sociaux",
  social_location = "Logements sociaux mis en location",
  social_demoli = "Logements sociaux démolis",
  social_ventes_physiques = "Ventes de logements sociaux",
  social_vacants = "Taux de logements sociaux vacants (en %)",
  social_individuel = "Taux de logements sociaux individuels (en %)",
  social_loyer_m2 = "Loyer moyen des logements sociaux (en €/m²/mois)",
  social_age_moyen = "Âge moyen du parc social (en années)",
  social_tx_energivores = "Taux de logements sociaux énergivores(en %)"
)




cor_matrix <- cor(dta_moy[ , -c(1,27,28)], use = "pairwise.complete.obs", method = "pearson")
cor_matrix
corrplot(cor_matrix)

truc <- dta[5:31]
cor_matrix <- cor(truc[ , -c(1,26,27)], use = "pairwise.complete.obs", method = "pearson")

corrplot(cor_matrix,
         tl.cex = 0.6)

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


test <- st_set_crs(test, 4326)


library(missMDA)
pre_acp <-missMDA::imputePCA(dta[,-c(2,4,8,20,23,31:34)],quali.sup = c(1,2,3),quanti.sup=c(4:5,6:13))
ACP_social <- PCA(pre_acp$completeObs,quali.sup = c(1,2,3),quanti.sup=c(4:5,6:13),graph=F)



simul <- function(nbsimul,nind,nvar){
  res <- rep(0,times = nbsimul)
  for (i in 1:nbsimul){
    dta <- as.data.frame(matrix(rnorm(nind*nvar),nrow=nind))
    ACP <- PCA(dta,graph = FALSE)
    res[i] <- ACP$eig[2,3]
  }
  quant <- quantile(res,probs=c(0.95))
  return(quant)
}
simul(1000,576,12)



dta <- dta %>%
  mutate(taux_accroissement = sold_naturel + solde_migra)

dta <- dta %>%
  mutate(pop_20_60 = 100 - pop_inf20 - pop_sup60)

