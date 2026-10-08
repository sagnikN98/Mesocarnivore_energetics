# =========================================================
# 02_step_length_models.R
# ODBA ~ step length models, species-wise, with AR1 correction
# =========================================================

library(mgcv)
library(itsadug)

# Load data (working directory set to root)
source("scripts/01_data_import.R")

# ---------------------------------------------------------
# Golden jackal
# ---------------------------------------------------------

# Preliminary model without AR1, to estimate rho
m0 <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
          data = jackal, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

# Mark start of each individual's track for AR1 structure
jackal$start <- with(jackal, c(TRUE, individual_id[-1] != head(individual_id, -1)))

mod_jackal <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
                  data = jackal,
                  family = Gamma(link = "inverse"),
                  method = "fREML",
                  rho = 0.378,        # rho_est
                  AR.start = jackal$start,
                  discrete = TRUE)

summary(mod_jackal)
check_resid(mod_jackal, ask = FALSE)

# ---------------------------------------------------------
# Indian fox
# ---------------------------------------------------------

m0 <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
          data = fox, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

fox$start <- with(fox, c(TRUE, individual_id[-1] != head(individual_id, -1)))

mod_fox <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
               data = fox,
               family = Gamma(link = "inverse"),
               method = "fREML",
               rho = 0.352,          # rho_est
               AR.start = fox$start,
               discrete = TRUE)

summary(mod_fox)
check_resid(mod_fox, ask = FALSE)

# ---------------------------------------------------------
# Jungle cat
# ---------------------------------------------------------

m0 <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
          data = jc, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

jc$start <- with(jc, c(TRUE, individual_id[-1] != head(individual_id, -1)))

mod_jc <- bam(mean_ODBA ~ s(steplength) + s(individual_id, bs = "re"),
              data = jc,
              family = Gamma(link = "inverse"),
              method = "fREML",
              rho = 0.382,          # rho_est
              AR.start = jc$start,
              discrete = TRUE)

summary(mod_jc)
check_resid(mod_jc, ask = FALSE)

# ---------------------------------------------------------
# Plot: ODBA vs step length, one plot per species
# ---------------------------------------------------------

plot_smooth(mod_jackal, view = "steplength",
            rm.ranef = TRUE, transform = function(x) 1/x,
            col = "#009E73", rug = FALSE, main = "Golden Jackal",
            ylim = c(0.5, 0.7), xlab = "Step length (m)",
            ylab = "ODBA")

plot_smooth(mod_jc, view = "steplength",
            rm.ranef = TRUE, transform = function(x) 1/x,
            col = "#0072B2", rug = FALSE, main = "Jungle cat",
            ylim = c(0.3, 0.6), xlab = "Step length (m)",
            ylab = "ODBA")

plot_smooth(mod_fox, view = "steplength",
            rm.ranef = TRUE, transform = function(x) 1/x,
            col = "#CC79A7", rug = FALSE, main = "Indian fox",
            ylim = c(0.5, 0.85), xlab = "Step length (m)",
            ylab = "ODBA")