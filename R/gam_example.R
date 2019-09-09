library(mgcv)
library(tidyverse)
library(cowplot)

mcycle <- MASS::mcycle


ggplot(data = mcycle, aes(x = times, y = accel)) +
  geom_point()



plot_mod <- function(df, k){
  mod <- gam(accel ~ s(times, k = k), data = df)
  pred <- predict(mod, se.fit = TRUE)
  
  pred_df <- data.frame(prediction = pred$fit,
                        x = mcycle$times,
                        upCI = pred$fit + pred$se.fit * 2,
                        lwCI = pred$fit - pred$se.fit * 2)
  
  ggplot() +
    geom_point(data = mcycle, aes(x = times, y = accel)) +
    geom_line(data = pred_df, aes(x = x, y = prediction)) +
    geom_ribbon(data = pred_df, aes(x = x, ymin = lwCI, 
                                    ymax = upCI), alpha = 0.2, fill = "blue")
}

k1 <- plot_mod(df = mcycle, k = 1)
k2 <- plot_mod(df = mcycle, k = 5)
k10 <- plot_mod(df = mcycle, k = 10)
k20 <- plot_mod(df = mcycle, k = 20)

cowplot::plot_grid(k1, k2, k10, k20)

