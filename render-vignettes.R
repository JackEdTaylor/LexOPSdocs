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

links <- lapply(v_files, function(v) {
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
  
  scrape <- read_html(v_html)
  
  v_title <- scrape %>%
    html_nodes("h1") %>%
    dplyr::first() %>%
    html_text()
  
  v_intro <- scrape %>%
    html_nodes("p") %>%
    dplyr::first() %>%
    html_text()
  
  sprintf("<a style=\"text-decoration:none;color:black;\" href=\"%s\"><div class=\"code-link\"><b>%s: </b>%s</div></a>", v_html, v_title, v_intro)
})

# save the resulting html to vignettes-boxes.rds
links %>%
  unlist() %>%
  paste(collapse="\n</br>") %>%
  htmltools::HTML() %>%
  saveRDS("vignettes-boxes.rds")