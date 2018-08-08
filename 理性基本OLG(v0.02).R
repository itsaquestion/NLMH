# 理性基本OLG(v0.02)

library(MyPlot)
library(dplyr)

run("setup")

run("set tech_growth_rate " %+% "0.1")

run("repeat 15 [go-once]")

run("k")


g = (0:20) / 20;
g

k = sapply(g, function(x) {
  run("setup")

  run(paste0("set tech_growth_rate ", x))

  run("repeat 15 [go-once]")

  ret = run("k");
  print(ret)
  ret
})

library(ggplot2)

plot(log(k) ~ g)
abline(lm(log(k) ~ g))

qplot(g, (k)) + theme_bw()

data.frame(g, k)

alpha = run("alpha");
alpha
n = run("reproduction_rate");
n
g = 0.4 # k = 0.01986451
rho = run("init_rho");
rho

k = ((1 - alpha) / ((1 + n) * (1 + g) * (2 + rho))) ^ (1 / (1 - alpha));
k
y = k ^ alpha;
y

# 对比一下，是否固定人口会不会影响人均值

# 不固定
run("setup")
run("set fixPop? false")
run('set num_pop 100')
result1 = NLDoReport(15, "go-once", c("k", "y"),
                     as.data.frame = TRUE, df.col.names = c("k", "y"))
result1
tail(result1, 5) %>% colMap(mean) %>% round(5)

qplot(1:15, cbind(result2$k, result1$k)) + geom_line() + theme_bw() + ggtitle("k") + xlab("t") + ylab("k")


# 固定
run("setup")
run("set fixPop? true")
run('set num_pop 20000')
result2 = NLDoReport(15, "go-once", c("k", "y"),
            as.data.frame = TRUE, df.col.names = c("k", "y"))
result2

tail(result2, 5) %>% colMap(mean) %>% round(5)

k2 = run("k");
k2
y2 = run("y");
y2

# 其实是不影响的
k1 / k2
y1 / y2

k.df = data.frame(t = 1:15, cbind(result1$k, result2$k))
names(k.df) = c("t", "k1", "k2")

ggplot(reshape2::melt(k.df, "t"), aes(x = t, y = (value), group = variable, color = variable)) +
  geom_line() + geom_point() + theme_bw() + ggtitle("k")

y.df = data.frame(t = 1:15, cbind(result1$y, result2$y))
names(y.df) = c("t", "y1", "y2")

ggplot(reshape2::melt(y.df, "t"), aes(x = t, y = (value), group = variable, color = variable)) +
  geom_line() + geom_point() + theme_bw() + ggtitle("y")




