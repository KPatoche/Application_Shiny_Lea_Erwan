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
  
  plot.PCA(resACP, invisible=invisible_opt, title="Graphe des individus de l'ACP", label='quali')+
    theme(plot.title = element_text(size=18),
          axis.title = element_text(size=16))
})

output$ACP_var <- renderPlot({
  df <- ACP_social()  # <- important !
  resACP <- PCA(df, quali.sup=c(1),quanti.sup=c(2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18),graph=FALSE) # Ajuster quali.sup selon tes données
  plot.PCA(resACP,choix = "var")+
    theme(plot.title = element_text(size=18),
          axis.title = element_text(size=16))
})
