
# Introduction

## What is LexOPS?

LexOPS is an R package and shiny app for generating word stimuli that can be used in Psychology experiments. The package is designed to be as intuitive as possible, and is similar in style to the [tidyverse](https://www.tidyverse.org/). The shiny app is designed to be especially intuitive, and requires minimal knowledge of R to use.

Here are 3 main advantages of using LexOPS to generate your word stimuli:

1. **Speed**: It's just much (much much) faster than creating well-controlled stimuli manually.

2. **Reproducibility**: if a random seed is set, LexOPS pipelines will generate the same stimuli each time the code is run. This means you can openly share the code that generated your stimuli, and anyone can reproduce your result.

3. **Replicability**: if no random seed is set, LexOPS pipelines will generate different stimuli each time the code is run. This means if you share your code, anyone can generate a novel set of stimuli for the same experimental design, that can be used to try and replicate any experimental result.

The package began as a series of R scripts, written to automate tasks I found myself repeating again and again when designing experiments. I decided to make it into a fully-fledged package because despite the huge range of freely available lists of word norms and features, there were no task-general solutions for using such lists to generate word stimuli.

## Installation

The latest version of LexOPS can be installed with the following R code:


```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("JackEdTaylor/LexOPS")
```

Install R here: [https://cloud.r-project.org/](https://cloud.r-project.org/)

Install RStudio (reccommended IDE) here: [https://www.rstudio.com/products/rstudio/](https://www.rstudio.com/products/rstudio/)

## The Shiny App

LexOPS features an intuitive shiny app (for more on shiny apps, see [https://shiny.rstudio.com/](https://shiny.rstudio.com/)). This features useful visualisations of data, and may be more friendly to users less familiar with R.

Once LexOPS is installed, the shiny app can be run with:


```r
LexOPS::run_shiny()
```

<div class="figure" style="text-align: center">
<img src="./images/shiny-preview.png" alt="The Generate tab of the LexOPS Shiny App" width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-4)The Generate tab of the LexOPS Shiny App</p>
</div>

<div class="info">
<p>The shiny app is also available as a web app online, at <a href="https://jackt.shinyapps.io/lexops/">https://jackt.shinyapps.io/lexops/</a>, but it is usually more reliable to run it locally with the <code>run_shiny()</code> function.</p>
</div>

## The LexOPS Dataset

LexOPS has a built-in dataset of English word features, which can be called with:


```r
LexOPS::lexops
```

For details on the variables included, see [https://rdrr.io/github/JackEdTaylor/LexOPS/man/lexops.html](https://rdrr.io/github/JackEdTaylor/LexOPS/man/lexops.html).