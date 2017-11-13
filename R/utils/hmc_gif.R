library(rstan)
library(data.table)

mod <- "
data {
  int<lower=1> N;
  real y[N];
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  y ~ normal(mu, sigma);
}
"

mod <- stan_model(model_code =  mod)

N <- 30
y <- rnorm(N, 0, 1)

stan_data <- list(
  "N" = N,
  "y" = y
)

sampling()
ps <- extract(nv_fit_n100, "lp__", include = FALSE, permuted = FALSE, inc_warmup = TRUE)

ps_c1 <- data.table(ps[,1,], "chain" = 1, "iteration" = 1:2000)
ps_c2 <- data.table(ps[,2,], "chain" = 2, "iteration" = 1:2000)
ps_c3 <- data.table(ps[,3,], "chain" = 3, "iteration" = 1:2000)

pd <- rbind(ps_c1, ps_c2, ps_c3)
pd[, "chain" := factor(chain)]

p <- ggplot(pd[iteration %in% 3:100], aes(x = mu, y = sigma)) +
  geom_path(aes(cumulative = TRUE, colour = chain, frame = iteration)) +
  geom_point(data = pd[iteration == 1], aes(colour = chain)) +
  labs(x = expression(mu), y = expression(sigma)) +
  theme_minimal() +
  annotate("text", label = paste0("Iteration = ", "iteration"), x = -0.9, y = 1.75) +
  theme(legend.justification = c(1, 0), legend.position = c(1, 0))
