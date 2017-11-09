# Pakete laden
library(rstan)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# 1.
N <- 100
mu <- 100
sigma <- 15

y <- rnorm(N, mu, sigma)

# 2.
# siehe models/01_nv.stan

# 3.
nv_mod <- stan_model("models/01_nv.stan")

nv_data_n100 <- list(
  "N" = N,
  "y" = y
)

nv_fit_n100 <- sampling(nv_mod, data = nv_data_n100)
print(nv_fit_n100)

# 4.
# N << 100
N <- 25

y <- rnorm(N, mu, sigma)

nv_data_n25 <- list(
  "N" = N,
  "y" = y
)

nv_fit_n25 <- sampling(nv_mod, data = nv_data_n25)

# N >> 100
N <- 800

y <- rnorm(N, mu, sigma)

nv_data_n800 <- list(
  "N" = N,
  "y" = y
)

nv_fit_n800 <- sampling(nv_mod, data = nv_data_n800)

print(nv_fit_n25)
print(nv_fit_n800)
