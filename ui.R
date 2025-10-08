ui <- navbarPage("Pavillon'R",
                 
                 # ---- Onglet 1 avec sidebar ----
                 tabPanel("Introduction", icon = icon("file-alt"),
                          sidebarLayout(
                            sidebarPanel(width=2,
                                         selectInput("var", "Que voulez-vous voir sur cette carte?", 
                                                     choices = setNames(colnames(france_dep_data)[10:34],labels)),
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
                 tabPanel(
                   "Vue d'ensemble",
                   fluidPage(
                     tags$style("
                          #info {
                            position: absolute;
                            top: 100px;
                            right: 30px;
                            z-index: 1000;
                            background: rgba(100,180,180,0.9);
                            padding: 15px;
                            border-radius: 10px;
                            box-shadow: 0 0 8px rgba(0,0,0,0.2);
                            max-width: 300px;
                          }
                        "),
                     
                     # On place le slider dans un sidebarLayout
                     sidebarLayout(
                       sidebarPanel(
                         sliderInput(
                           inputId = "date_slider",
                           label = "Choisir la date",
                           min = min(as.numeric(as.character(test$année_publication))),
                           max = max(as.numeric(as.character(test$année_publication))),
                           value = min(as.numeric(as.character(test$année_publication))),
                           step = 1
                         ),
                         width = 2
                       ),
                       
                       mainPanel(
                         titlePanel("Carte interactive - Département"),
                         leafletOutput("map", height = "80vh"),
                         uiOutput("info"),
                         width = 10
                       )
                     )
                   )
                 ),
                 
                 
                 # ---- Onglet 3 ----
                 tabPanel("Démographie et dynamique",
                          fluidPage(
                            plotOutput("hist")
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
                 tabPanel("Données", icon = icon("table"),
                          tabsetPanel(
                            type="tabs",
                            tabPanel("Tableau",DTOutput("table")),
                            tabPanel("Résumé des données", verbatimTextOutput("summaryTable")),
                            tabPanel("Exploration")
                          )
                 ),
                 
                 # ---- Onglet 6 ----
                 tabPanel("Info", icon=icon("info-circle"), 
                          tabsetPanel(
                            type="tabs",
                            tabPanel("À propos",
                          fluidPage(h4(p("A propos du jeu de données")),
                                    h5(p("Dans le cadre de sa mission de financeur du logement social en France, la Caisse des Dépôts et Consignations, à travers la Banque des Territoires, suit et constitue des données utiles aux acteurs et observateurs cherchant à analyser les évolutions des territoires, l'activité de la construction et le secteur du logement social.")),
                                    h5(p("Le jeu de données mis à disposition présente, pour les départements métropolitains et les DOM, des indicateurs de contexte sur le parc de logement et des informations sur le parc de logement social.")),
                                    h5(p("Ces données sont issues de l'Insee, de la base Sit@del2, du répertoire du parc locatif social (RPLS) et de la CDC. Elles sont valorisées dans la publication annuelle l'Atlas du logement et des territoires (Banques des Territoires), voir référence ci-dessous.")),
                                    h5(p("Nous avons modifié la variable année de publication tel qu'elle correspond aux années N-2 par rapport à l'année de publication indiquée, excepté le taux de chômage (T4 N-1) et le taux de pauvreté (N-3).")),
                                    br(),
                                    h5(p("Ce jeu de données n’est plus mis à jour à partir du 01/01/2025.")),
                                    h5(p("Le jeu de données pour cette application Shiny est disponible", a("sur ce site", href = "https://www.data.gouv.fr/datasets/logements-et-logements-sociaux-dans-les-departements-1/"),"."))
                                    )
                                  ),
                            
                          tabPanel("Définitions",
                            fluidPage(h4(p("Définitions des variables")),
                                      
                                      strong("Logement social:"),
                                      p("Logement construit avec l’aide de l’État et qui est soumis à des règles de construction, de gestion et d’attributions précises. Les loyers sont également réglementés et l’accès au logement conditionné à des ressources maximales."),
                                      p("Il existe 3 catégories de logements sociaux : PLAI pour les plus précaires, PLUS correspondant aux HLM et PLS dans les zones tendues"),
                                      br(),
                                      
                                      strong("Taux de pauvreté:"),
                                      p("Pourcentage de la population vivant en dessous du seuil de pauvreté national. En France, il est fixé à 60% du revenu médian."),
                                      br()
                                      
                                      )
                          )
                          )
                 
)
)