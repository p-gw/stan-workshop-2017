library(rstan)
library(data.table)

source("examples/01_nv.R")

ps <- extract(nv_fit_n100, "lp__", include = FALSE, permuted = FALSE, inc_warmup = TRUE)

ps_c1 <- data.table(ps[,1,], "chain" = 1, "iteration" = 1:2000)
ps_c2 <- data.table(ps[,2,], "chain" = 2, "iteration" = 1:2000)
ps_c3 <- data.table(ps[,3,], "chain" = 3, "iteration" = 1:2000)
ps_c4 <- data.table(ps[,4,], "chain" = 4, "iteration" = 1:2000)

pd <- rbind(ps_c1, ps_c2, ps_c3, ps_c4)
