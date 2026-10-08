# =========================================================
# 05_repeatability_analysis.R
# Repeatability (R) via parametric bootstrap, all three species
# =========================================================

library(mgcv)

source("scripts/03_main_models.R")

# ---------------------------------------------------------
# Golden jackal: parametric bootstrap
# ---------------------------------------------------------

set.seed(1)
n_sim <- 1000
fitted_mu <- fitted(m1)
phi <- summary(m1)$dispersion

R_boot <- numeric(n_sim)

for (i in 1:n_sim) {
  sim_y <- rgamma(length(fitted_mu), shape = 1/phi, scale = fitted_mu * phi)
  jackal_sim <- jackal
  jackal_sim$mean_ODBA <- sim_y
  
  m_sim <- bam(mean_ODBA ~ season * land_use + s(dist_to_road, k = 5, bs = 'tp') + dist_to_poultry +
                 s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
               data = jackal_sim, family = Gamma(link = "inverse"),
               method = "fREML", rho = 0.368, AR.start = jackal_sim$start,
               discrete = TRUE, weights = jackal_sim$w)
  
  vc <- gam.vcomp(m_sim)
  var_ind_i <- vc["s(individual_id)", "std.dev"]^2
  var_resid_i <- var(residuals(m_sim, type = "response"))
  
  R_boot[i] <- var_ind_i / (var_ind_i + var_resid_i)
}

quantile(R_boot, c(0.025, 0.5, 0.975))

# ---------------------------------------------------------
# Indian fox: parametric bootstrap
# ---------------------------------------------------------

set.seed(1)
n_sim <- 1000
fitted_mu_fox <- fitted(m3_w)
phi_fox <- summary(m3_w)$dispersion

R_boot_fox <- numeric(n_sim)

for (i in 1:n_sim) {
  sim_y <- rgamma(length(fitted_mu_fox), shape = 1/phi_fox, scale = fitted_mu_fox * phi_fox)
  fox_sim <- fox
  fox_sim$mean_ODBA <- sim_y
  
  m_sim_fox <- bam(mean_ODBA ~ season * land_use + s(dist_to_poultry, k = 4, bs = 'tp') +
                     s(dist_to_road, k = 4, bs = 'tp') +
                     s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
                   data = fox_sim, family = Gamma(link = "inverse"),
                   method = "fREML", rho = 0.303, AR.start = fox_sim$start,
                   discrete = TRUE, weights = fox_sim$w)
  
  vc_fox <- gam.vcomp(m_sim_fox)
  var_ind_fox_i <- vc_fox["s(individual_id)", "std.dev"]^2
  var_resid_fox_i <- var(residuals(m_sim_fox, type = "response"))
  
  R_boot_fox[i] <- var_ind_fox_i / (var_ind_fox_i + var_resid_fox_i)
}

quantile(R_boot_fox, c(0.025, 0.5, 0.975))

# ---------------------------------------------------------
# Jungle cat: parametric bootstrap
# ---------------------------------------------------------

set.seed(1)
n_sim <- 1000
fitted_mu_jc <- fitted(m2)
phi_jc <- summary(m2)$dispersion

R_boot_jc <- rep(NA, n_sim)

for (i in 1:n_sim) {
  sim_y <- rgamma(length(fitted_mu_jc), shape = 1/phi_jc, scale = fitted_mu_jc * phi_jc)
  jc_sim <- jc
  jc_sim$mean_ODBA <- sim_y
  
  fit_attempt <- tryCatch({
    m_sim_jc <- bam(mean_ODBA ~ season * land_use + s(dist_to_road, k = 5, bs = 'tp') +
                      s(dist_to_poultry, k = 4, bs = 'tp') +
                      s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
                    data = jc_sim, family = Gamma(link = "inverse"),
                    method = "fREML", rho = 0.358, AR.start = jc_sim$start,
                    discrete = TRUE, weights = jc_sim$w)
    
    vc_jc <- gam.vcomp(m_sim_jc)
    var_ind_jc_i <- vc_jc["s(individual_id)", "std.dev"]^2
    var_resid_jc_i <- var(residuals(m_sim_jc, type = "response"))
    var_ind_jc_i / (var_ind_jc_i + var_resid_jc_i)
  }, error = function(e) NA)
  
  R_boot_jc[i] <- fit_attempt
}

sum(is.na(R_boot_jc))
quantile(R_boot_jc, c(0.025, 0.5, 0.975), na.rm = TRUE)