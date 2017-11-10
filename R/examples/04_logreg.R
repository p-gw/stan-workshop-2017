# Pakete laden
library(data.table)
library(ggplot2)
library(rstan)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Datensätze laden
d_train <- fread("data/titanic_training.csv")
d_test  <- fread("data/titanic_test.csv")

# Stan Datensatz
stan_data <- list(
  "N"      = nrow(d_train),
  "y"      = d_train$survived,
  "pclass"  = d_train$class - 1,
  "female" = d_train$female,
  "age"    = d_train$age
)

X_tilde <- expand.grid(seq(0, 80, length.out = 100), 0:1, 0:2)

stan_data$N_tilde <- nrow(X_tilde)
stan_data$age_tilde <- X_tilde[, 1]
stan_data$female_tilde <- X_tilde[, 2]
stan_data$pclass_tilde <- X_tilde[, 3]

# Model fitten
stan_fit <- stan("models/0401_logreg.stan", data = stan_data)

# Darstellung
n_samp <- 40
samples <- sample(4000, n_samp)

posterior_samples <- extract(stan_fit)

pd <- data.table(
  "sample" = samples,
  "alpha" = posterior_samples$alpha[samples],
  "b_age" = posterior_samples$beta[samples, 3]
)

fitted <- data.table(
  "x_tilde" = seq(0, 80, length.out = 200)
)

for (i in 1:length(samples)) {
  fitted[, paste0("y_hat", i)] <- plogis(pd$alpha[i] + pd$b_age[i]*fitted$x_tilde)
}

fitted <- melt(fitted, id.vars = "x_tilde")

p <- ggplot(data = d_train, aes(x = age, y = survived)) +
  geom_jitter(shape = 21, colour = "#424242", height = 0, width = 1/3) +
  theme_minimal()

p_sim <- p + geom_path(data = fitted, aes(x = x_tilde, y = value, group = variable), colour = "#9C27B0")


#
hdi <- c(.1, .9)

pred <- posterior_samples$p_tilde
pred <- apply(pred, 2, function(x) c(mean(x), quantile(x, hdi)))

pd_quant <- data.frame(
  t(pred),
  "age" = stan_data$age_tilde,
  "female" = stan_data$female_tilde,
  "class" = stan_data$pclass_tilde
)

names(pd_quant) <- c("mean", "lwr", "upr", "age", "female", "class")

p_quant <- p + geom_ribbon(data = pd_quant, aes(x = age, ymin = lwr, ymax = upr, y = mean), fill = "#BDBDBD", alpha = 0.6) +
  geom_line(data = pd_quant, aes(x = age, y = mean), colour = "#00BCD4", size = 1) + facet_grid(female ~ class)
