mcycle <- MASS::mcycle

plot_gam <- function(df, k, sp, make_fig = T){
  mod <- gam(accel ~ s(times, k = k), sp = sp, data = df)
  pred <- predict(mod, se.fit = TRUE)
  
  pred_df <- data.frame(prediction = pred$fit,
                        x = mcycle$times,
                        upCI = pred$fit + pred$se.fit * 2,
                        lwCI = pred$fit - pred$se.fit * 2)
  
  fig <-
    ggplot() +
    geom_point(data = mcycle, aes(x = times, y = accel)) +
    geom_line(data = pred_df, aes(x = x, y = prediction)) +
    geom_ribbon(data = pred_df, aes(x = x, ymin = lwCI, 
                                    ymax = upCI), alpha = 0.2, fill = "blue")
  
  summ <- summary(mod)
  
  if (make_fig){
    return(fig)
  } else {
    print(summ)
  }
}