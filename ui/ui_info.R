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
                              p('Le DPE ou "Diagnostic de Performance Energétique" est un examen créé en 2006. Il a subit 2 reformes majeures en 2006 et en 2021.'),
                              p('Il est initalement composé de 2 étiquettes donnant ainsi 2 classes : une étiquette CO2 (kg/CO2/m2/an) et une étiquette énergétique (kWh/m2/an).'),
                              p("La réforme de 2021 (RE2020) : a tenté de fiabiliser la méthode pour mieux détecter les passoires thermiques. Cependant certaines mesures, comme l'abaissement des seuils de classe énergétique (A : '<50kWh' --> '<70kWh'), ont fait débat lors de sa mise en place.
                                        Parmis les autres mesures prises ont peut noter : abaissement du facteur d'énergie primaire ou l'abaissement de la valeur de contenu carbone de l'électricité."),
                              br(),
                              
                              strong("Facteur d'énergie primaire:"),
                              p("Facteur de conversion permettant de quantifier l'énergie réellement consommée pour une consommation de 1kWh dans un logement. Cela prend notamment en compte les phénomènes de déperdition sur le réseau."),
                              br(),
                              
                              strong("Logement social:"),
                              p("Logement construit avec l’aide de l’État et qui est soumis à des règles de construction, de gestion et d’attributions précises. Les loyers sont également réglementés et l’accès au logement conditionné à des ressources maximales."),
                              p("Il existe 3 catégories de logements sociaux : PLAI pour les plus précaires, PLUS correspondant aux HLM et PLS dans les zones tendues"),
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
                              p("Pourcentage de la population vivant en dessous du seuil de pauvreté national. En France, il est fixé à 60% du revenu médian.")
                    )
           )
         )
         
)