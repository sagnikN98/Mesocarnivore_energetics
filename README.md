# Locomotion costs (ODBA) for mesocarnivores in an agro-ecosystem in India

## Summary

Wildlife increasingly inhabit fragmented, human-modified habitats. Locomotion in these landscapes may carry elevated energetic costs. This repository contains the data and analysis code used to examine variation in energy expenditure, measured via overall dynamic body acceleration (ODBA) from tri-axial accelerometer data, in three mesocarnivore species (Indian fox, *Vulpes bengalensis*; golden jackal, *Canis aureus*; jungle cat, *Felis chaus*) inhabiting a human-dominated agro-ecosystem in central India. Analyses assess how season, land use, proximity to roads and poultry farms, and landscape heterogeneity influence ODBA, and quantify individual-level repeatability and temporal consistency in locomotion costs within each species.

**Keywords:** Accelerometry, Overall Dynamic Body Acceleration, Human-modified landscape, movement ecology, mesocarnivores

## Contents
mesocarnivore_energetics/
├── data/
│ ├── jackal_odba.csv
│ ├── fox_odba.csv
│ └── jungle_cat_odba.csv
├── scripts/
│ ├── 01_data_import.R
│ ├── 02_odba_step_length.R
│ ├── 03_main_models.R
│ ├── 04_plots.R
│ ├── 05_repeatability_analysis.R
│ └── 06_temporal_consistency.R
├── README.md
└── LICENSE


**Note:** Data preparation steps (spatial covariate extraction using the `sf` package, ODBA calculation from raw accelerometer data, fitting movement models using 'ctmm') were performed separately and are not included in this repository; see the manuscript's Methods section for details. The scripts here begin from the processed, individual-level data provided in `data/`.

## Variable descriptions

The following columns are present in each species' data file (`jackal_odba.csv`, `fox_odba.csv`, `jungle_cat_odba.csv`):

| Column | Description |

| `individual_id` | Unique identifier for each individual animal |
| `timestamp` | Time of the beginning of each 15-minute interval |
| `mean_ODBA` | Average overall dynamic body acceleration (ODBA) for each 15-minute interval |
| `steplength` | Distance between the first and last point of a 15-minute interval |
| `season` | Season of sampling: Wet, Hot dry, or Cool dry |
| `land_use` | Land use category associated with each 15-minute interval (1 = Grassland, 2 = Built-up, 3 = Agriculture, 4 = Fallow, 6 = Plantation). Category 5 was set as the reference level during releveling and does not appear as a distinct code in this column. |
| `dist_to_road` | Averaged distance to the nearest road for each 15-minute interval |
| `dist_to_poultry` | Averaged distance to the nearest poultry farm for each 15-minute interval |
| `heterogeneity` | Averaged value of local landscape heterogeneity for each 15-minute interval |

**Note:** Columns such as `w` (model weights), `start` (marks the beginning of each individual's track for AR1 autocorrelation structure), and `predicted_ODBA` (model-predicted values) are generated within the analysis scripts themselves and are not present in the original data files.

## Software and package versions

Analyses were conducted in R version 4.6.0 (2026-04-24), platform x86_64-pc-linux-gnu, running under Ubuntu 22.04.5 LTS.

Packages required to run the scripts in this repository:
- `dplyr`
- `mgcv` 1.9-1
- `itsadug` 2.5
- `plotfunctions` 1.5
- `ggplot2` 4.0.3

Full `sessionInfo()` output from the analysis environment:
R version 4.6.0 (2026-04-24)
Platform: x86_64-pc-linux-gnu
Running under: Ubuntu 22.04.5 LTS

Matrix products: default
BLAS: /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0 LAPACK version 3.10.0

attached base packages:
[1] stats graphics grDevices utils datasets methods base

other attached packages:
[1] ggplot2_4.0.3 sf_1.1-1 dplyr_1.2.1 itsadug_2.5
[5] plotfunctions_1.5 mgcv_1.9-1 nlme_3.1-168

loaded via a namespace (and not attached):
[1] Matrix_1.7-4 gtable_0.3.6 compiler_4.6.0 tidyselect_1.2.1
[5] Rcpp_1.1.2 splines_4.6.0 scales_1.4.0 lattice_0.22-5
[9] R6_2.6.1 generics_0.1.4 classInt_0.4-11 tibble_3.3.1
[13] units_1.0-1 DBI_1.3.0 pillar_1.11.1 RColorBrewer_1.1-3
[17] rlang_1.3.0 S7_0.2.2 otel_0.2.0 cli_3.6.6
[21] withr_3.0.3 magrittr_2.0.5 class_7.3-23 grid_4.6.0
[25] rstudioapi_0.19.0 lifecycle_1.0.5 vctrs_0.7.3 KernSmooth_2.23-26
[29] proxy_0.4-29 glue_1.8.1 farver_2.1.2 cellranger_1.1.0
[33] stats4_4.6.0 e1071_1.7-17 tools_4.6.0 pkgconfig_2.0.3


## How to run

All scripts assume the working directory is set to the repository root (the folder containing `data/` and `scripts/`). If using RStudio, open a project at the repository root before running any script.

Run scripts in the following order:

1. **`01_data_import.R`** — loads the three species' CSV files and formats key columns as factors.
2. **`02_odba_step_length.R`** — fits species-wise GAMMs of ODBA against step length, with AR(1) correction.
3. **`03_main_models.R`** — checks correlations among continuous predictors, then fits the main species-wise GAMMs of ODBA against season, land use, and continuous covariates.
4. **`04_plots.R`** — generates prediction plots (boxplots by land use/season, smooth curves for continuous predictors) from the models fit in script 03.
5. **`05_repeatability_analysis.R`** — estimates individual repeatability (R) of ODBA for each species.
6. **`06_temporal_consistency.R`** — assesses whether individual rankings in ODBA are consistent across seasons, via Spearman rank correlation of individual random-effect estimates.

Each script sources `01_data_import.R` (or, where relevant, `03_main_models.R`) independently, so scripts can be run individually without requiring the full sequence. Scripts 04–06 will re-fit the relevant models from script 03 when sourced, which may take some time.

**Note:** Scripts 05 and 06 run parametric bootstrap simulations (1000 iterations per species) and may take a substantial amount of time to complete.

## License

This repository is licensed under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/). You are free to share and adapt the material for any purpose, provided appropriate credit is given.

## Citation

If you use this data or code, please cite the associated manuscript:

Nandy, S., Vanak, A.T., Thaker, M. (in review). Locomotion costs (ODBA) for mesocarnivores in an agro-ecosystem in India. *Proceedings of the Royal Society B*.

A full citation with volume, page numbers, and DOI will be added once the manuscript is published. In the meantime, this repository itself can be cited directly via its Zenodo DOI: 

## Contact

For questions about this repository, please contact the corresponding author:
Maria Thaker — mthaker@iisc.ac.in