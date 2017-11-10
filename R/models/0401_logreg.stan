data {
  int<lower=1> N;
  int<lower=0,upper=1> female[N];
  int<lower=0,upper=2> pclass[N];
  real<lower=0> age[N];

  int<lower=0,upper=1> y[N];

  // ppd
  int<lower=1> N_tilde;
  int<lower=0,upper=1> female_tilde[N_tilde];
  int<lower=0,upper=2> pclass_tilde[N_tilde];
  real<lower=0> age_tilde[N_tilde];
}
transformed data {
  int<lower=0,upper=3> int1[N];
  real<lower=0> int2[N];

  int<lower=0,upper=3> int1_tilde[N_tilde];
  real<lower=0> int2_tilde[N_tilde];

  for (i in 1:N) {
    int1[i] = female[i]*pclass[i];
    int2[i] = age[i]*pclass[i];
  }
  for (i in 1:N_tilde) {
    int1_tilde[i] = female_tilde[i]*pclass_tilde[i];
    int2_tilde[i] = age_tilde[i]*pclass_tilde[i];
  }
}
parameters {
  real alpha;
  vector[5] beta;
}
transformed parameters {
  vector[N] eta;

  for (i in 1:N)
    eta[i] = alpha + beta[1]*female[i] + beta[2]*pclass[i] + beta[3]*age[i] + beta[4]*int1[i] + beta[5]*int2[i];
}
model {
  alpha ~ normal(0, 10);
  beta ~ normal(0, 2);

  y ~ bernoulli_logit(eta);
}
generated quantities {
  real<lower=0,upper=1> p_tilde[N_tilde];

  for (i in 1:N_tilde)
    p_tilde[i] = inv_logit(alpha + beta[1]*female_tilde[i] + beta[2]*pclass_tilde[i] + beta[3]*age_tilde[i] + beta[4]*int1_tilde[i] + beta[5]*int2_tilde[i]);
}
