
# setwd("//infra.vs.ch/dfs/SCA-DLW/PDIRECTS/1_Marie/7_dev/shiny/prep_pdirg")


options(scipen=100)

library(openxlsx)
library(stringr)
library(readxl)
library(shiny)
library(shinyjs)


all_files_demo <- c("data/liste_exploitations_animaux_demo.XLSX",
                    "data/liste_exploitations_bdta_demo.XLSX",
                    "data/liste_exploitations_exploitants_demo.XLSX")

source("settings/shiny_settings.R")
source("scripts/shiny_functions.R")

NUM_PAGES <- 3

liste_choix <- c("1" = "Accueil", 
                 "2" = "Données", 
                 "3" = "Fusion"
)



server<- shinyServer(function(input, output, session){
  
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  show("app-content")
  
  
  
  get_tomerge_filenames <- reactive({
    if(input$files_demo){
      tomergefiles <- basename(all_files_demo)
    } else {
      tomergefiles <- input$all_files$name    
    }
    return(tomergefiles)
  })
  
  get_tomerge_files <- reactive({
    cat(paste0("input$files_demo = ", input$files_demo, "\n"))
    if(input$files_demo){
      tomergefiles <- all_files_demo
    } else {
      tomergefiles <- input$all_files$datapath    
    }
    return(tomergefiles)
  })

  
  shinyjs::hide(id = paste0("num"))
  
  rnfiles <- length(all_files_demo)
  makeReactiveBinding('rnfiles')
  

  rv <- reactiveValues(page = 1)
  
  n <- 1
  makeReactiveBinding('n')
  
  
  observe({
    toggleState(id = "prevBtn", condition = rv$page > 1)
    toggleState(id = "nextBtn", condition = rv$page < NUM_PAGES)
    hide(selector = ".page")
    show(paste0("step", rv$page))
  })
  
  navPage <- function(direction) {
    rv$page <- rv$page + direction
  }
  
  observeEvent(input$prevBtn, {
    navPage(-1)
    n <<- n - 1 
    cat(paste0("nouvelle valeur de n: ", n, "\n"))
    updateNumericInput(session, 'num', value = n)
    })
  
  observeEvent(input$nextBtn, {
    navPage(1)
    n <<- n + 1 
    cat(paste0("nouvelle valeur de n: ", n, "\n"))
    updateNumericInput(session, 'num', value = n)
    })
  
  # output$curr_num <- renderUI({
  # HTML(paste0("input.num = ", input$num, "\n"))
  # })
  
  # --------------------------------------------------------------------------------- #
  # outputs for the different apps #
  
  #### UI POUR DéFINIR LE NOMBRE DE FICHIERS à CHARGER
  source(file = "scripts/render_def_files_UI.R", encoding="UTF-8", local = TRUE)
  output$def_files_UI <- renderUI({
    mainPanel(
      uiOutput("render_def_files_UI"),
      width=12
    )
  })
  
  #### UI POUR CHARGER ET AFFICHER LES DIFFERENTS FICHIERS
  source(file = "scripts/render_load_data_UI.R", encoding="UTF-8", local = TRUE)
  output$load_data_UI <- renderUI({
    mainPanel(
      uiOutput('render_load_data_UI'),
      width = 12)
  })
  
  #### UI POUR LES FICHIERS FUSIONNES
  # source(file = "scripts/render_merged_data_UI.R", encoding="UTF-8", local = TRUE)
  output$merged_data_UI <- renderUI({
    mainPanel(
      uiOutput("render_merged_data_UI"),
      h3("Colonnes de jointure"),
      uiOutput("colonnes_jointure"),
      actionBttn("fusion_fichier", "Fusionner"),
      DTOutput("merged_data_DT"),
      width=12
    )
  })
  
})