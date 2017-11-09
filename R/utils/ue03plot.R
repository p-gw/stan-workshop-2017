library(data.table)

d <- fread("data/heights2.csv")

p <- ggplot(d, aes(x = weight, y = height)) +
  geom_point(shape = 21, colour = "#424242") +
  geom_smooth(method = "lm", formula = y ~ x, colour = "#8BC34A", se = FALSE) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2, raw = T), colour = "#00BCD4", se = FALSE) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3, raw = T), colour = "#FF9800", se = FALSE) +
  theme_minimal()

png("../Präsentation/images/03_polyreg.png", width = 7, height = 4, units = "in", res = 200)
print(p)
dev.off()
  
