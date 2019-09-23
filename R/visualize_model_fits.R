visualize_model_fits <- function(df, known){
  
  M.lm <- gls(y ~ x,
              data = df)
  
  M.gls1 <- gls(y ~ x,
                data = df, weights = varFixed(~x))
  
  newdata <- data.frame(x = df$x)
  
  lm_pred <- AICcmodavg::predictSE.gls(M.lm, newdata = newdata, se.fit = TRUE)
  gls_pred <- AICcmodavg::predictSE.gls(M.gls1, newdata = newdata, se.fit = TRUE)
  
  fit_lm <- tibble(x = df$x,
                   fit = lm_pred$fit,
                   lw_ci = lm_pred$fit - lm_pred$se.fit * 2,
                   up_ci = lm_pred$fit + lm_pred$se.fit * 2,
                   Model = "OLS") 
  
  
  fit_gls <- tibble(x = df$x, 
                    fit = gls_pred$fit,
                    lw_ci = gls_pred$fit - gls_pred$se.fit * 2,
                    up_ci = gls_pred$fit + gls_pred$se.fit * 2,
                    Model = "GLS")
  
  fit_known <- tibble(x = df$x,
                     y = df$known,
                     Model = "Known") 
  
  out <- rbind(fit_lm, fit_gls)
  
  p <- ggplot() +
    geom_point(data = df, aes(x = x, y = y), alpha = 0.75) +
    geom_line(data = out,aes(x = x, y = fit, color = Model), size = 2) +
    geom_ribbon(data = out,aes(x = x, ymin = lw_ci, ymax = up_ci, 
                               fill = Model), alpha = 0.2) +
    geom_line(data = fit_known, aes(x = x, y = y)) +
    theme(plot.title = element_text(50)) +
    theme_ggeffects() +
    ggtitle("OLS vs GLS") 
    
  
    return(p)
}

model_summ <- function(df, known){
  M.lm <- gls(y ~ x,
              data = df)
  
  M.gls1 <- gls(y ~ x,
                data = df, weights = varFixed(~x))
  return(paste('<font size="5">Known effect size:',known,
              "<br>GLS modeled effect size",round(coef(M.gls1)[2],3),"</br>",
              "\nOLS modeled effect size",round(coef(M.lm)[2],3),"</font>"))
}
