
diffSmallerThan = function(a,b,threshold = 0.01){
  abs(a / b - 1) < threshold
}

tmpHist = function(x,title = ""){
  gghist(x) + mytheme_none + ggtitle(title) + 
    theme(text=element_text(family="思源黑体CN")) + scale_color_aaas() +
    xlab("")
}

# check setupTrutles ====

# check init alpha & beta
run("setup")

alpha_0 = run("[alpha] of turtles")

stopifnot(
  diffSmallerThan(mean(alpha_0), ((run("max_alpha_beta") + 1)/2))
)

beta_0 = run("[beta] of turtles")
stopifnot(
  diffSmallerThan(mean(beta_0), ((run("max_alpha_beta") + 1)/2))
)


# check init a_cost & d_cost
a_cost_0 = run("[a_cost] of turtles")
stopifnot(all(a_cost_0 == 0))

d_cost_0 = run("[d_cost] of turtles")
stopifnot(all(d_cost_0 == 0))

# check setupRes ====

checkRes = function(){
  hasRes = run("[hasRes?] of turtles")
  stopifnot(
    diffSmallerThan(mean(hasRes*1), run("p_res"))
  )
}
checkRes()

# check go-once ====
# a simulation of 'go-onec" function
run("setup")

run("resetCounters")

# setup res
run("setupRes")
checkRes()

run("allPlayGame")
checkRes()

play_times = run("[play_times] of turtles")
summary(play_times)
tmpHist(run("[play_times] of turtles"),"playTimes")


# check allPlayGame
profit_0 = run("[profit] of turtles")
tmpHist(profit_0,"第一次博弈后，分配能量前的赢利分布")
summary(profit_0)
# 最小值去到-10以上，肯定是过渡透支了潜在赢利


# check profit
run("getProfit")
profit_1 = run("[profit] of turtles")
tmpHist(profit_1, "第一次博弈，按资源分配能量后，赢利的分布")
summary(profit_1)

# 可供提供的资源总数
# 理论值
run("init_pop * p_res * v + init_pop * (1 - p_res) * v0")
# 实际值
run("count(turtles with [hasRes?]) * v + count(turtles with [hasRes? = false]) * v0")
# 增加值
sum(profit_1) - sum(profit_0)
# 三者相等，没问题

alpha_1 =  run("[alpha] of turtles")
tmpHist(alpha_1,"第一次博弈后，alpha的分布")

beta_1 =  run("[beta] of turtles")
tmpHist(beta_1,"第一次博弈后，beta的分布")

a_cost_1 = run("[a_cost] of turtles with [played? = true]")
p_a_cost_1 = tmpHist(a_cost_1,"第一次博弈后，参与了博弈的agent的a_cost的分布")


d_cost_1 = run("[d_cost] of turtles with [played? = true]")
p_d_cost_1 = tmpHist(d_cost_1,"第一次博弈后，参与了博弈的agent的d_cost的分布")
multiplot(p_d_cost_1,p_a_cost_1)


# reproduction

run("reproduction")









