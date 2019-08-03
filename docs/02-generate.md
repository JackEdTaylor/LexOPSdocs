
# The Generate Pipeline



## Generating Stimuli

One of the most noteworthy features of LexOPS is that it can generate controlled stimuli for any possible factorial design. This can be done in a pipeline using 3 main functions:

* `split_by()` to specify "splits" (independent variables) in the experimental design
* `control_for()` to specify variables that should be controlled for between conditions
* `generate()` to run the algorithm and generate the stimuli

As an example, we may want to generate stimuli for a 2x2 factorial design in a Lexical Decision Task, examining whether a possible effect of bigram probability interacts with concreteness.

Let's imagine that we want **abstract and concrete words** (according to Brysbaert, Warriner and Kuperman (2014)), of **high and low bigram probability** (based on SUBTLEX-UK (van Heuven, Mandera, Keuleers, & Brysbaert, 2014)). We also want to filter the data, such that our stimuli only consist of words that at least 90% of people actually know (according to Brysbaert, Mandera, and Keuleers (2018)). Finally, we want to control for the potential confounds of word length exactly and word frequency (according to SUBTLEX-UK (van Heuven, Mandera, Keuleers, & Brysbaert, 2014)) within ±0.2 Zipf, and would like 25 words per condition.


```r
library(LexOPS)

stim <- LexOPS::lexops %>%
  subset(PK.Brysbaert >= 0.9) %>%
  split_by(CNC.Brysbaert, 1:2 ~ 4:5) %>%
  split_by(BG.SUBTLEX_UK, 0:0.003 ~ 0.009:0.013) %>%
  control_for(Length, 0:0) %>%
  control_for(Zipf.SUBTLEX_UK, -0.2:0.2) %>%
  generate(n = 25)
```

<div class="info">
<p>Important notes on LexOPS (non-standard) syntax:</p>
<ul>
<li><p>As in the tidyverse, variables in the dataframe can be referenced outside of quotation marks.</p></li>
<li><p>The <code>:</code> character is used in <code>split_by()</code> to specify numeric boundaries (e.g. <code>0.009:0.013</code> means any number from 0.009 to 0.013 is acceptable for this level of the variable), and in and <code>control_for()</code> to specify tolerances (e.g. <code>-0.2:0.2</code> means controls will be acceptable if within ±0.2 of the match null).</p></li>
<li><p>The <code>~</code> character is used in <code>split_by()</code> to specify different levels of an independent variable (e.g. <code>1.5:2.5 ~ 3.5:4.5 ~ 5.5:6.5</code> would specify three levels of an independent variable).</p></li>
</ul>
</div>

Let's have a look at the first 5 rows of `stim` as an example:

<div class = 'table'>

 item_nr  A1_B1        A1_B2        A2_B1        A2_B2        match_null 
--------  -----------  -----------  -----------  -----------  -----------
       1  abide        merit        caddy        basin        A2_B1      
       2  acceptably   beseeching   typescript   fourteenth   A1_B2      
       3  snobby       relent       duffel       shelve       A1_B2      
       4  subtlety     riveting     bagpipes     headless     A2_B2      
       5  adequacy     endeared     typeface     whiteout     A2_B2      

</div>

We can see that we have 4 conditions:

* **A1_B1** (abstract, low probability)

* **A1_B2** (abstract, high probability)

* **A2_B1** (concrete, low probability)

* **A2_B2** (concrete, high probability)

Each row of the table is controlled for in terms of frequency and length. The `match_null` variable tells us which condition stimuli were matched relative to. For instance, we can see that in row 3, items are matched relative to the word "snobby". This means (for example) that all words for `item_nr` 3 are within ±0.2 Zipf of the Zipf value associated with the word snobby. By default, LexOPS will select the match_null for each item pseudo-randomly, such that each condition will be used as a match null an equal number of times, or as close to this ideal as is possible (e.g. the number of items requested may not be divisible by the number of conditions).

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
<img src="02-generate_files/figure-html/unnamed-chunk-8-1.png" alt="The results of the `plot_design()` function for the generated stimuli." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-8)The results of the `plot_design()` function for the generated stimuli.</p>
</div>

Here, all the numeric variables used as independent variables or controls have their distributions plotted  for each condition (in a grey violin plot). The points depict the values of individual words, and points of the same colour (joined by lines) are matched items. As we'd expect, our example stimuli show the expected differences in Bigram Probability and Concreteness, while Frequency is matched closely, and Length is matched exactly.

## Generating as Many as Possible

Let's imagine that we're not entirely sure how many stimuli we could generate using our design. It may be that the `n = 25` [we used earlier](#Generating-Stimuli) is considerably fewer than the number of stimuli we could generate with no problems. One way to test this is to have LexOPS generate as many stimuli as possible. We can do this by setting `n = "all"`:


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
<img src="02-generate_files/figure-html/unnamed-chunk-11-1.png" alt="The cumulative number of items generated per iteration." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-11)The cumulative number of items generated per iteration.</p>
</div>

Here, this shows a characteristic levelling-off; iterations become increasingly less likely to successfully generate items as the pool of possible combinations is gradually exhausted.