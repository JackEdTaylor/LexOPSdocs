
# FAQ

### How should I cite LexOPS? {-}

If you use LexOPS to generate your stimuli, please cite it! Make sure you also cite the sources for any datasets you use, regardless of whether they are included the LexOPS in-built dataset.

Here is how to cite LexOPS:

<div class="cite">
<p>Taylor, J. E., Beith, A., &amp; Sereno, S. C. (2019, September 17). LexOPS: An R Package and User Interface for the Controlled Generation of Word Stimuli. <a href="https://doi.org/10.31234/osf.io/7sudw" class="uri">https://doi.org/10.31234/osf.io/7sudw</a></p>
</div>

### What is a "match null"? {-}

The "match null" is a term used in the [generate pipeline](the-generate-pipeline.html), specified as the `match_null` argument in the `generate()` function. Whenever you control for variables in the generate pipeline, items are always matched relative to one of the specified conditions. The condition that items are matched relative to is referred to as the match null.

The default for the `generate()` function is to use `match_null = "balanced"`. This means that each condition is used as a match null an equal number of times, or as close to this as possible, in a random order. For example, if you specify 4 conditions (A1_B1, A1_B2, A2_B1, A2_B2) and ask for 50 stimuli (`n = 50`), by default the algorithm will randomly select two conditions to be used 12 times as match nulls, and two conditions to be used 13 times.

Since `match_null = "balanced"` works by dividing `n` by the number of conditions, this default will not work when `n = "all"` as the `generate()` function will not know how many stimuli will be generated in the stimulus list. This is why you'll get a warning if these options are used together. One alternative may be to use `match_null = "random"`.

Inclusive match nulls are also possible with `match_null = "inclusive"`, where stimuli will only be produced which are within the specified tolerances of each other stimulus they are matched to.

It is also possible to use a specific condition as the match null for each item. If you want to use condition A1_B2 as your null for instance, you can do this by specifying `match_null = "A1_B2"`.

The match null used for each generated item is stored in the wide and long formats of the output from the generate pipeline, as the variable `match_null`.
