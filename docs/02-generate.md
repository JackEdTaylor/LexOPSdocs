
# The Generate Pipeline



## Generating Stimuli

One of the most noteworthy features of LexOPS is that it can generate controlled stimuli for any possible factorial design. This can be done in a pipeline using 3 main functions:

<br>
<div class="float-third-left">
<p><code>split_by()</code></p>
<p>to specify “splits” (independent variables) in the experimental design</p>
</div>

<div class="float-third-centre">
<p><code>control_for()</code></p>
<p>to specify variables that should be controlled for between conditions</p>
</div>

<div class="float-third-right">
<p><code>generate()</code></p>
<p>to run the algorithm and generate the stimuli, using specified splits and controls</p>
</div>
<br>

### A Practical Example {-}

Imagine we want to generate stimuli for a 2x2 factorial design in a Lexical Decision Task, examining whether a possible effect of bigram probability interacts with concreteness.

For this, we might decide we want a stimulus set with the following features:

* Filtered such that **at least 90% of people know each word**, according to Brysbaert, Mandera, and Keuleers (2018).

* **Two levels of Concreteness** (abstract and concrete words) according to Brysbaert, Warriner and Kuperman (2014).

* **Two levels of Bigram Probability** (high and low probability) based on SUBTLEX-UK (van Heuven, Mandera, Keuleers, & Brysbaert, 2014).
  
* **Controlled for word length** (number of characters) exactly.

* **Controlled for word frequency** within ±0.2 Zipf, according to according to SUBTLEX-UK (van Heuven, Mandera, Keuleers, & Brysbaert, 2014).

* **25 words for each of the generated conditions** (100 stimuli in total).

<br>
We can use the following R code to generate a stimulus list like this with LexOPS:


```r
library(LexOPS)

stim <- lexops %>%
  subset(PK.Brysbaert >= 0.9) %>%
  split_by(CNC.Brysbaert, 1:2 ~ 4:5) %>%
  split_by(BG.SUBTLEX_UK, 0:0.003 ~ 0.009:0.013) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.2:0.2) %>%
  generate(n = 25)
```

<br>
<div class="info">
<p>Important notes on LexOPS (non-standard) syntax:</p>
<ul>
<li><p>As in the tidyverse, variables in the dataframe can be referenced outside of quotation marks.</p></li>
<li><p>The <code>:</code> character is used in <code>split_by()</code> to specify numeric boundaries (e.g. <code>0.009:0.013</code> means any number from 0.009 to 0.013 is acceptable for this level of the variable), and in and <code>control_for()</code> to specify tolerances (e.g. <code>-0.2:0.2</code> means controls will be acceptable if within ±0.2 of the match null).</p></li>
<li><p>The <code>~</code> character is used in <code>split_by()</code> to specify different levels of an independent variable (e.g. <code>1.5:2.5 ~ 3.5:4.5 ~ 5.5:6.5</code> would specify three levels).</p></li>
</ul>
</div>
<br>

### Output {-}

Let's have a closer look at the first 5 rows of `stim`, which contains the output from above:

<div class = 'table'>

 item_nr  A1_B1        A1_B2        A2_B1        A2_B2        match_null 
--------  -----------  -----------  -----------  -----------  -----------
       1  abide        merit        caddy        basin        A2_B1      
       2  acceptably   beseeching   typescript   fourteenth   A1_B2      
       3  snobby       relent       duffel       shelve       A1_B2      
       4  subtlety     riveting     bagpipes     headless     A2_B2      
       5  adequacy     endeared     typeface     whiteout     A2_B2      

</div>

<br>
We can see that we have 4 conditions:

* **A1_B1** (abstract, low probability)

* **A1_B2** (abstract, high probability)

* **A2_B1** (concrete, low probability)

* **A2_B2** (concrete, high probability)

<br>
Each row of the dataframe is controlled for in terms of frequency and length. The `match_null` variable tells us which condition stimuli were matched relative to. For instance, we can see that in row 3, items are matched relative to the word "relent". This means (for example) that all words for `item_nr` 3 are within ±0.2 Zipf of the Zipf value associated with the word snobby. By default, LexOPS will select the match_null for each item pseudo-randomly, such that each condition will be used as a match null an equal number of times, or as close to this ideal as is possible (e.g. the number of items requested may not be divisible by the number of conditions).

## Converting to Long Format

The table above shows the generated stimuli in wide format. This is a useful way to quickly view the stimuli and get a sense for what has been generated, but we often want to check our stimuli in more detail. The `long_format()` function is a quick way to convert stimuli generated in LexOPS into long format:


```r
stim_long <- long_format(stim)
```

Now we have the same stimuli in long format, with their associated values. Here are the same first 5 matched items from earlier, but in long format:

\small
<div class = 'table'>

 item_nr  condition   match_null   string        Zipf.SUBTLEX_UK   Length   BG.SUBTLEX_UK   CNC.Brysbaert
--------  ----------  -----------  -----------  ----------------  -------  --------------  --------------
       1  A1_B1       A2_B1        abide                3.453132        5       0.0029111            1.68
       1  A1_B2       A2_B1        merit                3.577120        5       0.0122070            1.66
       1  A2_B1       A2_B1        caddy                3.575405        5       0.0024618            4.32
       1  A2_B2       A2_B1        basin                3.482487        5       0.0100465            4.63
       2  A1_B1       A1_B2        acceptably           1.540834       10       0.0026093            1.48
       2  A1_B2       A1_B2        beseeching           1.473887       10       0.0095482            1.88
       2  A2_B1       A1_B2        typescript           1.297796       10       0.0027336            4.37
       2  A2_B2       A1_B2        fourteenth           1.540834       10       0.0120087            4.21
       3  A1_B1       A1_B2        snobby               2.564967        6       0.0017474            1.81
       3  A1_B2       A1_B2        relent               2.376977        6       0.0108419            1.69
       3  A2_B1       A1_B2        duffel               2.318985        6       0.0020055            4.12
       3  A2_B2       A1_B2        shelve               2.459164        6       0.0105992            4.41
       4  A1_B1       A2_B2        subtlety             2.913220        8       0.0025943            1.54
       4  A1_B2       A2_B2        riveting             2.941248        8       0.0097598            1.85
       4  A2_B1       A2_B2        bagpipes             3.162603        8       0.0028140            4.93
       4  A2_B2       A2_B2        headless             3.040128        8       0.0093918            4.42
       5  A1_B1       A2_B2        adequacy             2.158134        8       0.0020388            1.86
       5  A1_B2       A2_B2        endeared             2.348948        8       0.0107752            1.78
       5  A2_B1       A2_B2        typeface             2.297796        8       0.0023554            4.21
       5  A2_B2       A2_B2        whiteout             2.172857        8       0.0092599            4.28

</div>
\normalsize

Here we can see that indeed, the different conditions are within the boundaries we set, and that the variables used as controls are matched for items with the same `item_nr`.

## Plotting the Design

While having data in long format is undoubtably useful, it's not very efficient if you want to check what your stimuli look like in a quick glance (especially if your stimuli number in the thousands). What you probably want to do is plot the long format data to see how your stimuli differ between conditions and across matched items. Thankfully, LexOPS has a handy function to do exactly that:


```r
plot_design(stim)
```

<div class="figure" style="text-align: center">
<img src="02-generate_files/figure-html/unnamed-chunk-11-1.png" alt="The results of the `plot_design()` function for the generated stimuli." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-11)The results of the `plot_design()` function for the generated stimuli.</p>
</div>

The distributions of all the numeric variables used as independent variables or controls are plotted for each condition (in a grey violin plot). The points depict the values of individual words, and points of the same colour (joined by lines) are matched items. As we'd expect, our example stimuli show the expected differences in Bigram Probability and Concreteness, while Frequency is matched closely, and Length is matched exactly.

## Generating as Many as Possible

Let's imagine that we're not entirely sure how many stimuli we could generate using our design. It may be that the `n = 25` [we used earlier](#generating-stimuli) is considerably fewer than the number of stimuli we could generate with no problems. One way to test this is to have LexOPS generate as many stimuli as possible. We can do this by setting `n = "all"`:


```r
possible_stim <- LexOPS::lexops %>%
  subset(PK.Brysbaert >= 0.9) %>%
  split_by(CNC.Brysbaert, 1:2 ~ 4:5) %>%
  split_by(BG.SUBTLEX_UK, 0:0.003 ~ 0.009:0.013) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.2:0.2) %>%
  generate(n = "all", match_null = "random")
```

This is much slower, as LexOPS will continue trying to generate combinations of words that fit the specified characteristics until it has exhausted all the possibilities. Nevertheless, we actually generated 102 words generated per condition. This number is likely to change slightly each time we run the pipeline, as different combinations are randomly made from all the possible combinations. That said, it *is* a fairly good indication of the number of possible stimuli we could generate.

The 102 words we've managed to generate per condition here is quite a bit higher than the 25 we originally generated. Does this mean we should just request a larger stimulus list, such as `n = 80`? Well, it depends. If we want as many stimuli as are possible, then it may make sense to just set `n = "all"`, but often we only want to use as many stimuli as we need to find our effect. Also, if we use as many combinations as possible, experimenters who want to replicate our effect using a different set of stimuli will likely have fewer novel combinations available to them.

<div class="danger">
<p>Note that when <code>n = "all"</code>, the default <code>match_null = "balanced"</code> is not recommended, as LexOPS will not know how many iterations will successfully generate items before the <code>generate()</code> function is actually run. LexOPS will give a warning if <code>n = "all"</code> and <code>match_null = "balanced"</code>, because the conditions selected as the match null will not actually be balanced in the generated stimuli.</p>
</div>

## Plotting Iterations

It is also possible to check how well LexOPS performed when generating stimuli by plotting the cumulative item generation by iterations. To do this, we can use the `plot_iterations()` function. As an example, let's see how well we generated the stimuli in the last section.


```r
plot_iterations(possible_stim)
```

<div class="figure" style="text-align: center">
<img src="02-generate_files/figure-html/unnamed-chunk-14-1.png" alt="The cumulative number of items generated per iteration." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-14)The cumulative number of items generated per iteration.</p>
</div>

This shows a characteristic levelling-off; iterations become increasingly less likely to successfully generate items as the pool of possible combinations is gradually exhausted.

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

 item_nr  A1_B1       A1_B2       A2_B1       A2_B2       match_null 
--------  ----------  ----------  ----------  ----------  -----------
       1  proper      winner      normal      create      A1_B2      
       2  telegraph   terrorism   stability   terrified   A2_B2      
       3  polite      thrill      retain      lively      A2_B2      
       4  stool       lotto       prawn       rifle       A1_B1      
       5  tree        kill        list        sale        A1_B2      

</div>

These stimuli could then be used in combination with a counter-balanced design, alternating which level of B has its stimuli presented before the coffee, and which after. Note that the `split_random()` function will also need its own [random seed](#random-seeds) (`seed = ...`) to replicate a specific stimulus list.

## Random Seeds

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

