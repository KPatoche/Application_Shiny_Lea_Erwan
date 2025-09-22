# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$genMap <- renderPlot({
    
    ggplot(data=france_dep_data,aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="white") + 
      theme_minimal() +
      scale_fill_gradientn(colors = c("darkred","red","gray","lightblue","darkblue"))
  })
}
