tabPanel("Démographie et dynamique", icon = icon("user"),
         selectInput("dep_plot_tx_acroissement","Choisir un département :",
                     choices = unique(dta$nom_departement)),
         fluidRow(column(width=7,plotOutput("plot_tx_accroissement")),
                  column(width=5,plotOutput("plot_age_pop")))
         
)