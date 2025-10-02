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
                            titlePanel("Carte interactive - Département"),
                            leafletOutput("map", height = "90vh")
                          )
                 ),
                 
                 # ---- Onglet 3 ----
                 tabPanel("Analyse factorielle + classif",
                          fluidPage(
                            plotOutput("genMap_1")
                          )
                 ),
                 
                 # ---- Onglet 4 ----
                 tabPanel("Table", icon = icon("table"),
                            DTOutput("table")
                          ),
                 
                 # ---- Onglet 5 ----
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

