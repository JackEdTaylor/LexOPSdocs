
# Advanced Stimulus Generation



There are some cases when the default behaviour of the `split_by()`, `control_for()`, and `generate()` functions won't quite do what you want. This section presents some extra functions and functionality for generating your stimuli.

## Non-Stimulus Splits

Sometimes it makes sense to use independent variables that are not related to features of the word stimuli you present. For example, you may be interested in a possible difference between tasks (such as comparing Word Naming to Lexical Decision). In this case, it makes sense to use a within-subject design, but to present different stimuli in each task. These different stimuli should still be matched across tasks. This is possible with the `split_random()` function.

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

 item_nr  A1_B1        A1_B2        A2_B1        A2_B2        match_null 
--------  -----------  -----------  -----------  -----------  -----------
       1  backwoods    goddamned    potpourri    sociopath    A1_B1      
       2  bulletin     caffeine     needless     weaponry     A1_B1      
       3  provincial   rebellious   typewriter   horrifying   A1_B1      
       4  hallway      furious      carrier      volcano      A2_B2      
       5  governess    nightlife    celluloid    seduction    A1_B2      

</div>

These stimuli could then be used in combination with a counter-balanced design, alternating which level of B has its stimuli presented before the coffee, and which after. Note that the `split_random()` function will also need its own [random seed](#random-seeds) (`seed = ...`) to replicate a specific stimulus list.

## Map Functions as Controls

Imagine you want to generate a list of stimuli, controlling for a value of similarity to the match null. This would be very difficult using the `control_for()` function. The problem is that the similarity value would need to be calculated relative to the word currently being used as a match null. The `control_for_map()` function tells LexOPS to calculate a value to use as a control on each iteration of the `generate()` function.

### Orthographic Similarity

Here is an example, using `control_for_map()` to match by orthographic Levenshtein distance from the match null (calculated using the `vwr` package). This means that each string will be a distance of between 0 and 3 character insertions, deletions or replacements from the word used as the match null.


```r
library(vwr)

stim <- lexops %>%
  split_by(VAL.Warriner, 1:3 ~ 4.5:5.5 ~ 7:9) %>%
  control_for_map(levenshtein.distance, string, 0:3, name="Orth_Dist") %>%
  generate(20)
```

Here are the first 5 items of each condition that we generated:

\small
<div class = 'table'>

 item_nr  A1         A2         A3       match_null 
--------  ---------  ---------  -------  -----------
       1  grave      rank       great    A1         
       2  drown      urban      dream    A2         
       3  stink      sticky     song     A1         
       4  racist     pane       praise   A3         
       5  catheter   canister   cheer    A1         

</div>
\normalsize

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

Here are the first 5 items of each condition that we generated:

\small
<div class = 'table'>

 item_nr  A1          A2          A3           match_null 
--------  ----------  ----------  -----------  -----------
       1  mugger      liquor      lover        A3         
       2  frightful   fistful     fruitful     A2         
       3  smother     slugger     mother       A1         
       4  killer      molar       healer       A2         
       5  irritable   veritable   charitable   A3         

</div>
\normalsize

### Other Uses

I originally wrote this function so I could match by similarity measures, but it can be used to control for any variable that needs to be calculated relative to the match null. The `fun` argument of `control_for_map()` should be a function that takes the data in the column contained in `var` as its first argument, and can take the match null's value for `var` as the second argument, to return a vector of values for each entry. In addition, `tol` can be specified as it is in `control_for()`, as either a numeric tolerance, or categorical tolerance if the function outputs character vectors. The `name` argument should just be a character vector to name the column in the long format of the generated stimuli.

See the package documentation (`?control_for_map`) for more details. If you're wanting to write a function to use in `control_for_map()`, it may be a good idea to look at [how the vwr functions work](https://cran.r-project.org/web/packages/vwr/vwr.pdf) for comparison, as it was written with these in mind.

## Random Seeds

By default, the generate pipeline will produce novel stimulus lists each time it is run. Often you'll want your code to be reproducible, however. To do this, we can use a random seed.

Random seeds allow for replicable results from functions that produce different results each time they are run. In R, this is usually done with the `set.seed()` function. The `set.seed()` function can be used with LexOPS to write reproducible pipelines, **but** will yield different results between LexOPS R code and the [LexOPS shiny app](lexops-shiny-app.html). To ensure that pipelines created with R code can be reproduced in the shiny app (and [vice versa](lexops-shiny-app.html#random-seeds)) it is recommended to use the `seed` argument of the `generate()` function.

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