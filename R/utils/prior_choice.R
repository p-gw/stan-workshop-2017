library(data.table)
library(ggplot2)

d <- data.table("x" = seq(-12.5, 12.5, length.out = 200))

d[, "Cauchy(0, 2.5)" := dcauchy(x, 0, 2.5)]
d[, "t(3, 0, 2.5)" := metRology::dt.scaled(x, 3, 0, 2.5)]
d[, "Normal(0, 2.5)" := dnorm(x, 0, 2.5)]

d <- melt(d, id.vars = "x")

ggplot(d, aes(x = x, y = value, group = variable)) +
  geom_path(aes(colour = variable), size = 1) +
#  facet_wrap(~variable) +
#  scale_colour_discrete(guide = "none") +
  theme_minimal()
