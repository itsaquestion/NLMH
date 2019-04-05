library(MyPlot)
library(MyUtils)
library(ggplot2)

run("setup")

run('marriage')

run('updateCounters')

run('tick') # 此时为 ticks==1

run('ticks') == 1

run('ageing')

run('count turtles with [age = 1]')

run('reproduction')

run('count turtles with [age = 1]')





# ========================
# 以下为旧版内容
# ========================

# 固定
run("setup")
run("set fixPop? true")
run('set num_pop 2000')
run('set useLearning? true')

vars = c("k", "y", "mean_saving_rate", "saving_rate_sd")

result3 = NLDoReport(150, "go-once", vars,
                     as.data.frame = TRUE,
                     df.col.names = vars)

tmp = tail(result3, 100)
tail(tmp)
print(colMeans(tmp))



# 实验1： 贴现率rho下降，罗默第三版59页面

rho.list = (10:2) / 2;
rho.list

res = lapply(rho.list, function(rho) {
  run("setup")
  run("set fixPop? true")
  run('set num_pop 2000')
  run('set useLearning? true')

  run(paste0("set init_rho ", rho))

  vars = c("k", "y", "mean_saving_rate", "saving_rate_sd")

  result3 = NLDoReport(150, "go-once", vars,
                       as.data.frame = TRUE,
                       df.col.names = vars)

  tmp = tail(result3, 50)
  #tail(tmp)
  colMeans(tmp)
})

res_rho.df = data.frame(rho = rho.list, Reduce(rbind, res))
res_rho.df

library(ggplot2)
mplot(
    qplot(x = res_rho.df$rho, y = res_rho.df$mean_saving_rate) + geom_line() + mytheme +
    ggtitle("rho vs s, k ,y"),
    qplot(x = res_rho.df$rho, y = res_rho.df$k) + geom_line() + mytheme,
    qplot(x = res_rho.df$rho, y = res_rho.df$y) + geom_line() + mytheme
)

# 结论：
## 贴现率rho降低，使得储蓄更多，稳态k增加，稳态y增加
## 符合教科书结论


# 实验1： 贴现率rho下降，罗默第三版59页面

n.list = (1:9) / 10
n.list

res = lapply(n.list, function(nn) {
  run("setup")
  run("set fixPop? true")
  run('set num_pop 2000')
  run('set useLearning? true')

  run(paste0("set reproduction_rate ", nn))

  vars = c("k", "y", "mean_saving_rate", "saving_rate_sd")

  result3 = NLDoReport(
      150, "go-once", vars,
      as.data.frame = TRUE, df.col.names = vars)

  tmp = tail(result3, 50)
  #tail(tmp)
  colMeans(tmp)
})

n_res.df = data.frame(n = n.list, Reduce(rbind, res))
n_res.df

library(ggplot2)
mplot(
    qplot(x = n_res.df$n, y = n_res.df$mean_saving_rate) +
    geom_line() + mytheme +
    ggtitle("rho vs s, k ,y"),
    qplot(x = n_res.df$n, y = n_res.df$k) + geom_line() + mytheme,
    qplot(x = n_res.df$n, y = n_res.df$y) + geom_line() + mytheme
)

# 结论：
## n对储蓄率没什么影响（可以直接从公式看到），n增加，稳态k和y都会降低
## 符合教科书结论


# 