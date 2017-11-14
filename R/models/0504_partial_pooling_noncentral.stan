data {
  int<lower=1> N;
  real y[N];
  real<lower=0> sigma[N];
}
parameters {
  vector[N] theta_norm;
  real mu;
  real<lower=0> tau;
}
transformed parameters {
  vector[N] theta;
  theta = theta_norm*tau + mu;
}
model {
  theta_norm ~ normal(0, 1);
  tau ~ normal(0, 20);
  y ~ normal(theta, sigma);
}
generated quantities {
  real y_rep[N];

  for (i in 1:N)
    y_rep[i] = normal_rng(theta[i], sigma[i]);
}
