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
                            plotOutput("genMap_1")
                          )
                 ),
                 
                 # ---- Onglet 3 ----
                 tabPanel("Analyse factorielle + classif",
                          fluidPage(
                            plotOutput("genMap_1")
                          )
                 ),
                 
                 # ---- Onglet 4 ----
                 tabPanel("Information",
                            DTOutput("table")
                          )
                 )
