# 禀赋效应reload_0.2.0
library(MyPlot)
library(ggplot2)
library(functional)
library(xts)
library(MyUtils)
library(ggsci)
library(dplyr)

run('getBestCost 5 1')

getBestC = function(a, b){
  run(paste('getBestCost',a,b),showCmd=F)
}

v = run("v")
v0 = run("v0")

# 考察最优的c1和c2

aa = seq(1,run("max_alpha_beta"),0.01)
beta = run("fix_beta")

foo_b1 =  Curry(getBestC,b=beta)
yy_b1 = sapply(aa,foo_b1)


# foo_b1.5 =  Curry(getBestC,b=1.5)
# yy_b1.5 = sapply(aa,foo_b1.5)

# df = data.frame(t(yy_b1),t(yy_b1.5),0)
# names(df) = c("c1_b1","c2_b1","c1_b1.5","c2_b1.5","zero")

plotPart = function(df,title = "",line.size = 1){
  ggplotDF(df,aa) +  ggtitle(paste0(title," | beta =", beta)) +
    geom_line(size = line.size) + xlab("Alpha") +  mytheme_right  + scale_color_aaas() + ylab("")
}

df.c = data.frame(t(yy_b1),v,v0)
names(df.c) = c("c1","c2","v","v0")
p.c = plotPart(df.c, "最优投入 C1 & C2")

#p.c

# 考察胜率
win.p1 = df.c$c1 / (df.c$c1 + df.c$c2)
win.p2 = 1 - win.p1

df.win = data.frame(win.p1, win.p2)
p.win = plotPart(df.win, "胜率 W1 & W2")

#p.win



# 期望盈利
V = rep(run("v",showCmd=F),length(df.c$c1))
V0 = rep(run("v0",showCmd=F),length(df.c$c1))

profit.p1 = ifelse(df.c$c2>0, df.win$win.p1 * V  + (1 - df.win$win.p1) * V0 - df.c$c1,V )
profit.p2 = ifelse(df.c$c2>0, df.win$win.p2 * V  + (1 - df.win$win.p2) * V0 - df.c$c2,V0 )
profit.p1[profit.p1 < 0] = 0
profit.p2[profit.p2 < 0] = 0

profit.expected = (profit.p1 + profit.p2)/2

# 从跳跃点断开
breakJumps = function(x,  threshold = 0.2){
  breaker = abs(x - dplyr::lag(x)) > threshold
  x[breaker] = NaN
  x
}


# 临时断开
profit.p1 = breakJumps(profit.p1)
profit.p2 = breakJumps(profit.p2)


profit.expected = breakJumps(profit.expected)

df.profit = data.frame(profit.p1, profit.p2, profit.expected)
p.profit = plotPart(df.profit, "期望赢利 P1 & P2")

#p.profit

multiplot2(p.c,p.win,p.profit)


#data.frame(alpha = aa, df.c,df.win,df.profit) %>% head(100) %>% tail(40)



