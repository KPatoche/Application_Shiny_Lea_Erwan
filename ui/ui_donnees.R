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
                                           choices = setNames(colnames(dta)[6:30], labels))),
                        column(width=3,
                               selectInput("var_y", "Ordonné :", 
                                           choices = setNames(colnames(dta)[6:30], labels)))
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
)