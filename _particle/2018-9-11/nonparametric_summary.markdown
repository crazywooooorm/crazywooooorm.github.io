# Brief Summary of Nonparametric Statistics

## Basic

### Measurement
* Nominal (Classificatory Scale): Usually used to classify objects, each
subclass is mutual exclusive and equivalent.
* Ordinal (Ranking Scale): Nominal measurement but subclasses hold some order,
which makes them not equivalent from each other.
* Interval: Ordinal measurement but the distance between subclasses makes sense.
* Ratio: Interval measurement and has a true zero, which makes the ratio
calculation to be possible.

Difference between Interval scale and Ratio scale: Interval scale includes time
and temperature. You know the distance between data so you can do the add or
subtract operation, while you would never try to divide a time with another time
because their is no "zero time". Ratio scale, however, like weight or height, you
have "absolute zero", so you can do multiply or divide operation on this scale.

### Pros and Cons

#### Pros
* Doesn't depend on shape of distributions or other assumptions (assumptions
of distribution are actually pretty difficult to meet in many case).
* Works for small sample.
* Deals with data with different measurements.

#### Cons
* Might lose power and information when the assumptions on distributions are
actually met.

## One-Sample Case

### Binomial Test
* Works for nominal data with only two categories.
* In small samples, generate test result by directly using binomial formulas;
In large samples (>= 25), using normal approximation can make it easier to
calculate, but a continuity correction (+- 0.5) is needed.  

### Chi-Squared test
* Works for nominal data with various categories.
* In one sample chi-squared test, if k = 2, each expected frequency should >= 5. If
k>2, the number of < 5 groups must be smaller than 20% of total groups. If it
does happen, combine the adjacent groups.

### Kolmogorov-Smirnov One-Sample Test
* Test whether a set of data has the same distribution with a theoretical
distribution by comparing the difference between CDFs.

### One-Sample Run Test
* Test the randomness of the temporal occurrence or sequence of the scores in a
sample. Can be approximated to a normal distribution in a large sample case.

## Two-Samples Related Case

### McNemar Test
* Works for paired nominal data with binary output. Each observation is the
control of its own.
* Use the similar method with chi-squared test. The good part of the chi-square
test is that we can always create an approximated Chi-square statistic by
calculating Sum(((Oi - Ei)^2)/Ei) and then apply the test. In McNemar test, we
use two cells to create a Chi-square statistic.
* McNemar test always needs a continuity correction when applying the
approximation of Chi-squared test.
* If the expected frequencies are less than 5, replace McNemar test with
binomial test.

### Sign Test
* Works for at least paired ordinal data. Especially, "tie" is dropped, just
like "No move" would be dropped in McNemar test.
* In a small sample case, sign test is a binomial test; In a large sample case,
we can use the normal approximation for that binomial test, while a continuity
correction for that approximation is needed.

### Wilcoxon Signed-Rank Test
* Works for at least paired interval data since distance is considered.
* The mean and variance of rank sum statistic can be calculated easily, then use a normal
approximation for the total rank statistic.

### Matched Pairs Randomization Test
* Works for at least paired interval data, but as a permutation test, it 
doesn't need any assumptions about normality or homogeneity of variance.  
