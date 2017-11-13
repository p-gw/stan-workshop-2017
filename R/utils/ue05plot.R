library(data.table)
library(ggplot2)

d <- fread("data/8schools.csv")

p <- ggplot(d, aes(x = school, y = treatment_effect, ymin = treatment_effect - sd, ymax = treatment_effect + sd)) +
  geom_linerange(size = 2, colour = "#78909C") +
  geom_point(size = 3, colour = "#455A64") +
  theme_minimal()

png("../Präsentation/images/05_8schools.png", width = 7, height = 4, units = "in", res = 200)
print(p)
dev.off()
