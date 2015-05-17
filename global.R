options("getSymbols.warning4.0"=FALSE)
#source("helpers/data_generator.R")
source("helpers/data_generator_2.R")

cpm.methods <- c("Student",
                 "Bartlett",
                 "GLR",
                 "Exponential",
                 "GLRAdjusted",
                 "ExponentialAdjusted",
                 "FET",
                 "Mann-Whitney",
                 "Mood",
                 "Lepage",
                 "Kolmogorov-Smirnov",
                 "Cramer-von-Mises")
