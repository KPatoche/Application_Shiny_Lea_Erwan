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
      return(c("royalblue2","white","orangered1"))
    } else if (var_name %in% c("habitants","densite_km2","pop_inf20","pop_sup60","nb_logements")){
      return(c("lightyellow","gold","orangered1")) 
    } else{ 
      return(c("orangered1","white","royalblue2"))}
  }
  
  output$intro_plot <- renderPlot({
    
    france_dep_data %>%
      ggplot(aes(x=long,y=lat,group=group,fill=variation_loyer))+ 
      geom_polygon(col="black",linewidth = 0.4) + 
      theme_minimal() +
      labs(caption = "Source : INSEE, SDES et CDC")+
      scale_fill_gradient2(low="royalblue2",
                           mid="white",
                           high="orangered1",
                           midpoint = 0,
                           name = "Variation du loyer %",
                           guide = guide_colorbar(
                             title.position = "top",
                             barwidth = 2.5,           
                             barheight = 16,
                             frame.colour = "black"
                           ))+
      ggtitle("Variation du loyer moyen des logements sociaux par département entre 2016 et 2021",subtitle = expression("La variation se fait sur le loyer en m"^2))+
      theme(legend.title = element_text(face = "bold",hjust=0.5,size = 14),
            legend.text = element_text(size = 14),
            plot.title = element_text(face = "bold", size = 16),
            plot.subtitle = element_text(face = "italic", size = 14),
            axis.title = element_blank(),
            axis.text = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            plot.caption = element_text(face="italic",size=12)
            )
    
  })
  
  output$titre_intro <- renderUI({
    h3(paste0(titles[input$var]," entre ",input$annee[1]," et ",input$annee[2]))
  })
  
  
#Carte pour année 1  
  output$genMap_1 <- renderPlot({
    lims <- var_limits()
    pals <- get_palette(input$var)
    
    
    france_dep_data %>%
      filter(année_publication==input$annee[1]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="black") + 
      theme_minimal() +
      scale_fill_gradientn(colors = pals,
                           limits=lims)+
      theme(legend.position = "none",
            axis.title = element_blank(),
            axis.text = element_blank(),
            panel.grid = element_blank())
    
  })
#Carte pour année 2
  output$genMap_2 <- renderPlot({
    lims <- var_limits()
    pals <- get_palette(input$var)
    legend_title <- labels[which(colnames(france_dep_data)[10:34] == input$var)]
    
    if (grepl("Parc social", legend_title, ignore.case = TRUE)) {
      legend_title <- sub("Parc social", "PS", legend_title, ignore.case = TRUE)
    }
    
    france_dep_data %>%
      filter(année_publication==input$annee[2]) %>% 
      ggplot(aes(x=long,y=lat,group=group,fill=.data[[input$var]]))+ 
      geom_polygon(col="black") + 
      theme_minimal() +
      scale_fill_gradientn(colors = pals,
                           limits=lims,
                           guide = guide_colorbar(
                             title.position = "top",
                             barwidth = unit(1.8, "cm"),
                             barheight = unit(8, "cm"), 
                             frame.colour = "black"))+
      labs(fill=legend_title) +
      theme(
            legend.position = "right",
            legend.box = "vertical",
            legend.key.size = unit(0.4,'cm'),
            legend.text = element_text(size = 9), 
            legend.title = element_text(size = 10),
            legend.spacing = unit(1.0,"cm"),
            axis.title = element_blank(),
            axis.text = element_blank(),
            panel.grid = element_blank())+
      labs(fill = str_wrap(legend_title, width = 10))
  })
  
  output$annee_map_1 <- renderText({
    paste("Année :", input$annee[1])
  })
  
  output$annee_map_2 <- renderText({
    paste("Année :", input$annee[2])
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
  
  output$summaryTable <- renderPrint({options(width = 150)
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
  
  output$plot_tx_accroissement <- renderPlot({
    df_plot <- dta %>%
      filter(nom_departement %in% input$dep_plot_tx_acroissement) %>%
      select(année_publication, valeur = taux_accroissement) %>% 
      mutate(année_publication = factor(année_publication, levels = sort(unique(année_publication))))
    
    ggplot(df_plot, aes(x = année_publication, y = valeur, group = 1)) +
      geom_line(color = "#3182bd", size = 1.2) +
      geom_point(color = "#3182bd", size = 2) +
      labs(x = "Années", y = "Taux d'accroissement", title = "Variation du taux d'accroissement par département entre 2016 et 2021" ) +
      theme_minimal()
  })
  
  output$plot_age_pop <- renderPlot({
    
    df_plot <- dta %>%
      filter(nom_departement %in% input$dep_plot_tx_acroissement) %>%
      summarise(
        mean_inf20 = mean(pop_inf20, na.rm = TRUE),
        mean_20_60 = mean(pop_20_60, na.rm = TRUE),
        mean_sup60 = mean(pop_sup60, na.rm = TRUE)
      )
    
    df_bar <- data.frame(
      tranche = factor(c("<20 ans", "20-60 ans", ">60 ans"), levels = c("<20 ans", "20-60 ans", ">60 ans")),
      population = c(
        mean(df_plot$mean_inf20, na.rm = TRUE),
        mean(df_plot$mean_20_60, na.rm = TRUE),
        mean(df_plot$mean_sup60, na.rm = TRUE)
      )
    )
    
    ggplot(df_bar, aes(x = tranche, y = population, fill = tranche)) +
      geom_bar(stat = "identity", show.legend = FALSE) +
      scale_fill_manual(values = c("darkgreen", "gold", "deeppink4")) +
      labs(x = NULL, y = "Population moyenne",
           title = paste("Population moyenne par tranche d'âge -", input$dep_plot_tx_acroissement)) +
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
    
    #Graphique par département
    if (input$niveau == "nom_departement") {
      df_plot <- dta %>% 
        group_by(nom_departement) %>% 
        summarise(valeur_moy = mean(.data[[input$var_parc]], na.rm = TRUE))
      
      p <- ggplot(df_plot, aes(
        x = valeur_moy,
        y = reorder(nom_departement, valeur_moy),
        text = paste(nom_departement, ":", round(valeur_moy, 1))
      )) +
        geom_col(fill = "#3182bd") +
        labs(
          title = "Moyenne entre 2016 et 2021",
          x = NULL,
          y = NULL
        ) +
        scale_x_continuous(
          expand = c(0, 0),
          limits = c(0, NA),
          labels = scales::label_number(accuracy = 0.1, big.mark = " ")
        )+
        theme_minimal()
    
    #Graphique par région
    } else if (input$niveau == "nom_region") {
      df_plot <- dta %>% 
        group_by(nom_region) %>% 
        summarise(valeur_moy = mean(.data[[input$var_parc]], na.rm = TRUE))
      
      p <- ggplot(df_plot, aes(
        x = valeur_moy,
        y = reorder(nom_region, valeur_moy),
        text = paste(nom_region, ":", round(valeur_moy, 1))
      )) +
        geom_col(fill = "#3182bd") +
        labs(
          title = "Moyenne sur la période 2016-2021",
          x = NULL,
          y = input$var_parc
        ) +
        scale_x_continuous(
          expand = c(0, 0),
          limits = c(0, NA),
          labels = scales::label_number(accuracy = 0.1, big.mark = " ")
        )
    }
    ggplotly(p, tooltip = "text")
  })
  
  output$parc_social_graph2 <- renderPlot({
    
    df_plot <- dta %>%
      filter(nom_departement %in% input$dep_graph2) %>%
      select(année_publication, valeur = all_of(input$var_graph2)) %>% 
      mutate(année_publication = factor(année_publication, levels = sort(unique(année_publication)))) %>% 
      filter(!is.na(valeur))
    
    df_plot <- df_plot
    
    ggplot(df_plot, aes(x = année_publication, y = valeur, group = 1)) +
      geom_line(color = "#3182bd", size = 1.2) +
      geom_point(color = "#3182bd", size = 2) +
      labs(x = NULL, y = NULL, title = NULL) +
      ggtitle(label="à faire",subtitle=paste0("Département :", str_to_sentence(input$dep_graph2)))+
      theme_minimal()+
      scale_x_discrete(expand = c(0.01, 0.01))+
      theme(axis.text = element_text(size=14,face="bold"))
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
  
  output$ACP_ind <- renderPlot({
    plot.PCA(ACP_social,choix = "ind")
  })
  
  output$ACP_var <- renderPlot({
    plot.PCA(ACP_social,choix = "var")
  })
    
  
  output$bivariate_plot <- renderPlot({
    ggplot(france_dep_data, aes(x = .data[[input$var_x]], y = .data[[input$var_y]])) +
      geom_point(alpha = 0.6, color = "#2C3E50") +
      geom_smooth(method = "lm", se = FALSE, color = "#E74C3C") +
      theme_minimal() +
      labs(
        x = input$var_x,
        y = input$var_y,
        title = paste("Relation entre", input$var_x, "et", input$var_y)
      )
  })
  
  output$correlation_plot <- renderPlot({
    corrplot(cor_matrix,
             tl.cex = 0.6)})
}

