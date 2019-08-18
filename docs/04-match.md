
# Matching Individual Words

While the generate pipeline is usually sufficient, it's sometimes important to tailor stimuli more precisely. For instance, it may be important that a matched word is a plausible replacement for a target word in a sentence. The `match_word()` function exists for this purpose.

This function is currently more cumbersome to use than the generate pipeline, but might be updated to use similar tidyverse-style syntax in the future.

## Example

Here's an example usage of `match_word`, to suggest a word matched for "elephant" in terms of:

* Length (exactly)
* Frequency (within ±0.25 Zipf)
* Imageability (within ±1, on a 1-7 Likert rating scale)
* Part of Speech (i.e. is also a noun)


```r
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
  )
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

## Matching by Similarity

You may want to match by similarity to the target word. Thankfully this is more straightforward than in the generate pipeline (see [`control_for_map()`](advanced-stimulus-generation.html#map-functions-as-controls)).

### Orthographic similarity

Here's an example, matching "leaflet" by orthographic similarity. We just have to calculate the similarity measure before using the `match_word()` function.


```r
library(LexOPS)
library(vwr)
library(dplyr)

target_word <- "interesting"

suggested_matches <- lexops %>%
  mutate(orth_sim = as.numeric(levenshtein.distance(string, target_word))) %>%
  match_word(
    target = target_word,
    list(
      c("orth_sim", 0, 3)
    )
  )
```

Note that some of these are misspellings or unusual words, but we could remove these by filtering (e.g. with `dplyr::filter()`) or matching (with `match_word()`) by frequency, proportion known, or familiarity ratings.

<div class = 'table'>

string           euclidean_distance   orth_sim
--------------  -------------------  ---------
interestin                0.8300026          1
interacting               1.6600052          2
intercepting              1.6600052          2
interestingay             1.6600052          2
interestingly             1.6600052          2
interjecting              1.6600052          2
intermeshing              1.6600052          2
intersecting              1.6600052          2
uninteresting             1.6600052          2
entreating                2.4900077          3

</div>

### Phonological Similarity

To match by phonological similarity, we just have to calculate the levenshtein distance on one-letter phonemic representations, e.g. with `CMU.1letter` or `eSpeak.br_1letter`. Here we find words that are only 0 to 2 phonemic insertions, deletions, or substitutions away from "interesting".


```r
library(LexOPS)
library(vwr)
library(dplyr)

target_word <- "interesting"

# get the target word's pronunciation
target_word_pron <- lexops %>%
  filter(string == target_word) %>%
  pull(CMU.1letter)

# find phonologically similar words
suggested_matches <- lexops %>%
  mutate(phon_sim = as.numeric(levenshtein.distance(CMU.1letter, target_word_pron))) %>%
  match_word(
    target = target_word,
    list(
      c("phon_sim", 0, 2)
    )
  )
```

Which gives us:

<div class = 'table'>

string          euclidean_distance   phon_sim  CMU.1letter 
-------------  -------------------  ---------  ------------
entrusting               0.9528806          1  EntrAstIG   
encrusting               1.9057612          2  EnkrAstIG   
entrusted                1.9057612          2  EntrAstId   
instructing              1.9057612          2  InstrAktIG  
interest                 1.9057612          2  IntrAst     
interested               1.9057612          2  IntrAstAd   
interests                1.9057612          2  IntrAsts    
interrupting             1.9057612          2  IntRAptIG   
intrastate               1.9057612          2  IntrAstet   
mistrusting              1.9057612          2  mIstrAstIG  

</div>

