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
  
  output$table <- renderDT(
    dta[,-c(31,32,33)],
    filter = "top",
    colnames=c("Année",
               "Code du département",
               "Département",
               "Code région",
               "Région",
               "Nombre d'habitants",
               "Densité de population au km²",
               "Variation de la population sur 10 ans (en %)",
               "Dont contribution du solde naturel (en %)",
               "Dont contribution du solde migratoire (en %)",
               "% population de moins de 20 ans",
               "% population de 60 ans et plus",
               "Taux de chômage au T4 (en %)",
               "Taux de pauvreté (en %)",
               "Nombre de logements",
               "Nombre de résidences principales",
               "Taux de logements sociaux (en %)",
               "Taux de logements vacants (en %)",
               "Taux de logements individuels (en %)",
               "Moyenne annuelle de la construction neuve sur 10 ans",
               "Construction",
               "Parc social - Nombre de logements",
               "Parc social - Logements mis en location",
               "Parc social - Logements démolis",
               "Parc social - Ventes à des personnes physiques",
               "Parc social - Taux de logements vacants (en %)",
               "Parc social - Taux de logements individuels (en %)",
               "Parc social - Loyer moyen (en €/m²/mois)",
               "Parc social - Âge moyen du parc (en années)",
               "Parc social - Taux de logements énergivores (E,F,G) (en %)"))
  
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
  
  pal <- leaflet::colorNumeric(c("red","darkgreen"),domain=test$tx_pauvrete)
  
  output$map <- renderLeaflet({
    leaflet(test) %>%
      addTiles() %>%
      addPolygons(
        layerId = ~nom_departement,
        label = ~nom_departement,
        fillColor = ~pal(tx_pauvrete),  # couleur dynamique
        color = "darkblue",
        weight = 1,
        fillOpacity = 0.7
      ) %>%
      addLegend(
        pal = pal,
        values = ~tx_pauvrete,
        title = "Revenu médian",
        position = "bottomright"
      )
  })
  
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    
    dept <- test %>% filter(nom_departement == click$id)
    bbox <- as.numeric(st_bbox(dept))
    
    leafletProxy("map") %>%
      flyToBounds(
        lng1 = bbox[1],
        lat1 = bbox[2],
        lng2 = bbox[3],
        lat2 = bbox[4]
    )
  })

}

