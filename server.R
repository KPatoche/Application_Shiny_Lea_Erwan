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
  
  output$table <- renderDT(dta)
  
  output$hist <- renderPlot({
    dta %>%
      ggplot(aes(x = tx_pauvrete, 
                 y = as.factor(année_publication),
                 fill = as.factor(année_publication))) +
      geom_density_ridges(alpha = 0.6) +
      theme_minimal()
  })
  
  output$box<- renderPlot({
    dta %>%
      mutate(année_publication = as.factor(dta$année_publication)) %>% 
      ggplot(aes(x=année_publication,y=tx_pauvrete,fill=année_publication))+
      geom_boxplot()+
      geom_jitter()+
      theme_minimal()
  })
  
  
  output$lines<- renderPlot({
    dta %>%
      mutate(année_publication = as.factor(dta$année_publication)) %>% 
      group_by(année_publication) %>% 
      summarise(mean_pauvrete = mean(tx_pauvrete,na.rm=T)) %>% 
      ggplot(aes(x=année_publication,y=mean_pauvrete))+
      geom_point()+
      theme_minimal()
  })
}

