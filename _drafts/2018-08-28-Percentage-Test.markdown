---
layout: post
title: "Percentage Test"
author: "Xinghao Gu"
date: "August 28, 2018"
categories: Statistics
---
If we try to compare two percentage from two independent groups, which test should we use, T-test or Chi-squared test?

Suppose we want to test whether the prevalence of overweight is different between men and women. We did an investigation and got the estimated overweight prevalence in both men and women groups, then what's next?

Student's t-test is a very popular method to compare population means, while in most cases it only works for numeric data because of one of the assumptions of Students' t-test: The mean follows a normal distribution. In our case, however, we have a binary output for each sample (overweight or not). A more typical method for this situation is Chi-squared test.

Therefore, if we still want to use Students' t-test to test where there's a significant difference between the two overweight prevalence, is it correct? Why or why not?

We know the percentage of being overweight is a Bernoulli distribution with parameter P. And the number of people who are overweight is a binomial distribution with parameter P and N, where N is the sample size of that group. It has been proved (CLT) that binomial distribution is asymptotic to a normal distribution when NP and N(1-P) are both greater than 5. Thus, the percentage of being overweight is asymptotic to a normal distribution with mean = P and variance = P(1-P).

How big is the difference between the two tests? We did a simulation to compare the test results between Chi-squared test and Student's t-test.

{% highlight r %}
sim_prop <- function(N, trial1, trial2 = trial1,
                     theta1, theta2 = theta2) {
  success1 <- rbinom(N, trial1, theta1)
  success2 <- rbinom(N, trial2, theta2)
  output_tab <- data.frame(success1 = success1,
                           success2 = success2,
                           total1 = trial1,
                           total2 = trial2) %>%
    rowwise() %>%
    mutate(p1 = success1/total1,
           p2 = success2/total2,
           se1 = sqrt(p1*(1-p1)/(total1-1)),
           se2 = sqrt(p2*(1-p2)/(total2-1)),
           t_stat = (abs(p1 - p2)/sqrt(se1^2 + se2^2)),
           t_p = 2 * (1 - pt(t_stat, total1+total2-2)),
           chi_p = prop.test(c(success1, success2),
                             c(total1, total2),
                             correct = F)$p.value) %>%
    ungroup() %>%
    summarise(`T-test Reject Percentage` = mean(t_p < 0.05),
              `Chi-squared Reject Percentage` = mean(chi_p < 0.05))

  output_tab
}
{% endhighlight %}


Let's first try what would those tests behave when the true percentages are same.

{% highlight r %}
library(knitr)
library(kableExtra)
library(dplyr)
# simulate for (0.5, 0.5)
data.frame(group1 = c(10, 15, 20, 40, 100),
           group2 = c(30, 15, 20, 40, 100)) %>%
  rowwise() %>%
  do(
    data.frame(`Group 1 Size` = .$group1, `Group 2 Size` = .$group2,
              sim_prop(1000, .$group1, .$group2, 0.5, 0.5)) %>%
      bind_rows()

  ) %>%
  kable(caption = "Simulation on True Percentage is 0.5 and 0.5") %>%
  kable_styling(full_width = F, position = "c")
{% endhighlight %}

And then check what whould those tests behave when the true percentages are different.

{% highlight r %}
# simulate for (0.4, 0.6)
data.frame(group1 = c(10, 15, 20, 40, 100),
           group2 = c(30, 15, 20, 40, 100)) %>%
  rowwise() %>%
  do(
    data.frame(`Group 1 Size` = .$group1, `Group 2 Size` = .$group2,
              sim_prop(1000, .$group1, .$group2, 0.4, 0.6)) %>%
      bind_rows()

  ) %>%
  kable(caption = "Simulation on True Percentage is 0.4 and 0.6") %>%
  kable_styling(full_width = F, position = "c")
{% endhighlight %}

As we can see from the simulation result, when the sample sizes are small, t-test is easier to reject the null hypothesis; while when the sample sizes are big enough in both groups, the test results from those two tests tend to be same. And since the Chi-squared test has more power than the approximated t-test (hope we would talk about "power" in future), we still recommend using Chi-squared test in this case.
