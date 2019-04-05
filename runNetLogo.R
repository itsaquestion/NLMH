MyUtils::rmAll()

library(RNetLogo)
library(MyUtils)
#library(tidyverse)
library(testthat)

#options(java.parameters = "-Dawt.useSystemAAFontSettings=on")
options(java.parameters = "-Xms2g")



setwd("C:/Users/lee/OneDrive/Rprojects/NetLogo_Model_Helper/")
#setwd(here::here())
sourceDir("R/")

startNL(getNlPath(),gui=T)

#open the latest model
model.dir = "C:/Users/lee/OneDrive/Academic/UGT/netlogo/"

openLatestModel(model.dir)


# NLQuit()
#{

#}

###

