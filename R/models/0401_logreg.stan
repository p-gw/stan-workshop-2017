data {
  int<lower=1> N;
  int<lower=0,upper=1> female[N];
  int<lower=1,upper=3> pclass[N];
  real<lower=0> age[N];

  int<lower=0,upper=1> y[N];

  // ppd
  int<lower=1> N_tilde;
  int<lower=0,upper=1> female_tilde[N_tilde];
  int<lower=1,upper=3> pclass_tilde[N_tilde];
  real<lower=0> age_tilde[N_tilde];
}
parameters {
  real alpha;
  vector[1] beta;

  vector[3] a_class;
  real<lower=0> sigma_class;

  vector[3] female_class;
  real<lower=0> sigma_female;
}
transformed parameters {
  vector[N] eta;

  for (i in 1:N)
    eta[i] = alpha + a_class[pclass[i]] + female_class[pclass[i]]*female[i] + beta[1]*age[i];
}
model {
  alpha ~ normal(0, 10);
  a_class ~ normal(0, sigma_class);
  sigma_class ~ cauchy(0, 2);
  female_class ~ normal(0, sigma_female);
  sigma_female ~ cauchy(0, 2);

  beta ~ normal(0, 2);

  y ~ bernoulli_logit(eta);
}
generated quantities {
  real<lower=0,upper=1> p_tilde[N_tilde];

  for (i in 1:N_tilde) {
    p_tilde[i] = inv_logit(alpha + a_class[pclass_tilde[i]] + female_class[pclass_tilde[i]]*female_tilde[i] + beta[1]*age_tilde[i]);
  }
}
