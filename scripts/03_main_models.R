# =========================================================
# 03_main_models.R
# Correlation of continuous predictors
# Main GAMMs: ODBA ~ season * land_use + continuous covariates
# Species-wise, with AR1 autocorrelation and inverse weighting
# =========================================================

library(mgcv)
library(itsadug)

source("scripts/01_data_import.R")

# ---------------------------------------------------------
# Golden jackal
# ---------------------------------------------------------

vars_jackal <- jackal[, c("dist_to_road", "dist_to_poultry", "heterogeneity")]
cor(vars_jackal, method = "spearman", use = "complete.obs")

# ---------------------------------------------------------
# Indian fox
# ---------------------------------------------------------

vars_fox <- fox[, c("dist_to_road", "dist_to_poultry", "heterogeneity")]
cor(vars_fox, method = "spearman", use = "complete.obs")

# ---------------------------------------------------------
# Jungle cat
# ---------------------------------------------------------

vars_jc <- jc[, c("dist_to_road", "dist_to_poultry", "heterogeneity")]
cor(vars_jc, method = "spearman", use = "complete.obs")

##### -----------------------------------------------------
##      Running the main models
##### -----------------------------------------------------

# ---------------------------------------------------------
# Golden jackal
# ---------------------------------------------------------

# Preliminary model without AR1, to estimate rho
m0 <- bam(mean_ODBA ~ season * land_use + s(dist_to_poultry) + s(dist_to_road) +
            s(heterogeneity) + s(individual_id, bs = "re"),
          data = jackal, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

jackal$start <- with(jackal, c(TRUE, individual_id[-1] != head(individual_id, -1)))

# Inverse weighting by land use frequency
w_table <- table(jackal$land_use)
jackal$w <- 1 / as.numeric(w_table[jackal$land_use])
jackal$w <- jackal$w / mean(jackal$w)

m1 <- bam(mean_ODBA ~ season * land_use + s(dist_to_road, k = 5, bs = 'tp') + dist_to_poultry +
            s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
          data = jackal,
          family = Gamma(link = "inverse"),
          method = "fREML",
          rho = 0.368,        # rho_est
          AR.start = jackal$start,
          discrete = TRUE,
          weights = jackal$w)

summary(m1)
check_resid(m1, ask = FALSE)

# ---------------------------------------------------------
# Indian fox
# ---------------------------------------------------------

m0 <- bam(mean_ODBA ~ season * land_use + s(dist_to_poultry) + s(dist_to_road) +
            s(heterogeneity) + s(individual_id, bs = "re"),
          data = fox, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

fox$start <- with(fox, c(TRUE, individual_id[-1] != head(individual_id, -1)))

w_table <- table(fox$land_use)
fox$w <- 1 / as.numeric(w_table[fox$land_use])
fox$w <- fox$w / mean(fox$w)

m3_w <- bam(mean_ODBA ~ season * land_use + s(dist_to_poultry, k = 4, bs = 'tp') +
              s(dist_to_road, k = 4, bs = 'tp') +
              s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
            data = fox,
            family = Gamma(link = "inverse"),
            method = "fREML",
            rho = 0.303,
            AR.start = fox$start,
            discrete = TRUE,
            weights = fox$w)

summary(m3_w)
check_resid(m3_w, ask = FALSE)

# ---------------------------------------------------------
# Jungle cat
# ---------------------------------------------------------

m0 <- bam(mean_ODBA ~ season * land_use + s(dist_to_poultry) + s(dist_to_road) +
            s(heterogeneity) + s(individual_id, bs = "re"),
          data = jc, family = Gamma(link = "inverse"))

acf_res <- acf(residuals(m0), lag.max = 1, plot = FALSE)
rho_est <- acf_res$acf[2]

jc$start <- with(jc, c(TRUE, individual_id[-1] != head(individual_id, -1)))

w_table <- table(jc$land_use)
jc$w <- 1 / as.numeric(w_table[jc$land_use])
jc$w <- jc$w / mean(jc$w)

m2 <- bam(mean_ODBA ~ season * land_use + s(dist_to_road, k = 5, bs = 'tp') +
            s(dist_to_poultry, k = 4, bs = 'tp') +
            s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
          data = jc,
          family = Gamma(link = "inverse"),
          method = "fREML",
          rho = 0.358,
          AR.start = jc$start,
          discrete = TRUE,
          weights = jc$w)

summary(m2)
check_resid(m2, ask = FALSE)