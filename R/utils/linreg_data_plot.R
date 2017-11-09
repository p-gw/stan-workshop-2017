library(data.table)
library(ggplot2)

d <- fread("data/Howell1.csv")

p <- ggplot(d, aes(x = weight, y = height)) +
  geom_point(aes(colour = age >= 18), shape = 21) +
  scale_colour_manual(values = c("#512DA8", "#00796B")) +
  annotate("text", label = paste0("N = ", nrow(d)), x = 5, y = 180) +
  theme_minimal() +
  theme(legend.justification = c(1, 0), legend.position = c(1, 0))

png("../Präsentation/images/linreg_data.png", width = 6, height = 4, units = "in", res = 200)
print(p)
dev.off()
