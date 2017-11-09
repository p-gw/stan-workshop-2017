data {
  int<lower=1> N;
  real<lower=0> lambda;
  real<lower=0> weight[N];
  real<lower=0> height[N];
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(150, 100);
  beta ~ normal(0, lambda);

  for (i in 1:N)
    height[i] ~ normal(alpha + weight[i]*beta, sigma);
}
