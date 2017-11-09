# Pakete laden
library(rstan)
library(ggplot2)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Daten laden
d <- read.csv("data/heights.csv")

# 1.
ols_fit <- lm(height ~ weight, data = d)
summary(ols_fit)

# 2.
stan_data <- list(
  "N"      = nrow(d),
  "height" = d$height,
  "weight" = d$weight
)

unif_fit <- stan(file = "models/0201_linreg.stan", data = stan_data)

# 3.
stan_data$lambda <- 1
nv_fit_l1 <- stan(file = "models/0202_linreg.stan", data = stan_data)

stan_data$lambda <- 0.1
nv_fit_l01 <- stan(file = "models/0202_linreg.stan", data = stan_data)

stan_data$lambda <- 100
nv_fit_l100 <- stan(file = "models/0202_linreg.stan", data = stan_data)

# 4.
n_samp <- 40

posterior_samples <- extract(nv_fit_l1)

samples <- sample(4000, n_samp)

pd_sim <- data.frame(
  "sample"  = samples,
  "alpha"   = posterior_samples$alpha[samples],
  "beta"    = posterior_samples$beta[samples]
)

p <- ggplot(data = d, aes(x = weight, y = height)) +
  geom_point(shape = 21, colour = "#424242") +
  theme_minimal()

p_sim <- p + geom_abline(data = pd_sim, aes(intercept = alpha, slope = beta, group = sample), colour = "#E91E63", alpha = 0.6)

print(p_sim)

# 5.
hdi <- c(0.05, 0.95)

x <- seq(min(d$weight), max(d$weight), length.out = 200)

pred <- sapply(x, function(x) posterior_samples$alpha + posterior_samples$beta*x)
pred <- apply(pred, 2, function(x) c(mean(x), quantile(x, probs = hdi)))

pd_quant <- data.frame(
  t(pred),
  "weight" = x
)

names(pd_quant)[1:3] <- c("mean", "lwr", "upr")

p_quant <- p +
  geom_ribbon(data = pd_quant, aes(x = weight, y = mean, ymin = lwr, ymax = upr), alpha = 0.6, fill = "#BDBDBD") +
  geom_line(data = pd_quant, aes(x = weight, y = mean), size = 1, colour = "#E91E63")

print(p_quant)
