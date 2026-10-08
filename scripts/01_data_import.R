library(dplyr)

jackal <- read.csv("data/jackal_odba.csv")
fox    <- read.csv("data/fox_odba.csv")
jc     <- read.csv("data/jungle_cat_odba.csv")

jackal$individual_id <- as.factor(jackal$individual_id)
jackal$land_use <- as.factor(jackal$land_use)
jackal$season <- as.factor(jackal$season)

fox$individual_id <- as.factor(fox$individual_id)
fox$land_use <- as.factor(fox$land_use)
fox$season <- as.factor(fox$season)

jc$individual_id <- as.factor(jc$individual_id)
jc$land_use <- as.factor(jc$land_use)
jc$season <- as.factor(jc$season)