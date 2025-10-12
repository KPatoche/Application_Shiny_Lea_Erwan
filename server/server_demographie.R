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
          axis.line = element_line(color = "black", size = 1.2))+
    scale_y_continuous(expand = c(0, 0))
})