# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$genMap_1 <- renderPlot({
    
    france_dep_data %>%
      filter(année_publication==input$annee[1]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="white") + 
      theme_minimal() +
      scale_fill_gradientn(colors = c("darkred","red","gray","blue","darkblue"))
    
  })
  
  output$genMap_2 <- renderPlot({
    france_dep_data %>%
      filter(année_publication==input$annee[2]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="white") + 
      theme_minimal() +
      scale_fill_gradientn(colors = c("darkred","red","gray","blue","darkblue"))
    
  })
  
}

