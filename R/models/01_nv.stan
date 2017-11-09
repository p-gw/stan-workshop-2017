data {
  int<lower=1> N;
  real y[N];
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  for (i in 1:N)
    y[i] ~ normal(mu, sigma);
}
