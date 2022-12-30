get_buttons_style <- function(dwdButtons, genButtons) {
  return(
    paste0(# => to place the notification in the middle of the page
      # tags$head(
      # HTML(
      tags$style(
        HTML(
          ".tabbable > .nav > li > a                  { color:#4974a5}
        .tabbable > .nav > li[class=active]    > a {color:#335173  ; text-decoration: underline}",
          ".shiny-notification {
             position:fixed;
             top: calc(50%);
             left: calc(50%);
             }
        a:link {color: #e32c27}
        a:visited {color: #a81a16}
        a:hover {color: #a81a16}
}"
          
          
        )
      ),
      #       font-family: Courier New;
      #border-color: #ddd;
      tags$style(type="text/css",
                 paste0(paste0(paste0("#", dwdButtons), collapse=","), "
                 {
      background-color: rgb(145, 25, 9);
      color: white;
      -webkit-box-shadow: 0px;
      box-shadow: 0px;
           border:0px;
    }
   ")),
      tags$style(type="text/css",
                 paste0(
                   paste0(paste0(paste0("#", dwdButtons, ":hover"), collapse=","), ",", 
                          paste0(paste0("#", dwdButtons, ":active"), collapse=",")),
                   "{
      background-color:rgb(255, 25, 2);
      color: white;
      -webkit-box-shadow: 0px;
      box-shadow: 0px;
      border:0px;
    }
   ")),
      
      tags$style(type="text/css",
                 HTML(paste0(paste0(paste0("#", genButtons), collapse=","),"
               {
      background-color:rgb(2, 87, 35);
      color: white;
      -webkit-box-shadow: 0px;
      box-shadow: 0px;
           border:0px;
    }
   "))),
      tags$style(type="text/css",
                 HTML(paste0(paste0(paste0(paste0("#", genButtons, ":hover"), collapse=","), ",", 
                                    paste0(paste0("#", genButtons, ":active"), collapse=",")),
                             "{
      background-color:rgb(19, 165, 35);
      color: white;
      -webkit-box-shadow: 0px;
      box-shadow: 0px;
           border:0px;
    }
   ")))
      
    )
    
    
    # )
    # )
  )
}
