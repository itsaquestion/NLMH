

library(RNetLogo)
library(MyUtils)
#library(tidyverse)
library(testthat)

setwd("C:/Users/lee/OneDrive/Rprojects/NetLogo_UnitTest/")
sourceDir("methods")


startNLGui(getNlPath())

# open the latest model
model.dir = "C:/Users/lee/OneDrive/Academic/Endowment/NetLogo_models/"

openLatestModel(model.dir)

# exitNL()


