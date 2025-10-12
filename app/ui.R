ui <- navbarPage("Pavillon'R",
                 theme=shinytheme("united"),
                   source("../ui/ui_intro.R", local = TRUE)$value,
                   source("../ui/ui_carte.R", local = TRUE)$value,
                   source("../ui/ui_demographie.R", local = TRUE)$value,
                   source("../ui/ui_parc_social.R", local = TRUE)$value,
                   source("../ui/ui_ACP.R", local = TRUE)$value,
                   source("../ui/ui_donnees.R", local = TRUE)$value,
                   source("../ui/ui_info.R", local = TRUE)$value
                   
)

