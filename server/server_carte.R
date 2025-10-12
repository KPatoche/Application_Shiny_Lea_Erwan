
pal <- leaflet::colorFactor(palette=c("#1B9E77","#E6AB02","#7570B3","#D95F02"),domain=test$nom_region)

#Carte intéractive par département pour avoir une idée des indicateurs pour chaque département 
output$map <- renderLeaflet({
  leaflet(test) %>%
    addTiles() %>%
    setView(lng = 2.3522, lat = 47.1566, zoom = 6) %>%  # Exemple: Paris
    addPolygons(
      layerId = ~nom_departement,
      label = ~nom_departement,
      fillColor = ~pal(nom_region),  # couleur dynamique
      color = "darkblue",
      weight = 1,
      fillOpacity = 0.7
    )
})

#Fonction de clic sur la carte
observeEvent(input$map_shape_click, {
  click <- input$map_shape_click
  observe({
    
    req(input$date_slider)
    dept <- test %>% 
      filter(nom_departement == click$id, 
             année_publication == input$date_slider)
    
    bbox <- as.numeric(st_bbox(dept))
    
    leafletProxy("map") %>%
      flyToBounds(
        lng1 = bbox[1],
        lat1 = bbox[2],
        lng2 = bbox[3],
        lat2 = bbox[4]
      )
    
    #Bulle d'information quand on clique sur un département
    output$info <- renderUI({
      img_src <- paste0(dept$code_departement, ".png")  # ou dept$nom_departement
      
      
      HTML(paste0(
        "<img src='", img_src, "' style='width:80px;height:auto;display:block; margin:auto;'><br>",
        "<b>Département :</b> ", str_to_sentence(dept$nom_departement), "<br>",
        "<b>Région :</b> ", str_to_sentence(dept$nom_region), "<br>",
        "<b>Nombre d'habitants : </b>", dept$habitants,"<br>",
        "<b>Taux de logement sociaux :</b> ", round(dept$tx_log_sociaux,1)," %", "<br>",
        "<b>Taux de pauvreté :</b> ", round(dept$tx_pauvrete, 1), " %","<br>",
        "<b>Taux de chômage :</b> ", round(dept$tx_chomage,1)," %", "<br>"
      ))
    })
  })
  
})