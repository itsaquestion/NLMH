
# run commands and functions ====
do = function(cmd) {
  NLCommand(cmd)
}

get = function(cmd) {
  return(NLReport(cmd))
}


run = function(x, ...) {
  UseMethod("run", x)
}

run.character = function(cmd, showCmd = T) {
  cmd = stringr::str_trim(cmd)
  if (showCmd) msg(cmd)
  tryCatch({

    result = get(cmd)

    result
    return(result)
  },
    error = function(cond) {

      if (startsWith(cond$message, "Expected reporter")) {

        do(cmd)
      } else {
        message(cond)

      }
      invisible(NA)
    },
    warning = function(cond) {
      message(cond)
      # Choose a return value in case of warning
      invisible(NA)
    },
    finally = {
    invisible(NA)
  }
  )
  invisible(NA)
}

run.list = function(cmd.list) {
  ret = lapply(cmd.list, function(x) {
    run.character(x)
  })
  data.frame(cmd = cmd.list, result = ret)
}


runTimes = function(cmd, times, printTime = F) {
  msg(cmd)
  time = system.time({
    cmd.list = as.list(rep(cmd, times))
    #result = as.data.frame(Reduce(rbind,run(cmd.list)))
    result =
        run("map [-> " %+% cmd %+% "] (list " %+% Reduce(paste, 1:times) %+% ")",
            F)
    result = as.data.frame(Reduce(rbind, result))
    colnames(result) = NULL
    rownames(result) = 1:times
    result
  }
  )
  if (printTime) print(time)
  result
}
