# multi-pages https://github.com/daattali/advanced-shiny/blob/master/multiple-pages/
# loading screen https://github.com/daattali/advanced-shiny/blob/master/loading-screen/app.R
### in setwd("//infra.vs.ch/dfs/SCA-DLW/PDIRECTS/1_Marie/7_dev/shiny/fusion-fichiers")

options(scipen=100)

library(shiny)
library(shinythemes)

library(DT)
library(shinycssloaders)
library(fontawesome)
library(shinyWidgets)

library(shiny)
library(shinyjs)


library(openxlsx)
library(stringr)
library(readxl)

library(shinycssloaders)
library(shinybusy)
NUM_PAGES <- 3

globalreactive <- reactiveValues(num=1)

source("scripts/shiny_functions.R")

spinnerCol <- "#006600"

appCSS <- "
#loading-content {
  position: absolute;
  background: #000000;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #FFFFFF;
}
"

fluidPage(
  
  use_busy_spinner(spin = "fading-circle"),
  
  
  useShinyjs(),
  
  inlineCSS(appCSS),
  
  tags$head(HTML(get_buttons_style(dwdButtons="prevBtn",
                                   
                                   genButtons= "nextBtn"))),
  
  # lapply(1:length(get_tomerge_files()), function(i)
  #   tags$head(HTML(get_otherbuttons_style(otherButtons=paste0("màj_", i))))
  #   ),
  
  hidden(
    lapply(seq(NUM_PAGES), function(i) {
      div(
        class = "page",
        id = paste0("step", i),
        HTML(paste0('<h1 style="color:#0f0d64;font-size:200%;" align="center"><u>Etape ', i, '</u></h2>'))
      )
    })
  ),
  br(),
  
  
  # Loading message
  div(
    id = "loading-content",
    h2("Chargement en cours...")
  ),
  
  
  # The main app code goes here
  hidden(
    div(
      id = "app-content",
      
  
  
  # dummy input utiliser pour avoir une variable qui sert à switcher entre les onglets
  fluidRow(align = 'center',
           column(1.5, numericInput(inputId='num',label= "", value=1))

  ),
  
  ### définir le nombre de fichiers à fusionner
  conditionalPanel( 
    condition = "input.num == 1",
    fluidRow(align = 'center',
             uiOutput('def_files_UI'),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$div("Patience svp - chargement en cours...",id="running_message"))
             
             )
  ),
  
  ### charger les fichiers à fusionner, afficher et chgmt nom colonnes
  conditionalPanel( ## Mqmts réseau
    condition = "input.num == 2",
    fluidRow(align = 'center',
             uiOutput('load_data_UI'),
             
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$div("Patience svp - chargement en cours...",id="running_message"))
             
             )
    ),
  
  ### charger les fichiers à fusionner, afficher et chgmt nom colonnes
  conditionalPanel( 
    condition = "input.num == 3",
    fluidRow(align = 'center',
             uiOutput('merged_data_UI'),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$div("Patience svp - chargement en cours...",id="running_message"))
    )
  ),
  
  uiOutput("curr_num"),
  
  actionButton("prevBtn", "< Previous"),
  actionButton("nextBtn", "Next >")
    ) #end-div
  ) # end-hidden
)

