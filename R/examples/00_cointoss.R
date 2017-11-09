# Pakete laden
library(rstan)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Daten generieren
set.seed(678)
N <- 100
true_theta <- 0.5
y <- rbinom(N, 1, true_theta)

# Modell kompilieren
stan_model <- stan_model("models/00_cointoss.stan")

# Daten aufbereiten
stan_data <- list(
  "N" = N,
  "y" = y
)

# Modell berechnen
stan_fit <- sampling(object = stan_model, data = stan_data)

# geschätzte Werte ausgeben
print(stan_fit)
