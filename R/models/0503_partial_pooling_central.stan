data {
  int<lower=1> N;
  real y[N];
  real<lower=0> sigma[N];
}
parameters {
  real theta[N];
  real mu;
  real<lower=0> tau;
}
model {
  theta ~ normal(mu, tau);
  y ~ normal(theta, sigma);
}
generated quantities {
  real y_rep[N];

  for (i in 1:N)
    y_rep[i] = normal_rng(theta[i], sigma[i]);
}
