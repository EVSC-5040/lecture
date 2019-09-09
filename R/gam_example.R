library(mgcv)
library(tidyverse)

mcycle <- MASS::mcycle


ggplot(data = mcycle, aes(x = times, y = accel)) +
  geom_point()

mod <- gam(accel ~ s(times), data = mcycle)


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



