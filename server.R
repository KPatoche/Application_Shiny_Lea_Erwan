# Define server logic required to draw a histogram
server <- function(input, output) {
 
  
#Légende en commun pour les 2 maps
  
  var_limits <- reactive({
    df <- france_dep_data %>%
      filter(année_publication %in% input$annee) %>%
      pull(.data[[input$var]])
    
    c(min(df, na.rm = TRUE), max(df, na.rm = TRUE))
  })

  #Inversion de la palette selon la variable
  get_palette <- function(var_name) {
    if (var_name %in% c("tx_chomage","tx_pauvrete","social_demoli","social_vacants","social_tx_energivores","social_age_moyen",
                        "social_loyer_m2")) {  
      return(c("darkgreen","green","gold","orange","red"))
    } else {
      return(c("red","orange","gold","green","darkgreen")) 
    }
  }
  
  
#Carte pour année 1  
  output$genMap_1 <- renderPlot({
    lims <- var_limits()
    
    france_dep_data %>%
      filter(année_publication==input$annee[1]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="white") + 
      theme_minimal() +
      scale_fill_gradientn(colors = c("red","orange","gold","green","darkgreen"),
                           limits=lims)
    
  })
#Carte pour année 2
  output$genMap_2 <- renderPlot({
    lims <- var_limits()
    
    france_dep_data %>%
      filter(année_publication==input$annee[2]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="white") + 
      theme_minimal() +
      scale_fill_gradientn(colors = c("red","orange","gold","green","darkgreen"),
                           limits=lims)
    
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
  
  output$summaryTable <- renderPrint({
    dta_summary <- dta[,-c(31,32,33)]
    colnames(dta_summary) <- c("Année",
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
                             "Parc social - Taux de logements énergivores (E,F,G) (en %)")
    summary(dta_summary)
  })
  
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
  
  output$parc_social_plot <- renderPlotly({
    
    if (input$niveau == "nom_departement") {
      df_plot <- dta %>% 
        group_by(nom_departement) %>% 
        summarise(valeur_moy = mean(.data[[input$var_parc]], na.rm =TRUE)) %>% 
        arrange(desc(valeur_moy))
      
      p <- ggplot(df_plot, aes(
        x = valeur_moy,
        y = reorder(nom_departement, valeur_moy)
      )) +
        geom_col(fill = "#3182bd") +
        labs(
          title = paste("Moyenne sur 6 ans"),
          x = "Valeur moyenne",
          y = "Département")
      
    } else if (input$niveau == "nom_region") {
      df_plot <- dta %>% 
        group_by(nom_region) %>% 
        summarise(valeur_moy = mean(.data[[input$var_parc]], na.rm =TRUE)) %>%
        arrange(desc(valeur_moy))
      
      p <- ggplot(df_plot, aes(
        x = valeur_moy,
        y = reorder(nom_region, valeur_moy)
      )) +
        geom_col(fill = "#3182bd") +
        labs(
          title = paste("Moyenne sur 6 ans"),
          x = "Valeur moyenne",
          y = "Région")
    }
    ggplotly(p)
  })
  
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
      HTML(paste0(
        "<b>Département :</b> ", str_to_sentence(dept$nom_departement), "<br>",
        "<b>Région :</b> ", str_to_sentence(dept$nom_region), "<br>",
        "<b>Taux de logement sociaux :</b> ", round(dept$tx_log_sociaux,1)," %", "<br>",
        "<b>Taux de pauvreté :</b> ", round(dept$tx_pauvrete, 1), " %","<br>",
        "<b>Taux de chômage :</b> ", round(dept$tx_chomage,1)," %", "<br>"
      ))
    })
    })

})
}

