library(crayon)
# find the netlogo/app path under the base.path
# if there are more then 1 NetLogo dir, return the last one
getNlPath = function(base.path = "") {
  if (base.path == "") {
    if (Sys.info()["sysname"] == "Linux") {
      base.path = "/opt/"
    } else {
      base.path = "C:/Program Files/"
    }
  }

  tmp.files = list.files(base.path)
  nl.dir = tail(tmp.files[startsWith(tmp.files, "NetLogo")], 1)

  nl.path = paste0(base.path, "/", nl.dir, "/app")
  nl.path
}

# start NetLogo with GUI
startNLGui = function(nl.path) {

  files = list.files(nl.path)
  result = sapply(files,
                  function(x) {
                    startsWith(x, "netlogo-") &
                      endsWith(x, ".jar")
                  })
  nl.jarname = files[as.vector(result)]
  msg("Start NetLogo: ", nl.path)
  NLStart(nl.path, nl.jarname = nl.jarname)
}

exitNL = function() {
  msg("Quit")
  NLQuit()
}


# open the lastest model (according tothe modified time)
openLatestModel = function(model.dir) {
  model.files = list.files(model.dir)

  model.path = list.files(model.dir, full.names = T)
  model.path = model.path[sapply(model.path, function(x) strEndsWith(x, ".nlogo"))]

  model.mtime = file.info(model.path)$mtime

  target = model.path[which(model.mtime == max(model.mtime))]
  msg("Open model: ", target)
  NLLoadModel(target)

}

# 
msg = function(...) {
  cat(bold("NLMH >"), Reduce(paste0, list(...)), "\n")
}


