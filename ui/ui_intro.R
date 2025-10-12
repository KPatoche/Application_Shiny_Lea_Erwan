tabPanel(
  "Accueil",icon = icon("house"),
  
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
            choices = setNames(colnames(france_dep_data)[10:34], labels), selected = "tx_log_sociaux"
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
            plotOutput("visu1", height = "650px", width = "85%"),
            style = "margin-left: 150px;" 
          )
        ),
        hr(style = "border-top: 2px solid #bbb; width: 100vw; margin-left: 0; margin-right: 0;"),
        fluidRow(
          column(
            width = 12,
            plotOutput("visu2", height = "650px", width = "120%"),
            style = "margin-left: 80px;" 
          )
        ),
        hr(style = "border-top: 2px solid #bbb; width: 100vw; margin-left: 0; margin-right: 0;"),
        fluidRow(
          column(
            width = 12,
            plotOutput("visu3", height = "650px", width = "120%"),
            style = "margin-left: 80px;" 
          )
        )
      )
    )
  )
)