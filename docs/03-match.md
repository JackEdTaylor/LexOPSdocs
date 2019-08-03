
# Matching Individual Words

While the generate pipeline is usually sufficient, it's sometimes important to tailor stimuli more precisely. For instance, it may be important that a matched word is a plausible replacement for a target word in a sentence. The `match_word()` function exists for this purpose.

This function is currently more cumbersome to use than the generate pipeline, but might be updated to use similar tidyverse-style syntax in the future.

Here's an example usage of `match_word`, to suggest a word matched for "elephant" in terms of:

* Length (exactly)
* Frequency (within ±0.25 Zipf)
* Imageability (within ±1, on a 1-7 Likert rating scale)
* Part of Speech (i.e. is also a noun)


```r
library(tidyverse)
library(LexOPS)

suggested_matches <- lexops %>%
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

The suggested matches are returned in a dataframe, filtered to be within the specified tolerances, and ordered by euclidean distance from the target word (calculated using all the numeric variables used). The closest suggested match for "elephant" is "sandwich". If we are looking for a match to fit in a sentential context, we can choose the best suitable match from this list.

<div class = 'table'>

string      euclidean_distance   Length   Zipf.SUBTLEX_UK   IMAG.Glasgow_Norms  PoS.SUBTLEX_UK 
---------  -------------------  -------  ----------------  -------------------  ---------------
sandwich             0.1277845        8          4.246820               6.7647  noun           
trousers             0.2015595        8          4.244371               6.6286  noun           
wardrobe             0.3254995        8          4.104315               6.6176  noun           
clothing             0.3302426        8          4.135068               6.5455  noun           
calendar             0.3359636        8          4.329810               6.4000  noun           
magazine             0.3522378        8          4.287246               6.3846  noun           
bungalow             0.3726767        8          4.172277               6.4242  noun           
envelope             0.4004120        8          4.096792               6.4706  noun           
festival             0.4979158        8          4.510449               6.2353  noun           
motorway             0.5312793        8          4.107187               6.2333  noun           
exercise             0.5545788        8          4.449319               6.1212  noun           
treasure             0.5598275        8          4.458939               6.1176  noun           
portrait             0.5860690        8          4.183298               6.0968  noun           
engineer             0.6080041        8          4.138999               6.0909  noun           
document             0.6314306        8          4.182166               6.0323  noun           
shooting             0.7013990        8          4.391130               5.9032  noun           
applause             0.7068316        8          4.209885               5.9143  noun           
darkness             0.7291090        8          4.143049               5.9118  noun           

</div>
