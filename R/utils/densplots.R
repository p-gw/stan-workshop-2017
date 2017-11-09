library(data.table)

# Uniform
d <- data.table("x" = -100:100, y = 1/201)

p_unif <- ggplot(d, aes(x = x, y = y)) +
  geom_line(colour = "#FF5722", size = 2) +
  scale_y_continuous(limits = c(0, .01)) +
  theme_void()

png("../Präsentation/images/unif_prior.png", width = 7, height = 3, units = "in", res = 200)
print(p_unif)
dev.off()

# Normal
d <- data.table("x" = seq(-3, 3, length.out = 1000))
d[, "y" := dnorm(x)]

p_norm <- ggplot(d, aes(x = x, y = y)) +
  geom_line(colour = "#FF5722", size = 2) +
  theme_void()

png("../Präsentation/images/normal_prior.png", width = 7, height = 3, units = "in", res = 200)
print(p_norm)
dev.off()

# Laplace
d <- data.table("x" = seq(-6, 6, length.out = 1000))
d[, "y" := rmutil::dlaplace(x, 0, 2)]

p_laplace <- ggplot(d, aes(x = x, y = y)) +
  geom_line(colour = "#FF5722", size = 2) +
  theme_void()

png("../Präsentation/images/laplace_prior.png", width = 7, height = 3, units = "in", res = 200)
print(p_laplace)
dev.off()
