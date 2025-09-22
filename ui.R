
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Que voulez-vous voir sur cette carte?", colnames(france_dep_data)[11:35]
    )),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("genMap")
    )
  )
)

