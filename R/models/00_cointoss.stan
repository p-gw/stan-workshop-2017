data {
  int<lower=1> N;
  int<lower=0, upper=1> y[N];
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  for (i in 1:N)
    y[i] ~ bernoulli(theta);
}
