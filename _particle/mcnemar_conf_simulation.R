

sim_bin_mcnemar <- function(trial, theta, N){
  bin1 <- rbinom(N, trial, theta)
  bin2 <- trial - bin1
  data.frame(a = bin1, b = bin2) %>% 
    rowwise() %>% 
    mutate(b_p = binom.test(a, (a+b))$p.value,
           m_p = mcnemar.test(matrix(c(1,a,b,1), nrow = 2), 
                              correct = F)$p.value) %>% 
    ungroup() %>% 
    mutate(pct_binomial = sum(b_p < 0.05)/n(),
              pct_mcnemar = sum(m_p < 0.05)/n(),
              diff = abs(b_p - m_p))
}


sim_odds <- function(trial, theta, N){
  bin1 <- rbinom(N, trial, theta)
  bin2 <- trial - bin1
  true_odds <- theta/(1 - theta)
  
  output <- data.frame(a = bin1, b = bin2, 
             true_odds = true_odds) %>% 
    rowwise() %>% 
    mutate(estimated_odds = a/b,
           approx_l = exp(log(estimated_odds) - qnorm(0.975) * sqrt(1/a + 1/b)),
           approx_u = exp(log(estimated_odds) + qnorm(0.975) * sqrt(1/a + 1/b)),
           exact_l = mcnemar.exact(matrix(c(1,b,a,1), nrow = 2))$conf.int[1],
           exact_u = mcnemar.exact(matrix(c(1,b,a,1), nrow = 2))$conf.int[2],
           within_approx = (true_odds >= approx_l) & (true_odds <= approx_u),
           within_exact = (true_odds >= exact_l) & (true_odds <= exact_u)) %>% 
    ungroup() %>% 
    filter(!(estimated_odds %in% c(0, Inf))) %>% 
    summarise(effective_pct = n()/N,
              # approx_conf = mean(approx_u - approx_l),
              # exact_conf = mean(exact_u - exact_l),
              approx_cover = mean(within_approx),
              exact_cover = mean(within_exact))
  print(trial)
  return(list("approx_cover" = output[["approx_cover"]],
              "exact_cover" = output[["exact_cover"]]))
}


data.frame(trial = 2:100) %>% 
  rowwise() %>% 
  mutate(approx_cover = (sim_odds(trial, 0.5, 1000))$approx_cover,
         exact_cover = (sim_odds(trial, 0.5, 1000))$exact_cover) %>% 
  ungroup() %>% 
  gather(cat, val, approx_cover, exact_cover) %>% 
  ggplot(aes(x = trial, y = val, colour = cat)) +
  geom_line()

