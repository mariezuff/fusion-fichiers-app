
read_my_file <- function(myfile, ...) {
  if(grepl("\\.xls$", tolower(myfile)) | grepl("\\.xlsx", tolower(myfile))) {
    dt <- read_excel(myfile)
    dt <- data.frame(dt, stringsAsFactors = FALSE, check.names = FALSE)
  } else {
    dt <- read.delim(myfile, ...)
  }
  return(dt)
}


check_numcol <- function(x) {
  stopifnot(!is.na(as.numeric(as.character(x))))
}


renderDT_settings <- list(pageLength = 5,
                          scrollX='400px'
) #,scrollY='400px') pas mettre le scroll y vu que la page est limite à 5 entrées
