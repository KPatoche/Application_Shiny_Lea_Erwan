
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
    theme(axis.text = element_text(size=16),
          axis.title = element_text(size = 18,face="bold"),
          axis.line = element_line(color = "black", size = 1.2))
})