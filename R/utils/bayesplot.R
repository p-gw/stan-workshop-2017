library(data.table)
library(ggplot2)

d <- data.table("x" = seq(0, 1, length.out = 200))

d[, "prior" := dbeta(x, 1, 6)]
d[, "likelihood" := dbinom(4, 6, x)]

d[, "prior" := prior/sum(prior)]
d[, "likelihood" := likelihood/sum(likelihood)]

d[, "posterior" := prior*likelihood]
d[, "posterior" := posterior/sum(posterior)]

d <- melt(d, id.vars = "x")

p <- ggplot(d, aes(x = x, y = value, group = variable)) +
  geom_path(aes(colour = variable), size = 1) +
  scale_colour_manual(values = c("#607D8B", "#FFB300", "#03A9F4"), name = "") +
  theme_minimal() +
  labs(x = "probability", y = "density") +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))


png("../Präsentation/images/bayesplot.png", width = 6, height = 4, units = "in", res = 200)
print(p)
dev.off()
