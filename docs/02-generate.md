
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

* Filtered such that **at least 90% of people know each word**, according to Brysbaert, Mandera, McCormick, and Keuleers (2019).

* **Two levels of Concreteness** (abstract and concrete words) according to Brysbaert, Warriner and Kuperman (2014).

* **Two levels of Bigram Probability** (low and high probability) based on SUBTLEX-UK (van Heuven, Mandera, Keuleers, & Brysbaert, 2014).
  
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
<li><p>The <code>:</code> character is used in <code>split_by()</code> to specify numeric boundaries (e.g. <code>0.009:0.013</code> means any number from 0.009 to 0.013 is acceptable for this level of the variable), and in <code>control_for()</code> to specify tolerances (e.g. <code>-0.2:0.2</code> means controls will be acceptable if within ±0.2 of the match null).</p></li>
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
       2  unspecific   sinisterly   typescript   storefront   A1_B2      
       3  broadly      reliant      giraffe      coroner      A1_B2      
       4  deftly       pathos       smooch       sandal       A2_B2      
       5  ultra        revel        pluck        minty        A2_B2      

</div>

<br>
We can see that we have 4 conditions:

* **A1_B1** (abstract, low probability)

* **A1_B2** (abstract, high probability)

* **A2_B1** (concrete, low probability)

* **A2_B2** (concrete, high probability)

<br>
Each row of the dataframe is controlled for in terms of frequency and length. The `match_null` variable tells us which condition stimuli were matched relative to. For instance, we can see that in row 3, items are matched relative to the word "relent". This means that all words for `item_nr` 3 are within ±0.2 Zipf of the Zipf value associated with the word "relent". By default, LexOPS will select the match_null for each item pseudo-randomly, such that each condition will be used as a match null an equal number of times (`match_null = "balanced"`), or as close to this ideal as is possible (e.g. the number of items requested may not be divisible by the number of conditions). See [this FAQ section](faq.html#what-is-a-match-null) for more information on match nulls.

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
       2  A1_B1       A1_B2        unspecific           1.540834       10       0.0029410            1.41
       2  A1_B2       A1_B2        sinisterly           1.473887       10       0.0098809            1.75
       2  A2_B1       A1_B2        typescript           1.297796       10       0.0027336            4.37
       2  A2_B2       A1_B2        storefront           1.473887       10       0.0096897            4.00
       3  A1_B1       A1_B2        broadly              3.648528        7       0.0028142            1.68
       3  A1_B2       A1_B2        reliant              3.602609        7       0.0103099            1.83
       3  A2_B1       A1_B2        giraffe              3.777083        7       0.0021165            4.73
       3  A2_B2       A1_B2        coroner              3.726335        7       0.0107999            4.34
       4  A1_B1       A2_B2        deftly               2.329204        6       0.0025051            1.96
       4  A1_B2       A2_B2        pathos               2.620015        6       0.0121742            1.48
       4  A2_B1       A2_B2        smooch               2.263937        6       0.0028086            4.21
       4  A2_B2       A2_B2        sandal               2.443924        6       0.0091593            4.68
       5  A1_B1       A2_B2        ultra                3.572531        5       0.0029273            1.55
       5  A1_B2       A2_B2        revel                3.254444        5       0.0093859            1.69
       5  A2_B1       A2_B2        pluck                3.377881        5       0.0019315            4.00
       5  A2_B2       A2_B2        minty                3.421647        5       0.0099473            4.11

</div>
\normalsize

Here we can see that indeed, the different conditions are within the boundaries we set, and that the variables used as controls are matched for items with the same `item_nr`.

## Plotting the Design

While having data in long format is undoubtably useful, it's not very efficient if you want to check what your stimuli look like in a quick glance (especially if your stimuli number in the thousands). What you probably want to do is create a plot to see how your stimuli differ between conditions and across matched items. Thankfully, LexOPS has a handy function to do exactly that:


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

This is much slower, as LexOPS will continue trying to generate combinations of words that fit the specified characteristics until it has exhausted all the possibilities. Nevertheless, we actually generated 101 words generated per condition with the code above. This number is likely to change slightly each time we run the pipeline, as different combinations are randomly made from all the possible combinations. That said, it is a fairly good *indication* of the number of possible stimuli we could generate.

The 101 words we've managed to generate per condition here is quite a bit higher than the 25 we originally generated. Does this mean we should just request a larger stimulus list, such as `n = 80`, or even `n = 100`? Well, it depends. If we want as many stimuli as are possible, then it may make sense to just set `n = "all"`, but often we only want to use as many stimuli as we need to find our effect. Also, if we use as many combinations as possible, experimenters who want to replicate our effect using a different set of stimuli will likely have fewer novel combinations available to them.

<div class="danger">
<p>Note that when <code>n = "all"</code>, you will get a warning if you also keep the default match null setting, <code>match_null = "balanced"</code>. The reason for this is explained in <a href="faq.html#what-is-a-match-null">this FAQ section</a>.</p>
</div>

## Plotting Iterations

It is also possible to check how well LexOPS performed when generating stimuli by plotting the cumulative item generation by iterations. To do this, we can use the `plot_iterations()` function. As an example, let's visualise the algorithm's iterations when we generated as many stimuli as we could in the last section.


```r
plot_iterations(possible_stim)
```

<div class="figure" style="text-align: center">
<img src="02-generate_files/figure-html/unnamed-chunk-14-1.png" alt="The cumulative number of items generated per iteration." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-14)The cumulative number of items generated per iteration.</p>
</div>

This shows a characteristic levelling-off; iterations become increasingly less likely to successfully generate items as the pool of possible combinations is gradually exhausted.

## Custom Dataframes

While the [LexOPS Dataset](introduction.html#the-lexops-dataset) has lots of useful features for English, it isn't exhaustive, and other languages do exist! The LexOPS functions will actually work with any dataframe, with words from any language. As an example, here's how to generate a stimulus list of negative, neutral, and positive German words matched for length and frequency, based on the [Leipzig Affective Norms for German (LANG) (Kanske & Kotz, 2010)](http://doi.org/10.3758/BRM.42.4.987).


```r
library(readr)
LANG <- read_csv("kanske_kotz_2010.csv", locale=locale(encoding = "latin1"))

stim <- LANG %>%
  split_by(valence_mean, 1:3.5 ~ 4.75:5.25 ~ 6.5:9) %>%
  control_for(number_of_letters, 0:0) %>%
  control_for(frequency, -1:1) %>%
  generate(20, string_col = "word")
```

Here are the first five items generated for each condition:

\small
<div class = 'table'>

 item_nr  A1       A2       A3       match_null 
--------  -------  -------  -------  -----------
       1  hetze    blase    flirt    A2         
       2  bombe    stamm    komik    A3         
       3  pein     seil     kuss     A1         
       4  ärger    stein    humor    A3         
       5  terror   lehrer   gefühl   A1         

</div>
\normalsize

<br>
<div class="info">
<p>Note that if you’re using your own dataframe, you’ll have to specify which column contains the strings with the <code>string_col</code> argument of the <code>generate()</code> function (above, <code>string_col = "word"</code>), or else rename the column to be “string”.</p>
<p>Custom variables can be neatly integrated with the inbuilt LexOPS dataset (or vice versa) with the <a href="https://dplyr.tidyverse.org/reference/join.html">dplyr join functions</a>. This is how custom variables are used in the Shiny app. See <a href="lexops-shiny-app.html#custom-variables">this section</a> for a example using custom variables in the shiny app.</p>
</div>
<br>
