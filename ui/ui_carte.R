tabPanel(
  "Vue d'ensemble",icon = icon("earth-europe"),
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
)