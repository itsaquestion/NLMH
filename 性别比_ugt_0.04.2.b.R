# ÐÔ±ð±È_ugt_0.04.2.b ====
# 
library(dplyr)

init_sr_list = (10:20)/10
init_sr_list

res = lapply(init_sr_list, function(init_sr) {
  tt = Sys.time()

  options(java.parameters = "-Xms2g")

  startNL(getNlPath(), gui = F)

  #open the latest model
  model.dir = "C:/Users/lee/OneDrive/Academic/UGT/netlogo/"
  openLatestModel(model.dir)

  run("setup")
  run("set fixPop? true")
  run('set num_pop 1500')
  run("set reproduction_rate 5")

  run(paste0("set init_sr ", init_sr))

  vars = c("mean_unity_1", "mean_unity_2", "mean_saving_rate_1", "mean_saving_rate_2")

  result3 = NLDoReport(200, "go-once", vars,
                       as.data.frame = TRUE,
                       df.col.names = vars)

  tmp = tail(result3, 10)
  #tail(tmp)
  NLQuit()

  #beepr::beep()

  print(Sys.time() - tt)
  cat("\n")
  colMeans(tmp)
})

res.df = data.frame(sr = init_sr_list, Reduce(rbind, res))
res.df

plot(res.df$sr, res.df$mean_saving_rate_2, type = "l", ylim = c(0, 0.5))
plot(res.df$sr, res.df$mean_unity_2, type = "l")

beepr::beep()
beepr::beep()

library(ggplot2)
mplot(
    qplot(x = res_rho.df$rho, y = res_rho.df$mean_saving_rate) + geom_line() + mytheme +
    ggtitle("rho vs s, k ,y"),
    qplot(x = res_rho.df$rho, y = res_rho.df$k) + geom_line() + mytheme,
    qplot(x = res_rho.df$rho, y = res_rho.df$y) + geom_line() + mytheme
)