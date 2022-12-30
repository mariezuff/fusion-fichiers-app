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
  
  
  
  hidden(
    lapply(seq(NUM_PAGES), function(i) {
      div(
        class = "page",
        id = paste0("step", i),
        HTML(paste0('<h1 style="color:#a81a16;font-size:200%;" align="center"><u>Etape ', i, '</u></h2>'))
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




# 
# shinyUI(
#   list( fluidPage(
#     # cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex,
#     # slate, spacelab, superhero, united, yeti.    
#     theme = shinythemes::shinytheme('yeti'),
#     
#     
#     tags$head(HTML(get_buttons_style(dwdButtons=c(autre_dwd_buttons, paste0(rep(dwd_buttons, length(all_ctrls)), 
#                                                                             rep(all_ctrls, each=length(dwd_buttons)))),
#                                      genButtons= c(autre_gen_buttons, paste0(rep(gen_buttons, length(all_ctrls)), 
#                                                                              rep(all_ctrls, each=length(gen_buttons))))
#     ))),
#     
#     
#     
#     # tags$head(list(
#     #   includeScript("www/google-analytics.js"),
#     #   tags$meta(name="viewport", content="width=device-width, initial-scale=1.0, minimum-scale=1, maximum-scale=1, user-scalable=no"),
#     #   tags$meta(name="apple-mobile-web-app-title", content="SampleSizeR"),
#     #   tags$meta(name="apple-mobile-web-app-capable", content="yes"),
#     #   tags$meta(name="apple-mobile-web-app-status-bar-style", content="white"),
#     #   tags$style(HTML("#num{display: none;}")),
#     #   tags$style(HTML("#numberofFactors{display: none;}")),
#     #   tags$style(HTML("#keepAlive{display: none;}")),
#     #   tags$link(rel = "stylesheet", type = "text/css", href = "scientifica19style.css"),
#     #   tags$link(rel = "shortcut icon", href = "uzh.ico"),
#     #   tags$head(
#     #     HTML("<script>
#     #        var socket_timeout_interval
#     #        var n = 0
#     #        $(document).on('shiny:connected', function(event) { socket_timeout_interval = setInterval(function(){ Shiny.onInputChange('count', n++)}, 15000) });
#     #        $(document).on('shiny:disconnected', function(event) { clearInterval(socket_timeout_interval) });
#     #        </script>"))
#     # )),
#     shinyjs::useShinyjs(),
#     conditionalPanel(
#       condition = 'input.num < 1',
#       tags$header(
#         # img(src="uzh_logo.jpg", align = "left", style="float"),
#         tags$h1(align = 'center', "Calcul de réductions SBER"),
#         tags$br(),
#         tags$br(),
#         tags$br())
#     ),
#     
#     mainPanel(
#       
#       # master App header
#       fluidRow(
#         column(12, conditionalPanel(
#           condition = 'input.num < 1',
#           tags$br(),
#           tags$h2("Choisir selon le type de contrôles", 
#                   align = 'center',
#                   style="color:silver")),
#           tags$hr()
#         )),
#       
#       
#       # fluidRow(
#       #   column(12, conditionalPanel(
#       #     condition = 'input.num < 1',
#       #     tags$h3("According to your outcome variable, choose one of the tiles", 
#       #             align = 'left',
#       #             style="color:silver")))),
#       
#       # back to start button
#       fluidRow(align = 'right',
#                column(12, 
#                       conditionalPanel(
#                         condition = 'input.num > 0',
#                         # tags$header(img(src="uzh_logo.jpg", align = "left", style="float")),
#                         actionButton('btnStart', "Retour à la page d'accueil", width = '200px', 
#                                      icon = icon('home'))))),
#       
#       # action buttons which disapear after clicking
#       fluidRow(align = 'center',
#                
#                
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn1', "ContQII_PraiPat_ManquementsQI", width = '100%',
#                               icon = icon('grain', lib = "glyphicon"))
#                  # tags$p("some text")
#                )),
#                
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn2', "ContQII_PraiPat_ManquementsQII", width = '100%',
#                               icon = icon('grain', lib = "glyphicon" ))
#                  # tags$p("some text")
#                ))),
#       
#       fluidRow(align = 'center',
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn3', "ContQII_Haies_ManquementsQI",
#                               # style='padding:10px',
#                               width = '100%', icon = icon('tree'))
#                  # tags$p("some text")
#                )),
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn4', "ContReseau_Reseau_ManquementsQI", width = '100%', 
#                               icon = icon('bug', lib = "font-awesome"))
#                  # tags$p("some text")
#                )) ),
#       
#       
#       fluidRow(align = 'center',
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn5', "PrepCampagne_Multicontroles",
#                               # style='padding:10px',
#                               width = '100%', icon = icon('tree'))
#                  # tags$p("some text")
#                )),
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn6', "GenerateXML_Multicontroles", width = '100%', 
#                               icon = icon('bug', lib = "font-awesome"))
#                  # tags$p("some text")
#                )) ),
#       
#       fluidRow(align = 'center',
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn7', "Aide", width = '100%', icon = icon('hand-up', lib="glyphicon"))
#                  # tags$p("...")
#                )),
#                column(6, conditionalPanel(
#                  condition = 'input.num < 1',
#                  actionButton('btn8', "Contact", width = '100%', 
#                               icon = icon('edit', lib="glyphicon"))
#                  # tags$p("some text")
#                ))),
#       tags$style("#btn1 { margin-bottom: 10px; background: #07E121; border-color: grey;}"),
#       tags$style("#btn2 { margin-bottom: 10px; background: #47E15A; border-color: grey;}"),
#       tags$style("#btn3 { margin-bottom: 10px; background: #119621; border-color: grey;}"),
#       tags$style("#btn4 { margin-bottom: 10px; background: #F1948A; border-color: grey;}"),
#       tags$style("#btn5 { margin-bottom: 10px; background: #F1A712; border-color: grey;}"),
#       tags$style("#btn6 { margin-bottom: 10px; background: #F1DD12; border-color: grey;}"),
#       tags$style("#btn7 { margin-bottom: 10px; background: #85C1E9; border-color: grey; }"),
#       tags$style("#btn8 { margin-bottom: 10px; background: #85C1E9; border-color: grey; }"),
#       
#       # dummy input which is not displayed, but used to distinguish between panels
#       fluidRow(align = 'center',
#                column(10.5, htmlOutput("tabName")),
#                column(1.5, numericInput('num', "", 0))
#                
#       ),
#       
#       # # specific outputs
#       
#       conditionalPanel( ## Mqmts prai+pât QII
#         condition = "input.num == 1",
#         fluidRow(align = 'center',
#                  # h2("Title"),
#                  uiOutput('ContQII_PraiPat_ManquementsQI_UI'))),
#       
#       conditionalPanel( ## Mqmts prai+pât QI
#         condition = "input.num == 2",
#         fluidRow(align = 'center',
#                  uiOutput('ContQII_PraiPat_ManquementsQII_UI'))),
#       
#       conditionalPanel( ## Mqmts haies
#         condition = "input.num == 3",
#         fluidRow(align = 'center',
#                  uiOutput('ContQII_Haies_ManquementsQI_UI'))),
#       
#       conditionalPanel( ## Mqmts réseau
#         condition = "input.num == 4",
#         fluidRow(align = 'center',
#                  uiOutput('ContReseau_Reseau_ManquementsQI_UI'))),
#       
#       conditionalPanel( ## Mqmts réseau
#         condition = "input.num == 5",
#         fluidRow(align = 'center',
#                  uiOutput('PrepCampagne_Multicontroles_UI'))),
#       
#       
#       conditionalPanel( ## Mqmts réseau
#         condition = "input.num == 6",
#         fluidRow(align = 'center',
#                  uiOutput('GenerateXML_Multicontroles_UI'))),
#       
#       
#       conditionalPanel( ## Aide
#         condition = "input.num == 7",
#         fluidRow(align = 'center',
#                  htmlOutput("help"))),
#       
#       conditionalPanel( ## Contact
#         condition = "input.num == 8",
#         fluidRow(align = 'center',
#                  htmlOutput("contact"))),
#       
#       
#       # master App footer
#       fluidRow(column(12,
#                       tags$hr(),
#                       tags$style(type='text/css',"#btnStart { margin-top: 30px; }")
#       )),
#       textOutput("keepAlive"),
#       width = 12) # width of mainpanel
#   ))
# )
