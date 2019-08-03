
# Matching Individual Words

While the generate pipeline is usually sufficient, it's sometimes important to tailor stimuli more precisely. For instance, it may be important that a matched word is a plausible replacement for a target word in a sentence. The `match_word()` function exists for this purpose.

This function is currently more cumbersome to use than the generate pipeline, but might be updated to use similar tidyverse-style syntax in the future.

Here's an example usage of `match_word`, to suggest a word matched for "elephant" in terms of:

* Length (exactly)
* Frequency (within ±0.25 Zipf)
* Imageability (within ±1, on a 1-7 Likert rating scale)
* Part of Speech (i.e. is also a noun)

<div class = 'table'>

```r
library(tidyverse)
library(LexOPS)

lexops %>%
  match_word(
    target = "elephant",
    list(
      "Length",
      c("Zipf.SUBTLEX_UK", -0.25, 0.25),
      c("IMAG.Glasgow_Norms", -1, 1),
      "PoS.SUBTLEX_UK"
    )
  ) %>%
  select(string, euclidean_distance, Length, Zipf.SUBTLEX_UK, IMAG.Glasgow_Norms, PoS.SUBTLEX_UK)
```

```
## # A tibble: 18 x 6
##    string euclidean_dista~ Length Zipf.SUBTLEX_UK IMAG.Glasgow_No~
##    <chr>             <dbl>  <int>           <dbl>            <dbl>
##  1 sandw~            0.128      8            4.25             6.76
##  2 trous~            0.202      8            4.24             6.63
##  3 wardr~            0.325      8            4.10             6.62
##  4 cloth~            0.330      8            4.14             6.55
##  5 calen~            0.336      8            4.33             6.4 
##  6 magaz~            0.352      8            4.29             6.38
##  7 bunga~            0.373      8            4.17             6.42
##  8 envel~            0.400      8            4.10             6.47
##  9 festi~            0.498      8            4.51             6.24
## 10 motor~            0.531      8            4.11             6.23
## 11 exerc~            0.555      8            4.45             6.12
## 12 treas~            0.560      8            4.46             6.12
## 13 portr~            0.586      8            4.18             6.10
## 14 engin~            0.608      8            4.14             6.09
## 15 docum~            0.631      8            4.18             6.03
## 16 shoot~            0.701      8            4.39             5.90
## 17 appla~            0.707      8            4.21             5.91
## 18 darkn~            0.729      8            4.14             5.91
## # ... with 1 more variable: PoS.SUBTLEX_UK <fct>
```

</div>

The suggested matches are returned in a dataframe, filtered to be within the specified tolerances, and ordered by euclidean distance from the target word (calculated using all the numeric variables used). The closest suggested match for "elephant" is "sandwich".
