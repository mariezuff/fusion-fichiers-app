output$render_def_files_UI <- renderUI({
  
  
  list(
    fluidPage(
      
      # Input widgets
      fluidRow(
        ################# >>>>>>>> LEFT PANEL
         h3("Fichiers à fusionner :"),
                                     checkboxInput('files_demo', 'Fichiers démo', TRUE),
                                     conditionalPanel(
                                       condition="input.files_demo == false",
                                       fileInput("all_files",
                                                 label=("Fichiers à fusionner"),
                                                 multiple=TRUE, placeholder="--- Sél. fichiers ---")
                                     ),
         # h4("fichiers chargés :"),
        uiOutput("noms_fichiers")

      )
    ) # end fluidpage
  ) 
})  # end renderUI

output$noms_fichiers <- renderUI({

  myfiles <- get_tomerge_filenames()
  if(length(myfiles) == 0) return(NULL)
  HTML(paste0("<h4><u>Fichiers chargés</u> :</h4><br>", paste0(myfiles, collapse="<br>")))
  
})
