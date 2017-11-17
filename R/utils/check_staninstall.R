check_staninstall <- function() {
  print("Überprüfe Installation...")
  if (!require(rstan)) { stop("rstan ist nicht installiert!") }

  testmod <- "
    data { }
    parameters { }
    model { }
    generated quantities {
      real x;
      x = normal_rng(0, 1);
    }
  "

  print("Überprüfe Kompilierung...")
  stan_model <- stan_model(model_code = testmod)

  print("Überprüfe Sampling...")
  res <- sampling(stan_model, chains = 1, iter = 400, algorithm = "Fixed_param")

  print("Überprüfe Extraktion...")
  sim <- extract(res, "x")$x

  return(sim)
}
