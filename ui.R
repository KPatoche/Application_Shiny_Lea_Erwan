ui <- navbarPage("Pavillon'R",
                 
                 # ---- Onglet 1 avec sidebar ----
                 tabPanel("Graph intro",
                          sidebarLayout(
                            sidebarPanel(width=2,
                                         selectInput("var", "Que voulez-vous voir sur cette carte?", 
                                                     colnames(france_dep_data)[11:35]),
                                         sliderInput("annee","Années :", min=2016, max=2021, value=c(2016,2021))
                            ),
                            mainPanel(
                              fluidRow(
                                column(6, plotOutput("genMap_1")),
                                column(6, plotOutput("genMap_2"))
                              )
                            )
                          )
                 ),
                 
                 # ---- Onglet 2 sans sidebar ----
                 tabPanel("Département",
                          fluidPage(
                            tags$style("
                                    #info {
                                      position: absolute;
                                      top: 140px;
                                      right: 38px;
                                      z-index: 1000;
                                      background: rgba(100,180,180,0.9);
                                      padding: 15px;
                                      border-radius: 10px;
                                      box-shadow: 0 0 8px rgba(0,0,0,0.2);
                                      max-width: 300px;
                                    }
                                  "),
                            titlePanel("Carte interactive - Département"),
                            leafletOutput("map", height = "80vh"),
                            sliderInput(
                              inputId = "date_slider",
                              label = "Choisir la date",
                              min = min(test$année_publication),
                              max = max(test$année_publication),
                              value = min(test$année_publication),
                              step = 1
                            ),
                            uiOutput("info")
                          )
                 ),
                 
                 # ---- Onglet 3 ----
                 tabPanel("Analyse factorielle + classif",
                          fluidPage(
                            plotOutput("genMap_1")
                          )
                 ),
                 
                 # ---- Onglet 4 ----
                 
                 tabPanel("Parc social", icon = icon("building"),
                          fluidPage(
                            selectInput("var_parc","Choisir une variable du parc social :",
                                        choices = c("Parc social - Nombre de logements" = "social_nb_logements",
                                                    "Parc social - Logements mis en location"="social_location",
                                                    "Parc social - Logements démolis"="social_demoli",
                                                    "Parc social - Ventes à des personnes physiques"="social_ventes_physiques",
                                                    "Parc social - Taux de logements vacants (en %)"="social_vacants",
                                                    "Parc social - Taux de logements individuels (en %)"="social_individuel",
                                                    "Parc social - Loyer moyen (en €/m²/mois)"="social_loyer_m2",
                                                    "Parc social - Âge moyen du parc (en années)"="social_age_moyen",
                                                    "Parc social - Taux de logements énergivores (E,F,G) (en %)"="social_tx_energivores")),
                            radioButtons("niveau","Niveau d'analyse :",
                                      choices = c("Département"="nom_departement", "Région"="nom_region"),
                                      inline=TRUE),
                            plotlyOutput("parc_social_plot", height = "800px", width = "1000px")
                        )
                 ),
                 
                 # ---- Onglet 5 ----
                 tabPanel("Table", icon = icon("table"),
                          tabsetPanel(
                            type="tabs",
                            tabPanel("Données",DTOutput("table")),
                            tabPanel("Résumé des données", verbatimTextOutput("summaryTable")
                                   )
                          )
                 ),
                 
                 # ---- Onglet 6 ----
                 tabPanel("Info", icon=icon("info-circle"), 
                          fluidPage(h4(p("A propos du jeu de données")),
                                    h5(p("Dans le cadre de sa mission de financeur du logement social en France, la Caisse des Dépôts et Consignations, à travers la Banque des Territoires, suit et constitue des données utiles aux acteurs et observateurs cherchant à analyser les évolutions des territoires, l'activité de la construction et le secteur du logement social.")),
                                    h5(p("Le jeu de données mis à disposition présente, pour les départements métropolitains et les DOM, des indicateurs de contexte sur le parc de logement et des informations sur le parc de logement social.")),
                                    h5(p("Ces données sont issues de l'Insee, de la base Sit@del2, du répertoire du parc locatif social (RPLS) et de la CDC. Elles sont valorisées dans la publication annuelle l'Atlas du logement et des territoires (Banques des Territoires), voir référence ci-dessous.")),
                                    h5(p("Nous avons modifié la variable année de publication tel qu'elle correspond aux années N-2 par rapport à l'année de publication indiquée, excepté le taux de chômage (T4 N-1) et le taux de pauvreté (N-3).")),
                                    br(),
                                    h5(p("Ce jeu de données n’est plus mis à jour à partir du 01/01/2025.")),
                                    h5(p("Le jeu de données pour cette application Shiny est disponible", a("sur ce site", href = "https://www.data.gouv.fr/datasets/logements-et-logements-sociaux-dans-les-departements-1/"),"."))
                                    )
                 )
)

