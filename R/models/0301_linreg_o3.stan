data {
  int<lower=1> N;
  real<lower=0> lambda;
  real weight[N];
  real<lower=0> height[N];
}
parameters {
  real alpha;
  vector[3] beta;
  real<lower=0> sigma;
}
transformed parameters {
  real mu[N];

  for (i in 1:N) {
    mu[i] = alpha + weight[i]*beta[1] + (weight[i]^2)*beta[2] + (weight[i]^3)*beta[3];
  }
}
model {
  alpha ~ normal(150, 100);
  beta ~ normal(0, lambda);

  for (i in 1:N)
    height[i] ~ normal(mu[i], sigma);
}
