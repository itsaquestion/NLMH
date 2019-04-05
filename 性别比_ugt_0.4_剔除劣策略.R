# ÐÔ±ð±È_ugt_0.04.2.b ====
# 
library(dplyr)



library(SnowFor)

go_fun = function(init_sr) {
  tt = Sys.time()

  options(java.parameters = "-Xms2g")

  startNL(getNlPath(), gui = F)

  #open the latest model
  model.dir = "C:/Users/lee/OneDrive/Academic/UGT/netlogo/"
  openLatestModel(model.dir)

  NLLoadModel(model.dir %+% "/ugt_0.4.1_learn_from_average.nlogo")

  run("setup")
  run("set fixPop? true")
  run('set num_pop 1000')
  run('set distribute_factor% 1')
  run('set oldage_sup% 0.15')
  run("set reproduction_rate 5")
  run("set male_h 2")
  run("set male_h 2")

  run(paste0("set init_sr ", init_sr))

  vars = c("mean_unity_1", "mean_unity_2", "mid_saving_rate_2")

  result3 = NLDoReport(1000, "go-once", vars,
                       as.data.frame = TRUE,
                       df.col.names = vars)

  tmp = tail(result3, 50)
  #tail(tmp)
  NLQuit()

  #beepr::beep()

  print(Sys.time() - tt)
  cat("\n")
  colMeans(tmp)
}

pre_fun = function() {
  MyUtils::rmAll()

  library(RNetLogo)
  library(MyUtils)
  #library(tidyverse)
  library(testthat)

  #options(java.parameters = "-Dawt.useSystemAAFontSettings=on")
  options(java.parameters = "-Xms2g")

  setwd("C:/Users/lee/OneDrive/Rprojects/NetLogo_Model_Helper/")
  #setwd(here::here())
  MyUtils::sourceDir("R/")

}

init_sr_list = 1.0 + (0:10 / 5)
init_sr_list

res = snowFor(init_sr_list, go_fun, cores = 4, pre_fun = pre_fun)

res.df = data.frame(sr = init_sr_list, Reduce(rbind, res))
res.df

# plot(res.df$sr, res.df$mean_unity_2, type = "l")
# plot(res.df$sr, res.df$mid_saving_rate_2, type = "l")

library(ggplot2)
qplot(res.df$sr, res.df$mid_saving_rate_2) + geom_line()
qplot(res.df$sr, res.df$mean_unity_2) + geom_line()