library(rstan)
library(ggplot2)
library(scales)

source("examples/05_hierarchical_models.R")

# pathological traceplot
t1 <- traceplot(fit_ppc, pars = "tau") +
  scale_y_log10() +
  labs(y = "log(tau)") +
  scale_colour_manual(values = c("#4CAF50", "#FFC107", "#03A9F4", "#FF5722"), guide = "none") +
  theme_minimal()

t2 <- traceplot(fit_ppnc, pars = "tau") +
  scale_y_log10() +
  labs(y = "log(tau)") +
  scale_colour_manual(values = c("#4CAF50", "#FFC107", "#03A9F4", "#FF5722"), guide = "none") +
  theme_minimal()


png("../Präsentation/images/traceplot_1.png", width = 8, height = 1.5, units = "in", res = 200)
print(t1)
dev.off()

png("../Präsentation/images/traceplot_2.png", width = 8, height = 1.5, units = "in", res = 200)
print(t2)
dev.off()
