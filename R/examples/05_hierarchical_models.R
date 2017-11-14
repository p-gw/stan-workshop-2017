# Pakete laden
library(ggplot2)
library(rstan)
library(data.table)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Daten laden
d <- fread("data/8schools.csv")

# Stan Daten
stan_data <- list(
  "N"   = nrow(d),
  "y"   = d[, treatment_effect],
  "sigma"  = d[, sd]
)

# complete pooling model
fit_cp <- stan("models/0501_complete_pooling.stan", data = stan_data)

hdi <- c(0.1, 0.9)

y_rep_cp <- extract(fit_cp, "y_rep")$y_rep
y_rep_cp <- apply(y_rep_cp, 2, function(x) c(mean(x), quantile(x, hdi)))
y_rep_cp <- data.table(
  d[, school],
  t(y_rep_cp)
)

names(y_rep_cp) <- c("school", "mean", "lwr", "upr")

p <- ggplot(d, aes(x = school, y = treatment_effect)) +
  geom_point() +
  theme_minimal()

p_cp <- p + geom_linerange(data = y_rep_cp, aes(x = school, y = mean, ymin = lwr, ymax = upr))

# no pooling model
fit_np <- stan("models/0502_no_pooling.stan", data = stan_data)

y_rep_np <- extract(fit_np, "y_rep")$y_rep
y_rep_np <- apply(y_rep_np, 2, function(x) c(mean(x), quantile(x, hdi)))
y_rep_np <- data.table(
  d[, school],
  t(y_rep_np)
)

names(y_rep_np) <- c("school", "mean", "lwr", "upr")

p_np <- p + geom_linerange(data = y_rep_np, aes(x = school, y = mean, ymin = lwr, ymax = upr))

# partial pooling model (centered)
fit_ppc <- stan("models/0503_partial_pooling_central.stan", data = stan_data)

y_rep_ppc <- extract(fit_ppc, "y_rep")$y_rep
y_rep_ppc <- apply(y_rep_ppc, 2, function(x) c(mean(x), quantile(x, hdi)))
y_rep_ppc <- data.table(
  d[, school],
  t(y_rep_ppc)
)

names(y_rep_ppc) <- c("school", "mean", "lwr", "upr")

p_ppc <- p + geom_linerange(data = y_rep_ppc, aes(x = school, y = mean, ymin = lwr, ymax = upr))

# partial pooling model (non-centered)
fit_ppnc <- stan("models/0504_partial_pooling_noncentral.stan", data = stan_data)

y_rep_ppnc <- extract(fit_ppnc, "y_rep")$y_rep
y_rep_ppnc <- apply(y_rep_ppnc, 2, function(x) c(mean(x), quantile(x, hdi)))
y_rep_ppnc <- data.table(
  d[, school],
  t(y_rep_ppnc)
)

names(y_rep_ppnc) <- c("school", "mean", "lwr", "upr")

p_ppnc <- p + geom_linerange(data = y_rep_ppnc, aes(x = school, y = mean, ymin = lwr, ymax = upr))
