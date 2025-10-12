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
  
  df_plot <-dta %>%
    group_by(année_publication) %>%
    summarise(Energivore = sum(social_tx_energivores*social_nb_logements,na.rm=T)/sum(social_nb_logements,na.rm=T))
  
  diff_val <- df_plot$Energivore[df_plot$année_publication == 2020] -
    df_plot$Energivore[df_plot$année_publication == 2019]
  diff_text <- paste0(round(diff_val, 2), "%") 
  
  df_plot %>% 
    ggplot(aes(x=année_publication,y=Energivore,group = 1))+
    geom_line(color ="orangered2",size=1.7)+
    geom_point(color ="orangered2",size=2.5)+
    labs(caption = "Source : INSEE, SDES et CDC")+
    ggtitle("Evolution du pourcentage de logement sociaux énergivores en France métropolitaine de 2016 à 2021",subtitle = "La barre verticale représente une rupture brutale à l'échelle nationale avec une cause incertaine")+
    labs(x=NULL,y="Pourcentage de logements sociaux énergivores")+
    scale_y_continuous(labels = function(x) paste0(x, "%"))+
    theme(panel.background = element_rect(fill = "white"),
          legend.position = "none",
          axis.line = element_line(color = "black", size = 1.2),
          plot.title = element_text(face = "bold", size = 18),
          axis.text = element_text(size=14),
          axis.title = element_text(size=16),
          panel.grid.minor.y= element_line(colour="gray"),
          plot.subtitle = element_text(size=15))+
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
    geom_line(aes(color=nom_departement, group=nom_departement),alpha=0.3,size=1.7)+
    geom_point(aes(color=nom_departement),size=2.5,alpha = 0.5)+
    ggtitle("Evolution du pourcentage de logement sociaux énergivores par département de 2016 à 2021",subtitle = "La barre verticale représente une rupture brutale à l'échelle nationale avec une cause incertaine")+
    labs(x=NULL,y="Pourcentage de logements sociaux énergivores")+
    scale_y_continuous(labels = function(x) paste0(x, "%"))+
    theme(panel.background = element_rect(fill = "white"),
          legend.position = "none",
          axis.line = element_line(color = "black", size = 1.2),
          plot.title = element_text(face = "bold", size = 18),
          axis.text = element_text(size=14),
          axis.title = element_text(size=16),
          panel.grid.minor.y= element_line(colour="gray"),
          plot.subtitle = element_text(size=15))+
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