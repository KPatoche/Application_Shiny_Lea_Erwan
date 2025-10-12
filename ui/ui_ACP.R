tabPanel("ACP", icon = icon("magnifying-glass-chart"),
         fluidRow(
           column(width=2,
                  selectInput(
                    inputId = "ACP_categorie",
                    label = "Choisir la catégorie pour l'ACP",
                    choices = c("Année" = "annee", "Département" = "departement", "Région" = "region"),
                    selected = "annee"
                  )),
           column(width=2,
                  checkboxInput(
                    inputId = "afficher_individus",
                    label = "Afficher les individus",
                    value = TRUE
                  ))),
         fluidRow(
           column(6, plotOutput("ACP_ind", height = "500px", width = "100%")),
           column(6, plotOutput("ACP_var", height = "500px", width = "100%"))
         )
)