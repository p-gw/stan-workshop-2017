# Pakete laden
library(rstan)
library(ggplot2)
library(data.table)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Daten laden
d <- read.csv("data/heights2.csv")

stan_data <- list(
  "N"       = nrow(d),
  "lambda"  = 10000,
  "weight"  = scale(d$weight)[,1],      # hier standardisieren
  "height"  = d$height
)

# 03 (A)
# 1.
stan_fit_o2 <- stan("models/0301_linreg_o2.stan", data = stan_data)
stan_fit_o3 <- stan("models/0301_linreg_o3.stan", data = stan_data)

# 2.
stan_data_general <- list(
  "N" = nrow(d),
  "lambda" = 100,
  "y" = d$height,
  "X" = model.matrix(height ~ poly(weight, 3), data = d)  # model.matrix() kann beliebig gewählt werden
)

stan_data_general$N_beta <- ncol(stan_data_general$X)

stan_fit_general <- stan("models/0302_linreg.stan", data = stan_data_general)

# 3.
## posterior samples
n_samp <- 40
samples <- sample(4000, n_samp)

posterior_samples <- extract(stan_fit_o2)

pd <- data.frame(
  "sample"  = samples,
  "alpha"   = posterior_samples$alpha[samples],
  "o1"     = posterior_samples$beta[samples, 1],
  "o2"      = posterior_samples$beta[samples, 2]
)

lines <- data.frame(
  "x" = seq(min(scale(d$weight)), max(scale(d$weight)), length.out = 100)
)

for (i in 1:length(samples)) {
  lines[, paste0("y", i)] <- pd$alpha[i] + lines$x*pd$o1[i] + (lines$x^2)*pd$o2[i]
}

lines <- melt(lines, id.vars = "x")

p <- ggplot(data = d, aes(x = scale(weight), y = height)) +
  geom_point(shape = 21, colour = "#424242") +
  theme_minimal()

p_sim <- p + geom_path(data = lines, aes(x = x, y = value, group = variable), colour = "#00BCD4", alpha = 0.4)

print(p_sim)

## posterior quantiles (Verwendung von mu)
hdi <- c(.1, .9)

pred <- posterior_samples$mu
pred <- apply(pred, 2, function(x) c(mean(x), quantile(x, hdi)))

pd_quant <- data.frame(
  t(pred),
  "weight" = stan_data$weight
)

names(pd_quant) <- c("mean", "lwr", "upr", "weight")

p_quant <- p + geom_ribbon(data = pd_quant, aes(x = weight, ymin = lwr, y = mean, ymax = upr), fill = "#BDBDBD", alpha = 0.6) +
  geom_line(data = pd_quant, aes(x = weight, y = mean), colour = "#00BCD4", size = 1)


# 03 (B)
# 1.
weight_tilde <- 3   # = +3SD vom Mittelwert

y_hat <- posterior_samples$alpha +
  posterior_samples$beta[, 1]*weight_tilde +
  posterior_samples$beta[, 2]*weight_tilde^2

y_tilde <- rnorm(length(y_hat), y_hat, posterior_samples$sigma)

# 2.
N_tilde <- 200
x_tilde <- seq(min(stan_data$weight), max(stan_data$weight), length.out = N_tilde)

# 3.
stan_data$N_tilde <- N_tilde
stan_data$x_tilde <- x_tilde

stan_fit_o2_gq <- stan("models/0303_linreg_o2_gq.stan", data = stan_data, iter = 10000)

# 4.
ppd_samples <- extract(stan_fit_o2_gq, "y_tilde")$y_tilde

ppd <- apply(ppd_samples, 2, function(x) c(mean(x), quantile(x, hdi)))

ppd <- data.frame(
  t(ppd),
  "weight" = stan_data$x_tilde
)

names(ppd) <- c("mean", "lwr", "upr", "weight")

p_ppd <- p_quant + geom_ribbon(data = ppd, aes(x = weight, ymin = lwr, y = mean, ymax = upr), fill = "#BDBDBD", alpha = 0.3) +
  geom_line(data = ppd, aes(x = weight, y = mean), colour = "#00BCD4", size = 1)
