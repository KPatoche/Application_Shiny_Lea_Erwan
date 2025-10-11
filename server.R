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
                        "social_loyer_m2","tx_log_vac")) {  
      return(c("royalblue2","white","orangered1"))
    } else if (var_name %in% c("habitants","densite_km2","pop_inf20","pop_sup60","nb_logements","tx_log_ind")){
      return(c("white","orangered1")) 
    } else{ 
      return(c("orangered1","white","royalblue2"))}
  }
  
  output$visu1 <- renderPlot({
    
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
            plot.title = element_text(face = "bold", size = 18),
            plot.subtitle = element_text(face = "italic", size = 15),
            axis.title = element_blank(),
            axis.text = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            plot.caption = element_text(face="italic",size=12)
            )
    
  })
  
  output$visu2 <- renderPlot({
    
    dta %>%
      group_by(année_publication) %>%
      summarise(Energivore = sum(social_tx_energivores*social_nb_logements,na.rm=T)/sum(social_nb_logements,na.rm=T)) %>% 
      ggplot(aes(x=année_publication,y=Energivore,group = 1))+
      geom_line(color ="orangered2",size=1.2)+
      geom_point(color ="orangered2",size=2)+
      labs(caption = "Source : INSEE, SDES et CDC")+
      ggtitle("Evolution du pourcentage de logement sociaux énergivores en France métropolitaine de 2016 à 2021")+
      labs(x=NULL,y="Pourcentage de logements sociaux énergivores")+
      scale_y_continuous(labels = function(x) paste0(x, "%"))+
      theme(panel.background = element_rect(fill = "white"),
            legend.position = "none",
            axis.line = element_line(color = "black", size = 1.2),
            plot.title = element_text(face = "bold", size = 18),
            axis.text = element_text(size=14),
            axis.title = element_text(size=16),
            panel.grid.minor.y= element_line(colour="gray"))+
      scale_x_discrete(expand = c(0.01, 0.01))+
      geom_vline(xintercept = "2020", 
                 linetype = "dashed", 
                 color = "black", 
                 linewidth = 0.8)
            
  })
  
  output$visu3 <- renderPlot({
    dta %>%
      group_by(année_publication) %>%
      ggplot(aes(x=année_publication,y=social_tx_energivores))+
      labs(caption = "Source : INSEE, SDES et CDC")+
      geom_line(aes(color=nom_departement, group=nom_departement),alpha=0.3,size=1.2)+
      geom_point(aes(color=nom_departement),size=2,alpha = 0.5)+
      ggtitle("Evolution du pourcentage de logement sociaux énergivores par département de 2016 à 2021")+
      labs(x=NULL,y="Pourcentage de logements sociaux énergivores")+
      scale_y_continuous(labels = function(x) paste0(x, "%"))+
      theme(panel.background = element_rect(fill = "white"),
            legend.position = "none",
            axis.line = element_line(color = "black", size = 1.2),
            plot.title = element_text(face = "bold", size = 18),
            axis.text = element_text(size=14),
            axis.title = element_text(size=16),
            panel.grid.minor.y= element_line(colour="gray"))+
      scale_x_discrete(expand = c(0.01, 0.01))+
      geom_vline(xintercept = "2020", 
                 linetype = "dashed", 
                 color = "black", 
                 linewidth = 0.8)
    
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
      labs(caption = "Source : INSEE, SDES et CDC")+
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
            legend.text = element_text(size = 14), 
            legend.title = element_text(size = 18),
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
    dta[,-c(31,32,33,34,35,36)],
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
    dta_summary <- dta[,-c(31,32,33,34,35,36)]
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
      geom_line(color = "orangered1", size = 1.2) +
      geom_point(color = "orangered1", size = 2) +
      labs(caption = "Source : INSEE, SDES et CDC")+
      labs(x = "Années", y = "Taux d'accroissement") +
      ggtitle ("Variation du taux d'accroissement par département entre 2016 et 2021" , subtitle = paste0("Département : ",str_to_sentence(input$dep_plot_tx_acroissement)) )+
      theme_minimal()+
      theme(plot.title = element_text(size=16,face="bold"),
            axis.title = element_text(size=14,face="bold"),
            axis.text = element_text(size=12),
            axis.line = element_line(color = "black", size = 1.2))
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
      scale_fill_manual(values = c("gold", "orange", "orangered2")) +
      labs(x = NULL, y = "Population moyenne")+
      ggtitle("Population moyenne par tranche d'âge",subtitle = paste0("Département : ",str_to_sentence(input$dep_plot_tx_acroissement))) +
      theme_minimal()+
      labs(caption = "Source : INSEE, SDES et CDC")+
      theme(plot.title = element_text(size=16,face="bold"),
            axis.title = element_text(size=14,face="bold"),
            axis.text = element_text(size=12),
            axis.line = element_line(color = "black", size = 1.2))
  })
    
  
  output$box<- renderPlot({
    dta %>%
      mutate(année_publication = as.factor(dta$année_publication)) %>% 
      ggplot(aes(x=année_publication,y=tx_pauvrete,fill=année_publication))+
      geom_boxplot()+
      geom_jitter()+
      theme_minimal()
  })
  
  
  # output$lines<- renderPlot({
  #   dta %>%
  #     mutate(année_publication = as.factor(dta$année_publication)) %>% 
  #     group_by(année_publication) %>% 
  #     summarise(mean_pauvrete = mean(tx_pauvrete,na.rm=T)) %>% 
  #     ggplot(aes(x=année_publication,y=mean_pauvrete))+
  #     geom_point()+
  #     theme_minimal()
  # })
  
  output$titre_parc_social <- renderUI({
    
    titre_plot <- switch(input$var_parc,
                         "tx_log_sociaux" = "Moyenne du taux de logements sociaux (en %) pour la période 2016-2021",
                         "social_nb_logements" = "Moyenne du nombre de logements dans le parc social pour la période 2016-2021",
                         "social_location" = "Moyenne du nombre de logements loués dans le parc social pour la période 2016-2021",
                         "social_demoli" = "Moyenne du nombre de logements démolis dans le parc social pour la période 2016-2021",
                         "social_ventes_physiques" = "Moyenne du nombre de logements du parc social vendus à des personnes physiques pour la période 2016-2021",
                         "social_vacants" = "Moyenne du taux de logements vacants (en %) dans le parc social pour la période 2016-2021",
                         "social_individuel" = "Moyenne du taux de logements individuels (en %) dans le parc social pour la période 2016-2021",
                         "social_loyer_m2" = "Loyer moyen du parc social (en €/m²/mois) pour la période 2016-2021",
                         "social_age_moyen" = "Âge moyen du parc social (en années) pour la période 2016-2021",
                         "social_tx_energivores" = "Moyenne du taux de logements énergivores (E,F,G) (en %) dans le parc social pour la période 2016-2021"
    )
    h3(titre_plot, style = "text-align: center; font-weight: bold;")
  })
  
  output$titre_parc_social2 <- renderUI({
    
    titre_plot <- switch(input$var_graph2,
                         "tx_log_sociaux" = "Evolution du taux de logements sociaux (en %) pour la période 2016-2021",
                         "social_nb_logements" = "Evolution du nombre de logements dans le parc social pour la période 2016-2021",
                         "social_location" = "Evolution du nombre de logements loués dans le parc social pour la période 2016-2021",
                         "social_demoli" = "Evolution du nombre de logements démolis dans le parc social pour la période 2016-2021",
                         "social_ventes_physiques" = "Evolution du nombre de logements du parc social vendus à des personnes physiques pour la période 2016-2021",
                         "social_vacants" = "Evolution du taux de logements vacants (en %) dans le parc social pour la période 2016-2021",
                         "social_individuel" = "Evolution du taux de logements individuels (en %) dans le parc social pour la période 2016-2021",
                         "social_loyer_m2" = "Evolution du loyer moyen du parc social (en €/m²/mois) pour la période 2016-2021",
                         "social_age_moyen" = "Âge moyen du parc social (en années) pour la période 2016-2021",
                         "social_tx_energivores" = "Evolution du taux de logements énergivores (E,F,G) (en %) dans le parc social pour la période 2016-2021"
    )
    h3(titre_plot, style = "text-align: center; font-weight: bold;")
  })
  
  output$dep_selected <- renderUI({
    req(input$dep_graph2)
    div(
      style = "text-align: center; margin-bottom: 10px;",
      h4(paste("Département :", str_to_sentence(input$dep_graph2)))
    )
  })
 
  output$parc_social_plot <- renderPlotly({
    
    noms_var <- c(
      tx_log_sociaux = "Taux de logements sociaux (en %)",
      social_nb_logements = "Parc social - Nombre de logements",
      social_location = "Parc social - Logements mis en location",
      social_demoli = "Parc social - Logements démolis",
      social_ventes_physiques = "Parc social - Ventes à des personnes physiques",
      social_vacants = "Parc social - Taux de logements vacants (en %)",
      social_individuel = "Parc social - Taux de logements individuels (en %)",
      social_loyer_m2 = "Parc social - Loyer moyen (en €/m²/mois)",
      social_age_moyen = "Parc social - Âge moyen du parc (en années)",
      social_tx_energivores = "Parc social - Taux de logements énergivores (E,F,G) (en %)"
    )
    
    x_label <- noms_var[[input$var_parc]]
    
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
        geom_col(fill = "orangered1") +
        labs(x = x_label,y = NULL, title = NULL) + 
        theme(
          panel.background = element_rect(fill = "white"),
          panel.grid.major.x = element_line(color = "grey80"),
          panel.grid.major.y = element_blank()) +
        labs(caption = "Source : INSEE, SDES et CDC")+
        scale_x_continuous(
          expand = c(0, 0),
          limits = c(0, NA),
          labels = scales::label_number(accuracy = 0.1, big.mark = " ")
        )

    
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
        labs(caption = "Source : INSEE, SDES et CDC")+
        geom_col(fill = "orangered1") +
        labs(x = x_label, y = NULL, title = NULL) +
        theme(
          panel.background = element_rect(fill = "white"),
          panel.grid.major.x = element_line(color = "grey80"),
          panel.grid.major.y = element_blank()) +
        scale_x_continuous(
          expand = c(0, 0),
          limits = c(0, NA),
          labels = scales::label_number(accuracy = 0.1, big.mark = " ")
        )
    }
    ggplotly(p, tooltip = "text") %>% layout(title = list(text = ""))
  })
  
  output$parc_social_graph2 <- renderPlot({
    
    noms_var <- c(
      tx_log_sociaux = "Taux de logements sociaux (en %)",
      social_nb_logements = "Parc social - Nombre de logements",
      social_location = "Parc social - Logements mis en location",
      social_demoli = "Parc social - Logements démolis",
      social_ventes_physiques = "Parc social - Ventes à des personnes physiques",
      social_vacants = "Parc social - Taux de logements vacants (en %)",
      social_individuel = "Parc social - Taux de logements individuels (en %)",
      social_loyer_m2 = "Parc social - Loyer moyen (en €/m²/mois)",
      social_age_moyen = "Parc social - Âge moyen du parc (en années)",
      social_tx_energivores = "Parc social - Taux de logements énergivores (E,F,G) (en %)"
    )
    
    y_label <- noms_var[[input$var_graph2]]
    
    df_plot <- dta %>%
      filter(nom_departement %in% input$dep_graph2) %>%
      select(année_publication, valeur = all_of(input$var_graph2)) %>% 
      mutate(année_publication = factor(année_publication, levels = sort(unique(année_publication)))) %>% 
      filter(!is.na(valeur))
    
    df_plot <- df_plot
    
    ggplot(df_plot, aes(x = année_publication, y = valeur, group = 1)) +
      geom_line(color = "orangered1", size = 1.2) +
      geom_point(color = "orangered1", size = 2) +
      labs(x = NULL, y = y_label, title = NULL) +
      theme_minimal()+
      labs(caption = "Source : INSEE, SDES et CDC")+
      scale_x_discrete(expand = c(0.01, 0.01))+
      theme(axis.text = element_text(size=14),
            axis.title = element_text(size = 18,face="bold"),
            axis.line = element_line(color = "black", size = 1.2))
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
  
  ACP_social <- reactive({
    cat_sel <- input$ACP_categorie
    
    if(cat_sel == "annee") {
      # Supprimer colonnes 2 et 3
      pre_acp$completeObs[ , -c(2,3)]
    } else if(cat_sel == "departement") {
      # Supprimer colonnes 1 et 3
      pre_acp$completeObs[ , -c(1,3)]
    } else if(cat_sel == "region") {
      # Supprimer colonnes 2 et 3
      pre_acp$completeObs[ , -c(1,2)]
    }
  })
  
  
  
  output$ACP_ind <- renderPlot({
    df <- ACP_social() 
    
    invisible_opt <- if (input$afficher_individus) NULL else "ind"
    
    
    resACP <- PCA(df, quali.sup=c(1),quanti.sup=c(2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18),graph=FALSE)
    
    plot.PCA(resACP, invisible=invisible_opt, title="Graphe des individus de l'ACP", label='quali')
  })
  
  output$ACP_var <- renderPlot({
    df <- ACP_social()  # <- important !
    resACP <- PCA(df, quali.sup=c(1),quanti.sup=c(2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18),graph=FALSE) # Ajuster quali.sup selon tes données
    plot.PCA(resACP,choix = "var")
  })
    
  
  output$bivariate_plot <- renderPlotly({
    plot <- ggplot(france_dep_data, aes(x = .data[[input$var_x]], 
                                y = .data[[input$var_y]]),
                                text = paste("Département :", france_dep_data$Departement, 
                                "<br>Année :", france_dep_data$Annee)) +
      geom_point(alpha = 0.6, color = "orangered2") +
      theme_minimal() +
      labs(caption = "Source : INSEE, SDES et CDC")+
      labs(
        x = input$var_x,
        y = input$var_y,
        title = paste("Relation entre", input$var_x, "et", input$var_y)
      )
    
    ggplotly(plot, tooltip = "text")
    
  })
  
  output$correlation_plot <- renderPlot({
    corrplot(cor_matrix,
             tl.cex = 0.6)})
}

