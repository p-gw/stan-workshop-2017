data {
  int<lower=1> N;
  real<lower=0> lambda;
  real<lower=0> age[N];
  real<lower=0> height[N];

  // PPD
  int<lower=1> N_tilde;
  real<lower=0> age_tilde[N_tilde];

}
transformed data {
  real std_age[N];
  real std_age_tilde[N_tilde];

  for (i in 1:N) {
    std_age[i] = (age[i] - mean(age))/sd(age);
  }
  for (i in 1:N_tilde) {
    std_age_tilde[i] = (age_tilde[i] - mean(age))/sd(age);
  }
}
parameters {
  real alpha;
  vector[3] beta;
  real<lower=0> sigma;
}
transformed parameters {
  real mu[N];

  for (i in 1:N) {
    mu[i] = alpha + std_age[i]*beta[1] + (std_age[i]^2)*beta[2] + (std_age[i]^3)*beta[3];
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
    real mu_tilde = alpha + std_age_tilde[i]*beta[1] + (std_age_tilde[i]^2)*beta[2] + (std_age_tilde[i]^3)*beta[3];
    y_tilde[i] = normal_rng(mu_tilde, sigma);
  }
}
