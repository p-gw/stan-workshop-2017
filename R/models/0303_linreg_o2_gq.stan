data {
  int<lower=1> N;
  real<lower=0> lambda;
  real weight[N];
  real<lower=0> height[N];

  // posterior predictive simulations
  int<lower=1> N_tilde;
  real x_tilde[N_tilde];
}
parameters {
  real alpha;
  vector[2] beta;
  real<lower=0> sigma;
}
transformed parameters {
  real mu[N];

  for (i in 1:N) {
    mu[i] = alpha + weight[i]*beta[1] + (weight[i]^2)*beta[2];
  }
}
model {
  alpha ~ normal(150, 100);
  beta ~ normal(0, lambda);

  for (i in 1:N)
    height[i] ~ normal(mu[i], sigma);
}
generated quantities {
  real y_tilde[N_tilde];

  for (i in 1:N_tilde) {
    real mu_tilde = alpha + x_tilde[i]*beta[1] + (x_tilde[i]^2)*beta[2];
    y_tilde[i] = normal_rng(mu_tilde, sigma);
  }
}
