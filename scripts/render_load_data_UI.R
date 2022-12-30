
observe({
  
  if(!is.null(input$files_demo)) {
    
    myfiles <- get_tomerge_files()
    cat(paste0("myfiles = ", paste0(myfiles, collapse=","), "\n"))
    
    if (!is.null(myfiles)  ) {
      max_table = length(myfiles)
      lst <- list()
      for (i in 1:max_table) {

          lst[[i]] <-
            read_excel(
              myfiles[i]
            )
      }
      
      ###********************************************** 
      ###************************* LOADED DATA PAGE
      ###********************************************** 
      
      ####### DEFINE THE UI WHERE LOADED DATA PUT
      output$render_load_data_UI <- renderUI({
        Panels <- lapply(1:max_table, function(number){
          tabPanel(paste0("Fichier #", number),
                   fluidRow(
                     DTOutput( paste("tablename", number, sep = ""))
                   ),
                   fluidRow(column(6,
                                  uiOutput(paste0("colnametable", number))),
                            column(6, actionButton(paste0("màj_", number),paste0("Mettre à jour en-tête"),
                                                   class = "btn-primary")))
                   
          )
        })
        do.call(tabsetPanel,Panels)
      }) #### end renderUI loaded data
      ####### POPULATE THE UI WHERE LOADED DATA PUT
      for (i in 1:max_table) {
        local({
          my_i <- i
          tablename <- paste("tablename", my_i, sep = "")
          output[[tablename]] <- DT::renderDataTable({
            lst[[my_i]]
          }, 
          rownames= FALSE,
          server = FALSE,
          filter="top",
          options = renderDT_settings)
          
          output[[paste0("colnametable",my_i)]] <- renderUI({
            lapply(1:ncol( lst[[my_i]]), function(k){
            var_name <- paste("Colonne",k)
            var_value <- colnames( lst[[my_i]])[k]
            textInput(paste0("file", my_i, "_col", k),
                      var_name, 
                      var_value
                      # paste0("file", my_i, "_col", k)
                      )
          })
          })
        })
      }
      ####### BEHAVIOUR OF THE MAJ BUTTONS
      lapply(1:max_table, function(itab) {
        observeEvent(input[[paste0("màj_", itab)]], {
          dt1 <- lst[[itab]]
          ncol1 <- ncol(dt1) 
          newcols <- sapply(1:ncol1, function(x) input[[paste0("file", itab,"_col", x)]])
          colnames(dt1) <- newcols
          lst[[itab]] <<- dt1
          output[[paste0("tablename", itab)]] <- DT::renderDataTable({
            dt1
          }, 
          rownames= FALSE,
          server = FALSE,
          filter="top",
          options = renderDT_settings)
        })
      }) #### end define màj buttons
      
      
      
      ###********************************************** 
      ###************************* MERGING DATA PAGE
      ###********************************************** 
      # wellPanel(h3("Sélection des colonnes"),
      #           uiOutput("colselect_rep02")
      #           output$colselect_rep02 <- renderUI({
      #             cn <- colnames(get_rep02_data())
      #             # cat(paste0("cn = ", paste0(cn, collapse=","), "\n"))
      #             # cat(paste0("cn[cn %in% r02_defaultcols] = ", paste0(cn[cn %in% r02_defaultcols], collapse=","), "\n"))
      #             checkboxGroupInput("rep02_columns", "", 
      #                                choices  = cn,
      #                                selected = cn[cn %in% r02_defaultcols], inline=TRUE)
      #           })
                
      
      ####### DEFINE THE UI WHERE MERGED DATA PUT
      output$render_merged_data_UI <- renderUI({
          tabPanel(paste0("Colonnes à fusionner"),
                   lapply(1:max_table, function(number){ 
                     fluidRow(
                       column(12, uiOutput(paste0("colselect_tit", number))),
                       column(12, uiOutput(paste0("colselect_fichier", number))))
                   })
          )
      })
      ####### POPULATE THE UI WHERE LOADED DATA PUT
      for (i in 1:max_table) {
        local({
          my_i <- i
          cn <- colnames(lst[[my_i]])
          output[[paste0("colselect_fichier", my_i)]] <- renderUI({checkboxGroupInput(paste0("fichier", my_i, "_columns"), 
                                                                                      "", 
                                                                                      choices  = cn,
                                                                                      selected = cn, 
                                                                                      inline=TRUE)})
          
          
          output[[paste0("colselect_tit", my_i)]] <- renderUI({
            HTML(paste0("<h4>Choix colonne fichier ", my_i, "</h4>"))})
            
          
          
        })
      }
      
      lapply(1:max_table, function(itab) {
        observeEvent(input[[paste0("màj_", itab)]], {
        local({
          my_i <- itab
          cn <- colnames(lst[[my_i]])
          output[[paste0("colselect_fichier", my_i)]] <- renderUI({checkboxGroupInput(paste0("fichier", my_i, "_columns"), 
                                                                            "", 
                                                                            choices  = cn,
                                                                            selected = cn, 
                                                                            inline=TRUE)})
            })
        })
      })
      
      output[["colonnes_jointure"]] <- renderUI({

              
      all_cn <- lapply(1:max_table, function(itab) {
        input[[paste0("fichier", itab, "_columns")]]})

        cn <- Reduce(intersect,all_cn)
        
        checkboxGroupInput(paste0("jointure_columns"), 
                                    "", 
                                    choices  = cn,
                                    selected = cn, 
                                    inline=TRUE)
        
        })
      
      # output[[paste0("merged_data_DT")]] <- DT::renderDataTable(data.frame(" " ="Aucun fichier fusionné"))
      output[[paste0("merged_data_DT")]] <- NULL
      
      observeEvent(input[[paste0("fusion_fichier")]], {
        
        colsel_tables <- lapply(1:max_table, function(itab) {
          keep_cols <- input[[paste0("fichier", itab, "_columns")]]
          mydt <- lst[[itab]]
          mydt[,c(keep_cols), drop=FALSE]
          })
        
        common_cols <- unlist(lapply(colsel_tables, colnames))
        cat(paste0("common_cols = ", paste0(common_cols, collapse=","), "\n"))
        
        mergecol <- input[[paste0("jointure_columns")]]
        
        save(mergecol, file="mergecol.Rdata")
        
        if(length(mergecol) < 1 | is.null(mergecol)) {
          
          output[[paste0("merged_data_DT")]] <- NULL
          # output[[paste0("merged_data_DT")]] <- DT::renderDataTable({
          #   data.frame(" " ="Choisir ou définir au moins 1 colonne commune")
          # }, rownames= FALSE, colnames= FALSE)

        } else {
          melt_dt <- Reduce(function(x, y) merge(x, y, all=TRUE, by=mergecol), colsel_tables)  
          
          output[[paste0("merged_data_DT")]] <- DT::renderDataTable({
            melt_dt
          }, 
          rownames= FALSE,
          server = FALSE,
          filter="top",
          options = renderDT_settings)
          
        }
          
        

      })
      
      
    } # end if(!is.null(myfiles))
    
  } # end-if(!is.null(input$files_demo)) 
  
})