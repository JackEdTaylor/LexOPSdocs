# FAQ

### How should I cite LexOPS? {-}

If you use LexOPS to generate your stimuli, please cite it! Make sure you also cite the sources for any datasets you use, regardless of whether they are included the LexOPS in-built dataset.

Here is how to cite LexOPS:

<div class="cite">
<p>Taylor, J. E., Beith, A., &amp; Sereno, S. C. (2020). LexOPS: An R
Package and User Interface for the Controlled Generation of Word
Stimuli. <i>Behaviour Research Methods</i>, <i>52</i>, 2372–2382.
http://doi.org/10.3758/s13428-020-01389-1</p>
</div>

### What is a "match null"? {-}

The "match null" is a term used in the [generate pipeline](the-generate-pipeline.html), specified as the `match_null` argument in the `generate()` function. Whenever you control for variables in the generate pipeline, items are always matched relative to one of the specified conditions. The condition that items are matched relative to is referred to as the match null.

Here is a summary of the possible options for the `match_null` argument:

<br>

|match_null                          |Effect                                                                                                                                                                                                                                                                                                                                                                                                                            |
|:-----------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`"balanced"` (default)              |Each condition will be used as a match null an equal number of times, or as close to this as possible, in a random order. Since `match_null = "balanced"` works by dividing `n` by the number of conditions, this default will not work when `n = "all"` as the `generate()` function will not know how many stimuli will be generated in the stimulus list. This is why you'll get a warning if these options are used together. |
|`"inclusive"`                       |All conditions will be within the specified tolerances to *all other* conditions. This is usually the best setting for designs with 3 or more factorial cells. When you have 2 factorial cells, `"balanced"` and `"inclusive"` are equivalent.                                                                                                                                                                                    |
|`"random"`                          |Match nulls will be allocated randomly out of all possible conditions.                                                                                                                                                                                                                                                                                                                                                            |
|specific condition (e.g. `"A1_B1"`) |The selected condition will be used as a match null for all generated items.                                                                                                                                                                                                                                                                                                                                                      |

<br>
The match null used for each generated item is stored in the wide and long formats of the output from the generate pipeline, as the variable `match_null`.
