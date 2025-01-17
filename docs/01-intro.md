# Introduction

## What is LexOPS?

LexOPS is an R package and shiny app for generating matched stimuli that can be used in Psychology experiments. The package is designed to be similar in style to the [tidyverse](https://www.tidyverse.org/).

I originally wrote the package for selecting word stimuli, but it can be used to get matched items from any database of features.

Here are 3 main advantages of using LexOPS to generate your stimuli:

1. **Speed**: It's just faster than creating well-controlled stimuli manually.

2. **Reproducibility**: if a random seed is set, LexOPS pipelines will generate the same stimuli each time the code is run. This means you can share the code that generated your stimuli, and anyone can reproduce your result.

3. **Replicability**: if no random seed is set, LexOPS pipelines will generate different stimuli each time the code is run. This means if you share your code, anyone can generate a novel set of stimuli for the same experimental design. This can be useful for replication.

## Installation

### Installing R {-}

You can find the latest version of R here: [https://cloud.r-project.org/](https://cloud.r-project.org/). You might also want to install an IDE like the popular [RStudio](https://www.rstudio.com/products/rstudio/).

### Installing LexOPS {-}

The latest version of LexOPS can be installed as an R package with the following:


``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("JackEdTaylor/LexOPS@*release")
```

## The Shiny App

LexOPS features a graphical user interface in the form of a shiny app (for more on shiny apps, see [https://shiny.rstudio.com/](https://shiny.rstudio.com/)). This features useful visualisations of data and selected options, and may be more friendly to users less familiar with R.

Once LexOPS is installed, the shiny app can be run with:


``` r
LexOPS::run_shiny()
```

<div class="figure" style="text-align: center">
<img src="./images/shiny-preview.png" alt="The Generate tab of the LexOPS Shiny App" width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-3)The Generate tab of the LexOPS Shiny App</p>
</div>

<div class="info">
<p>A demo version of the shiny app with limited usage is also available
as a web app online, at <a
href="https://jackt.shinyapps.io/lexops/">https://jackt.shinyapps.io/lexops/</a>,
but it is much faster and more reliable to run it locally with the
<code>run_shiny()</code> function.</p>
</div>

## The LexOPS Dataset

LexOPS works can work with any list of features. Even so, LexOPS has inbuilt dataset with some features for English words that I've found useful in the past. This can be called with:


``` r
LexOPS::lexops
```

For details on the variables included, see [https://rdrr.io/github/JackEdTaylor/LexOPS/man/lexops.html](https://rdrr.io/github/JackEdTaylor/LexOPS/man/lexops.html).

Note that in addition to citing LexOPS, you should cite the sources for any materials you use.

## Using other Datasets

LexOPS functions will work on any dataframe. The following sections might be useful if you're using LexOPS on your own datasets:

* [Custom Dataframes](the-generate-pipeline.html#custom-dataframes): A section of the walkthrough showing how to use LexOPS on your own dataset.
* [Applications to Participant Selection](vignettes/participant-selection.html): A vignette showing how you can use a dataset which has nothing to do with words.
* [Using Data from Custom Sources](vignettes/custom-data.html): A vignette showing how you can join the LexOPS dataset to other lists of word features.
