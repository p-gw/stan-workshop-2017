data {
  int<lower=1> N;
  int<lower=1> N_beta;
  real<lower=0> lambda;

  matrix[N, N_beta] X;
  vector[N] y;
}
parameters {
  vector[N_beta] beta;
  real<lower=0> sigma;
}
transformed parameters {
  vector[N] mu;

  mu = X*beta;
}
model {
  beta ~ normal(0, lambda);

  y ~ normal(mu, sigma);
}
