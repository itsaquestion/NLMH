MyUtils::rmAll()
library(RNetLogo)
library(MyUtils)
#library(tidyverse)
library(testthat)

# options(java.parameters = "-Dawt.useSystemAAFontSettings=on")

setwd("C:/Users/lee/OneDrive/Rprojects/NetLogo_Model_Helper/")
#setwd(here::here())
sourceDir("methods")


startNLGui(getNlPath())

# open the latest model
model.dir = "C:/Users/lee/OneDrive/Academic/UGT/netlogo/"

openLatestModel(model.dir)

# exitNL()

run('setup')

run('count turtles')

library(xts)
library(lubridate)
a = as.xts(1:5, order.by = seq(today() - 4, today(), by = 1))

str(a)

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
fun = function(x) {

}

