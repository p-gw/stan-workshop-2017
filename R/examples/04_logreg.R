# Pakete laden
library(data.table)
library(ggplot2)
library(rstan)

# Multithreading aktivieren
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Datensätze laden
d_train <- fread("data/titanic_training_new.csv")
d_test  <- fread("data/titanic_test_new.csv")

# Stan Datensatz
stan_data <- list(
  "N" = nrow(d_train),
  "y" = d_train$survived,
  "X" = model.matrix(survived ~ factor(pclass)*age + factor(pclass)*female, data = d_train),
  "N_tilde" = nrow(d_test),
  "X_tilde" = model.matrix( ~ factor(pclass)*age + factor(pclass)*female, data = d_test)
)

stan_data$k <- ncol(stan_data$X)

# Model fitten
stan_fit <- stan("models/0401_logreg.stan", data = stan_data)

# PPD
## Überlebenswahrscheinlichkeiten
hdi <- c(0.25, 0.75)

p_pred <- extract(stan_fit, "p_tilde")$p_tilde
p_pred <- apply(p_pred, 2, function(x) c(mean(x), quantile(x, hdi)))
p_pred <- data.table(t(p_pred), 1:ncol(p_pred))

names(p_pred) <- c("mean", "lwr", "upr", "ID")

p_pred[order(mean, decreasing = FALSE), "rank" := 1:.N]  # Sortierung für Plot

### Darstellung
p_surv <- ggplot(p_pred, aes(x = rank, ymin = lwr, ymax = upr)) +
  geom_linerange(size = 1, colour = "#6D4C41") +
  coord_flip() +
  theme_minimal()

print(p_surv)

## Klassifizierung
y_pred <- extract(stan_fit, "y_tilde")$y_tilde

p_pred[, "prediction" := apply(y_pred, 2, median)]
p_pred[, "prediction" := factor(prediction)]

p_class <- ggplot(p_pred, aes(x = rank, ymin = lwr, ymax = upr)) +
  geom_linerange(size = 1, aes(colour = prediction)) +
  scale_colour_manual(values = c("#FF5722", "#2196F3")) +
  coord_flip() +
  theme_minimal() +
  theme(legend.justification = c(0, 1), legend.position = c(0, 1))

print(p_class)

# Zusatz: Abgleich mit Beobachtungen
d_val <- fread("data/titanic_solution.csv")
