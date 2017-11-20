library(mvtnorm)
library(data.table)
library(ggplot2)

# target MVNormal(0, I)

chains <- 4
iterations <- 2000
true_mu <- c(0, 0)
true_sigma <- diag(2)

starting_values <- function(mu, sigma, chains) {
  rmvnorm(chains, mu, sigma)
}

proposal_values <- function(mu, proposal_width = 0.25^2) {
  rmvnorm(1, mu, proposal_width*diag(2))
}



# MCMC simulation
y <- rmvnorm(100, true_mu, true_sigma)

# s <- starting_values(true_mu, 4*true_sigma, chains)
s <- expand.grid(c(-3, 3), c(-3, 3))

samples <- list()
samples[[1]] <- s

for (t in 2:(iterations + 1)) {
  proposal <- t(apply(samples[[(t - 1)]], 1, function(x) proposal_values(x)))
  r <- sapply(1:chains, function(x) dmvnorm(proposal[x, ], true_mu, true_sigma)/dmvnorm(samples[[(t - 1)]][x, ], true_mu, true_sigma))
  r <- ifelse(r > 1, 1, r)
  new_theta <- as.logical(rbinom(length(r), 1, prob = r))

  samples[[t]] <- samples[[(t - 1)]]
  for (i in 1:chains) {
    if (new_theta[i]) { samples[[t]][i,] <- proposal[i, ] }
  }
}

samples <- lapply(samples, function(x) x <- cbind(x, 1:4))
samples <- do.call(rbind, samples)

samples <- data.table(samples)
names(samples) <- c("x", "y", "chain")
samples[, "chain" := factor(chain)]

p1 <- ggplot(samples[1:(40*chains)], aes(x = x, y = y, group = chain)) +
  geom_path(aes(colour = chain)) +
  geom_point(data = samples[1:chains], aes(x = x, y = y, colour = chain), size = 2) +
  ggtitle("Traceplot", subtitle = "Iterationen 1-40") +
  scale_colour_manual(values = c("#4CAF50", "#FFC107", "#03A9F4", "#FF5722"), guide = "none") +
  scale_x_continuous(limits = c(-4, 4)) +
  scale_y_continuous(limits = c(-4, 4)) +
  coord_fixed(1) +
  theme_minimal()

print(p1)

p2 <- ggplot(samples[1:(1000*chains)], aes(x = x, y = y, group = chain)) +
  geom_path(aes(colour = chain)) +
  geom_point(data = samples[1:chains], aes(x = x, y = y, colour = chain), size = 2) +
  ggtitle("Traceplot", subtitle = "Iterationen 1-1000") +
  scale_colour_manual(values = c("#4CAF50", "#FFC107", "#03A9F4", "#FF5722"), guide = "none") +
  scale_x_continuous(limits = c(-4, 4)) +
  scale_y_continuous(limits = c(-4, 4)) +
  coord_fixed(1) +
  theme_minimal()

p3 <- ggplot(samples[(iterations*chains/2):.N], aes(x = x, y = y, group = chain)) +
  geom_jitter(aes(x = x, y = y, colour = chain), alpha = 0.8, shape = ".") +
  ggtitle("Posterior Samples", "Iterationen 1001-2000") +
  scale_colour_manual(values = c("#4CAF50", "#FFC107", "#03A9F4", "#FF5722"), guide = "none") +
  scale_x_continuous(limits = c(-4, 4)) +
  scale_y_continuous(limits = c(-4, 4)) +
  coord_fixed(1) +
  theme_minimal()

png("../Präsentation/images/mh_algorithmus.png", width = 8, height = 3, units = "in", res = 200)
grid.arrange(p1, p2, p3, nrow = 1)
dev.off()
