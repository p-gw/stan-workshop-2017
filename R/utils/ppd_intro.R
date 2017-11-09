library(data.table)
library(ggplot2)

source("examples/02_linreg.R")

# posterior für weight = x_tilde
x_tilde <- 45

y <- posterior_samples$alpha + posterior_samples$beta*x_tilde

p_post <- ggplot(data.table("mu" = y), aes(x = mu)) +
  geom_density(colour = "#f44336", fill = "#e57373", alpha = 0.2, adjust = 1/3) +
#  geom_line(stat = "density", colour = "#F44336", adjust = 1/3, size = 1, trim = TRUE) +
  ggtitle("posterior distribution", subtitle = paste0("weight = ", x_tilde)) +
  xlab(expression(mu)) +
  theme_minimal()


# ppd für weight = x_tilde
y_tilde <- rnorm(
  nrow(posterior_samples$alpha),
  y,
  posterior_samples$sigma
)

p_ppd <- ggplot(data.table("y_tilde" = y_tilde), aes(x = y_tilde)) +
  geom_density(colour = "#2196F3", fill = "#64B5F6", alpha = 0.2, adjust = 1/3, trim = FALSE) +
#  geom_line(stat = "density", colour = "#2196F3", adjust = 1/3, size = 1) +
  ggtitle("posterior predictive distribution", subtitle = paste0("weight = ", x_tilde)) +
  xlab(expression(tilde(y))) +
  theme_minimal()

lims <- c(min(y_tilde), max(y_tilde))

png("../Präsentation/images/ppd_intro_posterior.png", width = 4, height = 4, units = "in", res = 200)
print(p_post + scale_x_continuous(limits = lims))
dev.off()

png("../Präsentation/images/ppd_intro_ppd.png", width = 4, height = 4, units = "in", res = 200)
print(p_ppd + scale_x_continuous(limits = lims))
dev.off()
