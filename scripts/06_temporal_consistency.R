# =========================================================
# 06_temporal_consistency.R
# Temporal consistency of individual differences: comparing
# individual random-effect estimates across two seasons
# per species, via Spearman correlation
# Model structure matches the main models in script 03
# =========================================================

library(mgcv)

source("scripts/01_data_import.R")

# ---------------------------------------------------------
# Golden jackal
# ---------------------------------------------------------

seasons_use <- c("Cool dry", "Hot dry")
blup_by_season_jackal <- list()

for (s in seasons_use) {
  sub <- jackal[jackal$season == s, ]
  sub$individual_id <- droplevels(sub$individual_id)
  sub$start <- with(sub, c(TRUE, individual_id[-1] != head(individual_id, -1)))
  
  m_season <- bam(mean_ODBA ~ land_use + s(dist_to_road, k = 5, bs = 'tp') + dist_to_poultry +
                    s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
                  data = sub, family = Gamma(link = "inverse"),
                  method = "fREML", AR.start = sub$start, discrete = TRUE)
  
  coefs <- coef(m_season)
  blups <- coefs[grep("individual_id", names(coefs))]
  ids <- levels(sub$individual_id)
  blup_by_season_jackal[[s]] <- setNames(blups, ids)
}

all_ids_jackal <- levels(jackal$individual_id)
blup_table_jackal <- sapply(blup_by_season_jackal, function(x) x[all_ids_jackal])
rownames(blup_table_jackal) <- all_ids_jackal
blup_table_jackal

cor.test(blup_table_jackal[, 1], blup_table_jackal[, 2], method = "spearman")

# ---------------------------------------------------------
# Indian fox
# ---------------------------------------------------------

seasons_use <- c("Cool dry", "Wet")
blup_by_season_fox <- list()

for (s in seasons_use) {
  sub <- fox[fox$season == s, ]
  sub$individual_id <- droplevels(sub$individual_id)
  sub$start <- with(sub, c(TRUE, individual_id[-1] != head(individual_id, -1)))
  
  m_season <- bam(mean_ODBA ~ land_use + s(dist_to_poultry, k = 4, bs = 'tp') +
                    s(dist_to_road, k = 4, bs = 'tp') +
                    s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
                  data = sub, family = Gamma(link = "inverse"),
                  method = "fREML", AR.start = sub$start, discrete = TRUE)
  
  coefs <- coef(m_season)
  blups <- coefs[grep("individual_id", names(coefs))]
  ids <- levels(sub$individual_id)
  blup_by_season_fox[[s]] <- setNames(blups, ids)
}

all_ids_fox <- levels(fox$individual_id)
blup_table_fox <- sapply(blup_by_season_fox, function(x) x[all_ids_fox])
rownames(blup_table_fox) <- all_ids_fox
blup_table_fox

cor.test(blup_table_fox[, 1], blup_table_fox[, 2], method = "spearman")

# ---------------------------------------------------------
# Jungle cat
# ---------------------------------------------------------

seasons_use <- c("Cool dry", "Hot dry")
blup_by_season_jc <- list()

for (s in seasons_use) {
  sub <- jc[jc$season == s, ]
  sub$individual_id <- droplevels(sub$individual_id)
  sub$start <- with(sub, c(TRUE, individual_id[-1] != head(individual_id, -1)))
  
  m_season <- bam(mean_ODBA ~ land_use + s(dist_to_road, k = 5, bs = 'tp') +
                    s(dist_to_poultry, k = 4, bs = 'tp') +
                    s(heterogeneity, k = 5, bs = 'tp') + s(individual_id, bs = "re"),
                  data = sub, family = Gamma(link = "inverse"),
                  method = "fREML", AR.start = sub$start, discrete = TRUE)
  
  coefs <- coef(m_season)
  blups <- coefs[grep("individual_id", names(coefs))]
  ids <- levels(sub$individual_id)
  blup_by_season_jc[[s]] <- setNames(blups, ids)
}

all_ids_jc <- levels(jc$individual_id)
blup_table_jc <- sapply(blup_by_season_jc, function(x) x[all_ids_jc])
rownames(blup_table_jc) <- all_ids_jc
blup_table_jc

cor.test(blup_table_jc[, 1], blup_table_jc[, 2], method = "spearman")