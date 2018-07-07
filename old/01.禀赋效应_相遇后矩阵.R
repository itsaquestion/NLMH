library(functional)
library(dplyr)
library(ggplot2)
library(directlabels)
library(MyPlot)
library(MyUtils)

# 最优反应函数c1和c2 ====
bestC1Fun <- function(alpha, x, V) {
  pi = 0
  if(alpha == 1) 
    pi = (1 - x) * V / 4
  if(alpha > 1 & alpha < (2 - x)) 
    pi = ((alpha - x) ^ 2 * V) / (4 * (1 - x))
  if(alpha >= (2 - x)) 
    pi = (1 - x) * V
  
  pi
}

bestC2Fun <- function(alpha, x, V) {
  pi = 0
  if(alpha == 1) 
    pi = (1 - x) * V / 4
  if(alpha > 1 & alpha < (2 - x)) 
    pi = (((2-alpha) * alpha -(2 -x ) * x) * V) / (4 * (1 - x))
  if(alpha >= (2 - x)) 
    pi = 0
  
  pi
}


V = 1
xs = c(0, 0.2, 0.5, 0.8)
alphas  = seq(0, 3, by = 0.005) 

# best c1 ====
best.c1 = lapply(xs, function(xx){
  alphas %>%
    sapply(Curry(bestC1Fun, x = xx, V = V))
})

best.c1 = as.data.frame(Reduce(cbind, best.c1))
colnames(best.c1) = paste0("x_", xs)

p.c1 = ggplotDF(best.c1, alphas) + 
  geom_point() + ggtitle("Best C1") + 
  ylab("Best c1") + xlab("Alpha") + theme_bw()

# best c2 ====
best.c2 = lapply(xs, function(xx){
  alphas %>%
    sapply(Curry(bestC2Fun, x = xx, V = V))
})

best.c2 = as.data.frame(Reduce(cbind, best.c2))
colnames(best.c2) = paste0("x_", xs)


p.c2 = ggplotDF(best.c2, alphas) + 
  geom_point() + ggtitle("Best C2") + 
  ylab("Best c2") + xlab("Alpha") + theme_bw()

multiplot2(p.c1, p.c2)


# 最优c, 给定x = 0.2 ====

df = data.frame(x = alphas, c1 = best.c1$x_0.2, c2= best.c2$x_0.2)

ggplotDF(df) + 
  geom_point() + ggtitle("Best c1 vs c2 | x = 0.2") + 
  ylab("value") + xlab("Alpha") + theme_bw()



# 净利润 ====

profitFun <- function(c1, c2, V, x, alpha) {
  if(alpha < (2 - x)){
    p = c1 / (c1 + c2)
    p1 = p * V  + (1 - p) * x * V - c1
    p2 = (1 - p) * V + p * x * V - c2
  }else{
    p1 =  V 
    p2 = x * V 
  }
  
  
  return(data.frame(p1, p2))
}


#profitFun(0.2, 0.2, V, x = 0.2)

# 令x = 0.2
input = data.frame(c1 = best.c1$x_0.2, c2= best.c2$x_0.2, alpha= alphas)

result = rowApply(input, function(params){
  Curry(profitFun, V=V, x=0.2)(params$c1, params$c2, params$alpha)
})

df = data.frame(x = alphas, result)

p02 = ggplotDF(df) + 
  geom_point() + ggtitle("Profit | x = 0.2") + 
  ylab("profit") + xlab("Alpha") + theme_bw()  + ylim(0, V * (1+0.2))

p02

# 令x = 0.8
input = data.frame(c1 = best.c1$x_0.8, c2= best.c2$x_0.8, alpha= alphas)

result = rowApply(input, function(params){
  Curry(profitFun, V=V, x=0.8)(params$c1, params$c2, params$alpha)
})

df = data.frame(x = alphas, result)

p08 = ggplotDF(df) + 
  geom_point() + ggtitle("Profit | x = 0.8") + 
  ylab("profit") + xlab("Alpha") + theme_bw() + ylim(0, 1)


multiplot2(p02, p08)

# 比较c1 / c2 , alpha

df = data.frame(x = alphas, div = best.c1$x_0.2/best.c2$x_0.2)

ggplotDF(df) + 
  geom_point() + ggtitle("Profit | x = 0.2") + 
  ylab("c1/c2") + xlab("Alpha") + theme_bw() + geom_abline(slope=1) + 
  ylim(0, 10) + xlim(0, 2)

# 主体的适应度依赖于资源的比例 ====
# 一个独立的个体，期望赢利应该是做在位者和做后来者概率的加权

# 令x = 0.2
input = data.frame(c1 = best.c1$x_0.2, c2= best.c2$x_0.2, alpha= alphas)

result = rowApply(input, function(params){
  Curry(profitFun, V=V, x=0.2)(params$c1, params$c2, params$alpha)
})

betas = seq(0.1, 0.9, by = 0.1)

profits = lapply(betas, function(b){
  profit = 0
  if (b <= 0.5){
    profit = result$p1 * b + result$p2 * b + (1-b) * V * 0.2
  }else{
    profit = (2 * b - 1) * V + result$p1 * (1-b) + result$p2 * (1-b)
  }
  
}) 

profits = as.data.frame(Reduce(cbind, profits))
names(profits) = paste0("b_", betas)


ggplotDF(profits, alphas) + 
  geom_point() + ggtitle("E(profit) vs alpha vs beta | x = 0.2") + 
  ylab("E(profit)") + xlab("Alpha") + theme_bw()  + ylim(0, V * (1+0.2))

# 任何时候，都是高alpha的利润高于低alpha的利润




