source("app/global.R")
source("app/librairy.R")
source("app/ui.R")
source("app/server.R")

# Run the application 
shinyApp(ui = ui, server = server)
