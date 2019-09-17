
# FAQ

### What is a "match null"? {-}

The "match null" is a term used in the [generate pipeline](the-generate-pipeline.html), specified as the `match_null` argument in the `generate()` function. Whenever you control for variables in the generate pipeline, items are always matched relative to one of the specified conditions. The condition that items are matched relative to is referred to as the match null.

The default for the `generate()` function is to use `match_null = "balanced"`. This means that each condition is used as a match null an equal number of times, or as close to this as possible, in a random order. For example, if you specify 4 conditions (A1_B1, A1_B2, A2_B1, A2_B2) and ask for 50 stimuli (`n = 50`), by default the algorithm will randomly select two conditions to be used 12 times as match nulls, and two conditions to be used 13 times.

Since `match_null = "balanced"` works by dividing `n` by the number of conditions, this default will not work when `n = "all"` as the `generate()` function will not know how many stimuli will be generated in the stimulus list. This is why you'll get a warning if these options are used together. One alternative may be to use `match_null = "random"`.

It is also possible to use a specific condition as the match null for each item. If you want to use condition A1_B2 as your null for instance, you can do this by specifying `match_null = "A1_B2"`.

The match null used for each generated item is stored in the wide and long formats of the output from the generate pipeline, as the variable `match_null`.

