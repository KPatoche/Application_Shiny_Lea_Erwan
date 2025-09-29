
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width=2,
      selectInput("var", "Que voulez-vous voir sur cette carte?", colnames(france_dep_data)[11:35]),
      sliderInput("annee","Années :",min=2016,max=2021,value=c(2016,2021))),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("genMap_1"),
      plotOutput("genMap_2")
    )
  )
)

