# Get a list of all vignettes, download them, and render them
library(httr)
library(stringr)
library(rvest)
library(tidyverse)

# delete all .Rmd files from vignettes folder
list.files("vignettes", "^.+(\\.Rmd|\\.html|_files)$", full.names=TRUE, recursive=TRUE, include.dirs=TRUE) %>%
  file.remove()

# check docs/vignettes exists
if (!dir.exists(file.path("docs", "vignettes"))) dir.create(file.path("docs", "vignettes"))

vignette_repo <- GET("https://api.github.com/repos/JackEdTaylor/LexOPS/git/trees/master?recursive=1")

stop_for_status(vignette_repo)

v_files <- unlist(lapply(content(vignette_repo)$tree, "[", "path"), use.names=F) %>%
  grep("vignettes/.+\\.Rmd", ., value=TRUE) %>%
  basename()

# links will contain all the info rendered in the Vignettes boxes
links <- lapply(1:length(v_files), function(v_nr) {
  
  v <- v_files[[v_nr]]
  v_path <- file.path("vignettes", v)
  
  # download
  download.file(
    sprintf("https://raw.githubusercontent.com/JackEdTaylor/LexOPS/master/vignettes/%s", v),
    v_path
  )
  
  # render the html
  html_out <- rmarkdown::render(v_path)
  
  # copy to docs directory
  v_html <- sprintf("%s.html", tools::file_path_sans_ext(v_path))
  file.copy(v_html, file.path("docs", v_html), overwrite = TRUE)
  
  # scrape the rendered .html for the Vignettes page boxes' info
  scrape <- read_html(v_html)
  
  v_title <- scrape %>%
    html_nodes("h1") %>%
    .[[1]] %>%
    html_text()
  
  v_intro <- scrape %>%
    html_nodes("p") %>%
    .[[1]] %>%
    html_text()
  
  # return the html for the link to this vignette
  sprintf("<a style=\"text-decoration:none;color:black;\" href=\"%s\"><div class=\"code-link\"><b>%s) %s: </b>%s</div></a>", v_html, v_nr, v_title, v_intro)
})

# save the resulting html to vignettes-boxes.rds, which is then rendered by 98-vignettes.Rmd
links %>%
  unlist() %>%
  paste(collapse="\n</br>") %>%
  htmltools::HTML() %>%
  saveRDS("vignettes-boxes.rds")
