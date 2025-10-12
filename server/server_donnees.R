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

output$bivariate_plot <- renderPlotly({
  
  titre1 <- titre_bivaries[[input$var_x]]
  titre2 <- titre_bivaries[[input$var_y]]
  
  
  plot <- ggplot(dta, aes(x = .data[[input$var_x]], 
                          y = .data[[input$var_y]]))+
    geom_point(aes(text = paste("Département :", str_to_sentence(dta$nom_departement),
                                "<br>Année :", dta$année_publication)),alpha = 0.6, color = "orangered2") +
    theme_minimal() +
    labs(caption = "Source : INSEE, SDES et CDC")+
    labs(
      x = noms_var[[input$var_x]],
      y = noms_var[[input$var_y]],
      title = paste("Relation entre", titre1, "et", titre2)
    )
  
  ggplotly(plot, tooltip = "text")
  
})

output$correlation_plot <- renderPlot({
  corrplot(cor_matrix,
           tl.cex = 0.6)})