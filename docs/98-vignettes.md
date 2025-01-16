# Vignettes

These vignettes demonstrate some common use cases for LexOPS. Click on a vignette to view it.




```{=html}
<a style="text-decoration:none;color:black;" href="vignettes/control_for_map.html"><div class="code-link"><b>1) Higher Level Controls
(control_for_map): </b>The control_for() function works well when your variable
is 1-dimensional, with a single value for each word, as it is for
variables like Length, Frequency or Concreteness. Things become slightly
trickier, however, when controlling for distance or similarity values,
which can be calculated for each unique combination of words (i.e. \(n^2\) values). One easy solution is to use
control_for_map() to pass a function which should be used
to calculate the value between any two words. Simple examples for
controlling for orthographic and phonological similarity are available
in the package
bookdown site. This vignette demonstrates how to build your own
function for control_for_map(), which in this example
controls for semantic similarity.</div></a>
</br><a style="text-decoration:none;color:black;" href="vignettes/custom-data.html"><div class="code-link"><b>2) Using Data from Custom Sources: </b>The built-in variables of LexOPS are useful but not exhaustive.
Thankfully, LexOPS can work with any suitable list of features. For this
example, we will join the Lancaster
Sensorimotor norms to Engelthaler and
Hills’ humour ratings, and the in-built LexOPS dataset
(LexOPS::lexops). We can then use this to generate stimuli
with a visual rating by humour interaction, controlling for length and
frequency.</div></a>
</br><a style="text-decoration:none;color:black;" href="vignettes/custom-levels.html"><div class="code-link"><b>3) Creating Custom Levels: </b>By default, LexOPS will split by a single variable for each use of
split_by(), and will create items for each factorial cell.
For instance, splitting by arousal into 2 levels, and emotional valence
into 3 levels, would result in 6 factorial cells. But what if we want to
generate items for just 2 of these 6 factorial cells? We can do this by
creating a factor/character vector column in our data which will
represent suitability for each factorial cell. This vignette provides an
example, where we want to compare high arousal, negative emotional words
to low arousal neutral words.</div></a>
</br><a style="text-decoration:none;color:black;" href="vignettes/euclidean-distance.html"><div class="code-link"><b>4) Euclidean Distance: </b>Euclidean distance can be a useful way of matching by or controlling
for multiple variables with greater flexibility than dealing with the
variables individually. This vignette explains how weighted and
unweighted Euclidean distance is calculated in LexOPS, gives example
usage with euc_dists() and match_item(), and
introduces the control_for_euc() function. The latter
allows you to generate stimuli controlling for Euclidean distance to a
match null within a Generate pipeline.</div></a>
</br><a style="text-decoration:none;color:black;" href="vignettes/participant-selection.html"><div class="code-link"><b>5) Applications to Participant Selection: </b>LexOPS has potential applications in designing between-subject
studies that control for participant variables. In this example, a
randomised control trial is imagined, where subjects need to be matched
for some relevant variables such as age, sex, BMI, and IQ. Given the
pool of possible participants, LexOPS can be used to match subjects in
the intervention and control conditions.</div></a>
```
