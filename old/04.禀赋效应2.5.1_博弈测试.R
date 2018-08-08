rm(list = setdiff(ls(), lsf.str()))
# 1. 手动setup ====

v = run("V");v
v0 = run("V0");v0

# 2. 找2个agent ====

p1 = run('[who] of one-of turtles with [hasRes? = true]');p1

p2 = run('[who] of one-of turtles with [hasRes? = false]');p2

#run('inspect turtle ' %+% p1)
#run('inspect turtle ' %+% p2)

a1 = run('[alpha] of turtle ' %+% p1);a1
b1 = run('[beta] of turtle ' %+% p1);b1

a2 = run('[alpha] of turtle ' %+% p2);a2
b2 = run('[beta] of turtle ' %+% p2);b2

# 3. 开始计算

A = a1 * v - b1 * v0;A
B = b2 * (v - v0);B

c1 = A^2 / (4 * B);c1
c2 = - (A * (A - 2 * B ) / (4 * B));c2



# 4. 设定  ====

# 关闭misjudgement
run("set misjudge-rate 0")
run("playOneOnOne turtle " %+% p1 %+% " " %+% "turtle " %+% p2)

run("[d_cost] of turtle " %+% p1)
run("[a_cost] of turtle " %+% p2)

# 直接套用公式

# 测试 c1
stopifnot((a1 * v - b1 * v0) ^ 2 / (4 * b2 * (v - v0)) == c1 )
stopifnot(c1 == run("[d_cost] of turtle " %+% p1))

# 测试c2
stopifnot(- (a1 * v - b1 * v0) * ((a1 * v - b1 * v0) - 2 * b2 * ( v - v0)) / (4 * b2 * (v - v0)) == c2)
if(c2 < 0){stopifnot(run("[a_cost] of turtle " %+% p2) == 0)}


# 5. 测试fight ====
# 打1000次 
res = lapply(1:1000, function(x){
  if(x %% 10 == 0){print(x)}
  rr = run("fight turtle " %+% p1 %+% " " %+% "turtle " %+% p2)
  stopifnot(rr[1] == run("[hasRes?] of turtle " %+% p1))
  stopifnot(rr[2] == run("[hasRes?] of turtle " %+% p2))
  rr
})

res2 = Reduce(rbind,res)
(res2[,1] %>% mean()) + (res2[,2] %>% mean())

res2[,1] %>% mean()
c22 = if(c2<0) 0 else c2
c1 / (c1 + c22)

# 6. 随机抽取agent，博弈N次
for(i in 1:100){
  if(i %% 10 == 0){print(i)}
  p1 = run('[who] of one-of turtles with [hasRes? = true]');p1
  
  p2 = run('[who] of one-of turtles with [hasRes? = false]');p2
  
  #run('inspect turtle ' %+% p1)
  #run('inspect turtle ' %+% p2)
  
  a1 = run('[alpha] of turtle ' %+% p1);a1
  b1 = run('[beta] of turtle ' %+% p1);b1
  
  a2 = run('[alpha] of turtle ' %+% p2);a2
  b2 = run('[beta] of turtle ' %+% p2);b2
  
  # 3. 开始计算
  
  A = a1 * v - b1 * v0;A
  B = b2 * (v - v0);B
  
  c1 = A^2 / (4 * B);c1
  c2 = - (A * (A - 2 * B ) / (4 * B));c2
  
  if(A < 0){
    stopifnot(run("playOneOnOne turtle " %+% p1 %+% " " %+% "turtle " %+% p2) == "d_retreats")
    print("d_retreats")
  }else{
    if(A > 2 * B){
      stopifnot(run("playOneOnOne turtle " %+% p1 %+% " " %+% "turtle " %+% p2) == "a_retreats")
      print("a_retreats")
    }else if(A < 2 * B){
      stopifnot(run("playOneOnOne turtle " %+% p1 %+% " " %+% "turtle " %+% p2) == "fight")
      print("fight!")
    } 
  }
}



