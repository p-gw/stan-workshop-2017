data {
  int<lower=1> N;
  int<lower=1> k;
  matrix[N, k] X;
  int<lower=0,upper=1> y[N];

  // ppd
  int<lower=1> N_tilde;
  matrix[N_tilde, k] X_tilde;
}
parameters {
  vector[k] beta;
}
model {
  beta[1] ~ normal(0, 3);

  for (i in 2:k)
    beta[i] ~ normal(0, 1);

  y ~ bernoulli_logit(X*beta);
}
generated quantities {
  real<lower=0,upper=1> p_tilde[N_tilde];
  int<lower=0,upper=1> y_tilde[N_tilde];

  for (i in 1:N_tilde) {
    p_tilde[i] = inv_logit(X_tilde[i, ]*beta);
    y_tilde[i] = bernoulli_rng(p_tilde[i]);
  }
}
