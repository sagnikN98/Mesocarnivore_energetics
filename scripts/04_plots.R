# =========================================================
# 04_plots.R
# Plots of model predictions: boxplots by land use/season,
# and smooth curves for continuous predictors (road, poultry,
# heterogeneity), species-wise
# =========================================================

library(mgcv)
library(itsadug)
library(ggplot2)

source("scripts/03_main_models.R")

# ---------------------------------------------------------
# Add predicted values to the original data
# ---------------------------------------------------------

jackal$predicted_ODBA <- predict(m1, type = "response")
jc$predicted_ODBA <- predict(m2, type = "response")
fox$predicted_ODBA <- predict(m3_w, type = "response")

# ---------------------------------------------------------
# Boxplots: predicted ODBA by land use and season
# ---------------------------------------------------------

# Golden jackal
ggplot(jackal, aes(x = land_use, y = predicted_ODBA, fill = season)) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  stat_summary(
    fun = mean, geom = "point", aes(group = season),
    position = position_dodge(width = 0.8),
    shape = 21, size = 3, fill = "yellow", color = "black"
  ) +
  ylab("ODBA") + xlab("") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  scale_x_discrete(labels = c(
    "1" = "Grassland", "2" = "Built-up", "3" = "Agriculture", "4" = "Fallow"
  )) +
  scale_y_continuous(limits = c(NA, 0.8)) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black", size = 0.3),
    axis.ticks = element_line(color = "black", size = 0.3),
    axis.title.y = element_text(margin = margin(r = 10), face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.text.y = element_text(size = 12)
  ) +
  ggtitle("")

# Indian fox
ggplot(fox, aes(x = land_use, y = predicted_ODBA, fill = season)) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  stat_summary(
    fun = mean, geom = "point", aes(group = season),
    position = position_dodge(width = 0.8),
    shape = 21, size = 3, fill = "yellow", color = "black"
  ) +
  ylab("ODBA") + xlab("") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  scale_x_discrete(labels = c(
    "1" = "Grassland", "2" = "Built-up", "3" = "Agriculture",
    "4" = "Fallow", "6" = "Plantation"
  )) +
  scale_y_continuous(limits = c(NA, 0.9)) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black", size = 0.3),
    axis.ticks = element_line(color = "black", size = 0.3),
    axis.title.y = element_text(margin = margin(r = 10), face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.text.y = element_text(size = 12)
  ) +
  ggtitle("")

# Jungle cat
ggplot(jc, aes(x = land_use, y = predicted_ODBA, fill = season)) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  stat_summary(
    fun = mean, geom = "point", aes(group = season),
    position = position_dodge(width = 0.8),
    shape = 21, size = 3, fill = "yellow", color = "black"
  ) +
  ylab("ODBA") + xlab("") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  scale_x_discrete(labels = c(
    "1" = "Grassland", "2" = "Built-up", "3" = "Agriculture", "4" = "Fallow"
  )) +
  scale_y_continuous(limits = c(NA, 0.6)) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black", size = 0.3),
    axis.ticks = element_line(color = "black", size = 0.3),
    axis.title.y = element_text(margin = margin(r = 10), face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.text.y = element_text(size = 12)
  ) +
  ggtitle("")

# ---------------------------------------------------------
# Smooth plots: ODBA vs distance to road / poultry (per species)
# ---------------------------------------------------------

# Golden jackal
plot(1, type = "n", xlim = c(0, 2000), ylim = c(0.3, 0.8),
     xlab = "Distance to feature", ylab = "ODBA",
     main = "Golden Jackal", cex.axis = 1.5)
plot_smooth(m1, view = "dist_to_road", rm.ranef = TRUE, add = TRUE,
            col = "#0072B2", transform = function(x) 1/x, rug = FALSE)
plot_smooth(m1, view = "dist_to_poultry", rm.ranef = TRUE, add = TRUE,
            col = "#F48020", transform = function(x) 1/x, rug = FALSE)
legend("bottomleft", legend = c("Road", "Poultry"),
       col = c("#0072B2", "#F48020"), lwd = 2, cex = 2, bty = "n")

# Jungle cat
plot(1, type = "n", xlim = c(0, 2400), ylim = c(0.3, 0.8),
     xlab = "Distance to feature", ylab = "ODBA",
     main = "Jungle Cat", cex.axis = 1.5)
plot_smooth(m2, view = "dist_to_road", rm.ranef = TRUE, add = TRUE,
            col = "#0072B2", transform = function(x) 1/x, rug = FALSE,
            xlim = c(0, 1200))
plot_smooth(m2, view = "dist_to_poultry", rm.ranef = TRUE, add = TRUE,
            col = "#F48020", transform = function(x) 1/x, rug = FALSE)
legend("bottomleft", legend = c("Road", "Poultry"),
       col = c("#0072B2", "#F48020"), lwd = 2, cex = 0.7, bty = "n")

# Indian fox
plot(1, type = "n", xlim = c(0, 2000), ylim = c(0.3, 0.8),
     xlab = "Distance / Heterogeneity", ylab = "ODBA",
     main = "Indian Fox", cex.axis = 1.5)
plot_smooth(m3_w, view = "dist_to_road", rm.ranef = TRUE, add = TRUE,
            col = "#0072B2", transform = function(x) 1/x, rug = FALSE)
plot_smooth(m3_w, view = "dist_to_poultry", rm.ranef = TRUE, add = TRUE,
            col = "#F48020", transform = function(x) 1/x, rug = FALSE,
            xlim = c(0, 2000))
legend("bottomleft", legend = c("Road", "Poultry"),
       col = c("#0072B2", "#F48020"), lwd = 2, cex = 0.7, bty = "n")

# ---------------------------------------------------------
# Smooth plot: ODBA vs landscape heterogeneity (all species, one panel)
# ---------------------------------------------------------

plot(1, type = "n", xlim = c(0, 1.4), ylim = c(0.3, 0.8),
     xlab = "Landscape heterogeneity", ylab = "ODBA", cex.axis = 1.5)

plot_smooth(m1, view = "heterogeneity", rm.ranef = TRUE, add = TRUE,
            transform = function(x) 1/x, col = "#009E73", rug = FALSE)
plot_smooth(m2, view = "heterogeneity", rm.ranef = TRUE, add = TRUE,
            transform = function(x) 1/x, col = "#0072B2", rug = FALSE)
plot_smooth(m3_w, view = "heterogeneity", rm.ranef = TRUE, add = TRUE,
            transform = function(x) 1/x, col = "#F48020", rug = FALSE)

legend("bottomleft",
       legend = c("Golden jackal", "Indian fox", "Jungle cat"),
       col = c("#009E73", "#F48020", "#0072B2"),
       lwd = 2, cex = 0.8, bty = "n")