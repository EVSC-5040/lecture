library(MASS)
library(nlme)
library(tidyverse)
library(magrittr)
library(AICcmodavg)

# devtools::install_github("cardiomoon/ggiraphExtra")

# Load data
Squid <- read.csv(here::here("data/Squid_Zuur-et-al-2009.txt"), sep = "\t")

# Convert month to a factor variable (fMONTH)
# Remove rows with NA values using ... %>% filter(complete.cases(.))
Squid %<>% 
  mutate(fMONTH = factor(MONTH,  ordered = TRUE)) %>% 
  filter(complete.cases(.))

# Fit linear model  
M1 <- lm(Testisweight ~ DML * fMONTH, data = Squid)

# The function ggplot2::autoplot can be used to view diagnositc plots via ggplot2.
# Note that this only works after installing and loading the ggfortify package.
autoplot(M1, label.size = 2, which = 1:6)


# Clearly the assumption of homogeneity of variance is not being met.

## Fixed Variance Structure (implemented with nlme::gls())

# Fit a linear model to compare with
M.lm <- gls(Testisweight ~ DML, data = Squid)

# Fit a GLS model assuming a fixed variance structure
M.gls1 <- gls(Testisweight ~ DML * fMONTH,
              data = Squid, weights = varFixed(~DML))

# Compare the model fits with AIC
anova(M.lm, M.gls1)

## VarIdent Variance Structure

# This adjusts the indices of the model to estimate the response at different values of month and DML, rather
# than just DML

# Visualizing residuals by month and by DML
vis_squid <- Squid %>% mutate(residuals = resid(M.gls1))

ggplot(data = vis_squid, aes(x = DML, y = residuals, group = fMONTH)) +
  geom_point()+
  facet_wrap(.~fMONTH)

#Comparing OLS and GLS model fits - how does accounting for variance structure affect model fit?

M.lm <- gls(Testisweight ~ DML,
              data = Squid)

M.gls1 <- gls(Testisweight ~ DML,
              data = Squid, weights = varFixed(~DML))

newdata <- data.frame(DML = Squid$DML)

lm_pred <- AICcmodavg::predictSE.gls(M.lm, newdata = newdata, se.fit = TRUE)
gls_pred <- AICcmodavg::predictSE.gls(M.gls1, newdata = newdata, se.fit = TRUE)

fit_lm <- tibble(x = Squid$DML,
                     fit = lm_pred$fit,
                     lw_ci = lm_pred$fit - lm_pred$se.fit * 2,
                     up_ci = lm_pred$fit + lm_pred$se.fit * 2,
                     Model = "OLS") 


fit_gls <- tibble(x = Squid$DML, 
                   fit = gls_pred$fit,
                   lw_ci = gls_pred$fit - gls_pred$se.fit * 2,
                   up_ci = gls_pred$fit + gls_pred$se.fit * 2,
                  Model = "GLS")

out <- rbind(fit_lm, fit_gls)

ggplot() +
  geom_point(data = Squid, aes(x = DML, y = Testisweight), alpha = 0.1) +
  geom_line(data = out,aes(x = x, y = fit, color = Model)) +
  geom_ribbon(data = out,aes(x = x, ymin = lw_ci, ymax = up_ci, 
                  fill = Model), alpha = 0.2) +
  theme_ggeffects() +
  ggtitle("OLS vs GLS") 

