# Advanced Matching



There are some cases when the default behaviour of the `split_by()`, `control_for()`, and `generate()` functions won't quite do what you want. This section presents some extra functions and functionality for generating your matches.

## Non-Stimulus Splits

Sometimes it makes sense to use independent variables that are not related to features of the stimuli you present. For example, you may be interested in a possible difference between contexts or tasks (such as comparing Word Naming to Lexical Decision). In this case, it makes sense to use a within-subject design, but to present different stimuli in each context. These different stimuli should still be matched across contexts. This is possible with the `split_random()` function.

As an example, imagine we're interested in a 2x2 interaction between the effect of words' arousal ratings before and after a cup of coffee. We use `split_random()` to say that we want to create a random split in the data with two levels. Such a pipeline might look like this:


```r
stim <- lexops %>%
  split_random(2) %>%
  split_by(AROU.Warriner, 1:3 ~ 6:8) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.1:0.1) %>%
  generate(50)
```

This will create 4 conditions matched for length and frequency, where A1_B1 and A2_B1 are low arousal words, and A1_B2 and A2_B2 are high arousal words. Here are the first 5 items of each condition:

<div class = 'table'>

| item_nr|A1_B1       |A1_B2       |A2_B1       |A2_B2       |match_null |
|-------:|:-----------|:-----------|:-----------|:-----------|:----------|
|       1|panel       |snake       |bunch       |glory       |A1_B1      |
|       2|cobbler     |screech     |padding     |deathly     |A2_B2      |
|       3|monogrammed |promiscuity |linguistics |exhilarated |A1_B2      |
|       4|hourly      |unjust      |dismay      |payday      |A1_B1      |
|       5|rectangular |heartbroken |therapeutic |stimulating |A2_B2      |

</div>

These stimuli could then be used in combination with a counter-balanced design, alternating which level of B has its stimuli presented before the coffee, and which after. Note that the `split_random()` function will also need its own [random seed](#random-seeds) (`seed = ...`) to replicate a specific stimulus list.

## Random Seeds

By default, the generate pipeline will produce novel stimulus lists each time it is run. Often you'll want your code to be reproducible, however. To do this, we can use a random seed.

Random seeds allow for replicable results from functions that produce different results each time they are run. In R, this is usually done with the `set.seed()` function. The `set.seed()` function can be used with LexOPS to write reproducible pipelines, **but** will yield different results between LexOPS R code and the [LexOPS shiny app](lexops-shiny-app.html), and might produce different results between versions. To ensure that pipelines created with R code can be reproduced in the shiny app (and [vice versa](lexops-shiny-app.html#random-seeds)), and across different versions, it is recommended to use the `seed` argument of the `generate()` function.

### Setting the seed in the `generate()` function {-}

The following code will generate the same stimulus list each time it is run:


```r
stim <- lexops %>%
  subset(PK.Brysbaert >= 0.9) %>%
  split_by(CNC.Brysbaert, 1:2 ~ 4:5) %>%
  split_by(BG.SUBTLEX_UK, 0:0.003 ~ 0.009:0.013) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.2:0.2) %>%
  generate(25, seed = 42)
```

### Setting the seed in the `split_random()` function {-}

If you use the `split_random()` function, this will also require a `seed` argument in order for the pipeline to be reproducible. This does not necessarily need to be the same as the `seed` value passed to `generate()`, but the shiny app will assume this is the case when [translating Shiny options into R code](lexops-shiny-app.html#codify). The following is an example of a reproducible pipeline that uses the `split_random()` function:


```r
my_seed <- 42

stim <- lexops %>%
  split_random(2, seed = my_seed) %>%
  split_by(AROU.Warriner, 1:3 ~ 6:8) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.1:0.1) %>%
  generate(50, seed = my_seed)
```

## Map Functions as Controls

Imagine you want to generate a list of stimuli, controlling for a value of similarity to the match null. This would be very difficult using the `control_for()` function. The problem is that the similarity values would need to be calculated *n* times, relative each word currently being used as a match null. The `control_for_map()` function tells LexOPS to recalculate the value to use as a control on each iteration of the `generate()` function, relative to a value associated with the string currently selected as a match null.

Example applications for this include controlling for orthographic or phonological similarity.

### Orthographic Similarity

Here is an example, using `control_for_map()` to control for orthographic Levenshtein distance from the match null (calculated using the `vwr` package). This means that each string will be a distance of between 0 and 3 character insertions, deletions or replacements from the word used as the match null.


```r
library(vwr)

stim <- lexops %>%
  split_by(VAL.Warriner, 1:3 ~ 4.5:5.5 ~ 7:9) %>%
  control_for_map(levenshtein.distance, string, 0:3, name="Orth_Dist") %>%
  generate(20)
```

Here are the first 5 items of each condition that we generated. Note that we have 3 levels of valence, with matched items that are orthographically similar to one another:

\small
<div class = 'table'>

| item_nr|A1      |A2    |A3     |match_null |
|-------:|:-------|:-----|:------|:----------|
|       1|hearse  |snare |praise |A1         |
|       2|fist    |faze  |food   |A3         |
|       3|enslave |suave |save   |A1         |
|       4|whine   |orgy  |honey  |A3         |
|       5|slave   |heavy |play   |A2         |

</div>
\normalsize

<br>
<div class="info">
<p>The name argument (<code>name = ...</code>) of the <code>control_for_map()</code> function will simply specify the name of the column that the calculated values should be stored as when the stimuli are in long format (from the code above, <code>long_format(stim)</code> will contain a column called “Orth_Dist”, containing the orthographic distances from the match null).</p>
</div>
<br>

### Phonological Similarity

We can use a similar pipeline to match by phonological similarity. Instead of giving the string column to the function, we just have to give a column where phonemes are represented by single letters. All the generated stimuli will be within a distance of between 0 and 2 phonemic insertions, deletions, or substitutions from the word used as the match null. For fun (and to show how `control_for_map()` can be combined with `control_for()`), let's also control for rhyme.


```r
library(vwr)

stim <- lexops %>%
  split_by(VAL.Warriner, 1:3 ~ 4.5:5.5 ~ 7:9) %>%
  control_for_map(levenshtein.distance, eSpeak.br_1letter, 0:2, name="Phon_Dist") %>%
  control_for(Rhyme.eSpeak.br) %>%
  generate(20)
```

Here are the first 5 items of each condition that we generated. This time, all matched items are phonologically similar to one another:

\small
<div class = 'table'>

| item_nr|A1       |A2     |A3     |match_null |
|-------:|:--------|:------|:------|:----------|
|       1|bury     |heavy  |merry  |A2         |
|       2|jealousy |lunacy |legacy |A3         |
|       3|lonely   |wily   |lily   |A3         |
|       4|killer   |pillar |giver  |A1         |
|       5|saggy    |cabbie |daddy  |A1         |

</div>
\normalsize

### Other Uses

The `control_for_map()` function can be used to control for any variable that needs to be calculated relative to the match null. The `fun` argument of `control_for_map()` should be a function that takes the data in the column contained in `var` as its first argument, and can take the match null's value for `var` as the second argument, to return a vector of values for each entry. In addition, `tol` can be specified as it is in `control_for()`, as either a numeric tolerance, or categorical tolerance if the function outputs character vectors. The `name` argument should just be a character vector to name the column in the long format of the generated stimuli.

If you're wanting to use `control_for_map()` on your own function or data, see this [vignette on controlling for semantic relatedness](vignettes/control_for_map.html). The function's documentation in the package ([`?control_for_map`](https://rdrr.io/github/JackEdTaylor/LexOPS/man/control_for_map.html)) might also be useful. Additionally, you may want to look at [how the vwr functions work](https://cran.r-project.org/web/packages/vwr/vwr.pdf) for comparison, as `control_for_map()` was originally written with these in mind.

## Controlling for Euclidean Distance

The `control_for()` function lets you give specific tolerances for individual variables. Another method of matching items, however, may be to control for Euclidean distance, weighting variables by their relative importance. The `control_for_euc()` function lets you do exactly this. As an example, imagine we want to split by concretness, and control for length, frequency, and age of acquisition. We might decide that length is the most important thing to match (ideally exact matching), followed by frequency and age of acquisition. This could be achieved like so:


```r
stim <- lexops %>%
    split_by(CNC.Brysbaert, 1:2 ~ 4:5) %>%
    control_for_euc(
        c(Length, Zipf.BNC.Written, AoA.Kuperman),
        0:1e-5,
        name = "euclidean_distance",
        weights = c(1, 0.5, 0.05)
    ) %>%
    generate(20)
```

This method will generally be slower than standard LexOPS pipelines, but more flexible. You can also combine `control_for_euc()` and `control_for()` functions in your pipelines. For more information on controlling for Euclidean distance, and how to decide on tolerances, try the [vignette on Euclidean distance](https://jackedtaylor.github.io/LexOPSdocs/vignettes/euclidean-distance.html).
