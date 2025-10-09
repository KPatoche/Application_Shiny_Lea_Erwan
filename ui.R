ui <- navbarPage("Pavillon'R",
                 theme=shinytheme("united"),
                 tabPanel(
                   "Intro",
                   
                   tabsetPanel(
                     
                     # ---- Sous-onglet 1 : Comparaison ----
                     tabPanel(
                       "Comparaison",
                       
                       sidebarLayout(
                         sidebarPanel(
                           width = 2,
                           
                           selectInput(
                             "var",
                             "Que voulez-vous voir sur cette carte ?", 
                             choices = setNames(colnames(france_dep_data)[10:34], labels)
                           ),
                           
                           sliderInput(
                             "annee",
                             "Années :",
                             min = 2016,
                             max = 2021,
                             value = c(2016, 2021)
                           )
                         ),
                         
                         mainPanel(
                           fluidRow(
                             column(
                               12,
                               align = "center",
                               uiOutput("titre_intro")
                             )
                           ),
                           
                           fluidRow(
                             column(
                               6,
                                plotOutput("genMap_1", height="570px", width="100%"),
                             ),
                             column(
                               6,
                               tags$div(style = "padding-left:0; padding-right:0;",
                                        plotOutput("genMap_2", height="570px", width="120%"))
                               
                             )),
                           
                           fluidRow(
                             column(
                               6,
                               align = "center",
                               textOutput("annee_map_1")  # Année pour la 1re carte
                             ),
                             column(
                               6,
                               align = "center",
                               textOutput("annee_map_2")  # Année pour la 2e carte
                             )
                           )
                         )
                       )
                     ),
                     
                     # ---- Sous-onglet 2 : Visualisation ----
                     tabPanel(
                       "Visualisation",
                       mainPanel(
                         fluidRow(
                           column(
                             width = 12,
                             plotOutput("visu1", height = "650px", width = "100%"),
                             style = "margin-left: 150px;" 
                           )
                         ),
                         hr(),
                         fluidRow(
                           column(
                             width = 12,
                             plotOutput("visu2", height = "650px", width = "120%"),
                             style = "margin-left: 80px;" 
                           )
                           
                       )
                     )
                   )
                 )
                 ),
                 
                 # ---- Onglet 2 sans sidebar ----
                 tabPanel(
                   "Vue d'ensemble", icon = icon("earth-europe"),
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
                 
                 tabPanel("Démographie et dynamique", icon = icon("user"),
                          fluidPage(
                            selectInput("dep_plot_tx_acroissement","Choisir un département :",
                                        choices = unique(dta$nom_departement)),
                            fluidRow(column(width=7,plotOutput("plot_tx_accroissement")),
                                     column(width=5,plotOutput("plot_age_pop")))
                          )
                 ),
                 
                 # ---- Onglet 4 ----
                 
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
                 ),
                 
                 # ---- Onglet 5 ----
                 
                 tabPanel("ACP", icon = icon("magnifying-glass-chart"),
                            fluidRow(
                              column(6, plotOutput("ACP_ind")),
                              column(6, plotOutput("ACP_var"))
                            )
                          ),
                 
                 # ---- Onglet 6 ----
                 tabPanel("Données", icon = icon("table"),
                          tabsetPanel(
                            type="tabs",
                            tabPanel("Tableau",DTOutput("table")),
                            tabPanel("Résumé des données", verbatimTextOutput("summaryTable")),
                            tabPanel("Exploration", icon = icon("chart-bar"),
                                     fluidPage(
                                       fluidRow(
                                         column(width = 3,
                                         selectInput("var_x", "Abscisse :", 
                                                     choices = colnames(france_dep_data)[10:34])),
                                         column(width=3,
                                         selectInput("var_y", "Ordonné :", 
                                                     choices = colnames(france_dep_data)[10:34]))
                                       ),
                                       fluidRow(
                                           column(
                                             width = 6,
                                             plotlyOutput("bivariate_plot", height = "400px")
                                           ),
                                           column(
                                             width = 6,
                                             plotOutput("correlation_plot", height = "400px")
                                           )
                                         )
                                       )
                                     )
                            )
                          ),
                 
                 # ---- Onglet 7 ----
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
                                    h5(p("Le jeu de données pour cette application Shiny est disponible", a("sur ce site", href = "https://www.data.gouv.fr/datasets/logements-et-logements-sociaux-dans-les-departements-1/"),".")),
                                    h5(p("La note méthodologique et les sources des données sont disponible", a("ici", href = "https://opendata.caissedesdepots.fr/api/datasets/1.0/logements-et-logements-sociaux-dans-les-departements/attachments/note_methodologique_sources_pdf/"),"."))
                                    
                                    )
                                  ),
                            
                          tabPanel("Définitions",
                            fluidPage(h4(p("Définitions des variables")),
                                      
                                      strong("DPE:"),
                                      p("Le DPE est un type de bilan énergétique destiné aux bâtiments en vente ou en location. Il est aussi requis pour accéder à des aides financières à la rénovation."),
                                      p("La classe énergétique du logement se calcule à partir de ses performances énergétiques et de production annuelle de gaz à effet de serre."),
                                      p("Ce classement se divise en 7 classes énergétiques, à savoir A, B, C, D, E, F et G. Les logements notés E, F et G au DPE sont les plus énergivores."),
                                      p("Le nouveau DPE est entré en vigueur en 2021 et fait suite à loi sur l’Évolution du logement, de l’aménagement et du numérique (ELAN), les seuils des classes énergétiques ont été révisés et revus à la hausse, il est désormais plus facile d'obtenir un bon BPE."),
                                      br(),
                                      
                                      strong("Logement social:"),
                                      p("Logement construit avec l’aide de l’État et qui est soumis à des règles de construction, de gestion et d’attributions précises. Les loyers sont également réglementés et l’accès au logement conditionné à des ressources maximales."),
                                      p("Il existe 3 catégories de logements sociaux : PLAI pour les plus précaires, PLUS correspondant aux HLM et PLS dans les zones tendues."),
                                      br(),
                                      
                                      strong("Parc social:"),
                                      p("Le parc social correspond à l’ensemble des logements appartement à des organismes de HLM, ainsi que de les logements des autres bailleurs de logement sociaux. Les loyers sont réglementés et l’accès au logement est soumis à des conditions de ressources."),
                                      br(),
                                      
                                      strong("Parc social - Logements mis en location:"),
                                      p("Logements loués pour la première fois au cours de l'année N-2 par le bailleur social."),
                                      br(),
                                      
                                      strong("Parc social - Taux de logements vacants:"),
                                      p("Avant 2020, calculé comme le rapport entre le nombre de logements sociaux vacants et le nombre total de logements sociaux. A partir de 2020, calculé comme le rapport entre le nombre de logements sociaux vacants et le nombre de logements sociaux loués ou vacants."),
                                      br(),
                                      
                                      strong("Parc social - Logements énergivores:"),
                                      p("Logements classés en étiquette énergétique E, F ou G au sens du diagnostic de performance énergétique (DPE)."),
                                      br(),
                                      
                                      strong("Solde naturel:"),
                                      p("Différence entre le nombre de naissances vivantes et le nombre de décès au cours d'une année."),
                                      br(),
                                      
                                      strong("Solde migratoire:"),
                                      p("Différence entre le nombre de personnes qui sont entrées sur un territoire au cours d'une année."),
                                      br(),
                                      
                                      strong("Taux de chômage:"),
                                      p("Pourcentage de personne sans travail dans la population active (actifs occupés et chômeurs)."),
                                      br(),
                                      
                                      strong("Taux de logements vacants:"),
                                      p("Rapport entre le nombre de logements vacants et le nombre total de logements, calculé à partir des logements vacants se trouvant dans l’un des cas suivants : proposé à la vente, à la location ; déjà attribué à un acheteur ou un locataire et en attente d’occupation ; en attente de règlement de succession ; conservé par un employeur pour un usage futur au profit d’un de ses employés ; gardé vacant et sans affectation précise par le propriétaire."),
                                      br(),
                                      
                                      strong("Taux de logements sociaux:"),
                                      p("Nombre de logements sociaux hors habitat spécifique et hors parc non conventionné des Sociétés d’économie mixte (RPLS), rapporté au nombre de résidences principales (Insee)."),
                                      br(),
                                      
                                      strong("Taux de pauvreté:"),
                                      p("Pourcentage de la population vivant en dessous du seuil de pauvreté national. En France, il est fixé à 60% du revenu médian."),
                                      br()
                                      
                                      )
                          )
                          )
                 
)
)
