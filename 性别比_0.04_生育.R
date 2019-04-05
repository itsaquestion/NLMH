library(MyPlot)
library(MyUtils)
library(ggplot2)

run("setup")

run('marriage')

run('production_and_allocation')

run('oldage_support')

run('raising_children')


run('updateCounters') # ´ËÊ±Îª ticks==1

cmd.list = c('count turtles with [age = 0]', 'count turtles with [age = 1]', 'count turtles with [age = 2]')
run.list(cmd.list)


run('count turtles with [not old? and gender = "m" and not married? ]')

# ===============
run("setup")

# run("go-once")

run('ageing')

run('popCtrl')

run('marriage')

run('production_and_allocation')

run('oldage_support')

run('oldage_consumption_and_unity')




run('raising_children')





run('consumptionAndSaving')



library(MyPlot)
library(ggplot2)

library(FunPlot)
plotFunctions(CRRA2,
  params = list(theta = c(0, 1)), x = c(-0.5, 4), size = 0.6, end_space = 0.08, end_label = T) 

