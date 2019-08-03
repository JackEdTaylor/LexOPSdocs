# based on psyteachr code

library(tidyverse)
library(webex)

# default knitr options
knitr::opts_chunk$set(
  echo       = TRUE,
  results    = "hold",
  out.width = '100%',
  fig.width  = 8, 
  fig.height = 5, 
  fig.align = 'center',
  fig.cap='**CAPTION THIS FIGURE!!**'
)

# make docs directory and include .nojekyll file for github
if (!dir.exists('docs')) dir.create('docs')
file.create('docs/.nojekyll')

## set global theme options for figures
theme_set(theme_minimal())

## set class for a chunk using class="className"
knitr::knit_hooks$set(class = function(before, options, envir) {
  if (before) {
    sprintf("<div class = '%s'>", options$class)
  } else {
    "</div>"
  }
})

## verbatim code chunks
knitr::knit_hooks$set(verbatim = function(before, options, envir) {
  if (before) {
    sprintf("<div class='verbatim'><code>&#96;&#96;&#96;{%s}</code>", options$verbatim)
  } else {
    "<code>&#96;&#96;&#96;</code></div>"
  }
})

## verbatim inline R in backticks
backtick <- function(code) {
  paste0("<code>&#096;", code, "&#096;</code>")
}
