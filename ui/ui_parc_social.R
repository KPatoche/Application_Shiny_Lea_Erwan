tabPanel(
  "Parc social", icon = icon("building"),
  fluidPage(
    
    # Choix variable et niveau
    fluidRow(
      style = "display: flex; justify-content: center; align-items: center; margin-bottom: 20px;",
      column(
        4,
        selectInput(
          "var_parc",
          "Choisir une variable du parc social :",
          choices = c(
            "Taux de logements sociaux (en %)" = "tx_log_sociaux",
            "Parc social - Nombre de logements" = "social_nb_logements",
            "Parc social - Logements mis en location" = "social_location",
            "Parc social - Logements démolis" = "social_demoli",
            "Parc social - Ventes à des personnes physiques" = "social_ventes_physiques",
            "Parc social - Taux de logements vacants (en %)" = "social_vacants",
            "Parc social - Taux de logements individuels (en %)" = "social_individuel",
            "Parc social - Loyer moyen (en €/m²/mois)" = "social_loyer_m2",
            "Parc social - Âge moyen du parc (en années)" = "social_age_moyen",
            "Parc social - Taux de logements énergivores (E,F,G) (en %)" = "social_tx_energivores"
          )
        )
      ),
      column(
        4,
        radioButtons(
          "niveau",
          "Niveau d'analyse :",
          choices = c("Département" = "nom_departement", "Région" = "nom_region"),
          inline = TRUE
        )
      )
    ),
    
    uiOutput("titre_parc_social"),
    plotlyOutput("parc_social_plot", height = "800px", width = "1000px"),
    hr(),
    
    # Choix département + variable pour graphique secondaire
    fluidRow(
      style = "display: flex; justify-content: center; align-items: center; margin-bottom: 20px;",
      column(
        4,
        selectInput("dep_graph2", "Choisir un département :",
                    choices = unique(dta$nom_departement))
      ),
      column(
        4, 
        selectInput("var_graph2", "Choisir une variable du parc social :",
                    choices = c(
                      "Taux de logements sociaux (en %)" = "tx_log_sociaux",
                      "Parc social - Nombre de logements" = "social_nb_logements",
                      "Parc social - Logements mis en location" = "social_location",
                      "Parc social - Logements démolis" = "social_demoli",
                      "Parc social - Ventes à des personnes physiques" = "social_ventes_physiques",
                      "Parc social - Taux de logements vacants (en %)" = "social_vacants",
                      "Parc social - Taux de logements individuels (en %)" = "social_individuel",
                      "Parc social - Loyer moyen (en €/m²/mois)" = "social_loyer_m2",
                      "Parc social - Âge moyen du parc (en années)" = "social_age_moyen",
                      "Parc social - Taux de logements énergivores (E,F,G) (en %)" = "social_tx_energivores"
                    ))
      )
    ),
    
    uiOutput("titre_parc_social2"),
    uiOutput("dep_selected"),
    plotOutput("parc_social_graph2")
    
  )
)