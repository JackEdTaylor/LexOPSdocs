# LexOPS Shiny App

The Shiny app is an interactive interface for LexOPS. The LexOPS Shiny app can be run locally with:


``` r
LexOPS::run_shiny()
```

A demo of the Shiny app is available at https://jackt.shinyapps.io/lexops/, but running the app locally is recommended for reliability and speed.

## Generate

The Generate tab is an interface for the "[generate pipeline](the-generate-pipeline.html)". This allows you to generate stimuli for any possible factorial design.

### Specify Design

Splits (independent variables), controls, and filters can be specified in the following way:

1. Click the '+' button to add a new variable.
2. Choose a variable from the drop-down menu.
3. Select a source for the variable if necessary (i.e. "according to...").
4. Specify the boundaries or tolerances

<div class="figure" style="text-align: center">
<img src="./images/shiny/generate-specify-design.gif" alt="Specifying a design in the shiny app." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-2)Specifying a design in the shiny app.</p>
</div>

### Options

Here you can tell the app how many stimuli should be generated per condition, which condition should be used as the match null, and which variables to include in the long-format version of the results.

<div class="figure" style="text-align: center">
<img src="./images/shiny/generate-options.png" alt="Options for the Generate tab." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-3)Options for the Generate tab.</p>
</div>

### Results

This is where you can see the generated stimuli. A different set of stimuli which fit the design will be generated each time the "Regenerate" button is clicked. You can switch between viewing the stimuli in wide or long format, and can download the stimuli in either format as a file: `generated_stimuli.csv`.

<div class="figure" style="text-align: center">
<img src="./images/shiny/generate-results.gif" alt="Generating stimuli and viewing the results." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-4)Generating stimuli and viewing the results.</p>
</div>

### Review

This section gives you a summary of the generated stimuli. You can view how splits, controls, and filters differ between conditions and across matched items (which calls the `plot_design()` function). You can also view the cumulative item generation (from the `plot_iterations()` function), and check the distribution of the match nulls.

<div class="figure" style="text-align: center">
<img src="./images/shiny/generate-review.gif" alt="Reviewing generated stimuli." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-5)Reviewing generated stimuli.</p>
</div>

### Codify

This is a handy feature that lets you translate the selected options into LexOPS R code to reproduce the design. To reproduce a specific stimulus list, [set the seed](#random-seeds) in the Preferences tab.

<div class="figure" style="text-align: center">
<img src="./images/shiny/generate-codify.png" alt="Translate selected options into LexOPS R code." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-6)Translate selected options into LexOPS R code.</p>
</div>

## Match Item

The Match Item tab is a user interface for the [`match_item()` function](matching-individual-words.html). As in the Generate tab, you can specify variables that should be matched by (with tolerances relative to the target string) and filtered by (with boundaries independent of the target string). You can then view and download the suggested matches.

<div class="figure" style="text-align: center">
<img src="./images/shiny/match.gif" alt="Matching individual words in the Match tab." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-7)Matching individual words in the Match tab.</p>
</div>

## Fetch

The Fetch tab can be helpful for getting items from the LexOPS database (or uploaded in the [Custom Variables](#custom-variables) tab) for your own list of words. As an example, I may have a file, `my_stimuli.csv`, containing the following:

<div class = 'skinny'>

|word      | likert_rating| mean_RT|
|:---------|-------------:|-------:|
|pigeon    |          1.40|   456.0|
|dog       |          5.20|   423.5|
|wren      |          6.00|   511.0|
|symbiosis |          4.44|   503.2|
|shark     |          4.20|   482.3|

</div>

I could upload this to the Fetch tab. This will return the known values from the [LexOPS dataset](introduction.html#the-lexops-dataset) for my list of stimuli:

<div class="figure" style="text-align: center">
<img src="./images/shiny/fetch.gif" alt="Fetching the features of a stimulus list." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-9)Fetching the features of a stimulus list.</p>
</div>

## Visualise

The Visualise tab provides options for plotting useful information. This includes variables from the [LexOPS dataset](introduction.html#the-lexops-dataset), [custom variables](#custom-variables), and assigned factorial cells.

Here's an example, showing stimuli generated in the Generate tab (in a Bigram Probability x Concreteness design). Points can be coloured (e.g., by generated condition) and individual items can be identified by hovering over the points.

<div class="figure" style="text-align: center">
<img src="./images/shiny/visualise.gif" alt="Example usage of the Visualise tab." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-10)Example usage of the Visualise tab.</p>
</div>

## Custom Variables

The Custom Variables tab is useful for adding your own variables to the app to generate stimuli. Custom variables are only available for the current session.

Here is an example in which the variables from the [Leipzig Affective Norms for German (LANG) (Kanske & Kotz, 2010)](http://doi.org/10.3758/BRM.42.4.987) are added to the LexOPS shiny app. These variables can then be used in the Generate tab.

<div class="figure" style="text-align: center">
<img src="./images/shiny/custom-variables.gif" alt="Using stimuli for languages other than English." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-11)Using stimuli for languages other than English.</p>
</div>

The Custom Variables tab uses [dplyr's join functions](https://dplyr.tidyverse.org/reference/join.html). An equivalent to using custom variables in R code would be to either join the custom variables to the LexOPS dataset using dplyr's join functions, or to just run the generate pipeline on a dataframe of custom variables (see [this section](the-generate-pipeline.html#custom-dataframes) for an example).

## Random Seeds

The seed can be set in the Preferences tab to reproduce specific lists of generated stimuli. This means that the exact same list of words will be generated each time you click "Regenerate".

<div class="figure" style="text-align: center">
<img src="./images/shiny/setting-seed.gif" alt="Setting the seed in the Shiny app." width="75%" height="75%" />
<p class="caption">(\#fig:unnamed-chunk-12)Setting the seed in the Shiny app.</p>
</div>

If you ["codify" your selected options](#codify), the generated code will also set the seed as the same value, so that a stimulus list can be reproduced outside of the shiny app.

<div class="danger">
<p>Note that in order to reproduce stimulus lists generated with R code
within the shiny app, the seed should be set using the <code>seed</code>
argument of the <code>generate()</code> and <code>split_random()</code>
functions. See <a href="advanced-stimulus-generation#random-seeds">this
section</a> on random seeds in the generate pipeline for some
examples.</p>
</div>
