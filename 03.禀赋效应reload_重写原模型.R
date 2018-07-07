# 禀赋效应reload 0.1.0 
# 重写原模型


# 测试 getFightResult ====

result = runTimes('(getFightResult 1 2)',2000)
expect_true(abs(result[,1] %>% mean() - (1/ 3)) < 0.02)
expect_true(abs(result[,2] %>% mean() - (2/ 3)) < 0.02)

# 测试 fight ====

run('fight turtle 1 turtle 2')
run()

# 测试匹配 ====
run("setup")
expect_equal(
  run('count turtles with [hasRes?] / (count turtles)'),run('p_res'))

run('[d_cost] of turtle 1')
#run('[a_cost] of turtle 1')

#run('[d_cost] of turtle 2')
run('[a_cost] of turtle 2')

p1 = 7/ (7 + 5);p1
p2 = 1 - p1;p2

pi1 = p1 * run("V") + (1-p1) * run("V0");pi1
pi2 = p2 * run("V") + (1-p2) * run("V0");pi2
